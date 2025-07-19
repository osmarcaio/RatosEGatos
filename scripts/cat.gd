extends CharacterBody2D


var hunger := 100
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


func _ready():
	randomize()

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	var miado_aleatorio = miados[randi() % miados.size()]
	cat_voice.stream = miado_aleatorio
	cat_voice.play()
