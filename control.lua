local function init_player(player)

    local inventory_armor = player.get_inventory(defines.inventory.character_armor)

    if inventory_armor.is_empty() then
        player.character.character_running_speed_modifier = -0.4
    else
        local inventory_armor_content = inventory_armor.get_contents()
        if inventory_armor_content["light-armor"] ~= nil then
            player.character.character_running_speed_modifier = -0.3
        elseif inventory_armor_content["heavy-armor"] ~= nil then
            player.character.character_running_speed_modifier = -0.1
        elseif inventory_armor_content["modular-armor"] ~= nil then
            player.character.character_running_speed_modifier = 0.1
        end
    end

    local steelAxe = player.force.technologies["steel-axe"]
    if steelAxe.researched then
        player.character.character_mining_speed_modifier = -0.5
    else
        player.character.character_crafting_speed_modifier = -0.4
        player.character.character_mining_speed_modifier = -0.9
    end
end

local function on_player_joined_game(event)
    local player = game.players[event.player_index]
    init_player(player)
end

local function on_player_armor_inventory_changed(event)
    -- game.print("on_player_armor_inventory_changed")
    local player = game.players[event.player_index]
    init_player(player)
end

local function on_research_finished(event)
    local players = event.research.force.players
    for i in pairs(players) do
        init_player(players[i])
    end
end

script.on_event(defines.events.on_player_joined_game, on_player_joined_game)
script.on_event(defines.events.on_player_armor_inventory_changed, on_player_armor_inventory_changed)
script.on_event(defines.events.on_research_finished, on_research_finished)
