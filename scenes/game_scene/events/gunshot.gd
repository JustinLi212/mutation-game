class_name Gunshot
extends Area2D

@export var gun_noises: Array[AudioStreamWAV]

const FADE_IN_TIME = 0.1
const FADE_OUT_TIME = 0.1

@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var grid: Grid = $".."
@onready var sprite: AnimatedSprite2D = $GunSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#EventBus.pause_closed.connect(_on_unpaused)
	#EventBus.pause_opened.connect(_on_paused)
	collision_shape_2d.set_deferred("disabled", true)
	sprite.modulate.a = 0.0


func _process(_delta: float) -> void:
	grid.gun_timer_changed.emit(timer.time_left, timer.wait_time)


func shoot(time: float) -> void:
	timer.wait_time = time
	grid.gun_started.emit()
	# Show the gun crosshair
	sprite.modulate = Color(1.0, 0.0, 0.0, 0.0)
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, FADE_IN_TIME)
	
	# Start timer
	timer.start()
	await timer.timeout
	
	# Gun impact, enable collision
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	collision_shape_2d.set_deferred("disabled", false)
	sprite.animation = &"impact"
	
	sfx_player.stream = gun_noises.pick_random()
	sfx_player.play()
	
	await get_tree().create_timer(0.25, false).timeout
	
	# Disable collision, fade out
	collision_shape_2d.set_deferred("disabled", true)
	tween = create_tween().set_parallel()
	tween.tween_property(sprite, "modulate:a", 0.0, FADE_OUT_TIME)
	grid.gun_ended.emit()
	
	await tween.finished
	await sfx_player.finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	print("Player %d hit!" % body.get_node("../..").grid_number)


#func _on_paused() -> void:
	#gun_progress_bar.texture_under.speed_scale = 0.0
	#gun_progress_bar.texture_progress.speed_scale = 0.0
#
#
#func _on_unpaused() -> void:
	#gun_progress_bar.texture_under.speed_scale = 1.0
	#gun_progress_bar.texture_progress.speed_scale = 1.0
