extends PanelContainer

@onready var state_value = $HBoxContainer/Values/StateValue
@onready var input_vector_value = $HBoxContainer/Values/InputVectorValue
@onready var drift_value = $HBoxContainer/Values/DriftValue
@onready var on_floor_value = $HBoxContainer/Values/OnFloorValue
@onready var velocity_value = $HBoxContainer/Values/VelocityValue

func set_values(values):
	state_value.text = values["state"]
	input_vector_value.text = values["input_vector"]
	drift_value.text = values["should_drift"]
	on_floor_value.text = values["is_on_floor"]
	velocity_value.text = values["velocity"]
