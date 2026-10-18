extends Area2D
## Cadinin zehirli kuresi: oyuncuya carparsa 1 can goturur, duvara/zemine carparsa yok olur.

var velocity := Vector2.ZERO
var _life := 5.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += velocity * delta
	_life -= delta
	if _life <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt()
	queue_free()
