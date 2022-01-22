extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var die = $Die
onready var attack = $Attack

var cards_amount = 5
var target_position : Vector2
var r_mouse_pressed : bool

func _ready():
	r_mouse_pressed = false
	target_position = owner.get_global_position()
	states_map = {
		"idle": idle,
		"move": move,
		"attack": attack,
		"die": die
	}
	for child in [idle, move, attack]:
		var err = child.connect("change_target_position", owner, "_change_target_position")
		if err:
			printerr(err)


func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["attack"]:
		states_stack.push_front(states_map[state_name])

	._change_state(state_name)

func _physics_process(delta):
	if r_mouse_pressed:
		get_mouse_data()

func _unhandled_input(event):
	if event.is_action_pressed("right_click"):
		r_mouse_pressed = true
	if event.is_action_released("right_click"):
		r_mouse_pressed = false

	current_state.handle_input(event)

func get_mouse_data():
		target_position = owner.get_local_mouse_position() + owner.position
		if current_state == idle:
			idle.start_moving()
		if current_state == attack:
			states_stack[1] = states_map["move"]
		if current_state == move:
			move.emit_signal("change_target_position",owner.get_global_mouse_position())

func get_cards_amount():
	return cards_amount
	
func set_cards_amount(value):
	cards_amount = value

func add_one_card():
	cards_amount += 1 

func pop_one_card():
	cards_amount -= 1 

