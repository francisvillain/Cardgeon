extends Node


onready var global_node setget set_global_node, get_global_node
onready var player_position setget set_player_position, get_player_position
onready var navigation_node setget set_navigation_node, get_navigation_node
onready var player_node setget set_player_node, get_player_node

func _ready():
	randomize()

func set_global_node(param):
	global_node = param
	
func get_global_node():
	return global_node
	
func set_player_position(param):
	player_position = param

func get_player_position():
	return player_position

func set_player_node(node):
	player_node = node

func get_player_node():
	return player_node

func set_navigation_node(node):
	navigation_node = node

func get_navigation_node():
	return navigation_node

func get_player_predicted_position(body, bullet_pos):
	var movement_status = get_player_movement_status()
	var predicted_position : Vector2
	var return_range = 600

	predicted_position = movement_status["position"] + movement_status["direction"] * movement_status["speed"] * 1.1
	
	if check_in_room_predicted_position(predicted_position):
		predicted_position = movement_status["position"]
	
	var retval = check_max_return_range(movement_status["position"], bullet_pos, return_range)
	var condition = true
	
	if retval:
		if !check_in_room_predicted_position(retval):
			predicted_position = retval
		else:
			while condition: 
				return_range -= 10
				retval = check_max_return_range(movement_status["position"], bullet_pos, return_range)
				if !check_in_room_predicted_position(retval):
					return retval
	
	return predicted_position

func check_max_return_range(player_pos, bullet_pos, max_range):
	var dist = player_pos.distance_to(bullet_pos)
#	print("dist: ", dist)
	if dist > max_range:
		var return_dir  = player_pos.direction_to(bullet_pos).normalized()
		return bullet_pos - return_dir * max_range
	
func check_in_room_predicted_position(predicted_position):
	var room = global_node.get_node("Navigation2D/Room")
	var local_predicted_position = room.to_local(predicted_position)
	var cell_index = room.get_cellv(room.world_to_map(local_predicted_position))
	if cell_index != 1:
		return true
	return false
		
func get_player_movement_status():
	return player_node.get_player_movement_status()

func add_bullet_card(card : KinematicBody2D):
	var card_bulltes = global_node.get_node("CardBullets")
	if !card_bulltes:
		print("nie ma noda")
		
	card_bulltes.add_child(card)

func add_pickup_card(card : KinematicBody2D):
	var card_pickups = global_node.get_node("CardPickUp")
	
	if !card_pickups:
		print("nie ma noda")
		
	card_pickups.add_child(card)

func add_mark(mark : Node2D):
	var marks = global_node.get_node("FallMarks")
	
	if !marks:
		print("nie ma noda")
		
	marks.add_child(mark)

func add_landed_card(card : Node2D):
	var landed_cards = global_node.get_node("LandedCard")
	
	if !landed_cards:
		print("nie ma noda")
		
	landed_cards.call_deferred("add_child", card)

func pop_card_ui():
	var hand = global_node.get_node("CanvasLayer/Hand")
	hand.pop_card()

func add_card_ui(status : Dictionary):
	var hand = global_node.get_node("CanvasLayer/Hand")
	hand.add_card(status)

func add_cards(n : int):
	var player = global_node.get_node("Player")
	var suits  = ["diamond", "heart", "club", "spade"]
	var values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10","J","Q","K"]
	for i in range(n):
		
		var status = {
			"id" :  randi(),
			"suit" : suits[randi() % len(suits)],
			"value": values[randi() % len(values)],
		}
		add_card_ui(status)
		player.Cards.append(status)
		
