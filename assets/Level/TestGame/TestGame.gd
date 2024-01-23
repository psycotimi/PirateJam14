extends Node2D


# This is just for testing.
# You can just "Play This Scene" to test.

# Import Battle.gd script to use the functions.
const battleScripts = preload("res://scripts/Battle.gd")

var selectedTile
var targetTile

func _ready():
    Global.turnCounter = 0
    Global.pbTroopCount = 5
    Global.jamTroopCount = 5
