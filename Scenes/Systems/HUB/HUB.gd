extends CanvasLayer

@export var player: Player
@export var waveController: WaveController
@onready var moneyLabel: Label = $Control/Money/Label
@onready var damageButton: Button = $Background/MarginContainer/VBoxContainer/Damage
@onready var healthButton: Button = $Background/MarginContainer/VBoxContainer/Health
@onready var shootRatioButton: Button = $Background/MarginContainer/VBoxContainer/ShootRatio
@onready var nextWaveButton: Button = $Background/MarginContainer/VBoxContainer2/NextWave
@onready var statLabel: Label = $Statistics/StatisticsLabel

func open():
	get_tree().paused = true
	show()
	
func close():
	get_tree().paused = false
	waveController.nextWave()
	hide()
	
func changeStatisticLabel():
	statLabel.text = "Statistics:\n" + \
					  "Damage:       " + str(player.weapon.damage) + "\n" + \
					  "Max Health: " + str(player.maxHealth) + "\n" + \
					  "Shoot Ratio: " + str(player.weapon.shootRatio) + "/sec"
	
func _ready():
	waveController.waveFinished.connect(open)
	GlobalData.moneyChanged.connect(func (oldMoney, newMoney): moneyLabel.text = str(newMoney))
	damageButton.statBought.connect(func (): player.setStatDamage(player.statDamage + 1))
	healthButton.statBought.connect(func (): player.setStatHealth(player.statHealth + 1))
	shootRatioButton.statBought.connect(func (): player.setStatShootRatio(player.statShootRatio + 1))
	nextWaveButton.pressed.connect(close)
	player.statChanged.connect(changeStatisticLabel)
	changeStatisticLabel()
