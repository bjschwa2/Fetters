extends "entity.gd"


# class member variables:
var base
var keydown_mouseleft = false
var is_dragging = false
var mouse_is_over = false
var mouse_distance
var speed = 3 
var mousepoint = Vector2(0,0)

# Initialization here
func _ready():
	# Called every time the node is added to the scene.
	Globals.set("Player", self)
	set_process_input(true)
	set_fixed_process(true)
	base = get_node("base")
	#base.add_exception(self) #allow for player collision

# processing thread
func _fixed_process(delta):
	if keydown_mouseleft and mouse_is_over:
		is_dragging = true
		
	mousepoint = self.get_local_mouse_pos()
	mouse_distance = self.get_pos().distance_to(mousepoint)


# called when there is any input on the player
func _input(event):
	if event.is_action_pressed("mouse_down"): 
		keydown_mouseleft = true
	if event.is_action_released("mouse_down"):
		if is_dragging:
			if base.is_colliding():
				self.set_linear_velocity(-mousepoint*2)
			
		keydown_mouseleft = false
		is_dragging = false
		
# called when the mouse enters the player		
func _mouse_enter():
	mouse_is_over = true

# called when the mouse exits the player
func _mouse_exit():
	mouse_is_over = false


func level_load(level_node):
	
	tilemap = level_node.get_node("tileMap") # Get the tilemap
	
	# Set the limits for the camera
	
	#var top_left_pos = level_node.get_node("camera_start").get_pos()
	#var bottom_right_pos = level_node.get_node("camera_end").get_pos()
	#camera.set_limit(MARGIN_TOP, top_left_pos.y)
	#camera.set_limit(MARGIN_BOTTOM, bottom_right_pos.y)
	
	# Reset variables
	set_fixed_process(true)
