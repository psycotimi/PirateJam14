extends Node


func sad():
    $normaali.hide()
    $hyokkkays.hide()
    $voitto.hide()
    $havio.show()

func hyokkaa():
    $normaali.hide()
    $hyokkkays.show()
    $voitto.hide()
    $havio.hide()
    
func normaali():
    $normaali.show()
    $hyokkkays.hide()
    $voitto.hide()
    $havio.hide()
 
func happy():   
    $normaali.hide()
    $hyokkkays.hide()
    $voitto.show()
    $havio.hide()
