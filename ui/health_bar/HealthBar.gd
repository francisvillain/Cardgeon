extends TextureProgress

export var color_under : Color 
export var color_progress : Color

func _ready():
	self.tint_under = color_under
	self.tint_progress = color_progress


func progress_update(progress : float) -> void:
	self.value = progress

