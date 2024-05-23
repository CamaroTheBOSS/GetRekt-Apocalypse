extends Entity
class_name Enemy
@export var damage: float = 30.

@onready var _damageCollider = $DamageCollider
@onready var _animation = $AnimationPlayer
var dead: bool = false

func onCollision(body: Node2D):
	if body is Player:
		body.dealDamage(damage)

func onEntityKilled():
	dead = true
	_animation.play("death", -1, 1.7)
	GlobalData.setMoney(GlobalData.getMoney() + randi_range(1, 3))
	await _animation.animation_finished
	if is_instance_valid(self):
		queue_free()
		
func dealDamage(damageAmount: float):
	currHealth -= damageAmount
	hit.emit()
	if currHealth <= 0:
		healthDown.emit()
		
func onHit():
	if !_animation.current_animation == "death":
		_animation.play("hit", -1, 3)

func _ready():
	healthDown.connect(onEntityKilled)
	hit.connect(onHit)
	_damageCollider.body_entered.connect(onCollision)


func _process(delta):
	if _animation.current_animation == "spawn" or _animation.current_animation == "death" or GlobalData.cutScene:
		return
	if _animation.current_animation == "hit":
		move_and_slide()
		return
	if velocity:
		_animation.play("move", -1, 2)
	else:
		_animation.stop()
	move_and_slide()
	
