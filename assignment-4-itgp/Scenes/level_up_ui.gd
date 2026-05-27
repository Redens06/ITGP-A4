extends Control

var weaponsList = ["fireball", "lightOrb", "sword", "icicle", "mimic"]
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
	match upgrade1:
		"fireball":
			$HBoxContainer/upgradeOption1.text = "Fireball\nFire a fireball at the nearest enemy. Upgrades increase blast radius."
			$HBoxContainer/upgradeOption1.modulate = Color(0.698, 0.259, 0.0, 1.0)
		"lightOrb":
			$HBoxContainer/upgradeOption1.text = "Ball of Light\nOccasionally spawns an spinning ball of light around the player. Upgrades increase spawn rate"
			$HBoxContainer/upgradeOption1.modulate = Color(1.0, 1.0, 1.0, 1.0)
		"sword":
			$HBoxContainer/upgradeOption1.text = "Summoned Sword\nGain a specral sword that orbits the player. Upgrades increase orbiting speed."
			$HBoxContainer/upgradeOption1.modulate = Color(0.187, 0.5, 0.0, 1.0)
		"icicle":
			$HBoxContainer/upgradeOption1.text = "Icicles\nFires 4 piercing icicles in 4 directions, alternating angles each shot. Upgrades increase pierce amount."
			$HBoxContainer/upgradeOption1.modulate = Color(0.555, 0.627, 1.0, 1.0)
		"mimic":
			$HBoxContainer/upgradeOption1.text = "Mimic\nSummons a mimic of yourself to attack where you once stood. Upgrades increase the mimic's stats."
			$HBoxContainer/upgradeOption1.modulate = Color(0.879, 0.484, 0.858, 1.0)
		_:
			$HBoxContainer/upgradeOption1.text = upgrade1
	match upgrade2:
		"fireball":
			$HBoxContainer/upgradeOption2.text = "Fireball\nFire a fireball at the nearest enemy. Upgrades increase blast radius."
			$HBoxContainer/upgradeOption2.modulate = Color(0.698, 0.259, 0.0, 1.0)
		"lightOrb":
			$HBoxContainer/upgradeOption2.text = "Ball of Light\nOccasionally spawns an spinning ball of light around the player. Upgrades increase spawn rate"
			$HBoxContainer/upgradeOption2.modulate = Color(1.0, 1.0, 1.0, 1.0)
		"sword":
			$HBoxContainer/upgradeOption2.text = "Summoned Sword\nGain a specral sword that orbits the player. Upgrades increase orbiting speed."
			$HBoxContainer/upgradeOption2.modulate = Color(0.187, 0.5, 0.0, 1.0)
		"icicle":
			$HBoxContainer/upgradeOption2.text = "Icicles\nFires 4 piercing icicles in 4 directions, alternating angles each shot. Upgrades increase pierce amount."
			$HBoxContainer/upgradeOption2.modulate = Color(0.555, 0.627, 1.0, 1.0)
		"mimic":
			$HBoxContainer/upgradeOption2.text = "Mimic\nSummons a mimic of yourself to attack where you once stood. Upgrades increase the mimic's stats."
			$HBoxContainer/upgradeOption2.modulate = Color(0.879, 0.484, 0.858, 1.0)
		_:
			$HBoxContainer/upgradeOption1.text = upgrade2



func _on_upgrade_option_1_pressed() -> void:
	player.gainWeapon(upgrade1)
	hide()
	get_tree().paused = false


func _on_upgrade_option_2_pressed() -> void:
	player.gainWeapon(upgrade2)
	hide()
	get_tree().paused = false
