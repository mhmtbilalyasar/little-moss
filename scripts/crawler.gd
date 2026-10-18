extends CharacterBody2D
## Tier 1 dusman: yavasca ileri geri yuruyen bocek.
## Ustune ziplayarak yenilir, yandan dokunursa 1 can gotürür.

@export var speed := 38.0

var dir := -1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var floor_check: RayCast2D = $FloorCheck
@onready var hitbox: Area2D = $Hitbox


func _physics_process(delta: float) -> void:
	velocity.y = minf(velocity.y + 1200.0 * delta, 300.0)
	velocity.x = dir * speed
	move_and_slide()
	# Duvara veya platform kenarina gelince don
	if is_on_wall() or (is_on_floor() and not floor_check.is_colliding()):
		dir = -dir
		sprite.flip_h = dir > 0.0
		floor_check.target_position.x = 10.0 * dir

	for body in hitbox.get_overlapping_bodies():
		if not body.has_method("hurt"):
			continue
		if body.velocity.y > 0.0 and body.global_position.y < global_position.y - 3.0:
			body.bounce(-295.0)
			queue_free()
			return
		body.hurt()
