extends CharacterBody2D
class_name Entity
signal healthDown
signal healthModified
signal hit

# Move properties
@export var moveSpeed: float = 300.
var direction: Vector2 = Vector2()

# Health properties
@export var maxHealth: float = 100.
@export var currHealth: float = 100.:
	set(newHealth):
		currHealth = newHealth
		healthModified.emit()

func dealDamage(damage: float):
	pass
		
func _ready():
	pass
