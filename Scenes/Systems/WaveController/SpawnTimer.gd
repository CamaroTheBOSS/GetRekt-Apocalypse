extends Timer

@export var prefab: PackedScene
@export var balanceCurve: Curve
@export var waveController: WaveController

func getRandomPosition():
	var origin = waveController.spawnArea.global_position
	var std = waveController.spawnArea.shape.extents
	var x = randi_range(origin.x - std.x, origin.x + std.x)
	var y = randi_range(origin.y - std.y, origin.y + std.y)
	return Vector2(x, y)

func setTimer(oldWave, newWave):
	var enemiesPerSecond = balanceCurve.sample_baked(float(GlobalData.getWave() - 1) / (GlobalData.getMaxWaves() - 1))
	if enemiesPerSecond == 0:
		stop()
	else:
		wait_time =  (1 / enemiesPerSecond)
		start()
	
func spawn():
	var position = getRandomPosition()
	var enemy = self.prefab.instantiate()
	enemy.global_position = position
	enemy.add_to_group("HitableEnemy")
	waveController.spawn(enemy)
	
func _ready():
	GlobalData.waveChanged.connect(setTimer)
	timeout.connect(spawn)
	setTimer(0, 0)
