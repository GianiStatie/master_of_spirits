# Run.gd
extends State

const MAX_SPEED = 230

@export var drift_debounce_msec = 200

var should_drift: bool
var run_start: float

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO
	should_drift = false
	run_start = Time.get_ticks_msec()

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_down"):
		state_machine.transition_to("Sit")
	if Input.is_action_just_pressed("player_jump"):
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("player_attack"):
		state_machine.transition_to("Attack1")

func update(_delta: float) -> void:
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
	if owner.input_vector.x != 0:
		should_drift = Time.get_ticks_msec() - run_start > drift_debounce_msec
		owner.velocity = owner.input_vector * MAX_SPEED
		owner.animationState.travel("Run")
	elif should_drift:
		state_machine.transition_to("Drift")
	else:
		state_machine.transition_to("Idle")
