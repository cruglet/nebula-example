extends Nebula2DEditor


func _on_ready() -> void:
	for i: int in randi_range(10, 30):
		var cr: ColorRect = ColorRect.new()
		cr.size = Vector2(32, 32)
		cr.position = Vector2(randi_range(0, 120), randi_range(0, 120)) * 32
		
		add_control(cr)
