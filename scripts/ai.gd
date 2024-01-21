extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass


func selectmove(alueet, pelaajanalueet, aialueet):
    var goodmoves = []
    var baadmoves = []
    var betterthanbadmoves = []
    var siirto = []
    var ukollisetalueet = aialueet
    var pelaajanspread = alueet[str(pelaajanalueet[0])].spread
    #edes joku siirto
    for lahtoalue in aialueet:
        if alueet[str(lahtoalue)].troops <= 0:
            ukollisetalueet.erase(lahtoalue)
        else:
            for legalmove in alueet[str(lahtoalue)].legalmoves:
                baadmoves.append([lahtoalue,legalmove])
        
    # liikkuu leivälle
    for lahtoalue in ukollisetalueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if alueet[str(legalmove)].spread != alueet[str(lahtoalue)].spread:
                betterthanbadmoves.append([lahtoalue,legalmove])
                
    # liikkuu leivälle jos saa ukkoja
    for lahtoalue in ukollisetalueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if alueet[str(legalmove)].spread != pelaajanspread && alueet[str(legalmove)].troops > 0:
                goodmoves.append([lahtoalue,legalmove])
                                
    # hyökkää jos ylivoima
    for lahtoalue in ukollisetalueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:                
           if alueet[str(legalmove)].spread == pelaajanspread && alueet[str(lahtoalue)].troops > alueet[str(legalmove)].troops:
                goodmoves.append([lahtoalue,legalmove])

    goodmoves.shuffle()
    betterthanbadmoves.shuffle()
    baadmoves.shuffle()
    if goodmoves == []:
        if betterthanbadmoves == []:
            if baadmoves == []:
                print("ukot loppu")
            else:
                siirto = baadmoves[0]
        else:
            siirto = betterthanbadmoves[0]
    else:
        siirto = goodmoves[0]
    return siirto
