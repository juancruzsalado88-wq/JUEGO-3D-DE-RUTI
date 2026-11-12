extends Area3D

signal recogida

func _ready():
	body_entered.connect(_al_tocar)

func _al_tocar(cuerpo):
	if cuerpo is CharacterBody3D:
		recogida.emit()
		$Sonido.play()
		$MeshInstance3D.visible = false
		$CollisionShape3D.set_deferred("disabled", true)
		await $Sonido.finished
		queue_free()
