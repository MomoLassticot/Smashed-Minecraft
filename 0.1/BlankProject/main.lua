require("game_conf")


camera_position_x = ((conf_world_len_x * 80) / 2)*-1
camera_position_y = ((conf_world_len_y  * 80) / 2)*-1

function love.load()
    number = 0

    grass = love.graphics.newImage("asset/grass.png")
    dirt = love.graphics.newImage("asset/dirt.png")
    stone = love.graphics.newImage("asset/stone.png")
    bedrock = love.graphics.newImage("asset/bedrock.png")
    air = love.graphics.newImage("asset/air.png")
end

function love.update(dt)
    fps = love.timer.getFPS( )
    if love.keyboard.isDown("q") then
        camera_position_x = camera_position_x + (conf_speed * dt)
    end
    if love.keyboard.isDown("d") then
        camera_position_x = camera_position_x - (conf_speed * dt)
    end
    if love.keyboard.isDown("z") then
        camera_position_y = camera_position_y + (conf_speed * dt)
    end
    if love.keyboard.isDown("s") then
        camera_position_y = camera_position_y - (conf_speed * dt)
    end
end

function love.draw()
    local_conf_block_size = conf_block_size
    local_conf_air_layer = conf_air_layer
    local_conf_world_len_x = conf_world_len_x
    local_conf_world_len_y = conf_world_len_y
    block_tick = 0
    block_tick_Y = 0

    block = grass
    while block_tick < local_conf_world_len_x * local_conf_world_len_y do
        if block_tick % local_conf_world_len_x == 0 then
            block_tick_Y = block_tick_Y + 1
        end

        if block_tick < local_conf_world_len_x * local_conf_air_layer then 
            block = air
        elseif block_tick < local_conf_world_len_x * (local_conf_air_layer + 1) then
            block = grass
        elseif block_tick < local_conf_world_len_x * (local_conf_air_layer + 4) then
            block = dirt
        elseif block_tick_Y < local_conf_world_len_y then
            block = stone
        else
            block = bedrock
        end
        block_tick = block_tick + 1

        if ((block_tick % local_conf_world_len_x) * 80) + camera_position_x< love.graphics.getWidth( ) - admin_render_offset then
            if (block_tick_Y * 80) + camera_position_y > -80 + admin_render_offset then
                if (block_tick_Y * 80) + camera_position_y < love.graphics.getHeight( ) - admin_render_offset then
                    if ((block_tick % local_conf_world_len_x) * 80) + camera_position_x > -80 + admin_render_offset then
                    love.graphics.draw(block, (((block_tick % local_conf_world_len_x)* local_conf_block_size) + camera_position_x) , ((block_tick_Y * local_conf_block_size) + camera_position_y))
                    end
                end
            end
        end
    end




    love.graphics.print(fps)
end






function distance_between(x1, y1, x2, y2)
    return math.sqrt( (x2-x1)^2 + (y2-y1)^2)
end