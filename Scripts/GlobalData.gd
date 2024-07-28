class_name DataManager
extends Node

signal player_inv_updated
signal home_inv_updated
signal potion_crafted(Item)

var player_inventory : PlayerInventory = PlayerInventory.new()
var home_inventory : HomeInventory = HomeInventory.new()
var inventory_size = 12
var max_potion_slots : int = 3
var gold : int = 0

func move_inventory():
	for item in player_inventory.contents:
		if item.id == "null_item":
			continue
		home_inventory.add_item(item)
	player_inventory.reset()
	home_inv_updated.emit()
