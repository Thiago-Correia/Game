extends Node

@export_group("Configurações de Movimento")
@export var speed := 500.0 
@export var dash_speed := 1200.0
@export var dash_duration := 0.2
@export var dash_decay := 10.0

var dash_velocity := Vector2.ZERO
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown := 0.0

func calculate_velocity(_current_velocity: Vector2, direction: Vector2, delta: float) -> Vector2:
	# Atualiza Cooldowns
	if dash_cooldown > 0:
		dash_cooldown -= delta
	
	# Lógica do Dash
	if is_dashing:
		dash_timer -= delta
		# Suaviza a parada do dash
		dash_velocity = dash_velocity.move_toward(Vector2.ZERO, dash_decay * delta * 100)
		
		if dash_timer <= 0 or dash_velocity.length() < 10:
			is_dashing = false
			dash_velocity = Vector2.ZERO
		return dash_velocity
	
	# Movimento Normal
	return direction * speed

func start_dash():
	if not is_dashing and dash_cooldown <= 0:
		# Pega a direção baseada no input atual ou na última direção movida
		var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if dir == Vector2.ZERO: return # Não dá dash parado
		
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown = 1.0 # 1 segundo de recarga
		dash_velocity = dir * dash_speed
