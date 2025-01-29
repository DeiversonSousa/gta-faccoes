////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//           Parte do código relacionado aos NPCs inteligentes
//        O código está todo explicado em comentários para estudos
//                  POR BRUNO DA SILVA ; USA-SE RNPC DE MAUSEN
//              O RNPC ESTA MODIFICADO PARA TRABALHAR COM THREADS
//
//          wwww.brunodasilva.com.br - www.ips-team.forumeiros.com
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////





new ultimaMovimentada[MAX_ZUMBIS] = {-1,...};
new ultimaMovimentaEx[MAX_ZUMBIS];
new ultimaMovimentaEc[MAX_ZUMBIS];

public FollowerPlayer() {

	#if defined CONNECT_ZUMBIS

	static i;

	for(i = 0; i != MAX_ZUMBIS; i++) {
		if(gettime() - gLastTime[i] > 30) {
			BotFollow(i);
		}
		if(gettime() - gLastTime[i] < 30)         {
			ClearAnimations(i);
			ApplyAnimation(i,"PED","HIT_back",12.1,1,1,1,1,1,1);
		}
	}

	#endif

	return true;
}



public BotFollow(i) {

	static highestid;
	static Float:x, Float:y, Float:z, Float:highest, Float:health, Float:dis;

	GetPlayerPos(i, x, y, z);

	highestid = -1;
	highest = 99999.99;

	Players(p) {

		if(!(IsPlayerSpawned(p)) || GetPVarInt(p, "dormindo") || jogadorComFogueira[p] || gettime() - lastSinc [ p ] ) continue;

		dis = GetPlayerDistanceFromPoint(p , x, y, z);

		if(dis < highest && dis != -1.00 && IsPlayerSpawned(p)) {
			highest = dis;
			highestid = p;
		}
	}


	if( highestid == - 1) 															return false;
	//if( gZumbiFollow[highestid] >= MAX_ZUMBINELES && highestid != gProxPlayer[i])	return false;

	x = MIN_DISTANCE;

	if(GetPlayerSpecialAction(highestid) == SPECIAL_ACTION_DUCK) {
		x -= 30.0;
	}



	if(highest > x) {

		if( ultimaMovimentada[i] == -1 || IsPlayerConnected(gProxPlayer[i]) ) {

			ultimaMovimentada[i] = Node_GetNearest(gLVNodes, x, y, z);

			MoveRNPC(i, gLVNodes[ ultimaMovimentada[i] ][xLINK],gLVNodes[ ultimaMovimentada[i] ][yLINK], gLVNodes[ ultimaMovimentada[i] ][zLINK], 0.0089);
		}
		else if(gettime() - ultimaMovimentaEc [ i ] > 5 && IsPlayerInRangeOfPoint(i, 1.5, gLVNodes[ultimaMovimentada[i]][xLINK], gLVNodes[ultimaMovimentada[i]][yLINK], gLVNodes[ultimaMovimentada[i]][zLINK]+0.5))	{

			if(ultimaMovimentaEx[i] == 0) {
				ultimaMovimentada[i] ++;
			}
			else {
				ultimaMovimentada[i] --;
			}

//

			if(ultimaMovimentada[i] == 0) {
				ultimaMovimentaEx[i] = 0;
			}
			if(ultimaMovimentada[i] >= sizeof gLVNodes - 2) {
				ultimaMovimentaEx[i] = 1;
			}

			ultimaMovimentaEc [ i ] = gettime();

			MoveRNPC(i, gLVNodes[ultimaMovimentada[i]][xLINK], gLVNodes[ultimaMovimentada[i]][yLINK],gLVNodes[ultimaMovimentada[i]][zLINK]+0.5, 0.0089);
		}

		gProxPlayer[i] = -1;
		gProxPos[i] = Float:  0x7F800000;

		return true;
	}


	// caso algum jogador estiver nas próximidades do jogador

	GetPlayerPos(highestid, x, y, z);

	if( 1.7 >= highest )  {

		GetPlayerHealth(highestid, health);

		if( health < 30.0 ) {

			ApplyAnimation(highestid, "WUZI", "CS_Dead_Guy", 8.5, 1, 1, 1, 1, 0,1);
			ApplyPlayerAnimation(i, "BOMBER", "BOM_Plant_2Idle", 4.1, 1, 1, 1, 1, 1, 1);

			SetPlayerToFacePlayer(i, highestid);
			SetPlayerHealth(highestid, health - 3.0);

			if(0 == GetPVarInt(highestid, "JaIniciado"))  {

				SetPVarInt(highestid, "JaIniciado", 1);

				SetPlayerCameraPos(highestid, x, y, z + 07.0);
				SetPlayerCameraLookAt(highestid, x, y, z );

				SetPVarInt(highestid, "goro1", CreateObject(2907, x+(random(280)/100),y-(random(180)/100),z-0.8, 0.0, 0.0, 0.0));
				SetPVarInt(highestid, "goro2", CreateObject(2906, x+(random(280)/100),y-(random(280)/100),z-0.8, 0.0, 0.0, 0.0));
				SetPVarInt(highestid, "goro3", CreateObject(2905, x+(random(280)/100),y-(random(280)/100),z-0.8, 0.0, 0.0, 0.0));

				SetPVarInt(highestid, "Espirrando", SetTimerEx("EspirrarSangue", 1200, true, "i", highestid));

				static Float: npcPos [3] ;

				GetPlayerPos(i, npcPos[0], npcPos[1], npcPos[2]);

				MoveRNPC(i, x, y-0.1, z, 0.0083);

			}

			return true;
		}

		SetPlayerHealth(highestid, health - 5.0);
		ApplyPlayerAnimation(i,"RIOT","RIOT_PUNCHES",4.1,0,1,1,1,1);
	}
	else {

		ApplyAnimation(i, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 1, 1, 1);


		GetPlayerFacingAngle(i, health);

		if(random(2) - 1) {

			static
			Float: delay, Float: side;

			switch(floatround(highest)) {
				case 01 .. 12:				delay = 25.0;
				case 13 .. 25:	            delay = 15.0;
				case 26  .. 40:	            delay = 25.0;
				case 41  .. 50:             delay = 25.0;
				case 51  .. 76:             delay = 20.0;
			}

			if(random(2) - 1)
			side = -health-90.0;
			else
			side = -health+90.0;

			x += ((random(floatround( delay ))) * floatsin(side, degrees));
			y += ((random(floatround( delay ))) * floatcos(side, degrees));

		}
	}


	if(IsPlayerConnected(gProxPlayer[i])) {
		gZumbiFollow[gProxPlayer[i]]--;
	}

	gZumbiFollow[highestid] ++;
	gProxPlayer[i] = highestid;

	static Float: pPos[3];

	GetPlayerPos(i, pPos[0], pPos[1], pPos[2]);

	RNPC_CreateBuild(i, PLAYER_RECORDING_TYPE_ONFOOT);
	RNPC_AddMovement(pPos[0], pPos[1], pPos[2], x, y, z, 0.0080);
	RNPC_FinishBuild();

	RNPC_StartBuildPlayback(i);

	SendClientMessage(i, -1, "RNPC:101:0");


	return true;

}


 // RYDER FUNCION
// http://forum.sa-mp.com/member.php?u=46049

stock Node_GetNearest(const aeNodes[][], Float: fX, Float: fY, Float: fZ, const iSize = sizeof(aeNodes)) { // Get nearest node
        new
                iNode,
                Float: fDist1,
                Float: fDist2
        ;
        fDist2 = floatpower(aeNodes[0][xLINK] - fX, 2.0) + floatpower(aeNodes[0][yLINK] - fY, 2.0) + floatpower(aeNodes[0][zLINK] - fZ, 2.0);
       
        for(new i = 1; i < iSize; ++i) {
                fDist1 = floatpower(aeNodes[i][xLINK] - fX, 2.0) + floatpower(aeNodes[i][yLINK] - fY, 2.0) + floatpower(aeNodes[i][zLINK] - fZ, 2.0);
               
                if(fDist1 < fDist2) {
                        iNode = i;
                        fDist2 = fDist1;
                }
        }
        return iNode;
}


// ==========================================================================================
