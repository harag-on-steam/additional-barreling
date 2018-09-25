require("functions")

local fluid = data.raw.fluid["liquid-coolant-used"]
local builder = nil

if fluid then
    builder = barrelFluid("liquid-coolant-used")
    if builder then
        builder.fluidIngredient.minimum_temperature = 285
        builder.fluidIngredient.maximum_temperature = 350
        builder.fluidProduct.temperature = 285
        builder:build()
    end
end

fluid = data.raw.fluid["omnic-acid"]
if fluid then
    -- it seems the game can't handle barrels for fluids with composite icons
    fluid.icon = "__omnimatter__/graphics/icons/omnic-acid.png"
    fluid.icon_size = 32
    fluid.icons = nil
    builder = barrelFluid("omnic-acid")
    if builder then builder:build() end
end

fluid = data.raw.fluid["omniston"]
if fluid then
    -- it seems the game can't handle barrels for fluids with composite icons
    fluid.icon = "__omnimatter__/graphics/icons/omniston.png"
    fluid.icon_size = 32
    fluid.icons = nil
    builder = barrelFluid("omniston")
    if builder then builder:build() end
end