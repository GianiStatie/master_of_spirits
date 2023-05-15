# JumpAttack.gd
extends AbstractAttack

const MAX_FALL_SPEED_X = 230
const MAX_FALL_SPEED_Y = 500
const FALL_ACCELERATION = 42

func enter(_msg := {}) -> void:
	finished_attacking = false
	rushed_state = ""
	attackDebounce.start()

func update(_delta: float) -> void:
	owner.velocity.x = owner.input_vector.x * MAX_FALL_SPEED_X
	owner.velocity.y = move_toward(
		owner.velocity.y, 
		MAX_FALL_SPEED_Y, 
		FALL_ACCELERATION
	)
	
	owner.animationState.travel("JumpAttack")
	
	if owner.is_on_floor():
		state_machine.transition_to("Land")
	
	if finished_attacking and comboTimer.is_stopped():
		state_machine.transition_to("Fall")
	
	if attackDebounce.is_stopped():
		state_machine.transition_to("Fall")
	
