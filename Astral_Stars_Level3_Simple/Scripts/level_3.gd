extends Control

# Sets the main combat values used in Level 3
const PLAYER_ATTACK_DAMAGE: int = 100
const MIN_HEALTH: int = 0
const ENEMY_ATTACK_TIME: float = 1.2
const ENEMY_RESPAWN_TIME: float = 0.2
const BULLET_TRAVEL_TIME: float = 0.3
const BULLET_TARGET_OFFSET: int = 20

# Stores the Game Over and Victory scene paths
const GAME_OVER_SCENE: String = "res://Scenes/GameOver.tscn"
const VICTORY_SCENE: String = "res://Scenes/victory.tscn"

# Level 3 settings that can be adjusted through the Inspector
@export_range(1, 4) var level_number: int = 3
@export var player_max_health: int = 300
@export var enemy_max_health: int = 500
@export var enemies_to_defeat: int = 10
@export var enemy_attack_damage: int = 90

# Gets the player, enemy and battle UI nodes
@onready var blade: Sprite2D = $blade
@onready var enemy_sprite: Sprite2D = $Enemy
@onready var attack_button: Button = $AttackButton
@onready var player_bar: ProgressBar = $player
@onready var enemy_bar: ProgressBar = $enemy
@onready var enemy_bullet: Sprite2D = $EnemyBullet

# Stores health, defeated enemies and the current state of the battle
var player_health: int
var enemy_health: int
var defeated_count: int = 0
var battle_finished: bool = false
var enemy_respawning: bool = false
var bullet_flying: bool = false
var enemy_attack_timer: Timer


func _ready() -> void:
	# Makes sure the game is not paused when Level 3 begins
	get_tree().paused = false

	# Gives the player and enemy their starting health
	player_health = player_max_health
	enemy_health = enemy_max_health

	update_health_bars()

	# Hides the enemy bullet until the enemy attacks
	enemy_bullet.hide()
	attack_button.disabled = false

	# Connects the attack button to the attack function
	if not attack_button.pressed.is_connected(attack):
		attack_button.pressed.connect(attack)

	# Creates a repeating timer that controls when the enemy attacks
	enemy_attack_timer = Timer.new()
	enemy_attack_timer.wait_time = ENEMY_ATTACK_TIME
	add_child(enemy_attack_timer)

	enemy_attack_timer.timeout.connect(enemy_attack)
	enemy_attack_timer.start()


func attack() -> void:
	# Prevents attacking when the battle has finished or an enemy is respawning
	if battle_finished or enemy_respawning:
		return

	# Removes the player's attack damage from the enemy's health
	enemy_health = max(
		enemy_health - PLAYER_ATTACK_DAMAGE,
		MIN_HEALTH
	)

	update_health_bars()

	# Counts each defeated enemy
	if enemy_health == MIN_HEALTH:
		defeated_count += 1

		# Completes the level after the required number of enemies are defeated
		if defeated_count >= enemies_to_defeat:
			complete_level()
		else:
			# Respawns another enemy if the level is not complete
			respawn_enemy()


func enemy_attack() -> void:
	# Prevents multiple bullets or attacks happening at the same time
	if battle_finished or enemy_respawning or bullet_flying:
		return

	bullet_flying = true

	# Makes the enemy bullet appear at the enemy's position
	enemy_bullet.global_position = enemy_sprite.global_position
	enemy_bullet.show()

	# Sets the position that the bullet will travel towards
	var target_position = blade.global_position + Vector2(
		0,
		BULLET_TARGET_OFFSET
	)

	# Creates a tween to animate the bullet moving towards the player
	var tween = create_tween()

	tween.tween_property(
		enemy_bullet,
		"global_position",
		target_position,
		BULLET_TRAVEL_TIME
	)

	# Waits until the bullet animation has finished
	await tween.finished

	enemy_bullet.hide()
	bullet_flying = false

	if battle_finished or enemy_respawning:
		return

	# Removes health from the player after the enemy attack
	player_health = max(
		player_health - enemy_attack_damage,
		MIN_HEALTH
	)

	update_health_bars()

	# Changes to Game Over if the player's health reaches 0
	if player_health == MIN_HEALTH:
		game_over()


func update_health_bars() -> void:
	# Updates the player's health bar
	player_bar.max_value = player_max_health
	player_bar.value = player_health

	# Updates the enemy's health bar
	enemy_bar.max_value = enemy_max_health
	enemy_bar.value = enemy_health


func respawn_enemy() -> void:
	# Changes the Boolean while the enemy is respawning
	enemy_respawning = true

	# Hides the defeated enemy and its health bar
	enemy_sprite.hide()
	enemy_bar.hide()

	# Creates a short delay before the next enemy appears
	await get_tree().create_timer(
		ENEMY_RESPAWN_TIME
	).timeout

	if battle_finished:
		return

	# Gives the new enemy full health
	enemy_health = enemy_max_health
	update_health_bars()

	# Shows the new enemy and health bar
	enemy_sprite.show()
	enemy_bar.show()

	enemy_respawning = false


func game_over() -> void:
	# Prevents the Game Over function from running more than once
	if battle_finished:
		return

	# Stops the battle when the player loses
	battle_finished = true
	enemy_attack_timer.stop()
	attack_button.disabled = true
	enemy_bullet.hide()

	# Saves Level 3 so the player can retry the correct level
	GameProgress.current_level_scene = scene_file_path
	GameProgress.last_played_level = level_number

	# Changes to the Game Over screen
	get_tree().change_scene_to_file.call_deferred(
		GAME_OVER_SCENE
	)


func complete_level() -> void:
	# Prevents the level completion from running more than once
	if battle_finished:
		return

	# Stops all battle actions after the player wins
	battle_finished = true
	enemy_attack_timer.stop()
	attack_button.disabled = true
	enemy_bullet.hide()

	# Records that Level 3 has been completed
	GameProgress.complete_level(level_number)
	GameProgress.last_completed_level = level_number

	# Changes to the Victory screen
	get_tree().change_scene_to_file.call_deferred(
		VICTORY_SCENE
	)
