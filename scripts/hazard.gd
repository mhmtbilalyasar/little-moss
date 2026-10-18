extends Area2D
## Diken: dokunan oyuncu 1 can kaybeder ve son checkpoint'e doner.

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(true)
