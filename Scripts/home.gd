extends Node2D

var customer_scene = preload("res://Scenes/customer.tscn")
@onready var dialogue_box = %DialogueBox
@onready var crafting_menu = %CraftingMenu
@onready var home_menu = %HomeMenu
var crafted_potion : Item

var available_potions  : Array[CraftRecipe]
var customers : Array[Customer]
var customer_amount = 5
var current_customer : Customer

func _ready() -> void:
	GlobalData.potion_crafted.connect(potion_crafted)
	$UI.open_shop.connect(open_shop)
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	if GlobalData.day == 1:
		dialogue_box.start('CI1')
	if GlobalData.day >= 2:
		$UI/LeaveButton.hide()
		$UI/EndDemoButton.show()

func open_shop(recipes : Array[CraftRecipe]):
	if GlobalData.day > 1:
		dialogue_box.start('day2')
	available_potions = recipes
	spawn_customers()
	next_customer()

func close_shop():
	home_menu.disable_selection()
	home_menu.show()

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
	else:
		close_shop()
		
func potion_crafted(potion : Item):
	%CraftingMenu.hide()
	$UI/NoCraft.hide()
	if potion == current_customer.wanted_potion:
		$ShopCorrect.play()
		dialogue_box.start('correct')
		GlobalData.gold += 10
	else:
		$ShopIncorrect.play()
		dialogue_box.start('incorrect')
		
func show_craft():
	crafting_menu.show()
	$UI/NoCraft.show()

func stop_music():
	$ShopMusic.stop()

func start_music():
	$ShopMusic.play()

func show_buttons():
	$UI/LeaveButton.show()
	$UI/OpenShopButton.show()

func hide_buttons():
	$UI/LeaveButton.hide()
	$UI/OpenShopButton.hide()

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
		'stop_music' : stop_music()
		'start_music' : start_music()
		'show_buttons' : show_buttons()
		'hide_buttons' : hide_buttons()

func _on_no_craft_pressed() -> void:
	potion_crafted(null)


func _on_leave_button_button_down() -> void:
	GlobalData.day += 1
	get_tree().change_scene_to_file("res://Scenes/Levels/cave_level_tutorial.tscn")
	# CHANGE THIS TO LEVEL 1 ONCE IT IS IMPLEMENTED

func _on_char_displayed(idx):
	$DialogueBlip.play()


func _on_end_demo_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_leave_button_mouse_entered() -> void:
	$Trapdoor.open()

func _on_leave_button_mouse_exited() -> void:
	$Trapdoor.close()


func _on_secret_button_button_down() -> void:
	$SecretNoise.play()
