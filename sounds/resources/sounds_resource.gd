class_name SoundsResource
extends Resource

@export_group("SFX")
@export var walk:SfxResource
@export var run:SfxResource
@export var little_drop_collected:SfxResource
@export var jump:SfxResource
@export var land:SfxResource
@export var vanish:SfxResource
@export var victory:SfxResource
@export var teleport:SfxResource

@export_subgroup("Platforms", "platform_")
@export var platform_fall:SfxResource
@export var platform_button:SfxResource
@export var platform_teleport:SfxResource

@export_subgroup("Interface", "interface_")
@export var interface_select:SfxResource
@export var interface_back:SfxResource
@export var interface_enter:SfxResource
@export var interface_open:SfxResource
@export var interface_close:SfxResource

@export_group("Soundtracks")
@export var gameplay:AudioStream
@export var menu:AudioStream
@export var credits:AudioStream
