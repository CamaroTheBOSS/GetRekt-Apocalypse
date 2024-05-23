extends Weapon

func shoot(direction: Vector2, targetGroup: String):
	if !_reloadTimer.is_stopped():
		return
	for deviation in [-0.2, 0, 0.2]:
		var projectile = projectileScene.instantiate()
		var bulletDirection = direction + direction.rotated(PI / 2) * deviation
		projectile.global_position = _spawnPoint.global_position
		projectile.direction = bulletDirection
		projectile.targetGroup = targetGroup
		projectile.speed = shootSpeed
		projectile.damage = damage
		projectile.add_to_group("Projectile")
		get_tree().root.add_child(projectile)
	_reloadTimer.start()
	onShoot.emit()

func _ready():
	_reloadTimer.wait_time = 1 / shootRatio
