extends CanvasLayer

@onready var health_label: Label = $HealthLabel

func update_health(value: int):
	if health_label:
		health_label.text = "Health: %d" % value
	else:
		push_error("HealthLabel not found!")
