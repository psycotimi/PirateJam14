extends Sprite2D

var rotation_speed = PI/3
var suunta = randi_range(-1,1)
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    rotation -= rotation_speed*delta
    pass
