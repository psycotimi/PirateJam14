extends Node2D


# This is just for testing.
# You can just "Play This Scene" to test.

# Import Battle.gd script to use the functions.
const battleScripts = preload("res://scripts/Battle.gd")
@onready var uiNode = $UI

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

	# Arvojen muuttaminen debuggaukseen
	Global.turnCounter = 3
	Global.pbTroopCount = 10
	Global.jamTroopCount = 4
	Global.whoseTurn = "pb"
	# Tässä käytetään kahta vaihtoehtoista tapaa päivittää UI
	uiNode.update_turn_counter()
	$UI.update_turn_arrow()
	uiNode.update_troop_count()
	
	
