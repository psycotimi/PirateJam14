extends Control


func _on_mutesound_pressed():
    await buttonsound()
    if $mutesound.get_frame() == 0:
        
        # mutee kaikki äänet
        var bus_idx = AudioServer.get_bus_index("sound")
        AudioServer.set_bus_mute(bus_idx, true) 
        
        # Vaihda kuvake
        $mutesound.set_frame(1)
    
    else:
        $mutesound.set_frame(0)
        var bus_idx = AudioServer.get_bus_index("sound")
        AudioServer.set_bus_mute(bus_idx, false)

func _on_mutemusic_pressed():
    await buttonsound()
    if $mutemusic.get_frame() == 0:
        
        # mutee kaikki äänet
        var bus_idx = AudioServer.get_bus_index("music")
        AudioServer.set_bus_mute(bus_idx, true) 
        
        # Vaihda kuvake
        $mutemusic.set_frame(1)
    
    else:
        $mutemusic.set_frame(0)
        var bus_idx = AudioServer.get_bus_index("music")
        AudioServer.set_bus_mute(bus_idx, false)
        
func buttonsound():
    $buttonsound.pitch_scale = 1.5
    $buttonsound.play()
    await get_tree().create_timer(0.1).timeout
