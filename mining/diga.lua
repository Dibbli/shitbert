local pos = 0
local fuel = "minecraft:lava_bucket"
local keep = {
    [fuel] = true,
    ["minecraft:raw_iron"] = true,
    ["minecraft:raw_gold"] = true,
    ["minecraft:raw_copper"] = true,
    ["minecraft:diamond"] = true,
    ["minecraft:emerald"] = true,
    ["minecraft:coal"] = true,
    ["minecraft:bucket"] = true,
    ["minecraft:ancient_debris"] = true,
}
local badFluid = "minecraft:lava"
local dir = 1
local length = 30
local forwardCounter = 0 -- Counter for forward moves without finding anything to break
print("Initial fuel Level: ", turtle.getFuelLevel())

local function attemptRefuel()
    print("Fuel low, attempting to refuel... ")
    for i = 1, 16 do                                         -- for each slot in the chest
        local item = turtle.getItemDetail(i, false)
        if item then                                         -- if there is an item in this slot
            if (string.format("%s", item.name) == fuel) then -- if the item is in the whitelist
                turtle.select(i)
                turtle.refuel(1)
                print("Fuel Level: ", turtle.getFuelLevel())
            end
        end
    end
end

local function checkInv()
    for i = 1, 16 do                                         -- for each slot in the chest
        local item = turtle.getItemDetail(i, false)
        if item then                                         -- if there is an item in this slot
            if not keep[string.format("%s", item.name)] then -- if the item is not in the whitelist
                turtle.select(i)
                turtle.drop()
            end
        end
    end
end

local function select()
    for i = 1, 16 do                                         -- for each slot in the chest
        local item = turtle.getItemDetail(i, false)
        if item then                                         -- if there is an item in this slot
            if not keep[string.format("%s", item.name)] then -- if the item is NOT in the whitelist
                turtle.select(i)
            end
        end
    end
end

local function lava() --allows the turtle to detect lava infront of it and place a block to remove it
    local isBlock, block = turtle.inspectUp()
    if isBlock then
        if block.name == "minecraft:lava" then
            turtle.up()
            isBlock, block = turtle.inspectUp()
            if isBlock then
                if block.name == "minecraft:lava" then
                    select()
                    turtle.placeUp()
                end
            end
            turtle.down()
        end
    end
    isBlock, block = turtle.inspectDown() --also check for lava below the turtle
    if isBlock then
        if block.name == "minecraft:lava" then
            turtle.down()
            isBlock, block = turtle.inspectDown()
            if isBlock then
                if block.name == "minecraft:lava" then
                    select()
                    turtle.placeDown()
                end
            end
            turtle.up()
        end
    end
end

local function loop()
    local ready = true

    lava()

    while ready do
        while turtle.detect() do
            turtle.dig()
        end
        while turtle.detectUp() do
            turtle.digUp()
        end
        while turtle.detectDown() do
            turtle.digDown()
        end

        if not turtle.detect() then
            ready = false
        end
    end
    lava()
    turtle.forward()

    if not turtle.detect() then
        forwardCounter = forwardCounter + 1
        if forwardCounter >= 10 then
            print("Stopping due to moving forward 10 times without finding anything to mine.")
            os.exit()
        end
    else
        forwardCounter = 0 -- Reset the counter if a block is detected
    end
end

while true do
    if (pos == length) then
        pos = -1
    end

    while (turtle.getFuelLevel() < 160) do
        attemptRefuel()
    end
    loop()

    if (pos == -1) then
        if (dir == 1) then
            turtle.turnRight()
            dir = 0
            loop()
            turtle.turnRight()
        else
            turtle.turnLeft()
            dir = 1
            loop()
            turtle.turnLeft()
        end
        checkInv()
    end
    pos = pos + 1
end
