extends Node

var default_judgements:Array[Judgement] = [
	Judgement.create("sick", 350, 45.0, 1.0, 1.0, true, Color.CYAN),
	Judgement.create("good", 200, 75.0, 0.7, 1.0, false, Color.GREEN),
	Judgement.create("bad", 100, 90.0, 0.3, 0.75, false, Color.YELLOW),
	Judgement.create("shit", 50, 135.0, 0.0, -4.5, false, Color.RED)
]
var default_ranks:Array[AccuracyRank] = []
var null_rank:AccuracyRank

var judgements:Array[Judgement] = []
var ranks:Array[AccuracyRank] = []

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
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("s+ rank"), 100.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("s rank"), 90.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("a rank"), 80.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("b rank"), 70.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("c rank"), 55.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("d rank"), 45.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("e rank"), 40.0))
	default_ranks.append(AccuracyRank.create(SettingsAPI.get_setting("f rank"), 0.000001))

	null_rank = AccuracyRank.create(SettingsAPI.get_setting("null rank"), 0.0)