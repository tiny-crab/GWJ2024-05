extends Node2D

@onready var state: GameState = GameState.new()

func _ready():
    $UI.player = $Player
    $UI.enemy = $Enemy
    $UI.state = state
    state.isPlayerTurn = true
    $UI.start()

func _on_player_attack_pressed():
    if state.isPlayerTurn:
        $Player.attack()
        $Enemy.take_damage(5)
        end_player_turn()

func _on_player_special_pressed():
    if state.isPlayerTurn and $Player.rageActive:
        $Player.special()
        $Enemy.take_damage(10)
        end_player_turn()

func end_player_turn():
    state.isPlayerTurn = false

func end_enemy_turn():
    state.isPlayerTurn = true

func _on_enemy_attack_pressed():
    if not state.isPlayerTurn:
        $Enemy.attack()
        end_enemy_turn()

func _on_enemy_special_pressed():
    if not state.isPlayerTurn and $Enemy.rageActive:
        $Enemy.special()
        end_enemy_turn()
