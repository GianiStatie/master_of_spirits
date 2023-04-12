extends CharacterBody2D

const MAX_SPEED = 2.3e2
const ACCELERATION = 2.5e3
const FRICTION = 5.2e2

var input_vector = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var debugConsole = $"../CanvasLayer/DebugConsole"

var run_start = 0
var should_drift = false
var drift_debounce_msec = 200

var state_values = {
	"state": "not_set",
	"input_vector": "not_set",
	"should_drift": "not_set"
}

func _input(event):
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		should_drift = false
		run_start = Time.get_ticks_msec()

func _process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	state_values["input_vector"] = str(input_vector)
	state_values["should_drift"] = str(should_drift)
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED
		sprite.scale.x = sign(input_vector.x)
		animationState.travel("Run")
		state_values["state"] = "run"
		should_drift = Time.get_ticks_msec() - run_start > drift_debounce_msec
	elif should_drift:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Drift")
		state_values["state"] = "drift"
	else:
		velocity = Vector2.ZERO
		animationState.travel("Idle")
		state_values["state"] = "idle"
	
	debugConsole.set_values(state_values)
	
	move_and_slide()

func unset_player_drift():
	should_drift = false
