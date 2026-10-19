extends "res://scripts/enemy.gd"
## Yosun Cadisi: oyuncuyu gorunce yuzunu doner ve her 1.8 saniyede bir zehirli kure firlatir.
## Ustune ziplayarak yenilir.

const SPIT := preload("res://scenes/witch_spit.tscn")

@export var detect_range := 220.0
@export var fire_interval := 1.8
@export var spit_speed := 120.0

var _timer := 1.0
var _facing := -1.0

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	sprite.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	velocity.y = minf(velocity.y + 1200.0 * delta, 300.0)
	velocity.x = 0.0
	move_and_slide()
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player and global_position.distance_to(player.global_position) < detect_range:
		_facing = -1.0 if player.global_position.x < global_position.x else 1.0
		sprite.flip_h = _facing > 0.0
		_timer -= delta
		if _timer <= 0.0:
			_timer = fire_interval
			_fire(player)
	check_contact()


func _fire(player: Node2D) -> void:
	sprite.play("attack")
	await get_tree().create_timer(0.3).timeout
	if not is_inside_tree() or not is_instance_valid(player):
		return
	var spit := SPIT.instantiate()
	get_parent().add_child(spit)
	spit.global_position = global_position + Vector2(16.0 * _facing, -9.0)
	spit.velocity = (player.global_position - spit.global_position).normalized() * spit_speed


func _on_animation_finished() -> void:
	sprite.play("idle")
