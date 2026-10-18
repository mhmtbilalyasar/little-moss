extends Control
## Ana menu: Oyna ve Ayarlar. Ses ayarlari user://settings.cfg dosyasina kaydedilir.

const SAVE_PATH := "user://settings.cfg"


func _ready() -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	$Settings/Box/Music.value = cfg.get_value("audio", "music", 0.8)
	$Settings/Box/Sfx.value = cfg.get_value("audio", "sfx", 0.8)
	$Menu/PlayButton.pressed.connect(_on_play)
	$Menu/SettingsButton.pressed.connect(_on_settings)
	$Settings/Box/BackButton.pressed.connect(_on_back)


func _on_play() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_settings() -> void:
	$Menu.hide()
	$Settings.show()


func _on_back() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", $Settings/Box/Music.value)
	cfg.set_value("audio", "sfx", $Settings/Box/Sfx.value)
	cfg.save(SAVE_PATH)
	$Settings.hide()
	$Menu.show()
