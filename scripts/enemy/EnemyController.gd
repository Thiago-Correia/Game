extends CharacterBody2D

@export var speed := 100.0
@onready var attack_timer = $AttackTimer

@export_group("Combate")
@export var attack_range := 50.0 # Raio do ataque (deve ser um pouco maior que a distância de parada)
@export var ideal_distance := 100.0 # Distância que ele quer manter
@export var damage := 1
@onready var attack_area = $AttackArea


var player: Node2D = null
var can_attack := true

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	if $AttackArea/CollisionShape2D.shape is RectangleShape2D:
		var square_shape = $AttackArea/CollisionShape2D.shape.duplicate()
		
		square_shape.size = Vector2(attack_range * 2, attack_range * 2)
		
		$AttackArea/CollisionShape2D.shape = square_shape

func _physics_process(_delta):
	if player == null or player.health.is_dead:
		velocity = Vector2.ZERO # Para de se mover se o player sumir ou morrer
		return
		
	var distance_to_player = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	
	if distance_to_player > (ideal_distance + 5):
		velocity = direction * speed
	elif distance_to_player < (ideal_distance - 5):
		velocity = -direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	check_attack()

func check_attack():
	# Se o player estiver dentro da Area2D e o timer não estiver rodando
	var targets = attack_area.get_overlapping_bodies()
	for target in targets:
		if target.is_in_group("Player") and can_attack:
			attack_player(target)

func attack_player(target):
	can_attack = false
	print("Inimigo atacou o player!")
	
	if target.has_node("HealthComponent"):
		flash_attack()
		target.get_node("HealthComponent").take_damage(damage)
	
	attack_timer.start() # Inicia o cooldown de 1 segundo
	
func flash_attack():
	var tween = create_tween()
	# Fazemos ele brilhar em branco (fica bem evidente sobre o vermelho)
	modulate = Color.WHITE 
	# Retorna para o vermelho original em 0.1 segundos
	# Se o seu vermelho for o padrão do editor, Color.RED funciona bem
	tween.tween_property(self, "modulate", Color.GREEN_YELLOW, 0.1)

func _on_attack_timer_timeout():
	can_attack = true
