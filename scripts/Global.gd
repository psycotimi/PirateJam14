extends Node

# Variables to be used globally with "Global.<variable_name>".

# 0 for none (bread), 1 for pb, 2 for jam).
const spreadTypeList: Array = ["none", "pb", "jam"]
# Can be changed (maybe), but 3 seems to be the choise here.
const troopCountMax: int = 4
# Determines the dice to be used, most likely will be d6.
const dieMax: int = 6

# pelialueen koko
const gridsize: int = 16

# vuoronumero
var turnCounter: int = 0

# Kenen vuoro on? Hyödynnetään spreadTypeListiä
var whoseTurn: String = spreadTypeList[1]

# Molempien joukkojen sotilaiden määrä, alussa on 5
var pbTroopCount: int = 5
var jamTroopCount: int = 5
