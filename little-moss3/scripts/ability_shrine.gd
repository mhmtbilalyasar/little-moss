extends Area2D
## Yetenek tapinagi: dokununca yetenegi kalici olarak acar ve bir pankart gosterir.

@export_enum("dash", "double_jump") var ability := "dash"
@export_multiline var message := ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$Sprite2D.frame = 1 if GameState.has_ability(ability) else 0


func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("hurt") or GameState.has_ability(ability):
		return
	GameState.unlock(ability)
	$Sprite2D.frame = 1
	var layer := CanvasLayer.new()
	layer.layer = 20
	var panel := PanelContainer.new()
	panel.theme = preload("res://ui/theme.tres")
	var label := Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(330, 0)
	panel.add_child(label)
	layer.add_child(panel)
	get_tree().current_scene.add_child(layer)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_MINSIZE, 24)
	var tw := create_tween()
	tw.tween_interval(5.0)
	tw.tween_property(panel, "modulate:a", 0.0, 0.8)
	tw.tween_callback(layer.queue_free)
