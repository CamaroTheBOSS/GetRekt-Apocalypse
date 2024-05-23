extends Weapon
@export var spiralSpeed: float = 4
@export var bulletLifeTime: float = 4

func shoot(direction: Vector2, targetGroup: String):
	if !_reloadTimer.is_stopped():
		return
	var projectile = projectileScene.instantiate()
	projectile.global_position = _spawnPoint.global_position
	projectile.direction = direction
	projectile.targetGroup = targetGroup
	projectile.rotationSpeed = shootSpeed
	projectile.spiralSpeed = spiralSpeed
	projectile.damage = damage
	projectile.lifeTime = bulletLifeTime
	projectile.projectileOwner = _spawnPoint
	projectile.add_to_group("Projectile")
	get_tree().root.add_child(projectile)
	_reloadTimer.start()
	onShoot.emit()

func _ready():
	_reloadTimer.wait_time = 1 / shootRatio
