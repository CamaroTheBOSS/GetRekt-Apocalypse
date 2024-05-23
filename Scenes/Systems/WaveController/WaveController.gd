extends Node
class_name WaveController
signal waveFinished

@export var waveBalanceCurve: Curve

@onready var spawnArea = $SpawnArea/CollisionShape2D
@onready var waveTimer = $WaveTimer
@onready var enemiesNode = $Enemies

func resetGame():
	for enemy in get_tree().get_nodes_in_group("HitableEnemy"):
		if is_instance_valid(enemy):
			enemy.queue_free()
	for projectile in get_tree().get_nodes_in_group("Projectile"):
		if is_instance_valid(projectile):
			projectile.queue_free()
	setWaveTime()

func spawn(enemy: Enemy):
	if GlobalData.cutScene:
		return
	enemy.owner = enemiesNode
	enemiesNode.add_child(enemy)

func nextWave():
	GlobalData.setWave(GlobalData.wave + 1)
	for enemy in get_tree().get_nodes_in_group("HitableEnemy"):
		if is_instance_valid(enemy):
			enemy.queue_free()
	for projectile in get_tree().get_nodes_in_group("Projectile"):
		if is_instance_valid(projectile):
			projectile.queue_free()
	setWaveTime()
			
func setWaveTime():
	var waveTime = waveBalanceCurve.sample_baked(float(GlobalData.getWave() - 1) / (GlobalData.getMaxWaves() - 1))
	waveTimer.wait_time =  waveTime
	waveTimer.timeout.connect(func (): waveFinished.emit())
	if GlobalData.getWave() != GlobalData.getMaxWaves():
		waveTimer.start()
	GlobalData.setTimeLeft(ceil(waveTimer.time_left))
			
func _process(delta):
	if ceil(waveTimer.time_left) < GlobalData.getTimeLeft():
		GlobalData.setTimeLeft(ceil(waveTimer.time_left))
		
func _ready():
	GlobalData.newGame.connect(resetGame)
	setWaveTime()
