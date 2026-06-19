extends Node

@onready var grid_manager: GridManager = $"../GridManager"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	GameManager.add_grid_and_player(5)
	await get_tree().create_timer(1.0, false).timeout
	for i in range(1, 10):
		GameManager.add_grid_and_player(i)
	await get_tree().create_timer(1.0, false).timeout
	for i in range(1, 10):
		for c in 3:
			grid_manager.add_gunshot(i, Vector2i(randi_range(0, 2), c))
