extends Node

# Sets the first level and the highest level that can be unlocked
const FIRST_LEVEL: int = 1
const MAX_LEVEL: int = 3

# Stores the starting level scene
const LEVEL_1_SCENE: String = "res://Scenes/level1.tscn"

# Keeps track of the player's level progression
var highest_unlocked_level: int = FIRST_LEVEL
var current_level_scene: String = LEVEL_1_SCENE
var last_completed_level: int = FIRST_LEVEL
var last_played_level: int = FIRST_LEVEL

func complete_level(level_number: int) -> void:
	# Unlocks the next level after the player completes the current level
	# and prevents levels above the maximum level from being unlocked
	highest_unlocked_level = max(
		highest_unlocked_level,
		min(level_number + FIRST_LEVEL, MAX_LEVEL)
	)

func is_level_unlocked(level_number: int) -> bool:
	# Returns true if the selected level has been unlocked
	return level_number <= highest_unlocked_level
