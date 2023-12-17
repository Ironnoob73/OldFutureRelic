extends MeshInstance3D

@onready var screen = $Screen.material_override
@onready var viewport = $Viewport

@onready var ToolMode = $Viewport/ScreenTexture/Main/Mode
@onready var ToolBlockName = $Viewport/ScreenTexture/Main/BlockName
@onready var ToolBlockIcon = $Viewport/ScreenTexture/Main/BlockIcon
@onready var ToolLeftNumber = $Viewport/ScreenTexture/Main/LeftNumber

func _ready():
	screen.albedo_texture = viewport.get_texture()
	screen.emission_texture = viewport.get_texture()

func refresh_screen(block_name:String = "Null",block_icon:Texture = null,left_number:int = 0):
	ToolBlockName.text = "[scroll span=" + str(block_name.length()) + "]" + tr(block_name) + "[/scroll]"
	ToolBlockIcon.texture = block_icon
	ToolLeftNumber.text = str(left_number)
