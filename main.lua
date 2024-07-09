local ui = require("BeefStranger.Transfer Enchantments.ui")
local bs = require("BeefStranger.Transfer Enchantments.common")
local cfg = require("BeefStranger.Transfer Enchantments.config")

local menu = {
    TopLevel = { --TopLevel Enchant Transfer Menu
        Main = nil, ---@type tes3uiElement
        text = nil, ---@type tes3uiElement
        text_Border = nil, ---@type tes3uiElement
        text_Border_Input = nil, ---@type tes3uiElement
        text_Label_Cost = nil, ---@type tes3uiElement
        text_Info = nil, ---@type tes3uiElement
        text_Info_Soul = nil, ---@type tes3uiElement
        text_Info_Slash = nil, ---@type tes3uiElement
        text_Info_Cost = nil, ---@type tes3uiElement
        select = nil, ---@type tes3uiElement
        select_Enchant = nil, ---@type tes3uiElement
        select_Enchant_Item = nil, ---@type tes3uiElement
        select_Target = nil, ---@type tes3uiElement
        select_Target_Item = nil, ---@type tes3uiElement
        select_SoulGem = nil, ---@type tes3uiElement
        select_SoulGem_Item = nil, ---@type tes3uiElement
        buttons = nil, ---@type tes3uiElement
        buttons_Close = nil, ---@type tes3uiElement
        buttons_Confirm = nil, ---@type tes3uiElement
    },

    ItemSelect = {  --ItemSelect Menu
        Main = nil, ---@type tes3uiElement
        scrollPane = nil, ---@type tes3uiElement
        scrollPane_Block = nil, ---@type tes3uiElement
        scrollPane_Block_Icon = nil,---@type tes3uiElement
        scrollPane_Block_Name = nil,---@type tes3uiElement
        close = nil, ---@type tes3uiElement
    },

}


local function createTransfer()
    local TransferEnchant = tes3ui.registerID("bsTransferEnchant")
    local TopLevel = menu.TopLevel

    menu.TopLevel.Main = tes3ui.createMenu({id = TransferEnchant, fixedFrame = true,})
        TopLevel.Main.autoHeight = true
        TopLevel.Main.autoWidth = true

    TopLevel.text = TopLevel.Main:createBlock{id = "Text Layout"}
        ui.autoSize(TopLevel.text)

    TopLevel.text_Border = TopLevel.text:createThinBorder({id = "Text Input Box"})
        TopLevel.text_Border.width = 230
        TopLevel.text_Border.height = 30
        TopLevel.text_Border.borderRight = 3
        TopLevel.text_Border.paddingAllSides = 5
        TopLevel.text_Border.borderBottom = 30

    TopLevel.text_Border_Input = TopLevel.text_Border:createTextInput({id = "Text Input", placeholderText = "Rename Item", autoFocus = true})

    TopLevel.text_Info = TopLevel.text:createBlock({id = "Info"})
        ui.autoSize(TopLevel.text_Info)
        TopLevel.text_Label_Cost = TopLevel.text_Info:createLabel({id = "Cost Label", text = "Cost:"})
        TopLevel.text_Label_Cost.borderRight = 50
        TopLevel.text_Label_Cost.color = { 0.875, 0.788, 0.624 }

        TopLevel.text_Info_Soul = TopLevel.text_Info:createLabel({id = "Soul", text = "0"})
        TopLevel.text_Info_Slash = TopLevel.text_Info:createLabel({id = "Slash", text = "\\"})
        TopLevel.text_Info_Cost = TopLevel.text_Info:createLabel({id = "Cost", text = "0"})

    TopLevel.select = TopLevel.Main:createBlock({id = "Selectors"})
        ui.autoSize(TopLevel.select)
        TopLevel.select.borderBottom = 10

    TopLevel.select_Enchant = TopLevel.select:createThinBorder({id = "Enchant Select Border"})
        menu.selection(TopLevel.select_Enchant, "enchant")
        TopLevel.select_Enchant.borderLeft = 15
        TopLevel.select_Enchant.borderRight = 26

    TopLevel.select_Enchant_Item = TopLevel.select_Enchant:createImage({id = "Enchanted Item"})
        TopLevel.select_Enchant_Item.height = 32
        TopLevel.select_Enchant_Item.width = 32
        TopLevel.select_Enchant_Item.scaleMode = true

    TopLevel.select_Target = TopLevel.select:createThinBorder({id = "Item Select Border"})
        menu.selection(TopLevel.select_Target, "target")

    TopLevel.select_Target_Item = TopLevel.select_Target:createImage({id = "Target Item"})
        TopLevel.select_Target_Item.height = 32
        TopLevel.select_Target_Item.width = 32
        TopLevel.select_Target_Item.scaleMode = true

    TopLevel.select_SoulGem = TopLevel.select:createThinBorder({id = "SoulGem Select Border"})
        TopLevel.select_SoulGem.borderLeft = 20
        menu.selection(TopLevel.select_SoulGem, "soulGem")

    TopLevel.select_SoulGem_Item = TopLevel.select_SoulGem:createImage({id = "SoulGem"})
    TopLevel.select_SoulGem_Item.height = 32
    TopLevel.select_SoulGem_Item.width = 32
    TopLevel.select_SoulGem_Item.scaleMode = true

    TopLevel.label = TopLevel.Main:createBlock({id = "Labels"})
        ui.autoSize(TopLevel.label)
        TopLevel.label.borderBottom = 25

        TopLevel.label_Enchant = TopLevel.label:createLabel({id = "Enchant Label", text = "Enchantment"})
        TopLevel.label_Target = TopLevel.label:createLabel({id = "Target Label", text = "Item"})
            TopLevel.label_Target.borderLeft = 20
        TopLevel.label_SoulGem = TopLevel.label:createLabel({id = "SoulGem Label", text = "Soul"})
            TopLevel.label_SoulGem.borderLeft = 68


    TopLevel.buttons = TopLevel.Main:createBlock({id = "buttons"})
        TopLevel.buttons.widthProportional = 1
        ui.autoSize(TopLevel.buttons)

        TopLevel.buttons_Close = ui.close(TopLevel.buttons)

        TopLevel.buttons_Confirm = TopLevel.buttons:createButton({id = "confirm", text = "Confirm"})
        TopLevel.buttons_Confirm.absolutePosAlignX = 1
        TopLevel.buttons_Confirm:register(tes3.uiEvent.mouseClick, menu.transfer)

    tes3ui.enterMenuMode(TransferEnchant)
end

function menu.transfer()
    local target = menu.TopLevel.select_Target_Item:getLuaData("item") ---@type tes3armor|tes3weapon|tes3clothing
    local enchant = menu.TopLevel.select_Enchant_Item:getLuaData("item")---@type tes3armor|tes3weapon|tes3clothing
    local soul = menu.TopLevel.select_SoulGem_Item:getLuaData("item")
    local chargeCost = enchant and enchant.enchantment.chargeCost
    local type = enchant and enchant.enchantment.castType
    local constant = type == tes3.enchantmentType.constant
    debug.log(chargeCost)

    if enchant and target then
        if not constant and soul >= math.min(chargeCost, 300) or soul >= 300 then
            local name
            local newItem = target:createCopy({})
            if menu.TopLevel.text_Border_Input.text == "Rename Item" then
                name = newItem.name
            else
                name = menu.TopLevel.text_Border_Input.text
            end

            newItem.enchantment = enchant.enchantment
            newItem.name = name

            debug.log(chargeCost)
            tes3.addItem({ reference = tes3.player, item = newItem })

            tes3.removeItem({ reference = tes3.player, item = enchant, count = 1 })
            tes3.removeItem({ reference = tes3.player, item = target, count = 1 })
            debug.log(enchant.enchantment)

            ui.exit(menu.TopLevel.buttons_Confirm, true)
            bs.playSound(bs.sound.enchant_success)
        else
            ui.msg("Soul not powerful enough")
            bs.playSound(bs.sound.enchant_fail)
        end
    end
end

function menu.selection(element, selection)
    element.borderRight = 22
    element.paddingAllSides = 4
    element.height = 60
    element.width = 60
    element.childAlignY = 0.5
    element.childOffsetX = 10
    element:register(tes3.uiEvent.mouseClick, function(e) menu.itemSelect(selection) end)
end

function menu.itemSelect(obType)
    local ItemSelectID = tes3ui.registerID("bsItemSelect")

    menu.ItemSelect.Main = tes3ui.createMenu{id = ItemSelectID, fixedFrame = true}
    local ItemSelect = menu.ItemSelect
    local Main = ItemSelect.Main

    ItemSelect.scrollPane = Main:createVerticalScrollPane({id = "ScrollPane"})
    ItemSelect.scrollPane.paddingRight = 10
    ItemSelect.scrollPane.heightProportional = nil
    ItemSelect.scrollPane.widthProportional = nil
    ItemSelect.scrollPane.width = 352
    ItemSelect.scrollPane.height = 455

    if obType == "enchant" then
        menu.iterInv("enchant")
    elseif obType == "target" then
        menu.iterInv("target")
    elseif obType == "soulGem" then
        menu.iterInv("soulGem")
    end

    ItemSelect.close = ui.close(Main)
    Main:updateLayout()
end

function menu.iterInv(itemSelection)


    ---@param object tes3armor|tes3clothing
    ---@param itemData? tes3itemData
    local function itemList(object, itemData)
        local ItemSelect = menu.ItemSelect
        menu.ItemSelect.scrollPane_Block = menu.ItemSelect.scrollPane:createBlock({id = object.name})

        local scrollPane_Block = menu.ItemSelect.scrollPane_Block
        scrollPane_Block.autoWidth = true
        scrollPane_Block.autoHeight = true

        ItemSelect.scrollPane_Block_Icon = scrollPane_Block:createImage({id = object.name.." Image", path ="icons\\".. object.icon})
        ItemSelect.scrollPane_Block_Icon.width = 40
        ItemSelect.scrollPane_Block_Icon.height = 40
        ItemSelect.scrollPane_Block_Icon.scaleMode = true

        ItemSelect.scrollPane_Block_Name = scrollPane_Block:createLabel({id = "Name",text = object.name})
        ItemSelect.scrollPane_Block_Name.absolutePosAlignY = 0.03


        ui.itemTooltip(scrollPane_Block, object, itemData)

        --Clicking on an Item to select it--
        scrollPane_Block:register(tes3.uiEvent.mouseClick, function(e)
            if menu.TopLevel.Main then             --Make sure Main menu is still a thing
                if itemSelection == "enchant" then --When the Enchanted Item is Selected
                    local chargeCost = object.enchantment.chargeCost
                    local type = object.enchantment.castType
                    local constant = type == tes3.enchantmentType.constant
                    local cost = constant and 300 or chargeCost

                    menu.TopLevel.select_Enchant_Item.contentPath = "icons\\" .. object.icon
                    menu.TopLevel.select_Enchant_Item:setLuaData("item", object)
                    menu.TopLevel.text_Info_Cost.text = tostring(cost)

                    ui.itemTooltip(menu.TopLevel.select_Enchant_Item, object)
                    ui.update(menu.TopLevel.select_Enchant_Item)
                    ui.exit(menu.ItemSelect.Main)
                    bs.playSound(bs.sound.Item_Misc_Up)
                elseif itemSelection == "target" then --When the Target Item is selected
                    menu.TopLevel.select_Target_Item.contentPath = "icons\\" .. object.icon
                    menu.TopLevel.select_Target_Item:setLuaData("item", object)

                    ui.itemTooltip(menu.TopLevel.select_Target_Item, object)
                    ui.update(menu.TopLevel.select_Target_Item)
                    ui.exit(menu.ItemSelect.Main)
                    bs.playSound(bs.sound.Item_Misc_Up)
                elseif itemSelection == "soulGem" then --When the SoulGem is selected
                    if not itemData then return end
                    menu.TopLevel.select_SoulGem_Item.contentPath = "icons\\" .. object.icon
                    menu.TopLevel.select_SoulGem_Item:setLuaData("item", itemData.soul.soul)

                    menu.TopLevel.text_Info_Soul.text = tostring(itemData.soul.soul)

                    ui.itemTooltip(menu.TopLevel.select_SoulGem_Item, object, itemData)
                    ui.update(menu.TopLevel.select_SoulGem_Item)
                    ui.exit(menu.ItemSelect.Main)
                    bs.playSound(bs.sound.Item_Misc_Down)
                end
            end
        end)
        ui.update(menu.ItemSelect.Main)
    end


    for _, stack in pairs(tes3.mobilePlayer.inventory) do
        local type = stack.object.objectType
        local enchant = stack.object.enchantment
        local wearable = type == tes3.objectType.armor or type == tes3.objectType.clothing

        if itemSelection == "enchant" then
            if enchant and wearable then
                itemList(stack.object)
            end
        elseif itemSelection == "target" then
            if not enchant and wearable then
                itemList(stack.object)
            end
        elseif itemSelection == "soulGem" then
            if stack.object.isSoulGem and stack.variables then
                for _, itemData in pairs(stack.variables) do
                    if itemData.soul and itemData.soul.soul then

                        itemList(stack.object, itemData)
                    end
                end
            end
        end
    end
    ui.update(menu.ItemSelect.Main)
end

---@param e keyDownEventData
event.register(tes3.event.keyDown, function (e)
    if e.keyCode == cfg.keycode.keyCode then
        if not e.isShiftDown or not e.isAltDown or not e.isControlDown then
            if not tes3.menuMode() and tes3.mobilePlayer then
                createTransfer()
            end
        end
    end
end)

event.register("initialized", function()
    print("[MWSE:Transfer Enchantments] initialized")
end)