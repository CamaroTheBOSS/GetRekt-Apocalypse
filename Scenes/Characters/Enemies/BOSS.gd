extends Enemy

func onEntityKilled():
	dead = true
	GlobalData.notifyBossKilled(self)
	_animation.play("death", -1, 1.7)
	GlobalData.setMoney(GlobalData.getMoney() + randi_range(1, 3))
	await _animation.animation_finished
	if is_instance_valid(self):
		queue_free()
