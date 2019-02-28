TG_EV = 0;
TG_DEBUG = 1;
TG_PREFIX_SHOW = "Show "
TG_INFO_LABEL = "Titan Gathered info:";
TG_INFO_TOTAL = "Total amount: ";
TG_INFO_OBTAINED = "Already obtained:";
TG_DEFAULT_OPERATION = "Gathered"
TG_LOCAL_DEBUG_MODE = "Debug mode";
TG_ABOUT_TEXT = "About";

TG_LOCAL_SHARDS = "Warlock Shards";
TG_LOCAL_PROFESSIONS = "Primary Professions ";
TG_LOCAL_SEC_PROFESSIONS = "Secondary Professions ";
TG_LOCAL_HIDDE_ZERO = "Show zero items";
TG_LOCAL_SHOW_BANK	= "Show bank stacks";
TG_LOCAL_EXCLUDE_ZERO = "Ignore bag zero stacks";

-- SHOW MENU --------------------------------------------
TG_LOCAL_SHOW_CATEGORIES = "Visible categories";
TG_LOCAL_SHOW_TITAN_OPT = "Titan options";
TG_LOCAL_SHOW_SKILLS = "Show prof. skills";
TG_LOCAL_SHOW_SEC_SKILLS = "Show sec. skills";
TG_LOCAL_BANK_ITEMS = "Bank Items";
TG_LOCAL_SHOW_TOOLTIP = "Enable informations in tooltip";
TG_L_SHOW_STACKS_IN_TOOLTIP = "Show stack info in tooltips";
TG_L_CHANGE_TOOLTIP_ANCHOR = "Change Tooltip Anchor to Mouse";
TG_L_ENABLE_TOOLTIP = "Tooltip";

TG_COLOR_GOLD	 	= "|r";
TG_COLOR_RED 		= "|cFFFF0000";
TG_COLOR_ORANGE 	= "|cffff8020";
TG_COLOR_GREEN 		= "|cFF00FF00";
TG_COLOR_BLUE 		= "|cFF0000FF";
TG_COLOR_GREY 		= "|cff6c6f70";
TG_C_YELLOW 		= "|cffffff20";
TG_C_BROWN	     	= "|cffdf7919"
TG_C_GREY	      	= "|cff999999"
TG_C_SILVER     	= "|cffC0C0C0"
TG_C_GOLD       	= "|cffffff20"
TG_C_VIOLET     	= "|cffff00ff"
TG_C_WHITE      	= "|cffffffff"
TG_C_AQUA       	= "|cff00ffff"

TG_PROFESSIONS_SPELL = {
	{ 
		id = "Mining", 
		operation = "Minned"
	},
	{
		id = "Herbalism",
		operation = "Gathered"
	},
	{
		id = "Skinning",
		operation = "Skinned"
	},
	{
		id = "Enchanting",
		operation = "Enchanted"
	}
}

TG_ITEMS = {
	-- WARLOCK SHARDS --
	{ tag = "5509", name = "Healthstone", save="5509", cat = TG_LOCAL_SHARDS, skill = -1 },
	{ tag = "5512", name = "Soul Shard", save="5512", cat = TG_LOCAL_SHARDS, skill = -1 },
	{ tag = "6265", name = "Soul Shard", save="6265", cat = TG_LOCAL_SHARDS, skill = -1 },
	{ tag = "19004", name = "Healthstone", save="19004", cat = TG_LOCAL_SHARDS, skill = -1 },
	{ tag = "19008", name = "Healthstone", save="19008", cat = TG_LOCAL_SHARDS, skill = -1 },
}

TG_CATEGORIES = {}
TG_MINABLES = {}
