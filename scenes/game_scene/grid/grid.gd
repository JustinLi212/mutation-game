class_name Grid
extends Node2D

@warning_ignore("unused_signal")
signal gun_timer_changed(value: float)
signal gun_started(gunshot_info: GunshotInfo)
signal gun_ended(gunshot_info: GunshotInfo)
signal grid_position_changed

@export var grid_number: int = 1

var is_active: bool = false
var shake_tween: Tween
var SHAKE_AMOUNT: float = 5.0
var SHAKE_TIME: float = 0.1

var chosen_cells = {
	Gunshot.GunColor.WHITE: [],
	Gunshot.GunColor.RED: [],
	Gunshot.GunColor.ORANGE: [],
	Gunshot.GunColor.YELLOW: [],
	Gunshot.GunColor.GREEN: [],
	Gunshot.GunColor.BLUE: [],
	Gunshot.GunColor.PURPLE: [],
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
	grid_position_changed.connect(_on_grid_position_changed)
	GameManager.active_grids_changed.connect(_on_active_grids_changed)
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


func _on_gun_started(gunshot_info: GunshotInfo) -> void:
	gun_progress_bar.modulate = Gunshot.colors.get(gunshot_info.color)
	gun_progress_bar.modulate.a = 0.0
	var tween = create_tween().set_parallel()
	tween.tween_property(gun_progress_bar, "modulate:a", 1.0, 0.1)
	tween.tween_property(time_left_label, "modulate:a", 1.0, 0.1)


func _on_gun_ended(_gunshot_info: GunshotInfo) -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(gun_progress_bar, "modulate:a", 0.0, 0.1)
	tween.tween_property(time_left_label, "modulate:a", 0.0, 0.1)


func _on_gun_timer_changed(time_left: float, wait_time: float) -> void:
	time_left_label.text = "%.1f" % (time_left / Engine.time_scale)
	gun_progress_bar.value = (wait_time - time_left) / wait_time * 100.0


func _on_active_grids_changed() -> void:
	is_active = (grid_number in GameManager.active_grids)


func _on_grid_position_changed() -> void:
	if not is_active:
		return
	var sprite_tween = create_tween().set_loops(3)
	sprite_tween.tween_property(grid_sprite, "modulate:a", 0.0, 0.2)
	sprite_tween.tween_property(grid_sprite, "modulate:a", 1.0, 0.2)
	#for sprite: AnimatedSprite2D in grid_labels.get_children():
		#sprite.animation = &"%d" % grid_number
		#sprite.play()
		#sprite.modulate = Gunshot.colors[Gunshot.GunColor.PURPLE]
		#var tween = create_tween().set_loops(3)
		#tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
		#tween.tween_property(sprite, "modulate:a", 1.0, 0.2)
	#await get_tree().create_timer(1.2, false).timeout
	#for sprite: AnimatedSprite2D in grid_labels.get_children():
		#sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
