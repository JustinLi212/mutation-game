extends Node

@onready var laser: Area2D = $"../Laser"
@onready var background_music_player: AudioStreamPlayer = $"../BackgroundMusicPlayer"

var random_events: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	GameManager.add_grid_and_player(5)
	await get_tree().create_timer(2.0, false).timeout
	laser.shoot()
	await get_tree().create_timer(2.0, false).timeout
	for i in range(10):
		GameManager.add_grid_and_player(i)
