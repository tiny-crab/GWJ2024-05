extends Node2D

@export var maxHealth: int = 100
var currHealth: int

@export var maxRage: int = 10
var currRage: int
var rageActive: bool

func _ready():
    currHealth = maxHealth
    currRage = 0
    rageActive = false

func attack():
    print("Enemy attacked!")

func special():
    print("Enemy used special!")
    currRage = 0
    rageActive = false

func take_damage(damage: int):
    currHealth = clamp(currHealth - damage, 0, maxHealth)
    currRage = clamp(currRage + 5, 0, maxRage)
    if currRage == maxRage:
        rageActive = true
