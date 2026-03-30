class_name AppSelectButton extends Button


signal app_selected(app_index)

var app_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	emit_signal("app_selected", app_index)
