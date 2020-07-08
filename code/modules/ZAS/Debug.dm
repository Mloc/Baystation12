var/image/assigned = image('icons/Testing/Zone.dmi', icon_state = "assigned")
var/image/created = image('icons/Testing/Zone.dmi', icon_state = "created")
var/image/merged = image('icons/Testing/Zone.dmi', icon_state = "merged")
var/image/invalid_zone = image('icons/Testing/Zone.dmi', icon_state = "invalid")
var/image/air_blocked = image('icons/Testing/Zone.dmi', icon_state = "block")
var/image/zone_blocked = image('icons/Testing/Zone.dmi', icon_state = "zoneblock")
var/image/blocked = image('icons/Testing/Zone.dmi', icon_state = "fullblock")
var/image/mark = image('icons/Testing/Zone.dmi', icon_state = "mark")

#ifdef ZASDBG
/connection_edge/var/dbg_out = 0

/turf/var/tmp/dbg_img
/turf/proc/dbg(image/img, d = 0)
	if(!GLOB.zas_debug_overlays)
		return
	if(d > 0) img.dir = d
	overlays -= dbg_img
	overlays += img
	dbg_img = img

proc/zas_soft_assert(thing,fail)
	if(!thing) message_admins(fail)

/client/verb/dumpZASTopology()
	set category = "ZAS"
	set name = "Dump ZAS Topology"

	if(!check_rights(R_DEBUG)) return

	var/list/zones = list()
	var/list/edges = list()
	var/list/unsim_edges = list()

	var/list/considered_edges = list()
	for(var/zone/Z)
		if(Z.invalid)
			continue

		zas_soft_assert(Z.contents.len > 0)

		var/list/air = list(
			"temperature" = Z.air.temperature,
			"gas" = Z.air.gas)

		zones[++zones.len] = list(
			"id" = Z.name,
			"size" = Z.contents.len,
			"air" = air)

		considered_edges |= Z.edges
	
	for(var/connection_edge/zone/ZE in considered_edges)
		edges[++edges.len] = list(
			"zone_a" = ZE.A.name,
			"zone_b" = ZE.B.name,
			"coefficient" = ZE.coefficient,
			"direct" = ZE.direct)

	for(var/connection_edge/unsimulated/UE in considered_edges)
		var/list/unsim_air = list(
			"temperature" = UE.air.temperature,
			"gas" = UE.air.gas)

		edges[++edges.len] = list(
			"zone" = UE.A.name,
			"zone_b" = UE.B.name,
			"coefficient" = UE.coefficient,
			"direct" = UE.direct,
			"air" = unsim_air)
	
	var/list/out = list(
		"zones" = zones,
		"edges" = edges,
		"unsim_edges" = unsim_edges)

	text2file(json_encode(out), "zas_topology.json")
#endif
