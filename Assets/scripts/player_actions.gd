extends RigidBody2D

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
	base = get_node("Base")
	base.add_exception(self) #allow for player collision

# processing thread
func _fixed_process(delta):
	if keydown_mouseleft and mouse_is_over:
		is_dragging = true
		
	mousepoint = self.get_local_mouse_pos()
	mouse_distance = self.get_pos().distance_to(mousepoint)


# called when there is any input on the player
func _input(event):
	if event.is_action_pressed("mouse_down"): 
		print("mouse pressed")
		keydown_mouseleft = true
	if event.is_action_released("mouse_down"):
		print("mouse released")
		if is_dragging:
			print("setting linear velocity")
			print(mousepoint)
			print(mouse_distance)
			self.set_linear_velocity(-mousepoint)
			
		keydown_mouseleft = false
		is_dragging = false
		
# called when the mouse enters the player		
func _mouse_enter():
	print("mouse enter")
	mouse_is_over = true

# called when the mouse exits the player
func _mouse_exit():
	print("mouse exit") 
	mouse_is_over = false