extends State


func enter():
	.enter()
	owner.get_node("AnimationPlayer").play("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'die':
		emit_signal("finished",'previous')
		#GlobalNode.restart()
