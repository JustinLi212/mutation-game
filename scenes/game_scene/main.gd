extends Node2D

@onready var grids: Node2D = $Grids

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.add_grid_and_player(5)
	await get_tree().create_timer(2.0, false).timeout
	for i in range(10):
		GameManager.add_grid_and_player(i)
