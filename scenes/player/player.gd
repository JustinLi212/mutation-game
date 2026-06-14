extends CharacterBody2D

const tile_size = Vector2(37, 37)

@export var player_number: int = 0

var tween_time: float = 0.05
var sprite_tween: Tween
var _can_move: bool = true
var _is_active: bool = true

@onready var sprite: Sprite2D = $Sprite2D


func _input(event: InputEvent) -> void:
	if not _can_move:
		return
	if event.is_action_pressed("left") and not $LeftRayCast.is_colliding():
		_move(Vector2(-1, 0))
	if event.is_action_pressed("right") and not $RightRayCast.is_colliding():
		_move(Vector2(1, 0))
	if event.is_action_pressed("up") and not $UpRayCast.is_colliding():
		_move(Vector2(0, -1))
	if event.is_action_pressed("down") and not $DownRayCast.is_colliding():
		_move(Vector2(0, 1))

func _move(dir: Vector2) -> void:
	global_position += dir * tile_size
	sprite.global_position -= dir * tile_size
	
	if sprite_tween:
		sprite_tween.kill()
	
	sprite_tween = create_tween().set_trans(Tween.TRANS_SINE)
	sprite_tween.tween_property(sprite, "global_position", global_position, tween_time)
	
	
