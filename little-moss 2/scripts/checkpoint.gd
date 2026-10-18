extends Area2D
## Checkpoint cicegi: dokununca yanar ve oyuncu buradan yeniden baslar.

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("respawn"):
		body.respawn_pos = global_position
		$Sprite2D.frame = 1
