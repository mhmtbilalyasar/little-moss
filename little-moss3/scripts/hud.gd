extends CanvasLayer
## Canlar, yetenek gostergesi ve dash butonu.

func _ready() -> void:
	GameState.abilities_changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	$RightControls/Dash.visible = GameState.can_dash
	$Abilities.text = GameState.ability_text()


func set_hearts(count: int) -> void:
	var icons := $Hearts.get_children()
	for i in icons.size():
		icons[i].modulate = Color.WHITE if i < count else Color(1, 1, 1, 0.25)
