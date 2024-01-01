class_name InSimTTCPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_TTC
var sub_type := InSim.TTC.TTC_NONE

var ucid := 0
var b1 := 0
var b2 := 0
var b3 := 0


func _init(req := 0, subt := InSim.TTC.TTC_NONE) -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	req_i = req
	sub_type = subt


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	sub_type = read_byte(packet) as InSim.TTC
	ucid = read_byte(packet)
	b1 = read_byte(packet)
	b2 = read_byte(packet)
	b3 = read_byte(packet)


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)
	add_unsigned(ucid)
	add_unsigned(b1)
	add_unsigned(b2)
	add_unsigned(b3)


func _get_data_dictionary() -> Dictionary:
	var dict := {
		"SubT": sub_type,
		"UCID": ucid,
		"B1": b1,
		"B2": b2,
		"B3": b3,
	}
	return dict
