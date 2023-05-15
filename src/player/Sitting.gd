# Sitting.gd
extends State

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_jump"):
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("player_attack"):
		state_machine.transition_to("SitAttack")

func update(_delta: float) -> void:
	if Input.get_action_strength("ui_down") == 0:
		state_machine.transition_to("Rise")
	
	owner.animationState.travel("Sitting")
