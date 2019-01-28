using ArcadeLearningEnvironment

episodes = 50

game = Game("space_invaders", 101)
println("repeat_action_probability: ", get_float(game, "repeat_action_probability"))
println("frame_skip: ", get_int(game, "frame_skip"))
println("color_averaging: ", get_bool(game, "color_averaging"))
println("record_screen_dir: ", get_string(game, "record_screen_dir"))
println("Actions: ", game.actions)
println("Inputs: ", typeof(get_inputs(game)))
println("RGB: ", typeof(get_rgb(game)))
draw(game)
close!(game)
