extends Control

@onready var btnEmpezar = $div/Empezar
@onready var btnOpciones = $div/Opciones
@onready var btnSalir = $div/Salir
@onready var ptrStart = $ptrStart
@onready var ptrOption = $ptrOption
@onready var ptrQuit = $ptrQuit


func _ready():
	btnEmpezar.grab_focus()

func _process(delta):
	ptrStart.visible = false
	ptrOption.visible = false
	ptrQuit.visible = false
	
	if btnEmpezar.has_focus():
		ptrStart.visible = true
	if btnOpciones.has_focus():
		ptrOption.visible = true
	if btnSalir.has_focus():
		ptrQuit.visible = true


func _on_empezar_pressed():
	SceneTransition.change_scene("res://Levels/level_1.tscn")


func _on_opciones_pressed():
	pass # Replace with function body.


func _on_salir_pressed():
	get_tree().quit()
