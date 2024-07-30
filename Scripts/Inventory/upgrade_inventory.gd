extends HBoxContainer

var cost : int = 50
@onready var buy_button = $UpgradeInventory

func _ready() -> void:
	GlobalData.gold_updated.connect(check_upgrade)
	check_upgrade()

func check_upgrade():
	if GlobalData.gold >= cost:
		buy_button.disabled = false
	else:
		buy_button.disabled = true

func _on_upgrade_inventory_pressed() -> void:
	GlobalData.inventory_size = 15
	GlobalData.gold -= cost
