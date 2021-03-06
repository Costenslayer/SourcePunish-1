#include <sourcemod>
#include <sdktools>
#include <sourcepunish>
#include <sourcepunish_punishment>

public Plugin:myinfo = {
	name = "SourcePunish Block Spray",
	author = "Azelphur",
	description = "Block Spray plugin for SourcePunish",
	version = "0.2",
	url = "https://github.com/Krenair/SourcePunish"
};

new bool:g_bSprayBanned[MAXPLAYERS + 1];

public OnAllPluginsLoaded() {
	RegisterPunishment("blockspray", "Block Spray", AddPunishment, RemovePunishment, 0, ADMFLAG_CHAT);
	AddTempEntHook("Player Decal", PlayerSpray);
}

public AddPunishment(client, String:reason[], String:adminName[]) {
	g_bSprayBanned[client] = true;
}

public RemovePunishment(client) {
	g_bSprayBanned[client] = false;
}

public Action:PlayerSpray(const String:te_name[], const clients[], client_count, Float:delay) {
	new client = TE_ReadNum("m_nPlayer");

	if (IsClientInGame(client) && g_bSprayBanned[client]) {
		PrintToChat(client, "You are banned from placing sprays on this server");
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public OnClientDisconnect(client) {
	g_bSprayBanned[client] = false;
}
