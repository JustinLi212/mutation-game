extends Node

@export var gun_noises: Array[AudioStreamWAV]

@onready var background_music_player: AudioStreamPlayer = $"../BackgroundMusicPlayer"
@onready var grid_manager: GridManager = $"../GridManager"
@onready var pew_sfx_player: AudioStreamPlayer = $PewSFXPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.gun_fired.connect(_on_gun_fired)
	background_music_player.music_looped.connect(red_attack)
	
	await get_tree().physics_frame
	GameManager.add_grid_and_player(5)
	await get_tree().create_timer(1.0, false).timeout
	for i in range(1, 10):
		GameManager.add_grid_and_player(i)
	await get_tree().create_timer(1.0, false).timeout
	for i in range(1, 10):
		for c in 3:
			grid_manager.add_gunshot(5.5, i, Vector2i(randi_range(0, 2), c))
	await get_tree().create_timer(6.0, false).timeout
	


func red_attack() -> void:
	await get_tree().create_timer(2.0, false).timeout
	for i in range(1, 10):
		for c in 3:
			grid_manager.add_gunshot(5.5, i, Vector2i(randi_range(0, 2), c))

func _on_gun_fired() -> void:
	pew_sfx_player.stream = gun_noises.pick_random()
	pew_sfx_player.play()
