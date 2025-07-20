extends CharacterBody2D

var dragging := false
var speed := 50.0
var mode := "waiter" # "waiter" or "chef"
var modes_position := {
	"waiter": Vector2(100, 100),
	"chef": Vector2(100, 100)
}

@onready var rat_sprites := {
	"waiter": preload("res://assets/sprites/rat_waiter2.png"),
	"chef": preload("res://assets/sprites/rat_chef2.png")
}

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var select: Control = $Select
@onready var select_pop_timer: Timer = $SelectPopTimer
@onready var rat_sprite: Sprite2D = $RatSprite


func _ready():
	navigation_agent_2d.target_position = global_position

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta):	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func set_target_position(base:Vector2, variation=0):
	var random_vec := Vector2(
		randf_range(-variation, variation),
		randf_range(-variation, variation)
	)
	
	var new_position = base + random_vec
	
	if new_position.x < 16:
		new_position.x = 16
		
	if new_position.y < 48:
		new_position.y = 48
	elif new_position.y > 172:
		new_position.y = 172
	
	navigation_agent_2d.target_position = new_position

func _draw() -> void:
	if dragging:
		var line_final = get_global_mouse_position() - position
		draw_line(Vector2(0, 0), line_final, Color.WHITE, 1)

func _on_button_button_down() -> void:
	dragging = true

func _on_button_button_up() -> void:
	dragging = false
	set_target_position(get_global_mouse_position())

func _on_rat_button_focus_entered() -> void:
	select.visible = true

func _on_rat_button_focus_exited() -> void:
	select_pop_timer.start()

func _on_select_pop_timer_timeout() -> void:
	select.visible = false

func _on_chef_button_pressed() -> void:
	set_mode("chef")

func _on_waiter_button_pressed() -> void:
	set_mode("waiter")

func set_modes_position(new_modes_position) -> void:
	modes_position = new_modes_position
	print(modes_position)
	
func set_mode(mode):
	mode = mode
	rat_sprite.texture = rat_sprites[mode]
	set_target_position(modes_position[mode], 24)
