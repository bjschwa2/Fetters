extends Node

signal counters_changed()

const TILE_SIZE = Vector2(64, 64)

var level_scene # The scene containing the level
var level_node # The Node with the level
var level_tileset = TileSet.new() # The Tileset
var current_pack # The current pack/level
var current_level
var turns = 0 # How many turns passed from the start


var goals_left = 0 # The amount of goals left to be taken
var goals_total = {} # The starting amounts of different goals left to be taken
var goals_taken = {} # The taken amounts of different goals
var goal_wait = 0

onready var gui = get_node("../gui")
onready var player = get_node("../playerHolder/player")
onready var raw_packs = fileManager.get_file_lines("res://Levels/packs.txt")

func _ready():
	config.speed_ratio = 1
	set_process(true)
	get_node("/root").connect("size_changed",self,"window_resize")
	
func _process(delta): 
	pass
	
func load_level(pack, level): # Load level from pack
	current_level = level
	current_pack = pack
	level_scene = load(str("res://Levels/", pack, "/level", level, ".tscn"))
	
	# Remove every currently loaded level
	for node in get_children():
		node.queue_free()
	
	# Reset the counters
	turns = 0
	goals_left = 0
	goals_taken = {}
	goals_total = {}
	
	# Create the new level
	level_node = level_scene.instance()
	add_child(level_node)
	
	# Prepare the player
	player.enable()
	if player.get_node("in_and_out").is_connected("finished", self, "load_level"):
		player.get_node("in_and_out").disconnect("finished", self, "load_level")
	player.set_pos(level_node.get_node("start").get_pos())
	#player.level_load(level_node)
	emit_signal("counters_changed")
	
	# Compute useful info about the tiles
	level_tileset = level_node.get_node("tileMap").get_tileset()
	var tilemap = level_node.get_node("tileMap")
	
	window_resize()

func window_resize():
	var new_size = get_node("/root").get_size_override()
	if !level_node:
		return
	var tilemap = level_node.get_node("tileMap")
	
	var scale = new_size.x/1024
	if(scale > 1):
		level_node.get_node("CanvasLayer").set_scale(Vector2(scale,scale))
		level_node.get_node("CanvasLayer").set_offset(Vector2(32*scale,32-(scale - 1)*768/2))
	
	player.camera.force_update_scroll()
	
func retry_level(): # Retry the current level
	#player.get_node("in_and_out").play("exit")
	#player.get_node("in_and_out").connect("finished", self, "load_level", [current_pack, current_level])
	pass
	
func next_level(): # Go to the next level
	load_level(current_pack, int(current_level) + 1)

func show_end_gui():
	if player.get_node("in_and_out").is_connected("finished", self, "show_end_gui"):
		player.get_node("in_and_out").disconnect("finished", self, "show_end_gui")
	saveManager.set_reached_level(current_pack, current_level + 1)
	# Check if there are more levels
	for raw_pack in raw_packs:
		var line_parts = raw_pack.split(" ")
		if line_parts.size() >= 2:
			if line_parts[0] == current_pack:
				gui.prompt_finsh_level(turns, int(line_parts[1]) >= int(current_level) + 1, goal_wait - OS.get_unix_time())
				break
	
	emit_signal("counters_changed")