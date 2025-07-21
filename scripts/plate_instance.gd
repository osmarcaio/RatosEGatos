extends Node2D

var empty_plate = load("res://assets/sprites/plate.png")
var plates = [
	load("res://assets/sprites/plate1.png"),
	load("res://assets/sprites/plate2.png"),
	load("res://assets/sprites/plate3.png"),
	load("res://assets/sprites/plate4.png"),
]
var food_quantity = 0
var empty = false

@onready var plate_sprite: Sprite2D = $PlateSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
			
func change_image():
	var sprite_random = plates[randi() % plates.size()]
	plate_sprite.texture = sprite_random

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
