========================================================================
================================================================================
===========================[ Sistema de Concessionária ]========================
================================[ By Rodrigo_LosT]==============================
========================[ Por favor, mantenha os créditos ]=====================
================================================================================
==============================================================================*/

#define FILTERSCRIPT
#include <a_samp>
#include <DOF2>

#define AzulLindo 0x3FCFFFFF
#define Azul 0x33CCFFAA
#define Branco 0xFFFFFFAA

//Nome dos Carros
new vehName[][] ={
"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster",
"Limosine","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulancia","Leviathan","Moonbeam","Esperanto",
"Taxi","Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee",
"Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo",
"RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer",
"Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer",
"PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale","Oceanic","Sanchez","Sparrow","Patriot",
"Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR-350","Walton","Regina","Comet","BMX",
"Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo",
"Greenwood","Jetmax","Hotring","Sandking","Blista Compact","Maverick Policial","Boxville","Benson","Mesa",
"RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT","Elegant",
"Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain","Nebula","Majestic",
"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona",
"FBI Truck","Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight",
"Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob",
"Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A","Monster B","Uranus",
"Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight",
"Trailer","Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford",
"BF-400","Newsvan","Tug","Trailer A","Emperor","Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C",
"Andromada","Dodo","RC Cam","Launch","Viatura (LSPD)","Viatura (SFPD)","Viatura (LVPD)","Police Ranger",
"Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
"Stair Trailer","Boxville","Farm Plow","Utility Trailer" };

//===[ Sistema PART 1 ]===
#define MAX_cCARROS 51 // 1 a mais do máximo de carros (Máximo = 50)
#define MAX_DIGITOS 4 //Máximo de digitos (+ 1) personalizados na placa (Máximo = 3)
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward CarregarCarros();
forward CarregarCarro(cCarroid);
SalvarCarro(cCarroid);
forward ComprarCarro(playerid);
forward FuncaocCarro(playerid);
forward CarroVida(playerid);
PrecoCarro(playerid, modelo);
forward DiniCarro(playerid);
verificarPreco(modelo);
verificarModelo(modelo);
new CarroVidaTimer;
enum cInfo
{
    cDono[MAX_PLAYER_NAME],
    cModelo,
    Float:cSpawnX,
    Float:cSpawnY,
    Float:cSpawnZ,
    Float:cAngulo,
    cCarroON,
    cCorUm,
    cCorDois,
    cChave[MAX_cCARROS],
    cCID,
    cPlaca[MAX_DIGITOS]
};
new Carro[MAX_cCARROS][cInfo];
new cCarro[MAX_cCARROS];
//new cCarr[MAX_cCARROS];
new TaNoCarro[MAX_PLAYERS];
new ModeloCarro[MAX_PLAYERS];
new Text3D:texto3DCarro[MAX_cCARROS];
//------------------------------------------------------------------------------
//===[ Sistema PART 2 ]===
forward CarregarDono(playerid);
forward SalvarDono(playerid);
enum dInfo
{
    dChave,
    dDono[MAX_PLAYER_NAME],
    dModelo
};
new Dono[MAX_PLAYERS][dInfo];

#define MAX_TIPOSCARROS 69 //Total de modelos
//Preços
#define PRECO_Bravura 35000
#define PRECO_Buffalo 45000
#define PRECO_Perenniel 35000
#define PRECO_Sentinel 35000
#define PRECO_Limosine 60000
#define PRECO_Manana 35000
#define PRECO_Voodoo 40000
#define PRECO_Cheetah 45000
#define PRECO_Moonbeam 35000
#define PRECO_Esperanto 35000
#define PRECO_Washington 35000
#define PRECO_Premier 35000
#define PRECO_Banshee 50000
#define PRECO_Hotknife 50000
#define PRECO_Previon 35000
#define PRECO_Stallion 35000
#define PRECO_Romero 35000
#define PRECO_Admiral 35000
#define PRECO_Turismo 50000
#define PRECO_Solair 35000
#define PRECO_Glendale 35000
#define PRECO_Oceanic 35000
#define PRECO_Hermes 35000
#define PRECO_Sabre 35000
#define PRECO_ZR350 45000
#define PRECO_Regina 35000
#define PRECO_Comet 40000
#define PRECO_Camper 35000
#define PRECO_Virgo 35000
#define PRECO_Greenwood 40000
#define PRECO_BlistaCompact 35000
#define PRECO_SuperGT 45000
#define PRECO_Elegant 35000
#define PRECO_Nebula 35000
#define PRECO_Majestic 35000
#define PRECO_Buccaneer 35000
#define PRECO_Fortune 35000
#define PRECO_Cadrona 35000
#define PRECO_Willard 35000
#define PRECO_Feltzer 35000
#define PRECO_Remington 35000
#define PRECO_Slamvan 35000
#define PRECO_Blade 35000
#define PRECO_Vincent 35000
#define PRECO_Bullet 50000
#define PRECO_Clover 35000
#define PRECO_Hustler 35000
#define PRECO_Intruder 35000
#define PRECO_Primo 35000
#define PRECO_Tampa 35000
#define PRECO_Sunrise 35000
#define PRECO_Merit 35000
#define PRECO_Windsor 35000
#define PRECO_Uranus 45000
#define PRECO_Jester 40000
#define PRECO_Sultan 45000
#define PRECO_Stratum 35000
#define PRECO_Elegy 45000
#define PRECO_Flash 35000
#define PRECO_Tahoma 35000
#define PRECO_Savanna 40000
#define PRECO_Broadway 35000
#define PRECO_Tornado 35000
#define PRECO_Stafford 35000
#define PRECO_Emperor 35000
#define PRECO_Euros 45000
#define PRECO_Club 35000
#define PRECO_Alpha 40000
#define PRECO_Phoenix 45000

//------------------------------------------------------------------------------

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public CarroVida(playerid)
{
    new Float:Vida;
    new VID = GetPlayerVehicleID(playerid);
    GetVehicleHealth(VID, Vida);
    if(Vida < 244)
    {
        new car = TaNoCarro[playerid];
        if(car > 0)
        {
            Delete3DTextLabel(texto3DCarro[car]);
            DestroyVehicle(cCarro[car]);
            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Seu carro foi destruído... Lamentamos, sem re-imbolso.");
            TaNoCarro[playerid] = 0;
            format(Carro[car][cDono], MAX_PLAYER_NAME, "Ninguem");
            KillTimer(CarroVidaTimer);
            return 1;
        }
    }
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    for(new c = 0; c < MAX_cCARROS; c++)
	{
        if(Carro[c][cCID] == vehicleid)
        {
            new string[256];
            format(string, sizeof(string), "[CONCESSIONÁRIA] Este(a) %s pertence à %s.", vehName[GetVehicleModel(vehicleid)-400], Carro[c][cDono]);
            SendClientMessage(playerid, Branco, " ");
            SendClientMessage(playerid, Azul, string);
        }
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new PlayerNick[MAX_PLAYER_NAME];
    GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
    new arquivo[256];
    format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
    if(dialogid == 1319)
    {
        if(response == 1)
        {
                if(listitem == 0)
                {
                    if(DOF2_FileExists(arquivo))
                    {
                        CarregarDono(playerid);
                        new carro = Dono[playerid][dModelo];
                        new string[256];
                        format(string, sizeof(string), "Tem certeza que deseja vender seu carro?\nVocê receberá $%d", (verificarPreco(carro)/2));
                        ShowPlayerDialog(playerid,1320,DIALOG_STYLE_MSGBOX,"Concessionária",string,"Sim","Não");
                    }
                    else
                    {
                        SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você não tem um carro!");
                    }
                }
                if(listitem == 1)
                {
                    new textdialog[3000];
                    new string[MAX_TIPOSCARROS][256];
                    for(new c = 0; c < MAX_TIPOSCARROS; c++)
                    {
                        format(string[c], sizeof(string), "%s, $%d\n", vehName[verificarModelo(c)-400] ,verificarPreco(verificarModelo(c)));
                        strins(textdialog, string[c], strlen(textdialog));
                    }
                    ShowPlayerDialog(playerid,1321,DIALOG_STYLE_LIST,"Qual carro você deseja comprar?",textdialog,"Selecionar","Cancelar");
                }
        }
        else
        {
            //Tudo que vai acontecer no botão direito.
        }
    }
    if(dialogid == 1320)
    {
        if(response == 1)
		{
            if(DOF2_FileExists(arquivo))
            {
                new carro = Dono[playerid][dChave];
                GivePlayerMoney(playerid, (verificarPreco(Carro[carro][cModelo])/2));
                format(Carro[carro][cDono], MAX_PLAYER_NAME, "Ninguem");
                format(Carro[carro][cPlaca], MAX_DIGITOS, "RLS");
                Carro[carro][cCarroON] = 0;
                Carro[carro][cModelo] = 0;
                Carro[carro][cSpawnX] = 0.000000;
	            Carro[carro][cSpawnY] = 0.000000;
	            Carro[carro][cSpawnZ] = 0.000000;
                Carro[carro][cAngulo] = 0.000000;
                Carro[carro][cCorUm] = 0;
                Carro[carro][cCorDois] = 0;
                Dono[playerid][dChave] = 0;
                Dono[playerid][dModelo] = 0;
                format(Dono[playerid][dDono], MAX_PLAYER_NAME, "Ninguem");
                DOF2_RemoveFile(arquivo);
                SalvarCarro(carro);
                Delete3DTextLabel(texto3DCarro[carro]);
                DestroyVehicle(cCarro[carro]);
                SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Carro vendido com sucesso!");
            }
            else
            {
                SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você não tem um carro!");
            }
        }
        else
        {
            SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Venda do carro cancelada!");
        }
    }
    if(dialogid == 1321)
    {
        if(response == 1)
		{
            if(!DOF2_FileExists(arquivo))
            {
                if(listitem == 0){ ModeloCarro[playerid] = 401; PrecoCarro(playerid, 401); }
                if(listitem == 1){ ModeloCarro[playerid] = 402; PrecoCarro(playerid, 402); }
                if(listitem == 2){ ModeloCarro[playerid] = 404; PrecoCarro(playerid, 404); }
                if(listitem == 3){ ModeloCarro[playerid] = 405; PrecoCarro(playerid, 405); }
                if(listitem == 4){ ModeloCarro[playerid] = 409; PrecoCarro(playerid, 409); }
                if(listitem == 5){ ModeloCarro[playerid] = 410; PrecoCarro(playerid, 410); }
                if(listitem == 6){ ModeloCarro[playerid] = 412; PrecoCarro(playerid, 412); }
                if(listitem == 7){ ModeloCarro[playerid] = 415; PrecoCarro(playerid, 415); }
                if(listitem == 8){ ModeloCarro[playerid] = 418; PrecoCarro(playerid, 418); }
                if(listitem == 9){ ModeloCarro[playerid] = 419; PrecoCarro(playerid, 419); }
                if(listitem == 10){ ModeloCarro[playerid] = 421; PrecoCarro(playerid, 421); }
                if(listitem == 11){ ModeloCarro[playerid] = 426; PrecoCarro(playerid, 426); }
                if(listitem == 12){ ModeloCarro[playerid] = 429; PrecoCarro(playerid, 429); }
                if(listitem == 13){ ModeloCarro[playerid] = 434; PrecoCarro(playerid, 434); }
                if(listitem == 14){ ModeloCarro[playerid] = 436; PrecoCarro(playerid, 436); }
                if(listitem == 15){ ModeloCarro[playerid] = 439; PrecoCarro(playerid, 439); }
                if(listitem == 16){ ModeloCarro[playerid] = 442; PrecoCarro(playerid, 442); }
                if(listitem == 17){ ModeloCarro[playerid] = 445; PrecoCarro(playerid, 445); }
                if(listitem == 18){ ModeloCarro[playerid] = 451; PrecoCarro(playerid, 451); }
                if(listitem == 19){ ModeloCarro[playerid] = 458; PrecoCarro(playerid, 458); }
                if(listitem == 20){ ModeloCarro[playerid] = 466; PrecoCarro(playerid, 466); }
                if(listitem == 21){ ModeloCarro[playerid] = 467; PrecoCarro(playerid, 467); }
                if(listitem == 22){ ModeloCarro[playerid] = 474; PrecoCarro(playerid, 474); }
                if(listitem == 23){ ModeloCarro[playerid] = 475; PrecoCarro(playerid, 475); }
                if(listitem == 24){ ModeloCarro[playerid] = 477; PrecoCarro(playerid, 477); }
                if(listitem == 25){ ModeloCarro[playerid] = 479; PrecoCarro(playerid, 479); }
                if(listitem == 26){ ModeloCarro[playerid] = 480; PrecoCarro(playerid, 480); }
                if(listitem == 27){ ModeloCarro[playerid] = 483; PrecoCarro(playerid, 483); }
                if(listitem == 28){ ModeloCarro[playerid] = 491; PrecoCarro(playerid, 491); }
                if(listitem == 29){ ModeloCarro[playerid] = 492; PrecoCarro(playerid, 492); }
                if(listitem == 30){ ModeloCarro[playerid] = 496; PrecoCarro(playerid, 496); }
                if(listitem == 31){ ModeloCarro[playerid] = 506; PrecoCarro(playerid, 506); }
                if(listitem == 32){ ModeloCarro[playerid] = 507; PrecoCarro(playerid, 507); }
                if(listitem == 33){ ModeloCarro[playerid] = 516; PrecoCarro(playerid, 516); }
                if(listitem == 34){ ModeloCarro[playerid] = 517; PrecoCarro(playerid, 517); }
                if(listitem == 35){ ModeloCarro[playerid] = 518; PrecoCarro(playerid, 518); }
                if(listitem == 36){ ModeloCarro[playerid] = 526; PrecoCarro(playerid, 526); }
                if(listitem == 37){ ModeloCarro[playerid] = 527; PrecoCarro(playerid, 527); }
                if(listitem == 38){ ModeloCarro[playerid] = 529; PrecoCarro(playerid, 529); }
                if(listitem == 39){ ModeloCarro[playerid] = 533; PrecoCarro(playerid, 533); }
                if(listitem == 40){ ModeloCarro[playerid] = 534; PrecoCarro(playerid, 534); }
                if(listitem == 41){ ModeloCarro[playerid] = 535; PrecoCarro(playerid, 535); }
                if(listitem == 42){ ModeloCarro[playerid] = 536; PrecoCarro(playerid, 536); }
                if(listitem == 43){ ModeloCarro[playerid] = 540; PrecoCarro(playerid, 540); }
                if(listitem == 44){ ModeloCarro[playerid] = 541; PrecoCarro(playerid, 541); }
                if(listitem == 45){ ModeloCarro[playerid] = 542; PrecoCarro(playerid, 542); }
                if(listitem == 46){ ModeloCarro[playerid] = 545; PrecoCarro(playerid, 545); }
                if(listitem == 47){ ModeloCarro[playerid] = 546; PrecoCarro(playerid, 546); }
                if(listitem == 48){ ModeloCarro[playerid] = 547; PrecoCarro(playerid, 547); }
                if(listitem == 49){ ModeloCarro[playerid] = 549; PrecoCarro(playerid, 549); }
                if(listitem == 50){ ModeloCarro[playerid] = 550; PrecoCarro(playerid, 550); }
                if(listitem == 51){ ModeloCarro[playerid] = 551; PrecoCarro(playerid, 551); }
                if(listitem == 52){ ModeloCarro[playerid] = 555; PrecoCarro(playerid, 555); }
                if(listitem == 53){ ModeloCarro[playerid] = 558; PrecoCarro(playerid, 558); }
                if(listitem == 54){ ModeloCarro[playerid] = 559; PrecoCarro(playerid, 559); }
                if(listitem == 55){ ModeloCarro[playerid] = 560; PrecoCarro(playerid, 560); }
                if(listitem == 56){ ModeloCarro[playerid] = 561; PrecoCarro(playerid, 561); }
                if(listitem == 57){ ModeloCarro[playerid] = 562; PrecoCarro(playerid, 562); }
                if(listitem == 58){ ModeloCarro[playerid] = 565; PrecoCarro(playerid, 565); }
                if(listitem == 59){ ModeloCarro[playerid] = 566; PrecoCarro(playerid, 566); }
                if(listitem == 60){ ModeloCarro[playerid] = 567; PrecoCarro(playerid, 567); }
                if(listitem == 61){ ModeloCarro[playerid] = 575; PrecoCarro(playerid, 575); }
                if(listitem == 62){ ModeloCarro[playerid] = 576; PrecoCarro(playerid, 576); }
                if(listitem == 63){ ModeloCarro[playerid] = 580; PrecoCarro(playerid, 580); }
                if(listitem == 64){ ModeloCarro[playerid] = 585; PrecoCarro(playerid, 585); }
                if(listitem == 65){ ModeloCarro[playerid] = 587; PrecoCarro(playerid, 587); }
                if(listitem == 66){ ModeloCarro[playerid] = 589; PrecoCarro(playerid, 589); }
                if(listitem == 67){ ModeloCarro[playerid] = 602; PrecoCarro(playerid, 602); }
                if(listitem == 68){ ModeloCarro[playerid] = 603; PrecoCarro(playerid, 603); }
            }
            else
            {
                SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você já tem um carro!");
            }
        }
        else
        {
            SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Compra de carro cancelada.");
        }
    }
    return 0;
}

public OnPlayerConnect(playerid)
{
    TaNoCarro[playerid] = 0;
}

public OnPlayerDisconnect(playerid)
{
    new car = TaNoCarro[playerid];
    if(car > 0)
    {
        Delete3DTextLabel(texto3DCarro[car]);
        DestroyVehicle(cCarro[car]);
        TaNoCarro[playerid] = 0;
        format(Carro[car][cDono], MAX_PLAYER_NAME, "Ninguem");
        return 1;
    }
    return 0;
}

public OnVehicleSpawn(vehicleid)
{
    for(new c = 1; c<MAX_cCARROS; c++)
    {
        if(vehicleid == Carro[c][cCID])
        {
            ChangeVehicleColor(vehicleid, Carro[c][cCorUm], Carro[c][cCorDois]);
        }
    }
    return 0;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    new tcar = TaNoCarro[playerid];
    if(tcar > 0)
    {
        Delete3DTextLabel(texto3DCarro[tcar]);
        DestroyVehicle(cCarro[tcar]);
        SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Você foi avisado...");
        GivePlayerMoney(playerid, verificarPreco(ModeloCarro[playerid]));
        TaNoCarro[playerid] = 0;
        format(Carro[tcar][cDono], MAX_PLAYER_NAME, "Ninguem");
        return 1;
    }
    return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new idx;
    new cmd[128];
    cmd = strtok(cmdtext, idx);
    if(strcmp(cmd, "/admdestruircarro", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
            if(IsPlayerAdmin(playerid))
		    {
                new comando[256];
                comando = strtok(cmdtext, idx);
			    if(!strlen(comando))
			    {
				    SendClientMessage(playerid, Branco, "USE: /admdestruircarro [ Carro ID ]");
				    return 1;
			    }
			    new carrito = strval(comando);
                if(Carro[carrito][cCarroON] > 0)
                {
                    new arquivo[256];
                    new arquivo2[256];
                    format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini", carrito);
                    format(Carro[carrito][cDono], MAX_PLAYER_NAME, "%s", DOF2_GetString(arquivo,"cDono"));
                    format(arquivo2, sizeof(arquivo2), "/Concessionaria/Donos/%s.ini",Carro[carrito][cDono]);
                    format(Carro[carrito][cDono], MAX_PLAYER_NAME, "Ninguem");
                    format(Carro[carrito][cPlaca], MAX_DIGITOS, "RLS");
                    Carro[carrito][cCarroON] = 0;
                    Carro[carrito][cModelo] = 0;
                    Carro[carrito][cSpawnX] = 0.00000000;
                    Carro[carrito][cSpawnY] = 0.00000000;
                    Carro[carrito][cSpawnZ] = 0.00000000;
                    Carro[carrito][cAngulo] = 0.00000000;
                    Carro[carrito][cCorUm] = 0;
                    Carro[carrito][cCorDois] = 0;
                    SalvarCarro(carrito);
                    DOF2_RemoveFile(arquivo2);
                    Delete3DTextLabel(texto3DCarro[carrito]);
                    DestroyVehicle(cCarro[carrito]);
                    SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Carro destruído com sucesso!");
                }
                else
                {
                    SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Esse carro não tem dono.");
                    return 1;
                }
		    }
        }
        return 1;
	}
    if(strcmp(cmdtext,"/carroestacionar",true)==0)
	{
        if(IsPlayerInAnyVehicle(playerid))
        {
            new Float:X,Float:Y,Float:Z;
            new Float:A;
            new VID = GetPlayerVehicleID(playerid);
            CarregarDono(playerid);
            new PlayerNick[MAX_PLAYER_NAME];
    	    GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
            new arquivo[256];
            format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
            if(DOF2_FileExists(arquivo))
            {
                new carro = Dono[playerid][dChave];
                if(Carro[carro][cCID] == VID)
                {
                    if(strcmp(PlayerNick,Carro[carro][cDono],true)==0)
				    {
                        CarregarCarro(carro);
                        GetVehicleZAngle(VID,A);
                        GetVehiclePos(VID,X,Y,Z);
                        Carro[carro][cSpawnX] = X;
                        Carro[carro][cSpawnY] = Y;
                        Carro[carro][cSpawnZ] = Z;
                        Carro[carro][cAngulo] = A;
                        format(Carro[carro][cDono], MAX_PLAYER_NAME, "%s", PlayerNick);
                        Carro[carro][cCarroON] = 1;
                        Delete3DTextLabel(texto3DCarro[carro]);
                        DestroyVehicle(cCarro[carro]);
                        cCarro[carro] = AddStaticVehicle(Carro[carro][cModelo],Carro[carro][cSpawnX],Carro[carro][cSpawnY],Carro[carro][cSpawnZ],Carro[carro][cAngulo],Carro[carro][cCorUm],Carro[carro][cCorDois]);
                        new string[256];
                        format(string, sizeof(string), "[PLACA]\n%s-%d", Carro[carro][cPlaca], Carro[carro][cChave]);
                        texto3DCarro[carro] = Create3DTextLabel(string, AzulLindo, 0.0, 0.0, 0.0, 25.0, 0, 1);
                        Attach3DTextLabelToVehicle( texto3DCarro[carro], cCarro[carro], 0.0,-3.0,0.0);
                        PutPlayerInVehicle(playerid, cCarro[carro], 0);
                        Carro[carro][cCID] = VID;
                        SalvarCarro(carro);
                        SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Carro estacionado com sucesso!");
                        return 1;
                    }
                }
                else
                {
                    SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Este carro não é seu!");
                    return 1;
                }
            }
            new car = TaNoCarro[playerid];
            if(car > 0)
            {
                CarregarCarro(car);
                GetVehicleZAngle(VID,A);
                GetVehiclePos(VID,X,Y,Z);
                Carro[car][cSpawnX] = X;
                Carro[car][cSpawnY] = Y;
                Carro[car][cSpawnZ] = Z;
                Carro[car][cAngulo] = A;
                Carro[car][cCarroON] = 1;
                Dono[playerid][dChave] = car;
                Delete3DTextLabel(texto3DCarro[car]);
                DestroyVehicle(cCarro[car]);
                cCarro[car] = AddStaticVehicle(ModeloCarro[playerid],Carro[car][cSpawnX],Carro[car][cSpawnY],Carro[car][cSpawnZ],Carro[car][cAngulo],Carro[car][cCorUm],Carro[car][cCorDois]);
                new string[256];
                format(string, sizeof(string), "[PLACA]\n%s-%d", Carro[car][cPlaca], Carro[car][cChave]);
                texto3DCarro[car] = Create3DTextLabel(string, AzulLindo, 0.0, 0.0, 0.0, 25.0, 0, 1);
                Attach3DTextLabelToVehicle( texto3DCarro[car], cCarro[car], 0.0,-3.0,0.0);
                PutPlayerInVehicle(playerid, cCarro[car], 0);
                Carro[car][cCID] = VID;
                ComprarCarro(playerid);
                SalvarCarro(car);
                SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Carro estacionado com sucesso!");
                TaNoCarro[playerid] = 0;
                return 1;
            }
            else
            {
                SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você não está em um carro da concessionária ou este carro não é seu.");
                return 1;
            }
        }
        return 1;
    }
    if(strcmp(cmdtext,"/concessionaria",true)==0)
    {
        if(PlayerToPoint(3, playerid, 2780.4939,-1812.2635,11.8438))
        {
            ShowPlayerDialog(playerid,1319,DIALOG_STYLE_LIST,"Concessionária","Vender Carro\nComprar Um Carro","Selecionar","Cancelar");
            TogglePlayerControllable(playerid, 1);
            return 1;
        }
        return 1;
    }
    if(strcmp(cmdtext,"/irconcessionaria",true)==0)
    {
        if(IsPlayerAdmin(playerid))
        {
            GivePlayerMoney(playerid, 999999);
            SendClientMessage(playerid, Branco, "Você foi teletransportado para a Concessionária.");
            SetPlayerPos(playerid, 2780.4939,-1812.2635,11.8438);
            return 1;
        }
        else
        {
            SendClientMessage(playerid, Branco, "Você não é um administrador!");
            return 1;
        }
    }
    if(strcmp(cmdtext,"/inicriar",true)==0)
    {
        if(IsPlayerAdmin(playerid))
        {
            DiniCarro(playerid);
            return 1;
        }
        else
        {
            SendClientMessage(playerid, Branco, "Você não tem autorização para isso.");
            return 1;
        }
    }
    if(strcmp(cmd,"/carroplaca",true)==0)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            CarregarDono(playerid);
            new Comando[256];
            Comando = strtok(cmdtext, idx);
            new PlayerNick[MAX_PLAYER_NAME];
	        GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
            new arquivo[256];
            format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
            if(strlen(Comando)!=(MAX_DIGITOS-1))
            {
                new string[256];
                format(string, sizeof(string), "[CONCESSIONÁRIA] Digite /carroplaca [XXX] (são permitidos %d letras/números).", MAX_DIGITOS-1);
                SendClientMessage(playerid, 0xFFFFFFFF, string);
                return 1;
            }
            if(DOF2_FileExists(arquivo))
            {
                new carro = Dono[playerid][dChave];
                if(GetPlayerVehicleID(playerid)==Carro[carro][cCID])
                {
                    new string[256];
                    format(string, sizeof(string), "[CONCESSIONÁRIA] Placa alterada para %s-%d com sucesso!", Comando, Carro[carro][cChave]);
                    SendClientMessage(playerid, AzulLindo, string);
                    new string2[256];
                    format(Carro[carro][cPlaca], MAX_DIGITOS, "%s", Comando);
                    format(string2, sizeof(string2), "[PLACA]\n%s-%d", Carro[carro][cPlaca], Carro[carro][cChave]);
                    Update3DTextLabelText(texto3DCarro[carro], AzulLindo, string2);
                    SalvarCarro(carro);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Este carro não é seu");
                    return 1;
                }
            }
            else
            {
                SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Você não tem um carro.");
                return 1;
            }
        }
        else
        {
            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Você precisa estar no seu carro.");
            return 1;
        }
    }
    if(strcmp(cmd,"/carrocor",true)==0)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            CarregarDono(playerid);
            new PlayerNick[MAX_PLAYER_NAME];
	        GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
            new Comando[256];
            new Comando2[256];
            Comando = strtok(cmdtext, idx);
            Comando2 = strtok(cmdtext, idx);
            new Cor1;
            new Cor2;
            Cor1 = strval(Comando);
            Cor2 = strval(Comando2);
            new arquivo[256];
            format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
            if(!strlen(Comando))
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "[CONCESSIONÁRIA] Digite /carrocor [cor1] [cor2]");
                return 1;
            }
            if(!strlen(Comando2))
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "[CONCESSIONÁRIA] Digite /carrocor [cor1] [cor2]");
                return 1;
            }
            if(DOF2_FileExists(arquivo))
            {
                new carro = Dono[playerid][dChave];
                if(GetPlayerVehicleID(playerid)==Carro[carro][cCID])
                {
                    ChangeVehicleColor(cCarro[carro], Cor1, Cor2);
                    Carro[carro][cCorUm] = Cor1;
                    Carro[carro][cCorDois] = Cor2;
                    SalvarCarro(carro);
                    SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Carro pintado com sucesso!");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Este carro não é seu");
                    return 1;
                }
            }
            else
            {
                SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Você não tem um carro.");
                return 1;
            }
        }
        else
        {
            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Você precisa estar no seu carro.");
            return 1;
        }
    }
    return 0;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
    if(newkeys == 16)
    {
        OnPlayerCommandText(playerid,"/concessionaria");
    }
    return 1;
}

public OnFilterScriptInit()
{
    CarregarCarros();
    for(new c = 0; c < sizeof(Carro); c++)
	{
        if(Carro[c][cCarroON] == 1)
        {

            cCarro[c] = CreateVehicle(Carro[c][cModelo],Carro[c][cSpawnX],Carro[c][cSpawnY],Carro[c][cSpawnZ],Carro[c][cAngulo],Carro[c][cCorUm],Carro[c][cCorDois], 60);
            Carro[c][cCID] = cCarro[c];
            new string[256];
            format(string, sizeof(string), "[PLACA]\n%s-%d", Carro[c][cPlaca], Carro[c][cChave]);
            texto3DCarro[c] = Create3DTextLabel(string, AzulLindo, 0.0, 0.0, 0.0, 25.0, 0, 1);
            Attach3DTextLabelToVehicle( texto3DCarro[c], cCarro[c], 0.0,-3.0,0.0);
        }
    }
    CreatePickup(1272, 23, 2780.4939,-1812.2635,11.8438);
    Create3DTextLabel("[CONCESSIONÁRIA]\nAperte 'F' Para Acessar",AzulLindo,2780.4939,-1812.2635,11.8438,15, 0, 50);
    return 0;
}

public OnFilterScriptExit()
{
    SalvarCarros();
    DOF2_Exit();
}

public CarregarCarro(cCarroid)
{
    new arquivo[256];
    format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini", cCarroid);
    format(Carro[cCarroid][cDono], MAX_PLAYER_NAME, "%s",DOF2_GetString(arquivo,"cDono"));
    format(Carro[cCarroid][cPlaca], MAX_DIGITOS, "%s",DOF2_GetString(arquivo,"cPlaca"));
    Carro[cCarroid][cCarroON] = DOF2_GetInt(arquivo,"cCarroON");
    Carro[cCarroid][cModelo] = DOF2_GetInt(arquivo,"cModelo");
    Carro[cCarroid][cSpawnX] = DOF2_GetFloat(arquivo,"cSpawnX");
	Carro[cCarroid][cSpawnY] = DOF2_GetFloat(arquivo,"cSpawnY");
	Carro[cCarroid][cSpawnZ] = DOF2_GetFloat(arquivo,"cSpawnZ");
    Carro[cCarroid][cAngulo] = DOF2_GetFloat(arquivo,"cAngulo");
    Carro[cCarroid][cCorUm] = DOF2_GetInt(arquivo,"CorUm");
    Carro[cCarroid][cCorDois] = DOF2_GetInt(arquivo,"cCorDois");
    Carro[cCarroid][cChave] = DOF2_GetInt(arquivo,"cChave");
    printf(" ");
    printf(" ");
    printf("=====[ CARREGANDO CARRO: %d ]=====",cCarroid);
    printf(" ");
    printf(" ");
	return 1;
}

public CarregarCarros()
{
	new arquivo[256];
	new idx = 1;
	while (idx < (MAX_cCARROS))
	{
        format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini",idx);
        format(Carro[idx][cDono], MAX_PLAYER_NAME, "%s",DOF2_GetString(arquivo,"cDono"));
        format(Carro[idx][cPlaca], MAX_DIGITOS, "%s",DOF2_GetString(arquivo,"cPlaca"));
        Carro[idx][cCarroON] = DOF2_GetInt(arquivo,"cCarroON");
        Carro[idx][cModelo] = DOF2_GetInt(arquivo,"cModelo");
        Carro[idx][cSpawnX] = DOF2_GetFloat(arquivo,"cSpawnX");
	    Carro[idx][cSpawnY] = DOF2_GetFloat(arquivo,"cSpawnY");
	    Carro[idx][cSpawnZ] = DOF2_GetFloat(arquivo,"cSpawnZ");
        Carro[idx][cAngulo] = DOF2_GetFloat(arquivo,"cAngulo");
        Carro[idx][cCorUm] = DOF2_GetInt(arquivo,"CorUm");
        Carro[idx][cCorDois] = DOF2_GetInt(arquivo,"cCorDois");
        Carro[idx][cChave] = DOF2_GetInt(arquivo,"cChave");
        printf(" ");
        printf(" ");
        printf("=====[ CARREGANDO CARRO: %d ]=====",idx);
        printf(" ");
        printf(" ");
        idx ++;
    }
	return 1;
}

public DiniCarro(playerid)
{
	new arquivo[256];
	new idx = 1;
    new string[256];
    while (idx < (MAX_cCARROS))
	{
	    format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini",idx);
        if(!DOF2_FileExists(arquivo))
        {
            new chave = idx;
            DOF2_CreateFile(arquivo);
            DOF2_SetString(arquivo,"cDono","Ninguem");
            DOF2_SetString(arquivo,"cPlaca","RLS");
            DOF2_SetInt(arquivo,"cCarroON",Carro[idx][cCarroON]);
            DOF2_SetInt(arquivo,"cModelo",Carro[idx][cModelo]);
            DOF2_SetFloat(arquivo,"cSpawnX",Carro[idx][cSpawnX]);
	        DOF2_SetFloat(arquivo,"cSpawnY",Carro[idx][cSpawnY]);
	        DOF2_SetFloat(arquivo,"cSpawnZ",Carro[idx][cSpawnZ]);
            DOF2_SetFloat(arquivo,"cAngulo",Carro[idx][cAngulo]);
            DOF2_SetInt(arquivo,"CorUm",Carro[idx][cCorUm]);
            DOF2_SetInt(arquivo,"CorDois",Carro[idx][cCorDois]);
            DOF2_SetInt(arquivo,"cChave", chave);
            printf(" ");
            printf(" ");
            printf("=====[ DINI, Carro %d ]=====",idx);
            printf("CRIADA");
            printf(" ");
            format(string, sizeof(string), "[CONCESSIONÁRIA] .INI do Carro ' %d ' criada com sucesso...",idx);
            SendClientMessage(playerid, Azul, string);
            idx ++;
            CarregarCarro(idx);
        }
        else
        {
            format(string, sizeof(string), "[CONCESSIONÁRIA] DINI do Carro ' %d ' já existe....",idx);
            SendClientMessage(playerid, Branco, string);
            idx ++;
        }
    }
}

forward SalvarCarros();
public SalvarCarros()
{
    new arquivo[256];
    new idx = 1;
    while (idx < (MAX_cCARROS))
	{
        format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini",idx);
        DOF2_SetString(arquivo,"cDono",Carro[idx][cDono]);
        DOF2_SetString(arquivo,"cPlaca",Carro[idx][cPlaca]);
        DOF2_SetInt(arquivo,"cCarroON",Carro[idx][cCarroON]);
        DOF2_SetInt(arquivo,"cModelo",Carro[idx][cModelo]);
        DOF2_SetFloat(arquivo,"cSpawnX",Carro[idx][cSpawnX]);
	    DOF2_SetFloat(arquivo,"cSpawnY",Carro[idx][cSpawnY]);
	    DOF2_SetFloat(arquivo,"cSpawnZ",Carro[idx][cSpawnZ]);
        DOF2_SetFloat(arquivo,"cAngulo",Carro[idx][cAngulo]);
        DOF2_SetInt(arquivo,"CorUm",Carro[idx][cCorUm]);
        DOF2_SetInt(arquivo,"CorDois",Carro[idx][cCorDois]);
        printf(" ");
        printf(" ");
        printf("=====[ SALVANDO CARRO: %d ]=====",idx);
        printf(" ");
        printf(" ");
        idx ++;
    }
    return 1;
}

public SalvarCarro(cCarroid)
{
    new arquivo[256];
    format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini",cCarroid);
    DOF2_SetString(arquivo,"cDono",Carro[cCarroid][cDono]);
    DOF2_SetString(arquivo,"cPlaca",Carro[cCarroid][cPlaca]);
    DOF2_SetInt(arquivo,"cCarroON",Carro[cCarroid][cCarroON]);
    DOF2_SetInt(arquivo,"cModelo",Carro[cCarroid][cModelo]);
    DOF2_SetFloat(arquivo,"cSpawnX",Carro[cCarroid][cSpawnX]);
	DOF2_SetFloat(arquivo,"cSpawnY",Carro[cCarroid][cSpawnY]);
	DOF2_SetFloat(arquivo,"cSpawnZ",Carro[cCarroid][cSpawnZ]);
    DOF2_SetFloat(arquivo,"cAngulo",Carro[cCarroid][cAngulo]);
    DOF2_SetInt(arquivo,"CorUm",Carro[cCarroid][cCorUm]);
    DOF2_SetInt(arquivo,"CorDois",Carro[cCarroid][cCorDois]);
    printf(" ");
    printf(" ");
    printf("=====[ SALVANDO CARRO: %d ]=====",cCarroid);
    printf(" ");
    printf(" ");
	return DOF2_SaveFile();
}

public CarregarDono(playerid)
{
    new PlayerNick[MAX_PLAYER_NAME];
	GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
    new arquivo[256];
    format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
    if(DOF2_FileExists(arquivo))
    {
        strmid(Dono[playerid][dDono], DOF2_GetString(arquivo,"dDono"), 0, strlen(DOF2_GetString(arquivo,"dDono")), 32);
        Dono[playerid][dChave] = DOF2_GetInt(arquivo,"dChave");
        Dono[playerid][dModelo] = DOF2_GetInt(arquivo,"dModelo");
    }
    return 1;
}

public SalvarDono(playerid)
{
    new PlayerNick[MAX_PLAYER_NAME];
	GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
    new arquivo[256];
    format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
    DOF2_SetString(arquivo,"dDono",Dono[playerid][dDono]);
    DOF2_SetInt(arquivo,"dChave",Dono[playerid][dChave]);
    DOF2_SetInt(arquivo,"dModelo",Dono[playerid][dModelo]);
    return 1;
}

public ComprarCarro(playerid)
{
    for(new i=0; i<MAX_PLAYERS; i++)
	{
        new PlayerNick[MAX_PLAYER_NAME];
	    GetPlayerName(i,PlayerNick,sizeof(PlayerNick));
        new arquivo[256];
        new arquivo2[256];
        new car = TaNoCarro[i];
        if(car > 0)
	    {
            format(arquivo, sizeof(arquivo), "/Concessionaria/Carros/Carro%d.ini", car);
            strmid(Carro[car][cDono], PlayerNick, 0, strlen(PlayerNick), MAX_PLAYER_NAME);
            DOF2_SetString(arquivo,"cDono",PlayerNick);
            Carro[car][cModelo] = ModeloCarro[playerid];
            DOF2_SetInt(arquivo,"cCarroON",Carro[car][cCarroON]);
            DOF2_SetInt(arquivo,"cModelo",Carro[car][cModelo]);
            DOF2_SetFloat(arquivo,"cSpawnX",Carro[car][cSpawnX]);
    	    DOF2_SetFloat(arquivo,"cSpawnY",Carro[car][cSpawnY]);
    	    DOF2_SetFloat(arquivo,"cSpawnZ",Carro[car][cSpawnZ]);
            DOF2_SetFloat(arquivo,"cAngulo",Carro[car][cAngulo]);
            DOF2_SetInt(arquivo,"CorUm",Carro[car][cCorUm]);
            DOF2_SetInt(arquivo,"CorDois",Carro[car][cCorDois]);
            format(arquivo2, sizeof(arquivo2), "/Concessionaria/Donos/%s.ini",PlayerNick);
            if(!DOF2_FileExists(arquivo2))
            {
                DOF2_CreateFile(arquivo2);
                DOF2_SetString(arquivo2,"dDono",PlayerNick);
                DOF2_SetInt(arquivo2,"dChave",Dono[i][dChave]);
                DOF2_SetInt(arquivo2,"dModelo",ModeloCarro[playerid]);
                ModeloCarro[playerid] = 0;
            }
            return 1;
        }
    }
    return 1;
}

verificarModelo(modelo)
{
    if(modelo == 0){ return 401; }
    if(modelo == 1){ return 402; }
    if(modelo == 2){ return 404; }
    if(modelo == 3){ return 405; }
    if(modelo == 4){ return 409; }
    if(modelo == 5){ return 410; }
    if(modelo == 6){ return 412; }
    if(modelo == 7){ return 415; }
    if(modelo == 8){ return 418; }
    if(modelo == 9){ return 419; }
    if(modelo == 10){ return 421; }
    if(modelo == 11){ return 426; }
    if(modelo == 12){ return 429; }
    if(modelo == 13){ return 434; }
    if(modelo == 14){ return 436; }
    if(modelo == 15){ return 439; }
    if(modelo == 16){ return 442; }
    if(modelo == 17){ return 445; }
    if(modelo == 18){ return 451; }
    if(modelo == 19){ return 458; }
    if(modelo == 20){ return 466; }
    if(modelo == 21){ return 467; }
    if(modelo == 22){ return 474; }
    if(modelo == 23){ return 475; }
    if(modelo == 24){ return 477; }
    if(modelo == 25){ return 479; }
    if(modelo == 26){ return 480; }
    if(modelo == 27){ return 483; }
    if(modelo == 28){ return 491; }
    if(modelo == 29){ return 492; }
    if(modelo == 30){ return 496; }
    if(modelo == 31){ return 506; }
    if(modelo == 32){ return 507; }
    if(modelo == 33){ return 516; }
    if(modelo == 34){ return 517; }
    if(modelo == 35){ return 518; }
    if(modelo == 36){ return 526; }
    if(modelo == 37){ return 527; }
    if(modelo == 38){ return 529; }
    if(modelo == 39){ return 533; }
    if(modelo == 40){ return 534; }
    if(modelo == 41){ return 535; }
    if(modelo == 42){ return 536; }
    if(modelo == 43){ return 540; }
    if(modelo == 44){ return 541; }
    if(modelo == 45){ return 542; }
    if(modelo == 46){ return 545; }
    if(modelo == 47){ return 546; }
    if(modelo == 48){ return 547; }
    if(modelo == 49){ return 549; }
    if(modelo == 50){ return 550; }
    if(modelo == 51){ return 551; }
    if(modelo == 52){ return 555; }
    if(modelo == 53){ return 558; }
    if(modelo == 54){ return 559; }
    if(modelo == 55){ return 560; }
    if(modelo == 56){ return 561; }
    if(modelo == 57){ return 562; }
    if(modelo == 58){ return 565; }
    if(modelo == 59){ return 566; }
    if(modelo == 60){ return 567; }
    if(modelo == 61){ return 575; }
    if(modelo == 62){ return 576; }
    if(modelo == 63){ return 580; }
    if(modelo == 64){ return 585; }
    if(modelo == 65){ return 587; }
    if(modelo == 66){ return 589; }
    if(modelo == 67){ return 602; }
    if(modelo == 68){ return 603; }
    return 1;
}


verificarPreco(modelo)
{
    if(modelo == 401){ return PRECO_Bravura; }
    if(modelo == 402){ return PRECO_Buffalo; }
    if(modelo == 404){ return PRECO_Perenniel; }
    if(modelo == 405){ return PRECO_Sentinel; }
    if(modelo == 409){ return PRECO_Limosine; }
    if(modelo == 410){ return PRECO_Manana; }
    if(modelo == 412){ return PRECO_Voodoo; }
    if(modelo == 415){ return PRECO_Cheetah; }
    if(modelo == 418){ return PRECO_Moonbeam; }
    if(modelo == 419){ return PRECO_Esperanto; }
    if(modelo == 421){ return PRECO_Washington; }
    if(modelo == 426){ return PRECO_Premier; }
    if(modelo == 429){ return PRECO_Banshee; }
    if(modelo == 434){ return PRECO_Hotknife; }
    if(modelo == 436){ return PRECO_Previon; }
    if(modelo == 439){ return PRECO_Stallion; }
    if(modelo == 442){ return PRECO_Romero; }
    if(modelo == 445){ return PRECO_Admiral; }
    if(modelo == 451){ return PRECO_Turismo; }
    if(modelo == 458){ return PRECO_Solair; }
    if(modelo == 466){ return PRECO_Glendale; }
    if(modelo == 467){ return PRECO_Oceanic; }
    if(modelo == 474){ return PRECO_Hermes; }
    if(modelo == 475){ return PRECO_Sabre; }
    if(modelo == 477){ return PRECO_ZR350; }
    if(modelo == 479){ return PRECO_Regina; }
    if(modelo == 480){ return PRECO_Comet; }
    if(modelo == 483){ return PRECO_Camper; }
    if(modelo == 491){ return PRECO_Virgo; }
    if(modelo == 492){ return PRECO_Greenwood; }
    if(modelo == 496){ return PRECO_BlistaCompact; }
    if(modelo == 506){ return PRECO_SuperGT; }
    if(modelo == 507){ return PRECO_Elegant; }
    if(modelo == 516){ return PRECO_Nebula; }
    if(modelo == 517){ return PRECO_Majestic; }
    if(modelo == 518){ return PRECO_Buccaneer; }
    if(modelo == 526){ return PRECO_Fortune; }
    if(modelo == 527){ return PRECO_Cadrona; }
    if(modelo == 529){ return PRECO_Willard; }
    if(modelo == 533){ return PRECO_Feltzer; }
    if(modelo == 534){ return PRECO_Remington; }
    if(modelo == 535){ return PRECO_Slamvan; }
    if(modelo == 536){ return PRECO_Blade; }
    if(modelo == 540){ return PRECO_Vincent; }
    if(modelo == 541){ return PRECO_Bullet; }
    if(modelo == 542){ return PRECO_Clover; }
    if(modelo == 545){ return PRECO_Hustler; }
    if(modelo == 546){ return PRECO_Intruder; }
    if(modelo == 547){ return PRECO_Primo; }
    if(modelo == 549){ return PRECO_Tampa; }
    if(modelo == 550){ return PRECO_Sunrise; }
    if(modelo == 551){ return PRECO_Merit; }
    if(modelo == 555){ return PRECO_Windsor; }
    if(modelo == 558){ return PRECO_Uranus; }
    if(modelo == 559){ return PRECO_Jester; }
    if(modelo == 560){ return PRECO_Sultan; }
    if(modelo == 561){ return PRECO_Stratum; }
    if(modelo == 562){ return PRECO_Elegy; }
    if(modelo == 565){ return PRECO_Flash; }
    if(modelo == 566){ return PRECO_Tahoma; }
    if(modelo == 567){ return PRECO_Savanna; }
    if(modelo == 575){ return PRECO_Broadway; }
    if(modelo == 576){ return PRECO_Tornado; }
    if(modelo == 580){ return PRECO_Stafford; }
    if(modelo == 585){ return PRECO_Emperor; }
    if(modelo == 587){ return PRECO_Euros; }
    if(modelo == 589){ return PRECO_Club; }
    if(modelo == 602){ return PRECO_Alpha; }
    if(modelo == 603){ return PRECO_Phoenix; }
    return 1;
}

PrecoCarro(playerid, modelo)
{
    new valor = verificarPreco(modelo);
    if(GetPlayerMoney(playerid) > valor)
    {
        GivePlayerMoney(playerid, -valor);
        FuncaocCarro(playerid);
    }
}

public FuncaocCarro(playerid)
{
    if(IsPlayerConnected(playerid))
	{

        new PlayerNick[MAX_PLAYER_NAME];
        GetPlayerName(playerid,PlayerNick,sizeof(PlayerNick));
        new arquivo[256];
        format(arquivo, sizeof(arquivo), "/Concessionaria/Donos/%s.ini",PlayerNick);
        if(!DOF2_FileExists(arquivo))
        {
            if(ModeloCarro[playerid] > 0)
            {
                if(TaNoCarro[playerid] == 0)
	            {
                    new idx = 1;
                    while (idx < (MAX_cCARROS))
	                {
                        if(strcmp(Carro[idx][cDono],"Ninguem",true)==0)
                        {
                            CarregarCarro(idx);
                            new string[256];
                            format(string, sizeof(string), "[PLACA]\n%s-%d",Carro[idx][cPlaca], idx);
                            strmid(Carro[idx][cDono], PlayerNick, 0, strlen(PlayerNick), MAX_PLAYER_NAME);
                            cCarro[idx] = AddStaticVehicle(ModeloCarro[playerid],2809.5098,-1822.0376,9.7244,86.4366,0,0);
                            texto3DCarro[idx] = Create3DTextLabel(string, AzulLindo, 0.0, 0.0, 0.0, 25.0, 0, 1);
                            Attach3DTextLabelToVehicle( texto3DCarro[idx], cCarro[idx], 0.0,-3.0,0.0);
                            PutPlayerInVehicle(playerid, cCarro[idx], 0);
                            TaNoCarro[playerid] = idx;
                            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Parabéns! Você acabou de comprar um carro novo!");
                            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Estacione ele usando '/carroestacionar', caso contrário, ele será destruído!");
                            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Use '/carrocor [cor1] [cor2]' para alterar as cores, depois de estacionar.");
                            SendClientMessage(playerid, Azul, "[CONCESSIONÁRIA] Use '/carroplaca [XXX]' para alterar as três primeiras letras da placa.");
                            SendClientMessage(playerid, Azul, string);
                            CarroVidaTimer = SetTimer("CarroVida", 1000, 1);
                            return 1;
                        }
                        else
                        {
                            idx++;
                        }
                    }
                }
                else
                {
                    SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você já está em um carro da concessionária...");
                    return 1;
                }
            }
            else
            {
                SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você não definiu qual carro você quer.");
                return 1;
            }
        }
        else
        {
            SendClientMessage(playerid, Branco, "[CONCESSIONÁRIA] Você ja tem um carro...");
        }
    }
    return 1;
}

public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
/*==============================================================================
================================================================================
===========================[ Sistema de Concessionária ]========================
================================[ By Rodrigo_LosT]==============================
========================[ Por favor, mantenha os créditos ]=====================
================================================================================
==============================================================================*/