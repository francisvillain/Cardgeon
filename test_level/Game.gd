extends Node2D


func _ready():
	GlobalNode.set_global_node(self)
	GlobalNode.add_cards(5)
	
