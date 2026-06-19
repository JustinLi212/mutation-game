class_name Grid
extends AnimatableBody2D

@export var grid_number: int = 1

var is_active: bool = false
var shake_tween: Tween
var SHAKE_AMOUNT: float = 5.0
var SHAKE_TIME: float = 0.1
var base_pos: Vector2

@onready var player: Player = $Player
@onready var grid_sprite: AnimatedSprite2D = $GridSprite
@onready var grid_labels: Node2D = $GridLabels


func _ready() -> void:
	player.grid_shaken.connect(_on_grid_shaken)
	for sprite: AnimatedSprite2D in grid_labels.get_children():
		sprite.animation = &"%d" % grid_number
		sprite.play()
	base_pos = global_position


func _process(_delta: float) -> void:
	grid_labels.modulate.a = grid_sprite.modulate.a


func _on_grid_shaken(dir: Vector2) -> void:
	# Don't shake if already shaking
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	shake_tween = create_tween()
	shake_tween.tween_property(self, "global_position", base_pos + dir * SHAKE_AMOUNT, SHAKE_TIME)
	shake_tween.tween_property(self, "global_position", base_pos, SHAKE_TIME)


func _on_animated_sprite_2d_frame_changed() -> void:
	grid_sprite.rotation_degrees = randi_range(0, 3) * 90
