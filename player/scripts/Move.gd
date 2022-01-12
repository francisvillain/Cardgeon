extends Motion

var path := []

const offset = 5

func enter():
	.enter()
	speed = 0.0
	velocity = Vector2()
	#emit_signal("change_target_position", get_parent().target_position)
	emit_signal("change_target_position", owner.get_global_mouse_position())
	owner.get_node("AnimationPlayer").play("move")

func handle_input(event):
	return .handle_input(event)

func update(_delta):
	if not can_move():
		emit_signal("finished", "idle")

	speed = max_walk_speed
	generate_path()
	navigate()
	
	var input_direction_mouse = (get_parent().target_position - owner.position).normalized()
	
	var collision_info = move()
	if not collision_info:
		return
	if collision_info.collider.is_in_group("environment"):
		return null

func move():
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)

func can_move() -> bool:
	var dist = get_parent().target_position.distance_to(owner.position) 
	return dist > offset

func navigate():
	if path.size()>0:
		velocity = owner.position.direction_to(path[1]) * speed

		if owner.position == path[0]:
			path.pop_front()

func generate_path():
	var nav = GlobalNode.get_navigation_node()
	var tp =  get_parent().target_position
	path = nav.get_simple_path(owner.position, tp, true)
	var line = owner.get_node("Line2D")
	line.points = path
