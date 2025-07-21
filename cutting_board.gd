extends StaticBody2D

var type = "cutting_board"
var associated_worker = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_associated_worker(worker=null):
	associated_worker = worker
