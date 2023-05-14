# Attack3.gd
extends State

@onready var comboTimer = $ComboTimer

var finished_attacking: bool
var rushed_state: String

func enter(_msg := {}) -> void:
	rushed_state = ""
	finished_attacking = false
	owner.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_jump"):
		rushed_state = "Jump"
	if Input.is_action_pressed("ui_down"):
		rushed_state = "Sit"

func update(_delta: float) -> void:
	owner.animationState.travel("Attack3")
	
	if finished_attacking:
		if rushed_state != "":
			state_machine.transition_to(rushed_state)
		if comboTimer.is_stopped():
			state_machine.transition_to("Idle")

func _finished_attack3():
	finished_attacking = true
	comboTimer.start()
