local _, AddonTable = ...
local L = AddonTable.L

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
local AdiBags_PetFood = LibStub("AceAddon-3.0"):NewAddon("AdiBags_PetFood")

-- Virag Dev Tool
AdiBags_PetFood.kbDEBUG = true
function AdiBags_PetFood:Dump(str, obj)
  if ViragDevTool_AddData and AdiBags_PetFood.kbDEBUG then 
    ViragDevTool_AddData(obj, str) 
  end
end

AddonTable.ItemTables = {
  fruit = {
    ['4537']  = true, -- Tel'abim Banana
  },
  meat = {
    ['117']   = true, -- Tough Jerky
    ['724']   = true, -- Goretusk Liver Pie [Cooking]
    ['729']   = true, -- Stringy Vulture Meat
    ['769']   = true, -- Chunk of Boar Meat
    ['2672']  = true, -- Stringy Wolf Meat
    ['2677']  = true, -- Boar Ribs
    ['2679']  = true, -- Charred Wolf Meat
    ['2680']  = true, -- Spiced Wolf Meat [Cooking]
    ['2681']  = true, -- Roasted Boar Meat [Cooking]
    ['2687']  = true, -- Dry Pork Ribs [Cooking]
    ['2886']  = true, -- Crag Boar Rib
    ['3685']  = true, -- Raptor Egg (is meat?)
    ['4655']  = true, -- Giant Clam Meat
    ['5469']  = true, -- Strider Meat
    ['5503']  = true, -- Clam Meat
    ['5504']  = true, -- Tangy Clam Meat
    ['7974']  = true, -- Zesty Clam Meat
    ['15924'] = true, -- Soft-shelled Clam Meat
  },
  fish = {
    ['6290']  = true, -- Brilliant Smallfish [Cooking]
    ['6291']  = true, -- Raw Brilliant Smallfish
  },
  fungus = {},
  bread = {
    ['4540']  = true, -- Tough Hunk of Bread
    ['4541']  = true, -- Freshly Baked Bread
  },
  misc = {},
}
AddonTable.Modules = {}

function AdiBags_PetFood:GetOptions()
  return {
    meat = {
      name = "meat",
      desc = 'Meat',
      type = 'toggle',
      order = 70,
    },
    fish = {
      name = "fish",
      desc = 'Fish',
      type = 'toggle',
      order = 70,
    },
    fungus = {
      name = "fungus",
      desc = 'Fungus',
      type = 'toggle',
      order = 70,
    },
    fruit = {
      name = "fruit",
      desc = 'Fruit',
      type = 'toggle',
      order = 70,
    },
    bread = {
      name = "bread",
      desc = 'Bread',
      type = 'toggle',
      order = 70,
    },
    misc = {
      name = "misc",
      desc = 'Misc',
      type = 'toggle',
      order = 70,
    },
  }
end

function AdiBags_PetFood:GetProfile()
  return {
    PetFood = true
  }
end

function AdiBags_PetFood:DefaultFilter(slotData, module, petFoodFilter)
  local prefix = module.prefix

  local ItemTables = AddonTable.ItemTables

  for categoryName, categoryDesc in pairs(ItemTables) do
    if (petFoodFilter.db.profile[categoryName]) then
      for id,_ in pairs(ItemTables[categoryName]) do
        if (tonumber(id) == slotData.itemId) then
          --return "Pet Food ("..categoryName..")"
          return "Pet Food"
        end
      end
    end
  end
end

function AdiBags_PetFood:GetDefaultCategories()
  return {
    ["Meat"] = "Meat",
    ["Fish"] = "Fish",
    ["Fruit"] = "Fruit",
    ["Fungus"] = "Fungus",
    ["Bread"] = "Bread",
    ["Misc"] = "Misc",
  }
end

function AdiBags_PetFood:Load(module)
  local petFoodFilter = AdiBags:RegisterFilter(module.namespace, 90)
  petFoodFilter.uiName = module.namespace
  petFoodFilter.uiDesc = module.description

  if module.filter ~=nil then
    function petFoodFilter:Filter(slotData)
      return module.filter(slotData)
    end
  else
    function petFoodFilter:Filter(slotData)
      return AdiBags_PetFood:DefaultFilter(slotData, module, petFoodFilter)
    end
  end

  function petFoodFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace(module.namespace, {
      profile = AdiBags_PetFood:GetProfile()
    })
  end

  function petFoodFilter:GetOptions()
    return AdiBags_PetFood:GetOptions(), AdiBags:GetOptionHandler(self, true)
  end
end

AddonTable.Modules.petfood = {
  ["name"] = "petfood",
  ["categories"] = AdiBags_PetFood:GetDefaultCategories(),
  ["namespace"] = "Pet Food",
  ["prefix"] = "Pet Food",
  ["description"] = "Pet food"
}

AdiBags_PetFood:Load(AddonTable.Modules.petfood)
