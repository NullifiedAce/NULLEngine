extends Node

var default_judgements:Array[Judgement] = [
	Judgement.create("sick",	350,	45.0,	1.0,	1.0,	true,	Color.FOREST_GREEN),
	Judgement.create("good",	200,	75.0,	0.7,	1.0,	false,	Color.DEEP_SKY_BLUE),
	Judgement.create("bad",		100,	90.0,	0.3,	0.75,	false,	Color.ORANGE),
	Judgement.create("shit",	50,		135.0,	0.0,	-4.5,	false,	Color.DARK_RED)
]
var default_ranks:Array[AccuracyRank] = []
var null_rank:AccuracyRank

var judgements:Array[Judgement] = []
var ranks:Array[AccuracyRank] = []

var final_score: int = 0
var final_misses: int = 0
var final_max_combo: int = 0

var final_sicks: int = 0
var final_goods: int = 0
var final_bads: int = 0
var final_shits: int = 0

var total_notes: int = 0
var hittable_notes: int = 0

func judgement_from_time(time:float):
	for j in judgements:
		if j.ms_needed >= absf(time):
			return j

	return judgements[judgements.size()-1]

func rank_from_accuracy(accuracy:float):
	for r in ranks:
		if r.accuracy_needed <= accuracy:
			return r

	return null_rank

func create_default_ranks():
	default_ranks.clear()
	for i:HUDAccuracyRank in HUDHandler.accuracy_ranks:
		if i.null_rank:
			null_rank = AccuracyRank.create(i.rank_name, 0.0)
		else:
			default_ranks.append(AccuracyRank.create(i.rank_name, i.rank_accuracy))

func set_results(score: int = 0, misses: int = 0, max_combo: int = 0, sicks: int = 0, goods: int = 0, bads: int = 0, shits: int = 0, total: int = 0):
	final_score = score
	final_misses = misses
	final_max_combo = max_combo

	final_sicks = sicks
	final_goods = goods
	final_bads = bads
	final_shits = shits

	hittable_notes = total

	total_notes = final_sicks + final_goods + final_bads + final_shits

func add_results(score: int = 0, misses: int = 0, max_combo: int = 0, sicks: int = 0, goods: int = 0, bads: int = 0, shits: int = 0, total: int = 0):
	final_score += score
	final_misses += misses
	if max_combo >= final_max_combo:
		final_max_combo = max_combo

	final_sicks += sicks
	final_goods += goods
	final_bads += bads
	final_shits += shits

	hittable_notes += total

	total_notes += final_sicks + final_goods + final_bads + final_shits

func clear_results():
	final_score = 0
	final_misses = 0
	final_max_combo = 0

	final_sicks = 0
	final_goods = 0
	final_bads = 0
	final_shits = 0

	hittable_notes = 0

	total_notes = 0
