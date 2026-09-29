extends Control

# Stores the scene path for the main story scene
const MAIN_SCENE: String = "res://Scenes/main scene.tscn"

# Boolean used to prevent the scene from changing more than once
var is_changing_scene := false

func _input(event: InputEvent) -> void:
	# Allows the player to continue by pressing Ctrl+S
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.ctrl_pressed and event.keycode == KEY_S:
				go_to_main_scene()

	# Allows the player to continue by left-clicking anywhere on the screen
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				go_to_main_scene()


func go_to_main_scene() -> void:
	# Prevents the transition from being activated multiple times
	if is_changing_scene:
		return

	# Changes the Boolean once the scene transition has started
	is_changing_scene = true

	# Uses the fade transition to move to the main story scene
	TransitionScene.transition_to(MAIN_SCENE)
