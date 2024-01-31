require("game_conf")

local_conf_block_size = conf_block_size


camera_position_x = start_camera_position_x
camera_position_y = start_camera_position_y

world = {}

grass = {1, love.graphics.newImage("asset/grass.png")}
dirt = {2, love.graphics.newImage("asset/dirt.png")}
stone = {3, love.graphics.newImage("asset/stone.png")}
bedrock = {4, love.graphics.newImage("asset/bedrock.png")}
air = {5, love.graphics.newImage("asset/air.png")}

block_list = {grass, dirt, stone, bedrock, air, "caca"}

function love.load()
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
        
        table.insert(world, block[1])

        block_tick = block_tick + 1
    end
    print(table.concat(world,", "))
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

        -- if block_tick < local_conf_world_len_x * local_conf_air_layer then 
        --     block = air
        -- elseif block_tick < local_conf_world_len_x * (local_conf_air_layer + 1) then
        --     block = grass
        -- elseif block_tick < local_conf_world_len_x * (local_conf_air_layer + 4) then
        --     block = dirt
        -- elseif block_tick_Y < local_conf_world_len_y then
        --     block = stone
        -- else
        --     block = bedrock
        -- end
        block_tick = block_tick + 1

        if ((block_tick % local_conf_world_len_x) * local_conf_block_size) + camera_position_x< love.graphics.getWidth( ) - admin_render_offset then
            if (block_tick_Y * local_conf_block_size) + camera_position_y > -local_conf_block_size + admin_render_offset then
                if (block_tick_Y * local_conf_block_size) + camera_position_y < love.graphics.getHeight( ) - admin_render_offset then
                    if ((block_tick % local_conf_world_len_x) * local_conf_block_size) + camera_position_x > -local_conf_block_size + admin_render_offset then
                        a = world[block_tick]
                        block = block_list[a][2]
                        love.graphics.draw(block, (((block_tick % local_conf_world_len_x)* local_conf_block_size) + camera_position_x) , ((block_tick_Y * local_conf_block_size) + camera_position_y))
                    end
                end
            end
        end
    end
    for world = 1, 100 do
        love.graphics.rectangle("line", getBlockPositionX(world, camera_position_x), getBlockPositionY(world, camera_position_y), conf_block_size, local_conf_block_size)
    end
    x, y = love.mouse.getPosition( )
    if love.mouse.isDown(2) then
        destroyblock(getBlockNumber(x, y, camera_position_x, camera_position_y))
    end
    x, y = love.mouse.getPosition( )
    print(getBlockNumber(x, y, camera_position_x, camera_position_y))
    -- print("camX = ", camera_position_x)
    -- print("camY = ", camera_position_y)
    -- print("posX = ", getBlockPositionX(51, camera_position_x))
    -- print("posY = ", getBlockPositionY(51, camera_position_y))
    -- love.graphics.print(fps)
    -- love.graphics.rectangle("line", getBlockPositionX(1, camera_position_x), getBlockPositionY(1, camera_position_y), conf_block_size, local_conf_block_size)
    -- love.graphics.rectangle("line", getBlockPositionX(101, camera_position_x), getBlockPositionY(101, camera_position_y), conf_block_size, local_conf_block_size)
    -- love.graphics.rectangle("line", getBlockPositionX(201, camera_position_x), getBlockPositionY(201, camera_position_y), conf_block_size, local_conf_block_size)
    -- love.graphics.rectangle("line", getBlockPositionX(301, camera_position_x), getBlockPositionY(301, camera_position_y), conf_block_size, local_conf_block_size)
end





function getBlockPositionX(block_number, camx)
    ax = (block_number % conf_world_len_x)
    bx = ax * conf_block_size
    cx = bx + camx
    return cx
end
function getBlockPositionY(block_number, camy)
    a = math.floor(block_number / conf_world_len_x) +1
    b = a * local_conf_block_size
    c = b + (camy)
    return c
end

function getBlockNumber(position_x, position_y, camx, camy)
    ax = (math.floor((position_x - camx) / conf_block_size))
    bx = (math.floor((position_y - camy) / conf_block_size)) -  1
    cx = bx * conf_world_len_x
    dx = ax+cx
    return dx
end

function destroyblock(block_number)
    world[block_number] = 5
end