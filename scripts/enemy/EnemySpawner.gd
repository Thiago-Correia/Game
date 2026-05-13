extends Node2D

@export var enemy_scene: PackedScene # Arraste seu Enemy.tscn para cá no Inspetor
@export var max_enemies: int = 5    # Limite de inimigos na tela
@export var spawn_radius: float = 1000.0 # Um pouco maior que a metade da tela (1080p)

@onready var spawn_timer = $SpawnTimer
@onready var player = get_tree().get_first_node_in_group("Player")

func _on_spawn_timer_timeout():
	# 1. Conta quantos inimigos existem no grupo "enemies"
	var current_enemies = get_tree().get_nodes_in_group("Enemies").size()
	
	if current_enemies < max_enemies:
		spawn_enemy()

func spawn_enemy():
	if player == null: return
	
	# 2. Escolhe uma direção aleatória (0 a 360 graus)
	var random_angle = randf() * TAU # TAU é 2 * PI (volta completa)
	var direction = Vector2.RIGHT.rotated(random_angle)
	
	# 3. Calcula a posição final: Posição do Player + (Direção * Raio)
	var spawn_pos = player.global_position + (direction * spawn_radius)
	
	# 4. Instancia o inimigo
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	
	# Adiciona o inimigo ao grupo para podermos contar depois
	enemy.add_to_group("Enemies")
	
	# Adiciona na cena principal (ou em um nó 'Enemies' se você tiver um)
	get_tree().current_scene.add_child(enemy)
