extends Node2D

signal add_rat()

func _on_button_pressed() -> void:
	emit_signal("add_rat")
