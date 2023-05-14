# Attack2.gd
extends State

@onready var comboTimer = $ComboTimer

var finished_attacking: bool
var rushed_state: String

func enter(_msg := {}) -> void:
	finished_attacking = false
	rushed_state = ""
	owner.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_attack"):
		rushed_state = "Attack3"
	if Input.is_action_just_pressed("player_jump"):
		rushed_state = "Jump"
	if Input.is_action_pressed("ui_down"):
		rushed_state = "Sit"

func update(_delta: float) -> void:
	owner.animationState.travel("Attack2")
	
	if finished_attacking:
		if rushed_state != "":
			state_machine.transition_to(rushed_state)
		if comboTimer.is_stopped():
			state_machine.transition_to("Idle")

func _finished_attack2():
	finished_attacking = true
	comboTimer.start()
