extends Control

onready var screen_size = get_viewport_rect().size
onready var HandCard = preload("res://ui/ui_cards/HandCard.tscn")

func _ready():
	#add_cards(5)
	pass


func _process(delta):
	pass
	#print(get_viewport_rect().size)



func add_card(status : Dictionary):
	var card = HandCard.instance()
	add_child(card)
	card.launch(status)

func pop_card():
	var cards = get_children()
	if cards:
		cards[0].queue_free()
