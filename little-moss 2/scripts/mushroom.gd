extends Area2D
## Ziplatan mantar.

@export var power := -435.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("bounce") and body.velocity.y >= 0.0:
		body.bounce(power)
		$Sprite2D.frame = 1
		await get_tree().create_timer(0.25).timeout
		$Sprite2D.frame = 0
