# Land.gd
extends State

func enter(_msg := {}) -> void:
	owner.input_vector.y = 0
	owner.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_jump"):
		state_machine.transition_to("Jump")

func update(_delta: float) -> void:
	owner.animationState.travel("Land")
	
	if Input.is_action_pressed("ui_down"):
		state_machine.transition_to("Sit")
	
	if owner.input_vector.x != 0:
		state_machine.transition_to("Run")

func _finished_landing():
	state_machine.transition_to("Idle")
