extends Node

@export var gun_noises: Array[AudioStreamWAV]

const MAX_CHOOSE_ATTEMPTS = 50

var gun_functions: Array[Callable] = [
	red_attack,
	orange_attack,
	yellow_attack,
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
	for grid_number in range(1, 10):
		var chosen_cells = get_random_cells(grid_number, 4)
		grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.RED] = chosen_cells
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.RED, 7.5))
	
	
func orange_attack() -> void:
	for grid_number in get_random_grids(5):
		var chosen_cells = get_random_cells(grid_number, 8)
		grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.ORANGE] = chosen_cells
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(
				GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.ORANGE, 7.5))


func yellow_attack() -> void:
	for _attack in 4:
		for grid_number in get_random_grids(1):
			var chosen_cells = get_random_cells(grid_number, 8)
			grid_manager.get_grid(grid_number).chosen_cells[Gunshot.GunColor.YELLOW] = chosen_cells
			for cell: Vector2i in chosen_cells:
				grid_manager.add_gunshot(
					GunshotInfo.new(grid_manager.get_grid(grid_number), cell, Gunshot.GunColor.YELLOW, 1.5))
		await get_tree().create_timer(2.0, false).timeout


func _on_gun_fired() -> void:
	pew_sfx_player.stream = gun_noises.pick_random()
	pew_sfx_player.play()


func pick_random_attack() -> void:
	gun_functions.pick_random().call()


func get_random_grids(count: int) -> Array:
	var grids: Array = range(1, 10)
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
