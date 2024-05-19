extends Node2D

@onready var state: GameState = GameState.new()
var isPlayerAttacking: bool = false

@onready var playerHitSounds = [
    preload("res://assets/sounds/playerhit1/sword4.ogg"),
    preload("res://assets/sounds/playerhit1/sword5.ogg"),
    preload("res://assets/sounds/playerhit1/sword6.ogg"),
    preload("res://assets/sounds/playerhit1/sword7.ogg"),
    preload("res://assets/sounds/playerhit1/sword8.ogg"),
    preload("res://assets/sounds/playerhit1/sword9.ogg"),
    preload("res://assets/sounds/playerhit1/sword10.ogg"),
    preload("res://assets/sounds/playerhit1/sword11.ogg"),
]

@onready var uiSounds = [
    preload("res://assets/sounds/uiclicks/mouseclick1.ogg"),
    preload("res://assets/sounds/uiclicks/switch17.ogg"),
    preload("res://assets/sounds/uiclicks/switch18.ogg"),
    preload("res://assets/sounds/uiclicks/switch19.ogg"),
]

func _ready():
    $UI.player = $Player
    $UI.enemy = $Enemy
    $UI.state = state
    state.isPlayerTurn = true
    $UI.start()

func _process(delta):
    if Input.is_action_pressed("player_dodge"):
        $Player.dodge()
    if Input.is_action_pressed("player_jump"):
        $Player.jump()
    if $Player.currRage == $Player.maxRage:
        $UI/Player/Actions/Special.visible = true
    else:
        $UI/Player/Actions/Special.visible = false

func _on_player_attack_pressed():
    $AudioStreamPlayer2D.stream = uiSounds.pick_random()
    $AudioStreamPlayer2D.play()
    if state.isPlayerTurn and not isPlayerAttacking:
        $Player.attack()
        isPlayerAttacking = true

func _on_player_special_pressed():
    $AudioStreamPlayer2D.stream = uiSounds.pick_random()
    $AudioStreamPlayer2D.play()
    if state.isPlayerTurn and $Player.rageActive:
        $Player.special()

func _on_player_turn_complete():
    end_player_turn()

func _on_enemy_turn_complete():
    end_enemy_turn()

func end_player_turn():
    isPlayerAttacking = false
    state.isPlayerTurn = false
    $UI/Hint.visible = true
    var tween = get_tree().create_tween()
    tween.tween_callback(choose_enemy_action).set_delay(1)

func choose_enemy_action():
    if $Enemy.currRage == $Enemy.maxRage:
        $Enemy.special()
    else:
        $Enemy.attack($EnemyMeleePosition.global_position)

func end_enemy_turn():
    $UI/Hint.visible = false
    state.isPlayerTurn = true

func _on_enemy_attack_pressed():
    if not state.isPlayerTurn:
        $Enemy.attack($EnemyMeleePosition.global_position)

func _on_enemy_special_pressed():
    if not state.isPlayerTurn and $Enemy.rageActive:
        $Enemy.special()

func _on_player_jump_pressed():
    $Player.jump()

func _on_player_dodge_pressed():
    $Player.dodge()

func _on_player_hit_target():
    $AudioStreamPlayer2D.stream = playerHitSounds.pick_random()
    $AudioStreamPlayer2D.play()
    $Enemy.take_damage(5)
