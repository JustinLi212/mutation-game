class_name Gunshot
extends Area2D

const FADE_IN_TIME = 0.1
const FADE_OUT_TIME = 0.1

enum GunColor {
	WHITE,			## Starter. Spawns one gunshot per grid.
	RED,			## Triple threat. Gets the full 8 seconds.
	ORANGE,			## Six shooter. Only spawns in four grids.
	YELLOW,			
	GREEN,
	BLUE,
	PURPLE,
}

static var colors: Dictionary[GunColor, Color] = {
	GunColor.WHITE: Color(1.0, 1.0, 1.0, 1.0),
	GunColor.RED: Color(1.0, 0.0, 0.0, 1.0),
	GunColor.ORANGE: Color(1.0, 0.501, 0.12, 1.0),
	GunColor.YELLOW: Color(1.0, 1.0, 0.0, 1.0),
	GunColor.GREEN: Color(0.0, 0.764, 0.0, 1.0),
	GunColor.BLUE: Color(0.218, 0.439, 1.0, 1.0),
	GunColor.PURPLE: Color(0.781, 0.502, 1.0, 1.0),
}

var gunshot_info: GunshotInfo

@onready var grid: Grid = $".."
@onready var sprite: AnimatedSprite2D = $GunSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#EventBus.pause_closed.connect(_on_unpaused)
	#EventBus.pause_opened.connect(_on_paused)
	collision_shape_2d.set_deferred("disabled", true)
	sprite.modulate = colors[gunshot_info.color]
	sprite.modulate.a = 0.0


func _process(_delta: float) -> void:
	grid.gun_timer_changed.emit(timer.time_left, timer.wait_time)


func shoot(time: float) -> void:
	timer.wait_time = time
	grid.gun_started.emit(gunshot_info)
	
	if gunshot_info.color == GunColor.GREEN:
		sprite.animation = &"heart"
		z_index = -100
	
	# Show the gun crosshair
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, FADE_IN_TIME)
	
	if gunshot_info.color != GunColor.GREEN:
		var rotate_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		rotate_tween.tween_property(sprite, "rotation_degrees", -90.0, 0.5).as_relative()
	
	# Start timer
	timer.start()
	await timer.timeout
	
	if gunshot_info.color != GunColor.GREEN:
		impact()
		return
	else:
		tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, FADE_OUT_TIME)
	
	cleanup()


## Gun impact, enable collision
func impact() -> void:
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	EventBus.gun_fired.emit()
	collision_shape_2d.set_deferred("disabled", false)
	sprite.animation = &"impact"
	
	# Disable collision after two frames
	await get_tree().physics_frame
	await get_tree().physics_frame
	collision_shape_2d.set_deferred("disabled", true)
	
	# Stay visible for 0.25 seconds
	await get_tree().create_timer(0.25, false).timeout
	
	cleanup()


func cleanup() -> void:
	# Fade out
	var tween = create_tween().set_parallel()
	tween.tween_property(sprite, "modulate:a", 0.0, FADE_OUT_TIME)
	grid.gun_ended.emit(gunshot_info)
	
	# Remove this gunshot from the grid's chosen cell storage
	var chosen: Array = grid.chosen_cells[gunshot_info.color]
	var idx = chosen.find(gunshot_info.cell)
	if idx != -1:
		chosen.remove_at(idx)
	
	await tween.finished
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	GameManager.remove_grid(body.get_node("../..").grid_number)
	GameManager.active_players_changed.emit()
	#print("Player %d hit!" % body.get_node("../..").grid_number)


#func _on_paused() -> void:
	#gun_progress_bar.texture_under.speed_scale = 0.0
	#gun_progress_bar.texture_progress.speed_scale = 0.0
#
#
#func _on_unpaused() -> void:
	#gun_progress_bar.texture_under.speed_scale = 1.0
	#gun_progress_bar.texture_progress.speed_scale = 1.0
