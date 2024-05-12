extends Node2D

var isPlayerTurn: bool = true

func _ready():
    $UI/Player/Indicators/TurnIndicator.visible = true
    sync_player_ui()
    sync_enemy_ui()

func sync_player_ui():
    $UI/Player/Bars/HealthBar.max_value = $Player.maxHealth
    $UI/Player/Bars/HealthBar.value = $Player.currHealth
    $UI/Player/Bars/RageBar.max_value = $Player.maxRage
    $UI/Player/Bars/RageBar.value = $Player.currRage
    $UI/Player/Indicators/RageIndicator.visible = $Player.rageActive

func sync_enemy_ui():
    $UI/Enemy/Bars/HealthBar.max_value = $Enemy.maxHealth
    $UI/Enemy/Bars/HealthBar.value = $Enemy.currHealth
    $UI/Enemy/Bars/RageBar.max_value = $Enemy.maxRage
    $UI/Enemy/Bars/RageBar.value = $Enemy.currRage
    $UI/Enemy/Indicators/RageIndicator.visible = $Enemy.rageActive

func _on_player_attack_pressed():
    if isPlayerTurn:
        $Player.attack()
        $Enemy.take_damage(5)
        sync_player_ui()
        sync_enemy_ui()
        end_player_turn()

func _on_player_special_pressed():
    if isPlayerTurn and $Player.rageActive:
        $Player.special() # TODO switch to special
        $Enemy.take_damage(10)
        sync_player_ui()
        sync_enemy_ui()
        end_player_turn()

func end_player_turn():
    isPlayerTurn = false
    $UI/Player/Indicators/TurnIndicator.visible = false
    $UI/Enemy/Indicators/TurnIndicator.visible = true

func end_enemy_turn():
    isPlayerTurn = true
    $UI/Player/Indicators/TurnIndicator.visible = true
    $UI/Enemy/Indicators/TurnIndicator.visible = false

func _on_enemy_attack_pressed():
    if not isPlayerTurn:
        $Enemy.attack()
        $Player.take_damage(5)
        sync_player_ui()
        sync_enemy_ui()
        end_enemy_turn()

func _on_enemy_special_pressed():
    if not isPlayerTurn and $Enemy.rageActive:
        $Enemy.special() # TODO switch with special
        $Player.take_damage(10)
        sync_player_ui()
        sync_enemy_ui()
        end_enemy_turn()
