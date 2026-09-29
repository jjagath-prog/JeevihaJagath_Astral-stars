extends Control

# Constants used for the player's attack, health limits, attack timing and scene changes
const PLAYER_ATTACK_DAMAGE: int = 100
const MIN_HEALTH: int = 0
const ENEMY_ATTACK_TIME: float = 2.0
const BULLET_TARGET_OFFSET: int = 20
const BULLET_TRAVEL_TIME: float = 0.6
const ENEMY_RESPAWN_TIME: float = 0.5
const GAME_OVER_SCENE: String = "res://Scenes/GameOver.tscn"
const VICTORY_SCENE: String = "res://Scenes/victory.tscn"

# Battle values that can be changed in the Inspector for different levels
@export_range(1, 4) var level_number: int = 1
@export var player_max_health: int = 1000
@export var enemy_max_health: int = 300
@export var enemies_to_defeat: int = 6
@export var enemy_attack_damage: int = 50

# Gets the player, enemy, attack button, health bars and enemy bullet
@onready var blade: Sprite2D = $blade
@onready var enemy_sprite: Sprite2D = $Enemy
@onready var attack_button: Button = $AttackButton
@onready var player_bar: ProgressBar = $player
@onready var enemy_bar: ProgressBar = $enemy
@onready var enemy_bullet: Sprite2D = $EnemyBullet

# Stores the changing values and states during the battle
var player_health: int
var enemy_health: int
var defeated_count: int = 0
var battle_finished: bool = false
var enemy_respawning: bool = false
var bullet_flying: bool = false
var enemy_attack_timer: Timer

func _ready() -> void:
	# Sets up the player's and enemy's health when the battle begins
	get_tree().paused = false
	player_health = player_max_health
	enemy_health = enemy_max_health
	update_health_bars()
	enemy_bullet.hide()
	attack_button.disabled = false

	# Connects the attack button to the player's attack
	if not attack_button.pressed.is_connected(attack):
		attack_button.pressed.connect(attack)

	# Creates a timer so the enemy attacks repeatedly during the battle
	enemy_attack_timer = Timer.new()
	enemy_attack_timer.wait_time = ENEMY_ATTACK_TIME
	add_child(enemy_attack_timer)
	enemy_attack_timer.timeout.connect(enemy_attack)
	enemy_attack_timer.start()

func attack() -> void:
	# Prevents the player from attacking when the battle is finished or enemy is respawning
	if battle_finished or enemy_respawning:
		return

	# Removes the player's attack damage from the enemy's health
	enemy_health = max(enemy_health - PLAYER_ATTACK_DAMAGE, MIN_HEALTH)
	update_health_bars()

	# Counts defeated enemies and checks if the player has completed the level
	if enemy_health == MIN_HEALTH:
		defeated_count += 1
		if defeated_count >= enemies_to_defeat:
			complete_level()
		else:
			respawn_enemy()

func enemy_attack() -> void:
	# Stops another enemy attack if the battle is finished, respawning or a bullet is already moving
	if battle_finished or enemy_respawning or bullet_flying:
		return

	# Makes the enemy bullet appear and move towards the player
	bullet_flying = true
	enemy_bullet.global_position = enemy_sprite.global_position
	enemy_bullet.show()
	var target_position = blade.global_position + Vector2(0, BULLET_TARGET_OFFSET)
	var tween = create_tween()
	tween.tween_property(enemy_bullet, "global_position", target_position, BULLET_TRAVEL_TIME)
	await tween.finished

	# Hides the bullet after it reaches the player
	enemy_bullet.hide()
	bullet_flying = false

	if battle_finished or enemy_respawning:
		return

	# Takes health away from the player when the enemy attack reaches them
	player_health = max(player_health - enemy_attack_damage, MIN_HEALTH)
	update_health_bars()

	# Ends the battle if the player's health reaches 0
	if player_health == MIN_HEALTH:
		game_over()

func update_health_bars() -> void:
	# Updates both health bars to show the current health
	player_bar.max_value = player_max_health
	player_bar.value = player_health
	enemy_bar.max_value = enemy_max_health
	enemy_bar.value = enemy_health

func respawn_enemy() -> void:
	# Prevents attacks while the next enemy is being respawned
	enemy_respawning = true
	enemy_sprite.hide()
	enemy_bar.hide()

	# Waits before bringing a new enemy into the battle
	await get_tree().create_timer(ENEMY_RESPAWN_TIME).timeout

	if battle_finished:
		return

	# Resets the enemy's health and makes the new enemy visible
	enemy_health = enemy_max_health
	update_health_bars()
	enemy_sprite.show()
	enemy_bar.show()
	enemy_respawning = false

func game_over() -> void:
	# Stops the battle when the player has been defeated
	if battle_finished:
		return

	battle_finished = true
	enemy_attack_timer.stop()
	attack_button.disabled = true
	enemy_bullet.hide()

	# Saves which level the player lost so the correct level can be retried
	GameProgress.current_level_scene = scene_file_path
	GameProgress.last_played_level = level_number

	# Changes to the Game Over scene
	get_tree().change_scene_to_file.call_deferred(GAME_OVER_SCENE)

func complete_level() -> void:
	# Stops the battle once the required number of enemies have been defeated
	if battle_finished:
		return

	battle_finished = true
	enemy_attack_timer.stop()
	attack_button.disabled = true
	enemy_bullet.hide()

	# Saves the completed level and unlocks the next level
	GameProgress.complete_level(level_number)
	GameProgress.last_completed_level = level_number

	# Changes to the Victory scene
	get_tree().change_scene_to_file.call_deferred(VICTORY_SCENE)
