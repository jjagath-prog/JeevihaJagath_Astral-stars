extends Control

# Stores the scene path for the Level 3 battle
const LEVEL_3_SCENE: String = "res://Scenes/level3.tscn"

# Boolean used to prevent the battle from starting more than once
var is_starting = false

func _input(event: InputEvent) -> void:
	# Stops further input once the battle has started
	if is_starting:
		return

	# Starts Level 3 when the player left-clicks the mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_battle()

	# Starts Level 3 when the player presses Enter
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			start_battle()

func start_battle() -> void:
	# Changes the Boolean so the transition cannot be triggered multiple times
	is_starting = true

	# Uses the transition system to move to the Level 3 battle
	TransitionScene.transition_to(LEVEL_3_SCENE)
