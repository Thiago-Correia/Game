extends Node

@onready var Player: Node2D = $"."

@export var speed := 100

@export var dash_speed := 20
@export var dash_duration := 0.25
@export var dash_decay := 12.0

var dash_velocity := Vector2.ZERO
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown:= 0.0

func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var player_direction := Vector2(input_dir.x, input_dir.y).normalized()
	var player_velocity = player_direction * speed

	if(Input.is_action_pressed("ui_accept") and !is_dashing and dash_cooldown <= 0):
		is_dashing = true
		dash_cooldown = 2.0
		dash_timer = dash_duration
		dash_velocity = player_direction * dash_speed

	if(is_dashing):
		dash_timer -= delta
		dash_velocity.move_toward(Vector2.ZERO, dash_decay * delta)

		if dash_timer <= 0.0 or dash_velocity.length() < 0.1:
			is_dashing = false
			dash_velocity = Vector2.ZERO

	if(dash_cooldown > 0):
		dash_cooldown -= delta

	var total_velocity = player_velocity + dash_velocity
	move(Player, total_velocity)

func move(player: Node2D, velocity: Vector2) -> void:
	player.position += velocity
