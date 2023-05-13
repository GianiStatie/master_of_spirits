# Idle.gd
extends State

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_down"):
		state_machine.transition_to("Sit")
	if Input.is_action_just_pressed("player_jump"):
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("player_attack"):
		state_machine.transition_to("Attack1")

func update(_delta: float) -> void:
	if owner.input_vector.x != 0:
		state_machine.transition_to("Run")
	
	owner.animationState.travel("Idle")
