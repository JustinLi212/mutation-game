extends AudioStreamPlayer

signal music_looped

var last_playback_pos: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_playback_position() < last_playback_pos:
		music_looped.emit()
	last_playback_pos = get_playback_position()
