extends Node2D

var is_game_over = false
var rat_scene := preload("res://scenes/rat.tscn")
var cat_scene := preload("res://scenes/cat.tscn")
var ingredients := {
	"meat": 5,
	"fish": 10,
	"sauce": 15,
	"lettuce": 20,
	"tomato": 25,
	"potato": 30
}
var total_ingredients = 0
var cheese_quantity = 38
var game_level = 1

@onready var modes_position := {
	"waiter" = $Markers/WaiterPosition.position,
	"chef" = $Markers/ChefPosition.position
}
@onready var rats: Node2D = $Rats
@onready var cats: Node2D = $Cats
@onready var meat_label: Label = $Control/RightInterface/MeatBox/MeatLabel
@onready var fish_label: Label = $Control/RightInterface/FishBox/FishLabel
@onready var sauce_label: Label = $Control/RightInterface/SauceBox/SauceLabel
@onready var lettuce_label: Label = $Control/RightInterface/LettuceBox/LettuceLabel
@onready var tomato_label: Label = $Control/RightInterface/TomatoBox/TomatoLabel
@onready var potato_label: Label = $Control/RightInterface/PotatoBox/PotatoLabel
@onready var cheese_label: Label = $Control/LeftInterface/CheeseBox/CheeseLabel
@onready var cat_timer: Timer = $Timers/CatTimer
@onready var game_over_timer: Timer = $Timers/GameOverTimer

@onready var plate: Node2D = %Plate
@onready var plate_label: Label = $Furniture/Plate/PlateLabel


func reset_ingredients():
	ingredients = {
		"meat": 0,
		"fish": 0,
		"sauce": 0,
		"lettuce": 0,
		"tomato": 0,
		"potato": 0
	}

func _ready() -> void:
	spawn_rat()
	spawn_cat()
	spawn_cat()
	spawn_cat()
	plate.change_image()

func _process(_delta: float) -> void:
	update_hud()
	
	var total_ingredients_calculated = 0
	for value in ingredients.values():
		total_ingredients_calculated += value
	total_ingredients = total_ingredients_calculated
	
	plate_label.text = str(total_ingredients)
	
	if not is_game_over:
		var all_rats = rats.get_children()
		if not all_rats:
			game_over()

func update_hud():
	meat_label.text = str(ingredients["meat"])
	fish_label.text = str(ingredients["fish"])
	sauce_label.text = str(ingredients["sauce"])
	lettuce_label.text = str(ingredients["lettuce"])
	tomato_label.text = str(ingredients["tomato"])
	potato_label.text = str(ingredients["potato"])
	cheese_label.text = str(cheese_quantity)

func _unhandled_input(event): # Ao clicar em nenhum botão
	if event is InputEventMouseButton and event.pressed:
		var focused = get_viewport().gui_get_focus_owner()
		if focused:
			focused.release_focus()

func _on_rat_button_add_rat() -> void:
	if cheese_quantity >= 15:
		cheese_quantity -= 15
		spawn_rat()

func spawn_rat():
	var rat_instance = rat_scene.instantiate()
	rat_instance.position = $Markers/StarterPosition.position
	rat_instance.set_modes_position(modes_position)
	rats.add_child(rat_instance)
	rat_instance.association_event.connect(_on_rat_association_event)
	rat_instance.rat_eaten.connect(_on_rat_eaten_event)
	rat_instance.set_target_position($Markers/EntryPosition.position, 16) 

func spawn_cat():
	var cat_instance = cat_scene.instantiate()
	cat_instance.position = $Markers/StarterPosition.position
	cats.add_child(cat_instance)
	cat_instance.set_hunger_max(100 + game_level*10)
	cat_instance.hungry_mode.connect(_on_cat_hungry_mode_event)
	cat_instance.cat_satisfied.connect(_on_cat_satisfied_event)
	cat_instance.cat_left.connect(_on_cat_left_event)
	cat_instance.set_target_position($Markers/CatPosition.position, 70) 

func _on_rat_association_event(rat, collider):	
	if collider.is_in_group("interactive"):
		if collider.is_in_group("stoves"):
			var rat_associated = collider.associated_worker
			if rat_associated and rat != rat_associated:
				rat_associated.set_associated_object()
			
			collider.set_associated_worker(rat)
			rat.set_associated_object(collider)
			
			rat.set_mode("chef")
			var worker_position = collider.get_node("WorkerPosition").global_position
			rat.set_target_position(worker_position, 0)
			
		elif collider.is_in_group("cutting_boards"):
			var rat_associated = collider.associated_worker
			if rat_associated and rat != rat_associated:
				rat_associated.set_associated_object()
			
			collider.associated_worker = rat
			rat.associated_object = collider
			
			rat.set_mode("chef")
			var worker_position = collider.get_node("WorkerPosition").global_position
			rat.set_target_position(worker_position, 0)
		
		elif collider.is_in_group("counters"):
			if rat.mode != "waiter":
				rat.set_mode("waiter")

func _on_food_produced(food: String, quantity: int) -> void:
	ingredients[food] += quantity

func _on_cat_hungry_mode_event(cat):
	var all_rats = rats.get_children()
	if all_rats:
		var rat = all_rats.pick_random()
		cat.eat_rat(rat)

func _on_rat_eaten_event(rat):
	rat.queue_free()

func _on_cat_satisfied_event(cat):
	cat.finish($Markers/StarterPosition.position)
	cheese_quantity += 4

func _on_cat_left_event(cat):
	cat.queue_free()

func game_over():
	Engine.time_scale = 0.1
	is_game_over = true
	game_over_timer.start()

func _on_game_over_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_cat_timer_timeout() -> void:
	spawn_cat()
	game_level += 1
