extends Node2D

export(Vector2) var textureSize = Vector2.ZERO
export(bool) var scaleWithWindow = true
export(bool) var forwardInput = true

var initialWindowSize:Vector2 = Vector2.ZERO
var lastWindowSize:Vector2 = Vector2.ZERO
var firstViewport:Viewport = null
var firstSprite:Sprite = null


func get_first_sprite():
	for kid in self.get_children():
		if kid is Sprite:
			return kid
	return null
func get_first_viewport():
	for kid in self.get_children():
		if kid is Viewport:
			return kid
	return null


func on_window_resized():
	self.lastWindowSize = self.get_viewport_rect().size


func _ready():
	self.initialWindowSize = self.get_viewport_rect().size
	self.on_window_resized()
	var error:int = self.get_tree().get_root().connect("size_changed", self, "on_window_resized")
	if error != 0:
		print("[ERROR]: 3dIn2DManager.gd Failed to connect to size_changed event/signal with code: " + str(error) + "!")#Debugging
	self.set_process_unhandled_input(self.forwardInput)
	self.set_process(self.scaleWithWindow)
	self.firstSprite = self.get_first_sprite()
	if self.firstSprite == null:
		print("Cats.")
		return
	self.firstViewport = self.get_first_viewport()
	if self.firstViewport == null:
		print("Dogs.")
		return
	self.firstSprite.centered = false
	self.firstSprite.position = Vector2.ZERO
	self.firstSprite.texture = self.firstViewport.get_texture()
	self.textureSize = self.firstViewport.size


func _unhandled_input(event):
	if(not self.forwardInput):
		self.set_process_unhandled_input(false)
		return
	if event is InputEventMouse:
		event.position += self.global_position
		print("[INFO]: 3DIn2DManager _unhandled_input:MouseEvent: "+str(event.position))
		pass
	if(self.firstViewport != null):
		self.firstViewport.input(event)
		return
	self.firstViewport = self.get_first_viewport()


func _process(_delta):
	if(!self.scaleWithWindow):
		self.set_process(false)
		return
	self.firstViewport.size = self.lastWindowSize
