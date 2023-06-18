extends Control

@onready var btnEmpezar = $div/Empezar
@onready var btnOpciones = $div/Opciones
@onready var btnSalir = $div/Salir
@onready var ptrStart = $ptrStart
@onready var ptrOption = $ptrOption
@onready var ptrQuit = $ptrQuit



func _ready():
	btnEmpezar.grab_focus()
	MainMusic.play()

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
	SceneTransition.change_scene("res://Levels/character_selection.tscn")


func _on_opciones_pressed():
	SceneTransition.change_scene("res://Settings/config.tscn")


func _on_salir_pressed():
	get_tree().quit()


func _on_bg_music_finished():
	$bgMusic.play()
