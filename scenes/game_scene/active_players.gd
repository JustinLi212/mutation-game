extends GridContainer


func _ready() -> void:
	GameManager.active_players_changed.connect(update_players)
	for container: TextureRect in get_children():
		container.get_node("Pivot/XSprite").modulate.a = 0.0


func update_players() -> void:
	for container: TextureRect in get_children():
		if int(container.name) in GameManager.active_players:
			container.get_node("NumberSprite").modulate.a = 1.0
		else:
			container.get_node("NumberSprite").modulate.a = 0.2
		if int(container.name) in GameManager.active_grids:
			container.get_node("Pivot/XSprite").modulate.a = 0.0
		else:
			container.get_node("Pivot/XSprite").modulate.a = 1.0


## Hard coded to the 7's X sprite to get the frame rate
func _on_x_sprite_frame_changed() -> void:
	for container: TextureRect in get_children():
		container.get_node("Pivot/XSprite").rotation_degrees = randi_range(0, 3) * 90
		container.get_node("Pivot/XSprite").rotation_degrees += randf_range(-2, 2)
