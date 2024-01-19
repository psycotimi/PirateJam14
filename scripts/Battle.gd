extends Node

var rng = RandomNumberGenerator.new()

# Function to roll the amount of dice needed and return the sum.
# An animation could be linked into this function(?).
func roll_dice(amountOfDice: int) -> int:
    var dieRoll: int = 0
    var diceSum: int = 0
    
    for die in range(amountOfDice):
        dieRoll = rng.randi_range(1, Global.dieMax+1)
        diceSum += dieRoll
        
        # print("Die ", die, ": ", dieRoll) # debug print

    return diceSum


# A function to determine the winner of a battle.
# Return true if attacker won and false if defender won.
# In case of a tie, defender wins.
func did_attacker_win(attackerDice: int, defenderDice: int) -> bool:
    var attackSum: int = 0
    var defenceSum: int = 0
    
    # Roll a die for every attacker and calculate sum.
    attackSum = roll_dice(attackerDice)
    # Now the same for defenders.
    defenceSum = roll_dice(defenderDice)
    
    # Debug prints.
    # print("Attack sum: ", attackSum)
    # print("Defence sum: ", defenceSum)
    
    if (attackSum > defenceSum):
        return true
    else:
        return false
