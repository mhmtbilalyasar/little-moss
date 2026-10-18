extends CharacterBody2D
## Ortak dusman kodu: ustune basinca yenilir, yandan dokunursa 1 can goturur.

func check_contact() -> void:
	for body in $Hitbox.get_overlapping_bodies():
		if not body.has_method("hurt"):
			continue
		if body.velocity.y > 0.0 and body.global_position.y < global_position.y - 3.0:
			body.bounce(-295.0)
			queue_free()
			return
		body.hurt()
