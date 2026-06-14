class_name Grid
extends AnimatableBody2D

@export var grid_number: int = 1

var is_active: bool = false
var shake_tween: Tween
var SHAKE_AMOUNT: float = 5.0
var base_pos: Vector2

@onready var labels: Node2D = $GridLabels
@onready var player: Player = $Player

func _ready() -> void:
	player.grid_shaken.connect(_on_grid_shaken)
	for label in labels.get_children():
		label.text = "%d" % grid_number
		if grid_number == 6 or grid_number == 9:
			label.text = "[u]%d[/u]" % grid_number
	base_pos = global_position


func _on_grid_shaken(dir: Vector2) -> void:
	# Don't shake if already shaking
	if shake_tween and shake_tween.is_running():
		return
	shake_tween = create_tween()
	shake_tween.tween_property(self, "global_position", dir * SHAKE_AMOUNT, 0.1).as_relative()
	shake_tween.tween_property(self, "global_position", base_pos, 0.1)
