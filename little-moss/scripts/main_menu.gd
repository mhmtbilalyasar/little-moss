extends Control
## Ana menu, bolum secimi (5 tema, 1. tema 20 bolum) ve ayarlar.

const SAVE_PATH := "user://settings.cfg"
const LEVELS_PER_THEME := 20


func _ready() -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	$Settings/Box/Music.value = cfg.get_value("audio", "music", 0.8)
	$Settings/Box/Sfx.value = cfg.get_value("audio", "sfx", 0.8)
	for i in range(1, LEVELS_PER_THEME + 1):
		var button := Button.new()
		button.text = str(i)
		button.custom_minimum_size = Vector2(64, 30)
		button.pressed.connect(_play_level.bind(i))
		$Levels/Box/Grid.add_child(button)
	$Menu/PlayButton.pressed.connect(_show.bind($Levels))
	$Menu/SettingsButton.pressed.connect(_show.bind($Settings))
	$Levels/Box/BackButton.pressed.connect(_show.bind($Menu))
	$Settings/Box/BackButton.pressed.connect(_close_settings)


func _show(target: Control) -> void:
	for panel in [$Menu, $Levels, $Settings]:
		panel.visible = panel == target


func _play_level(number: int) -> void:
	get_tree().change_scene_to_file("res://levels/level_%d.tscn" % number)


func _close_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", $Settings/Box/Music.value)
	cfg.set_value("audio", "sfx", $Settings/Box/Sfx.value)
	cfg.save(SAVE_PATH)
	_show($Menu)
