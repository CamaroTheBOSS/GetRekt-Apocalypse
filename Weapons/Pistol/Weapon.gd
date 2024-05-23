extends Node2D
class_name Weapon
signal onShoot

@export var projectileScene: PackedScene
@export var shootRatio: float:
	set(newShootRatio):
		shootRatio = newShootRatio
		if _reloadTimer:
			_reloadTimer.wait_time = 1 / newShootRatio

@export var shootSpeed: float
@export var damage: float
@export var icon: Texture2D

@onready var _reloadTimer: Timer = $Reload
@onready var _spawnPoint: Marker2D = $SpawnPoint


func shoot(direction: Vector2, targetGroup: String):
	if !_reloadTimer.is_stopped():
		return
	var projectile = projectileScene.instantiate()
	projectile.global_position = _spawnPoint.global_position
	projectile.direction = direction
	projectile.targetGroup = targetGroup
	projectile.speed = shootSpeed
	projectile.damage = damage
	projectile.add_to_group("Projectile")
	get_tree().root.add_child(projectile)
	_reloadTimer.start()
	onShoot.emit()

func _ready():
	_reloadTimer.wait_time = 1 / shootRatio
