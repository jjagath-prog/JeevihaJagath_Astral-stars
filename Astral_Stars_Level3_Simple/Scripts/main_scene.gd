extends Control

# Stores the animation name and Galaxy Map scene path
const METEOR_ANIMATION: String = "meteor"
const GALAXY_MAP_SCENE: String = "res://Scenes/GalaxyMap.tscn"

# Loads the dialogue used after the meteor animation
const STORY = preload("res://Dialogue/main_dialogue.dialogue")

# Booleans used to control when the player can change scenes
var is_changing_scene := false
var dialogue_finished := false

# Gets the AnimationPlayer used for the meteor animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# Plays the meteor animation first and waits until it is finished
	animation_player.play(METEOR_ANIMATION)
	await animation_player.animation_finished

	# Shows the story dialogue after the meteor animation
	DialogueManager.show_dialogue_balloon(STORY, "start")
	await DialogueManager.dialogue_ended
	
	# Allows the player to continue after the dialogue has finished
	dialogue_finished = true


func _input(event: InputEvent) -> void:
	# Prevents the player from leaving before the dialogue has finished
	if not dialogue_finished:
		return

	# Allows Ctrl+S to open the Galaxy Map
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.ctrl_pressed and event.keycode == KEY_S:
				go_to_galaxy_map()

	# Allows right-click to open the Galaxy Map
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				go_to_galaxy_map()


func go_to_galaxy_map() -> void:
	# Prevents the scene transition from being activated more than once
	if is_changing_scene:
		return

	# Changes the Boolean and uses the fade transition to open the Galaxy Map
	is_changing_scene = true
	TransitionScene.transition_to(GALAXY_MAP_SCENE)
