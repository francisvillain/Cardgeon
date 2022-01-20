extends Node

func calculate_card_damage(card_status : Dictionary):
	var value = card_status["value"]
	var figures = ["A","J","Q","K"]
	var num_cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
	
	if value in num_cards:
		return int(value)
	if value in figures:
		return 10
