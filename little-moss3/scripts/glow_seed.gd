extends Area2D
## Parlayan tohum. Toplanan tohumlar kaydedilir, bolume tekrar girince geri gelmez.

var _key := ""


func _ready() -> void:
	var root: Node = owner if owner else get_tree().current_scene
	_key = "%s:%s" % [root.scene_file_path, name]
	if GameState.is_collected(_key):
		queue_free()
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		GameState.collect(_key)
		queue_free()
