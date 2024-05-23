extends Projectile
class_name BossProjectile

func onCollisionWithBody(body: Node2D):
	if body is Entity and body.is_in_group(targetGroup):
		body.dealDamage(damage)

func onCollisionWithArea(area):
	pass
