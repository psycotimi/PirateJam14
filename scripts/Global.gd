extends Node


# Variables to be used globally with "Global.<variable_name>".

# 0 for none (bread), 1 for pb, 2 for jam).
const spreadTypeList: Array = ["none", "pb", "jam"]
# Can be changed (maybe), but 3 seems to be the choise here.
const troopCountMax: int = 3
# Determines the dice to be used, most likely will be d6.
const dieMax: int = 6

# pelialueen koko
const gridsize: int = 16

# vuoronumero
var turnCounter: int = 0
# Kenen vuoro on? Hyödynnetään spreadTypeListiä
var whoseTurn: String = spreadTypeList[0]

# Molempien joukkojen sotilaiden määrä
var pbTroopCount: int = 0
var jamTroopCount: int = 0
