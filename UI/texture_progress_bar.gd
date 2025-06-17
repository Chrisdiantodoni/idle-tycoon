extends Control
class_name CookBar

signal on_cook_completed

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


func cook_item(time: float) -> void:
	var tween := create_tween()
	tween.tween_property(texture_progress_bar, "value", 1.0, time)
	tween.finished.connect(func(): on_cook_completed.emit())

func reset_bar() -> void:
	texture_progress_bar.value = 0
