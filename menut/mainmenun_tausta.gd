extends Node2D

var rotation_speed = PI/13
var posx:float
var posy:float
var phase: float
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    phase -= rotation_speed*delta
    posx = 800*sin(phase+PI/3)
    posy = -800*cos(phase)
    position = Vector2(posx,posy)
    pass
