extends Timer

@export var prefab: PackedScene
@export var waveController: WaveController
var bossSpawned = false

func reset():
	bossSpawned = false
	
func spawn():
	if GlobalData.getWave() != GlobalData.getMaxWaves() or bossSpawned:
		return
	var position = GlobalData.getInitBossPosition()
	var enemy = self.prefab.instantiate()
	enemy.global_position = position
	enemy.add_to_group("HitableEnemy")
	waveController.spawn(enemy)
	GlobalData.notifyBossSpawned(enemy)
	bossSpawned = true
	
func _ready():
	timeout.connect(spawn)
	GlobalData.newGame.connect(reset)
	start()
