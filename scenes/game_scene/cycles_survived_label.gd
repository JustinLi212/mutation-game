extends RichTextLabel


func _ready() -> void:
	GameManager.cycle_survived.connect(func():
		text = "Cycles Survived: %d" % GameManager.cycles_survived)
