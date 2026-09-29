extends Control

# Stores the scene path for the Level 3 battle
const LEVEL_3_SCENE: String = "res://Scenes/level3.tscn"

func _on_retry_button_pressed() -> void:
	# Restarts Level 3 when the player presses the retry button
	get_tree().change_scene_to_file(LEVEL_3_SCENE)
