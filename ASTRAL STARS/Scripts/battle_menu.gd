extends CanvasLayer

# Stores the Galaxy Map scene path so it can be used when returning to the map
const GALAXY_MAP_SCENE: String = "res://Scenes/GalaxyMap.tscn"

# Gets the pause, quit and blur UI nodes
@onready var pause_button = $pause
@onready var quit_button = $quit
@onready var blur = $blur

# Gets the pause and quit menu panels
@onready var pause_panel = $"pause panel"
@onready var quit_panel = $"quit panel"


func _ready() -> void:
	# Allows the pause menu to still work while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Hides the menu panels when the scene first starts
	blur.hide()
	pause_panel.hide()
	quit_panel.hide()

	# Connects the pause and quit buttons to their functions
	pause_button.pressed.connect(open_pause)
	quit_button.pressed.connect(open_quit)

	# Connects each pause menu button to the correct action
	$"pause panel/VBoxContainer/resume".pressed.connect(resume_game)
	$"pause panel/VBoxContainer/restart".pressed.connect(restart_game)
	$"pause panel/VBoxContainer/Map".pressed.connect(return_to_map)

	# Connects the yes and no buttons on the quit confirmation menu
	$"quit panel/VBoxContainer/yes".pressed.connect(return_to_map)
	$"quit panel/VBoxContainer/no".pressed.connect(resume_game)


func open_pause() -> void:
	# Shows the blur and pause menu, then pauses the game
	blur.show()
	pause_panel.show()
	quit_panel.hide()

	pause_button.hide()
	quit_button.hide()

	get_tree().paused = true


func open_quit() -> void:
	# Opens the quit confirmation menu instead of immediately leaving
	blur.show()
	pause_panel.hide()
	quit_panel.show()

	pause_button.hide()
	quit_button.hide()

	get_tree().paused = true


func resume_game() -> void:
	# Unpauses the game and closes any open menu
	get_tree().paused = false

	blur.hide()
	pause_panel.hide()
	quit_panel.hide()

	pause_button.show()
	quit_button.show()


func restart_game() -> void:
	# Unpauses and reloads the current level from the beginning
	get_tree().paused = false
	get_tree().reload_current_scene()


func return_to_map() -> void:
	# Unpauses the game and uses the fade transition to return to the Galaxy Map
	get_tree().paused = false
	TransitionScene.transition_to(GALAXY_MAP_SCENE)
