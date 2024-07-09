local ui = {}

---Refreshes Top Level Parent of element
---@param element tes3uiElement
function ui.update(element)
    element:getTopLevelMenu():updateLayout()
end

---@param element tes3uiElement Element to destroy, will auto getTopLevelMenu
---@param leave? boolean|nil Optional: Leaves MenuMode if true 
function ui.exit(element, leave)
    element:getTopLevelMenu():destroy()
    if leave then
        tes3ui.leaveMenuMode()
    end
end

---Create a Close Button that destroys/exits MenuMode
---@param parent tes3uiElement What Element the button will be under
---@param callback fun(e: tes3uiEventData)? Optional:Additional Function that runs before closing
---@return tes3uiElement button The tes3uiElement for the Close Button
function ui.close(parent, callback)
    local button = parent:createButton({id = "close", text = "Cancel"})

    button:register(tes3.uiEvent.mouseClick, function (e)
        if callback then
            callback(e)
        end
        tes3ui.leaveMenuMode()
        button:getTopLevelMenu():destroy()
    end)

    return button
end

---Create Tooltip for Items
---@param parent tes3uiElement
---@param item tes3alchemy|tes3apparatus|tes3armor|tes3book|tes3clothing|tes3ingredient|tes3light|tes3lockpick|tes3misc|tes3probe|tes3repairTool|tes3weapon|tes3leveledItem 
---@param itemData? tes3itemData itemData if used
function ui.itemTooltip(parent, item, itemData)
    parent:register(tes3.uiEvent.help, function (e)
        tes3ui.createTooltipMenu({item = item, itemData = itemData or nil})
    end)
end

function ui.autoSize(element)
    element.autoHeight = true
    element.autoWidth = true
end

ui.msg = tes3.messageBox

function ui.playSound(sound, volume, pitch, reference)
    tes3.playSound{ sound = sound, volume = volume, pitch = pitch, reference = reference}
end

return ui