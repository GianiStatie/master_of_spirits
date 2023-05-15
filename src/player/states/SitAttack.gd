extends State

var finished_attacking: bool

@onready var attackDebounce = $AttackDebounce 

func enter(_msg := {}) -> void:
	finished_attacking = false
	attackDebounce.start()
	owner.velocity = Vector2.ZERO

func update(_delta: float) -> void:
	owner.animationState.travel("SitAttack")
	
	if finished_attacking or attackDebounce.is_stopped():
		state_machine.transition_to("Sitting")

func _finished_sit_attack():
	finished_attacking = true
