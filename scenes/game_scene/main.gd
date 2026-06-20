extends Node2D


@onready var pause_queued_label: RichTextLabel = $UI/PauseQueuedLabel


func _ready() -> void:
	EventBus.pause_queued.connect(_on_pause_queued)
	EventBus.music_looped.connect(_on_music_looped)
	pause_queued_label.visible = false
	GameManager.reset_state()


func _on_pause_queued() -> void:
	pause_queued_label.visible = true


func _on_music_looped() -> void:
	pause_queued_label.visible = false
