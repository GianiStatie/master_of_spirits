# Fall.gd
extends State

const MAX_FALL_SPEED_X = 230
const MAX_FALL_SPEED_Y = 500
const FALL_ACCELERATION = 42

func enter(_msg := {}) -> void:
	owner.input_vector.y = 1

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	owner.velocity.x = owner.input_vector.x * MAX_FALL_SPEED_X
	owner.velocity.y = move_toward(
		owner.velocity.y, 
		MAX_FALL_SPEED_Y, 
		FALL_ACCELERATION
	)
	owner.animationState.travel("Fall")
	
	if owner.is_on_floor():
		state_machine.transition_to("Land")
