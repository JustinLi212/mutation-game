extends Area2D


const FADE_IN_TIME = 0.1
const FADE_OUT_TIME = 0.1
var charge_duration = 2.0


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
@onready var time_left: RichTextLabel = $TextureProgressBar/TimeLeft


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.pause_closed.connect(_on_unpaused)
	EventBus.pause_opened.connect(_on_paused)
	collision_shape_2d.set_deferred("disabled", true)
	sprite.modulate.a = 0.0
	texture_progress_bar.modulate.a = 0.0
	timer.wait_time = charge_duration


func _process(_delta: float) -> void:
	time_left.text = "%.2f" % timer.time_left


func shoot(time: float) -> void:
	timer.wait_time = time
	# Show the laser charge
	var tween := create_tween().set_parallel()
	tween.tween_property(sprite, "modulate:a", 0.3, FADE_IN_TIME)
	tween.tween_property(texture_progress_bar, "modulate:a", 1.0, FADE_IN_TIME)
	tween.tween_property(texture_progress_bar, "value", 100.0, timer.wait_time)
	
	# Start timer
	timer.start()
	await timer.timeout
	
	# Show the laser shooting, enable collision
	tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, .25)
	collision_shape_2d.set_deferred("disabled", false)
	sprite.animation = &"shoot"
	await get_tree().create_timer(0.25, false).timeout
	
	# Disable collision, fade out
	collision_shape_2d.set_deferred("disabled", true)
	tween = create_tween().set_parallel()
	tween.tween_property(sprite, "modulate:a", 0.0, FADE_OUT_TIME)
	tween.tween_property(texture_progress_bar, "modulate:a", 0.0, FADE_OUT_TIME)
	await tween.finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	print("Player %d hit!" % body.get_parent().grid_number)


func _on_paused() -> void:
	texture_progress_bar.texture_under.speed_scale = 0.0
	texture_progress_bar.texture_progress.speed_scale = 0.0


func _on_unpaused() -> void:
	texture_progress_bar.texture_under.speed_scale = 1.0
	texture_progress_bar.texture_progress.speed_scale = 1.0
