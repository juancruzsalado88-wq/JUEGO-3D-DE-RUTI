extends Node3D

var llaves = 0
const TOTAL = 3
var terminado = false

@onready var etiqueta = $CanvasLayer/Label
@onready var victoria = $CanvasLayer/Victoria
@onready var derrota = $CanvasLayer/Derrota
@onready var puerta = $Puerta
@onready var salida = $Salida

func _ready():
	add_to_group("mundo")
	process_mode = Node.PROCESS_MODE_ALWAYS
	victoria.process_mode = Node.PROCESS_MODE_ALWAYS
	derrota.process_mode = Node.PROCESS_MODE_ALWAYS
	for hijo in get_children():
		if hijo is Area3D and hijo.has_signal("recogida"):
			hijo.recogida.connect(_llave_recogida)
	salida.body_entered.connect(_al_salir)

func _input(event):
	if terminado and event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().paused = false
		get_tree().reload_current_scene()

func _llave_recogida():
	llaves += 1
	get_node("CharacterBody3D").parpadear()
	etiqueta.text = "Llaves: %d/%d" % [llaves, TOTAL]
	if llaves >= TOTAL:
		etiqueta.text = "¡Salida abierta!"
		puerta.queue_free()

func _al_salir(cuerpo):
	if cuerpo is CharacterBody3D and llaves >= TOTAL and not terminado:
		terminado = true
		victoria.text = "¡Ganaste!\nR para reiniciar"
		victoria.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

func perder():
	if terminado:
		return
	terminado = true
	derrota.text = "Te atraparon...\nR para reiniciar"
	derrota.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = true
