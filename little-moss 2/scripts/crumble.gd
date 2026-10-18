extends StaticBody2D
## Cokan platform: ustunde durunca titrer, sonra duser, bir sure sonra geri gelir.

@export var stand_time := 0.45
@export var respawn_time := 3.0

var _shaking := false
var _broken := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	$Trigger.body_entered.connect(_on_body_entered)


func _process(_delta: float) -> void:
	sprite.position.x = randf_range(-1.0, 1.0) if _shaking else 0.0


func _on_body_entered(body: Node2D) -> void:
	if _shaking or _broken or not body.has_method("hurt"):
		return
	_shaking = true
	await get_tree().create_timer(stand_time).timeout
	_shaking = false
	_broken = true
	sprite.visible = false
	shape.set_deferred("disabled", true)
	await get_tree().create_timer(respawn_time).timeout
	sprite.visible = true
	shape.set_deferred("disabled", false)
	_broken = false
