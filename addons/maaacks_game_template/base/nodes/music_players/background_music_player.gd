extends AudioStreamPlayer

var debounce = false:
	set(val):
		debounce = val
		if val == true:
			await get_tree().create_timer(6, false).timeout
			debounce = false


var color_streams: Dictionary = {
	Gunshot.GunColor.WHITE: [],
	Gunshot.GunColor.RED: [1, 2, 3],
	Gunshot.GunColor.ORANGE: [4, 5, 6],
	Gunshot.GunColor.YELLOW: [7, 8, 9],
	Gunshot.GunColor.GREEN: [10, 11, 12],
	Gunshot.GunColor.BLUE: [13, 14, 15],
	Gunshot.GunColor.PURPLE: [],
}

var current_color_indices: Dictionary = {}

var last_position: float = 0.0

var sync_stream: AudioStreamSynchronized
@onready var pause_player: AudioStreamPlayer = $"../PausePlayer"


func _ready() -> void:
	EventBus.pause_opened.connect(_on_game_paused)
	EventBus.pause_closed.connect(_on_game_unpaused)
	EventBus.color_started.connect(_on_color_started)
	GameManager.tutorial_shoot.connect(reset_music)
	GameManager.reset_music.connect(reset_music)
	sync_stream = stream as AudioStreamSynchronized


func _process(_delta: float) -> void:
	if not debounce and get_playback_position() < last_position:
		debounce = true
		EventBus.music_looped.emit()
	last_position = get_playback_position()


func reset_music() -> void:
	seek(0)


func _on_game_paused() -> void:
	stream_paused = true
	if pause_player:
		pause_player.play()


func _on_game_unpaused() -> void:
	stream_paused = false
	if pause_player:
		pause_player.stop()


func _on_color_started(color: Gunshot.GunColor) -> void:
	await get_tree().physics_frame
	var stream_list = color_streams[color]
	# Fallback to red music
	if stream_list.size() == 0:
		stream_list = color_streams[Gunshot.GunColor.RED]
	var idx: int = stream_list.pick_random()
	sync_stream.set_sync_stream_volume(idx, 0.0)
	current_color_indices[color] = idx
	await EventBus.music_looped
	sync_stream.set_sync_stream_volume(idx, -60.0)


func _on_color_ended(color: Gunshot.GunColor) -> void:
	return
	sync_stream.set_sync_stream_volume(current_color_indices[color], -60.0)
