# SitAttack.gd
extends AbstractAttack


func update(_delta: float) -> void:
	owner.animationState.travel("SitAttack")
	
	if finished_attacking and comboTimer.is_stopped():
		state_machine.transition_to("Sitting")
	
	if attackDebounce.is_stopped():
		state_machine.transition_to("Sitting")
