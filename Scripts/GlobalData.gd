class_name DataManager
extends Node

signal player_inv_updated

var player_inventory : PlayerInventory = PlayerInventory.new()

var home_inventory : HomeInventory = HomeInventory.new()

func move_inventory():
	for item in player_inventory.contents:
		home_inventory.add_item(item)
	player_inventory.reset()
