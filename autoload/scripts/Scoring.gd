extends Node

func scoreNote(msTiming: float, scoringSystem: String):
	match scoringSystem:
		"LEGACY":	return scoreNoteLEGACY(msTiming)
		"WEEK7":	return scoreNoteWEEK7(msTiming)
		"PBOT1":	return scoreNotePBOT1(msTiming)
		_:			push_error("Unknown scoring system: " + scoringSystem)

func judgeNote(msTiming: float, scoringSystem: String):
	match scoringSystem:
		"LEGACY":	return scoreNoteLEGACY(msTiming)
		"WEEK7":	return scoreNoteWEEK7(msTiming)
		"PBOT1":	return judgeNotePBOT1(msTiming)
		_:
			push_error("Unknown scoring system: " + scoringSystem)
			return "miss"

# The maximum score a note can receive.
const PBOT1_MAX_SCORE:int = 500

# The offset of the sigmoid curve for the scoring function.
const PBOT1_SCORING_OFFSET:float = 54.99

# The slope of the sigmoid curve for the scoring function.
const PBOT1_SCORING_SLOPE:float = 0.080

# The minimum score a note can receive while still being considered a hit.
const PBOT1_MIN_SCORE:float = 9.0

# The score a note receives when it is missed.
const PBOT1_MISS_SCORE:int = 0

# The threshold at which a note hit is considered perfect and always given the max score.
const PBOT1_PERFECT_THRESHOLD:float = 5.0 # 5ms

# The threshold at which a note hit is considered missed.
const PBOT1_MISS_THRESHOLD:float = 160.0

# The time within which a note is considered to have been hit with the Killer judgement.
# `~7.5% of the hit window, or 12.5ms`
const PBOT1_KILLER_THRESHOLD:float = 12.5

# The time within which a note is considered to have been hit with the Sick judgement.
# `~25% of the hit window, or 45ms`
const PBOT1_SICK_THRESHOLD:float = 45.0

# The time within which a note is considered to have been hit with the Good judgement.
# `~55% of the hit window, or 90ms`
const PBOT1_GOOD_THRESHOLD:float = 90.0

# The time within which a note is considered to have been hit with the Bad judgement.
# `~85% of the hit window, or 135ms`
const PBOT1_BAD_THRESHOLD:float = 135.0

# The time within which a note is considered to have been hit with the Shit judgement.
# `100% of the hit window, or 160ms`
const PBOT1_SHIT_THRESHOLD:float = 160.0

func scoreNotePBOT1(msTiming:float):
	var absTiming:float = abs(msTiming)

	if absTiming > PBOT1_MISS_THRESHOLD:
		return PBOT1_MISS_SCORE
	elif absTiming < PBOT1_PERFECT_THRESHOLD:
		return PBOT1_MAX_SCORE
	else:
		# Fancy equation (idfk what math is done here. I didn't code this I just copied FNF's code -NULL)
		var factor:float = 1.0 - (1.0 / (1.0 + exp(-PBOT1_SCORING_SLOPE * (absTiming - PBOT1_SCORING_OFFSET))))

		var score:int = int(PBOT1_MAX_SCORE * factor + PBOT1_MIN_SCORE)
		return score

func judgeNotePBOT1(msTiming:float):
	var absTiming:float = abs(msTiming)

	if absTiming < PBOT1_SICK_THRESHOLD:
		return "sick"
	elif absTiming < PBOT1_GOOD_THRESHOLD:
		return "good"
	elif absTiming < PBOT1_BAD_THRESHOLD:
		return "bad"
	elif absTiming < PBOT1_SHIT_THRESHOLD:
		return "shit"
	else:
		push_warning("Missed note: Bad timing %0d" % (absTiming < PBOT1_SHIT_THRESHOLD))
		return "miss"

func scoreNoteWEEK7(msTiming:float):
	pass

func scoreNoteLEGACY(msTiming:float):
	pass
