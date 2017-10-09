extends CanvasLayer


const GOAL_TYPES = ["hole"]

var allow_next_level = false
var popup_running = false

onready var timer = get_node("timer")
onready var popup = get_node("popup")
#onready var lookaround = get_node("lookaround")
onready var level_holder = get_node("../levelHolder")
onready var player = get_node("../playerHolder/player")

func _ready():
	screenManager.set_minimum_size(Vector2(0, 0))
	
	var nodes_left = get_node("popup/popupNode/popupBody/buttonContainer").get_children()
	
	# Removes the focus from the buttons
	for button in get_node("topLeftButtons").get_children():
		if button extends Control:
			button.set_focus_mode(Control.FOCUS_NONE)
			
			if button extends BaseButton:
				nodes_left.push_back(button)
	
		# Removes the focus from the buttons
	while nodes_left.size() > 0:
		var button = nodes_left[nodes_left.size() - 1]
		nodes_left.pop_back()
		if button extends BaseButton:
			button.connect("pressed", self, "popup_button_pressed", [button.get_name()])
		else:
			for i in button.get_children():
				nodes_left.push_back(i)
	
	# Subscribe to various notifications
	level_holder.connect("counters_changed", self, "update_counters")
	set_process_input(true)
	
	
func _input(event):
	if event.is_action_pressed("retry"):
		popup_button_pressed("retry")
	if event.is_action_pressed("next_level"):
		popup_button_pressed("next")
	if event.is_action_pressed("exit"):
		popup_button_pressed("menu")
		

func popup_button_pressed(name): # Actions for different popup buttons
	if name == "retry":
		check_hide_popup()
		level_holder.retry_level()
	elif name == "next":
		if allow_next_level:
			check_hide_popup()
			allow_next_level = false
			level_holder.next_level()
		else:
			return
	elif name == "menu":
		get_tree().set_pause(false)
		scenesManager.load_scene("res://menu/menu.tscn")

func check_hide_popup():
	if popup_running:
		get_tree().set_pause(false)
		popup.get_node("AnimationPlayer").play("hide_popup")
		popup.get_node("AnimationPlayer").connect("finished", self, "hide_popup", [], CONNECT_ONESHOT)

func hide_popup(): # Hide the popup
	popup_running = false
	popup.hide()
	set_disabled(false)

func set_disabled(disable):
	for node in get_node("top_left_buttons").get_children():
		if node extends Button:
			node.set_disabled(disable)
			
func update_counters():
	pass
	
