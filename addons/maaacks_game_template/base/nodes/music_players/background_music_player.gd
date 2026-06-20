extends AudioStreamPlayer

var last_position: float = 0.0

var sync_stream: AudioStreamSynchronized
@onready var pause_player: AudioStreamPlayer = $"../PausePlayer"


func _ready() -> void:
	EventBus.pause_opened.connect(_on_game_paused)
	EventBus.pause_closed.connect(_on_game_unpaused)
	EventBus.music_looped.connect(_on_music_looped)
	sync_stream = stream as AudioStreamSynchronized


func _process(delta: float) -> void:
	if get_playback_position() < last_position:
		EventBus.music_looped.emit()
	last_position = get_playback_position()


func _on_game_paused() -> void:
	stream_paused = true
	if pause_player:
		pause_player.play()


func _on_game_unpaused() -> void:
	stream_paused = false
	if pause_player:
		pause_player.stop()


func _on_music_looped() -> void:
	sync_stream.set_sync_stream_volume(1, -60)
	sync_stream.set_sync_stream_volume(2, 0)
