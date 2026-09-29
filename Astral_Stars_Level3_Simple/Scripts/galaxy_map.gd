extends Control

# Sets the total number of levels and the level numbers used in the Galaxy Map
const TOTAL_LEVELS: int = 4
const FIRST_LEVEL_NUMBER: int = 1
const LEVEL_1: int = 1
const LEVEL_2: int = 2
const LEVEL_3: int = 3
const LEVEL_4: int = 4

# Text displayed on the level buttons depending on whether they are unlocked
const LEVEL_TEXT: String = "LEVEL "
const LOCKED_TEXT: String = "LOCKED"
const SCENE_NOT_FOUND_TEXT: String = "Scene not found: "

# Stores the scene paths for each level
const LEVEL_1_START: String = "res://Scenes/level1start screen.tscn"
const LEVEL_2_START: String = "res://Scenes/level 2 start .tscn"
const LEVEL_3_START: String = "res://Scenes/level 3 start .tscn"
const LEVEL_4_SCENE: String = "res://Scenes/level4.tscn"

# Stores all four level buttons in an array
@onready var level_buttons: Array[Button] = [
	$Level1Button,
	$Level2Button,
	$Level3Button,
	$Level4Button
]

# Allows Ctrl + L to open Level 1
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_L and event.ctrl_pressed:
			get_tree().change_scene_to_file(LEVEL_1_START)

func _ready() -> void:
	# Updates the buttons to show which levels are unlocked or locked
	update_level_buttons()

	# Connects each level button to its correct level number
	for i in range(TOTAL_LEVELS):
		var level_number := i + FIRST_LEVEL_NUMBER
		level_buttons[i].pressed.connect(open_level.bind(level_number))

func update_level_buttons() -> void:
	# Loops through all four levels and checks if each one has been unlocked
	for i in range(TOTAL_LEVELS):
		var level_number := i + FIRST_LEVEL_NUMBER
		var unlocked = GameProgress.is_level_unlocked(level_number)

		# Disables the button if the player has not unlocked the level
		level_buttons[i].disabled = not unlocked

		# Shows the level number when unlocked, otherwise displays LOCKED
		if unlocked:
			level_buttons[i].text = LEVEL_TEXT + str(level_number)
		else:
			level_buttons[i].text = LOCKED_TEXT

func open_level(level_number: int) -> void:
	# Prevents the player from opening a level that is still locked
	if not GameProgress.is_level_unlocked(level_number):
		return

	# Finds the correct scene depending on which level button was selected
	var level_path := ""
	match level_number:
		LEVEL_1:
			level_path = LEVEL_1_START
		LEVEL_2:
			level_path = LEVEL_2_START
		LEVEL_3:
			level_path = LEVEL_3_START
		LEVEL_4:
			level_path = LEVEL_4_SCENE

	# Checks the level scene exists before changing to it
	if ResourceLoader.exists(level_path):
		TransitionScene.transition_to(level_path)
	else:
		push_error(SCENE_NOT_FOUND_TEXT + level_path)
