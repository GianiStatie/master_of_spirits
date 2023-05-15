extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var debugConsole = $"../CanvasLayer/DebugConsole"
@onready var stateMachine = $StateMachine

@onready var runState = $StateMachine/Run
@onready var sitAttackState = $StateMachine/SitAttack

var input_vector = Vector2.ZERO

var state_values = {
	"state": "not_set",
	"input_vector": "not_set",
	"velocity": "not_set",
	"should_drift": "not_set",
	"is_on_floor": "not_set",
}

func _process(_delta):
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
	
	state_values["input_vector"] = str(input_vector)
	state_values["velocity"] = str(velocity)
	state_values["should_drift"] = str(runState.should_drift)
	state_values["state"] = stateMachine.state.name
	state_values["is_on_floor"] = str(is_on_floor())
	debugConsole.set_values(state_values)

func _physics_process(_delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	move_and_slide()
