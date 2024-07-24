local valid_fuels = {
    ["minecraft:lava_bucket"] = true,
}

for i = 1, 16 do
    local item = turtle.getItemDetail(i, false)
    if item and valid_fuels[item.name] then
        turtle.select(i)
        turtle.refuel()
    end
end

print("Lava buckets left to fill fuel: ", (turtle.getFuelLimit() - turtle.getFuelLevel()) / 1000)
