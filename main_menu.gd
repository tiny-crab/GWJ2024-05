extends Node2D

@onready var playButton = $UI/CenterContainer/VBoxContainer/PlayButton
@onready var exitButton = $UI/CenterContainer/VBoxContainer/ExitButton

func _on_play_button_mouse_entered():
    playButton.modulate = Color("#666666")

func _on_play_button_mouse_exited():
    playButton.modulate = Color("#ffffff")

func _on_play_button_pressed():
    $UI.visible = false
    $Comic.visible = true

    # Hide all comic elements other than Panel1 background
    $Comic/Panel1/Background.modulate = Color("ffffff")
    $Comic/Panel1/Text.modulate = Color("ffffff00")
    $Comic/Panel2/Background.modulate = Color("ffffff00")
    $Comic/Panel2/Text.modulate = Color("ffffff00")
    $Comic/Panel2/Text2.modulate = Color("ffffff00")
    $Comic/Panel3/Background.modulate = Color("ffffff00")
    $Comic/Panel3/Text.modulate = Color("ffffff00")
    $Comic/Panel3/Text2.modulate = Color("ffffff00")
    $Comic/Panel3/DRRR1.modulate = Color("ffffff00")
    $Comic/Panel3/DRRR2.modulate = Color("ffffff00")
    $Comic/Panel3/Eye.modulate = Color("ffffff00")

    var tween = get_tree().create_tween()
    # Animate panel 1
    tween.tween_property($Comic/Panel1/Text, "modulate", Color("ffffff"), 2)

    # Transition panel 1 -> 2
    tween.tween_property($Comic/Panel1/Background, "modulate", Color("ffffff00"), 1).set_delay(5)
    tween.parallel().tween_property($Comic/Panel1/Text, "modulate", Color("ffffff00"), 1).set_delay(5)
    tween.parallel().tween_property($Comic/Panel2/Background, "modulate", Color("ffffff"), 1).set_delay(5)

    #Animate panel 2
    tween.tween_property($Comic/Panel2/Text, "modulate", Color("ffffff"), 2)
    tween.tween_property($Comic/Panel2/Text2, "modulate", Color("ffffff"), 2)

    # Transition panel 2 -> 3
    tween.tween_property($Comic/Panel2/Text, "modulate", Color("ffffff00"), 1).set_delay(5)
    tween.parallel().tween_property($Comic/Panel2/Text2, "modulate", Color("ffffff00"), 1).set_delay(5)
    tween.parallel().tween_property($Comic/Panel2/Background, "modulate", Color("ffffff00"), 1).set_delay(5)
    tween.parallel().tween_property($Comic/Panel3/Background, "modulate", Color("ffffff"), 1).set_delay(5)
    tween.parallel().tween_property($Comic/Panel3/Eye, "modulate", Color("ffffff"), 1).set_delay(5)

    # Animate panel 3
    tween.tween_property($Comic/Panel3/Text, "modulate", Color("ffffff"), 2)
    tween.tween_property($Comic/Panel3/DRRR1, "modulate", Color("ffffff"), 2)
    tween.parallel().tween_property($Comic/Panel3/DRRR2, "modulate", Color("ffffff"), 2).set_delay(.5)
    tween.tween_property($Comic/Panel3/Text2, "modulate", Color("ffffff"), 2).set_delay(.5)

    # Transition panel 3 out
    tween.tween_property($Comic/Panel3/Background, "modulate", Color("ffffff00"), 2).set_delay(5)
    tween.parallel().tween_property($Comic/Panel3/Text, "modulate", Color("ffffff00"), 2).set_delay(5)
    tween.parallel().tween_property($Comic/Panel3/Text2, "modulate", Color("ffffff00"), 2).set_delay(5)
    tween.parallel().tween_property($Comic/Panel3/DRRR1, "modulate", Color("ffffff00"), 2).set_delay(5)
    tween.parallel().tween_property($Comic/Panel3/DRRR2, "modulate", Color("ffffff00"), 2).set_delay(5)

    tween.tween_property($Comic/Panel3/Eye, "modulate", Color("ffffff00"), .5).set_delay(2)
    tween.tween_callback(start_game)

func start_game():
    var game = preload("res://game.tscn").instantiate()
    get_tree().root.add_child(game)
    get_tree().root.remove_child(self)

func _on_exit_button_mouse_entered():
    exitButton.modulate = Color("#666666")

func _on_exit_button_mouse_exited():
    exitButton.modulate = Color("#ffffff")

func _on_exit_button_pressed():
    $UI.visible = false
    $DRRR.visible = true
    var tween = get_tree().create_tween()
    tween.tween_property($DRRR/DRRR1, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR2, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR3, "modulate", Color("ffffff"), 1)

