extends Control

func _ready():
    $Options.hide()
    $Pause.show()

# jatka peliä
func _on_resume_pressed():
    await buttonsound()
    hide()
    get_tree().paused = false
    
# sulje peli
func _on_quit_pressed():
    await buttonsound()
    get_tree().quit()


func _on_options_pressed():
    await buttonsound()
    $Pause.hide()
    $Options.show()


# nämä funktiot options menun sisällä
func _on_mute_pressed():
    await buttonsound()
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
    await buttonsound()
    $Options.hide()
    $Pause.show()

func buttonsound():
    $buttonsound.pitch_scale = randf_range(2,3)
    $buttonsound.play()
    await get_tree().create_timer(0.1).timeout

func _on_restart_pressed():
    await buttonsound()
    get_tree().paused = false
    get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")
    
    
