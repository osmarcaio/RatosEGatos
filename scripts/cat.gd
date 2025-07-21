extends CharacterBody2D

signal hungry_mode(cat)
signal cat_satisfied(cat)
signal cat_left(cat)

var speed := randf_range(50, 100)
var hunger_max := 100.0
var hunger := 50.0
var hunger_loss = randf_range(1, 3)
var hunger_loss_extra = 1.01
var rat_to_eat = null
var in_hungry_mode = false
var exit_position = null

var miados := [
	load("res://assets/sounds/cat/cat_angry.wav"),
	load("res://assets/sounds/cat/cat_hungry.wav"),
	load("res://assets/sounds/cat/cat_meow.wav"),
	load("res://assets/sounds/cat/cat_meow_cartoon.wav"),
	load("res://assets/sounds/cat/cat_meow_meow.wav"),
	load("res://assets/sounds/cat/cat_meow_attention.wav"),
	load("res://assets/sounds/cat/cat_pain.wav"),
]

@onready var cat_voice: AudioStreamPlayer = $CatVoice
@onready var progress_bar_area: Control = $ProgressBarArea
@onready var progress_bar: ColorRect = $ProgressBarArea/ProgressBar
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var cat_position: Marker2D = $"../../Markers/CatPosition"
@onready var hunger_timer: Timer = $HungerTimer
@onready var sprite_1: Sprite2D = $Sprite1
@onready var sprite_2: Sprite2D = $Sprite2


func _ready():
	randomize()

func _process(_delta: float) -> void:
	update_progress_bar()
	
	if hunger >= hunger_max and not exit_position:
		emit_signal("cat_satisfied", self)
		
	
	if in_hungry_mode and not exit_position:
		if rat_to_eat:
			set_target_position(rat_to_eat.position)
			var distancia = rat_to_eat.position.distance_to(position)
			if distancia < 16:
				rat_to_eat.eaten()
				
				sprite_1.visible = false
				sprite_2.visible = true
				
				in_hungry_mode = false
				hunger = -100
				emit_signal("cat_satisfied", self)
		else:
			emit_signal("hungry_mode", self)
	
	if exit_position:
		var distancia = exit_position.distance_to(position)
		if distancia < 16:
			emit_signal("cat_left", self)
			exit_position = null
		
	
func _physics_process(_delta):	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_button_pressed() -> void:
	var miado_aleatorio = miados[randi() % miados.size()]
	cat_voice.stream = miado_aleatorio
	cat_voice.play()
	
	var main = get_node("/root/Main")
	var food = main.total_ingredients
	hunger += food
	main.reset_ingredients()
	main.plate.change_image()

func update_progress_bar():
	var progress_bar_size = progress_bar_area.size.x
	var progress_bar_percent = hunger / hunger_max
	progress_bar.size.x = progress_bar_percent * progress_bar_size
	
func _on_hunger_timer_timeout() -> void:
	hunger -= hunger_loss
	hunger_loss *= hunger_loss_extra
	
	if hunger <= 0:
		cat_voice.stream = miados[1]
		cat_voice.play()	
		emit_signal("hungry_mode", self)
		in_hungry_mode = true
		hunger_timer.stop()
		
func set_target_position(base:Vector2, variation=0):
	var random_vec := Vector2(
		randf_range(-variation, variation),
		randf_range(-variation, variation)
	)
	
	var new_position = base + random_vec
	
	navigation_agent_2d.target_position = new_position

func eat_rat(rat):
	rat_to_eat = rat

func finish(new_exit_position):
	exit_position = new_exit_position
	set_target_position(exit_position)

func set_hunger_max(new_hunger_max):
	hunger_max = new_hunger_max
