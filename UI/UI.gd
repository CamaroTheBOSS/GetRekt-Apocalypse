extends CanvasLayer

@export var player: Player
@export var waveController: WaveController

@onready var _healthBar: ProgressBar = $ManaHealth/HealthBar
@onready var _moneyAmount: Label = $ManaHealth/Money/Label
@onready var _weaponIcon: TextureProgressBar = $ManaHealth/WeaponIcon
@onready var _waveLabel: Label = $WaveInfo/WaveLabel
@onready var playerDeathAnimation: AnimationPlayer = $PlayerDeath/AnimationPlayer
@onready var _bossHealthBar: ProgressBar = $Boss/HealthBar
@onready var boss: Entity

func resetGame():
	playerDeathAnimation.play("RESET")
	boss = null
	_bossHealthBar.hide()
	updateHealthBar()
	updateMoneyAmount(0, 0)
	updateWaveLabel(1, 1)

func updateHealthBar():
	_healthBar.max_value = player.maxHealth
	_healthBar.value = max(player.currHealth, 0)
	
func updateMoneyAmount(oldMoney, newMoney):
	_moneyAmount.text = str(GlobalData.getMoney())
	
func updateWeaponIcon(weapon: Weapon):
	_weaponIcon.texture_under = weapon.icon
	
func updateWaveLabel(oldValue, newValue):
	if GlobalData.getWave() != GlobalData.getMaxWaves():
		_waveLabel.text = "Wave: " + str(GlobalData.getWave()) + "\n" + str(GlobalData.getTimeLeft())
	else:
		_waveLabel.text = "Wave: " + str(GlobalData.getWave()) + "\nKILL THE BOSS"
	
func onPlayerDeath():
	playerDeathAnimation.play("FadeIn")
	
func updateBossHealthBar():
	if !boss:
		return
	_bossHealthBar.max_value = boss.maxHealth
	_bossHealthBar.value = max(boss.currHealth, 0)
	
func onBossSpawn(spawnedBoss):
	boss = spawnedBoss
	boss.healthModified.connect(updateBossHealthBar)
	updateBossHealthBar()
	_bossHealthBar.show()
	
func _ready():
	player.healthModified.connect(updateHealthBar)
	player.onDeath.connect(onPlayerDeath)
	GlobalData.moneyChanged.connect(updateMoneyAmount)
	GlobalData.timeLeftChanged.connect(updateWaveLabel)
	GlobalData.waveChanged.connect(updateWaveLabel)
	GlobalData.newGame.connect(resetGame)
	GlobalData.bossSpawned.connect(onBossSpawn)
	
	updateHealthBar()
	updateMoneyAmount(0, 0)
	updateWeaponIcon(player.weapon)
	updateWaveLabel(0, 0)
