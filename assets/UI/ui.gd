extends CanvasLayer


# onready tarkoittaa että koodirivi suoritetaan vain kun scene on ready.
@onready var turnNumber: Label = $TurnCounter/VBoxContainer/TurnNumber
@onready var pbArrow: Label = $TurnCounter/PBArrow
@onready var jamArrow: Label = $TurnCounter/JamArrow
@onready var pbCount: Label = $PBTroopCounter/VBoxContainer/PBTroopCount
@onready var jamCount: Label = $JamTroopCounter/VBoxContainer/JamTroopCount

func _ready():
    $PauseMenu.hide()

# Tällä voidaan päivittää vuoronumero Globaalin muuttujan avulla (turnNumber).
func update_turn_counter():
    turnNumber.text = str(Global.turnCounter + 1)

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

# Pausetetaan peli ja avataan pause menu.
func _on_pause_button_pressed():
    await buttonsound()
    get_tree().paused = true
    $PauseMenu.show()

func buttonsound():
    $buttonsound.pitch_scale = randf_range(2,3)
    $buttonsound.play()
    await get_tree().create_timer(0.1).timeout
