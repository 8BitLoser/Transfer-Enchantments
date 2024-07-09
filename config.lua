local configPath = "Transfer Enchantment"


---@class bsTransferEnchant<K, V>: { [K]: V }
local defaults = {
    keycode = { --Keycode to trigger menu
        keyCode = tes3.scanCode.y,
        isShiftDown = false,
        isAltDown = false,
        isControlDown = false,
    },
}


---@class bsTransferEnchant
local config = mwse.loadConfig(configPath, defaults)

local function registerModConfig()
    local template = mwse.mcm.createTemplate({ name = configPath })
        template:saveOnClose(configPath, config)

    local settings = template:createPage({ label = "Settings" })

    settings:createKeyBinder({
        label = "Key To Open Transfer Menu",
        variable = mwse.mcm.createTableVariable { id = "keycode", table = config },
        allowCombinations = false,
    })

    template:register()
end
event.register(tes3.event.modConfigReady, registerModConfig)

return config