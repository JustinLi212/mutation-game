class_name GunshotInfo
extends Resource

var grid: Grid
var cell: Vector2i
var color: Gunshot.GunColor
var time_left: float


func _init(p_grid: Grid, p_cell: Vector2i, p_color: Gunshot.GunColor, p_time_left: float) -> void:
	grid = p_grid
	cell = p_cell
	color = p_color
	time_left = p_time_left
