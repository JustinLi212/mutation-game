class_name GridManager
extends Node2D

const GUNSHOT_SCENE = preload("uid://vsu14xfhjtqs")

var current_grids: Array[int]
var current_players: Array[int]


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
	current_grids = GameManager.active_grids.duplicate()


func update_players() -> void:
	for grid: Grid in get_children():
		grid.player.alive = (grid.grid_number in GameManager.active_grids)
		grid.player.can_move = (grid.grid_number in GameManager.active_players)
	current_players = GameManager.active_players.duplicate()


func make_grid_visible(grid: Grid) -> void:
	grid.visible = true
	var tween := create_tween()
	tween.tween_property(grid, "modulate:a", 1.0, 0.5)


func make_grid_invisible(grid: Grid) -> void:
	var tween := create_tween()
	tween.tween_property(grid, "modulate:a", 0.0, 0.5)
	grid.visible = false


func get_grid(grid_number: int) -> Grid:
	for grid: Grid in get_children():
		if grid.grid_number == grid_number:
			return grid
	return null


func add_invisible_gunshot(gunshot_info: GunshotInfo) -> void:
	var gunned_grid: Grid = gunshot_info.grid
	var gunshot: Gunshot = GUNSHOT_SCENE.instantiate()
	gunshot.position = (gunshot_info.cell + Vector2i(-1, -1)) * 37
	gunshot.gunshot_info = gunshot_info
	gunned_grid.add_child(gunshot)
	gunshot.visible_crosshair = false
	gunshot.shoot(gunshot_info.time_left)


func add_gunshot(gunshot_info: GunshotInfo) -> void:
	var gunned_grid: Grid = gunshot_info.grid
	var gunshot: Gunshot = GUNSHOT_SCENE.instantiate()
	gunshot.position = (gunshot_info.cell + Vector2i(-1, -1)) * 37
	gunshot.gunshot_info = gunshot_info
	gunned_grid.add_child(gunshot)
	gunshot.shoot(gunshot_info.time_left)


func add_impact(gunshot_info: GunshotInfo) -> void:
	var gunned_grid: Grid = gunshot_info.grid
	var gunshot: Gunshot = GUNSHOT_SCENE.instantiate()
	gunshot.position = (gunshot_info.cell + Vector2i(-1, -1)) * 37
	gunshot.gunshot_info = gunshot_info
	gunned_grid.add_child(gunshot)
	gunshot.impact()
