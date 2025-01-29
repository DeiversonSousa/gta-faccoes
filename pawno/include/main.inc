
#include <a_samp>
#include <rnpc>

#define IsPlayerSpawned(%1)													GetPVarInt(%1, "spawn") == 1

#define Players(%0) \
	static %0, loopPlayers_%0; %0 = gPlayersLoop[0], loopPlayers_%0 = 0; \
	for( ; loopPlayers_%0 != gPlayersonline; loopPlayers_%0++, %0 = gPlayersLoop[loopPlayers_%0])

#define cmd(%0,%1,%2)															forward g_Cmd@%0(%1,%2); public g_Cmd@%0(%1,%2)

#define IsAlphaNum(%0)             												((%0 >= 0x41 && %0 <= 0x5A) || (%0 >= 0x61 && %0 <= 0x7A) || (%0 >= '0' && %0 <= '9'))

#define FormattedMessage(%1)       												(format(szFormat, 128, %1), szFormat) 


#define COLOR_LIGHTBLUE		0x33CCFFAA
#define COLOR_LIGHTGREEN	0xB8FF00FF
#define COLOR_GREYGREEN		0xCCDD66FF
#define COLOR_DARKBLUE		0x9966FFFF
#define COLOR_PEPPER		0xDD3333FF
#define COLOR_YELLOW		0xFFEA00FF
#define COLOR_ORANGE		0xFAAB00FF
#define COLOR_WHITE		0xFFFFFFFF
#define COLOR_RED		0xFF0000FF

#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif

#if defined MAX_PICKUPS
	#undef MAX_PICKUPS
#endif

#include ../include/servidor.cfg


#include ../include/declaracao.inc
#include ../include/sqlite.inc
#include ../include/mapas.inc
#include "../include/progress.inc"
#include "../include/motornpc.inc"

