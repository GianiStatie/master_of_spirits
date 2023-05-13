# Rise.gd
extends State


func update(_delta: float) -> void:
	owner.animationState.travel("Rise")

func _finished_rising():
	state_machine.transition_to("Idle")
