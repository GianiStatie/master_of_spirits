extends PanelContainer

@onready var state_value = $HBoxContainer/Values/StateValue
@onready var input_vector_value = $HBoxContainer/Values/InputVectorValue
@onready var drift_value = $HBoxContainer/Values/DriftValue

func set_values(values):
	state_value.text = values["state"]
	input_vector_value.text = values["input_vector"]
	drift_value.text = values["should_drift"]
