extends RigidBody2D

# class member variables:
var player
var base

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	base = get_node("Base")
	base.add_exception(self) #allow for player collision


func _process(delta):
	if base.is_colliding():
		print("Colliding")