extends KinematicBody2D


const GRAVITY = 2000
#const DAMAGE = 2
export(float) var TIME = 1.3 #SEC

var velocity = Vector2.ZERO
var original_rotation = 0.0

var Mark = preload("res://card/Mark.tscn")
var CardLanded = preload("res://card/CardLanded.tscn")
var mark
var landed_card_position : Vector2
var full_time : float

var status = {}

var screen_size = Vector2(1280,720)  #get_viewport_rect().size


func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta 
	#$Sprite.rotation = original_rotation + velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var target = collision.get_collider()
		if target.is_in_group("player"):
			target.add_card(status)
			queue_free()
			mark.queue_free()
	
func calculate_arc_velocity(source_position, target_position, arc_height, gravity):
	var vel = Vector2()
	var displacement = target_position - source_position
	
	if displacement.y > arc_height:
		var time_up = sqrt(-2 * arc_height / float(gravity))
		var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
		full_time = float(time_up + time_down) 
		TIME = full_time
#		print("full time: ",float(full_time))

		vel.y = -sqrt(-2 * gravity * arc_height) * TIME/float(time_up + time_down)
		vel.x = displacement.x / TIME # * float(time_up + time_down) 
		
#		vel.y = -sqrt(-2 * gravity * arc_height) * 1/full_time
#		vel.x = displacement.x / full_time
		
		$Timer.wait_time = 0.8 * full_time
		$Timer.start()
		
		
	return vel
	
func launch(target_position, new_status):
	
	status = new_status
	landed_card_position = target_position
	
	mark = Mark.instance()
	GlobalNode.add_mark(mark)
	mark.launch(status["id"])
	mark.set_global_position(target_position)
	
	var direction = (target_position - position).normalized()
#	if direction.x < 0: # left
#		$Sprite.rotation_degrees = -135
#	original_rotation = $Sprite.rotation
	
	# calculate arc_height based on distance
	var distance = abs(target_position.x - global_position.x)
	var max_height = (distance / screen_size.x) * screen_size.y
	
	var arc_height = target_position.y - global_position.y - max_height
	arc_height = min(arc_height, -max_height)
	#print("height %s" % arc_height)
	
	velocity = calculate_arc_velocity(global_position, target_position, arc_height, GRAVITY)

func card_land():
	self.queue_free()
	var card = CardLanded.instance()
	GlobalNode.add_landed_card(card)
	card.call_deferred("set_global_position", self.get_global_position())
	card.launch(status)

func get_id():
	return status["id"]

func _on_Timer_timeout():
	$CollisionPolygon2D.disabled = false
