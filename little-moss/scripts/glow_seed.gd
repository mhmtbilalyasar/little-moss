extends Area2D
## Parlayan tohum (toplanabilir).

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		queue_free()
