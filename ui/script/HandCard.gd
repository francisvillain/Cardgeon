extends TextureRect

var colors = {
	"diamond" : Color(0, 0.64, 0.84, 1),
	"heart" : Color(0.68, 0, 0.18, 1),
	"club" : Color(0.03, 0.94, 0.19, 1),
	"spade" : Color(0.5,0.03,0.94, 1)
}

func _ready():
	pass # Replace with function body.

func launch(status : Dictionary):
	set_self_modulate(colors[status["suit"]])
	$Label.set_text(status["value"])
	
