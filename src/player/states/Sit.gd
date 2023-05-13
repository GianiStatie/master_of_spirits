# Sit.gd
extends State

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("ui_down"):
		state_machine.transition_to("Rise")

func update(delta: float) -> void:
	owner.animationState.travel("Sit")
