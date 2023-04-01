extends Control

@onready var btnEmpezar = $div/Empezar
@onready var btnOpciones = $div/Opciones
@onready var btnSalir = $div/Salir



func _ready():
	btnEmpezar.grab_focus()



func _on_empezar_pressed():
	SceneTransition.change_scene("res://Levels/level_1.tscn")


func _on_opciones_pressed():
	pass # Replace with function body.


func _on_salir_pressed():
	get_tree().quit()
