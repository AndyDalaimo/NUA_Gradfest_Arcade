class_name AppTagLabel
extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func anim_tag_label() -> void:
	var t = create_tween().set_trans(Tween.TRANS_SINE).set_parallel(true)
	t.tween_property(self, "scale", Vector2(1.05, 1.05), 0.3)
	await t.finished
	var b = create_tween().set_trans(Tween.TRANS_SINE).set_parallel(true)
	b.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	await b.finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
