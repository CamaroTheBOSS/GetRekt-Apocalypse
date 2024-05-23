extends Camera2D

@export var target: Node2D

@export var SHOOT_SHAKE_DECAY: float = 5.
@export var SHOOT_SHAKE_STRENGTH: float = 60.
@export var SHAKE_SPEED: float = 30.
var _noise = FastNoiseLite.new()
var _currentShakePosition: float = 0.
var _currentShakeStrength: float = 0.


func setViewToBoss(boss):
	var currTarget = target
	target = boss
	await GlobalData.cutSceneEnd
	target = currTarget


func reset():
	global_position = GlobalData.getInitPlayerPosition()
	reset_smoothing()


# Called when the node enters the scene tree for the first time.
func _ready():
	if target and Utils.signalExist(target, "onShoot"):
		target.onShoot.connect(shake)
	GlobalData.waveChanged.connect(func (oldWave, newWave): reset())
	GlobalData.newGame.connect(reset)
	GlobalData.bossSpawned.connect(setViewToBoss)
	GlobalData.bossKilled.connect(setViewToBoss)
	reset()
	
	
func shake():
	_currentShakeStrength = SHOOT_SHAKE_STRENGTH
	

func getNoiseOffset(delta: float):
	_currentShakePosition += delta * SHAKE_SPEED
	return Vector2(_noise.get_noise_2d(1, _currentShakePosition), 
				   _noise.get_noise_2d(100, _currentShakePosition)
			) * _currentShakeStrength


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var globalMousePosition = get_global_mouse_position()
	offset.x = (globalMousePosition.x - global_position.x) / 10
	offset.y = (globalMousePosition.y - global_position.y) / 10
	if _currentShakeStrength:
		_currentShakeStrength = lerp(_currentShakeStrength, 0., SHOOT_SHAKE_DECAY * delta)
		offset += getNoiseOffset(delta)
	if target:
		global_position = target.global_position
