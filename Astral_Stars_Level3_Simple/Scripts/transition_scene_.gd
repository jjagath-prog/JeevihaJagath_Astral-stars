extends CanvasLayer

# Sets the transparency values and speed used for the fade transition
const HIDDEN_ALPHA: float = 0.0
const VISIBLE_ALPHA: float = 1.0
const FADE_TIME: float = 0.15
const COLOR_ALPHA_PROPERTY: String = "color:a"

# Error message displayed if the requested scene cannot be opened
const SCENE_ERROR_TEXT: String = "Could not open scene: "

# Gets the ColorRect used to create the fade effect
@onready var color_rect: ColorRect = $ColorRect

# Boolean used to prevent multiple transitions happening at the same time
var is_transitioning := false

func _ready() -> void:
	# Makes the transition overlay invisible when the game starts
	color_rect.color.a = HIDDEN_ALPHA
	color_rect.visible = false

func transition_to(scene_path: String) -> void:
	# Stops another transition from starting while one is already running
	if is_transitioning:
		return
	
	is_transitioning = true
	color_rect.visible = true
	
	# Creates a tween that fades the screen to black
	var tween = create_tween()
	tween.tween_property(color_rect, COLOR_ALPHA_PROPERTY, VISIBLE_ALPHA, FADE_TIME)
	await tween.finished
	
	# Changes to the requested scene after the fade has finished
	var error = get_tree().change_scene_to_file(scene_path)
	
	# Checks if the scene could not be opened and resets the transition
	if error != OK:
		push_error(SCENE_ERROR_TEXT + scene_path)
		color_rect.color.a = HIDDEN_ALPHA
		color_rect.visible = false
		is_transitioning = false
		return
	
	# Waits for the new scene to load before fading back in
	await get_tree().process_frame
	
	# Creates another tween to remove the black overlay
	tween = create_tween()
	tween.tween_property(color_rect, COLOR_ALPHA_PROPERTY, HIDDEN_ALPHA, FADE_TIME)
	await tween.finished
	
	# Hides the overlay and allows another transition to happen
	color_rect.visible = false
	is_transitioning = false
