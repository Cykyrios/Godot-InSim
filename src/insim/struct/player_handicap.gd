class_name PlayerHandicap
extends InSimStruct

## Player handicaps

const MASS_MULTIPLIER := 1.0

const STRUCT_SIZE := 4

const H_MASS_MAX := 200
const H_TRES_MAX := 50

var player_id := 0  ## player's unique id
## bit 0: set [member h_mass] / bit 1: set [member h_tres] (e.g. flags = 3 to set both)
## / bit 7: silent
var flags := 0
var h_mass := 0:  ## 0 to 200 - added mass (kg)
	set(new_mass):
		h_mass = clampi(new_mass, 0, H_MASS_MAX)
var h_tres := 0:  ## 0 to 50 - intake restriction
	set(new_tres):
		h_tres = clampi(new_tres, 0, H_TRES_MAX)

var gis_mass := 0.0


func _to_string() -> String:
	return "(PLID %d, Flags %d, %dkg, %d%%)" % [player_id, flags, h_mass, h_tres]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, player_id)
	buffer.encode_u8(1, flags)
	buffer.encode_u8(2, h_mass)
	buffer.encode_u8(3, h_tres)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	player_id = buffer.decode_u8(0)
	flags = buffer.decode_u8(1)
	h_mass = buffer.decode_u8(2)
	h_tres = buffer.decode_u8(3)


func _set_values_from_gis() -> void:
	h_mass = gis_mass * MASS_MULTIPLIER


func _update_gis_values() -> void:
	gis_mass = h_mass / MASS_MULTIPLIER
