extends Node2D

const HIT_DISTANCE: float = 15.0
const TAKE_DAMAGE_METHOD: String = "take_damage"

@export var speed: float = 600.0
var target: Node2D
var damage: int = 300

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
	var direction = global_position.direction_to(target.global_position)
	global_position += direction * speed * delta
	if global_position.distance_to(target.global_position) <= HIT_DISTANCE:
		if target.has_method(TAKE_DAMAGE_METHOD):
			target.take_damage(damage)
		queue_free()
