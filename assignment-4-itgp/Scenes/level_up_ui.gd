extends Control

var weaponsList = ["fireball", "lightOrb", "sword"]
var upgrade1 = ""
var upgrade2 = ""
var player = null

func _process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")

func createOptions():
	var tempWL = weaponsList.duplicate()
	upgrade1 = tempWL.pick_random()
	tempWL.erase(upgrade1)
	upgrade2 = tempWL.pick_random()
	updateButtons()
	show()

func updateButtons():
	$HBoxContainer/upgradeOption1.text = upgrade1
	$HBoxContainer/upgradeOption2.text = upgrade2


func _on_upgrade_option_1_pressed() -> void:
	player.gainWeapon(upgrade1)
	hide()
	get_tree().paused = false


func _on_upgrade_option_2_pressed() -> void:
	player.gainWeapon(upgrade2)
	hide()
	get_tree().paused = false
