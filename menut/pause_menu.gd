extends Control

func _ready():
    $Options.hide()
    $Pause.show()

# jatka peliä
func _on_resume_pressed():
    hide()
    get_tree().paused = false
    
# sulje peli
func _on_quit_pressed():
   get_tree().quit()


func _on_options_pressed():
    $Pause.hide()
    $Options.show()


# nämä funktiot options menun sisällä
func _on_mute_pressed():
    if $Options/AnimatedSprite2D.get_frame() == 0:
        
        # mutee kaikki äänet
        var bus_idx = AudioServer.get_bus_index("Master")
        AudioServer.set_bus_mute(bus_idx, true) 
        
        # Vaihda kuvake
        $Options/AnimatedSprite2D.set_frame(1)
    
    else:
        $Options/AnimatedSprite2D.set_frame(0)
        var bus_idx = AudioServer.get_bus_index("Master")
        AudioServer.set_bus_mute(bus_idx, false)


func _on_back_pressed():
    $Options.hide()
    $Pause.show()


func _on_restart_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")
    
    
