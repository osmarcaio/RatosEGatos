extends StaticBody2D

signal food_produced(food:String, quantity:int)

var associated_worker = null
var selected_food := "none"
var foods := {
	"lettuce": 0.5,
	"tomato": 5,
}
var food_mult = {
	"lettuce": 1,
	"tomato": 15,
}

@onready var select: Control = $Select
@onready var select_pop_timer: Timer = $SelectPopTimer
@onready var food_timer: Timer = $FoodTimer
@onready var worker_position: Marker2D = $WorkerPosition
@onready var progress_bar_area: Control = $ProgressBarArea
@onready var progress_bar: ColorRect = $ProgressBarArea/ProgressBar
@onready var sprite_1: Sprite2D = $Sprite1
@onready var sprite_2: Sprite2D = $Sprite2

func _ready() -> void:
	print("CUTTING")
	set_selected_food("lettuce")

func _process(_delta: float) -> void:
	update_progress_bar()


func _on_main_button_pressed() -> void:
	select.visible = true

func _on_stove_button_focus_exited() -> void:
	select_pop_timer.start()

func _on_select_pop_timer_timeout() -> void:
	select.visible = false

func _on_lettuce_button_button_down() -> void:
	set_selected_food("lettuce")

func _on_tomato_button_button_down() -> void:
	set_selected_food("tomato")

func set_selected_food(new_food):
	selected_food = new_food
	food_timer.wait_time = foods[new_food]
	if associated_worker:
		food_timer.start(0)


func set_associated_worker(new_worker=null):	
	if new_worker:
		sprite_1.visible = false
		sprite_2.visible = true
		progress_bar.visible = true
		
		food_timer.start(0)
	else:
		sprite_1.visible = true
		sprite_2.visible = false
		progress_bar.visible = false
		
		food_timer.stop()

	associated_worker = new_worker

func _on_food_timer_timeout() -> void:
	emit_signal("food_produced", selected_food, food_mult[selected_food])

func update_progress_bar():
	var progress_bar_size = progress_bar_area.size.x
	var progress_bar_limit = food_timer.wait_time
	var actual_progress_bar = progress_bar_limit - food_timer.time_left
	var progress_bar_percent = actual_progress_bar / progress_bar_limit
	progress_bar.size.x = progress_bar_percent * progress_bar_size
	
