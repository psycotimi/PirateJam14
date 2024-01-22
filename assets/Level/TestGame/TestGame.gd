extends Node2D


# This is just for testing.
# You can just "Play This Scene" to test.

# Import Battle.gd script to use the functions.
const battleScripts = preload("res://scripts/Battle.gd")

var selectedTile
var targetTile

func _ready():
    # Arvojen muuttaminen debuggaukseen
    Global.pbTroopCount = 10
    Global.jamTroopCount = 4
    Global.whoseTurn = "pb"
