extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func selectmove(alueet, pelaajanalueet, aialueet):
    var siirto = []
    for lahtoalue in aialueet:
        if alueet[lahtoalue].troops <= 0:
            continue
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if siirto == []:
                siirto = [lahtoalue,legalmove]
            if pelaajanalueet.has(legalmove) && alueet[str(lahtoalue)].troops > alueet[str(legalmove)].troops:
                siirto = [lahtoalue,legalmove]
            elif !pelaajanalueet.has(legalmove) && !aialueet.has(legalmove) && alueet[str(legalmove)].troops > 0:
                siirto = [lahtoalue,legalmove]
    var sleep = randf_range(1, 3)
    await get_tree().create_timer(sleep).timeout
    return siirto
