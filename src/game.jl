# The following was inspired by AtariAlgos.jl
# Modifications by Dennis Wilson @d9w

using Colors
using ImageCore
using ImageTransformations
export
    Game,
    close!,
    draw,
    get_inputs,
    get_rgb,
    get_float,
    get_int,
    get_bool,
    get_string

rom_directory(x::String) = joinpath(dirname(@__FILE__), "..", "deps", "rom_files", "$x.bin")

struct Game
    ale::ALEPtr
    width::Int
    height::Int
    actions::Array{Int32}
end

function Game(romfile::String, seed::Int64)
    ale = ALE_new()
    setInt(ale, "random_seed", Cint(seed))
    loadROM(ale, string(rom_directory(romfile)))
    w = getScreenWidth(ale)
    h = getScreenHeight(ale)
    actions = getMinimalActionSet(ale)
    Game(ale, w, h, actions)
end

function close!(game::Game)
    ALE_del(game.ale)
end

function draw(game::Game)
    rawscreen = Array{Cuchar}(undef, game.width * game.height * 3)
    getScreenRGB(game.ale, rawscreen)
    colorview(RGB, Float64.(reshape(rawscreen/256.,
                                    (3, game.width, game.height))))';
end

function get_inputs(game::Game)
    screen = getScreen(game.ale)/(0xff*1.0)
    screen = reshape(screen, (game.width, game.height))'
    # imresize(screen, (42, 32))/256.
    screen
end

function get_rgb(game::Game)
    rawscreen = Array{Cuchar}(undef, game.width * game.height * 3)
    getScreenRGB(game.ale, rawscreen)
    rgb = Float64.(reshape(rawscreen/256.,(3, game.width, game.height)));
    [rgb[i,:,:]' for i in 1:3]
end

# Read access to A.L.E. configuration:
get_float(game::Game, key::String) = getFloat(game.ale, key)
get_int(game::Game, key::String) = getInt(game.ale, key)
get_bool(game::Game, key::String) = getBool(game.ale, key)
get_string(game::Game, key::String) = getString(game.ale, key)