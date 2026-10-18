extends CanvasLayer
## Ekrandaki canlar. Player "hearts_changed" gonderince calisir.

func set_hearts(count: int) -> void:
	var icons := $Hearts.get_children()
	for i in icons.size():
		icons[i].modulate = Color.WHITE if i < count else Color(1, 1, 1, 0.25)
