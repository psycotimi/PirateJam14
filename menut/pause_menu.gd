extends Control


# jatka peliä
func _on_resume_pressed():
    hide()
    get_tree().paused = false
    
# sulje peli
func _on_quit_pressed():
   get_tree().quit()
