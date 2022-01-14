extends KinematicBody2D

signal change_hp

var current_direction : String
var health = 100
var target_movement_position : Vector2

onready var line = $Line2D
onready var progress_bar = $Bars/HealthBar

var Cards = []

func _ready():
	GlobalNode.set_player_node(self)
	target_movement_position = get_global_position()
	progress_bar.set_max(health)
	emit_signal("change_hp", health)

func _physics_process(_delta):
	line.global_position = Vector2.ZERO
	look_direction_mouse()
	check_death()
	#GlobalNode.set_player_position(get_global_position())

func look_direction_mouse() -> void:
	var detect_dir : String
	if get_global_mouse_position().x - get_global_position().x > 0:
		detect_dir = 'right'
	else:
		detect_dir = 'left'
	
	if current_direction != detect_dir:
		#emit_signal("direction_changed", detect_dir)
		change_direction(detect_dir)
		current_direction = detect_dir

func change_direction(new_direction : String) -> void:

	match new_direction:
		'right':
			get_node("Body").flip_h = false
			get_node("CollisionPolygon2D").scale = Vector2(1,1)
			get_node("Arm").scale = Vector2(1,1)
		'left':
			get_node("Body").flip_h = true
			get_node("CollisionPolygon2D").scale = Vector2(-1,1)
			get_node("Arm").scale = Vector2(-1,1)

func take_damage(node, damage, effect):
	health -= damage

func check_death():
	pass
	#if health <= 0:
		#GlobalNode.restart()

func add_card(status):
	var ids = []
	for c in Cards:
		ids.append(c["id"])
	if status["id"] in ids:
		return 
	else:
		get_node("StateMachine").add_one_card()
		GlobalNode.add_card_ui(status)
		Cards.append(status)
	
func pop_card():
	get_node("StateMachine").pop_one_card()
	GlobalNode.pop_card_ui()

func get_player_movement_status():
	return {
		"position" : get_global_position(),
		"direction" : get_direction(),
		"speed" : get_movement_speed(),
	}

func get_direction():
	var direction_mouse = Vector2(0,0)
	if target_movement_position.distance_to(get_global_position()) > 20:
		direction_mouse = (target_movement_position - get_global_position()).normalized()
	return direction_mouse

func get_movement_speed():
	return 400 # node with stats in the future


func _change_target_position(pos):
	target_movement_position = pos
