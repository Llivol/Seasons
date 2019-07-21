extends Node

export var debug = false
export var sprites = true
export var infinite_stamina = false
export var infinite_health = false
export var infinite_rope_lenght = false
export var unkillable = false

func _ready():
	print("\n-------- CHEATS --------\n")
	print(str(">> [Ctrl] To access cheat mode\n"))
	print(str(">> [F1] Debug mode setted to: ", debug))
	print(str(">> [F2] Infinite health mode setted to: ", infinite_health))
	print(str(">> [F3] Infinite stamina mode setted to: ", infinite_stamina))
	print(str(">> [F4] Infinite rope mode setted to: ", infinite_rope_lenght))
	print(str(">> [F5] Unkillable mode setted to: ", unkillable))
	print(str("\n-------- LEVELS --------\n"))
	print(str(">> [Init] Restarts current level"))
	print(str(">> [1] Summer 10"))
	print(str(">> [2] Winter 17"))
	print(str(">> [3] Spring 03"))
	print(str(">> [4] Fall 09"))

	print("\n------------------------\n")

func _input(event):
	if Input.is_action_just_pressed("Cheat_exit"):
		get_tree().change_scene("res://screens/Title.tscn")
		print(">> Exiting game...")
		
	if Input.is_action_just_pressed("Start"):
		var current_scene = get_tree().get_current_scene().filename
		match current_scene:
			"res://screens/Title.tscn":
				get_tree().change_scene("res://levels/Playground.tscn")
			"res://levels/Playground.tscn":
				get_tree().change_scene("res://levels/SpringDL3.tscn")
			"res://levels/SpringDL3.tscn":
				get_tree().change_scene("res://levels/SummerDL10.tscn")
			"res://levels/SummerDL10.tscn":
				get_tree().change_scene("res://levels/FallDL9.tscn")
			"res://levels/FallDL9.tscn":
				get_tree().change_scene("res://levels/WinterDL17.tscn")
			"res://levels/WinterDL17.tscn":
				get_tree().change_scene("res://screens/Title.tscn")
	
	if Input.is_action_just_pressed("Level_1"):
		get_tree().change_scene("res://levels/SpringDL3.tscn")
		print(">> Changing scene...")
	
	if Input.is_action_just_pressed("Level_2"):
		get_tree().change_scene("res://levels/SummerDL10.tscn")
		print(">> Changing scene...")
	
	if Input.is_action_just_pressed("Level_3"):
		get_tree().change_scene("res://levels/FallDL9.tscn")
		print(">> Changing scene...")
	
	if Input.is_action_just_pressed("Level_4"):
		get_tree().change_scene("res://levels/WinterDL17.tscn")
		print(">> Changing scene...")
		
	if Input.is_action_pressed("Cheat_mode"):
		
		if Input.is_action_pressed("Cheat_debug"):
			debug = !debug
			print(str(">> Debug mode setted to: ", debug))

		if Input.is_action_pressed("Cheat_inf_health"):
			infinite_health = !infinite_health
			print(str(">> Infinite health mode setted to: ", infinite_health))

		if Input.is_action_pressed("Cheat_inf_stamina"):
			infinite_stamina = !infinite_stamina
			print(str(">> Infinite stamina mode setted to: ", infinite_stamina))

		if Input.is_action_pressed("Cheat_inf_rope"):
			infinite_rope_lenght = !infinite_rope_lenght
			print(str(">> Infinite rope mode setted to: ", infinite_rope_lenght))

		if Input.is_action_pressed("Cheat_unkillable"):
			unkillable = !unkillable
			print(str(">> Unkillable mode setted to: ", unkillable))

		if Input.is_action_pressed("Cheat_restart"):
			var current_scene = get_tree().get_current_scene().filename
			get_tree().change_scene(current_scene)
			print(">> Reloading scene...")

#		if Input.is_action_pressed("Level_5"):
#			get_tree().change_scene("res://levels/FallDL9.tscn")
#			print(">> Changing scene...")
#
#		if Input.is_action_pressed("Level_6"):
#			get_tree().change_scene("res://levels/FallDL14.tscn")
#			print(">> Changing scene...")
#
#		if Input.is_action_pressed("Level_7"):
#			get_tree().change_scene("res://levels/WinterDL12.tscn")
#			print(">> Changing scene...")
#
#		if Input.is_action_pressed("Level_8"):
#			get_tree().change_scene("res://levels/WinterDL17.tscn")
#			print(">> Changing scene...")