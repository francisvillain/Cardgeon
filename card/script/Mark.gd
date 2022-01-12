extends Area2D

var id : int

func launch(card_id):
	id = card_id

func _on_Mark_body_entered(body):
	if id == body.get_id():
		body.card_land()
		queue_free()
