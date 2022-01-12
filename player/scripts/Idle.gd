extends Motion


func enter():
	.enter()
	owner.get_node("AnimationPlayer").play("idle")
	emit_signal("change_target_position", owner.get_global_position())

func handled_input(event):
	return .handle_input(event)

func start_moving():
	emit_signal("finished", "move")
