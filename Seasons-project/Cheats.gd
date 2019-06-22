extends Node

export var debug = true
export var sprites = true
export var infinite_stamina = true
export var infinite_health = true
export var infinite_rope_lenght = true
export var unkillable = false

func _ready():
	print("-------- CHEATS --------")
	print(str(">> [F1] Debug mode setted to: ", debug))
	print(str(">> [F2] Infinite health mode setted to: ", infinite_health))
	print(str(">> [F3] Infinite stamina mode setted to: ", infinite_stamina))
	print(str(">> [F4] Infinite rope mode setted to: ", infinite_rope_lenght))
	print(str(">> [F5] Unkillable mode setted to: ", unkillable))
	print("------------------------")

func _input(event):
	if event.is_action_pressed("Cheat_debug"):
		debug = !debug
		print(str(">> Debug mode setted to: ", debug))
	if event.is_action_pressed("Cheat_inf_health"):
		infinite_health = !infinite_health
		print(str(">> Infinite health mode setted to: ", infinite_health))
	if event.is_action_pressed("Cheat_inf_stamina"):
		infinite_stamina = !infinite_stamina
		print(str(">> Infinite stamina mode setted to: ", infinite_stamina))
	if event.is_action_pressed("Cheat_inf_rope"):
		infinite_rope_lenght = !infinite_rope_lenght
		print(str(">> Infinite rope mode setted to: ", infinite_rope_lenght))
	if event.is_action_pressed("Cheat_unkillable"):
		unkillable = !unkillable
		print(str(">> Unkillable mode setted to: ", unkillable))
	if event.is_action_pressed("Cheat_restart"):
		var current_scene = get_tree().get_current_scene().filename
		get_tree().change_scene(current_scene)
		print(">> Reloading scene...")
		
		# Remove the current level
		#var level = root.get_node("Level")
		#root.remove_child(level)
		#level.call_deferred("free")
		
		# Add the next level
		#var next_level_resource = load("res://path/to/scene.tscn)
		#var next_level = next_level.instance()
		#root.add_child(next_level)