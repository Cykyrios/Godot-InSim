class_name InSimPENPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_PEN
var player_id := 0

var old_penalty := InSim.Penalty.PENALTY_NONE
var new_penalty := InSim.Penalty.PENALTY_NONE
var reason := InSim.PenaltyReason.PENR_NUM
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"PLID": player_id,
		"OldPen": old_penalty,
		"NewPen": new_penalty,
		"Reason": reason,
		"Sp3": sp3,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	old_penalty = read_byte(packet) as InSim.Penalty
	new_penalty = read_byte(packet) as InSim.Penalty
	reason = read_byte(packet) as InSim.PenaltyReason
	sp3 = read_byte(packet)
