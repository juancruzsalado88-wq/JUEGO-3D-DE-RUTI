extends CharacterBody3D

const VELOCIDAD = 2.5

var jugador = null
var atrapado = false

func _ready():
	jugador = get_tree().get_first_node_in_group("jugador")
	print("ENEMIGO LISTO, jugador: ", jugador)

func _physics_process(delta):
	if jugador == null:
		jugador = get_tree().get_first_node_in_group("jugador")
		return
	if atrapado:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direccion = jugador.global_position - global_position
	direccion.y = 0

	if direccion.length() < 1.2:
		atrapar()
		return

	direccion = direccion.normalized()
	velocity.x = direccion.x * VELOCIDAD
	velocity.z = direccion.z * VELOCIDAD
	move_and_slide()

func atrapar():
	atrapado = true
	$Susto.play()
	get_tree().get_first_node_in_group("mundo").perder()
