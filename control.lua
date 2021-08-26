function toggle_view(player, view, show)
    local settings = player.game_view_settings
    settings[view] = show
end

function toggle_view_map(player, show)
    toggle_view(player, "show_minimap", show)
end
function toggle_view_quickbar(player, show)
    toggle_view(player, "show_quickbar", show)
end
function toggle_view_shortcut_bar(player, show)
    toggle_view(player, "show_shortcut_bar", show)
end

local function init_player(player)

    -- game.print("init_player")

    if player.character == nil then return end

    local inventory_armor = player.get_inventory(defines.inventory.character_armor)

    -- if inventory_armor == nil then
    --     game.print("nil inventory_armor")
    -- end

    if inventory_armor == nil or inventory_armor.is_empty() then
        player.character.character_running_speed_modifier = -0.4
        toggle_view_map(player, false)
        toggle_view_quickbar(player, false)
        toggle_view_shortcut_bar(player, false)
    else
        local inventory_armor_content = inventory_armor.get_contents()
        if inventory_armor_content["light-armor"] ~= nil then
            toggle_view_map(player, true)
            toggle_view_quickbar(player, true)
            toggle_view_shortcut_bar(player, false)
            player.character.character_running_speed_modifier = -0.3
        elseif inventory_armor_content["heavy-armor"] ~= nil then
            toggle_view_map(player, true)
            toggle_view_quickbar(player, true)
            toggle_view_shortcut_bar(player, false)
            player.character.character_running_speed_modifier = -0.1
        else
            toggle_view_map(player, true)
            toggle_view_quickbar(player, true)
            toggle_view_shortcut_bar(player, true)
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

local function on_configuration_changed(event)
    for i, player in pairs(game.players) do
      init_player(game.players[i])
    end
end

local function on_player_joined_game(event)
    local player = game.players[event.player_index]
    init_player(player)
end

local function on_player_armor_inventory_changed(event)
    local player = game.players[event.player_index]
    init_player(player)
end

local function on_research_finished(event)
    local players = event.research.force.players
    for i in pairs(players) do
        init_player(players[i])
    end
end

-- script.on_event(defines.events.on_tick, on_configuration_changed)
script.on_event(defines.events.on_player_joined_game, on_player_joined_game)
script.on_event(defines.events.on_cutscene_cancelled, on_configuration_changed)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_player_armor_inventory_changed, on_player_armor_inventory_changed)
script.on_event(defines.events.on_research_finished, on_research_finished)
