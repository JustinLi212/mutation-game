extends GridContainer


func _ready() -> void:
	GameManager.active_players_changed.connect(update_players)


func update_players() -> void:
	for label: RichTextLabel in get_children():
		if int(label.text) in GameManager.active_players:
			label.modulate.a = 1.0
		else:
			label.modulate.a = 0.2
