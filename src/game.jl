# The following was trimmed down and modified from AtariAlgos.jl, which is
# licensed under the MIT "Expat" License:
# Copyright (c) 2015: Thomas Breloff.
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# Modifications by Dennis Wilson @d9w

using Colors
export Game, draw, update, reset, step

rom_directory(x::String) = joinpath(dirname(@__FILE__), "..", "deps", "rom_files", "$x.bin")

type Game
    ale::ALEPtr
    lives::Int
    died::Bool
    reward::Float64
    score::Float64
    nframes::Int
    width::Int
    height::Int
    rawscreen::Vector{Cuchar}
    state::Vector{Float64}
    screen::Matrix{RGB{Float64}}
    actions::Vector{Int32}
end

function Game(romfile::String)
    ale = ALE_new()
    loadROM(ale, string(rom_directory(romfile)))
    w = getScreenWidth(ale)
    h = getScreenHeight(ale)
    rawscreen = Array{Cuchar}(w * h * 3)
    state = Array{Float64}(length(rawscreen))
    screen = fill(RGB{Float64}(0,0,0), h, w)
    actions = getLegalActionSet(ale)
    Game(ale, lives(ale), false, 0., 0., 0, w, h, rawscreen, state, screen, actions)
end

function Base.close(game::Game)
    ALE_del(game.ale)
end

function draw(game::Game)
    idx = 1
    for i in 1:game.height, j in 1:game.width
        game.screen[i,j] = RGB{Float64}(game.state[idx], game.state[idx+1], game.state[idx+2])
        idx += 3
    end
    game.screen
end

function update(game::Game)
    # get the raw screen data
    getScreenRGB(game.ale, game.rawscreen)
    for i in eachindex(game.rawscreen)
        game.state[i] = game.rawscreen[i] / 256.
    end
    game.lives = lives(game.ale)
    game.state
end

function Base.reset(game::Game)
    reset_game(game.ale)
    game.lives = 0
    game.died = false
    game.reward = 0
    game.score = 0
    game.nframes = 0
    update(game)
end

function Base.step(game::Game, action::Int32)
    # act and get the reward and new state
    game.reward = act(game.ale, action)
    game.score += game.reward
    update(game)
    game.reward, game.state
end
