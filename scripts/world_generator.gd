extends Node2D

@export var biome_textures: Array[Texture2D] # Arraste seus PNGs para cá no Inspetor
@export var grid_size: Vector2i = Vector2i(5, 5) # Tamanho do mundo em blocos
@export var biome_size: Vector2 = Vector2(1024, 1024) # Tamanho em pixels de cada PNG

func _ready():
	generate_world()

func generate_world():
	# Define uma semente aleatória para que o mundo mude a cada execução
	randomize() 
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			# 1. Escolhe um bioma aleatório da pool
			var random_biome = biome_textures.pick_random()
			
			# 2. Cria um novo Sprite para exibir esse bioma
			var sprite = Sprite2D.new()
			sprite.texture = random_biome
			sprite.centered = false # Facilita o posicionamento no grid
			
			# 3. Calcula a posição baseada no índice do loop e tamanho da imagem
			sprite.position = Vector2(x * biome_size.x, y * biome_size.y)
			
			# 4. Adiciona o sprite à cena
			add_child(sprite)
