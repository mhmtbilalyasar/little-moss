extends CharacterBody2D
## Little Moss - oyuncu karakteri.
## Asagidaki sayilari Godot'ta sag paneldeki "Inspector" bolumunden de degistirebilirsin.

signal hearts_changed(hearts: int)

@export var max_hearts := 3
@export var speed := 138.0
@export var acceleration := 1350.0
@export var friction := 1650.0
@export var jump_velocity := -305.0
@export var gravity_rising := 920.0
@export var gravity_falling := 1280.0
@export var max_fall_speed := 340.0
@export var coyote_time := 0.11        # Kenardan ciktiktan sonra hala ziplayabilme suresi
@export var jump_buffer_time := 0.11   # Yere inmeden hemen once basilan zipla tusu hatirlanir

var hearts := 3
var respawn_pos := Vector2.ZERO
var invincible := 0.0
var _coyote := 0.0
var _buffer := 0.0
var _level_bottom := 99999.0
var _tween: Tween

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	hearts = max_hearts
	respawn_pos = global_position
	# Kamera, "Ground" katmaninda cizdigin alanin disina cikmaz.
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
	# Saga / sola hareket
	var dir := Input.get_axis("ui_left", "ui_right")
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * speed, acceleration * delta)
		sprite.flip_h = dir < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	# Yercekimi
	var gravity := gravity_rising if velocity.y < 0.0 else gravity_falling
	velocity.y = minf(velocity.y + gravity * delta, max_fall_speed)

	# Ziplama (coyote time + jump buffer + tusu erken birakinca kisa ziplama)
	var jump_pressed := Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")
	var jump_released := Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_up")
	_coyote = coyote_time if is_on_floor() else _coyote - delta
	_buffer = jump_buffer_time if jump_pressed else _buffer - delta
	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = jump_velocity
		_buffer = 0.0
		_coyote = 0.0
		_squash(Vector2(0.8, 1.2))
	if jump_released and velocity.y < 0.0:
		velocity.y *= 0.45

	var was_on_floor := is_on_floor()
	move_and_slide()
	if is_on_floor() and not was_on_floor:
		_squash(Vector2(1.25, 0.8))   # yere inince ezilme efekti
	_update_animation()

	# Hasar sonrasi yanip sonme
	invincible = maxf(0.0, invincible - delta)
	sprite.visible = invincible <= 0.0 or int(invincible * 16.0) % 2 == 0

	# Cukura dusme: can kaybetmeden son checkpoint'e don
	if global_position.y > _level_bottom + 48.0:
		respawn()


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
	camera.reset_smoothing()


func bounce(power: float) -> void:
	velocity.y = power
	_coyote = 0.0


func _update_animation() -> void:
	var anim := "idle"
	if invincible > 0.95:
		anim = "hurt"
	elif not is_on_floor():
		anim = "jump" if velocity.y < 0.0 else "fall"
	elif absf(velocity.x) > 20.0:
		anim = "run"
	if sprite.animation != anim:
		sprite.play(anim)


func _squash(amount: Vector2) -> void:
	if _tween:
		_tween.kill()
	sprite.scale = amount
	_tween = create_tween()
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.14)
