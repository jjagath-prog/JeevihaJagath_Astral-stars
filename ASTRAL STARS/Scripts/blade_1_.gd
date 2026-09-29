extends Node2D

# Signal used to tell the battle system when the character has been defeated
signal defeated

# Sets the minimum health so it cannot go below 0
const MIN_HEALTH: int = 0

# Sets the character's health, attack damage and projectile properties
@export var max_health: int = 20000
@export var attack_damage: int = 300
@export var projectile_scene: PackedScene
@export var projectile_texture: Texture2D

# Gets the health bar and the point where the projectile will be shot from
@onready var health_bar: ProgressBar = get_node_or_null("HealthBar")
@onready var shoot_point: Marker2D = get_node_or_null("ShootPoint")

# Stores the current health and checks whether the character is defeated
var health: int
var is_defeated: bool = false



func attack(enemy: Node2D) -> void:
	# Stops the attack if the character is defeated or there is no valid enemy
	if is_defeated or not is_instance_valid(enemy):
		return

	# Checks that a projectile scene has been added
	if projectile_scene == null:
		push_warning("Assign Projectile.tscn in the Inspector.")
		return

	# Creates the projectile and adds it into the current battle scene
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)

	# Sets the projectile position, target, damage and texture
	projectile.global_position = shoot_point.global_position
	projectile.target = enemy
	projectile.damage = attack_damage
	projectile.get_node("Sprite2D").texture = projectile_texture


func take_damage(amount: int) -> void:
	# Stops the character from taking more damage after being defeated
	if is_defeated:
		return

	# Takes damage from the current health and updates the health bar
	health = max(health - amount, MIN_HEALTH)
	update_health_bar()

	# If health reaches 0, the character is defeated
	if health == MIN_HEALTH:
		is_defeated = true
		hide()
		defeated.emit()


func update_health_bar() -> void:
	# Updates the health bar to match the character's current health
	health_bar.max_value = max_health
	health_bar.value = health
