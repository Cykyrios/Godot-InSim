class_name InSimLAPPacket
extends InSimPacket

## LAP time packet

const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_LAP
var player_id := 0  ## player's unique id

var lap_time := 0  ## lap time (ms)
var elapsed_time := 0  ## total time (ms)

var laps_done := 0  ## laps completed
var flags := 0  ## player flags

var sp0 := 0
var penalty := InSim.Penalty.PENALTY_NONE  ## current penalty value (see [enum InSim.Penalty])
var num_stops := 0  ## number of pit stops
var fuel200 := 0  ## /showfuel yes: double fuel percent / no: 255


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()
	lap_time = read_unsigned()
	elapsed_time = read_unsigned()
	laps_done = read_word()
	flags = read_word()
	sp0 = read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	fuel200 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"LTime": lap_time,
		"ETime": elapsed_time,
		"LapsDone": laps_done,
		"Flags": flags,
		"Sp0": sp0,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Fuel200": fuel200,
	}
