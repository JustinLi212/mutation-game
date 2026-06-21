extends Node

signal active_grids_changed
signal active_players_changed

var active_grids: Array[int] = []
var active_players: Array[int] = []

var high_score: int = 0
var cycles_survived: int = 0


func _ready() -> void:
	EventBus.music_looped.connect(_on_music_looped)


func _process(_delta: float) -> void:
	for num in range(1, 10):
		if Input.is_action_pressed(str(num)):
			if num not in active_players:
				toggle_player(num)
		elif num in active_players:
			toggle_player(num)


# Old toggle based input, might add as an option
#func _input(event: InputEvent) -> void:
	#for i in range(1, 10):
		#if event.is_action_pressed(str(i)):
			#toggle_player(i)


func add_grid_and_player(number: int) -> void:
	add_grid(number)
	add_player(number)


func remove_grid_and_player(number: int) -> void:
	remove_grid(number)
	remove_player(number)


func toggle_grid(grid_number: int) -> void:
	if grid_number in active_grids:
		remove_grid(grid_number)
	else:
		add_grid(grid_number)


func toggle_player(grid_number: int) -> void:
	if grid_number in active_players:
		remove_player(grid_number)
	else:
		add_player(grid_number)


func add_grid(grid_number: int) -> void:
	if not _check_number(grid_number):
		return
	if grid_number in active_grids:
		return
	active_grids.push_back(grid_number)
	active_grids_changed.emit()


func add_player(grid_number: int) -> void:
	if not _check_number(grid_number):
		return
	if grid_number in active_players or grid_number not in active_grids:
		return
	active_players.push_back(grid_number)
	active_players_changed.emit()


func remove_grid(grid_number: int) -> void:
	if not _check_number(grid_number):
		return
	var grid_index = active_grids.find(grid_number)
	if grid_index == -1:
		return
	active_grids.remove_at(grid_index)
	active_grids_changed.emit()
	Engine.time_scale = 1.0 + (9 - active_grids.size()) / 9.0
	if active_grids == []:
		WinLoseManager.game_won()
		Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = Engine.time_scale
	var pitch_shift := AudioServer.get_bus_effect(0, 0) as AudioEffectPitchShift
	pitch_shift.pitch_scale = 1.0 / AudioServer.playback_speed_scale


func remove_player(grid_number: int) -> void:
	if not _check_number(grid_number):
		return
	var player_index = active_players.find(grid_number)
	if player_index == -1:
		return
	active_players.remove_at(player_index)
	active_players_changed.emit()


func _check_number(n: int) -> bool:
	return 0 < n and n < 10

func _on_music_looped() -> void:
	cycles_survived += 1
	high_score = max(cycles_survived, high_score)
	# Randomize last active grid
	if active_grids.size() == 1:
		active_grids = [randi_range(1, 9)]
		active_grids_changed.emit()

func reset_state() -> void:
	active_grids = []
	active_players = []
	cycles_survived = 0
	active_grids_changed.emit()
	active_players_changed.emit()
	reset_time()


func reset_time() -> void:
	Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = 1.0
	AudioServer.get_bus_effect(0, 0).pitch_scale = 1.0
