extends RigidBody2D

func _ready():
	connect("body_enter",self,"_body_enter")

func _body_enter( body ):
	if body == Globals.get("Player"):
		Globals.get("Player").set_gravity_scale(Globals.get("Player").get_gravity_scale() *1.1 )
		print(Globals.get("Player").get_gravity_scale())
		#queue_free()
