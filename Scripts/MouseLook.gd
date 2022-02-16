extends Camera

const HALF_VECTOR2:Vector2 = Vector2.ONE / 2.0

var initialTransform:Transform = Transform.IDENTITY
var lastMousePosition:Vector2 = Vector2.ZERO
var lastScreenSize:Vector2 = Vector2.ZERO
var accumulator:Vector2 = Vector2.ZERO
var deadzone_radius:float = 150.0

func _ready():
	self.initialTransform = self.transform
	self.lastScreenSize = self.get_viewport().size
	self.lastMousePosition = self.lastScreenSize / 2.0


func _input(event):
	if event is InputEventMouseMotion:
		self.lastMousePosition = event.position
		print("[INFO]: MouseLook _input:MouseMotion: "+str(event.position)+".")#Debugging


func _process(delta):
	var scaledRatio = ((self.lastMousePosition / self.lastScreenSize) * 2.0 - Vector2.ONE)
	if(self.lastMousePosition.distance_to(self.lastScreenSize / 2.0) < self.deadzone_radius):
		pass
	else:
		#accumulator += -scaledRatio * 1.0 * delta
		accumulator.x += -scaledRatio.x * 1.0 * delta
		accumulator.y += scaledRatio.y * 1.0 * delta
	self.transform = self.initialTransform
	self.rotate_x(accumulator.y)
	self.rotate_y(accumulator.x)

