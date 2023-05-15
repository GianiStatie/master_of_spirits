extends State

var finished_attacking: bool

@onready var comboTimer = $ComboTimer
@onready var attackDebounce = $AttackDebounce 

func enter(_msg := {}) -> void:
	finished_attacking = false
	attackDebounce.start()
	owner.velocity = Vector2.ZERO

func update(_delta: float) -> void:
	owner.animationState.travel("SitAttack")
	
	if finished_attacking and comboTimer.is_stopped():
		state_machine.transition_to("Sitting")
	
	if attackDebounce.is_stopped():
		state_machine.transition_to("Sitting")

func _finished_sit_attack():
	comboTimer.start()
	finished_attacking = true
