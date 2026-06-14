extends AnimatableBody2D

@export var grid_number: int = 1

var is_active: bool = false

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	rich_text_label.text = str(grid_number)
	
