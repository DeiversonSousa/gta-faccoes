#define				TABLE_PROP				"PROPRIEDADES"
#define				ID_PROP					"ID"
#define				NOME_PROP				"NOME"
#define				CUSTO_PROP				"CUSTO COMPRA"
#define				VENDA_PROP				"CUSTO VENDA"
#define				DONO_PROP				"DONO"
#define				POSX_PROP				"POS X"
#define				POSY_PROP				"POS Y"
#define				POSZ_PROP				"POS Z"

#define				MAX_PROPS				100

#define				DEBUG_PROP				true

new 
	MySQL_Connection;

new 
	pInfoPropName[MAX_PROPS][20],
	pInfoPropCusto[MAX_PROPS],
	pInfoPropVenda[MAX_PROPS],
	pInfoPropDono[MAX_PROPS][MAX_PLAYER_NAME],
	Float:pInfoPropPosX[MAX_PROPS],
	Float:pInfoPropPosY[MAX_PROPS],
	Float:pInfoPropPosZ[MAX_PROPS],
	bool:pInfoPropIdCheck[MAX_PROPS];

new
	pInfoPickupProp[MAX_PROPS],
	Text3D:pInfoLabelProp[MAX_PROPS];

new
	Format_MySQL[600],
	Format_Label[150],
	GetDono[24];

public OnGameModeExit()
{
	mysql_close(MySQL_Connection);

	#if defined Prop_OnGameModeExit
       	return Prop_OnGameModeExit();
	#else
	   	return 1;
	#endif
}
#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit Prop_OnGameModeExit
#if defined Prop_OnGameModeExit
    forward Prop_OnGameModeExit();
#endif

stock mysql_prop_connect(const Server_Host[], const Server_User[], const Server_Database[], const Server_Password[]) 
{
	MySQL_Connection = mysql_connect(Server_Host, Server_User, Server_Database, Server_Password);

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, " \
		CREATE TABLE IF NOT EXISTS `"TABLE_PROP"` ( \
		`"ID_PROP"` INT(5) PRIMARY KEY NOT NULL, \
		`"NOME_PROP"` VARCHAR(20) NOT NULL DEFAULT 'N/A', \
		`"CUSTO_PROP"` INT(10) NOT NULL DEFAULT '0', \
		`"VENDA_PROP"` INT(10) NOT NULL DEFAULT '0', \
		`"DONO_PROP"` VARCHAR(24) NOT NULL DEFAULT 'N/A', \
		`"POSX_PROP"` FLOAT NOT NULL DEFAULT '0.0', \
		`"POSY_PROP"` FLOAT NOT NULL DEFAULT '0.0', \
		`"POSZ_PROP"` FLOAT NOT NULL DEFAULT '0.0')");
	mysql_query(MySQL_Connection, Format_MySQL);
	
	#if DEBUG_PROP == true
		printf("CONEXÃO MYSQL - TABLE %s", TABLE_PROP);
	#endif
	
	LoadProps();

	return 1;
}
stock CreateProp(Name_Prop[], Price_Buy_Prop, Price_Sell_Prop, Owner_Prop[], Float:PosX_Prop, Float:PosY_Prop, Float:PosZ_Prop)
{
	new ID_Prop;

	for(new p = 0; p < MAX_PROPS; p ++)
	{
		if(pInfoPropIdCheck[p] == false)
		{
			pInfoPropIdCheck[p] = true;
			ID_Prop = p;
			break;
		}
	}

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, " \
	INSERT INTO `"TABLE_PROP"` ( \
	`"ID_PROP"`, \
	`"NOME_PROP"`, \
	`"CUSTO_PROP"`, \
	`"VENDA_PROP"`, \
	`"DONO_PROP"`, \
	`"POSX_PROP"`, \
	`"POSY_PROP"`, \
	`"POSZ_PROP"`) \
	VALUES ('%i', '%s', '%i', '%i', '%s', '%f', '%f', '%f')", ID_Prop, Name_Prop, Price_Buy_Prop, Price_Sell_Prop, Owner_Prop, PosX_Prop, PosY_Prop, PosZ_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	format(Format_Label, sizeof Format_Label, "ID: %i\nNome: %s\nDono: %s\nPreço: R$ %i,00", ID_Prop, Name_Prop, Owner_Prop, Price_Buy_Prop);
	
	pInfoPickupProp[ID_Prop] = CreatePickup(1210, 1, PosX_Prop, PosY_Prop, PosZ_Prop);
	pInfoLabelProp[ID_Prop] = Create3DTextLabel(Format_Label, -1, PosX_Prop, PosY_Prop, PosZ_Prop + 1, 50.0, 0, 1);

	#if DEBUG_PROP == true
		printf("CreateProp: ID: %i | Nome: %s | Custo: %i | Venda: %i Owner: %s", ID_Prop, Name_Prop, Price_Buy_Prop, Price_Sell_Prop, Owner_Prop);
	#endif
	return 1;
}
stock DeleteProp(Name_Prop[])
{
	new GetID;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"ID_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows())
	{
		GetID = cache_get_field_content_int(0, ID_PROP);

		Delete3DTextLabel(pInfoLabelProp[GetID]);
		DestroyPickup(pInfoPickupProp[GetID]);

		mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "DELETE FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
		mysql_query(MySQL_Connection, Format_MySQL);
	}

	#if DEBUG_PROP == true
		printf("DeleteProp:  %s", Name_Prop);
	#endif
	return 1;
}
stock BuyProp(Owner_Prop[], Name_Prop[])
{
	new GetID;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT * FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows())
	{
		GetID = cache_get_field_content_int(0, ID_PROP);

		cache_get_field_content(0, NOME_PROP, pInfoPropName[GetID]);
		cache_get_field_content(0, DONO_PROP, pInfoPropDono[GetID]);

		printf("BuyProp: %s", pInfoPropDono[GetID]);

		if(!(strcmp("N/A", pInfoPropDono[GetID], true) == 0)) return 0; 

		mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "UPDATE `"TABLE_PROP"` SET `"DONO_PROP"` = '%s' WHERE `"NOME_PROP"` = '%s'", Owner_Prop, Name_Prop);
		mysql_query(MySQL_Connection, Format_MySQL);

		strcat((pInfoPropDono[GetID][0] = '\0', pInfoPropDono[GetID]), Owner_Prop);

		format(Format_Label, sizeof Format_Label, "ID: %i\nNome: %s\nDono: %s", GetID, pInfoPropName[GetID], pInfoPropDono[GetID]);

		Update3DTextLabelText(pInfoLabelProp[GetID], -1, Format_Label);
	}

	#if DEBUG_PROP == true
		printf("BuyProp: %s | Owner: %s", Name_Prop, Owner_Prop);
	#endif
	return 1;
}
stock SellProp(Name_Prop[])
{
	new GetID;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT * FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows())
	{
		GetID = cache_get_field_content_int(0, ID_PROP);
		cache_get_field_content(0, NOME_PROP, pInfoPropName[GetID]);
		pInfoPropCusto[GetID] = cache_get_field_content_int(0, CUSTO_PROP);

		pInfoPropDono[GetID] = "N/A";

		mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "UPDATE `"TABLE_PROP"` SET `"DONO_PROP"` = 'N/A' WHERE `"NOME_PROP"` = '%s'", Name_Prop);
		mysql_query(MySQL_Connection, Format_MySQL, false);

		format(Format_Label, sizeof Format_Label, "ID: %i\nNome: %s\nDono: %s\nPreço: R$ %i,00", GetID, pInfoPropName[GetID], pInfoPropDono[GetID], pInfoPropCusto[GetID]);

		Update3DTextLabelText(pInfoLabelProp[GetID], -1, Format_Label);
	}
	
	#if DEBUG_PROP == true
		printf("SellProp: %s", Name_Prop);
	#endif
	return 1;
}
stock GetPropBuyVal(Name_Prop[])
{
	new Price_Buy_Prop;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"CUSTO_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows()) Price_Buy_Prop = cache_get_field_content_int(0, CUSTO_PROP);

	#if DEBUG_PROP == true
		printf("GetPropBuyVal: %i", Price_Buy_Prop);
	#endif
	return Price_Buy_Prop;
}
stock GetPropSellVal(Name_Prop[])
{
	new Price_Sell_Prop;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"VENDA_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows()) Price_Sell_Prop = cache_get_field_content_int(0, VENDA_PROP);

	#if DEBUG_PROP == true
		printf("GetPropSellVal: %i", Price_Sell_Prop);
	#endif
	return Price_Sell_Prop;
}
stock LoadProps()
{
	new GetID;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT * FROM `"TABLE_PROP"`");
	mysql_query(MySQL_Connection, Format_MySQL);
	if(cache_num_rows())
	{
		printf("\n____________________________PROPERTY_SYS_BY_F1N4L____________________________");
		for(new p = 0; p < cache_num_rows(); p ++)
		{
			GetID = cache_get_field_content_int(p, ID_PROP);

			cache_get_field_content(p, NOME_PROP, pInfoPropName[GetID]);
			cache_get_field_content(p, DONO_PROP, pInfoPropDono[GetID]);
			pInfoPropCusto[GetID] = cache_get_field_content_int(p, CUSTO_PROP);
			pInfoPropVenda[GetID] = cache_get_field_content_int(p, VENDA_PROP);
			pInfoPropPosX[GetID] = cache_get_field_content_float(p, POSX_PROP);
			pInfoPropPosY[GetID] = cache_get_field_content_float(p, POSY_PROP);
			pInfoPropPosZ[GetID] = cache_get_field_content_float(p, POSZ_PROP);

			pInfoPropIdCheck[GetID] = true;

			if(strcmp("N/A", pInfoPropDono[GetID], true) == 0) format(Format_Label, sizeof Format_Label, "ID: %i\nNome: %s\nDono: %s\nPreço: R$ %i,00", GetID, pInfoPropName[GetID], pInfoPropDono[GetID], pInfoPropCusto[GetID]);
			else format(Format_Label, sizeof Format_Label, "ID: %i\nNome: %s\nDono: %s", GetID, pInfoPropName[GetID], pInfoPropDono[GetID]);
			
			pInfoPickupProp[GetID] = CreatePickup(1210, 1, pInfoPropPosX[GetID], pInfoPropPosY[GetID], pInfoPropPosZ[GetID]);
			pInfoLabelProp[GetID] = Create3DTextLabel(Format_Label, -1, pInfoPropPosX[GetID], pInfoPropPosY[GetID], pInfoPropPosZ[GetID] + 1, 50.0, 0, 1);
			
			#if DEBUG_PROP == true
				printf("Nome: %s | Dono: %s | Custo: %i | Venda: %i", pInfoPropName[GetID], pInfoPropDono[GetID], pInfoPropCusto[GetID], pInfoPropVenda[GetID]);
			#endif
		}

		#if DEBUG_PROP == true
			printf("\n%i propriedades carregadas.\n_____________________________________________________________________________\n", cache_num_rows());
		#endif
	}
	
	return 1;
}
stock bool:IsPlayerInRangeOfProp(playerid, Name_Prop[])
{
	new Float:GetPos[3], bool:InRange;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"POSX_PROP"`, `"POSY_PROP"`, `"POSZ_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows())
	{
		GetPos[0] = cache_get_field_content_float(0, POSX_PROP);
		GetPos[1] = cache_get_field_content_float(0, POSY_PROP);
		GetPos[2] = cache_get_field_content_float(0, POSZ_PROP);

		if(IsPlayerInRangeOfPoint(playerid, 5.0, GetPos[0], GetPos[1], GetPos[2])) InRange = true;
		else InRange = false;
	}

	#if DEBUG_PROP == true
		printf("IsPlayerInRangeOfProp: %s | Playerid: %i", Name_Prop, playerid);
	#endif
	return InRange;
}
stock bool:IsEmptyProp(Name_Prop[])
{
	new bool:CheckOwner;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"DONO_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows())
	{
		cache_get_field_content(0, DONO_PROP, GetDono);

		if(strcmp("N/A", GetDono, false) == 0) CheckOwner = true; 
		else CheckOwner = false;
	}
	
	#if DEBUG_PROP == true
		printf("CheckOwnerProp: %s | Existe: %i", Name_Prop, CheckOwner);
	#endif
	return CheckOwner;
}
stock bool:IsPlayerOwnerProp(Owner_Prop[], Name_Prop[])
{
	new bool:PlayerIsOwner;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"DONO_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows())
	{
		cache_get_field_content(0, DONO_PROP, GetDono);

		if(strcmp(Owner_Prop, GetDono, false) == 0) PlayerIsOwner = true; 
		else PlayerIsOwner = false;
	}

	#if DEBUG_PROP == true
		printf("PlayerIsOwnerProp: %s | Owner: %s | Existe: %i", Name_Prop, Owner_Prop, PlayerIsOwner);
	#endif
	return PlayerIsOwner;
}
stock bool:PropExists(Name_Prop[])
{
	new bool:PropExiste;

	mysql_format(MySQL_Connection, Format_MySQL, sizeof Format_MySQL, "SELECT `"NOME_PROP"` FROM `"TABLE_PROP"` WHERE `"NOME_PROP"` = '%s'", Name_Prop);
	mysql_query(MySQL_Connection, Format_MySQL);

	if(cache_num_rows()) PropExiste = true;
	else PropExiste = false;

	#if DEBUG_PROP == true
		printf("CheckPropExists: %s", Name_Prop);
	#endif
	return PropExiste;
}