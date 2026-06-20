extends Node

@export var gun_noises: Array[AudioStreamWAV]

const MAX_CHOOSE_ATTEMPTS = 50

var gun_functions: Array[Callable] = [
	red_attack,
	orange_attack,
]


@onready var background_music_player: AudioStreamPlayer = $"../BackgroundMusicPlayer"
@onready var grid_manager: GridManager = $"../GridManager"
@onready var pew_sfx_player: AudioStreamPlayer = $PewSFXPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.gun_fired.connect(_on_gun_fired)
	background_music_player.music_looped.connect(pick_random_attack)
	
	await get_tree().physics_frame
	GameManager.add_grid_and_player(5)
	red_attack()
	await get_tree().create_timer(1.0, false).timeout
	for i in range(1, 10):
		GameManager.add_grid_and_player(i)
	await get_tree().create_timer(1.0, false).timeout


func red_attack() -> void:
	for grid_number in range(1, 10):
		var added_cell_count: int = 0
		var chosen_cells: Array = grid_manager.get_grid(grid_number).chosen_cells.get("red")
		chosen_cells = []
		for _attempt in MAX_CHOOSE_ATTEMPTS:
			var cell := Vector2i(randi_range(0, 2), randi_range(0, 2))
			if cell not in chosen_cells:
				chosen_cells.append(cell)
				added_cell_count += 1
			if added_cell_count >= 3:
				break
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(Gunshot.GunColor.RED, 7.5, grid_number, cell)
	
	
func orange_attack() -> void:
	var grids: Array = range(1, 10)
	grids.shuffle()
	for grid_number in grids.slice(0, 4):	# first 3 grid numbers in shuffled grid list
		var added_cell_count: int = 0
		var chosen_cells: Array = grid_manager.get_grid(grid_number).chosen_cells.get("orange")
		chosen_cells = []
		for _attempt in MAX_CHOOSE_ATTEMPTS:
			var cell := Vector2i(randi_range(0, 2), randi_range(0, 2))
			if cell not in chosen_cells:
				chosen_cells.append(cell)
				added_cell_count += 1
			if added_cell_count >= 8:
				break
		for cell: Vector2i in chosen_cells:
			grid_manager.add_gunshot(Gunshot.GunColor.ORANGE, 7.5, grid_number, cell)


func _on_gun_fired() -> void:
	pew_sfx_player.stream = gun_noises.pick_random()
	pew_sfx_player.play()


func pick_random_attack() -> void:
	gun_functions.pick_random().call()
