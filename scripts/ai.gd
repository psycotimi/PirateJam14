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
    var ukollisetalueet = []
    var pelaajanspread = alueet[str(pelaajanalueet[0])].spread
    
    # jos ei ole enään alueita
    if aialueet == []:
        return []
        
    #edes joku siirto
    for lahtoalue in aialueet:
        if alueet[str(lahtoalue)].troops <= 0:
            continue
        else:
            ukollisetalueet.append(lahtoalue)
            for legalmove in alueet[str(lahtoalue)].legalmoves:
                baadmoves.append([lahtoalue,legalmove])
        
    # liikkuu leivälle tai vihun alueelle riippumatta joukoista
    for lahtoalue in ukollisetalueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if alueet[str(legalmove)].spread != alueet[str(lahtoalue)].spread:
                if alueet[str(legalmove)].troops > alueet[str(lahtoalue)].troops:
                    baadmoves.append([lahtoalue,legalmove])
                else:
                    betterthanbadmoves.append([lahtoalue,legalmove])
                
    # liikkuu leivälle jos saa ukkoja
    for lahtoalue in ukollisetalueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:
            if aialueet.has(legalmove):
                if alueet[str(legalmove)].troops in range(1,3) && alueet[str(lahtoalue)].troops in range(1,3):
                    betterthanbadmoves.append([lahtoalue,legalmove])
                continue
            elif alueet[str(legalmove)].spread != pelaajanspread && alueet[str(legalmove)].troops > 0:
                goodmoves.append([lahtoalue,legalmove])
                                
    # hyökkää jos ylivoima
    for lahtoalue in ukollisetalueet:
        for legalmove in alueet[str(lahtoalue)].legalmoves:          
           if alueet[str(legalmove)].spread == pelaajanspread && alueet[str(lahtoalue)].troops > alueet[str(legalmove)].troops:
                if alueet[str(legalmove)].troops > 0:
                    goodmoves.append([lahtoalue,legalmove])
                else:
                    betterthanbadmoves.append([lahtoalue,legalmove])

    goodmoves.shuffle()
    betterthanbadmoves.shuffle()
    baadmoves.shuffle()
    await get_tree().create_timer(0.5).timeout
    if goodmoves == []:
        if betterthanbadmoves == []:
            if baadmoves == []:
                print("ukot loppu")
                return []
            else:
                siirto = baadmoves[0]
        else:
            siirto = betterthanbadmoves[0]
    else:
        siirto = goodmoves[0]
    return siirto
