extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass


func selectmove(alueet, pelaajanalueet, aialueet):
    var siirto = []
    var pelaajanspread = alueet[str(pelaajanalueet[0])].spread
    #edes joku siirto
    for lahtoalue in aialueet:
        if alueet[lahtoalue].troops <= 0:
            aialueet.erase(lahtoalue)
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            siirto = [lahtoalue,legalmove]
        
    # liikkuu leivälle
    for lahtoalue in aialueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if alueet[str(legalmove)].spread != alueet[str(lahtoalue)].spread:
                siirto = [lahtoalue,legalmove]
                
    # liikkuu leivälle jos saa ukkoja
    for lahtoalue in aialueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if alueet[str(legalmove)].spread != pelaajanspread && alueet[str(legalmove)].troops > 0:
                siirto = [lahtoalue,legalmove]
                aialueet.erase(lahtoalue)
                                
    # hyökkää jos ylivoima
    for lahtoalue in aialueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:                
           if alueet[str(legalmove)].spread == pelaajanspread && alueet[str(lahtoalue)].troops > alueet[str(legalmove)].troops:
                siirto = [lahtoalue,legalmove]

    return siirto
