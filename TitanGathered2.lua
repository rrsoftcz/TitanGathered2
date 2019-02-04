TG_ID = "Ore";
TG_PLAYER_CLASS = "";
ITEM_HISTORY = "itemsHistory"
LOOT_HISTORY = "lootsHistory"

local p, TG_PLAYER_CLASS = UnitClass("player");

TitanGathered2 = {}
tgPluginDb = {}
tgPlugins = {}
-- Reduce the chance of functions and variables colliding with another addon.
local tg = TitanGathered2
local infoBoardData = {}
local ScriptHooks = {};
local gtt = GameTooltip

tg.id = "Gathered2";
tg.addon = "TitanGathered2";
tg.email = "bajtlamer@gmail.com";
tg.www = "www.rrsoft.cz";
tg.boardCount = 5;
tg.showZero = 0;
tg.menuitem = "";
--  Get data from the TOC file.
tg.version = tostring(GetAddOnMetadata(tg.addon, "Version")) or "Unknown"
tg.author = GetAddOnMetadata(tg.addon, "Author") or "Unknown"

-- Create about popup info text.
tg.about = TitanUtils_GetGreenText("Titan Panel [Gathered]") ..
TitanUtils_GetHighlightText(" By ")..TitanUtils_GetNormalText(tg.author) .. "\n" ..
TitanUtils_GetNormalText("Version: ")..TitanUtils_GetHighlightText(tg.version) .. "\n" ..
TitanUtils_GetNormalText("email: ")..TitanUtils_GetHighlightText(tg.email) .. " - " ..
TitanUtils_GetHighlightText(tg.www);

-- **************************************************************************
-- NAME : TitanGathered2Button_OnLoad()
-- DESC : Registers the add on upon it loading
-- **************************************************************************
function tg.Button_OnLoad(self)
    local tooltipAboutText;

    echo(tg.addon.." ("..TG_COLOR_GREEN..tg.version.."|cffff8020) loaded! Created By "..tg.author);

    tooltipAboutText = "|cffff8020"..tg.id.." "..TitanUtils_GetGreenText(tg.version) .. "\n";

    self.registry = {
        id = tg.id,
        version = tg.version,
        menuText = tg.id,
        buttonTextFunction = "TitanGathered2Button_GetButtonText",
        tooltipTitle = tooltipAboutText,
        category = "Information",
        tooltipTextFunction = "TitanGathered2Button_GetTooltipText",
        icon = "Interface\\Addons\\TitanGathered2\\Artwork\\TitanOre",
        iconWidth = 16,
        updateType = TITAN_PANEL_UPDATE_TOOLTIP,
        savedVariables = {
            ShowIcon = 1,
            ShowLabelText = 1,
            ShowColoredText = 1,
            ShowInfoTooltip = 1,
            ShowStacksInTooltip = 1,
            ShowZerro = 1,
            ShowBankItems = 1,
            ExcludeZero = 1,
            ShowSkills = 1,
            ShowSecSkills = 1,
            ShowOres = 1,
            ShowBFAHerbs = 1,
            ShowBars = 1,
            ShowStones = 1,
            ShowGems = 1,
            ShowLeathers = 1,
            ShowScales = 1,
            ShowHides = 1,
            ShowCloths = 1,
            ShowHerbs = 1,
            ShowEssences = 1,
            ShowMisc = 1,
            ShowPigments = 1,
            ShowPoisons = 1,
            ShowBandages = 1,
            ShowInks = 1,
            ShowInscriptPigments = 1,
            ShowCooking = 1,
            ShowAlchemy = 1,
            Debugmode = 1,
            displayitems = {},
            itemsHistory = {},
            bankHistory = {},
            clearItems = {},
        }};
        self:RegisterEvent("PLAYER_ENTERING_WORLD");
        self:RegisterEvent("PLAYER_LEAVING_WORLD");
        self:RegisterEvent("LOOT_OPENED");
        self:RegisterEvent("BANKFRAME_OPENED");
        self:RegisterEvent("BANKFRAME_CLOSED");
        self:RegisterEvent("TRADE_SKILL_SHOW");
        self:RegisterEvent("SKILL_LINES_CHANGED");
        self:RegisterEvent("CURSOR_UPDATE");
        tg:HookTooltipEvents()
    end

    -- Button
    function TitanGathered2Button_GetButtonText(self)
        local txtTitanTitle = " ";
        return tg.id, txtTitanTitle;
    end

    -- Tooltip
    function TitanGathered2Button_GetTooltipText(self)
        local tooltipText = "";

        local i, e, cat, short, v_count;
        local val = 0;

        local p, playerClass = UnitClass("player");

        local nextText = "";

        local v_color = TG_COLOR_GOLD;
        local prof_1, prof_2, archaeology, fishing, cooking, firstaid = GetProfessions();

        local nextText = "";
        local val = 1;
        local prof = 0;

        -- PRIMARY SKILLS
        if (not TitanGetVar(tg.id, "ShowSkills")) then

            if (prof_1) then
                local skillName, icon, skillrank, skillmax, numspells, spelloffset, skillline = GetProfessionInfo(prof_1);
                v_color = tg.GetSkillRankColor(skillrank, skillmax);
                nextText = nextText..v_color..skillName..":\t"..skillrank..TitanUtils_GetHighlightText(" of ")..skillmax.."\n";
            end
            if (prof_2) then
                local skillName, icon, skillrank, skillmax, numspells, spelloffset, skillline = GetProfessionInfo(prof_2);
                v_color = tg.GetSkillRankColor(skillrank, skillmax);
                nextText = nextText..v_color..skillName..":\t"..skillrank..TitanUtils_GetHighlightText(" of ")..skillmax.."\n";
            end

            if (val == 1) then
                tooltipText = tooltipText.."\n";
                tooltipText = tooltipText..TitanUtils_GetHighlightText(TG_LOCAL_PROFESSIONS.."\n");
                tooltipText = tooltipText..nextText;
            end
        end

        local nextText = "";
        local val = 1;
        local prof = 0;

        -- SECONDARY SKILLS
        if (not TitanGetVar(tg.id, "ShowSecSkills")) then

            if (archaeology) then
                local skillName, icon, skillrank, skillmax, numspells, spelloffset, skillline = GetProfessionInfo(archaeology);
                v_color = tg.GetSkillRankColor(skillrank, skillmax);
                nextText = nextText..v_color..skillName..":\t"..skillrank..TitanUtils_GetHighlightText(" of ")..skillmax.."\n";
            end
            if (fishing) then
                local skillName, icon, skillrank, skillmax, numspells, spelloffset, skillline = GetProfessionInfo(fishing);
                v_color = tg.GetSkillRankColor(skillrank, skillmax);
                nextText = nextText..v_color..skillName..":\t"..skillrank..TitanUtils_GetHighlightText(" of ")..skillmax.."\n";
            end
            if (cooking) then
                local skillName, icon, skillrank, skillmax, numspells, spelloffset, skillline = GetProfessionInfo(cooking);
                v_color = tg.GetSkillRankColor(skillrank, skillmax);
                nextText = nextText..v_color..skillName..":\t"..skillrank..TitanUtils_GetHighlightText(" of ")..skillmax.."\n";
            end
            if (firstaid) then
                local skillName, icon, skillrank, skillmax, numspells, spelloffset, skillline = GetProfessionInfo(firstaid);
                v_color = tg.GetSkillRankColor(skillrank, skillmax);
                nextText = nextText..v_color..skillName..":\t"..skillrank..TitanUtils_GetHighlightText(" of ")..skillmax.."\n";
            end

            if (val == 1) then
                tooltipText = tooltipText.."\n";
                tooltipText = tooltipText..TitanUtils_GetHighlightText(TG_LOCAL_SEC_PROFESSIONS.."\n");
                tooltipText = tooltipText..nextText;
            end
        end

        -- Show reagent summary ONLY for enabled categories
        for _, cat in pairs(TG_CATEGORIES) do
            local nextText = "";
            -- is category switched On?
            local isOn = TitanGetVar(tg.id, trim(cat.smenu));
            if (not isOn) then
                -- loop all items from thtis category...
                for _, item in pairs(cat.db) do
                        local color = TitanGathered2_GetColorByRarity(item.tag);
                        nextText = nextText..getGatheredTooltipInfo(item, color);
                end
            end

            if (string.len(nextText) > 0) then
                tooltipText = tooltipText.."\n";
                tooltipText = tooltipText..TG_COLOR_ORANGE..cat.name.."\n----------------------------------------\n";
                tooltipText = tooltipText..nextText;
            end
        end
        return tooltipText.."\n";
    end

    --------------------------
    -- Create tooltip label --
    --------------------------
    function getGatheredTooltipInfo(item, color)
        local v_count = TitanGathered2_CountItem(item.tag);
        local b_count = TitanGathered2_CountItemStoredInBank(item.tag);
        local nextText = "";

        if (TitanGetVar(tg.id, "ShowZerro")) then
            if (v_count > 0) then
                nextText = nextText..TitanGathered2_ShowTooltipRow(color, item.name, v_count, b_count);
            elseif (b_count > 0 and not TitanGetVar(tg.id, "ExcludeZero") and not TitanGetVar(tg.id, "ShowBankItems")) then
                nextText = nextText..TitanGathered2_ShowTooltipRow(color, item.name, v_count, b_count);
            end
        else
            nextText = nextText..TitanGathered2_ShowTooltipRow(color, item.name, v_count, b_count);
        end
        return nextText;
    end

    ----------------------------------------------------------------
    -- Get hex color string by percentage
    ----------------------------------------------------------------
    function tg.GetSkillRankColor(skill,skillmax)
        local color = TG_COLOR_RED;
        local percents = floor( ( (skill) / skillmax ) * 100 );

        if ( percents > 49) then
            color = TG_COLOR_ORANGE;
        end
        if ( percents > 74 ) then
            color = TG_C_YELLOW;
        end
        if ( percents > 94) then
            color = TG_COLOR_GREEN;
        end

        return color;
    end

    -- Item count function
    function TitanGathered2_CountItem(searchedItemID)
        local i_count = 0;

        for b = 0, 4 do
            local nbslots = GetContainerNumSlots(b);
            for s = 0, nbslots do
                local _, itemCount, _, _, _, _, _, _, _, bankItemID = GetContainerItemInfo(b, s);

                if(tonumber(searchedItemID) == tonumber(bankItemID)) then
                    i_count = i_count + itemCount;
                end
            end
        end
        return i_count;
    end

    -- show tooltip row
    function TitanGathered2_ShowTooltipRow(v_color, e_name, v_count, b_count)
        local t_row = "";

        if (not TitanGetVar(tg.id, "ShowBankItems")) then
            t_row = v_color..e_name..":\t"..v_count.."/"..b_count.."\n";
        else
            t_row = v_color..e_name..":\t"..v_count.."\n";
        end

        return t_row;
    end

    -- bank item count function
    function TitanGathered2_CountItemStoredInBank(item_id)

        local dbb = TitanGetVar(tg.id, "bankHistory");
        local nbslots, i, e;
        local i_count = 0;

        for i, e in pairs(dbb) do

            local _, _, color, id, name = string.find(e.name, "|c(%x+)|Hitem:(%d+):[%d:]+|h%[(.-)%]|h|r");

            if (type(e) == "table") then

                if (id == item_id) then
                    i_count = i_count + e.value;
                end
            end
        end
        return i_count;
    end

    -- Event
    function tg.Button_OnEvent(self, event)

        if (event == "PLAYER_LEAVING_WORLD") then
            self:UnregisterEvent("BAG_UPDATE");
        end
        if (event == "PLAYER_ENTERING_WORLD") then
            self:RegisterEvent("BAG_UPDATE");
            self:RegisterEvent("LOOT_OPENED");
        end
        if (event == "LOOT_OPENED") then
            TitanGathered2_loot();
        end
        if (event == "BANKFRAME_OPENED") then
            TitanGathered2_bankOpen();
        end
        if (event == "BANKFRAME_CLOSED") then
            TitanGathered2_bankClose();
        end
        TitanPanelButton_UpdateButton(tg.id);
        tg.showZero = TitanGetVar(tg.id, "ShowZerro");
        --TitanPanelGatheredInfoBoard_OnLoad(self);
    end

    -----------------------------------------------------------
    -- TOOLTIPS
    -----------------------------------------------------------
    function ScriptHooks:OnTooltipSetItem()

        if(TitanGetVar(tg.id, "ShowInfoTooltip"))then return end

        local tooltipLabel = getglobal("GameTooltipTextLeft1")
        local targetName = tooltipLabel:GetText()
        local objectCategory, objectItem = tg.GetItemCategory(targetName)
        local _prof = function(a) return a == nil or a end
        local _skil = function(b) return b == nil or b end

        local skillInfo = tg.getItemProfessionInfo(_prof(objectCategory), _skil(objectItem))

        if (tg.isTargetGatherableObject(targetName) == 1) then

            tg.addEmptyLineToTooltip(self)

            tg.addTooltipText(self, TG_INFO_LABEL, GameFontNormal)
            if (skillInfo ~= nil) then
                skillInfo = TG_C_BROWN.."Required Skill: |r"..skillInfo.name.."|r "..skillInfo.color..1
                tg.addTooltipText(self, skillInfo, GameFontNormalSmall, TG_C_BROWN)
                tg.addEmptyLineToTooltip(self)
            end

            tg.addItemsFromLootsToTooltip(self, targetName, tg.getVar(LOOT_HISTORY), tg.getVar(ITEM_HISTORY));

            if(not TitanGetVar(tg.id, "ShowStacksInTooltip"))then
                local fndBags = GetItemsFromBags(targetName)
                local fndBank = GetItemsFromBank(targetName)

                tg.addTooltipText(self, TG_C_YELLOW..TG_INFO_TOTAL..TG_C_VIOLET..fndBags + fndBank..TG_C_YELLOW.." Bags: "..TG_C_VIOLET..fndBags..TG_C_YELLOW.." Bank: "..TG_C_VIOLET..fndBank.."|r", GameFontNormal, TG_C_BROWN)
            end
        end
    end

    function ScriptHooks:OnShow()
        if(TitanGetVar(tg.id, "ShowInfoTooltip"))then return end

        if(self:IsOwned(UIParent))then
            local tooltipTextLeft = getglobal("GameTooltipTextLeft1")
            if(tooltipTextLeft) then
                local _text = tooltipTextLeft:GetText()

                for i, obj in pairs(TG_MINABLES) do
                    if(_text == obj.name) then
                        local _m = function(a) return type(a) ~= "table" or a end
                        local _f = _m(tg.getObjectFromLootHistory(obj.id))

                        -- Add info text label and gathering tries...
                        tg.addEmptyLineToTooltip(self)
                        tg.addTooltipText(self, TG_INFO_LABEL, GameFontNormal, TG_C_YELLOW)
                        tg.tooltipAddGatheringTriesFromSource(self, _f)

                        -- Mean target is minable object, vein, deposit, herb etc..
                        if( _f ~= true )then
                            tg.addEmptyLineToTooltip(self)
                            tg.addTooltipText(self, TG_INFO_OBTAINED, GameFontNormalSmall, TG_C_YELLOW)

                            local loots = tg._sort(_f.loots, "sum") or {}

                            for i, gItem in pairs(loots)do
                                local all = _f.sumes or 0
                                local c = gItem.sum or 0
                                local _p = tg.calculatePercentage(all, c)
                                local info = TG_C_VIOLET..tostring(gItem.sum).."|r"

                                if (gItem.name) then
                                    if(not TitanGetVar(tg.id, "ShowStacksInTooltip"))then
                                        info = getItemStackSizeInfo(gItem.name);
                                    end
                                    local color = TitanGathered2_GetColorByRarity(gItem.name);
                                    local tooltipText = printf(color.."%s %s"..TG_C_AQUA.." (%s)|r", gItem.name, info, _p)
                                    tg.addTooltipText(self, tooltipText, GameFontNormalSmall)
                                else
                                    TitanGathered2_PrintDebug("Error: getObjectFromLootHistory() returned object without name!")
                                end
                            end
                        end
                    end
                end
            end
            -- must be here, rerender tooltip to appropriate size...
            self:SetPadding(0,5)
            self:Show()
        end
    end

    function tg:HookTooltipEvents()
        for scriptName, hookFunc in next, ScriptHooks do
            gtt:HookScript(scriptName, hookFunc);
        end
    end

    function tg:SendElementEvent(event,...)
        for _, element in ipairs(elements) do
            if (not element.disabled) and (element[event]) then
                element[event](element,...);
            end
        end
    end


    -- Menu
    function TitanPanelRightClickMenu_PrepareGathered2Menu(self)
        local info;
        local i, e, cat, fce, save;

        if (L_UIDROPDOWNMENU_MENU_LEVEL == 2) then

            if (L_UIDROPDOWNMENU_MENU_VALUE == TG_LOCAL_SHARDS) then
                if (TG_PLAYER_CLASS == "WARLOCK") then
                    for i, e in pairs(TG_ITEMS) do
                        TitanGathered2_PrintDebug("--------WARLOCK-------")
                        if(e.cat == TG_LOCAL_SHARDS) then
                            info = {};
                            info.text = e.name;
                            info.value = i;
                            info.func = TitanGathered2_SetDisplay;
                            info.checked = TitanGathered2Button_isdisp(i);
                            info.keepShownOnClick = 1;
                            L_UIDropDownMenu_AddButton(info, L_UIDROPDOWNMENU_MENU_LEVEL);
                        end
                    end
                end
            end

            -- Tooltip
            if (L_UIDROPDOWNMENU_MENU_VALUE == TG_L_ENABLE_TOOLTIP) then
                info = {};
                info.text = TG_LOCAL_SHOW_TOOLTIP;
                info.func = TitanGathered2Button_ToggleShowInfoTooltip;
                info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ShowInfoTooltip"));
                info.keepShownOnClick = 1;
                L_UIDropDownMenu_AddButton(info, L_UIDROPDOWNMENU_MENU_LEVEL);

                info = {};
                info.text = TG_L_SHOW_STACKS_IN_TOOLTIP;
                info.func = TitanGathered2Button_ToggleShowStacksInTooltip;
                info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ShowStacksInTooltip"));
                info.keepShownOnClick = 1;
                L_UIDropDownMenu_AddButton(info, L_UIDROPDOWNMENU_MENU_LEVEL);
            end
            -- Bank
            if (L_UIDROPDOWNMENU_MENU_VALUE == TG_LOCAL_BANK_ITEMS) then
                info = {};
                info.text = TG_LOCAL_SHOW_BANK;
                info.func = TitanGathered2Button_ToggleShowBankItems;
                info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ShowBankItems"));
                info.keepShownOnClick = 1;
                L_UIDropDownMenu_AddButton(info, L_UIDROPDOWNMENU_MENU_LEVEL);

                info = {};
                info.text = TG_LOCAL_EXCLUDE_ZERO;
                info.func = TitanGathered2Button_ToggleEcludeZero;
                info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ExcludeZero"));
                info.keepShownOnClick = 1;
                L_UIDropDownMenu_AddButton(info, L_UIDROPDOWNMENU_MENU_LEVEL);
            end
            -- About
            if (L_UIDROPDOWNMENU_MENU_VALUE == "DisplayAbout") then
                info = {};
                info.text = tg.about;
                info.value = "AboutTextPopUP";
                info.notClickable = 1;
                info.isTitle = 0;
                L_UIDropDownMenu_AddButton(info, L_UIDROPDOWNMENU_MENU_LEVEL);
            end

            return;
        end

        TitanPanelRightClickMenu_AddTitle(TitanPlugins[tg.id].menuText);

        -- Show Skills
        info = {};
        info.text = TG_LOCAL_SHOW_SKILLS;
        info.func = TitanGathered2Button_ToggleShowSkills;
        info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ShowSkills"));
        info.keepShownOnClick = 1;
        L_UIDropDownMenu_AddButton(info);

        -- Show Secondary Skills
        info = {};
        info.text = TG_LOCAL_SHOW_SEC_SKILLS;
        info.func = TitanGathered2Button_ToggleShowSecSkills;
        info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ShowSecSkills"));
        info.keepShownOnClick = 1;
        L_UIDropDownMenu_AddButton(info);

        -- Hidde zero option
        info = {};
        info.text = TG_LOCAL_HIDDE_ZERO;
        info.func = TitanGathered2Button_ToggleShowZerro;
        info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "ShowZerro"));
        info.keepShownOnClick = 1;
        L_UIDropDownMenu_AddButton(info);

        -- Debug mode
        info = {};
        info.text = TG_LOCAL_DEBUG_MODE;
        info.func = TitanGathered2Button_ToggleDebugmode;
        info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, "Debugmode"));
        info.keepShownOnClick = 1;
        L_UIDropDownMenu_AddButton(info);

        TitanPanelRightClickMenu_AddSpacer();

        -- Show Info Tooltip
        info = {};
        info.text = TG_L_ENABLE_TOOLTIP;
        info.value = TG_L_ENABLE_TOOLTIP;
        info.hasArrow = 1;
        info.notCheckable = true
        L_UIDropDownMenu_AddButton(info);

        -- bank items
        info = {};
        info.text = TG_LOCAL_BANK_ITEMS;
        info.value = TG_LOCAL_BANK_ITEMS;
        info.hasArrow = 1;
        info.notCheckable = true
        L_UIDropDownMenu_AddButton(info);

        TitanPanelRightClickMenu_AddSpacer();

        -- categories label
        info = {};
        info.text = TG_LOCAL_SHOW_CATEGORIES;
        info.isTitle = 1;
        L_UIDropDownMenu_AddButton(info);

        -- Loop all categories and insert each to option menu
        for i, category in pairs(TG_CATEGORIES) do
            local varname = trim(category.smenu);

            if (varname ~= nil) then
                info = {};
                info.text = category.smenu
                info.func = ToggleTitanGatherdMenuItem
                info.checked = TitanUtils_Toggle(TitanGetVar(tg.id, varname))
                info.keepShownOnClick = 0
                L_UIDropDownMenu_AddButton(info)
            end
        end

        TitanPanelRightClickMenu_AddSpacer();

        if (TG_PLAYER_CLASS == "WARLOCK") then
            -- Shards submenu
            info = {};
            info.text = TG_LOCAL_SHARDS;
            info.value = TG_LOCAL_SHARDS;
            info.hasArrow = 1;
            L_UIDropDownMenu_AddButton(info);
        end

        -- titan panel options
        info = {};
        info.text = TG_LOCAL_SHOW_TITAN_OPT;
        info.isTitle = 1;
        L_UIDropDownMenu_AddButton(info);

        TitanPanelRightClickMenu_AddToggleIcon(tg.id);
        TitanPanelRightClickMenu_AddToggleLabelText(tg.id);
        TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, tg.id, TITAN_PANEL_MENU_FUNC_HIDE);

        -- info about plugin
        info = {};
        info.text = TG_ABOUT_TEXT;
        info.value = "DisplayAbout";
        info.hasArrow = 1;
        info.notCheckable = true
        L_UIDropDownMenu_AddButton(info);

    end

    function TitanGathered2_SetDisplay(self)
        local db = TitanGetVar(tg.id, "displayitems");
        local i, d, found;
        if(self.value == 0) then
            TitanSetVar(tg.id, "displayitems", {});
        else
            found = 0;
            for i, d in pairs(db) do
                if(d == self.value)then
                    found = i;
                end
            end
            if(found > 0) then
                table.remove(db, found)
            else
                while(table.getn(db) > 80) do
                    table.remove(db);
                end;
                table.insert(db, self.value);
            end
            TitanSetVar(tg.id, "displayitems", db);
        end;
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_isdisp(val)
        local disp = TitanGetVar(tg.id, "displayitems");
        local i, d;

        if(type(disp) ~= "table") then
            return 0;
        end

        for i, d in pairs(disp) do
            if(d == val) then
                return 1;
            end
        end
        return nil;
    end

    function ToggleTitanGatherdMenuItem(self)
        TitanToggleVar(tg.id, trim(self.value));
        TitanPanelButton_UpdateButton(tg.id);
        return;
    end

    function TitanGathered2Button_ToggleShowInfoTooltip()
        TitanToggleVar(tg.id, "ShowInfoTooltip");
        TitanPanelButton_UpdateButton(tg.id);
    end
    function TitanGathered2Button_ToggleShowStacksInTooltip()
        TitanToggleVar(tg.id, "ShowStacksInTooltip");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleDebugmode()
        TitanToggleVar(tg.id, "Debugmode");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleEcludeZero()
        TitanToggleVar(tg.id, "ExcludeZero");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleShowZerro()
        TitanToggleVar(tg.id, "ShowZerro");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleShowSkills()
        TitanToggleVar(tg.id, "ShowSkills");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleShowSecSkills()
        TitanToggleVar(tg.id, "ShowSecSkills");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleShowBankItems()
        TitanToggleVar(tg.id, "ShowBankItems");
        TitanPanelButton_UpdateButton(tg.id);
    end

    function TitanGathered2Button_ToggleShowMisc()
        TitanToggleVar(tg.id, "ShowMisc");
        TitanPanelButton_UpdateButton(tg.id);
    end


    -------------------------------------------------------
    -- getObjectFromLootHistory
    -- On event LOOT_OPENED will stored all looted items
    -------------------------------------------------------

    function tg.getObjectFromLootHistory(objectId, db)
        local _db = db or tg.getVar(LOOT_HISTORY)

        for i, objectNode in pairs(_db) do
            if (objectNode.id == objectId) then
                return objectNode
            end
        end
        return nil
    end


    function TitanGathered2_loot()
        for index = 1, GetNumLootItems(), 1 do
            if (LootSlotHasItem(index)) then
                local lootIcon, lootName, lootQuantity, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(index)
                local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(lootName)
                local iParent = tg.getLootParentSourceObject(index, lootName)
dump(GetLootInfo());
                if (iParent.name ~= nil) then
                    local itemId = getItemIdFromLink(sLink)
                    tg.updateItemFromLoot(lootName, iParent, lootQuantity, index)
                    -- if (itemId > 0) then
                    --     local oItem = {id = itemId, name = lootName}
                    --     tgo.addItemToCollection(oItem)
                    -- end
                end
                tg.PluginUpdateHistory(lootName, lootQuantity, sLink, iParent)
             end
        end
    end

    function tg.updateItemFromLoot(sName, lootSource, lootQuantity, index)
        local lootHistoryDb = tg.getVar(LOOT_HISTORY)
        local foundObject = tg.getObjectFromLootHistory(lootSource.id, lootHistoryDb)

        if (foundObject ~= nil) then
            local count = foundObject.count or 1
            local sumes = foundObject.sumes or 0
            local loots = foundObject.loots or {}
            local found = 0

            for i, item in pairs(loots) do
                if (item.name == sName) then
                    local cnt = item.cnt or 0
                    local sum = item.sum or 0
                    item.cnt = cnt+1
                    item.sum = sum + tonumber(lootQuantity)
                    found = i
                end
            end

            if (found == 0) then
                table.insert(loots, {name = sName, cnt = 1, sum = lootQuantity})
            end

            if (index == 1) then
                foundObject.count = count + 1
            end

            foundObject.loots = loots
            foundObject.sumes = sumes + lootQuantity

            table.remove(lootHistoryDb, lootSource.id)
            table.insert(lootHistoryDb, lootSource.id, foundObject)
            TitanGathered2_PrintDebug("Updating ".. LOOT_HISTORY.." database, added "..tostring(sName))
        else
            foundObject = lootSource
            foundObject.count = 1
            foundObject.loots = {}
            foundObject.sumes = lootQuantity

            table.insert(foundObject.loots, {name = sName, cnt = 1, sum = lootQuantity})
            table.insert(lootHistoryDb, lootSource.id, foundObject)
            TitanGathered2_PrintDebug("Inserting ".. LOOT_HISTORY.." database, added "..tostring(sName))
        end
        tg.setVar(LOOT_HISTORY, lootHistoryDb)
    end


    function tg.PluginUpdateHistory(item,iQuantity,link,oParent)
        local db = tg.getVar(ITEM_HISTORY)
        local i,d
        local oItem	= {}
        local oSrc = {}
        local fndSUM, fndBags, fndBank, fndCount, parentid, oldValue, newValue, found = 0,0,0,0,0,0,0,0,0


        for i,d in pairs(db) do
            if(d.name == item)then
                oldValue = d.value
                found = i
                if (type(d.source) == "table") then
                    oSrc = d.source
                    fndCount = d.source[tonumber(oParent.id)] or 0
                end
            end
        end

        local fnd, category = tg.findItemInCollection(item)
        local isOn = category == nil or TitanGetVar(tg.id, trim(category.smenu));

        if(found > 0) then

            newValue = oldValue + iQuantity

            if (fnd == true) then


                if (oParent.name ~= nil) then
                    table.insert(oSrc, oParent.id, fndCount + 1)
                end

                oItem = { name = item, value = newValue, source = oSrc }
                table.remove(db, found)
                table.insert(db,found,oItem)

                TitanGathered2_PrintDebug("Updating ".. ITEM_HISTORY.." database, added "..tostring(item))
                TitanGathered2_PrintToLog(item, isOn)
                -- if (not isOn) then
                --     local info = getItemStackSizeInfo(item)
                --     echo(printf(TG_C_YELLOW.."TG item found |r %s %s|r", item, info))
                -- end
            end
        else
            if (fnd == true) then
                if (oParent.name ~= nil) then
                    table.insert(oSrc, oParent.id, 1)
                end

                oItem = { name = item, value = iQuantity, source = oSrc }
                table.insert(db,oItem)

                TitanGathered2_PrintDebug("Inserting ".. ITEM_HISTORY.." database, added "..tostring(item))
                TitanGathered2_PrintToLog(item, isOn)
                -- if (not isOn) then
                --     local info = getItemStackSizeInfo(item)
                --     echo(printf(TG_C_YELLOW.."TG item found |r %s %s|r", item, info))
                -- end
            end
        end
        tg.setVar(ITEM_HISTORY, db)
    end


    function TitanGathered2_PrintToLog(itemname, isOn)
        if (not isOn) then
            local info = getItemStackSizeInfo(itemname)
            echo(printf(TG_C_YELLOW.."TG item found |r %s %s|r", itemname, info))
        end
    end
    -------------------------------------------------------
    -- TitanGathered2_bankOpen()
    -- On event BANKFRAME_OPEN will cleared all data in db
    -------------------------------------------------------
    function TitanGathered2_bankOpen()
        TG_EV = 0;
    end

    -------------------------------------------------------
    -- TitanGathered2_bankClose()
    -- On event BANKFRAME_CLOSE will stored data to db
    -------------------------------------------------------
    function TitanGathered2_bankClose()
        if (TG_EV == 1) then
            return;
        else
            local dbb = {};

            if GetNumBankSlots() then
                maxBslot, _ = GetNumBankSlots();
            else
                maxBslot = 0;
            end

            local nbslots, b, s, t, n, nn;
            local i_count = 0;

            reagentBanka = GetContainerNumSlots(-3);

            for s = 0, reagentBanka do
                local texture, itemCount = GetContainerItemInfo(-3, s);

                iName = GetContainerItemLink(-3, s);
                if (iName) then
                    nitem = {name = iName, value = itemCount};
                    table.insert(dbb, nitem);
                end
            end

            nbanka = GetContainerNumSlots(-1);
            for s = 0, nbanka do
                local texture, itemCount = GetContainerItemInfo(-1, s);

                iName = GetContainerItemLink(-1, s);
                if (iName) then
                    nitem = {name = iName, value = itemCount};
                    table.insert(dbb, nitem);
                end
            end

            if (maxBslot > 0) then
                for b = 1, maxBslot, 1 do
                    ibag = b + 4;
                    nbslots = GetContainerNumSlots(ibag);

                    for s = 1, nbslots do
                        local texture, itemCount = GetContainerItemInfo(ibag, s);
                        iName = GetContainerItemLink(ibag, s);

                        if (iName) then
                            nitem = {name = iName, value = itemCount};
                            table.insert(dbb, nitem);
                        end
                    end
                end
            end

            TG_EV = 1;

            echo(TG_COLOR_GREEN.."Titan Gathered: "..TG_C_YELLOW.."bank database updated..");
            TitanSetVar(tg.id, "bankHistory", dbb);
        end
    end

    function tg.addItemsFromLootsToTooltip(self, targetName, lootHistory, itemHistory)
        local _loots = tg.updatePercentsToLootsHistory(targetName, lootHistory, itemHistory) or {};
        for _, item in pairs(_loots) do
            if (item.name == targetName) then
                lootInfo = printf("Gathered "..TG_C_VIOLET.."%d"..TG_C_BROWN.."x|r from: "..TG_C_YELLOW.."%s|r ("..TG_C_YELLOW.."%d"..TG_C_BROWN.."st|r %s)|r", item.cnt, item.source, item.sum, item.percents)
                tg.addTooltipText(self, lootInfo, GameFontNormal);
            end
        end

    end

    function getItemStackSizeInfo(iname)
        local _bgs = GetItemsFromBags(iname)
        local _bnk = GetItemsFromBank(iname)
        local _sum = _bgs + _bnk

        local _str =
        TG_C_YELLOW..
        "Sum: "..
        TG_C_VIOLET..
        "%d "..TG_C_YELLOW..
        "Bgs:"..TG_C_VIOLET..
        " %d "..TG_C_YELLOW..
        "Bnk:"..TG_C_VIOLET..
        " %d|r";

        return printf(_str, _sum, _bgs, _bnk)
    end

    function tg.checkForReagentCounts(sParentName, itemsHistory, minables)
        local sum, bank, bags, livetime = 0, 0, 0, 0

        for i, n in pairs(itemsHistory) do
            if (type(n.source) == "table") then
                local minableId = tg.getMinablesId(sParentName, minables)
                if (n.source[minableId] ~= nil) then
                    bags = GetItemsFromBags(n.name)
                    bank = GetItemsFromBank(n.name)
                    livetime = n.value
                    sum = bank + bags
                end
            end
        end
        return sum, bank, bags, livetime
    end

    function tg._sort(_tObject, _key)
        if(type(_tObject) == "table")then
            table.sort(_tObject, function(a, b)
                if(a[_key] and b[_key])then
                    return a[_key] > b[_key]
                end
            end)
        end
        return _tObject
    end

    function tg.tooltipAddGatheringTriesFromSource(self, mstate)
        if(mstate == true)then
            self:AddLine("Not mined yet.")
        else
            self:AddLine(printf(TG_C_BROWN.."You gathered this resource |r%d"..TG_C_BROWN.." times.|r", mstate.count))
        end
        tg.setTooltipTextSize(GameFontNormalSmall)
    end


    function tg.getMinablesId(tag, db)
        for i, m in pairs(db) do
            if(trim(m.name) == trim(tag)) then
                return tonumber(m.id)
            end
        end
        return 0
    end

    function tg.findItemInCollection(itemName)
        local category, item = tg.GetItemCategory(itemName)
        return item ~= nil, category
    end

    function tg.CheckIfiSMinableObject(item, minablesDb)
        for i, c in pairs(minablesDb) do
            if (item == c.name) then
                return 1
            end
        end
        return 0
    end

    function tg.getGatherableItemName(itemID)
        return tg.isTargetGatherableObject(itemID)
    end

    -------------------------------------------------------
    -- TitanGathered2_GetCategory()
    -- Check if materil is member of tradeskil mats
    -------------------------------------------------------
    function tg.GetItemCategory(itemName)
        local i, iname;
        local f = 0;

        for _, category in pairs(TG_CATEGORIES) do
            if(type(category.db) == "table")then
                for _, item in pairs(category.db)do
                    if (itemName == item.name) then
                        return category, item;
                    end
                end
            end
        end
        return nil;
    end

    -- Greb GUID
    function tg.getLootParentSourceObject(index, lootName)
        local sgUID, _ = GetLootSourceInfo(index)
        local intID = getIDformGUIDString(sgUID)
        local found = { id = intID, name = nil }

        for _, plugin in pairs(tgPlugins)do
            found = plugin.getGatherableSourceObject(found.id)
            -- found = tg.getGatherableItemName(lootName)
            if(found.name ~= nil)then
                return found
            end
        end
        return found
    end

    function tg.getItemProfessionInfo(category, item)
        local prof_1, prof_2, archaeology, fishing, cooking, firstaid = GetProfessions()
        local professions = {}
        local pInfo = {}

        table.insert( professions, prof_1 )
        table.insert( professions, prof_2 )
        table.insert( professions, archaeology )
        table.insert( professions, fishing )
        table.insert( professions, cooking )
        table.insert( professions, firstaid )

        for _, _p in pairs(professions) do
            if (category ~= true and _p ~= nil) then
                local sName, _, sRank, sMax, _, _, _ = GetProfessionInfo(_p)
                if (sName == tostring(category.profession)) then
                    return { name = sName, rank = sRank, max = sMax, color = TG_C_WHITE }
                end
            end
        end
        return nil
    end

    function TitanGathered2_PrintDebug(text)
        if (not TitanGetVar(tg.id, "Debugmode")) then
            DEFAULT_CHAT_FRAME:AddMessage(TG_C_YELLOW..tostring(text));
        end
    end

    -- Return boolean value even given item exist in the gathering db
    function tg.isTargetGatherableObject(itemID)
        for _, c in pairs(TG_CATEGORIES) do
            if (not TitanGetVar(tg.id, c.smenu)) then
                for i, item in pairs(c.db) do
                    if (itemID == item.name or itemID == item.tag) then
                        return 1, item;
                    end
                end
            end
        end
        return 0, nil;
    end

    -- Return item counts from bank
    function GetItemsFromBank(item)
        local dbb = TitanGetVar(tg.id, "bankHistory");
        local i, e;
        local eName;
        local i_count = 0;

        if (dbb) then
            for i, e in pairs(dbb) do
                if (type(e) == "table") then
                    local bName = GetItemInfo(e.name);
                    if (bName == item) then
                        i_count = i_count + e.value;
                    end
                end
            end
        end
        return i_count;
    end

    -- Return all intems from bags
    function GetItemsFromBags(item)
        local nbslots, b, s, t, n;
        local i_count = 0;

        for b = 0, 4 do
            nbslots = GetContainerNumSlots(b);
            for s = 0, nbslots do
                -- TODO simlify this code!!
                local _, itemCount = GetContainerItemInfo(b, s);
                t = GetContainerItemLink(b, s);
                if (t) then
                    local bName = GetItemInfo(t);
                    if (bName == item) then
                        i_count = i_count + itemCount;
                    end
                end
            end
        end
        return i_count;
    end


    function TitanGathered2_GetColorByRarity(item_id)
        local sName, itemLink, i = GetItemInfo(item_id);
        if(not i) then
            return '|cffffffff'
        end

        local r, g, b, hex = GetItemQualityColor(i);
        return '|c'..hex;
    end

    function tg.addTooltipText(tooltip, text, size, color)
        local _color = color or "|cffffff20"
        tooltip:AddLine(_color..text.."|r", 0, 50, 255)
        tg.setTooltipTextSize(size)
    end

    function tg.addEmptyLineToTooltip(tooltip)
        tooltip:AddLine(" ")
    end

    function tg.setTooltipTextSize(size)
        local tooltipIndex = GameTooltip:NumLines()
        _G["GameTooltipTextLeft"..tooltipIndex]:SetFontObject(size)

    end
    ----------------------------------------------------
    -- UTILS
    ----------------------------------------------------
    function tg.getPlayersProfileName()
        local full, name, realm = TitanUtils_GetPlayer()
        return full
    end

    function tg.getPlayerTag()
        local playerKey, playerName, playerServer= TitanUtils_GetPlayer()
        return playerKey
    end

    function tg.updatePercentsToLootsHistory(targetName, lootsHistory, itemsHistory)
        local loots = {}
        for _, source in pairs(lootsHistory) do
            if(type(source.loots) == "table")then
                for i, item in pairs(source.loots)do
                    if(targetName == item.name)then
                        local total = tg.getTotalMinedFromItemLoots(item.name, lootsHistory)
                        item.percents = tg.calculatePercentage(tonumber(total), item.sum)
                        item.source = source.name
                        table.insert( loots, item)
                    end
                end
            end
        end

        table.sort(loots, function(a, b)
            if(a.sum and b.sum)then
                return a.sum > b.sum
            end
        end)

        return loots
    end

    function tg.getTotalMinedFromItemLoots(iName, db)
        local sum = 0;
        for _, rec in pairs(db) do
            if(type(rec.loots) == "table")then
                for _, item in pairs(rec.loots) do
                    if(item.name == iName)then
                        sum = sum + tonumber(item.sum);
                    end
                end
            end
        end
        return sum;
    end

    -- An unused alternative this moment
    function tg.getTotalMinedFromItemHistory(iName, db)
        for _, record in pairs(db) do
            if(tostring(record.name) == tostring(iName))then
                return record.value
            end
        end
        return 0
    end

    function tg.calculatePercentage(max, i)
        local percentage = 0
        if(max == i or max == 0 or i == 0)then
            percents = 100
        else
            percents = (i / max) * 100
        end
        if(percents < 1)then
            return printf("%3.1f%%", percents)
        else
            return printf("%d%%", math.floor(percents))
        end
    end

    function tg.isFloat(n)
        if (math.type(n)=="float") then
            return false
         else
            return true
        end
    end

    function tg.getTableLength(oTable)
        local count = 0
        for _ in pairs(oTable) do count = count + 1 end
        return count
    end

    function tg.getLastPartFromString(sVar)
        local oParts = tg.stringToObjectBySpace(sVar) or {}
        local max = tg.getTableLength(oParts) or 0
        if(type(oParts) == "table")then
            return oParts[max]
        else
            return ""
        end
    end

    function tg.getPartFromString(sVar, index)
        local oParts = tg.stringToObjectBySpace(sVar) or {}
        local max = tg.getTableLength(oParts) or 0
        local i = index or 0
        if(i > max)then
            return ""
        else
            return oParts[index]
        end
    end

    function tg.stringToObjectBySpace(sVar)
        local parts = {}
        local s = tostring(sVar)
        for part in s:gmatch("%w+") do table.insert(parts, part) end
        return parts
    end

    function getIDformGUIDString(guid)
        local parts = {}
        for part in guid:gmatch("([^-]+)") do table.insert(parts, part) end
        return tonumber(parts[6]) or -1
    end

    function getItemIdFromLink(sLink)
        if(sLink ~= nil)then
            local _, _, Color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(sLink,
            "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
            return tonumber(itemId) or 0
        end
        return 0
    end

    function echo(text, color)
        local _color = color or TG_C_WHITE
        print(_color..tostring(text).."|r")
    end

    function trim(s)
        return string.gsub(s, "%s", "");
    end

    function dump(o)
        echo(create_dump(o));
    end

    function create_dump(o)
        if type(o) == "table" then
            local s = TG_COLOR_GREEN.."{|r"
            for k, v in pairs(o) do
                if type(k) ~= "number" then k = '"'..k..'"' end
                s = s .. TG_C_YELLOW .. "[".._color(k) .. "]|r = " .. create_dump(v) .. ",\n"
            end
            return s .. TG_COLOR_GREEN.."}|r"
        else
            return tostring(o)
        end
    end

    function _color(str)
        if(type(str) == "number") then
            return TG_COLOR_RED..str.."|r";
        else
            return str;
        end
    end

    function printf(s, ...)
        return s:format(...);
    end

    function tg.setVar(key, table)
        local playername = tg.getPlayersProfileName()
        local players = tgPluginDb["players"] or {}
        local player = players[playername] or {}

        player[key] = table

        players[playername] = player
        tgPluginDb["players"] = players
    end

    function tg.getVar(key)
        local playername = tg.getPlayersProfileName()
        local players = tgPluginDb["players"] or {}
        local player = players[playername] or {}

        return player[key] or {}
    end

    function tg.UpdateVar(key, index, value)
        local player = tg.getPlayerTag()
        tgPluginDb[player][key][index] = value
    end

    function tg.AddVar(key, value)
        table.insert(tg.getVar(key), value)
    end