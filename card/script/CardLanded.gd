extends Area2D

var status = {}



func launch(new_status):
	status  = new_status


func _on_CardLanded_body_entered(body):
	if body.is_in_group("player"):
		body.add_card(status)
		queue_free()
