extends KinematicBody2D


class_name Card

var direction : Vector2 = Vector2()
export var velocity : int = 450 

var status = {}

var CardFlying = preload("res://card/CardFlying.tscn")

func _ready():
	pass 

func _physics_process(delta):
	
	var collider = move_and_collide(direction * velocity * delta)
	
	if collider:
		self.queue_free()
		var card = CardFlying.instance()
		GlobalNode.add_pickup_card(card)
		card.set_global_position(self.get_global_position())
		var target = GlobalNode.get_player_predicted_position(collider.get_collider(), get_global_position())
		card.launch(target, status)
		
func throw(dir : Vector2):
	direction = dir

func launch(new_status):
	status = new_status
