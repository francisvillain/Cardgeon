extends Position2D

onready var CardScene = preload("res://card/CardBullet.tscn") 


func _ready():
	pass # Replace with function body.


func _on_Attack_throw_card():
	var card = CardScene.instance()
	GlobalNode.add_bullet_card(card)
	card.set_global_position(self.get_global_position())
	var dir : Vector2 = get_global_mouse_position() - self.get_global_position()
	card.throw(dir.normalized())
	var status = owner.Cards.pop_front()
	card.launch(status)
