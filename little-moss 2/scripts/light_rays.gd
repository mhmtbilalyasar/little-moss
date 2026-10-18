extends TextureRect
## Gunes isiklari: yavasca parlayip soner. Sayilari Inspector'dan degistirebilirsin.

@export var speed := 0.6
@export var phase := 0.0
@export var strength := 0.85

var _time := 0.0


func _process(delta: float) -> void:
	_time += delta
	modulate.a = strength * (0.65 + 0.35 * sin(_time * speed + phase))
