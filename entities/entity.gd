
extends RigidBody2D

#const TileConfig = preload("./tile_config.gd")
const TILE_SIZE = Vector2(64, 64)

export(NodePath) var tilemap_path = @"../tileMap"
export(NodePath) var level_holder_path = @"../.."
export(String) var goal = ""

var tile_directions = {
	overlap = Vector2(0, 0),
	top = Vector2(0, -1),
	right = Vector2(1, 0),
	bottom = Vector2(0, 1),
	left = Vector2(-1, 0)
}

var tile_types = {}
var ray_status = {}

var is_moving = false
var movement = Vector2(0, 0)
var movement_original = Vector2(0, 0)
var movement_check_collision = ""
var speed_multiplier = 1
var pause_frames = 0
var wait_frames = 3
var push_direction = ""
var enabled = true

onready var tilemap = get_node(tilemap_path)
onready var level_holder = get_node(level_holder_path)
onready var ray_nodes = {
	bottom = get_node("base"),
}

func _ready():
	enable()
	for ray in ray_nodes:
		ray_nodes[ray].add_exception(self)
		ray_status[ray] = null
	
	for direction in tile_directions:
		#tile_types[direction] = TileConfig.TILE_EMPTY
		pass
	
	if goal != "":
		level_holder.goal_add(goal)
	
	connect("auto_move_done", self, "play_auto_move_sound")
	set_fixed_process(true)

func _fixed_process(delta):
	pass

func disable():
	enabled = false
	stop_movement()
	set_fixed_process(false)
	set_layer_mask_bit(1, false)

func enable():
	enabled = true
	set_fixed_process(true)
	set_layer_mask_bit(1, true)

func update_status():
	update_tile_status()
	update_ray_status()

func update_tile_status():
	var current_position = tilemap.world_to_map(get_global_pos()).snapped(Vector2(1, 1))
	for direction in tile_directions:
		var cell = tilemap.get_cellv(current_position + tile_directions[direction])
		#tile_types[direction] = TileConfig.get_tile_type(cell)

func update_ray_status():
	for ray in ray_nodes:
		if ray_nodes[ray].is_colliding() and ray_nodes[ray].get_collider() != null:
			ray_status[ray] = ray_nodes[ray].get_collider()
		else:
			ray_status[ray] = null




