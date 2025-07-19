extends CharacterBody2D


var dragging = false
var line_0 : Vector2 = position
var line_1 : Vector2 = position
var line_final : Vector2 = position


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if dragging:
		line_1 = get_global_mouse_position()
		line_final = line_1 - line_0
		draw_line(Vector2(0, 0), line_final, Color.WHITE, 2)

func _on_button_button_down() -> void:
	line_0 = position
	dragging = true

func _on_button_button_up() -> void:
	dragging = false
	position = get_global_mouse_position()
