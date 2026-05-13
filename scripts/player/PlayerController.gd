extends CharacterBody2D

# Referências aos componentes
@onready var movement = $PlayerMovement
@onready var health = $HealthComponent

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_damage"):
		health.take_damage(10)
		print(health.current_health)
	
	# Delegando o Dash (Espaço) para o componente de movimento
	if event.is_action_pressed("ui_accept"):
		movement.start_dash()

func _physics_process(delta: float) -> void:
	# 1. Pega a direção do input
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Pede para o componente de movimento calcular a velocidade
	# Passamos o 'velocity' atual e a 'direction'
	velocity = movement.calculate_velocity(velocity, direction, delta)
	
	# 3. Executa o movimento oficial da Godot (com colisão)
	move_and_slide()
