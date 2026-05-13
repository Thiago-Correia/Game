extends Node  # <--- ESSA LINHA É OBRIGATÓRIA

signal health_changed(new_health)
signal died

@export var max_health: int = 100
@onready var current_health: int = max_health

var is_dead: bool = false

@onready var parent_node = get_parent() 

func take_damage(amount: int):
	if is_dead: return
	
	current_health = clampi(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	
	flash_sprite()

	if current_health <= 0:
		die()

func die():
	is_dead = true
	died.emit()
	print("Morreu!")

func flash_sprite():
	var tween = create_tween()
	parent_node.modulate = Color.RED 
	tween.tween_property(parent_node, "modulate", Color.WHITE, 0.1)
