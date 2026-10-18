extends "res://scripts/enemy.gd"
## Tier 1 dusman: yavasca ileri geri yuruyen bocek.

@export var speed := 38.0

var dir := -1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var floor_check: RayCast2D = $FloorCheck


func _physics_process(delta: float) -> void:
	velocity.y = minf(velocity.y + 1200.0 * delta, 300.0)
	velocity.x = dir * speed
	move_and_slide()
	# Duvara veya platform kenarina gelince don
	if is_on_wall() or (is_on_floor() and not floor_check.is_colliding()):
		dir = -dir
		sprite.flip_h = dir > 0.0
		floor_check.target_position.x = 10.0 * dir
	check_contact()
