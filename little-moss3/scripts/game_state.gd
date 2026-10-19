extends Node
## Kalici oyun durumu: yetenekler, ulasilan bolum, toplanan tohumlar. user://save.cfg dosyasina kaydedilir.

signal abilities_changed

const SAVE_PATH := "user://save.cfg"

var can_dash := false
var can_double_jump := false
var max_level := 1
var collected: Array = []


func _ready() -> void:
	_setup_input()
	load_game()


func _setup_input() -> void:
	if InputMap.has_action("dash"):
		return
	InputMap.add_action("dash")
	for key in [KEY_SHIFT, KEY_X, KEY_K]:
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event("dash", event)


func has_ability(ability: String) -> bool:
	return can_dash if ability == "dash" else can_double_jump


func unlock(ability: String) -> void:
	if ability == "dash":
		can_dash = true
	else:
		can_double_jump = true
	save_game()
	abilities_changed.emit()


func record_level(path: String) -> void:
	var number := path.get_file().get_basename().trim_prefix("level_").to_int()
	max_level = maxi(max_level, number)
	save_game()


func is_collected(key: String) -> bool:
	return collected.has(key)


func collect(key: String) -> void:
	if not collected.has(key):
		collected.append(key)
		save_game()


func ability_text() -> String:
	return "Dash: %s   Kanatlar: %s   Tohum: %d" % ["Açık" if can_dash else "Kapalı", "Açık" if can_double_jump else "Kapalı", collected.size()]


func reset() -> void:
	can_dash = false
	can_double_jump = false
	max_level = 1
	collected = []
	save_game()
	abilities_changed.emit()


func save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("abilities", "can_dash", can_dash)
	cfg.set_value("abilities", "can_double_jump", can_double_jump)
	cfg.set_value("progress", "max_level", max_level)
	cfg.set_value("progress", "collected", collected)
	cfg.save(SAVE_PATH)


func load_game() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	can_dash = cfg.get_value("abilities", "can_dash", false)
	can_double_jump = cfg.get_value("abilities", "can_double_jump", false)
	max_level = cfg.get_value("progress", "max_level", 1)
	collected = cfg.get_value("progress", "collected", [])
	abilities_changed.emit()
