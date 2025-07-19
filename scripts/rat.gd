extends CharacterBody2D


var dragging = false

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var speed = 100.0

func _ready():
	# Começa com pathfinding ativo
	navigation_agent_2d.target_position = global_position

func _physics_process(delta):
	queue_redraw()
	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func set_target_position(pos: Vector2):
	navigation_agent_2d.target_position = pos

func _draw() -> void:
	if dragging:
		var line_final = get_global_mouse_position() - position
		draw_line(Vector2(0, 0), line_final, Color.WHITE, 2)

func _on_button_button_down() -> void:
	dragging = true

func _on_button_button_up() -> void:
	dragging = false
	set_target_position(get_global_mouse_position())
