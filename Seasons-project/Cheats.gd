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
	print(str(">> [1] Spring 03"))
	print(str(">> [2] Spring 06"))
	print(str(">> [3] Summer 06"))
	print(str(">> [4] Summer 10"))
	print(str(">> [5] Fall 09"))
	print(str(">> [6] Fall 14"))
	print(str(">> [7] Winter 12"))
	print(str(">> [8] Winter 17"))
	print("\n------------------------\n")

func _input(event):
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
			
		if Input.is_action_pressed("Level_1"):
			get_tree().change_scene("res://levels/SpringDL3.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed	("Level_2"):
			get_tree().change_scene("res://levels/SpringDL6.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed("Level_3"):
			get_tree().change_scene("res://levels/SummerDL6.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed("Level_4"):
			get_tree().change_scene("res://levels/SummerDL10.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed("Level_5"):
			get_tree().change_scene("res://levels/FallDL9.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed("Level_6"):
			get_tree().change_scene("res://levels/FallDL14.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed("Level_7"):
			get_tree().change_scene("res://levels/WinterDL12.tscn")
			print(">> Changing scene...")

		if Input.is_action_pressed("Level_8"):
			get_tree().change_scene("res://levels/WinterDL17.tscn")
			print(">> Changing scene...")
		
		# Remove the current level
		#var level = root.get_node("Level")
		#root.remove_child(level)
		#level.call_deferred("free")
		
		# Add the next level
		#var next_level_resource = load("res://path/to/scene.tscn)
		#var next_level = next_level.instance()
		#root.add_child(next_level)