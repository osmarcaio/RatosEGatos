extends Node2D


var rat_scene := preload("res://scenes/rat.tscn")

@onready var modes_position := {
	"waiter" = $Markers/WaiterPosition.position,
	"chef" = $Markers/ChefPosition.position
}
@onready var rats: Node2D = $Rats


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _unhandled_input(event): # Ao clicar em nenhum botão
	if event is InputEventMouseButton and event.pressed:
		var focused = get_viewport().gui_get_focus_owner()
		if focused:
			focused.release_focus()

		if event.button_index == MOUSE_BUTTON_RIGHT:
			spawn_rat()

func spawn_rat():
	var rat_instance = rat_scene.instantiate()
	rat_instance.position = $Markers/StarterPosition.position
	rat_instance.set_modes_position(modes_position)
	rats.add_child(rat_instance)
	rat_instance.set_target_position($Markers/EntryPosition.position, 16) 
