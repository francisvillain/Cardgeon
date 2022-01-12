extends KinematicBody2D

var health = 1
var damage = 0
var direction = Vector2()
var target
var path : Array = []
var speed : float = 200.0
var velocity : Vector2 = Vector2()
var target_detected : bool = false

onready var line = $Line2D
onready var los = $LineOfSight

func _physics_process(delta):
	line.global_position = Vector2.ZERO
	check_death()
	detect_target()
	check_player_in_detection()
	if target_detected:
		generate_path()
		navigate()
	move(delta)

func detect_target():
	target = GlobalNode.get_player_node()
	los.look_at(target.global_position) 

func move(delta):
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.is_in_group("player"):
			collider.take_damage(self,damage, 0)

func take_damage(node, damage, effect):
	health -= damage

func check_death():
	if health <= 0:
		self.queue_free()

func navigate():
	if path.size()>0:
		velocity = position.direction_to(path[1]) * speed
		
		if position == path[0]:
			path.pop_front()

func generate_path():
	var nav = GlobalNode.get_navigation_node()
	path = nav.get_simple_path(position, target.position, false)
	line.points = path

#func set_target_position(new_direction):
#	target_position = new_direction
#	#target_detected = true

func check_player_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("player"):
		target_detected = true
		print("raycast collided")
		return true
	return false

