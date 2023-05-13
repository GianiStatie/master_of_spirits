# Jump.gd
extends State

const MAX_JUMP_SPEED_X = 230
const MAX_JUMP_SPEED_Y = 550
const JUMP_ACCELERATION = 42

func enter(_msg := {}) -> void:
	owner.input_vector.y = -1

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("player_jump"):
		state_machine.transition_to("Fall")

func update(_delta: float) -> void:
	owner.velocity.x = owner.input_vector.x * MAX_JUMP_SPEED_X
	owner.velocity.y = move_toward(
		owner.velocity.y, 
		-MAX_JUMP_SPEED_Y, 
		JUMP_ACCELERATION
	)
	owner.animationState.travel("Jump")
	
	if owner.velocity.y == -MAX_JUMP_SPEED_Y:
		state_machine.transition_to("Fall")
