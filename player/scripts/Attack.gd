extends State

signal throw_card
signal change_target_position(pos)

func enter():
	.enter()
	owner.get_node("AnimationPlayer").play("attack")
	emit_signal("throw_card")
	owner.pop_card()
	
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'attack':
		emit_signal("finished",'previous')

