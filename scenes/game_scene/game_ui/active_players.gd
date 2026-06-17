extends GridContainer


func _ready() -> void:
	GameManager.active_players_changed.connect(update_players)


func update_players() -> void:
	for container: TextureRect in get_children():
		if int(container.name) in GameManager.active_players:
			container.modulate.a = 1.0
		else:
			container.modulate.a = 0.2
