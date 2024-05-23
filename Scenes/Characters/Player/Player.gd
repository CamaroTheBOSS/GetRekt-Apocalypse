extends Entity
class_name Player
signal onShoot
signal statChanged
signal onDeath

@export var weapon: Weapon
@export var timeImmunityAfterDamage: float = 1.

@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _hitbox: CollisionShape2D = $PhysicsCollider
@onready var _damageArea: Area2D = $DamageCollider
@onready var _immunity: Timer = $Immunity
@onready var damageSound: AudioStreamPlayer2D = $DamageSound
@onready var weaponSound: AudioStreamPlayer2D = $WeaponSound
var dead = false

var statDamage: int = 0
var statHealth: int = 0
var statShootRatio: float = 0

func resetGame():
	setStatDamage(0)
	setStatHealth(0)
	setStatShootRatio(0)
	global_position = GlobalData.getInitPlayerPosition()
	dead = false
	currHealth = maxHealth
	_animation.play("RESET")

func nextWave():
	global_position = GlobalData.getInitPlayerPosition()
	currHealth = maxHealth

func setStatDamage(newStatDamage):
	weapon.damage = weapon.damage - statDamage + newStatDamage
	statDamage = newStatDamage
	statChanged.emit()
	
	
func setStatHealth(newStatHealth):
	maxHealth = maxHealth - statHealth + newStatHealth
	currHealth = maxHealth
	statHealth = newStatHealth
	statChanged.emit()
	
	
func setStatShootRatio(newStatShootRatio):
	weapon.shootRatio = weapon.shootRatio - statShootRatio + newStatShootRatio
	statShootRatio = newStatShootRatio
	statChanged.emit()
	

func onEntityKilled():
	dead = true
	onDeath.emit()
	_animation.play("death", -1, 1.7)
		
		
func onImmunityEnd():
	for collider in _damageArea.get_overlapping_areas():
		if collider.owner is Enemy:
			collider.body_entered.emit(self)
			break
		
		
func dealDamage(damage: float):
	if !_immunity.is_stopped() or dead or GlobalData.cutScene:
		return
	_immunity.start()
	currHealth -= damage
	hit.emit()
	if currHealth <= 0:
		healthDown.emit()

		
func onHit():
	if !_animation.current_animation == "death":
		_animation.play("hit", -1, 3)
		damageSound.play()
		
		
func onWeaponShoot():
	onShoot.emit()


func _ready():
	healthDown.connect(onEntityKilled)
	hit.connect(onHit)
	_immunity.wait_time = timeImmunityAfterDamage
	_immunity.timeout.connect(onImmunityEnd)
	weapon.onShoot.connect(onWeaponShoot)
	GlobalData.waveChanged.connect(func (oldWave, newWave): nextWave())
	GlobalData.newGame.connect(resetGame)
	nextWave()

func _process(delta):
	if dead or GlobalData.cutScene:
		return
	
	# Shooting
	var globalMousePosition = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		weapon.shoot((globalMousePosition - position).normalized(), "HitableEnemy")
	
	# Moving
	var xDirection = Input.get_axis("left", "right")
	var yDirection = Input.get_axis("up", "down")
	direction = Vector2(xDirection, yDirection).normalized()
	velocity = direction * moveSpeed		
	if _animation.current_animation == "hit":
		move_and_slide()
		return
	if velocity:
		_animation.play("move", -1, 2)
	else:
		_animation.stop()	
		
	# Aiming
	weapon.look_at(globalMousePosition)
	if (get_local_mouse_position().x < 0 and scale.x > 0) or scale.x < 0:
		scale.x = -scale.x

	move_and_slide()
