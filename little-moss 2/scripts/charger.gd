extends "res://scripts/enemy.gd"
## Tier 2 dusman: oyuncuyu gorunce titrer (uyari), sonra duz bir cizgide ustune kosar.
## Duvara veya kenara carpinca sersemler.

@export var detect_range := 135.0
@export var windup_time := 0.52
@export var rush_speed := 195.0
@export var stun_time := 1.15

enum State { IDLE, WINDUP, ATTACK, STUNNED }

var state := State.IDLE
var timer := 0.0
var dir := -1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var floor_check: RayCast2D = $FloorCheck


func _physics_process(delta: float) -> void:
	velocity.y = minf(velocity.y + 1200.0 * delta, 300.0)
	velocity.x = 0.0
	match state:
		State.IDLE:
			var player := get_tree().get_first_node_in_group("player") as Node2D
			if player:
				var dx := player.global_position.x - global_position.x
				var dy := absf(player.global_position.y - global_position.y)
				if absf(dx) < detect_range and dy < 28.0:
					_face(signf(dx))
					state = State.WINDUP
					timer = windup_time
		State.WINDUP:
			timer -= delta
			sprite.position.x = randf_range(-1.0, 1.0)      # titreme = uyari
			sprite.modulate = Color(1.6, 0.8, 0.8)
			if timer <= 0.0:
				sprite.position.x = 0.0
				sprite.modulate = Color.WHITE
				state = State.ATTACK
		State.ATTACK:
			velocity.x = dir * rush_speed
		State.STUNNED:
			timer -= delta
			if timer <= 0.0:
				state = State.IDLE

	move_and_slide()

	if state == State.ATTACK and (is_on_wall() or (is_on_floor() and not floor_check.is_colliding())):
		state = State.STUNNED
		timer = stun_time
	check_contact()


func _face(new_dir: float) -> void:
	if new_dir != 0.0:
		dir = new_dir
	sprite.flip_h = dir > 0.0
	floor_check.target_position.x = 10.0 * dir
