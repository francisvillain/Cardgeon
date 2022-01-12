extends Area2D

var player = null

signal target_position(new_direction)


func _physics_process(delta):
	if player:
		emit_signal("target_position", player.position)

func _on_DetectPlayer_body_entered(body):
	if body.is_in_group("player"):
		print("Znalazł")
		player = body
	
