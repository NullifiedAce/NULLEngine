extends Node

# GAME DEFAULTS
# ====================

# Default difficulty for charts.
const DEFAULT_DIFFICULTY:String = "normal"

# Default list of difficulties for charts.
# Assumes no erect mode, etc.
const DEFAULT_DIFFICULTY_LIST:Array[String] = ["easy", "normal", "hard"]

# Default difficulties for erect mode.
const DEFAULT_DIFFICULTY_LIST_ERECT:Array[String] = ["erect", "nightmare"]

# List of all difficulties used by the base game.
# Includes Erect and Nightmare.
const DEFAULT_DIFFICULTY_LIST_FULL:Array[String] = ["easy", "normal", "hard", "erect", "nightmare"]

# Default player character for charts.
const DEFAULT_CHARACTER:String = "bf"

# Default player character for health icons.
const DEFAULT_HEALTH_ICON:String = "face"

# Default stage for charts.
const DEFAULT_STAGE:String = "mainStage"

# Default song for if the Gameplay scene messes up.
const DEFAULT_SONG:String = "tutorial"

# Default variation for charts.
const DEFAULT_VARIATION:String = "default"

# Standardized variations for charts.
const DEFAULT_VARIATION_LIST:Array[String] = ["default", "erect", "pico"]

# The default intensitiy multiplier for camera bops.
# Prolly needs to be tuned bc it's a multiplier now.
const DEFAULT_BOP_INTENSITY:float = 1.015

# The default rate for camera zooms (in beats per zoom).
const DEFAULT_ZOOM_RATE:int = 4

# Default BPM for charts. so things don't break if none is specified.
const DEFAULT_BPM:float = 100

# HEALTH VALUES
# ====================

# The player's maximum health.
# If the player is at this value, they can't gain any more health.
const HEALTH_MAX:float = 2.0

# The player's starting health
const HEALTH_STARTING = HEALTH_MAX / 2

# The player's minimum health.
# If the player is at or below this value, they lose.
const HEALTH_MIN:float = 0.0

# The amount of health the player gains when hitting a note with the KILLER rating.
const HEALTH_KILLER_BONUS:float = 2.0 / 100.0 * HEALTH_MAX # +2.0%

# The amount of health the player gains when hitting a note with the SICK rating.
const HEALTH_SICK_BONUS:float = 1.5 / 100.0 * HEALTH_MAX # +1.5%

# The amount of health the player gains when hitting a note with the GOOD rating.
const HEALTH_GOOD_BONUS:float = 0.75 / 100.0 * HEALTH_MAX # +0.75%

# The amount of health the player gains when hitting a note with the BAD rating.
const HEALTH_BAD_BONUS:float = 0.0 / 100.0 * HEALTH_MAX # +0.0%

# The amount of health the player gains when hitting a note with the SHIT rating.
const HEALTH_SHIT_BONUS:float = -1.0 / 100.0 * HEALTH_MAX # -1.0%

# The amount of health the player gains, while holding a hold note, per second.
const HEALTH_HOLD_BONUS_PER_SECOND:float = 7.5 / 100.0 * HEALTH_MAX # +7.5% / second

# The amount of health the player loses upon missing a note.
const HEALTH_MISS_PENALTY:float = 4.0 / 100.0 * HEALTH_MAX # 4.0%

# The amount of health the player loses upon pressing a key when no note is there.
const HEALTH_GHOST_MISS_PENALTY:float = 2.0 / 100.0 * HEALTH_MAX # 2.0%

# The amount of health the player loses upon letting go of a hold note while it is still going.
const HEALTH_HOLD_DROP_PENALTY:float = 0.0 # 0.0%

# SCORE VALUES
# ====================

# The amount of score the player gains for every second they hold a hold note.
# A fraction of this value is granted every frame
const SCORE_HOLD_BONUS_PER_SECOND:float = 250.0

const JUDGEMENT_KILLER_COMBO_BREAK:bool = false
const JUDGEMENT_SICK_COMBO_BREAK:bool = false
const JUDGEMENT_GOOD_COMBO_BREAK:bool = false
const JUDGEMENT_BAD_COMBO_BREAK:bool = true
const JUDGEMENT_SHIT_COMBO_BREAK:bool = true

# % Sick
const RANK_PERFECT_PLAT_THRESHOLD:float = 1.0 # % Sick
const RANK_PERFECT_GOLD_THRESHOLD:float = 0.85 # % Sick

# % Hit
const RANK_PERFECT_THRESHOLD: float = 1.00
const RANK_EXCELLENT_THRESHOLD: float = 0.90
const RANK_GREAT_THRESHOLD: float = 0.80
const RANK_GOOD_THRESHOLD: float = 0.60
