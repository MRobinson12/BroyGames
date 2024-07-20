extends PanelContainer

@onready var texture_rect : TextureRect = $Item

func display(item : Item):
	texture_rect.texture = item.icon
