class_name Enemy extends Node2D

signal turn_complete

@export var maxHealth: int = 100
var currHealth: int

@export var maxRage: int = 10
var currRage: int
var rageActive: bool

@onready var initPosition: Vector2 = position

@onready var projectileTemplate = load("res://enemy_projectile.tscn")

var locationToDisappearTo: Vector2
var nextAnimationAfterDisappear: String

func _ready():
    currHealth = maxHealth
    currRage = 0
    rageActive = false

func disappear_to(global_position: Vector2, next_animation: String):
    $AnimationPlayer.current_animation = "disappear"
    nextAnimationAfterDisappear = next_animation
    locationToDisappearTo = global_position

func _on_disappear_complete():
    position = locationToDisappearTo
    if not nextAnimationAfterDisappear.is_empty():
        $AnimationPlayer.current_animation = nextAnimationAfterDisappear
        nextAnimationAfterDisappear = ""

func attack(global_position: Vector2):
    disappear_to(global_position, "attack_single")

func attack_single_complete():
    disappear_to(initPosition, "idle")
    emit_signal("turn_complete")

func special():
    print("Enemy used special!")

    var projectile: EnemyProjectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.position.y = 30
    projectile.velocity = Vector2(-25, 0)
    await get_tree().create_timer(0.5).timeout

    projectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.position.y = 0
    projectile.velocity = Vector2(-25, 0)
    await get_tree().create_timer(0.5).timeout

    projectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.position.y = -30
    projectile.velocity = Vector2(-25, 0)

    currRage = 0
    rageActive = false
    emit_signal("turn_complete")

func take_damage(damage: int):
    currHealth = clamp(currHealth - damage, 0, maxHealth)
    currRage = clamp(currRage + 5, 0, maxRage)
    if currRage == maxRage:
        rageActive = true

