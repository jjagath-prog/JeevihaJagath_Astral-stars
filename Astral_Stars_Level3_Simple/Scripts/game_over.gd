extends Control

# Stores the level numbers used to identify which level the player lost
const LEVEL_1: int = 1
const LEVEL_2: int = 2
const LEVEL_3: int = 3

# Loads the different retry screens for each level
const LEVEL_1_RETRY = preload("res://Assets/texts/TV - 11 (8).png")
const LEVEL_2_RETRY = preload("res://Assets/Backgrounds/TV - 11 (14).png")
const LEVEL_3_RETRY = preload("res://Assets/Backgrounds/Level 3 defeat.png")

func _ready() -> void:
	# Checks the last level played and displays the correct defeat screen
	if GameProgress.last_played_level == LEVEL_1:
		$TextureRect.texture = LEVEL_1_RETRY
	elif GameProgress.last_played_level == LEVEL_2:
		$TextureRect.texture = LEVEL_2_RETRY
	elif GameProgress.last_played_level == LEVEL_3:
		$TextureRect.texture = LEVEL_3_RETRY

func _on_retry_button_pressed() -> void:
	# Returns the player to the level they were playing when Retry is pressed
	TransitionScene.transition_to(GameProgress.current_level_scene)
