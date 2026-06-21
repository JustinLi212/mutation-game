extends Node

@export var gun_noises: Array[AudioStreamWAV]

const MAX_CHOOSE_ATTEMPTS = 50

var gun_functions: Array[Callable] = [
	red_attack,
	orange_attack,
	yellow_attack,
	green_attack,
	blue_attack,
]

@onready var grid_manager: GridManager = $"../GridManager"
@onready var pew_sfx_player: AudioStreamPlayer = $PewSFXPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.gun_fired.connect(_on_gun_fired)
	EventBus.music_looped.connect(pick_random_attack)
	
	await get_tree().physics_frame
	GameManager.add_grid_and_player(5)
	red_attack()
	await get_tree().create_timer(1.0, false).timeout
	for i in range(1, 10):
		GameManager.add_grid_and_player(i)
	await get_tree().create_timer(1.0, false).timeout


func red_attack() -> void:
	for grid_number in GameManager.active_grids.duplicate():
		var chosen_cells: Array = get_random_cells(grid_number, 4)
		grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.RED] = chosen_cells
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.RED, 7.5))
	
	
func orange_attack() -> void:
	for grid_number in get_random_grids(5):
		var chosen_cells: Array = get_random_cells(grid_number, 8)
		grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.ORANGE] = chosen_cells
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.ORANGE, 7.5))


func yellow_attack() -> void:
	for _attack in 4:
		for grid_number in get_random_grids(1):
			var chosen_cells: Array = get_random_cells(grid_number, 7)
			grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.YELLOW] = chosen_cells
			for cell: Vector2i in chosen_cells:
				grid_manager.add_gunshot(
					GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.YELLOW, 1.5))
		await get_tree().create_timer(2.0, false).timeout


func green_attack() -> void:
	var random_grids: Array = get_random_grids(5)
	for grid_number in random_grids:
		var chosen_cells: Array = get_random_cells(grid_number, 1)
		grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.GREEN] = chosen_cells
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.GREEN, 7.5))
	
	await get_tree().create_timer(7.5, false).timeout
	for grid_number in random_grids:
		for r in 3:
			for c in 3:
				if Vector2i(r, c) not in grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.GREEN]:
					grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), Vector2(r, c), Gunshot.GunColor.WHITE, 0.01))


func blue_attack() -> void:
	var random_grids: Array = get_random_grids(4)
	for grid_number in random_grids:
		var chosen_cells: Array = get_random_cells(grid_number, 3)
		var chosen_grid := grid_manager.get_grid(grid_number) as Grid
		var chosen_player = chosen_grid.player
		var tween = create_tween().set_loops(3)
		tween.tween_property(chosen_player, "modulate:a", 1.0, 0.15)
		tween.tween_property(chosen_player, "modulate:a", 0.0, 0.15)
		chosen_grid.chosen_cells[Gunshot.GunColor.BLUE] = chosen_cells
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.BLUE, 7.5))
	await get_tree().create_timer(6.5, false).timeout
	for grid_number in random_grids:
		var chosen_player := grid_manager.get_grid(grid_number).player as Player
		var tween = create_tween().set_loops(3)
		tween.tween_property(chosen_player, "modulate:a", 0.0, 0.15)
		tween.tween_property(chosen_player, "modulate:a", 1.0, 0.15)


func _on_gun_fired() -> void:
	pew_sfx_player.stream = gun_noises.pick_random()
	pew_sfx_player.play()


func pick_random_attack() -> void:
	gun_functions.pick_random().call()


func get_random_grids(count: int) -> Array:
	var grids: Array = GameManager.active_grids.duplicate()
	grids.shuffle()
	return grids.slice(0, count)


func get_random_cells(grid_number: int, count: int) -> Array:
	var added_cell_count: int = 0
	var all_cells: Array = []
	for cells: Array in grid_manager.get_grid(grid_number).chosen_cells.values():
		all_cells.append_array(cells)
	var chosen_cells = []
	for _attempt in MAX_CHOOSE_ATTEMPTS:
		var cell := Vector2i(randi_range(0, 2), randi_range(0, 2))
		if cell not in all_cells:
			chosen_cells.append(cell)
			all_cells.append(cell)
			added_cell_count += 1
		if added_cell_count >= count:
			break
	return chosen_cells
