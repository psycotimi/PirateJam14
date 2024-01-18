extends Node2D

var rotation_speed = PI/10
var posx:float
var posy:float
var phase: float
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    phase -= rotation_speed*delta
    posx = 500*sin(phase)
    posy = 500*cos(phase)
    position = Vector2(posx,posy)
    pass
