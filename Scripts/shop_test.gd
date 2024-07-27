extends Node2D

signal crafted

var customer_scene = preload("res://Scenes/customer.tscn")
@onready var dialogue_box = $DialogueBox
@onready var crafting_menu = %CraftingMenu
var crafted_potion : Item

@export var available_potions  : Array[CraftRecipe]
var customers : Array[Customer]
var customer_amount = 5
var current_customer : Customer

func _ready() -> void:
	GlobalData.potion_crafted.connect(potion_crafted)
	spawn_customers()
	next_customer()
	pass

func spawn_customers():
	for i in range(customer_amount):
		var new_customer : Customer = customer_scene.instantiate()
		new_customer.wanted_potion = available_potions[randi_range(0, available_potions.size()-1)]
		customers.append(new_customer)
		$CustomerSpawn.add_child(new_customer)


func next_customer():
	if current_customer:
		current_customer.direction = 1
	if customers:
		current_customer = customers[0]
		customers.remove_at(0)
		current_customer.direction = -1
		
func potion_crafted():
	pass

func _on_dialogue_signal(value):
	match(value):
		'next_customer': next_customer()
		'craft' : crafting_menu.show()

func _on_dialogue_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.direction = 0
	dialogue_box.start("start")

func _on_despawn_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.queue_free()
