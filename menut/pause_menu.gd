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



func _on_back_pressed():
    await buttonsound()
    $Options.hide()
    $Pause.show()

func buttonsound():
    $buttonsound.pitch_scale = 1.5
    $buttonsound.play()
    await get_tree().create_timer(0.1).timeout

func _on_restart_pressed():
    await buttonsound()
    get_tree().paused = false
    get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")
    
    
