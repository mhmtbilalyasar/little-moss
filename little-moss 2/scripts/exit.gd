extends Area2D
## Bolum cikisi. "next_level" bos birakilirsa ayni bolum yeniden baslar.

@export_file("*.tscn") var next_level := ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("hurt"):
		return
	if next_level == "":
		get_tree().reload_current_scene.call_deferred()
	else:
		get_tree().change_scene_to_file.call_deferred(next_level)
