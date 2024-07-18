class_name DataManager
extends Node

signal inventory_updated

var inventory : Inventory = Inventory.new()

@export var test_item : Item


func _on_add_item_pressed() -> void:
	inventory.add_item(test_item)
	inventory_updated.emit(inventory)
