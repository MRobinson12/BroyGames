extends Node2D

var customer_scene = preload("res://Scenes/customer.tscn")
@onready var dialogue_box = %DialogueBox
@onready var crafting_menu = %CraftingMenu
var crafted_potion : Item

var available_potions  : Array[CraftRecipe]
var customers : Array[Customer]
var customer_amount = 5
var current_customer : Customer

func _ready() -> void:
	GlobalData.potion_crafted.connect(potion_crafted)
	$UI.open_shop.connect(open_shop)

func open_shop(recipes : Array[CraftRecipe]):
	available_potions = recipes
	spawn_customers()
	next_customer()

func spawn_customers():
	for i in range(customer_amount):
		var new_customer : Customer = customer_scene.instantiate()
		new_customer.wanted_potion = available_potions[randi_range(0, available_potions.size()-1)].output.item
		customers.append(new_customer)
		$CustomerSpawn.add_child(new_customer)

func next_customer():
	if current_customer:
		current_customer.direction = 1
	if customers:
		current_customer = customers[0]
		customers.remove_at(0)
		current_customer.direction = -1
		
func potion_crafted(potion : Item):
	%CraftingMenu.hide()
	$UI/NoCraft.hide()
	if potion == current_customer.wanted_potion:
		dialogue_box.start('correct')
	else:
		dialogue_box.start('incorrect')
		
func show_craft():
	crafting_menu.show()
	$UI/NoCraft.show()

func _on_dialogue_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.direction = 0
	dialogue_box.start(body.wanted_potion.id)

func _on_despawn_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.queue_free()

func _on_dialogue_box_dialogue_signal(value: String) -> void:
	match(value):
		'next_customer': next_customer()
		'craft' : show_craft()

func _on_no_craft_pressed() -> void:
	potion_crafted(null)
