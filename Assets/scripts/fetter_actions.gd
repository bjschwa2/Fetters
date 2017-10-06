extends RigidBody2D

func _ready():
	connect("body_enter", self, "_on_body_enter")
	set_fixed_process(true)

func _fixed_process(delta):
	pass

func _on_body_enter( body ):
	print("body entered")
	if body == Globals.get("Player"):
		Globals.get("Player").set_mass( Globals.get("Player").get_mass() +1 )
		print(Globals.get("Player").get_mass())
