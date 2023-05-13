# Attack2.gd
extends State

@onready var comboTimer = $ComboTimer

var finished_attacking: bool
var combo_attack: bool

func enter(_msg := {}) -> void:
	finished_attacking = false
	combo_attack = false
	owner.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_attack"):
		combo_attack = true

func update(_delta: float) -> void:
	owner.animationState.travel("Attack2")
	
	if finished_attacking:
		if combo_attack:
			state_machine.transition_to("Attack3")
		if comboTimer.is_stopped():
			state_machine.transition_to("Idle")

func _finished_attack2():
	finished_attacking = true
	comboTimer.start()
