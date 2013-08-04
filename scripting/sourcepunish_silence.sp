#include <sourcemod>
#include <sdktools>
#include <sourcepunish>

public Plugin:myinfo = {
	name = "SourcePunish Silence",
	author = "Azelphur",
	description = "Silence plugin for SourcePunish",
	version = "0.1",
	url = "https://github.com/Krenair/SourcePunish"
};

new g_bMutedPlayers[MAXPLAYERS + 1];

public OnAllPluginsLoaded() {
	RegisterPunishment("silence", "Silence", AddPunishment, RemovePunishment);
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say2");
	AddCommandListener(Command_Say, "say_team");
}

public Action:Command_Say(client, const String:command[], argc) {
	if (g_bMutedPlayers[client]) {
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public AddPunishment(client, String:reason[]) {
	g_bMutedPlayers[client] = true;
	SetClientListeningFlags(client, VOICE_MUTED);
}

public RemovePunishment(client) {
	g_bMutedPlayers[client] = false;
	new Handle:hDeadTalk = FindConVar("sm_deadtalk");
	if (hDeadTalk != INVALID_HANDLE) {
		if (GetConVarInt(hDeadTalk) == 1 && !IsPlayerAlive(client)) {
			SetClientListeningFlags(client, VOICE_LISTENALL);
		} else if (GetConVarInt(hDeadTalk) == 2 && !IsPlayerAlive(client)) {
			SetClientListeningFlags(client, VOICE_TEAM);
		} else {
			SetClientListeningFlags(client, VOICE_NORMAL);
		}
	} else {
		SetClientListeningFlags(client, VOICE_NORMAL);
	}
}

public OnClientDisconnect(client) {
	g_bMutedPlayers[client] = false;
}