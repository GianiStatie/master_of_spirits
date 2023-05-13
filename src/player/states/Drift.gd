# Drift.gd
extends State

const FRICTION = 6.2e2

func enter(_msg := {}) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Run")
	if Input.is_action_pressed("ui_down"):
		state_machine.transition_to("Sit")
	if Input.is_action_just_pressed("player_jump"):
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("player_attack"):
		state_machine.transition_to("Attack1")

func update(delta: float) -> void:
	owner.velocity = owner.velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	owner.animationState.travel("Drift")
	
	if owner.velocity == Vector2.ZERO:
		state_machine.transition_to("Idle")
