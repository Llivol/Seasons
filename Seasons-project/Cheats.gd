extends Node

export var debug = true
export var infinite_stamina = true
export var infinite_health = true
export var infinite_rope_lenght = true

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