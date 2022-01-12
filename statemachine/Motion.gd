extends State
# Collection of important methods to handle direction and animation.

class_name Motion

var speed = 0.0
var velocity = Vector2()

export(float) var max_walk_speed 

signal change_target_position(pos)

func handle_input(event):
	if event.is_action_pressed("attack") and get_parent().get_cards_amount():
		emit_signal("finished", "attack")
	return .handle_input(event)

func enter():
	owner.get_node("CollisionPolygon2D").set_deferred("disabled",false)
	max_walk_speed = 400

#func get_input_direction():
#	var input_direction = Vector2(
#			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
#			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#	)
#
#	return input_direction
