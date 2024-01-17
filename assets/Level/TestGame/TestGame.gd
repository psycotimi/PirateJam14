extends Node2D


# This is just for testing.
# You can just "Play This Scene" to test.

# Import Battle.gd script to use the functions.
const battleScripts = preload("res://scripts/Battle.gd")
var selectedTile
var targetTile

func _ready():
    var battle = battleScripts.new()

    for roll in range(10):
        var attackerWon = battle.did_attacker_win(3, 3)
        if attackerWon:
            print("Attacker won!")
        else:
            print("Defender won!")
        print()

func _input(event):
    if Input.is_action_just_pressed("select_tile"):
        if selectedTile != null:
            targetTile = $gamegrid.get_tile_under_mouse()
        else:
            selectedTile = $gamegrid.get_tile_under_mouse()    
        print(selectedTile, targetTile) 
        
#    if event is InputEventMouseButton:
#        print("Mouse click at: ", event.position)
