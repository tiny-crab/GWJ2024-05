class_name Enemy extends Node2D

@export var maxHealth: int = 100
var currHealth: int

@export var maxRage: int = 10
var currRage: int
var rageActive: bool

@onready var projectileTemplate = load("res://enemy_projectile.tscn")

func _ready():
    currHealth = maxHealth
    currRage = 0
    rageActive = false

func attack():
    print("Enemy attacked!")
    var projectile: EnemyProjectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.velocity = Vector2(-25, 0)

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

func take_damage(damage: int):
    currHealth = clamp(currHealth - damage, 0, maxHealth)
    currRage = clamp(currRage + 5, 0, maxRage)
    if currRage == maxRage:
        rageActive = true
