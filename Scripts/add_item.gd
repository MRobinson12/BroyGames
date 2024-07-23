extends Button


@export var greendle : Item
@export var blattashroom : Item
@export var anpel : Item
@export var gloomberry : Item
@export var slate_slime : Item
@export var lionsbrane : Item
@export var glinting_glassrock : Item
@export var stal_wart : Item



func _on_pressed() -> void:
	GlobalData.player_inventory.add_item(greendle)
	GlobalData.player_inventory.add_item(blattashroom)
	GlobalData.player_inventory.add_item(anpel)
	GlobalData.player_inventory.add_item(gloomberry)
	GlobalData.player_inventory.add_item(slate_slime)
	GlobalData.player_inventory.add_item(lionsbrane)
	GlobalData.player_inventory.add_item(glinting_glassrock)
	GlobalData.player_inventory.add_item(stal_wart)
