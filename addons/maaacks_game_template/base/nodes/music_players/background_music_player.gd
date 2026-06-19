extends AudioStreamPlayer

@onready var pause_player: AudioStreamPlayer = $"../PausePlayer"


func _ready() -> void:
	EventBus.pause_opened.connect(_on_game_paused)
	EventBus.pause_closed.connect(_on_game_unpaused)


func _on_game_paused() -> void:
	stream_paused = true
	if pause_player:
		pause_player.play()


func _on_game_unpaused() -> void:
	stream_paused = false
	if pause_player:
		pause_player.stop()
