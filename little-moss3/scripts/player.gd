extends CharacterBody2D
## Little Moss - oyuncu: yurume, ziplama, Dash (Shift / X / K) ve cift ziplama (Ruh Kanatlari).
## Sayilari Inspector'dan degistirebilirsin.

signal hearts_changed(hearts: int)

const FRAMES_EMERALD := preload("res://art/player_frames.tres")
const FRAMES_CYAN := preload("res://art/player_frames_cyan.tres")
const WINGS := preload("res://art/wings_effect.png")
const RING := preload("res://art/shadow_ring.png")

@export var max_hearts := 3
@export var speed := 138.0
@export var acceleration := 1350.0
@export var friction := 1650.0
@export var jump_velocity := -305.0
@export var gravity_rising := 920.0
@export var gravity_falling := 1280.0
@export var max_fall_speed := 340.0
@export var coyote_time := 0.11
@export var jump_buffer_time := 0.11
@export var dash_speed := 280.0
@export var dash_time := 0.18

var hearts := 3
var respawn_pos := Vector2.ZERO
var invincible := 0.0
var _coyote := 0.0
var _buffer := 0.0
var _level_bottom := 99999.0
var _tween: Tween
var _dash_charged := true
var _dashing := 0.0
var _dash_dir := 1.0
var _air_jump_used := false
var _double_anim := 0.0
var _trail := 0.0
var _ghost_timer := 0.0
var _cyan := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	hearts = max_hearts
	respawn_pos = global_position
	var ground := get_parent().get_node_or_null("Ground") as TileMapLayer
	if ground:
		var area := ground.get_used_rect()
		var tile := ground.tile_set.tile_size
		camera.limit_left = area.position.x * tile.x
		camera.limit_top = area.position.y * tile.y
		camera.limit_right = area.end.x * tile.x
		camera.limit_bottom = area.end.y * tile.y
		_level_bottom = float(camera.limit_bottom)
	call_deferred("emit_signal", "hearts_changed", hearts)


func _physics_process(delta: float) -> void:
	if is_on_floor():
		_air_jump_used = false
		if not _dash_charged:
			_dash_charged = true
			_set_cyan(false)
			sprite.modulate = Color(2.4, 2.4, 2.4)
			create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.2)

	if GameState.can_dash and _dash_charged and _dashing <= 0.0 and Input.is_action_just_pressed("dash"):
		_start_dash()

	if _dashing > 0.0:
		_dashing -= delta
		velocity = Vector2(_dash_dir * dash_speed, 0.0)
		if _dashing <= 0.0:
			velocity.x = _dash_dir * speed
	else:
		_move(delta)

	var was_on_floor := is_on_floor()
	move_and_slide()
	if is_on_floor() and not was_on_floor and _dashing <= 0.0:
		_squash(Vector2(1.25, 0.8))
	_tick(delta)


func _move(delta: float) -> void:
	var dir := Input.get_axis("ui_left", "ui_right")
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * speed, acceleration * delta)
		sprite.flip_h = dir < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	var gravity := gravity_rising if velocity.y < 0.0 else gravity_falling
	velocity.y = minf(velocity.y + gravity * delta, max_fall_speed)

	var jump_pressed := Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")
	var jump_released := Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_up")
	_coyote = coyote_time if is_on_floor() else _coyote - delta
	_buffer = jump_buffer_time if jump_pressed else _buffer - delta
	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = jump_velocity
		_buffer = 0.0
		_coyote = 0.0
		_trail = 0.2
		_squash(Vector2(0.8, 1.2))
	elif jump_pressed and not is_on_floor() and _coyote <= 0.0 and GameState.can_double_jump and not _air_jump_used:
		_air_jump_used = true
		velocity.y = jump_velocity * 0.95
		_buffer = 0.0
		_double_anim = 0.35
		_trail = 0.2
		_spawn_wings()
	if jump_released and velocity.y < 0.0:
		velocity.y *= 0.45


func _tick(delta: float) -> void:
	invincible = maxf(0.0, invincible - delta)
	sprite.visible = invincible <= 0.0 or int(invincible * 16.0) % 2 == 0
	_double_anim = maxf(0.0, _double_anim - delta)
	if _trail > 0.0:
		_trail -= delta
		_ghost_timer -= delta
		if _ghost_timer <= 0.0:
			_ghost_timer = 0.05
			_spawn_ghost()
	_update_animation()
	if global_position.y > _level_bottom + 48.0:
		respawn()


func _start_dash() -> void:
	var dir := Input.get_axis("ui_left", "ui_right")
	_dash_dir = dir if dir != 0.0 else (-1.0 if sprite.flip_h else 1.0)
	sprite.flip_h = _dash_dir < 0.0
	_dashing = dash_time
	_dash_charged = false
	_trail = dash_time + 0.1
	velocity.y = 0.0
	_set_cyan(true)


func hurt(back_to_checkpoint := false) -> void:
	if invincible > 0.0:
		return
	hearts -= 1
	invincible = 1.25
	if hearts <= 0:
		hearts = max_hearts
		back_to_checkpoint = true
	hearts_changed.emit(hearts)
	if back_to_checkpoint:
		respawn()
	else:
		velocity = Vector2(135.0 if sprite.flip_h else -135.0, -215.0)


func respawn() -> void:
	global_position = respawn_pos
	velocity = Vector2.ZERO
	_dashing = 0.0
	_dash_charged = true
	_set_cyan(false)
	camera.reset_smoothing()


func bounce(power: float) -> void:
	velocity.y = power
	_coyote = 0.0
	_air_jump_used = false


func _update_animation() -> void:
	var anim := "idle"
	if _dashing > 0.0:
		anim = "dash"
	elif invincible > 0.95:
		anim = "hurt"
	elif not is_on_floor():
		if _double_anim > 0.0:
			anim = "double_jump"
		else:
			anim = "jump" if velocity.y < 0.0 else "fall"
	elif absf(velocity.x) > speed * 0.75:
		anim = "run"
	elif absf(velocity.x) > 20.0:
		anim = "walk"
	if sprite.animation != anim:
		sprite.play(anim)


func _set_cyan(on: bool) -> void:
	if on == _cyan:
		return
	_cyan = on
	var anim := sprite.animation
	var frame := sprite.frame
	sprite.sprite_frames = FRAMES_CYAN if on else FRAMES_EMERALD
	sprite.play(anim)
	sprite.frame = frame


func _squash(amount: Vector2) -> void:
	if _tween:
		_tween.kill()
	sprite.scale = amount
	_tween = create_tween()
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.14)


func _spawn_ghost() -> void:
	var ghost := Sprite2D.new()
	ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h
	ghost.modulate = Color(0.45, 0.9, 1.0, 0.55)
	ghost.z_index = -1
	get_parent().add_child(ghost)
	ghost.global_position = global_position
	var tw := ghost.create_tween()
	tw.tween_property(ghost, "modulate:a", 0.0, 0.25)
	tw.tween_callback(ghost.queue_free)


func _spawn_wings() -> void:
	for side in [-1.0, 1.0]:
		var wing := Sprite2D.new()
		wing.texture = WINGS
		wing.centered = false
		wing.flip_h = side > 0.0
		wing.offset = Vector2(0.0 if side > 0.0 else -24.0, -14.0)
		wing.scale = Vector2(0.4, 0.4)
		get_parent().add_child(wing)
		wing.global_position = global_position + Vector2(side * 3.0, -2.0)
		var tw := wing.create_tween().set_parallel(true)
		tw.tween_property(wing, "scale", Vector2(1.1, 1.1), 0.25)
		tw.tween_property(wing, "modulate:a", 0.0, 0.25)
		tw.chain().tween_callback(wing.queue_free)
	var ring := Sprite2D.new()
	ring.texture = RING
	ring.modulate = Color(1, 1, 1, 0.8)
	get_parent().add_child(ring)
	ring.global_position = global_position + Vector2(0.0, 8.0)
	var rt := ring.create_tween().set_parallel(true)
	rt.tween_property(ring, "scale", Vector2(1.7, 1.7), 0.3)
	rt.tween_property(ring, "modulate:a", 0.0, 0.3)
	rt.chain().tween_callback(ring.queue_free)
	var burst := CPUParticles2D.new()
	burst.one_shot = true
	burst.amount = 12
	burst.lifetime = 0.5
	burst.explosiveness = 1.0
	burst.initial_velocity_min = 20.0
	burst.initial_velocity_max = 55.0
	burst.gravity = Vector2.ZERO
	burst.scale_amount_min = 1.0
	burst.scale_amount_max = 2.0
	burst.color = Color(0.6, 1.0, 0.85, 0.9)
	get_parent().add_child(burst)
	burst.global_position = global_position
	burst.emitting = true
	get_tree().create_timer(0.8).timeout.connect(burst.queue_free)
