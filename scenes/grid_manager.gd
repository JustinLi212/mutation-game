extends Node2D


var current_grids: Array[int]
var current_players: Array[int]
var possible_squares: Array[Vector2i]


func _ready() -> void:
	GameManager.active_grids_changed.connect(update_grids)
	GameManager.active_players_changed.connect(update_players)
	for grid: Grid in get_children():
		grid.visible = false


func update_grids() -> void:
	for grid: Grid in get_children():
		if grid.grid_number in GameManager.active_grids:
			if grid.grid_number not in current_grids:
				make_grid_visible(grid)
		else:
			make_grid_invisible(grid)
			grid.player.can_move = false
	current_grids = GameManager.active_grids.duplicate()


func update_players() -> void:
	for grid: Grid in get_children():
		if grid.grid_number in GameManager.active_players:
			grid.player.can_move = true
		else:
			grid.player.can_move = false
	current_players = GameManager.active_players.duplicate()


func make_grid_visible(grid: Grid) -> void:
	grid.visible = true
	var tween := create_tween()
	tween.tween_property(grid, "modulate:a", 1.0, 0.5)


func make_grid_invisible(grid: Grid) -> void:
	var tween := create_tween()
	tween.tween_property(grid, "modulate:a", 0.0, 0.5)
	grid.visible = false
	
