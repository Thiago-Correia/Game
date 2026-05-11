extends Node2D

@export var tilemap: TileMapLayer

@export var map_width := 128
@export var map_height := 128

@export var biome_seed_count := 18
@export var world_seed := 12345

@export var noise_scale := 0.03
@export var border_noise_strength := 10.0

var biomes = [
	{
		"name": "Grass",
		"source_id": 0,
		"atlas_coords": Vector2i(8, 7)
	},
	{
		"name": "Sand",
		"source_id": 0,
		"atlas_coords": Vector2i(2, 7)
	},
	{
		"name": "Snow",
		"source_id": 0,
		"atlas_coords": Vector2i(6, 7)
	},
	{
		"name": "Water",
		"source_id": 0,
		"atlas_coords": Vector2i(0, 7)
	},
	{
		"name": "Fire",
		"source_id": 0,
		"atlas_coords": Vector2i(4, 7)
	},
]

var biome_points: Array = []

var noise := FastNoiseLite.new()


func _ready():
	generate_world()


func generate_world():

	if tilemap == null:
		push_error("TileMapLayer not assigned!")
		return

	tilemap.clear()

	var rng := RandomNumberGenerator.new()
	rng.seed = world_seed

	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = noise_scale
	
	biome_points.clear()

	for i in biome_seed_count:

		var biome_index = rng.randi_range(0, biomes.size() - 1)

		var point_data = {
			"position": Vector2(
				rng.randi_range(0, map_width),
				rng.randi_range(0, map_height)
			),
			"biome_index": biome_index
		}

		biome_points.append(point_data)

	for y in map_height:
		for x in map_width:

			var current_pos = Vector2(x, y)

			var closest_seed = null
			var closest_distance := INF

			for seed_point in biome_points:

				var seed_pos: Vector2 = seed_point.position

				var noise_value = noise.get_noise_2d(x, y)

				var distorted_seed = seed_pos + Vector2(
					noise_value * border_noise_strength,
					noise_value * border_noise_strength
				)

				var dist = current_pos.distance_squared_to(distorted_seed)

				if dist < closest_distance:
					closest_distance = dist
					closest_seed = seed_point

			var biome = biomes[closest_seed.biome_index]

			tilemap.set_cell(
				Vector2i(x, y),
				biome.source_id,
				biome.atlas_coords
			)

	print("World generated.")
