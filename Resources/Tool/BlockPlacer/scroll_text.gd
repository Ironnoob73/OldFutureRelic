@tool
extends RichTextEffect
class_name RichTextScroll

var bbcode = "scroll"

func _process_custom_fx(char_fx):
	var speed = char_fx.env.get("freq", 30.0)
	var span = char_fx.env.get("span", 4.0)
	var width = char_fx.env.get("width", 150.0)
	char_fx.offset.x = -wrap(char_fx.elapsed_time * speed,(width*1.5)+(char_fx.range.x*span),char_fx.range.x*span ) + width
	return true
