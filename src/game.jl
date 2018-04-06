# The following was inspired by AtariAlgos.jl
# Modifications by Dennis Wilson @d9w

using Colors
using ImageCore
using ImageTransformations
export
    Game,
    close!,
    draw,
    get_inputs

rom_directory(x::String) = joinpath(dirname(@__FILE__), "..", "deps", "rom_files", "$x.bin")

struct Game
    ale::ALEPtr
    width::Int
    height::Int
    actions::Array{Int32}
end

function Game(romfile::String)
    ale = ALE_new()
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
    rawscreen = Array{Cuchar}(game.width * game.height * 3)
    getScreenRGB(game.ale, rawscreen)
    colorview(RGB, Float64.(reshape(rawscreen/256.,
                                    (3, game.width, game.height))))';
end

function get_inputs(game::Game)
    screen = reshape(getScreen(game.ale), (game.width, game.height))'
    imresize(screen, (42, 32))/256.
end
