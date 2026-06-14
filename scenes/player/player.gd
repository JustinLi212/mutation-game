class_name Player
extends CharacterBody2D

signal grid_shaken(dir: Vector2)

const tile_size = Vector2(37, 37)

@export var player_number: int = 0

var tween_time: float = 0.05
var sprite_tween: Tween
var can_move: bool = false

@onready var sprite: Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	global_rotation_degrees = 0.0


func _input(event: InputEvent) -> void:
	if not can_move:
		return
	if event.is_action_pressed("left"):
		if not $LeftRayCast.is_colliding():
			_move(Vector2.LEFT)
		else:
			_shake_grid(Vector2.LEFT)
	if event.is_action_pressed("right"):
		if not $RightRayCast.is_colliding():
			_move(Vector2.RIGHT)
		else:
			_shake_grid(Vector2.RIGHT)
	if event.is_action_pressed("up"):
		if not $UpRayCast.is_colliding():
			_move(Vector2.UP)
		else:
			_shake_grid(Vector2.UP)
	if event.is_action_pressed("down"):
		if not $DownRayCast.is_colliding():
			_move(Vector2.DOWN)
		else:
			_shake_grid(Vector2.DOWN)

func _move(dir: Vector2) -> void:
	var move_amount: Vector2 = dir * tile_size
	global_position += move_amount
	sprite.global_position = global_position - move_amount
	
	if sprite_tween:
		sprite_tween.kill()
	
	sprite_tween = create_tween().set_trans(Tween.TRANS_SINE)
	sprite_tween.tween_property(sprite, "position", move_amount, tween_time).as_relative()


func _shake_grid(dir: Vector2) -> void:
	grid_shaken.emit(dir)
