extends Node

signal active_grids_changed
signal active_players_changed

var active_grids: Array[int] = []
var active_players: Array[int] = []


func _input(event: InputEvent) -> void:
	for i in range(1, 10):
		if event.is_action_pressed(str(i)):
			toggle_player(i)


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
