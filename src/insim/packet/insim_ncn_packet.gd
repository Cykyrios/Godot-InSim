class_name InSimNCNPacket
extends InSimPacket

## New ConN packet

const USER_NAME_MAX_LENGTH := 24
const PLAYER_NAME_MAX_LENGTH := 24

const PACKET_SIZE := 56
const PACKET_TYPE := InSim.Packet.ISP_NCN
var ucid := 0  ## connection's unique id (0 = host)

var user_name := ""  ## username
var player_name := ""  ## nickname

var admin := 0  ## 1 if admin
var total := 0  ## number of connections including host
var flags := 0  ## bit 2: remote
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte()
	user_name = read_string(USER_NAME_MAX_LENGTH)
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	admin = read_byte()
	total = read_byte()
	flags = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"UName": user_name,
		"PName": player_name,
		"Admin": admin,
		"Total": total,
		"Flags": flags,
		"Sp3": sp3,
	}
