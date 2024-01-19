extends CanvasLayer


# onready tarkoittaa että koodirivi suoritetaan vain kun scene on ready.
@onready var turnNumber: Label = $TurnCounter/VBoxContainer/TurnNumber
@onready var pbArrow: Label = $TurnCounter/PBArrow
@onready var jamArrow: Label = $TurnCounter/JamArrow
@onready var pbCount: Label = $PBTroopCounter/VBoxContainer/PBTroopCount
@onready var jamCount: Label = $JamTroopCounter/VBoxContainer/JamTroopCount

# Tällä voidaan päivittää vuoronumero Globaalin muuttujan avulla (turnNumber).
func update_turn_counter():
    turnNumber.text = str(Global.turnCounter)

# Tällä voidaan päivittää vuorossa olevan pelaajan merkki Globaalin muuttujan
# avulla (whoseTurn = "none" / "pb" / "jam").
func update_turn_arrow():
    if (Global.whoseTurn == "pb"):
        pbArrow.show()
        jamArrow.hide()
    elif (Global.whoseTurn == "jam"):
        pbArrow.hide()
        jamArrow.show()
    else:
        pbArrow.hide()
        jamArrow.hide()

# Tällä voidaan yksinkertaisesti päivittää sotilaslaskurit.
func update_troop_count():
    pbCount.text = str(Global.pbTroopCount)
    jamCount.text = str(Global.jamTroopCount)
