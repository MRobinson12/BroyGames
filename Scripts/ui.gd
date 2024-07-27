extends CanvasLayer

@onready var inventory_display : InventoryDisplay = %InventoryDisplay
@onready var home_menu  = %HomeMenu
@onready var crafting_menu = %CraftingMenu
var node_2d: Node2D
var potion_frames = []

func _ready():
	node_2d = get_parent()
	var character = node_2d.get_node("Character")
	character.play("idle")
	setup_potion_frames()

func setup_potion_frames():
	potion_frames = [
		node_2d.get_node("PotionFrame1"),
		node_2d.get_node("PotionFrame2"),
		node_2d.get_node("PotionFrame3")
	]
	# Initialize frames as blank
	for frame in potion_frames:
		frame.texture = null

func _on_toggle_inventory_pressed() -> void:
	if inventory_display.is_visible_in_tree():
		inventory_display.close()
	else:
		inventory_display.open()


func _on_toggle_crafting_pressed() -> void:
	if home_menu.is_visible_in_tree():
		home_menu.hide()
		crafting_menu.show()
		crafting_menu.populate_crafting(home_menu.selected_recipes)
	else:
		home_menu.show()
		crafting_menu.hide()

func _on_open_shop_button_pressed():
	if check_enabled_recipes():
		crafting_menu.populate_crafting(home_menu.selected_recipes)
		update_selected_recipes_display()
		transition_to_shop_state()

func check_enabled_recipes():
	# Check if at least 1 recipe has been enabled
	return home_menu.selected_recipes.size() > 0

func update_selected_recipes_display():
	# First clear all frames
	for frame in potion_frames:
		frame.texture = null
	
	# Update frames with selected recipes
	for i in range(min(home_menu.selected_recipes.size(), 3)):
		var recipe = home_menu.selected_recipes[i]
		if PotionItem:
			var texture = recipe.output.item.frame_texture
			potion_frames[i].texture = texture

func transition_to_shop_state():
	#blah blah blah fade to black or something
	$HomeMenu.visible = false
	pass
