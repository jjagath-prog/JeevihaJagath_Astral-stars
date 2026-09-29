extends Control

# Stores the level numbers used to identify which level was completed
const LEVEL_1: int = 1
const LEVEL_2: int = 2
const LEVEL_3: int = 3

# Sets how long the victory screen is displayed before returning to the Galaxy Map
const VICTORY_DISPLAY_TIME: float = 1.0

# Stores the Galaxy Map scene path
const GALAXY_MAP_SCENE: String = "res://Scenes/GalaxyMap.tscn"

# Loads the different victory screens for each level
const LEVEL_1_VICTORY = preload("res://Assets/texts/TV - 11 (9).png")
const LEVEL_2_VICTORY = preload("res://Assets/Backgrounds/en.png")
const LEVEL_3_VICTORY = preload("res://Assets/Backgrounds/Victorylevel 3 .png")


func _ready() -> void:
	# Checks which level was completed and displays the correct victory screen
	if GameProgress.last_completed_level == LEVEL_1:
		$TextureRect.texture = LEVEL_1_VICTORY
	elif GameProgress.last_completed_level == LEVEL_2:
		$TextureRect.texture = LEVEL_2_VICTORY
	elif GameProgress.last_completed_level == LEVEL_3:
		$TextureRect.texture = LEVEL_3_VICTORY

	# Displays the victory screen for a short time before continuing
	await get_tree().create_timer(VICTORY_DISPLAY_TIME).timeout

	# Uses the fade transition to return the player to the Galaxy Map
	TransitionScene.transition_to(GALAXY_MAP_SCENE)
