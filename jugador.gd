extends CharacterBody3D

const VELOCIDAD = 4.0
const SENSIBILIDAD = 0.003

@onready var cabeza = $Cabeza
@onready var linterna = $Cabeza/SpotLight3D

func _ready():
	add_to_group("jugador")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSIBILIDAD)
		cabeza.rotate_x(-event.relative.y * SENSIBILIDAD)
		cabeza.rotation.x = clamp(cabeza.rotation.x, -1.4, 1.4)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F:
		linterna.visible = not linterna.visible

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	var entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_key_pressed(KEY_A): entrada.x -= 1
	if Input.is_key_pressed(KEY_D): entrada.x += 1
	if Input.is_key_pressed(KEY_W): entrada.y -= 1
	if Input.is_key_pressed(KEY_S): entrada.y += 1
	entrada = entrada.limit_length(1.0)

	var direccion = transform.basis * Vector3(entrada.x, 0, entrada.y)

	velocity.x = direccion.x * VELOCIDAD
	velocity.z = direccion.z * VELOCIDAD
	move_and_slide()

func parpadear():
	for i in 4:
		linterna.visible = false
		await get_tree().create_timer(0.08).timeout
		linterna.visible = true
		await get_tree().create_timer(0.08).timeout
