using ArcadeLearningEnvironment

# For this example you need to obtain the Seaquest ROM file from
# https://atariage.com/system_items.html?SystemID=2600&ItemTypeID=ROM

episodes = 50

ale = ALE_new()
rom = string(ENV["ATARI_DIR"], "SEAQUEST.BIN")
println(rom)
loadROM(ale, rom)

S = Array{Int}(undef, episodes)
TR = Array{Float64}(undef, episodes)
for ei = 1:episodes
    ctr = 0.0

    fc = 0
    while game_over(ale) == false
        actions = getLegalActionSet(ale)
        ctr += act(ale, actions[rand(1:length(actions))])
        fc += 1
    end
    reset_game(ale)
    println("Game $ei ended after $fc frames with total reward $(ctr).")

    S[ei] = fc
    TR[ei] = ctr
end
ALE_del(ale)
