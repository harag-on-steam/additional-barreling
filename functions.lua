function barrelFluid(fluidName)
	fluid = data.raw.fluid[fluidName]
	if not fluid or not fluid.icon then
		log("fluid " .. fluidName .. " does not exist or has no icon")
		return nil
	end

	local fluidIcon = fluid.icon
	local barrelName = fluidName .. "-barrel"
	local fillRecipeName = "fill-" .. barrelName
	local emptyRecipeName = "empty-" .. barrelName
	local order = "u[" .. barrelName .. "]"

	local sideTint = util.table.deepcopy(fluid.base_color)
	sideTint.a = 0.75
	local topHoopTint = util.table.deepcopy(fluid.flow_color)
	topHoopTint.a = 0.75

	local barrelItem = 
	{
		type = "item",
		name = barrelName,
		localised_name = {"item-name.filled-barrel", {"fluid-name." .. fluidName}},
		icons = {
			{icon = "__base__/graphics/icons/fluid/barreling/empty-barrel.png"},
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-side-mask.png", tint = sideTint},
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-hoop-top-mask.png", tint = topHoopTint},
		},
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "fill-barrel",
		order = order,
		stack_size = 10,
	}

	local fluidIngredient = {type= "fluid", name = fluidName, amount = 50}
	local fillRecipe = 
	{
		type = "recipe",
		name = fillRecipeName,
		localised_name = {"recipe-name.fill-barrel", {"fluid-name." .. fluidName}},
		enabled = true,
		subgroup = "fill-barrel",
		category = "barreling-pump",
		energy_required = 0.2,
		icons = {
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-fill.png"},
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-fill-side-mask.png", tint = sideTint},
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-fill-top-mask.png", tint = topHoopTint},
			{icon = fluidIcon, scale = 0.5, shift = {4, -8}},
		},
		icon_size = 32,
		order = order,
		ingredients = {
			{type = "item", name = "empty-barrel", amount = 1},
			fluidIngredient,
		},
		results = {
			{type = "item", name = barrelName, amount = 1},
		},
	}

	local fluidProduct = {type = "fluid", name = fluidName, amount = 50}
	local emptyRecipe = 
	{
		type = "recipe",
		name = emptyRecipeName,
		localised_name = {"recipe-name.empty-filled-barrel", {"fluid-name." .. fluidName}},
		enabled = true,
		subgroup = "empty-barrel",
		category = "barreling-pump",
		energy_required = 0.2,
		icons = {
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-empty.png"},
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-side-mask.png", tint = sideTint},
			{icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-top-mask.png", tint = topHoopTint},
			{icon = fluidIcon, scale = 0.5, shift = {7, 8}},
		},
		icon_size = 32,
		order = order,
		ingredients = {
			{type = "item", name = barrelName, amount = 1},
		},
		results = {
			fluidProduct,
			{type = "item", name = "empty-barrel", amount = 1},
		},
	}

	local builder = {}
	builder.barrelItem = barrelItem
	builder.fillRecipe = fillRecipe
	builder.emptyRecipe = emptyRecipe
	builder.fluidIngredient = fluidIngredient
	builder.fluidProduct = fluidProduct

	function builder:build()
		data:extend({ self.barrelItem, self.fillRecipe, self.emptyRecipe })
		local unlockTechnology = data.raw.technology["fluid-handling"].effects
		table.insert(unlockTechnology, { type = "unlock-recipe", recipe = self.fillRecipe.name})
		table.insert(unlockTechnology, { type = "unlock-recipe", recipe = self.emptyRecipe.name})
	end

	return builder
end
