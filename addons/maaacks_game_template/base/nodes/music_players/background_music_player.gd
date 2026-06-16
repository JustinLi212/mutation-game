extends AudioStreamPlayer

signal game_paused
signal game_unpaused
signal music_looped

@onready var music_timer: Timer = $MusicTimer

var stream_playback: AudioStreamPlaybackInteractive


func _ready() -> void:
	music_timer.start()
	music_timer.timeout.connect(music_looped.emit)
	music_timer.timeout.connect(_on_music_timeout)
	game_paused.connect(_on_game_paused)
	game_unpaused.connect(_on_game_unpaused)
	stream_playback = get_stream_playback() as AudioStreamPlaybackInteractive


func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		game_paused.emit()
	elif what == NOTIFICATION_UNPAUSED:
		game_unpaused.emit()


func _on_music_timeout() -> void:
	print("HI")


func _on_game_paused() -> void:
	print("HI")
	stream_playback.switch_to_clip_by_name(&"pause")
	music_timer.paused = true


func _on_game_unpaused() -> void:
	stream_playback.switch_to_clip_by_name(&"game")
	music_timer.paused = false
