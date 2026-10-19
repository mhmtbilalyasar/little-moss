extends Area2D
## Bolum cikisi. level_N -> level_(N+1). "next_level" bos ise ana menuye doner.

@export_file("*.tscn") var next_level := ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("hurt"):
		return
	if next_level == "":
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
	else:
		GameState.record_level(next_level)
		get_tree().change_scene_to_file.call_deferred(next_level)
