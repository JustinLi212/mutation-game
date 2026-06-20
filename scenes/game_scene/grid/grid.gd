class_name Grid
extends Node2D

@warning_ignore("unused_signal")
signal gun_timer_changed(value: float)
signal gun_started(gun_color: Gunshot.GunColor)
signal gun_ended


@export var grid_number: int = 1

var is_active: bool = false
var shake_tween: Tween
var SHAKE_AMOUNT: float = 5.0
var SHAKE_TIME: float = 0.1

var chosen_cells = {
	"white": [],
	"red": [],
	"orange": [],
	"yellow": [],
	"green": [],
	"blue": [],
	"purple": [],
}


@onready var grid_body: AnimatableBody2D = $GridBody
@onready var player: Player = $GridBody/Player
@onready var grid_sprite: AnimatedSprite2D = $GridBody/GridSprite
@onready var grid_labels: Node2D = $GridBody/GridLabels
@onready var gun_progress_bars: Node2D = $GunProgressBars
@onready var gun_progress_bar: ProgressBar = $GunProgressBars/ProgressBar1
@onready var time_left_label: RichTextLabel = $GunProgressBars/TimeLeftLabel1


func _ready() -> void:
	player.grid_shaken.connect(_on_grid_shaken)
	gun_started.connect(_on_gun_started)
	gun_ended.connect(_on_gun_ended)
	gun_timer_changed.connect(_on_gun_timer_changed)
	for sprite: AnimatedSprite2D in grid_labels.get_children():
		sprite.animation = &"%d" % grid_number
		sprite.play()
	for child in gun_progress_bars.get_children():
		child.modulate.a = 0.0


func _process(_delta: float) -> void:
	grid_labels.modulate.a = grid_sprite.modulate.a


func _on_grid_shaken(dir: Vector2) -> void:
	# Don't shake if already shaking
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	shake_tween = create_tween()
	shake_tween.tween_property(grid_body, "position", dir * SHAKE_AMOUNT, SHAKE_TIME)
	shake_tween.tween_property(grid_body, "position", Vector2.ZERO, SHAKE_TIME)


func _on_animated_sprite_2d_frame_changed() -> void:
	grid_sprite.rotation_degrees = randi_range(0, 3) * 90


func _on_gun_started(gun_color: Gunshot.GunColor) -> void:
	gun_progress_bar.modulate = Gunshot.colors.get(gun_color)
	gun_progress_bar.modulate.a = 0.0
	var tween = create_tween().set_parallel()
	tween.tween_property(gun_progress_bar, "modulate:a", 1.0, 0.1)
	tween.tween_property(time_left_label, "modulate:a", 1.0, 0.1)


func _on_gun_ended() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(gun_progress_bar, "modulate:a", 0.0, 0.1)
	tween.tween_property(time_left_label, "modulate:a", 0.0, 0.1)


func _on_gun_timer_changed(time_left: float, wait_time: float) -> void:
	time_left_label.text = "%.2f" % time_left
	gun_progress_bar.value = (wait_time - time_left) / wait_time * 100.0
