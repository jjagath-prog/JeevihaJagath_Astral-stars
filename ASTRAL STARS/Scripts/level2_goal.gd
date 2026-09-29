extends Control

# Stores the scene path for the Level 2 battle
const LEVEL_2_SCENE: String = "res://Scenes/level2.tscn"

# Boolean used to prevent the battle from starting more than once
var is_starting = false

func _input(event: InputEvent) -> void:
	# Stops any more input once the battle has started
	if is_starting:
		return

	# Starts the battle when the player left-clicks the mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_battle()

	# Starts the battle when the player presses Enter
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			start_battle()

func start_battle() -> void:
	# Changes the Boolean to prevent the transition from being triggered twice
	is_starting = true

	# Uses the transition system to move into the Level 2 battle
	TransitionScene.transition_to(LEVEL_2_SCENE)
