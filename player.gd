extends CharacterBody2D

const MAX_SPEED = 2.3e2
const FRICTION = 6.2e2
const JUMP_ACCELERATION = 42
const MAX_JUMP_SPEED = 550
const MAX_FALL_SPEED = 550

var input_vector = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var debugConsole = $"../CanvasLayer/DebugConsole"
@onready var attackComboTimer = $AttackComboTimer

var run_start = 0
var should_drift = false
var should_jump = false
var drift_debounce_msec = 200
var finished_attacking = false
var attack_combo = false
var attack_index = 0

enum {
	IDLE,
	MOVE,
	DRIFT,
	SIT,
	RAISE,
	JUMP,
	FALL,
	LAND,
	ATTACK,
	ATTACK2,
	ATTACK3
}
var state_names = ["idle", "move", "drift", "sit", "raise", "jump", "fall", "land", "attack", "attack2", "attack3"]
var state = IDLE

var state_values = {
	"state": "not_set",
	"input_vector": "not_set",
	"velocity": "not_set",
	"should_drift": "not_set",
	"is_on_floor": "not_set"
}

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
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
		LAND:
			land_state(delta)
		ATTACK:
			attack_state(delta)
		ATTACK2:
			attack_state(delta)
		ATTACK3:
			attack_state(delta)
	
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
	
	state_values["input_vector"] = str(input_vector)
	state_values["should_drift"] = str(should_drift)
	state_values["velocity"] = str(velocity)
	state_values["state"] = state_names[state]
	state_values["is_on_floor"] = str(is_on_floor())
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
	if Input.is_action_just_pressed("player_jump"):
		state = JUMP
	if Input.is_action_just_pressed("player_attack"):
		finished_attacking = false
		state = ATTACK

func move_state(delta):
	var is_move_key_pressed = Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED
		animationState.travel("Run")
		should_drift = Time.get_ticks_msec() - run_start > drift_debounce_msec
	elif should_drift and not is_move_key_pressed:
		state = DRIFT
	else:
		state = IDLE
	
	if Input.is_action_pressed("ui_down"):
		state = SIT
	if Input.is_action_just_pressed("player_jump"):
		state = JUMP
	if Input.is_action_just_pressed("player_attack"):
		finished_attacking = false
		state = ATTACK
	if not is_on_floor():
		state = FALL
	
	if state != MOVE:
		should_drift = false

func drift_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	animationState.travel("Drift")
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		run_start = Time.get_ticks_msec()
		state = MOVE
	if Input.is_action_just_pressed("player_jump"):
		state = JUMP
	if Input.is_action_pressed("ui_down"):
		state = SIT
	elif velocity == Vector2.ZERO:
		state = IDLE
	if Input.is_action_just_pressed("player_attack"):
		finished_attacking = false
		state = ATTACK
	if not is_on_floor():
		state = FALL

func sit_state(delta):
	should_drift = false
	velocity = Vector2.ZERO
	animationState.travel("Sit")
	
	if Input.is_action_just_released("ui_down"):
		state = RAISE
	if Input.is_action_just_pressed("player_jump"):
		state = JUMP

func raise_state(delta):
	animationState.travel("Raise")

func _fully_raised():
	state = IDLE

func jump_state(delta):
	should_drift = false
	input_vector.y = -1
	velocity.y = move_toward(velocity.y, -MAX_JUMP_SPEED, JUMP_ACCELERATION)
	velocity.x = input_vector.x * MAX_SPEED * 0.85
	animationState.travel("Jump")
	
	if Input.is_action_just_released("player_jump") or velocity.y == -MAX_JUMP_SPEED:
		state = FALL

func fall_state(delta):
	input_vector.y = 1
	velocity.y = move_toward(velocity.y, MAX_FALL_SPEED, JUMP_ACCELERATION)
	velocity.x = input_vector.x * MAX_SPEED * 0.85
	animationState.travel("Fall")
	
	if is_on_floor():
		state = LAND

func land_state(delta):
	input_vector.y = 0
	velocity = Vector2.ZERO
	animationState.travel("Land")
	
	if input_vector.x != 0:
		state = MOVE
	if Input.is_action_just_pressed("player_jump"):
		state = JUMP
	if Input.is_action_pressed("ui_down"):
		state = SIT
	if Input.is_action_just_pressed("player_attack"):
		finished_attacking = false
		state = ATTACK

func _fully_landed():
	state = IDLE
	
	if Input.is_action_just_pressed("player_jump"):
		state = JUMP

func attack_state(delta):
	velocity = Vector2.ZERO
	
	match attack_index:
		0:
			animationState.travel("Attack")
		1:
			animationState.travel("Attack2")
		2:
			animationState.travel("Attack3")
	
	if Input.is_action_just_pressed("player_attack"):
		attack_combo = true
	
	if Input.is_action_just_pressed("player_jump"):
		should_jump = true
	
	if finished_attacking:
		if attack_combo and attack_index < 2:
			attack_index += 1
			finished_attacking = false
		elif should_jump:
			should_jump = false
			state = JUMP
		elif attackComboTimer.is_stopped() or input_vector.x != 0:
			attack_index = 0
			state = IDLE
		attack_combo = false

func _finished_attacking():
	finished_attacking = true
	attackComboTimer.start()
