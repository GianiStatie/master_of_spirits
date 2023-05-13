# Attack3.gd
extends State

@onready var comboTimer = $ComboTimer

var finished_attacking: bool

func enter(_msg := {}) -> void:
	finished_attacking = false
	owner.velocity = Vector2.ZERO

func update(_delta: float) -> void:
	owner.animationState.travel("Attack3")
	
	if finished_attacking and comboTimer.is_stopped():
		state_machine.transition_to("Idle")

func _finished_attack3():
	finished_attacking = true
	comboTimer.start()
