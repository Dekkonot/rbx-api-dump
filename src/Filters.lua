return {
	Security = {
		None = {},
		CoreScript = {"RobloxSecurity", "NotAccessibleSecurity"},
		Plugin = {"LocalUserSecurity", "RobloxScriptSecurity", "NotAccessibleSecurity", "RobloxSecurity"},
		Normal = {"PluginSecurity", "LocalUserSecurity", "RobloxScriptSecurity", "NotAccessibleSecurity", "RobloxSecurity"},
	},
	Members = {
		None = {},
		Writable = {"ReadOnly", "NotScriptable"},
		Sync = {"CanYield", "Yields"},
		NotDeprecated = {"Deprecated"},
		Normal = {"ReadOnly", "NonScriptable", "Deprecated"},
	},
	Class = {
		None = {},
		NonService = {"Service"},
		NotDeprecated = {"Deprecated"},
		NotSettings = {"Settings"},
	}
}