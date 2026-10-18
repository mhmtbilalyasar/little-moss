extends AnimatableBody2D
## Hareketli platform. "horizontal" kapaliysa yukari-asagi hareket eder.

@export var horizontal := true
@export var travel := 48.0     # Her yone gidecegi mesafe (piksel)
@export var speed := 46.0
@export var phase := 0.0

var _origin := Vector2.ZERO
var _time := 0.0


func _ready() -> void:
	_origin = position


func _physics_process(delta: float) -> void:
	_time += delta
	var offset := sin(_time * speed / travel + phase) * travel
	if horizontal:
		position = _origin + Vector2(offset, 0.0)
	else:
		position = _origin + Vector2(0.0, offset)
