using ArcadeLearningEnvironment
using Test

# TODO: find a public domain ROM and test on that

ale = ALE_new()

# This value is set in ale.cfg
@test getFloat(ale, "repeat_action_probability") == 0.0

ALE_del(ale)

