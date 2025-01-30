extends VBoxContainer

var upgrades := [
	{
		"id": "fire_rate_level",
		"name": "Fire Rate",
		"description": "",
	},
	{
		"id": "bounce_level",
		"name": "Bounce Level",
		"description": "Increase shoots bounce",
	},
	{
		"id": "bullet_speed_level",
		"name": "Bullet Speed",
		"description": "",
	},
	{
		"id": "infection_level",
		"name": "Infection Level",
		"description": "",
	},
	
]

@onready var grid: GridContainer = $Grid


const PRICES := [10, 20, 50]

const UPGRADE_BOX = preload("res://ui/upgrades/upgrade_box.tscn")
func _ready() -> void:
	GameManager.save_data.money += 100
	$Money.text = str("Net balance: $", GameManager.save_data.money)
	for upgrade in upgrades:
		var button := UPGRADE_BOX.instantiate()
		button.name = upgrade.id
		button.get_node("Name").text = upgrade.name
		button.get_node("Container/Description").text = upgrade.description
		var level: int = GameManager.save_data[upgrade.id]
		
		_update_button(button)
		button.pressed.connect(_on_upgrade_bought.bind(button))
		grid.add_child(button)

func _update_button(button: Button) -> void:
	var level: int = GameManager.save_data[button.name]
	button.disabled = level >= 2
	button.get_node("Container/HBox/Price").text = "MAX" if level >= 2 else str(PRICES[level], "$")


func _on_upgrade_bought(button: Button) -> void:
	$Money.text = str("Net balance: $", GameManager.save_data.money)
	var price: int = PRICES[GameManager.save_data[button.name]]
	if GameManager.save_data.money >= price:
		GameManager.save_data.money -= price
		GameManager.save_data[button.name] += 1
		_update_button(button)

	else:
		var tween := get_tree().create_tween()
		$Money.modulate = Color.RED
		tween.tween_property($Money, "modulate", Color.GREEN, 0.25)
