extends CharacterBody2D

const MAX_SPEED = 2.3e2
const FRICTION = 5.2e2
const JUMP_STRENGTH = 200
const MAX_JUMP_SPEED = 230

var input_vector = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var debugConsole = $"../CanvasLayer/DebugConsole"

var run_start = 0
var should_drift = false
var drift_debounce_msec = 200

enum {
	IDLE,
	MOVE,
	DRIFT,
	SIT,
	RAISE,
	JUMP,
	FALL
}
var state_names = ["idle", "move", "drift", "sit", "raise", "jump", "fall"]
var state = IDLE

var state_values = {
	"state": "not_set",
	"input_vector": "not_set",
	"should_drift": "not_set"
}

func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta)
		MOVE:
			move_state(delta)
		DRIFT:
			drift_state(delta)
		SIT:
			sit_state(delta)
		RAISE:
			raise_state(delta)
		JUMP:
			jump_state(delta)
		FALL:
			fall_state(delta)
	
	state_values["input_vector"] = str(input_vector)
	state_values["should_drift"] = str(should_drift)
	state_values["state"] = state_names[state]
	debugConsole.set_values(state_values)
	move_and_slide()

func idle_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Idle")
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		run_start = Time.get_ticks_msec()
		state = MOVE
	if Input.is_action_pressed("ui_down"):
		state = SIT

func move_state(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	if Input.is_action_pressed("ui_down"):
		state = SIT
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED
		sprite.scale.x = sign(input_vector.x)
		animationState.travel("Run")
		should_drift = Time.get_ticks_msec() - run_start > drift_debounce_msec
	elif should_drift:
		should_drift = false
		state = DRIFT
	else:
		state = IDLE

func drift_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	animationState.travel("Drift")
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		run_start = Time.get_ticks_msec()
		state = MOVE
	if Input.is_action_pressed("ui_down"):
		state = SIT
	elif velocity == Vector2.ZERO:
		state = IDLE

func sit_state(delta):
	should_drift = false
	velocity = Vector2.ZERO
	animationState.travel("Sit")
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input_vector != Vector2.ZERO:
		sprite.scale.x = sign(input_vector.x)
	
	if Input.is_action_just_released("ui_down"):
		state = RAISE

func raise_state(delta):
	animationState.travel("Raise")

func _fully_raised():
	state = IDLE

func jump_state(delta):
	input_vector.y = -1
	velocity = input_vector * MAX_SPEED
	animationState.travel("Jump")
	if Input.is_action_just_released("player_jump"):
		state = FALL

func fall_state(delta):
	input_vector.y = 1
	velocity = input_vector * MAX_SPEED
