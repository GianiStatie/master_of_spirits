# AbstractAttack.gd
extends State
class_name AbstractAttack

@onready var comboTimer = $ComboTimer
@onready var attackDebounce = $AttackDebounce

var finished_attacking: bool
var rushed_state: String

func enter(_msg := {}) -> void:
	finished_attacking = false
	rushed_state = ""
	attackDebounce.start()
	owner.velocity = Vector2.ZERO

func _on_finished_attack():
	finished_attacking = true
	comboTimer.start()
