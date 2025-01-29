/*
		  Data de Inicio do Game Mode: 22/04/2016
        Fim da Versão 1.0 do Game Mode: 00/00/0000
			   	  Feito por  Marola
		        	Game Mode GTB
 © Copyright - GTB Torcidas - Todos os direitos reservados.
				www.equipegtb.com
*/

// ================= [ Includes ] ================= //
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <a_mysql>
#include <Losgs>

#define         TIMER_FIX_PERFORMANCE_CHECKS        false
#include        <timerfix>

/*-----------------------------------------------------------------------------------------------------------------
|             1 - Los Santos                                                                                      |
|             2 - San Fierro                                                                                      |
|             3 - Las Venturas                                                                                    |
|------------------------------------------------------------------------------------------------------------------*/
#define         LHOUSE_CITY                     1

/*-----------------------------------------------------------------------------------------------------------------
|             1 - Teletransporta o player quando comprar o carro                                                  |
|             2 - Envia mensagem com a localização do carro                                                       |
|------------------------------------------------------------------------------------------------------------------*/
#define         LHOUSE_DELIVERY_METHOD          1

/*-----------------------------------------------------------------------------------------------------------------
|             ID da tecla que ao ser pressionada perto do carro, irá ativar/desativar o alarme                    |
|                               Por padrão a tecla é Y (65536)                                                    |
|------------------------------------------------------------------------------------------------------------------*/
#define         ALARM_KEY                       65536

/*-----------------------------------------------------------------------------------------------------------------
|             Número máximo de coletes que podem ser armazenados em cada casa                                     |
|                               Por padrão: 5                                                                     |
|------------------------------------------------------------------------------------------------------------------*/
#define         MAX_ARMOUR                      5

//=====================  [DIALOGS] ==========================//
#define         DIALOG_CREATE_HOUSE             500
#define         DIALOG_CAR_MODELS_CHANGE        501
#define         DIALOG_CAR_MENU                 502
#define         DIALOG_CAR_PARK                 503
#define         DIALOG_CAR_COLOR_1              504
#define         DIALOG_VEHICLES_MODELS          505
#define         DIALOG_SELL_CAR                 506
#define         DIALOG_HOUSE_STATUS             507
#define         DIALOG_SELL_HOUSE               508
#define         DIALOG_CHANGE_HOUSE_SPAWN       509
#define         DIALOG_EDIT_HOUSE               510
#define         DIALOG_EDIT_HOUSE_PRICE         511
#define         DIALOG_EDIT_HOUSE_RENT_PRICE    512
#define         DIALOG_EDIT_HOUSE_INT           513
#define         DIALOG_EDIT_HOUSE_ID            514
#define         DIALOG_HOUSE_TENANT_MENU        515
#define         DIALOG_HOUSE_RENT_MENU          516
#define         DIALOG_HOUSE_OWNER_MENU         560
#define         DIALOG_HOUSE_SELL_MENU          550
#define         DIALOG_RENT                     610
#define         DIALOG_RENT_PRICE               570
#define         DIALOG_HOUSE_SELL_PLAYER        580
#define         DIALOG_HOUSE_SELL_PLAYER2       590
#define         DIALOG_HOUSE_SELL_PLAYER3       600
#define         DIALOG_SELLING_CONFIRM          514
#define         DIALOG_CHANGE_PLATE             620
#define         DIALOG_STORAGE_HOUSE            516
#define         DIALOG_DELETE_HOUSE             517
#define         DIALOG_CHANGE_OWNER             518
#define         DIALOG_CHANGE_OWNER2            519
#define         DIALOG_ADMIN                    520
#define         DIALOG_SELL_HOUSE_ADMIN         521
#define         DIALOG_GUEST                    522
#define         DIALOG_CAR_MODELS_CREATED       533
#define         DIALOG_RENT_CONFIRM             524
#define         DIALOG_DUMP_TENANT              525
#define         DIALOG_UNRENT_CONFIRM           526
#define         DIALOG_RENTING_GUEST            527
#define         DIALOG_HOUSE_TITLE              528
#define         DIALOG_HOUSE_TITLE_ADMIN        529
#define         DIALOG_CAR_COLOR_2              530
#define         DIALOG_STORAGE_ARMOUR           531

//======================== [CORES] ==============================//
#define         COLOR_WARNING					0xf14545ff
#define         COLOR_ERROR						0xf14545ff
#define         COLOR_SUCCESS					0x88aa62ff
#define         COLOR_INFO						0xA9C4E4ff

//======================== [DEFINES] ===========================//
#define         TEXT_SELLING_HOUSE              "- {5CFFC8} CASA A VENDA {FFFFFF} -\n{FFFF5C}Preço: {F6F6F6}$%d\n{FFFF5C}Número: {F6F6F6}%d"
#define         TEXT_HOUSE                      "{46FE00}%s\n\n{FFFF5C}Dono da Casa: {F6F6F6}%s\n{FFFF5C}Aluguel: {F6F6F6}%s\n{FFFF5C}Status: {F6F6F6}%s\n{FFFF5C}Número: {F6F6F6}%d"
#define         TEXT_RENT_HOUSE                 "{46FE00}%s\n\n{FFFF5C}Dono da Casa: {F6F6F6}%s\n{FFFF5C}Locador: {F6F6F6}%s\n{FFFF5C}Preço Aluguel: {F6F6F6}$%d\n{FFFF5C}Status: {F6F6F6}%s\n{FFFF5C}Número: {F6F6F6}%d"

#define         MAX_HOUSES                      500

#define         LOG_HOUSES                      "LHouse/Logs/Casas.log"
#define         LOG_VEHICLES                    "LHouse/Logs/Carros.log"
#define         LOG_ADMIN                       "LHouse/Logs/Administração.log"
#define         LOG_SYSTEM                      "LHouse/Logs/Sistema.log"

// ================= [ Ant Double Player ] ================= //
#define loop(%0,%1) for(new %0; %0 < %1; ++%0)
#define Kick(%0) SetTimerEx("Kicka", 100, false, "i", %0)

// ================= [ Defines ] =================== //
#define DIALOG_INICIO 				1
#define DIALOG_REGISTRO 			2
#define DIALOG_REGISTRO_EMAIL 		3
#define DIALOG_LOGIN 				4
#define DIALOG_NICK_EM_USO          5
#define DIALOG_ENQUETE     			6
#define DIALOG_RADIO 				7
#define DIALOG_CREDITOS 			8
#define DIALOG_CASH         		9
#define DIALOG_CASHS        		10
#define DIALOG_CASH1        		11
#define DIALOG_CASH2        		12
#define DIALOG_CASH3        		13
#define DIALOG_CASH4        		14
#define DIALOG_CASH5        		15
#define DIALOG_VEH          		16
#define DIALOG_VEHVIP       		17
#define DIALOG_ARMAS        		18
#define DIALOG_CONFIG       		19
#define DialogoTransferirCash       20
#define DialogoTransferirCash2      21
#define DIALOG_REGRAS               22
#define DIALOG_REGRAS2              23
#define DIALOG_REGRAS3              24
#define DIALOG_REGRAS4              25
#define DIALOG_REGRAS5              26
#define DIALOG_REGRAS6              27
#define DIALOG_REGRAS7              28
#define DIALOG_TORCIDA              29
#define DIALOG_TORCIDAS             30
#define DIALOG_SF                   31
#define DIALOG_LS                   32
#define DIALOG_LV                   33
#define DIALOG_ESTADOS              34
#define DIALOG_MOCHILA              35
#define DIALOG_MENUSEDE             36
#define DIALOG_HQ                   37
#define DIALOG_EQUIPAR              38
#define DIALOG_VENC_VIP     		39
#define DIALOG_COMANDOS_VIP     	40
#define DIALOG_EFECTS     			41
#define DIALOG_TOYS     			42
#define DIALOG_ENABLE_KEY 			43
#define DIALOG_NEW_KEY				44
#define DIALOG_NEW_KEY_LEVEL		45
#define DIALOG_NEW_KEY_DAYS 		46
#define DIALOG_KEY_CONFIRM 			47
#define DIALOG_REMOVE_KEY			48
#define DIALOG_VIPS                 49
#define DIALOG_TEMPO                50
#define MAX_TORCIDAS 				51 // Quando for adicionar uma torcida, aumente em +1.
#define DIALOG_MESSAGE              51
#define ADMIN_SPEC_TYPE_NONE        52
#define ADMIN_SPEC_TYPE_PLAYER      53
#define ADMIN_SPEC_TYPE_VEHICLE     54
#define DIALOG_TUNAR                55
#define PINTARV                     56
#define DIALOG_RODAS                57
#define DIALOG_AJUDA                58
#define DIALOG_CONTA                59
#define ANUNCIAR                    60
#define CIDADELS                    61
#define CIDADESF                    62
#define CIDADELV                    63

// ================= [ Cores ] ================= //
#define COR_VERMELHO 	0xFF0000FF
#define COR_AMARELO     0xFFFF00FF
#define COR_ROXO 	 	0xC798FAAA
#define COR_BRANCO   	0xFFFFFFFF
#define COR_ERRO     	0xFF0000FF
#define COR_REPORTER 	0xFF9900AA
#define COR_LARANJA  	0xFF9900AA
#define COR_PRINCIPAL 	0x0088FFFF
#define COR_USOCORRETO  0x0000EEFF
#define COR_NEGATIVO    0xFF7777FF
#define COR_UPC 		0xAA3333AA
#define COR_DPA 		0x3737FF96
#define COR_TVP 		0xAFAFAFAA
#define COR_PCA 		0x33AA33AA
#define COR_PC 			0xFF0000FF
#define COR_MPC 		0x800080AA
#define COR_UAS 		0xD2FFD296
#define COR_LDA    		0x87CEFFAA
#define COR_LDB 		0xFFFF00AA
#define COR_PDA 		0x80800096
#define COR_CRF         0xFF6666AA
#define COR_TDF         0xFFD700AA
#define COR_ALQ         0x008B8BAA
#define COR_ADMIN       0x3333FF96
#define COR_VIP         0xEEC900FF
#define COR_VERDE		0x33AA33AA
#define COR_BOPE        0x363636FF
#define COR_CHOQUE      0xA9A9A9FF
#define OURO            0xEEC900FF
#define PRATA 			0x9C9C9CFF
#define BRONZE 			0x8B5A2BFF
#define COR_PORTAO      0x909596FF
#define TireDano(%1,%2,%3,%4) %1 | (%2 << 1) | (%3 << 2) | (%4 << 3)

// ================= [ Conectar DB ] ==================== //
#define mysql_host "127.0.0.1" //IP DB;
#define mysql_user "root" //USER DB;
#define mysql_password "" //PASSWORD DB;
#define mysql_database "dbgtb" //NAME DB;

// ================ [ Conectar DB VIP ] =============== //
#define Host_Connection 		"127.0.0.1"
#define Host_User         		"root"
#define Host_DB           		"vips"
#define Host_Password     		""

// ================= [ Enum ] ================= //
enum pInfo
{
	pAdmin,
	pPres,
	pvPres,
	pOrg,
	pPux,
	pHelper,
	pReporter,
	pBope,
	pChoque,
	sutotal,
	suabatidos,
	Cash,
	Dinheiro,
	pMatou,
	pMorreu,
	Passagens,
	Procurado,
	Cone,
	pBarreira,
	Grade,
	bool:BlockTR,
	bool:BlockIR,
	bool:BlockPM,
	bool:CityAdmin,
	bool:EmTrabalho,
    bool:DelayAsay,
    bool:DelayReport,
    Kicked,
	pIniciante,
	pSkin,
	pTorcida,
	bool:GPS_Torcidas,
	bool:ChatTorcida,
	Score,
	pSinalizadores,
	pFogos,
	pCocaina,
	pMaconha,
	pMP3,
	pMateriais,
	TempoPreso,
	bool:NoHospital,
	Vip,
	DiasVip,
	TempoVip,
	vKey[25],
	vDias,
	vNivel,
	bool:PegouKit,
	gSpectateID,
	gSpectateType,
	LastReport,
	pRpt,
	bool:ReloadPlayer,
	bool:InDuel,
	DuelInvite,
	DuelID,
	Camisas,
	Bermudas,
	BermudasPerdida,
	BermudasTomada,
	PanosTomado,
	PanosPerdido,
	DuelInviteType,
	DuelInviteTypeArmour,
	Wanted,
	Float:LastPos[3]
};

enum t_info
{
	tNome[64],
	Sigla[6],
	Regiao,
	Estado,
	Float:Spawn[3],
	tCor,
	tSkin,
}

enum Variables
{
	pMoney,
	pSkin,
	VirtualWorld,
	pHealth,
	pArmour,
	Float:Float_X,
	Float:Float_Y,
	Float:Float_Z,
	Float:pAngle,
	WantedLevel,
	Inter
}

// ================= [ Variaveis ] ================= //
new bool:Logado[MAX_PLAYERS];
new Player[MAX_PLAYERS][pInfo];
new Variable[MAX_PLAYERS][Variables];
new HighestID;
new Float:colete;
new NomeEnquete[128] = "N/A";
new bool:EnqueteAberta;
new SringEnquete[128];
new TotalDeVotosSim;
new TotalDeVotosNao;
new PlayerVotou[500];
new VeiculoVeh[MAX_PLAYERS];
new CrieiTapete[MAX_PLAYERS];
new TempoTapete[MAX_PLAYERS];
new PassandoTapete[MAX_PLAYERS];
new TapeteCOP[MAX_PLAYERS];
new Equipamentos[MAX_PLAYERS];
new Float:AnguloTapete, Float:TapeteX, Float:TapeteY, Float:TapeteZ;
new Float:X, Float:Y, Float:Z, Float:A;
new conectDB = -1;
new Connection;
new tentativaDeLogin[MAX_PLAYERS];
new CP[MAX_PLAYERS];
new EstadosSudeste[4] = {1,2,3,4};
new EstadosSul[4] = {5,6,7,8};
new EstadosNorte[8] = {9,10,11,12,13,14,15,16};
new Text:Textdraw[4], Text:Hora, Text:Data, Text:Box[4], Text:Entrada[3];
new bool:TempoReal[2];
new AnoL[MAX_PLAYERS],MesL[MAX_PLAYERS];
new DiaL[MAX_PLAYERS],MinutoL[MAX_PLAYERS],HoraL[MAX_PLAYERS];
new tmpobjid;
new Timer;
new LimiteReparar[MAX_PLAYERS];
new Weapons[MAX_PLAYERS][13][2];
new Reports[10] = {INVALID_PLAYER_ID, ...};
new ReportsReasons[10][24];
new rep_idx;
new Preso[MAX_PLAYERS];
new PresoADM[MAX_PLAYERS];
new CarBOPE[26];
new portaoBOPE;
new portaoBOPE2;
new portaocasa;
new portaomansao;

// ================ [ Torcidas ] ================= //
new Torcidas[MAX_TORCIDAS][t_info] = {
{"Torcida", "Sigla", 0, 0, {0.0, 0.0, 0.0}, COR_BRANCO, 0},
{"Torcida Jovem do Flamengo", "TJF", 3, 1, {298.9993,-1155.5597,80.9099}, COR_UPC, 107},
{"Raça Rubro Negra", "RRN", 3, 1, {439.3765,-1483.4410,30.6376}, COR_PC, 98},
{"Força Jovem do Vasco", "FJV", 3, 1, {736.5942,-1276.0553,13.5534}, COR_DPA, 28},
{"Torcida Jovem do Botafogo", "TJB", 3, 1, {1280.1870,-794.9151,88.3151}, COR_DPA, 0},
{"Young Flu", "TYF", 3, 1, {709.1729,-1422.1975,13.5312}, COR_PCA, 106},
{"Ira Jovem do Vasco", "IJV", 3, 1, {1125.5115,-2036.9897,69.8810}, COR_DPA, 0},
{"Pavilhão 9", "P9", 3, 2, {2387.4644,-1544.8707,24.0000}, COR_MPC, 188},
{"Camisas 12", "C12", 3, 2, {2475.1243,-1528.5378,23.9999}, COR_MPC, 19},
{"Torcida Tricolor Independente", "TTI", 3, 2, {2246.8677,-1662.0450,15.4690}, COR_UPC, 250},
{"Mancha Verde", "MV", 3, 2, {1793.2771,-1703.9200,13.5288}, COR_DPA, 2},
{"Gaviões da Fiel", "GDF", 3, 2, {1686.1012,-2101.3367,13.8343}, COR_TVP, 271},
{"Torcida Jovem do Santos", "TJS", 3, 2, {2722.4751,-2026.6414,13.5472}, COR_PCA, 0},
{"Comando Máfia Azul", "CMA", 3, 3, {1780.8768,-1349.1748,15.7453}, COR_PDA, 22},
{"Torcida Organizada Galoucura", "TOG", 3, 3, {2683.8411,-1104.8311,69.3670}, COR_DPA, 116},
{"Torcida Jovem ponte", "TJP", 3, 4, {204.6145,-233.1515,1.7786}, COR_PC, 0},
{"Torcida Furia Independente", "TFI", 3, 4, {627.7701,-571.7003,17.5487}, COR_PCA, 0},
{"Torcida Organizada os Fanáticos", "TOF", 2, 5, {-2006.8806,1128.5851,53.2815}, COR_PC, 32},
{"Imperio Alviverde", "IAV", 2, 5, {-1655.3398,1206.8250,21.1563}, COR_DPA, 168},
{"Torcida Furia Independente", "TFI", 2, 5, {-1703.8235,1339.8689,7.1819}, COR_PCA, 0},
{"Torcida Mancha Azul", "TMA", 2, 7, {-2184.2834,-247.9608,40.7195}, COR_DPA, 0},
{"Torcida Organizada Gaviões Alvinegros", "TOGA", 2, 7, {-2442.0251,523.9457,29.9102}, COR_ALQ, 202},
{"Força Jovem do Goias", "FJG", 2, 8, {-1832.7720,111.0716,15.1172}, COR_DPA, 107},
{"Torcida Esquadrão Vilanovense", "TEV", 2, 8, {-1955.3096,258.7455,41.0471}, COR_ALQ, 175},
{"Torcida Jovem do Sport", "TJS", 1, 9, {2090.9050,2224.5129,11.0234}, COR_UPC, 166},
{"Torcida Jovem Fanautico", "TJF", 1, 9, {1934.6375,2445.4248,11.1782}, COR_LDB, 176},
{"Torcida Organizada Inferno Coral", "TOIC", 1, 9, {1658.4321,2251.8757,11.0701}, COR_LDA, 125},
{"Torcida Organizada Bamor", "TOB", 1, 10, {2178.3687,964.2657,10.8203}, COR_LDA, 292},
{"Torcida Uniformizada os Imbativeis", "TUI", 1, 10, {2558.8193,1417.5371,10.8280}, COR_PC, 247},
{"Torcida Uniformizada do Fortaleza", "TUF", 1, 11, {2347.4688,2274.5876,8.1478}, COR_ALQ, 66},
{"Torcida Organizada Cearamor", "TOC", 1, 11, {2798.6609,1256.3475,11.0299}, COR_LDB, 49},
{"Torcida Mafia Vermelha", "TMV", 1, 12, {1688.7971,920.3893,10.7848}, COR_PCA, 0},
{"Torcida Garra Alvinegra", "TGA", 1, 12, {1375.4203,1038.5996,10.8203}, COR_DPA, 48},
{"Torcida Organizada Remista", "TOR", 1, 13, {2519.1033,2334.8618,10.8203}, COR_PDA, 0},
{"Torcida Uniformizada Terror Bicolor", "TUTB", 1, 13, {2097.2751,2491.9673,14.8390}, COR_DPA, 142},
{"Torcida Trovão Azul", "TTA", 1, 14, {1669.0331,1833.8472,10.8203}, COR_LDA, 0},
{"Torcida Organizada Mancha Azul", "TOMA", 1, 15, {1686.1438,1450.4910,10.7694}, COR_LDA, 163},
{"Urubuzada", "UBZ", 3, 1, {416.2722,-1154.6017,76.6876}, COR_UPC, 0},
{"Geral do Gremio", "GDG", 2, 6, {-2518.8499,-26.5129,25.6172}, COR_DPA, 268},
{"Torcida Dragões Atleticanos", "TDA", 2, 8, {-2025.2749,67.1913,28.4314}, COR_UPC, 0},
{"Ira Jovem do Gama", "IJG", 2, 8, {-1882.5850,866.5850,35.1719}, COR_DPA, 43},
{"Torcida Jovem do Galo", "TJG", 1, 16, {1964.7148,2154.0483,10.8203}, COR_LDA, 299},
{"Torcida Facção Brasiliense", "TFB", 2, 8, {-1947.0754,1000.7812,35.1756}, COR_PC, 161},
{"Movimento Organizado Força Indepedente", "MOFI", 1, 11, {2543.7363,1966.7346,10.3904}, COR_LDB, 17}, // CONFIRMA O NOME DA MOFI
{"Torcida Uniformizada Terror Tricolor", "TUTT", 1, 13, {2244.6445,2523.4526,10.8203}, COR_LDB, 0},
{"Jovem Garra Tricolor", "JGT", 1, 11, {2200.9729,1393.0037,10.8203}, COR_ALQ, 186},
{"Leões do Vale", "LV", 2, 7, {-2666.9460,-5.2905,6.1328}, COR_DPA, 0},
{"Torcida Organizada Comando Alvinegro", "TOCA", 1, 9, {2245.6296,10.8203,348.8002}, COR_LDB, 0},
{"Torcida Organizada Raça Coral", "TORC",1, 9, {1876.1128,2236.9348,11.1250}, COR_LDA, 242},
{"Torcida Facção Jovem", "TFJ",1, 16, {1944.6550,2052.4290,10.8203}, COR_UPC, 10},
{"Torcida Organizada Mancha Negra", "TOMN", 1, 15, {941.2982,1732.9628,8.8516}, COR_LDA, 278}
};

/*
	ID das Regioes:
	    1: Norte e Nordeste
	    2: Sul e Centro-Oeste
	    3: Sudeste

	ID dos Estados:
		1: Rio de Janeiro
		2: São Paulo
		3: Minas Gerais
		4: Interior
		5: Paraná
		6: Rio Grande do Sul
		7: Santa Catarina
		8: Goias / Distrito Federal
		9: Pernambuco
		10: Bahia
		11: Ceará
		12: Rio Grande do Norte
		13: Pará
		14: Sergipe
		15: Alagoas
		16: Paraíba

*/

enum H_DATA
{
    houseOwner[MAX_PLAYER_NAME],
    houseTitle[32],
    Float:houseX,
    Float:houseY,
    Float:houseZ,
    Float:houseIntX,
    Float:houseIntY,
    Float:houseIntZ,
    Float:houseIntFA,
    housePrice,
    houseRentable,
    houseRentPrice,
    houseTenant[MAX_PLAYER_NAME],
    houseInterior,
    houseVirtualWorld,
    houseOutcoming,
    houseIncoming,
    houseStatus,
    Float: houseArmourStored[MAX_ARMOUR]
};

new houseData[MAX_HOUSES][H_DATA];

enum V_DATA
{
    vehicleHouse,
    vehicleModel,
    Float:vehicleX,
    Float:vehicleY,
    Float:vehicleZ,
    Float:vehicleAngle,
    vehicleColor1,
    vehicleColor2,
    vehiclePrice,
    vehicleStatus,
    vehiclePlate[9],
    vehicleRespawnTime
};

new
    houseVehicle[MAX_HOUSES][V_DATA];

new Float:vehicleRandomSpawnLS[5][4] =
{
    {562.1305, -1289.1633, 17.2482, 8.3140},
    {555.0199, -1289.7725, 17.2482, 8.3140},
    {545.4489, -1290.3143, 17.2422, 5.4940},
    {537.9535, -1290.5930, 17.2422, 5.4940},
    {531.6931, -1289.9067, 17.2422, 5.4940}
};

new Float:vehicleRandomSpawnLV[5][4] =
{
    {2148.9365, 1408.1271, 10.8203, 357.5897},
    {2142.3223, 1408.1522, 10.8203, 0.4097},
    {2135.7615, 1408.5500, 10.8203, 0.4097},
    {2129.6689, 1408.9573, 10.8203, 0.4097},
    {2122.9722, 1408.7527, 10.8125, 0.4097}
};

new Float:vehicleRandomSpawnSF[5][4] =
{
    {-1660.8989, 1214.8601, 6.8225, 254.6284},
    {-1662.4044, 1220.4973, 13.2328, 244.6268},
    {-1658.1219, 1211.8868, 13.2439, 253.0740},
    {-1665.8286, 1206.1846, 20.7260, 297.6071},
    {-1656.9680, 1214.9564, 20.7159, 214.0509}
};

#pragma unused vehicleRandomSpawnLV
#pragma unused vehicleRandomSpawnSF

new
    houseIDReceiveCar,
    carSell,
    housePickupIn[MAX_HOUSES],
    housePickupOut[MAX_HOUSES],
    houseMapIcon[MAX_HOUSES],
    Text3D:houseLabel[MAX_HOUSES],
    Float:houseInteriorX[MAX_PLAYERS],
    Float:houseInteriorY[MAX_PLAYERS],
    Float:houseInteriorZ[MAX_PLAYERS],
    Float:houseInteriorFA[MAX_PLAYERS],
    houseIntPrice[MAX_PLAYERS],
    houseInteriorInt[MAX_PLAYERS],
    carSet[MAX_PLAYERS],
    bool: houseCarSet[MAX_PLAYERS],
    bool: counting[MAX_PLAYERS] = false,
    houseCarSetPos[MAX_PLAYERS],
    carSetted[MAX_PLAYERS],
    playerReceiveHouse,
    priceReceiveHouse,
    timerC[MAX_PLAYERS],
    houseSellingID,
    playerIDOffer,
    timeHour, timeMinute, timeSecond,
    towRequired[MAX_HOUSES],
    vehicleHouseCarDefined[MAX_HOUSES],
    newOwnerID,
    bool: adminCreatingVehicle[MAX_PLAYERS],
    playerName[MAX_PLAYER_NAME],
    globalColor1,
    globalColor2,
    Float: oldArmour;

//============================= [FORWARDS] ============================//
TowVehicles();
CreateHouseVehicleToPark(playerid);
RentalCharge();
CreateLogs();
SaveHouses();
SaveHouse(house);
SpawnInHome(playerid);
DestroySetVehicle(playerid);


main()
{
	print("\n================================");
	print("      GAMEMODE GTB TORCIDAS V1.0");
 	print("  INICIO GAMEMODE: 22/04/2016 ás 22:18");
 	print("        PROGRAMADOR: MAROLA");
	print("==================================\n");
}
new db[1000];
public OnGameModeInit()
{
	// ================== [ CONFIGURAÇÕES ] ================== //
    CreateAllHouses();
    CreateAllHousesVehicles();
    CreateLogs();
    for(new house = 1; house < MAX_HOUSES; house++)
        if(houseVehicle[house][vehicleModel] != 0)
            SetVehicleNumberPlate(houseVehicle[house][vehicleHouse], houseVehicle[house][vehiclePlate]);
    new logString[128];
    format(logString, sizeof logString, "----------- SISTEMA INICIADO -----------");
    WriteLog(LOG_SYSTEM, logString);
    SetTimer("TowVehicles", 60000*3, true);
    SetTimer("RentalCharge", 1000, true);
    SetTimer("SaveHouses", 60000*10, true);
    
	UsePlayerPedAnims();
	LimitGlobalChatRadius(30);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(0);
	SendRconCommand("hostname [BR/PT] GTB Torcidas - Oficial [V1.0]");
	SendRconCommand("language BR/PT");
	SetGameModeText("[GTB Mod] v1.0");
 	SetTimer("Top1",60000*5,1);
 	SetTimer("hora",1000,1);
	SetTimer("@PayDay", 60000*60, 1);
 	Timer = SetTimer("CheckVip", 60000, true);
	TempoReal[1] = true;
	CreatePickupsSedes();
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	
	// ============= [ LASER ] ================== //
    new p = GetMaxPlayers();
    for (new i=0; i < p; i++)
	{
            SetPVarInt(i, "laser", 0);
            SetPVarInt(i, "color", 18643);
    }
	
	// ================== [ Banco de Dados ] =================================== //
	mysql_log(LOG_ERROR | LOG_WARNING, LOG_TYPE_HTML); //registra erros e avisos em um arquivo de log agradável .html
 	conectDB = mysql_connect(mysql_host, mysql_user, mysql_database, mysql_password); //Usando as definições de conexão..
 	Connection = mysql_connect(Host_Connection, Host_User, Host_DB, Host_Password); //Usando as definições de conexão..
	mysql_query(conectDB, "CREATE TABLE IF NOT EXISTS `banlist` (`Name` varchar(24) NOT NULL,`banreason` varchar(24),`bantime` int(20),`bannedby` varchar(30), `data` varchar(20), `days` int(20),IP varchar(16))", false);
	mysql_query(Connection, "CREATE TABLE IF NOT EXISTS `Keys`(`Key` varchar(24) NOT NULL, `Dias` int(5) NOT NULL, `Nivel` int(5) NOT NULL)", false);
	mysql_query(Connection, "CREATE TABLE IF NOT EXISTS `Vips`(`Nick` varchar(24) NOT NULL, `Dias` int(5) NOT NULL, `TempoVip` int(5) NOT NULL, `Nivel` int(5) NOT NULL)", false);

	strcat(db,"CREATE TABLE IF NOT EXISTS `pinfo` (`id` int(11) NOT NULL auto_increment PRIMARY KEY,`Nick` varchar(24),`Senha` varchar(20),`Email` varchar(64), IP varchar(16), `iniciante` int(11), `minutol` int(11), `horal` int(11), `dial` int(11), `mesl` int(11), `anol` int(11), `nometorcida` varchar(70),`torcida` int (11), `skin` int(11), `score` int(11),");
	strcat(db,"`cash` int(11),`dinheiro` int(11), `admin` int(11), `pres` int(11), `vpres` int(11), `org` int(11), `pux` int(11), `bope` int(11), `choque` int(11), `matou` int(11), `morreu` int(11), `procurado` int(11), `estrelaprocurado` int(11), `suabatidos` int(11), `sutotal` int(11), `passagens` int(11), `reportslidos` int(11),");
	strcat(db,"`fumo` int(11), `cheiro` int(11), `tempopreso` int(11))");
	mysql_query(conectDB, db, true);

    CreatePickup(1318, 1, 772.3268,-5.1274,1000.7287, -1); //SAIR SEDE
    
    // ================== [ TEXTDRAW'S ] ======================================= //
	Box[0] = TextDrawCreate(641.531494, 366.083312, "usebox");
	TextDrawLetterSize(Box[0], 0.000000, 8.887042);
	TextDrawTextSize(Box[0], -2.000000, 0.000000);
	TextDrawAlignment(Box[0], 1);
	TextDrawColor(Box[0], 0);
	TextDrawUseBox(Box[0], true);
	TextDrawBoxColor(Box[0], 102);
	TextDrawSetShadow(Box[0], 0);
	TextDrawSetOutline(Box[0], 0);
	TextDrawFont(Box[0], 0);

	Box[1] = TextDrawCreate(641.531494, 361.416687, "usebox");
	TextDrawLetterSize(Box[1], 0.000000, 0.007402);
	TextDrawTextSize(Box[1], -2.000000, 0.000000);
	TextDrawAlignment(Box[1], 1);
	TextDrawColor(Box[1], -16776961);
	TextDrawUseBox(Box[1], true);
	TextDrawBoxColor(Box[1], -16776961);
	TextDrawSetShadow(Box[1], 0);
	TextDrawSetOutline(Box[1], 0);
	TextDrawFont(Box[1], 0);

	Box[2] = TextDrawCreate(641.531494, 2.083280, "usebox");
	TextDrawLetterSize(Box[2], 0.000000, 8.951854);
	TextDrawTextSize(Box[2], -2.000002, 0.000000);
	TextDrawAlignment(Box[2], 1);
	TextDrawColor(Box[2], 0);
	TextDrawUseBox(Box[2], true);
	TextDrawBoxColor(Box[2], 102);
	TextDrawSetShadow(Box[2], 0);
	TextDrawSetOutline(Box[2], 0);
	TextDrawFont(Box[2], 0);

	Box[3] = TextDrawCreate(641.531555, 87.249938, "usebox");
	TextDrawLetterSize(Box[3], 0.000000, 0.007402);
	TextDrawTextSize(Box[3], -1.999999, 0.000000);
	TextDrawAlignment(Box[3], 1);
	TextDrawColor(Box[3], 0);
	TextDrawUseBox(Box[3], true);
	TextDrawBoxColor(Box[3], -16776961);
	TextDrawSetShadow(Box[3], 0);
	TextDrawSetOutline(Box[3], 0);
	TextDrawFont(Box[3], 0);

	Entrada[0] = TextDrawCreate(267.994354, 384.416748, "GTB ~w~Torcidas");
	TextDrawLetterSize(Entrada[0], 0.458433, 2.177500);
	TextDrawAlignment(Entrada[0], 1);
	TextDrawColor(Entrada[0], -16776961);
	TextDrawSetShadow(Entrada[0], 0);
	TextDrawSetOutline(Entrada[0], 1);
	TextDrawBackgroundColor(Entrada[0], 51);
	TextDrawFont(Entrada[0], 3);
	TextDrawSetProportional(Entrada[0], 1);

	Entrada[1] = TextDrawCreate(291.420043, 375.083587, "versao: ~w~1.0v");
	TextDrawLetterSize(Entrada[1], 0.206837, 1.156666);
	TextDrawAlignment(Entrada[1], 1);
	TextDrawColor(Entrada[1], -16776961);
	TextDrawSetShadow(Entrada[1], 0);
	TextDrawSetOutline(Entrada[1], 1);
	TextDrawBackgroundColor(Entrada[1], 51);
	TextDrawFont(Entrada[1], 2);
	TextDrawSetProportional(Entrada[1], 1);
	
	Entrada[2] = TextDrawCreate(277.364746, 404.833526, "crescendo com voce");
	TextDrawLetterSize(Entrada[2], 0.264933, 1.273332);
	TextDrawAlignment(Entrada[2], 1);
	TextDrawColor(Entrada[2], -1);
	TextDrawSetShadow(Entrada[2], 0);
	TextDrawSetOutline(Entrada[2], 1);
	TextDrawBackgroundColor(Entrada[2], 51);
	TextDrawFont(Entrada[2], 3);
	TextDrawSetProportional(Entrada[2], 1);
    
	Textdraw[0] = TextDrawCreate(493.384460, 384.416900, "GTB ~w~Torcidas");
	TextDrawLetterSize(Textdraw[0], 0.413455, 2.405002);
	TextDrawAlignment(Textdraw[0], 1);
	TextDrawColor(Textdraw[0], -16776961);
	TextDrawSetShadow(Textdraw[0], 0);
	TextDrawSetOutline(Textdraw[0], 1);
	TextDrawBackgroundColor(Textdraw[0], 51);
	TextDrawFont(Textdraw[0], 2);
	TextDrawSetProportional(Textdraw[0], 1);

	Textdraw[1] = TextDrawCreate(525.680908, 406.000000, "versao: ~w~1.0v");
	TextDrawLetterSize(Textdraw[1], 0.213396, 1.057499);
	TextDrawAlignment(Textdraw[1], 1);
	TextDrawColor(Textdraw[1], -16776961);
	TextDrawSetShadow(Textdraw[1], 0);
	TextDrawSetOutline(Textdraw[1], 1);
	TextDrawBackgroundColor(Textdraw[1], 51);
	TextDrawFont(Textdraw[1], 2);
	TextDrawSetProportional(Textdraw[1], 1);

	Textdraw[2] = TextDrawCreate(508.814605, 415.916625, "www.equipegtb.com");
	TextDrawLetterSize(Textdraw[2], 0.213396, 1.057499);
	TextDrawAlignment(Textdraw[2], 1);
	TextDrawColor(Textdraw[2], -1);
	TextDrawSetShadow(Textdraw[2], 0);
	TextDrawSetOutline(Textdraw[2], 1);
	TextDrawBackgroundColor(Textdraw[2], 51);
	TextDrawFont(Textdraw[2], 2);
	TextDrawSetProportional(Textdraw[2], 1);

	Textdraw[3] = TextDrawCreate(516.779296, 427.000030, "players on: ~w~20/50");
	TextDrawLetterSize(Textdraw[3], 0.213396, 1.057499);
	TextDrawAlignment(Textdraw[3], 1);
	TextDrawColor(Textdraw[3], -16776961);
	TextDrawSetShadow(Textdraw[3], 0);
	TextDrawSetOutline(Textdraw[3], 1);
	TextDrawBackgroundColor(Textdraw[3], 51);
	TextDrawFont(Textdraw[3], 2);
	TextDrawSetProportional(Textdraw[3], 1);

	Hora = TextDrawCreate(544.421630, 23.916709, "10:20:30");
	TextDrawLetterSize(Hora, 0.386748, 1.804165);
	TextDrawAlignment(Hora, 1);
	TextDrawColor(Hora, -16776961);
	TextDrawSetShadow(Hora, 0);
	TextDrawSetOutline(Hora, 1);
	TextDrawBackgroundColor(Hora, 51);
	TextDrawFont(Hora, 3);
	TextDrawSetProportional(Hora, 1);
	
	Data = TextDrawCreate(536.456542, 5.249979, "22/04/2016");
	TextDrawLetterSize(Data, 0.351608, 1.804165);
	TextDrawAlignment(Data, 1);
	TextDrawColor(Data, -1);
	TextDrawSetShadow(Data, 0);
	TextDrawSetOutline(Data, 1);
	TextDrawBackgroundColor(Data, 51);
	TextDrawFont(Data, 3);
	TextDrawSetProportional(Data, 1);

	// ================= [ EXTERIOR B.O.P.E ] ================================== //
	Create3DTextLabel("Departamento de Polícia\nPressione F",0xE3E3E3FF,341.4738,1827.2454,2241.5850,25.0,0,1); //BOPE LV DP
	Create3DTextLabel("Entrar no Departamento\nPressione F",0xE3E3E3FF,2296.7395,2460.0120,10.8203,40,0,1); //BOPE LV (ENTRAR)
	Create3DTextLabel("Sair\nPressione F",0xE3E3E3FF,350.5490,1834.3707,2241.5850,40,0,1); //BOPE SAIR LV
	Create3DTextLabel("Elevador\nPressione F",0xE3E3E3FF,2297.1169,2451.4468,10.8203,25.0,0,1); //ELEVADOR BOPE LV
	Create3DTextLabel("Elevador\nPressione F",0xE3E3E3FF,2291.1814,2458.5923,38.6875,25.0,0,1); //ELEVADOR BOPE LV
	Create3DTextLabel("Equipar\nPressione F",0xE3E3E3FF,298.9932,1829.0441,2241.5850,25.0,0,1); //EQUIPAR BOPE LV

 	CreatePickup(1247, 1, 341.4738,1827.2454,2241.5850, -1); //BOPE LV DP LIMP FICHA
    CreatePickup(1314, 1, 2296.7395,2460.0120,10.8203, -1); //BOPE LV DP
	CreatePickup(1239, 1, 350.5490,1834.3707,2241.5850, -1); //BOPE LV (SAIR)
	CreatePickup(1318, 1, 2291.1814,2458.5923,38.6875, -1); //BOPE LV ELEVADOR
	CreatePickup(1318, 1, 2297.1169,2451.4468,10.8203, -1); //BOPE LV ELEVADOR
	CreatePickup(1254, 1, 298.9932,1829.0441,2241.5850, -1); //EQUIPAR BOPE LV
	
	// =================== [ PORTÕES ] ========================================= //
	portaoBOPE=CreateDynamicObject(980,2237.6,2453.08,12.45,0.0,0.0,90.000);
	portaoBOPE2=CreateDynamicObject(971,2334.43,2443.65,7.7906,180,180,56.0002);
	portaocasa = CreateDynamicObject(971, 527.52362, -1873.93237, 2.19100,   0.00000, 0.00000, 0.00000);
	portaomansao = CreateDynamicObject(971, 1026.75684, -370.08450, 72.74670,   0.00000, 0.00000, 0.00000);

 	// =================== [ VEÍCULOS BOPE ] ===================================== //
	CarBOPE[1] = CreateVehicle(490,2282.1152,2477.3601,10.7138,179.0098,0,0,60000); //
	CarBOPE[2] = CreateVehicle(490,2277.6846,2477.2725,10.5603,180.1091,0,0,60000); //
	CarBOPE[3] = CreateVehicle(490,2273.5161,2477.8120,10.7123,180.5015,0,0,60000); //
	CarBOPE[4] = CreateVehicle(490,2269.2578,2477.8269,10.7130,179.5302,0,0,60000); //
	CarBOPE[5] = CreateVehicle(490,2260.4070,2477.9712,10.7131,179.6287,0,0,60000); //
	CarBOPE[6] = CreateVehicle(490,2255.7454,2477.9014,10.7115,179.6411,0,0,60000); //
	CarBOPE[7] = CreateVehicle(598,2251.7871,2478.0071,10.7124,177.8916,0,1,60000); //
	CarBOPE[8] = CreateVehicle(598,2260.5415,2458.4551,10.7113,1.3456,0,1,60000); //
	CarBOPE[9] = CreateVehicle(598,2255.7742,2458.4878,10.7113,358.7373,0,1,60000); //
	CarBOPE[10] = CreateVehicle(598,2269.1118,2458.5486,10.7138,358.8112,0,1,60000); //
	CarBOPE[11] = CreateVehicle(598,2273.8113,2458.2876,10.7125,358.4223,0,1,60000); //
	CarBOPE[12] = CreateVehicle(598,2278.1143,2458.1877,10.7131,359.1316,0,1,60000); //
	CarBOPE[13] = CreateVehicle(598,2282.2993,2458.3198,10.7122,0.4213,0,1,60000); //
	CarBOPE[14] = CreateVehicle(598,2295.1733,2443.0007,10.7125,1.2980,0,1,60000); //
	CarBOPE[15] = CreateVehicle(598,2291.0605,2442.9233,10.7122,359.8896,0,1,60000); //
	CarBOPE[16] = CreateVehicle(523,2283.1582,2441.3345,10.3919,357.7822,0,1,60000); //
	CarBOPE[17] = CreateVehicle(523,2280.9163,2441.2688,10.3921,1.8715,0,1,60000); //
	CarBOPE[18] = CreateVehicle(523,2278.6685,2441.2317,10.3893,359.2724,0,1,60000); //
	CarBOPE[19] = CreateVehicle(523,2276.4285,2441.1260,10.3894,0.6812,0,1,60000); //
	CarBOPE[20] = CreateVehicle(523,2274.0627,2441.0720,10.3946,359.1118,0,1,60000); //
	CarBOPE[21] = CreateVehicle(523,2271.7517,2441.0212,10.3891,0.0873,0,1,60000); //
	CarBOPE[22] = CreateVehicle(523,2269.5515,2440.9453,10.3843,1.5222,0,1,60000); //
	CarBOPE[23] = CreateVehicle(497,2277.7742,2470.6748,38.6837,90.0209,0,1,60000); // HELLI
	CarBOPE[24] = CreateVehicle(427,2290.7000000,2476.3000000,11.1000000,180.0000000,0,1,60000); //Enforcer
	CarBOPE[25] = CreateVehicle(427,2294.6001000,2476.3000000,11.1000000,180.0000000,0,1,60000); //Enforcer
	
	//=============================== [ B.O.P.E LV] ============================= //
	CreateDynamicObject(1337, 2289.8779296875, 2485.0859375, 17.285743713379, 0, 0, 0);//DP LV Objeto (2)
	CreateDynamicObject(987, 2281.9409179688, 2502.6938476563, 10.3203125, 0, 0, 0);//DP LV Objeto (3)
	CreateDynamicObject(987, 2270.0510253906, 2502.6647949219, 10.298473358154, 0, 0, 0);//DP LV Objeto (4)
	CreateDynamicObject(987, 2258.2131347656, 2502.6833496094, 10.298473358154, 0, 0, 0);//DP LV Objeto (5)
	CreateDynamicObject(987, 2246.8132324219, 2502.6723632813, 10.295305252075, 0, 0, 0);//DP LV Objeto (6)
	CreateDynamicObject(987, 2237.462890625, 2502.6950683594, 10.295305252075, 0, 0, 0);//DP LV Objeto (7)
	CreateDynamicObject(987, 2237.8383789063, 2490.7131347656, 10.312507629395, 0, 0, 90);//DP LV Objeto (8)
	CreateDynamicObject(987, 2237.8393554688, 2478.9033203125, 10.323474884033, 0, 0, 90);//DP LV Objeto (9)
	CreateDynamicObject(987, 2237.8598632813, 2467.0317382813, 10.331087112427, 0, 0, 90);//DP LV Objeto (10)
	CreateDynamicObject(987, 2237.8767089844, 2458.5717773438, 10.325777053833, 0, 0, 90);//DP LV Objeto (11)
	CreateDynamicObject(987, 2237.8547363281, 2437.0964355469, 10.423471450806, 0, 0, 90);//DP LV Objeto (12)
	CreateDynamicObject(987, 2237.8872070313, 2430.5041503906, 10.420303344727, 0, 0, 90);//DP LV Objeto (13)
	CreateDynamicObject(987, 2238.1240234375, 2430.9208984375, 10.408324241638, 0, 0, 0);//DP LV Objeto (14)
	
	// =================== [ INTERIOR B.O.P.E ] ================================ //
	tmpobjid = CreateDynamicObject(19866,351.194,1832.889,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,352.726,1827.442,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19416,351.209,1830.583,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,351.194,1836.635,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19416,351.211,1838.192,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,344.325,1822.561,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,351.210,1824.161,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19930,344.674,1828.117,2240.573,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19925,344.672,1829.140,2240.573,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19929,342.807,1829.144,2240.573,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19929,339.946,1829.143,2240.573,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19866,338.620,1828.705,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,344.233,1827.452,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,344.364,1827.450,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,336.620,1829.705,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,336.053,1829.205,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,336.453,1829.205,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,336.252,1829.205,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,340.978,1822.228,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19383,336.248,1826.864,2242.435,90.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19383,336.248,1823.365,2242.435,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,336.250,1816.799,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,331.355,1820.141,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19383,334.389,1828.918,2242.315,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,332.687,1829.576,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,331.840,1829.476,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,327.973,1828.906,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,327.523,1824.138,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,351.194,1842.470,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,346.488,1842.563,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,337.477,1842.591,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,331.927,1843.589,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,328.197,1843.589,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,332.768,1847.328,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,322.761,1846.755,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,327.040,1829.467,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,322.759,1832.777,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(1499,322.780,1832.765,2240.578,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19527, "cauldron1", "cauldron1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19332, "balloon_texts", "balloon02", 0);
	tmpobjid = CreateDynamicObject(1499,322.762,1835.776,2240.578,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19527, "cauldron1", "cauldron1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19332, "balloon_texts", "balloon02", 0);
	tmpobjid = CreateDynamicObject(19866,322.759,1836.517,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,322.762,1827.212,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,322.759,1841.959,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,322.759,1837.263,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,322.759,1841.209,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,341.259,1842.494,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,336.247,1823.760,2235.637,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(1502,333.603,1828.886,2240.562,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19379,317.897,1836.508,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,320.979,1841.337,2240.647,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,308.263,1836.508,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,326.466,1843.587,2240.647,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,324.466,1843.585,2240.647,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19538,311.996,1831.102,2240.585,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0);
	tmpobjid = CreateDynamicObject(1493,345.807,1827.523,2240.581,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wall2", 0);
	tmpobjid = CreateDynamicObject(19443,314.688,1834.693,2240.677,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,319.637,1824.883,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19443,314.688,1833.260,2240.679,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,321.159,1830.390,2240.647,90.000,0.000,116.159,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(3032,314.765,1835.580,2243.229,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(3032,314.765,1833.055,2243.229,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(3032,313.859,1831.548,2243.229,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(19443,313.808,1831.605,2239.731,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,314.682,1832.256,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(3032,310.605,1831.534,2243.229,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(3032,314.761,1834.336,2244.147,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(19462,309.769,1829.218,2236.663,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19383,312.257,1831.603,2242.315,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19443,310.670,1831.605,2239.731,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,309.769,1831.701,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(1499,311.483,1831.585,2240.578,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19527, "cauldron1", "cauldron1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19332, "balloon_texts", "balloon02", 0);
	tmpobjid = CreateDynamicObject(1499,309.775,1825.124,2240.578,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19527, "cauldron1", "cauldron1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19332, "balloon_texts", "balloon02", 0);
	tmpobjid = CreateDynamicObject(19866,309.763,1827.940,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19383,309.771,1825.864,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,309.769,1822.718,2236.663,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,309.763,1824.600,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,309.763,1821.100,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19462,322.757,1834.312,2247.896,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,314.735,1820.463,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,309.899,1820.828,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,304.934,1820.463,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,306.288,1832.958,2240.647,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,300.920,1830.702,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19866,306.371,1831.535,2242.955,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19866,305.725,1830.687,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(19379,296.361,1825.642,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19383,308.068,1831.298,2242.315,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(1499,307.293,1831.278,2240.578,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19527, "cauldron1", "cauldron1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19332, "balloon_texts", "balloon02", 0);
	tmpobjid = CreateDynamicObject(19866,314.312,1836.472,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(2608,312.648,1836.232,2242.622,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2063,304.371,1830.214,2241.487,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(2063,299.087,1830.301,2241.487,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(2475,307.554,1820.649,2240.590,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(2475,304.553,1820.621,2240.590,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(2475,301.492,1820.629,2240.590,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(19379,295.300,1820.464,2240.576,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(11496,292.513,1823.114,2246.304,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2475,298.432,1820.633,2240.590,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(1850,302.801,1825.341,2240.302,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(1850,302.308,1826.061,2240.302,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(1850,305.790,1825.894,2239.507,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(1850,305.297,1825.497,2239.507,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19107, "armyhelmets", "armyhelmet4", 0);
	tmpobjid = CreateDynamicObject(2608,308.026,1836.202,2242.622,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2164,309.818,1836.379,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2173,311.943,1835.911,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2948,315.223,1834.795,2241.430,0.000,90.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(2948,315.221,1836.368,2241.428,0.000,90.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(1806,312.219,1834.905,2240.584,0.000,0.000,-38.759,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2268,311.661,1835.592,2241.839,-12.000,90.000,19.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2752,311.779,1836.165,2241.367,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19567,311.800,1836.155,2241.264,0.000,0.000,19.020,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19089,314.768,1834.724,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.765,1833.921,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.763,1833.459,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.769,1832.855,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.765,1832.254,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.771,1835.203,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.764,1835.895,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.765,1836.366,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,313.838,1834.414,2239.738,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.587,1831.538,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,313.864,1831.545,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,314.226,1831.551,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.869,1831.530,2245.835,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,310.646,1831.543,2245.465,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,310.266,1831.536,2245.969,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2164,306.374,1832.136,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2164,306.384,1833.898,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1999,307.495,1835.952,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19354,317.631,1834.386,2238.843,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19325,351.273,1828.346,2241.420,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "lightblue", 0);
	tmpobjid = CreateDynamicObject(19087,314.769,1835.907,2242.312,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19087,314.767,1835.307,2242.312,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19325,309.798,1829.345,2242.483,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(19325,309.762,1822.245,2242.483,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(19089,309.792,1828.626,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.800,1829.421,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.805,1830.206,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.798,1830.947,2245.932,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.803,1827.946,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.769,1823.828,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.770,1823.147,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.757,1822.447,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.766,1821.687,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.770,1821.104,2248.847,0.000,0.000,0.059,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19325,309.814,1825.906,2247.323,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(19089,309.813,1825.031,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,309.804,1826.692,2248.847,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,345.471,1839.507,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,346.472,1838.160,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,346.472,1836.828,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,346.472,1839.492,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,345.471,1838.175,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,345.471,1836.843,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,341.364,1839.507,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,342.365,1839.492,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,341.364,1838.175,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,342.365,1838.160,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,342.365,1836.828,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,341.364,1836.843,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,337.035,1838.155,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,337.029,1836.804,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,338.036,1838.160,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,338.036,1836.828,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,346.472,1840.824,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,345.471,1840.839,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,342.365,1840.824,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,341.364,1840.839,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19786,348.325,1842.480,2242.906,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0);
	tmpobjid = CreateDynamicObject(19786,338.885,1842.534,2242.906,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0);
	tmpobjid = CreateDynamicObject(11685,338.036,1839.500,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,337.035,1839.495,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,338.036,1840.841,2240.554,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(11685,337.035,1840.836,2240.554,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19379,351.211,1844.615,2240.576,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19786,342.453,1822.220,2242.906,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0);
	tmpobjid = CreateDynamicObject(2166,343.744,1823.832,2240.582,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19929,339.956,1828.581,2240.358,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19929,342.807,1828.582,2240.360,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19930,344.248,1828.145,2240.358,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(1806,342.721,1827.088,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1806,340.274,1827.208,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2161,337.881,1822.347,2240.583,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(2161,339.210,1822.346,2240.583,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(2161,340.539,1822.345,2240.583,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(2163,344.205,1826.869,2240.583,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1806,343.154,1823.975,2240.583,0.000,0.000,181.020,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19567,339.622,1828.566,2241.151,0.000,0.000,11.640,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19567,340.729,1828.576,2241.151,0.000,0.000,-11.640,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19567,343.230,1828.550,2241.151,0.000,0.000,-11.640,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2268,339.398,1828.029,2241.579,0.000,90.000,11.640,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2268,340.320,1828.189,2241.579,0.000,90.000,-11.640,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2268,341.171,1829.016,2241.579,0.000,90.000,168.119,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2268,339.848,1829.130,2241.579,0.000,90.000,191.880,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2268,342.797,1828.170,2241.579,0.000,90.000,-11.640,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2268,343.650,1829.012,2241.579,0.000,90.000,168.119,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19893,343.970,1827.891,2241.281,0.000,0.000,-72.780,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap2", 0);
	tmpobjid = CreateDynamicObject(19893,343.179,1822.766,2241.366,0.000,0.000,-163.620,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap2", 0);
	tmpobjid = CreateDynamicObject(19325,351.277,1839.938,2241.420,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "lightblue", 0);
	tmpobjid = CreateDynamicObject(19462,351.246,1834.394,2247.895,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(1753,328.147,1826.305,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "marb002", 0);
	tmpobjid = CreateDynamicObject(1823,328.611,1824.764,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19786,331.400,1828.840,2242.770,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0);
	tmpobjid = CreateDynamicObject(2164,328.894,1820.276,2240.582,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2167,329.814,1820.272,2240.582,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2204,332.762,1820.301,2240.582,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2205,334.269,1823.062,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19893,334.153,1823.174,2241.520,0.000,0.000,26.760,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap2", 0);
	tmpobjid = CreateDynamicObject(19567,335.777,1823.247,2241.404,0.000,0.000,-41.879,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2265,335.192,1823.133,2241.841,0.000,90.000,-41.880,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19325,336.241,1824.883,2241.420,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0);
	tmpobjid = CreateDynamicObject(19089,336.242,1826.647,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.250,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.237,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.215,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.189,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.179,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.257,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.281,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.311,1823.585,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.220,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.190,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.179,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.279,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.299,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.317,1825.106,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.212,1826.647,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.272,1826.647,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.292,1826.647,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.312,1826.647,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,336.182,1826.647,2244.783,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2265,336.390,1823.392,2241.841,0.000,90.000,-221.820,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2163,331.020,1828.800,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2162,327.624,1822.376,2242.206,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1753,328.158,1822.188,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "marb002", 0);
	tmpobjid = CreateDynamicObject(19380,330.961,1824.137,2240.507,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0);
	tmpobjid = CreateDynamicObject(19929,339.944,1829.143,2239.698,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19929,342.807,1829.144,2239.698,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19925,344.672,1829.140,2239.698,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19930,344.674,1828.117,2239.698,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2752,335.820,1823.263,2241.551,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2752,335.732,1823.365,2241.843,0.000,90.000,-41.100,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1547,322.874,1836.180,2242.334,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(1547,322.854,1840.050,2242.674,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(1547,322.854,1840.050,2242.374,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(1547,322.854,1840.050,2242.074,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(1547,335.569,1829.005,2242.342,90.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(1547,335.569,1829.005,2242.072,90.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(19381,331.079,1824.182,2244.075,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0);
	tmpobjid = CreateDynamicObject(2189,343.894,1842.426,2242.807,0.000,90.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2189,319.527,1825.112,2242.807,0.000,90.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2189,301.702,1830.565,2242.807,0.000,90.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2189,327.638,1825.179,2242.507,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2660,314.795,1834.303,2243.365,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2660,314.759,1834.329,2243.365,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2661,309.900,1825.844,2243.572,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2661,309.872,1825.860,2243.572,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(18981,348.710,1830.326,2245.904,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0);
	tmpobjid = CreateDynamicObject(18981,297.314,1818.690,2245.463,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0);
	tmpobjid = CreateDynamicObject(19378,331.103,1833.746,2244.103,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16639, "a51_labs", "ws_trainstationwin1", 0);
	tmpobjid = CreateDynamicObject(19378,331.103,1843.380,2244.103,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16639, "a51_labs", "ws_trainstationwin1", 0);
	tmpobjid = CreateDynamicObject(19462,351.212,1838.335,2248.882,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,351.212,1830.511,2248.882,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19462,346.675,1827.440,2245.229,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19378,327.946,1833.746,2244.104,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16639, "a51_labs", "ws_trainstationwin1", 0);
	tmpobjid = CreateDynamicObject(19378,327.946,1843.380,2244.106,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16639, "a51_labs", "ws_trainstationwin1", 0);
	tmpobjid = CreateDynamicObject(19462,330.682,1843.592,2247.896,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19455,336.266,1837.770,2245.766,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-60-percent", 0);
	tmpobjid = CreateDynamicObject(19455,336.268,1828.136,2245.766,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-60-percent", 0);
	tmpobjid = CreateDynamicObject(19455,336.262,1818.503,2245.766,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-60-percent", 0);
	tmpobjid = CreateDynamicObject(19089,342.730,1828.885,2251.515,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2661,342.203,1828.866,2244.405,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19089,341.708,1828.885,2251.515,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(2661,342.239,1828.914,2244.405,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19443,308.095,1831.298,2244.868,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19443,312.896,1831.596,2244.868,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19443,311.460,1831.594,2244.870,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(18075,329.726,1836.369,2244.068,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18075,346.183,1834.651,2245.466,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18075,336.683,1834.651,2245.466,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(902,339.930,1821.784,2243.340,35.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "smileyface1", 0);
	tmpobjid = CreateDynamicObject(902,337.930,1821.784,2243.340,36.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "smileyface1", 0);
	tmpobjid = CreateDynamicObject(19449,339.528,1837.453,2240.499,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0);
	tmpobjid = CreateDynamicObject(19449,339.528,1840.953,2240.499,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0);
	tmpobjid = CreateDynamicObject(19449,343.528,1837.453,2240.497,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0);
	tmpobjid = CreateDynamicObject(19449,343.528,1840.953,2240.497,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0);
	tmpobjid = CreateDynamicObject(19443,322.759,1838.833,2243.886,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(1897,351.269,1830.472,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.270,1838.135,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.270,1837.193,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.270,1838.985,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.269,1829.588,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.269,1831.390,2242.315,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.311,1830.486,2241.734,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.311,1830.486,2243.230,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.341,1838.128,2241.734,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1897,351.341,1838.128,2243.231,0.000,90.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1522,328.917,1843.576,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9106, "vgeamun", "hirisedoor1_256", 0);
	tmpobjid = CreateDynamicObject(1522,330.416,1843.576,2240.583,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9106, "vgeamun", "hirisedoor1_256", 0);
	tmpobjid = CreateDynamicObject(19089,330.433,1843.532,2243.619,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19089,351.197,1834.382,2243.619,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(1547,332.308,1843.460,2242.294,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "orange", 0);
	tmpobjid = CreateDynamicObject(19866,332.665,1842.599,2242.955,90.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, "libertyhi", "wallmix64HV", 0);
	tmpobjid = CreateDynamicObject(1522,322.755,1838.109,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9106, "vgeamun", "hirisedoor1_256", 0);
	tmpobjid = CreateDynamicObject(19443,322.763,1840.425,2242.345,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19443,322.763,1837.321,2242.345,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3786, "missiles_sfs", "ws_greyfoam", 0);
	tmpobjid = CreateDynamicObject(19379,306.283,1839.280,2242.606,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19004, "roundbuilding1", "stonewalltile4", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19327,314.788,1834.311,2243.507,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Arsenal", 80, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,314.788,1834.311,2243.197,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Escritorio", 80, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,309.908,1825.881,2243.537,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Arsenal", 80, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,319.534,1825.059,2242.866,0.000,0.000,-90.300,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "B.O.P.E", 80, "Ariel", 30, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,338.882,1822.341,2243.326,0.000,0.000,-179.499,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "BOPE", 80, "Engravers MT", 30, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327, 338.976, 1822.341, 2243.306, 0.000,-90.499,179.799,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "[]", 80, "courier", 72, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,338.880,1822.342,2242.776,0.000,-0.099,179.600,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Operações Especiais", 80, "Calibri", 25, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,343.898,1842.433,2242.807,0.000,0.000,-0.100,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "B.O.P.E", 80, "Ariel", 40, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,327.637,1825.199,2242.565,0.000,0.000,90.700,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "B.O.P.E", 80, "Ariel", 45, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,342.202,1828.924,2244.468,0.000,0.000,-179.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Frente", 90, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19327,342.202,1828.924,2244.298,0.000,0.000,-179.000,-1,-1,-1,50.000,50.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Mesa", 90, "Ariel", 25, 1, -1, 0, 1);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(1536,351.218,1835.896,2240.578,0.000,0.000,990.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1536,351.255,1832.877,2240.578,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2061,300.933,1830.030,2240.820,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2358,300.992,1830.324,2240.696,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,301.309,1826.267,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.695,1821.676,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1822.324,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1822.973,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1823.620,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1824.269,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1824.916,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1826.717,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1827.364,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1828.012,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1828.660,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1829.308,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11729,296.696,1829.885,2240.413,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2358,301.754,1830.326,2240.696,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2358,302.576,1830.333,2240.696,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2358,301.432,1830.334,2240.923,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2358,302.274,1830.330,2240.920,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2358,301.833,1830.340,2241.149,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2061,301.312,1830.018,2240.820,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2061,301.612,1830.007,2240.820,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,301.550,1826.253,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,301.815,1826.277,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.095,1826.258,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.373,1826.220,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.655,1826.220,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.978,1826.216,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,303.263,1826.236,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,303.552,1826.271,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,303.858,1826.283,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,301.299,1825.202,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,301.589,1825.127,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,301.847,1825.110,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.129,1825.119,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.429,1825.106,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.712,1825.115,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,302.995,1825.124,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,303.297,1825.131,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,303.578,1825.140,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2035,303.837,1825.111,2241.121,0.000,-90.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.907,1820.919,2242.111,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.788,1820.910,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.760,1820.748,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.881,1820.737,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,306.768,1820.797,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,307.288,1820.797,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,307.789,1820.796,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,304.723,1820.752,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,304.262,1820.734,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,303.802,1820.755,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,301.716,1820.783,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,301.236,1820.773,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,300.794,1820.785,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,298.631,1820.794,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,298.144,1820.806,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,297.673,1820.813,2241.398,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,307.645,1820.822,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,306.976,1820.875,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,304.669,1820.824,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,304.003,1820.858,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,301.611,1820.858,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,300.847,1820.875,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,298.540,1820.847,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,297.796,1820.859,2240.868,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11713,312.763,1820.572,2242.095,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11711,322.649,1834.276,2243.394,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19942,307.437,1820.807,2242.204,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19942,307.441,1820.927,2242.204,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19942,307.331,1820.650,2242.204,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19942,307.337,1820.810,2242.204,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19942,307.342,1820.950,2242.204,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19942,307.487,1820.683,2242.204,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,304.889,1820.796,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,304.609,1820.793,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,304.348,1820.810,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,304.068,1820.806,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,303.768,1820.822,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,301.835,1820.828,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,301.557,1820.798,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,301.334,1820.813,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,301.068,1820.830,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,300.726,1820.814,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,298.685,1820.850,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,298.399,1820.861,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,298.139,1820.837,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,297.893,1820.855,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19141,297.590,1820.844,2242.161,-30.000,-90.000,5.940,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,307.771,1820.760,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,307.290,1820.765,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,306.829,1820.751,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,304.745,1820.740,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,304.275,1820.766,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,303.808,1820.772,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,301.709,1820.783,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,301.206,1820.778,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,300.742,1820.779,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,298.660,1820.737,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,298.170,1820.757,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19142,297.700,1820.780,2243.013,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.563,1826.509,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.588,1827.233,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.582,1827.834,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.574,1828.475,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.565,1829.116,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.538,1829.735,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.524,1824.729,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.550,1824.089,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.529,1823.429,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.540,1822.789,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.550,1822.129,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18637,296.540,1821.469,2243.005,72.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,305.475,1830.178,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,305.175,1830.182,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,304.876,1830.186,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,304.636,1830.189,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,304.395,1830.192,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,304.135,1830.195,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,303.835,1830.199,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,303.576,1830.222,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2041,303.295,1830.186,2242.477,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3013,298.106,1830.265,2242.412,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3013,298.588,1830.261,2242.412,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3013,299.028,1830.274,2242.412,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3013,299.507,1830.264,2242.412,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3013,300.028,1830.257,2242.412,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,303.432,1826.084,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,302.509,1826.100,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,301.450,1826.047,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,302.462,1825.338,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,303.383,1825.369,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,303.383,1825.369,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(3082,301.442,1825.370,2242.048,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,299.941,1830.210,2241.958,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,299.039,1830.118,2241.958,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,298.248,1830.232,2241.958,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,298.579,1830.426,2241.958,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,299.361,1830.442,2241.958,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,305.411,1830.210,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,305.131,1830.204,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.890,1830.201,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.647,1830.218,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.369,1830.191,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.070,1830.163,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,303.867,1830.183,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,303.626,1830.180,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,303.324,1830.191,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,299.941,1830.210,2241.045,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,299.519,1830.385,2241.045,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,299.142,1830.120,2241.045,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,298.519,1830.333,2241.045,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2043,298.302,1830.130,2241.045,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,300.130,1830.236,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,299.828,1830.229,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,299.549,1830.259,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,299.311,1830.285,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,299.006,1830.259,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,298.702,1830.232,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,298.443,1830.260,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,298.165,1830.291,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,297.902,1830.280,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,303.324,1830.191,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,303.640,1830.200,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,303.938,1830.202,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.242,1830.185,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.502,1830.174,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,304.785,1830.213,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,305.052,1830.183,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2040,305.368,1830.192,2241.047,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18642,307.081,1820.679,2242.115,90.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18642,307.068,1820.818,2242.115,90.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18642,307.076,1820.959,2242.115,90.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18642,306.718,1820.688,2242.115,90.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18642,306.728,1820.809,2242.115,90.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18642,306.737,1820.930,2242.115,90.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.599,1820.755,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.580,1820.880,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.656,1820.968,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11750,307.692,1820.873,2242.111,0.000,0.000,66.300,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2061,301.952,1830.022,2240.820,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.905,1825.560,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.912,1825.280,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.764,1825.567,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.764,1825.567,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.754,1825.465,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.764,1825.567,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.749,1825.304,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18641,303.927,1825.418,2242.373,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,305.870,1820.564,2241.123,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,305.870,1820.564,2241.629,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,305.870,1820.564,2242.066,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,305.870,1820.564,2242.449,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,302.829,1820.603,2241.123,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,299.768,1820.560,2241.123,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,302.829,1820.603,2241.614,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,302.829,1820.603,2242.001,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,302.829,1820.603,2242.392,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,299.768,1820.560,2241.505,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,299.768,1820.560,2241.876,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,299.768,1820.560,2242.267,90.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,301.448,1825.432,2241.511,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,302.013,1825.417,2241.511,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,302.549,1825.463,2241.511,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,303.057,1825.443,2241.511,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,303.623,1825.454,2241.511,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,303.704,1825.968,2241.511,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,303.214,1825.963,2241.511,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,302.767,1825.947,2241.511,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,302.316,1825.956,2241.511,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,301.868,1825.945,2241.511,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2044,301.464,1825.923,2241.511,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.341,1830.035,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.388,1830.312,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.213,1830.355,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.205,1830.069,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.053,1830.373,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.059,1830.063,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,304.844,1830.363,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,304.966,1830.189,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,304.831,1830.057,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.496,1830.080,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1672,305.533,1830.317,2241.940,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2034,303.341,1830.282,2241.872,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2034,303.375,1830.061,2241.872,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2034,303.746,1830.336,2241.872,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2034,303.779,1830.114,2241.872,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18636,306.778,1825.442,2241.541,0.000,0.000,-121.319,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,304.953,1825.442,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19808,312.235,1835.760,2241.397,0.000,0.000,0.419,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2059,312.759,1836.177,2241.405,0.000,0.000,-52.020,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2613,314.542,1836.889,2240.584,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2613,306.967,1836.972,2240.584,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11713,349.534,1827.540,2242.095,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19807,313.245,1836.103,2241.438,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(630,323.375,1842.930,2241.608,0.000,0.000,-49.499,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2616,327.663,1827.540,2242.353,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2612,344.186,1826.059,2242.405,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2611,344.199,1823.746,2242.405,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2197,336.709,1823.790,2240.022,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11706,343.959,1825.160,2240.584,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2000,341.285,1822.820,2240.065,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2000,341.785,1822.820,2240.065,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2196,343.415,1827.269,2241.508,0.000,0.000,-232.259,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2196,339.387,1828.693,2241.281,0.000,0.000,-33.540,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19808,340.112,1828.425,2241.299,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19807,341.294,1828.511,2241.343,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19807,343.781,1828.485,2241.343,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19808,342.739,1828.421,2241.299,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19894,343.916,1824.058,2241.373,0.000,0.000,-122.879,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2190,340.440,1822.321,2241.939,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(630,323.555,1830.016,2241.608,0.000,0.000,-15.719,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2611,334.599,1842.458,2242.405,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11706,333.844,1842.228,2240.584,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11706,350.727,1842.104,2240.584,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11705,341.410,1822.572,2241.466,0.000,0.000,-136.140,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,344.005,1826.054,2241.508,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11706,333.568,1820.487,2240.584,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1714,334.971,1821.450,2240.584,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1715,335.769,1824.680,2240.584,0.000,0.000,-35.159,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1715,334.213,1824.705,2240.584,0.000,0.000,21.359,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19808,335.306,1822.935,2241.527,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2274,335.806,1820.764,2242.568,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2272,334.930,1820.730,2241.705,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2275,333.823,1820.718,2242.364,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2270,335.656,1820.937,2242.116,0.000,0.000,-90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19807,334.511,1823.325,2241.585,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2059,334.267,1823.043,2241.519,0.000,0.000,-24.420,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2059,335.484,1823.012,2241.519,0.000,0.000,102.599,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11745,330.914,1828.589,2241.625,0.000,0.000,95.699,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11749,331.243,1820.477,2241.633,0.000,0.000,22.559,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11749,331.345,1820.484,2241.633,0.000,0.000,3.240,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11736,331.722,1820.485,2241.628,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19824,331.050,1820.463,2242.367,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19623,330.517,1820.498,2241.685,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19623,330.941,1820.507,2241.685,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19624,333.681,1823.123,2240.983,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19352,331.749,1820.496,2241.971,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19352,331.368,1820.495,2241.971,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19331,330.915,1820.462,2242.057,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19330,330.532,1820.468,2242.063,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19099,331.728,1820.509,2241.400,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19100,331.355,1820.507,2241.398,0.000,-90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18636,330.989,1820.562,2241.387,0.000,0.000,89.459,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18636,330.690,1820.573,2241.387,0.000,0.000,89.459,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18636,330.429,1820.563,2241.387,0.000,0.000,89.459,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19355,338.299,1829.045,2238.841,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1210,343.880,1824.473,2240.724,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1775,329.619,1830.028,2241.684,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2886,313.271,1831.554,2241.713,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2886,309.826,1826.886,2241.713,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19172,326.446,1829.559,2242.776,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19174,325.977,1843.495,2242.526,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(11711,351.173,1834.386,2243.396,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2253,337.243,1822.618,2242.203,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2036,304.915,1825.935,2241.524,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2985,300.632,1825.373,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2985,300.123,1825.370,2240.583,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19602,304.164,1830.283,2241.911,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19602,304.670,1830.253,2241.911,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19602,304.417,1830.263,2241.911,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19375,317.520,1831.689,2245.065,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19375,311.523,1831.690,2245.067,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19375,311.523,1822.056,2245.067,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19375,322.023,1822.056,2245.067,0.000,90.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19623,327.940,1822.544,2242.331,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(19623,328.012,1823.403,2242.331,0.000,0.000,90.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18636,327.972,1822.095,2242.315,0.000,0.000,1.859,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(18636,327.985,1822.990,2242.315,0.000,0.000,1.859,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2690,331.220,1829.690,2241.484,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2690,308.623,1820.678,2241.484,0.000,0.000,180.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(361,305.734,1825.763,2241.587,76.000,0.000,25.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(1210,304.364,1826.424,2240.731,0.000,0.000,0.000,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2855,344.682,1827.865,2241.496,0.000,0.000,88.260,-1,-1,-1,50.000,50.000);
	tmpobjid = CreateDynamicObject(2816,342.510,1838.025,2241.056,0.000,0.000,84.060,-1,-1,-1,50.000,50.000);
	
	// ================= [ MINHA CASA ] ======================================== //
	CreateVehicle(520, 493.3885, -1936.0027, 18.1171, 87.7368, -1, -1, 100);
	CreateVehicle(411, 539.3922, -1918.5868, 4.0774, 0.0000, -1, -1, 100);
	CreateVehicle(451, 534.5759, -1918.9362, 4.4330, 0.0000, -1, -1, 100);
	CreateVehicle(506, 528.7139, -1918.6044, 4.5350, 0.0000, -1, -1, 100);
	CreateVehicle(454, 515.4529, -2003.4319, 1.3118, 179.2232, -1, -1, 100);
	CreateDynamicObject(13724, 529.12738, -1920.56177, 6.72353,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18981, 528.95282, -1968.53662, 11.30809,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(18981, 516.60846, -1968.55103, -0.69400,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18981, 503.45587, -1956.53967, -0.69600,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 500.35519, -1956.53772, -0.69400,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 488.36743, -1943.72229, -0.69600,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18981, 485.43353, -1956.52576, -0.69600,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 528.95282, -1980.54968, -0.69600,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 540.95081, -1968.53650, -0.69400,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3361, 523.57874, -1983.77429, 9.71214,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3406, 524.35431, -1988.10327, 5.53119,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3361, 529.21899, -1992.01855, 5.52461,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3361, 525.27625, -1996.42456, 1.48546,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3406, 519.72302, -1996.36841, -1.16940,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3406, 522.55920, -1999.22253, -1.16740,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3406, 520.57312, -1999.22253, -1.16740,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3406, 510.94000, -1996.36841, -1.16940,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3406, 506.99280, -1992.46265, -1.16740,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3406, 506.99280, -2001.25073, -1.16740,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3499, 531.77533, -1956.06714, 9.55235,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14394, 492.50137, -1888.67236, 2.02515,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14394, 500.49551, -1888.67236, 2.02520,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14394, 508.49579, -1888.67236, 2.02520,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14394, 511.03601, -1888.67236, 2.02520,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19371, 488.57080, -1888.59924, 1.12970,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19371, 515.05811, -1888.59924, 1.12970,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(5130, 502.07813, -1905.10608, 5.01027,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(5130, 518.77344, -1925.80469, 8.77862,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(984, 493.89221, -1911.12927, 8.67940,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 485.94562, -1916.08801, 8.73140,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 487.31534, -1911.74829, 8.73902,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 486.44153, -1912.60022, 8.73902,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 510.26489, -1911.12927, 8.67940,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 519.86072, -1911.12927, 8.67940,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 526.30450, -1914.33545, 8.73540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 485.94421, -1920.87634, 8.73140,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 526.31415, -1919.12976, 8.73540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 529.54401, -1922.33374, 8.73540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 503.95404, -1931.44385, 12.42250,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 523.76227, -1931.44824, 12.44497,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 528.52301, -1931.44824, 12.44500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8661, 506.49139, -1921.70288, 8.07670,   0.00000, 180.00000, 180.00000);
	CreateDynamicObject(1609, 510.52051, -1916.09790, 6.39577,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(758, 512.67078, -1921.35193, 2.99958,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(745, 496.12900, -1915.48474, 4.01615,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(898, 499.54440, -1920.96533, -0.66636,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(702, 502.16452, -1920.35803, 5.16661,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(702, 510.47375, -1920.04724, 5.16661,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(702, 506.81177, -1915.68347, 5.16661,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(747, 506.14929, -1915.23450, 4.01610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1601, 506.63187, -1919.24829, 5.93734,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1601, 501.29922, -1916.79907, 6.76587,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1602, 508.36414, -1917.22290, 7.06469,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1603, 503.98743, -1921.53577, 7.49362,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1603, 505.56570, -1921.43726, 7.38956,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1603, 504.81717, -1921.39709, 8.03412,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1603, 505.31909, -1920.63831, 7.70918,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1603, 504.09961, -1920.70923, 7.70918,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1602, 508.75027, -1916.38623, 6.95750,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1602, 509.26605, -1917.30371, 7.38956,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1600, 504.32388, -1919.13965, 5.93730,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1605, 508.93964, -1917.10974, 7.34009,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1605, 500.10336, -1915.86853, 6.61552,   0.00000, 0.00000, 114.97448);
	CreateDynamicObject(1605, 497.94354, -1919.49927, 6.94046,   0.00000, 0.00000, 54.92595);
	CreateDynamicObject(1609, 502.84970, -1918.76416, 6.39577,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(898, 506.66461, -1921.19897, -0.66636,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1601, 507.36429, -1915.39685, 6.76587,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 506.64301, -1913.75781, 8.67940,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 498.64542, -1913.75781, 8.72540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 513.06317, -1916.95959, 8.72540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 495.46011, -1916.95959, 8.72540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 513.06116, -1919.17126, 8.72540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 506.64301, -1922.38342, 8.67940,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 498.64539, -1922.38342, 8.72540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 495.46011, -1919.17126, 8.72540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 515.09814, -1896.88599, 3.49369,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 515.09961, -1893.68323, 3.49369,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 488.53171, -1896.88599, 3.49370,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 488.53171, -1893.68323, 3.49370,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 487.10400, -1904.05798, 4.64790,   0.00000, 0.00000, -81.00000);
	CreateDynamicObject(1360, 484.66693, -1904.85486, 4.64790,   0.00000, 0.00000, -63.00000);
	CreateDynamicObject(1360, 482.57147, -1906.39648, 4.64790,   0.00000, 0.00000, -45.00000);
	CreateDynamicObject(1360, 481.09760, -1908.36853, 4.64790,   0.00000, 0.00000, -27.00000);
	CreateDynamicObject(1360, 480.33051, -1910.79456, 4.64790,   0.00000, 0.00000, -9.00000);
	CreateDynamicObject(1360, 480.11115, -1913.33582, 4.64790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 480.12106, -1915.81616, 4.64790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 480.12762, -1918.37573, 4.64790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 514.04193, -1903.89551, 4.64790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1361, 515.75958, -1904.28882, 4.63790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1361, 516.01434, -1905.27759, 4.63790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1361, 516.58728, -1906.15271, 4.63790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1361, 517.43890, -1906.72974, 4.63790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 519.19177, -1906.74988, 4.64790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 521.67792, -1906.74988, 4.64790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 524.23578, -1906.74988, 4.64790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1361, 516.01434, -1905.27759, 4.63790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, 529.15112, -1901.38733, 3.05770,   -9.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 527.25049, -1901.38733, 3.05370,   -9.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 527.24902, -1894.78516, 2.00640,   -9.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 529.15112, -1894.78516, 2.00840,   -9.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 525.81677, -1889.82324, 2.00640,   0.00000, 90.00000, 17.00000);
	CreateDynamicObject(19454, 530.52820, -1889.95032, 2.00440,   0.00000, 90.00000, -17.00000);
	CreateDynamicObject(19454, 525.81677, -1889.82324, 2.00640,   0.00000, 90.00000, 17.00000);
	CreateDynamicObject(19454, 527.92853, -1890.31604, 2.00840,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19313, 525.45923, -1901.99023, 0.52130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 530.99487, -1901.99023, 0.52130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3934, 491.80637, -1935.85938, 16.22117,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19373, 513.54773, -1894.96179, 2.89920,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(640, 492.57352, -1895.18091, 3.56809,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 492.57150, -1900.40649, 3.56610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 488.93320, -1895.18091, 3.56810,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 488.93121, -1900.40662, 3.56610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(638, 490.90054, -1892.84631, 3.56610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(638, 490.64014, -1892.85010, 3.56810,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19373, 490.65161, -1898.46399, 2.89920,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19373, 490.65161, -1901.92175, 2.89720,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(9833, 490.51459, -1897.61731, 2.98713,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 512.19464, -1895.46655, 3.56809,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19373, 490.65161, -1894.96179, 2.89920,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(640, 513.30737, -1900.82227, 3.56809,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19373, 513.54944, -1898.45630, 2.89920,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19373, 513.54846, -1901.94507, 2.89920,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(638, 513.79535, -1893.13354, 3.56610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3520, 514.43585, -1900.32996, 2.98841,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3520, 513.20416, -1895.65051, 2.98841,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3520, 514.29303, -1895.93616, 2.98840,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18708, 507.67188, -1916.82715, 5.06364,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18708, 500.11197, -1916.34180, 5.06335,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10444, 504.67899, -1922.15906, 0.64804,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(10444, 512.87549, -1928.95581, 0.64800,   0.00000, 90.00000, 180.00000);
	CreateDynamicObject(10444, 502.04727, -1913.87634, 0.64800,   0.00000, 90.00000, -90.00000);
	CreateDynamicObject(10444, 495.92029, -1928.96667, 0.64800,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1649, 510.81400, -1920.62732, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 510.81311, -1917.32336, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 510.80841, -1914.04248, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(10444, 502.35654, -1920.11597, 5.06617,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1649, 506.39749, -1920.62732, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 501.98270, -1920.62732, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 497.56219, -1920.62732, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 506.39749, -1917.32336, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 501.98270, -1917.32336, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 497.56219, -1917.32336, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 506.39749, -1914.04248, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 501.98270, -1914.04248, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 497.56219, -1914.04248, 8.01180,   -90.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 519.24603, -1981.01074, 12.44497,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 531.06183, -1981.00940, 12.39050,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 541.36975, -1968.15588, 12.45050,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 516.04333, -1968.17700, 12.45050,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 503.21573, -1955.36963, 12.45050,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19443, 539.47192, -1982.59045, 11.71720,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1646, 527.40881, -1974.60266, 12.04630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1645, 530.28796, -1974.69263, 12.04625,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 532.14941, -1971.99878, 12.39050,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 525.74493, -1975.20654, 12.44500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1646, 533.45117, -1974.64246, 12.04630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1647, 536.50348, -1974.75293, 12.04630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1642, 533.36310, -1978.68311, 11.80720,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1643, 529.85828, -1978.71204, 11.80718,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1641, 536.48389, -1978.66199, 11.80720,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 528.29065, -1973.97742, 12.09695,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 531.23590, -1974.14636, 12.09695,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 534.25671, -1974.07019, 12.09695,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 537.29858, -1973.97400, 12.09695,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1644, 537.21411, -1973.98889, 12.53258,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1644, 534.22137, -1974.00269, 12.53258,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1644, 531.27692, -1974.10474, 12.53258,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1644, 528.24066, -1973.93811, 12.53258,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1364, 517.27844, -1958.31848, 12.59040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1364, 517.32556, -1965.76416, 12.59040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1536, 501.40140, -1932.03223, 8.07671,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1536, 504.41690, -1931.99866, 8.07470,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19129, 489.10858, -1942.05676, 8.12569,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14391, 484.40491, -1938.74707, 9.11680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18102, 480.57230, -1938.50403, 12.74030,   0.00000, 4.00000, 240.00000);
	CreateDynamicObject(19446, 486.03210, -1936.18872, 11.36490,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19377, 484.81360, -1935.22693, 13.03490,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, 490.07770, -1935.22913, 7.87700,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19446, 486.03210, -1936.18872, 7.19190,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3851, 486.90500, -1936.18933, 8.71130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19421, 483.63971, -1937.61951, 9.02940,   11.00000, 0.00000, 180.00000);
	CreateDynamicObject(19454, 488.64185, -1924.90027, 8.29890,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1825, 486.68451, -1926.75549, 8.07662,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1825, 483.65259, -1928.94348, 8.07662,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1670, 486.62140, -1926.79028, 8.98460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1670, 483.53333, -1928.96533, 8.98460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18654, 487.47217, -1932.50696, 7.78744,   0.00000, 0.00000, 46.49469);
	CreateDynamicObject(18653, 480.13675, -1932.57324, 7.78740,   0.00000, 0.00000, 142.21675);
	CreateDynamicObject(14387, 491.40158, -1934.08777, 12.04811,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 486.88278, -1930.52625, 13.74400,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 483.68201, -1930.50891, 13.74400,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1726, 520.48560, -1948.40356, 15.72514,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1726, 523.44244, -1949.31104, 15.72510,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1819, 520.98932, -1950.91565, 15.72733,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2222, 521.50970, -1950.43311, 16.30310,   0.00000, 0.00000, 12.00000);
	CreateDynamicObject(19450, 520.03522, -1947.69470, 17.26150,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19404, 515.30859, -1951.01978, 17.26150,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19452, 520.03888, -1949.38196, 18.97180,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19452, 520.04065, -1950.88611, 18.96980,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(3440, 524.49152, -1952.32935, 16.63240,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3440, 524.48962, -1952.32874, 12.11614,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 517.60730, -1952.48096, 17.31100,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 522.00262, -1952.48096, 17.31100,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, 524.61145, -1949.92798, 17.31100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2010, 515.91443, -1951.81128, 15.75708,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2010, 523.87378, -1948.21069, 15.75708,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1637, 519.46362, -1980.64893, 12.87119,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1364, 517.27399, -1973.00647, 12.59040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(9915, 553.35266, -1914.10376, -6.00165,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1825, 481.86539, -1932.15405, 13.12333,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1825, 485.55969, -1932.14111, 13.12333,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16151, 483.81314, -1937.96252, 13.43545,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2773, 540.25439, -1956.18274, 12.31610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2773, 533.56445, -1956.18274, 12.31610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2773, 537.01068, -1956.18274, 12.31610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19371, 524.33319, -1938.33496, 13.02989,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19357, 484.94821, -1925.90125, 5.58593,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1231, 525.59863, -1911.53455, 10.73555,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 486.76672, -1912.05396, 10.73555,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 516.22705, -1980.56970, 13.15077,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 531.70984, -1956.07422, 15.22668,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 488.46439, -1935.67761, 13.61676,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 499.02246, -1939.51013, 12.30281,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 514.83057, -1889.93884, 3.37724,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 488.85526, -1889.88794, 3.37724,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 525.65039, -1894.89246, 2.60380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19121, 530.75421, -1894.86377, 2.60380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1290, 565.70178, -1906.17273, 12.43662,   0.00000, 0.00000, 268.25146);
	CreateDynamicObject(3877, 492.12851, -1922.72156, 17.40212,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, 478.80872, -1935.92822, 17.40212,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, 505.50308, -1936.06396, 17.40212,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 506.69370, -1873.92688, 3.25590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8656, 488.29132, -1873.92883, 3.25390,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8656, 548.33539, -1873.92883, 3.25590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8656, 568.21338, -1873.93079, 3.25790,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8656, 582.97321, -1888.69678, 3.25590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 582.97119, -1914.71436, 3.25790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 582.97681, -1914.71643, 1.67790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 582.97321, -1914.71460, -0.58230,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 473.51761, -1888.69507, 3.25190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 473.51761, -1919.22961, 3.25190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 473.51761, -1888.69312, 0.99550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 473.51761, -1919.22961, 0.99550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 473.51761, -1919.22961, -1.24258,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8656, 473.51761, -1888.69312, -1.24260,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3499, 521.87012, -1873.92688, 2.88770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 480.40149, -1873.70337, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 494.46561, -1873.70337, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 514.44769, -1873.70337, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 508.44690, -1873.70532, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3499, 532.69019, -1873.94885, 2.88770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 540.22961, -1873.70337, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 554.20941, -1873.70337, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 568.16913, -1873.70337, 4.72415,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 575.96948, -1873.70532, 4.72420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 583.07062, -1880.66052, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 583.07062, -1894.67041, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 583.07062, -1908.69763, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 583.07568, -1922.63733, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 473.41422, -1880.68030, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 473.41422, -1894.64612, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 473.41422, -1908.60229, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19313, 473.41422, -1922.61548, 4.72420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3520, 489.85516, -1895.99597, 2.98840,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3520, 491.11786, -1896.03406, 2.98840,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3520, 491.60834, -1900.27563, 2.98840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3520, 490.16614, -1900.20166, 2.98840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1568, 521.88568, -1873.92688, 5.26350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1568, 532.68140, -1873.94885, 5.26350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18981, 486.13980, -1903.38281, -0.00620,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2909, 522.54852, -1873.92688, 4.06840,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2909, 531.96222, -1873.94885, 4.06842,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2909, 527.31104, -1873.92883, 6.94580,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3279, 493.61206, -1953.82690, 9.23882,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(18981, 473.42813, -1943.61377, -0.69600,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, 473.41241, -1936.61584, 3.74940,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19129, 483.15921, -1946.10254, 11.73360,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(19454, 475.51682, -1936.06055, 6.98540,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, 475.51682, -1936.06055, -2.61630,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, 476.51505, -1936.05859, -2.61633,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, 476.51501, -1936.05859, 6.98340,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 476.02042, -1922.51868, 4.64790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 476.02039, -1924.86072, 4.64790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 476.45590, -1927.25403, 4.64790,   0.00000, 0.00000, 16.00000);
	CreateDynamicObject(1360, 477.11566, -1929.60974, 4.64790,   0.00000, 0.00000, 16.00000);
	CreateDynamicObject(1360, 477.79266, -1932.04407, 4.64790,   0.00000, 0.00000, 16.00000);
	CreateDynamicObject(7916, 490.75574, -1960.40710, 4.11480,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7916, 495.45245, -1961.54675, 4.11480,   0.00000, 0.00000, 344.26450);
	CreateDynamicObject(16114, 498.53186, -1953.68518, -15.16563,   0.00000, 0.00000, -75.00000);
	CreateDynamicObject(16114, 505.54312, -1953.03955, -15.16563,   0.00000, 0.00000, -75.00000);
	CreateDynamicObject(16114, 505.54312, -1953.03955, -15.16563,   0.00000, 0.00000, -75.00000);
	CreateDynamicObject(16114, 522.54584, -1953.69836, -15.16563,   0.00000, 0.00000, -75.00000);
	CreateDynamicObject(18981, 544.89233, -1942.46045, -0.69600,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18981, 570.98645, -1929.50464, -0.69600,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 556.89740, -1929.50659, -0.69800,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 544.89032, -1944.03333, -0.69800,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18980, 544.36371, -1955.79456, 0.88331,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18981, 532.89191, -1956.55225, -0.69400,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 542.65424, -1955.69604, 12.56110,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(16114, 560.55103, -1929.19629, -15.76912,   0.00000, 0.00000, 311.25293);
	CreateDynamicObject(16114, 581.26947, -1927.88147, -18.59349,   0.00000, 0.00000, 283.31577);
	CreateDynamicObject(16114, 582.35614, -1914.49475, -19.61474,   0.00000, 0.00000, 283.31577);
	CreateDynamicObject(7916, 551.73877, -1945.45068, 3.05133,   0.00000, 0.00000, 12.67037);
	CreateDynamicObject(16114, 563.16058, -1921.39294, -18.22700,   0.00000, 0.00000, 311.25293);
	
	// ====================== [ MINHA MANSÃO ] ================================= //
	CreateVehicle(451, 1026.5809, -304.5703, 73.6646, 0.0000, -1, -1, 100);
	CreateVehicle(506, 1023.5743, -304.5295, 73.7710, 0.0000, -1, -1, 100);
	CreateVehicle(535, 1020.6725, -304.6813, 73.8957, 0.0000, -1, -1, 100);
	CreateVehicle(477, 1017.4749, -304.8675, 73.8957, 0.0000, -1, -1, 100);
	CreateVehicle(429, 1053.3229, -304.5296, 73.8127, 0.0000, -1, -1, 100);
	CreateVehicle(409, 1039.6277, -284.6076, 73.8728, 90.1388, -1, -1, 100);
	CreateVehicle(480, 1056.1382, -304.3021, 73.8950, 0.0000, -1, -1, 100);
	CreateVehicle(541, 1059.0834, -304.3618, 73.7900, 0.0000, -1, -1, 100);
	CreateVehicle(545, 1014.5813, -304.4388, 73.9798, 0.0000, -1, -1, 100);
	CreateVehicle(520, 1043.0149, -363.4534, 76.0827, 271.1319, -1, -1, 100);
	CreateDynamicObject(6959, 1029.40857, -350.68689, 73.16060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7665, 1102.21912, -343.25229, 75.73130,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(6959, 1070.75732, -350.68689, 73.16060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1103.75220, -350.68686, 73.15860,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1103.75220, -310.69580, 73.15860,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1070.75354, -310.69580, 73.16060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1029.40857, -310.69580, 73.16060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1029.40857, -299.54019, 73.15860,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1070.75354, -299.54019, 73.15860,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6959, 1103.75220, -299.54019, 73.15660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7665, 1097.07959, -301.73721, 75.73330,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7665, 1031.33850, -306.87161, 75.73330,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(7504, 1058.42920, -279.07501, 75.73130,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(7504, 1008.68231, -325.05145, 75.73130,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(7033, 1020.99915, -364.49237, 76.97667,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7504, 1008.68536, -325.04889, 74.39445,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(7504, 1124.87451, -325.04141, 74.67540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(7504, 1078.99243, -371.05817, 75.73330,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7504, 1078.99243, -371.05539, 74.67340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7665, 1097.07788, -301.74057, 74.67540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7504, 1058.42957, -279.07700, 74.67540,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(7665, 1031.34033, -306.87375, 74.67540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 1021.16187, -382.48477, 68.99839,   0.00000, 73.00000, 90.00000);
	CreateDynamicObject(7504, 1078.99207, -371.05341, 73.32257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7504, 1124.87341, -325.03979, 73.32260,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(7665, 1097.07642, -301.74200, 73.88620,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7504, 1058.42944, -279.07898, 73.88620,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(7665, 1031.34131, -306.87753, 73.88620,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(6522, 1092.21814, -335.17108, 81.34895,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10444, 1106.86621, -290.67798, 74.17509,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19381, 1074.16797, -354.88208, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1076.02771, -350.35822, 73.12760,   0.00000, 90.00000, -45.00000);
	CreateDynamicObject(19381, 1080.93445, -343.30389, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1080.93445, -326.88449, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1076.02771, -319.02921, 73.12760,   0.00000, 90.00000, 45.00000);
	CreateDynamicObject(19381, 1074.19397, -314.72220, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1063.69128, -314.72220, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1063.66907, -354.88129, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1053.19360, -314.72220, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1055.31738, -334.99936, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(9254, 1037.43359, -296.42822, 73.74050,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18981, 1021.47058, -313.26300, 61.89340,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18981, 1022.42798, -313.26099, 61.89140,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18766, 1050.07849, -313.26300, 71.89690,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1060.03271, -313.26102, 71.89490,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1061.11475, -313.26300, 71.89690,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18981, 1065.75549, -301.26169, 61.89340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19381, 1053.19360, -334.99939, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1053.17371, -354.87970, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(18766, 1065.75549, -282.09641, 69.33750,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19381, 1027.36755, -314.72220, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1016.87012, -314.72220, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1013.64648, -314.72031, 73.12160,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(18765, 1038.85486, -365.81412, 71.83973,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1048.80701, -365.79611, 71.83770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1048.80701, -360.91589, 71.83570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1038.85486, -360.91791, 71.83770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19381, 1042.69421, -354.88129, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1039.70630, -356.81009, 73.12360,   0.00000, 90.00000, 66.00000);
	CreateDynamicObject(2909, 1032.43030, -370.09421, 73.82560,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2909, 1027.00549, -370.04492, 77.48880,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2909, 1018.01202, -370.09421, 73.82560,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2909, 1012.66150, -370.09222, 77.08650,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(16093, 1014.29718, -368.22336, 72.94025,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2909, 1010.43103, -370.09219, 73.82560,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2909, 1020.98651, -370.09442, 72.13351,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(3265, 1022.57788, -371.78476, 72.66386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3265, 1058.80615, -371.51129, 72.66390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3265, 1102.35156, -371.51129, 72.66390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3265, 1124.72852, -371.51129, 72.66390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19381, 1014.45093, -348.87302, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1014.45093, -339.24438, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1014.45111, -329.69849, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1014.44897, -324.28104, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1231, 1034.50549, -313.18088, 75.96118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 1045.34119, -313.27274, 75.96118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 1065.66687, -313.12769, 75.96118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 1009.73962, -313.33087, 75.96118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 1065.78455, -289.21634, 75.96118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 1065.72681, -284.08701, 75.96118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1033.29712, -360.23325, 73.87589,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1033.29712, -362.18161, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1033.29712, -364.30289, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1033.29712, -366.52289, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1033.29712, -368.66061, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1022.72925, -366.82184, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1022.72919, -364.66159, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1022.72919, -362.16061, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1033.29712, -356.87619, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1033.28552, -355.84683, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1033.86670, -355.51047, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1047.84680, -354.51111, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1035.65344, -355.33713, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 1037.73071, -355.33710, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 1039.85095, -355.33710, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 1041.92529, -355.33710, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 1052.92749, -355.33710, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 1050.94458, -355.33710, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1360, 1048.80969, -355.33710, 73.87590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14407, 1045.34839, -353.88135, 71.14081,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1036.54626, -352.85513, 73.52620,   0.00000, 0.00000, -24.00000);
	CreateDynamicObject(18014, 1036.85706, -352.15729, 73.52420,   0.00000, 0.00000, -24.00000);
	CreateDynamicObject(18014, 1039.83533, -350.23383, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1044.47998, -350.23380, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1049.11975, -350.23380, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1053.76367, -350.23380, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1058.40503, -350.23380, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1066.74561, -350.23380, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1070.41528, -348.70911, 73.52620,   0.00000, 0.00000, -45.00000);
	CreateDynamicObject(18014, 1073.69934, -345.42026, 73.52620,   0.00000, 0.00000, -45.00000);
	CreateDynamicObject(18014, 1074.19568, -344.92090, 73.52420,   0.00000, 0.00000, -45.00000);
	CreateDynamicObject(18014, 1075.74683, -341.22342, 73.52620,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1075.74780, -340.78351, 73.52820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1075.91028, -329.40326, 73.52820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1075.91223, -328.28110, 73.52820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1074.39136, -324.57291, 73.52620,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(18014, 1071.11023, -321.29349, 73.52620,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(18014, 1067.41394, -319.74240, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1062.79358, -319.74240, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1058.15320, -319.74240, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1053.51123, -319.74240, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1049.93115, -319.74042, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19381, 1074.16858, -364.53198, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1074.19336, -366.31619, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1063.66907, -364.51199, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1053.17371, -364.51199, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1074.19336, -364.51199, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1063.69055, -366.31619, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1053.17126, -366.33609, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1360, 1054.30420, -356.30035, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1054.30420, -358.42429, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1054.30420, -360.69019, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1054.30420, -362.93231, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14407, 1055.77905, -369.43515, 71.14080,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1360, 1054.30420, -365.01559, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1360, 1054.30420, -366.19949, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1033.86670, -355.51047, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1042.80029, -354.51111, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1055.19287, -366.95654, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, 1052.99060, -356.70834, 74.78198,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, 1034.68457, -369.64725, 74.78198,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1053.70667, -365.64130, 74.84207,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1053.70667, -362.21579, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1053.70667, -358.77319, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1053.70471, -357.75323, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1051.95496, -355.96277, 74.84210,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3850, 1049.05164, -355.96280, 74.84210,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3850, 1041.51953, -355.96280, 74.84210,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3850, 1038.12158, -355.96280, 74.84210,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3850, 1035.76514, -355.96481, 74.84210,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3850, 1034.06018, -357.77347, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1034.06018, -361.20471, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1034.06018, -364.64539, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3850, 1034.06018, -368.10931, 74.84210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3934, 1043.80542, -363.31595, 74.33639,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, 1034.59216, -356.54623, 74.78198,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, 1052.95764, -366.70773, 74.78198,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1058.44128, -330.30261, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1053.84387, -330.30151, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1050.11267, -330.29953, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1048.12122, -332.96881, 73.52620,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1048.12122, -337.56989, 73.52420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18014, 1050.11267, -339.63940, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1053.84387, -339.63940, 73.52220,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18014, 1058.44128, -339.63940, 73.52420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(9915, 1064.36511, -335.73492, 57.62312,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3515, 1050.66821, -332.80414, 72.39498,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3515, 1050.66821, -337.10461, 72.39500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3515, 1058.28308, -335.11520, 72.39500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1304, 1055.77356, -333.79449, 73.08670,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(1305, 1054.10815, -337.10751, 71.85226,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(1303, 1052.80371, -334.83139, 72.99766,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1300, 1020.78406, -360.39114, 73.47625,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1305, 1056.13464, -337.27853, 71.73352,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(1305, 1053.91052, -332.51816, 71.73350,   0.00000, 0.00000, -127.00000);
	CreateDynamicObject(1303, 1055.68018, -332.12534, 73.04350,   0.00000, 0.00000, -62.00000);
	CreateDynamicObject(19381, 1071.37341, -305.08679, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1081.87292, -305.08679, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1092.37793, -305.08679, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1102.87683, -305.08679, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1112.71814, -305.08679, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1102.87683, -314.72220, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1112.71814, -314.72220, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(18766, 1119.63281, -282.03503, 74.00385,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1109.70618, -282.01312, 74.00180,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1089.72400, -282.01511, 74.00180,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1119.62976, -299.50430, 72.00390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1119.62976, -289.50879, 72.00590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1119.64636, -302.42874, 72.00190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1109.70618, -302.42871, 72.00190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1099.71057, -282.01352, 74.00380,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1099.68518, -302.42871, 72.00190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1089.72400, -302.42871, 72.00190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1086.86963, -302.42871, 72.00390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1086.86963, -284.48810, 72.00390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18765, 1086.87146, -294.16656, 72.00190,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10444, 1106.86621, -290.67798, 73.96149,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(10444, 1106.86621, -290.67798, 73.60580,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18766, 1099.71069, -284.02020, 71.99360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1089.72400, -284.02219, 71.99360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1109.70618, -284.02219, 71.99360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14387, 1080.58594, -304.39246, 73.47243,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18766, 1085.07605, -301.66119, 71.99360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1085.04224, -306.86502, 71.99360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1408, 1057.48853, -355.23199, 73.78610,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1408, 1062.89490, -355.23398, 73.78610,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1408, 1072.17664, -355.23199, 73.78610,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1408, 1077.62732, -355.23199, 73.78610,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1408, 1077.62732, -365.30551, 73.78610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 1065.42224, -355.41736, 75.64046,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 1069.49146, -355.48233, 75.64046,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1568, 1080.69897, -336.77841, 71.08520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1568, 1080.69897, -333.57889, 71.08520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1568, 1079.32947, -331.87198, 71.08520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1568, 1079.32947, -338.28510, 71.08520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2773, 1080.36841, -336.44379, 73.63000,   0.00000, 0.00000, -63.00000);
	CreateDynamicObject(2773, 1080.23315, -333.88254, 73.63004,   0.00000, 0.00000, 63.00000);
	CreateDynamicObject(3660, 1019.27753, -314.48972, 75.70704,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3660, 1022.78717, -314.49121, 75.70500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3660, 1009.88995, -323.55423, 75.70500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3660, 1009.89001, -343.75900, 75.70500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3660, 1009.88812, -334.94620, 75.70700,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(640, 1029.95166, -319.40170, 73.75480,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(736, 1059.47156, -332.19193, 83.75817,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(736, 1059.49329, -338.08560, 83.75820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(737, 1014.44928, -348.87299, 73.53200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(737, 1014.44775, -339.26431, 73.53200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(737, 1014.44781, -329.67850, 73.53200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(737, 1014.44781, -320.08051, 73.53200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1024.57666, -319.40121, 73.75480,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(640, 1022.35608, -319.40170, 73.75280,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(640, 1019.92133, -321.75449, 73.75480,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1019.91931, -327.09488, 73.75280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1019.92133, -332.31229, 73.75480,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1019.92328, -337.57040, 73.75280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1019.92133, -342.82971, 73.75480,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1019.92328, -348.12329, 73.75680,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, 1019.92133, -351.05688, 73.75480,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3660, 1057.88330, -314.49121, 75.70500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3660, 1066.99451, -305.95856, 75.70500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19381, 1067.40796, -295.45425, 73.12560,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, 1067.40796, -293.65451, 73.12360,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(3660, 1066.99255, -298.71851, 75.70300,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3932, 1080.33459, -361.49606, 74.05310,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3462, 1078.83936, -361.45383, 74.02986,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1078.59070, -359.53693, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1361, 1078.51721, -363.41980, 73.87590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1303, 1078.15308, -360.28424, 72.60239,   4.00000, 35.00000, 0.00000);
	CreateDynamicObject(1303, 1076.73401, -361.09824, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1078.21045, -361.00305, 72.60240,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1079.27600, -360.97809, 72.60240,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1078.80774, -360.35590, 72.60240,   4.00000, 35.00000, -215.00000);
	CreateDynamicObject(1303, 1078.04736, -359.06744, 72.60240,   4.00000, 35.00000, -215.00000);
	CreateDynamicObject(1303, 1078.11133, -359.68445, 72.60240,   4.00000, 35.00000, -215.00000);
	CreateDynamicObject(1303, 1078.45667, -360.00040, 72.60240,   4.00000, 35.00000, -215.00000);
	CreateDynamicObject(1303, 1078.41101, -362.02554, 72.60240,   4.00000, 35.00000, -215.00000);
	CreateDynamicObject(1303, 1077.95361, -361.48257, 72.60240,   4.00000, 35.00000, -215.00000);
	CreateDynamicObject(1303, 1078.10486, -362.59225, 72.60240,   4.00000, 35.00000, -113.00000);
	CreateDynamicObject(1303, 1079.08386, -362.37723, 72.60240,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1078.93884, -362.94211, 72.60240,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1078.02893, -363.36966, 72.60240,   4.00000, 35.00000, -113.00000);
	CreateDynamicObject(1303, 1078.59351, -363.95850, 72.60240,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1075.62366, -360.68506, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1074.59546, -360.26447, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1073.66162, -359.75702, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1072.64490, -359.24649, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1408, 1072.17664, -365.30551, 73.78610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1408, 1069.54260, -362.58130, 73.78610,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1303, 1071.58752, -358.75394, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1070.42712, -358.31635, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.96387, -355.91086, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.94922, -356.21054, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.90479, -356.70905, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.88770, -357.46924, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.88428, -357.94980, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.83301, -358.58810, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1303, 1069.87793, -359.31119, 72.57395,   -26.00000, 13.00000, 2.00000);
	CreateDynamicObject(1408, 1057.48853, -360.72650, 73.78610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1408, 1062.89490, -360.72650, 73.78610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1408, 1065.46802, -357.94678, 73.78610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(869, 1057.29163, -358.81543, 73.61074,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(869, 1059.87146, -358.97501, 73.61074,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(869, 1062.19031, -358.83197, 73.61074,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(869, 1063.37085, -358.88629, 73.61074,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(870, 1063.76086, -356.86462, 73.61070,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(870, 1061.59961, -356.73526, 73.61070,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(870, 1059.45911, -356.70563, 73.61070,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(870, 1057.21899, -356.61667, 73.61070,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(870, 1056.03967, -356.74234, 73.61070,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(1303, 1078.91565, -355.91550, 73.18230,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1077.87451, -355.88293, 73.18230,   4.00000, 35.00000, -55.00000);
	CreateDynamicObject(1303, 1077.12305, -356.83469, 73.18230,   4.00000, 35.00000, 18.00000);
	CreateDynamicObject(1303, 1077.31055, -357.97678, 73.18230,   4.00000, 35.00000, 55.00000);
	CreateDynamicObject(1303, 1079.12073, -357.11694, 72.74230,   4.00000, 35.00000, 55.00000);
	CreateDynamicObject(1303, 1078.32031, -357.12805, 72.74230,   4.00000, 35.00000, 55.00000);
	CreateDynamicObject(1303, 1079.01294, -357.83585, 72.74230,   4.00000, 35.00000, 55.00000);
	CreateDynamicObject(1303, 1078.25244, -357.84738, 72.74230,   4.00000, 35.00000, 55.00000);
	CreateDynamicObject(9831, 1081.75232, -357.91315, 74.03336,   40.00000, 0.00000, 91.00000);
	CreateDynamicObject(16151, 1123.33850, -285.23907, 74.82149,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(13206, 1120.48804, -287.11639, 74.50520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14387, 1121.29700, -308.70856, 73.47240,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(18766, 1118.47620, -304.53513, 71.99360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18766, 1124.09802, -304.50986, 71.99360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1408, 1079.25244, -300.45825, 73.78610,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1408, 1072.54749, -297.21533, 73.78610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1408, 1072.54810, -291.76260, 73.78610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1408, 1069.91235, -289.07675, 73.78610,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(970, 1081.97180, -300.03830, 74.95850,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1081.97180, -295.89981, 74.95850,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1081.97180, -291.75970, 74.95850,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1081.97180, -287.63919, 74.95850,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1081.97180, -283.48410, 74.95850,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1081.96985, -281.08374, 74.95850,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1084.10486, -307.17938, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1088.24817, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1092.37024, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1096.47437, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1100.57629, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1104.67664, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1108.78882, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1112.89050, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1116.63245, -307.17941, 74.95850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1646, 1084.14197, -295.47284, 74.74030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1646, 1084.16797, -292.38354, 74.74030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1646, 1084.15564, -289.06042, 74.74030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1646, 1084.18896, -285.59912, 74.74030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2725, 1083.62708, -294.68735, 74.72118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 1083.58630, -291.56445, 74.72118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 1083.60718, -288.15060, 74.72118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2725, 1083.53760, -284.57333, 74.72118,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1825, 1101.51184, -305.20145, 74.50127,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1825, 1093.24097, -305.36087, 74.50127,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(642, 1093.09253, -305.36566, 75.84206,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(642, 1101.36316, -305.21567, 75.84206,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14387, 1092.88159, -296.31424, 73.47240,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(14387, 1092.49634, -285.94302, 73.47240,   0.00000, 0.00000, -45.00000);
	CreateDynamicObject(1297, 1013.60980, -283.87189, 76.58623,   0.00000, 0.00000, 142.00000);
	CreateDynamicObject(1297, 1013.51715, -308.25211, 76.58620,   0.00000, 0.00000, -142.00000);
	CreateDynamicObject(1297, 1060.41858, -307.87665, 76.58620,   0.00000, 0.00000, -42.00000);
	CreateDynamicObject(1297, 1060.31812, -283.90411, 76.58620,   0.00000, 0.00000, 42.00000);
	CreateDynamicObject(1726, 1117.82959, -335.59061, 77.08700,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1727, 1118.99683, -332.79517, 77.08729,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1727, 1119.99341, -336.32800, 77.08730,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1822, 1119.08325, -335.06119, 77.08807,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2069, 1118.19104, -332.77902, 77.11991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10009, 1112.49023, -308.57184, 74.86290,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(10009, 1112.48218, -318.87247, 74.86290,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2964, 1110.66248, -353.58347, 77.08640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3004, 1110.90491, -353.87888, 77.98367,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2965, 1110.17505, -353.75629, 77.98390,   0.00000, 0.00000, 0.00000);
	return 1;
}

public OnGameModeExit()
{
    new p = GetMaxPlayers();
    for (new i=0; i < p; i++){
    	SetPVarInt(i, "laser", 0);
     	RemovePlayerAttachedObject(i, 0);
    }
	for(new i = 0; i < HighestID; i++)
	{
	    if(IsPlayerConnected(i))
        {
            SalvarPlayer(i);
        }
	}
	DOF2_Exit();
    SaveHouses();
    new logString[128];
    format(logString, sizeof logString, "----------- SISTEMA FINALIZADO -----------");
    WriteLog(LOG_SYSTEM, logString);

    for(new house = 1; house < MAX_HOUSES; house++)
        if(houseVehicle[house][vehicleModel] != 0)
            DestroyVehicle(houseVehicle[house][vehicleHouse]);
 	KillTimer(Timer);
    mysql_close(conectDB);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    TogglePlayerSpectating(playerid, true);
	new opening = random(3);
	switch(opening)
	{
		case 0:
		{
			InterpolateCameraPos(playerid, 2158.2129,-1139.6005,66.4812, 2231.6226,-943.3710,111.9578, 25000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 2158.2129,-1139.6005,66.4812, 2231.6226,-943.3710,111.9578, 25000, CAMERA_MOVE);
		}
		case 1:
		{
			InterpolateCameraPos(playerid, 2158.2129,-1139.6005,66.4812, 2231.6226,-943.3710,111.9578, 25000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 2158.2129,-1139.6005,66.4812, 2231.6226,-943.3710,111.9578, 25000, CAMERA_MOVE);
		}
		case 2:
		{
			InterpolateCameraPos(playerid, 2158.2129,-1139.6005,66.4812, 2231.6226,-943.3710,111.9578, 25000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 2158.2129,-1139.6005,66.4812, 2231.6226,-943.3710,111.9578, 25000, CAMERA_MOVE);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_INICIO, DIALOG_STYLE_LIST, "{FFFFFF}Seja bem vindo a {FF0000}GTB Torcidas", "{FF0000}¤ {FFFFFF}Registrar\n{FF0000}¤ {FFFFFF}Logar\n{FF0000}¤ {FFFFFF}Esqueci minha senha {FF0000}(Desativado Temp.)\n{FF0000}¤ {FFFFFF}Sair", "Selecionar", "");
	return 1;
}

public OnPlayerConnect(playerid)
{
	// =========================== [ CHECAR BANIMENTOS ] ======================= //
	new ip[24],Query[128];
	GetPlayerIp(playerid, ip, sizeof ip);
	mysql_format(conectDB, Query, sizeof(Query), "SELECT * FROM `banlist` WHERE(`Name`='%s' OR `IP`='%s')", Nome(playerid), ip);
	mysql_tquery(conectDB, Query, "OnPlayerBanned", "d", playerid);
	for(new i=0; i < 30; i++)
	{
	    SendClientMessage(playerid, COR_BRANCO,""); /* Equivale a 10 SendClientMessage VÁZIOS */
	}
	SendClientMessage(playerid, COR_ERRO,">> --------------------------------------------------------------------------------------- <<");
	SendClientMessage(playerid, COR_ERRO,".: [BR/PT] GTB Torcidas - Oficial [v1.0]");
	SendClientMessage(playerid, COR_BRANCO,".: Seja bem vindo ao servidor GTA Torcidas Brasil.");
	SendClientMessage(playerid, COR_BRANCO,".: Use {FF0000}'creditos'{FFFFFF} para ver quem elaborou o gamemode.");
	SendClientMessage(playerid, COR_BRANCO,".: Acesse: {FF0000}www.equipegtb.com");
	SendClientMessage(playerid, COR_BRANCO,".: Curta nossa página no Facebook: {FF0000}www.fb.com/gtboficial");
	SendClientMessage(playerid, COR_BRANCO,".: Não fazemos apologia ao crime.");
	SendClientMessage(playerid, COR_BRANCO,".: Paz nas Torcidas do Brasil.");
	SendClientMessage(playerid, COR_ERRO,">> --------------------------------------------------------------------------------------- <<");
	// ===================== [ ID ] ============================================ //
	if(playerid == HighestID)
	{
		new highID=0;
		for(new x=0; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x))
			{
				if(x>highID) {
					highID = x;
				}
			}
		}
		HighestID = highID;
	}
	
	// ======================= [ Textdraw's ] ================================== //
    TextDrawHideForPlayer(playerid, Textdraw[0]);
    TextDrawHideForPlayer(playerid, Textdraw[1]);
    TextDrawHideForPlayer(playerid, Textdraw[2]);
    TextDrawHideForPlayer(playerid, Textdraw[3]);
    TextDrawHideForPlayer(playerid, Data);
    TextDrawHideForPlayer(playerid, Hora);
    TextDrawShowForPlayer(playerid, Box[0]);
    TextDrawShowForPlayer(playerid, Box[1]);
    TextDrawShowForPlayer(playerid, Box[2]);
    TextDrawShowForPlayer(playerid, Box[3]);
    TextDrawShowForPlayer(playerid, Entrada[0]);
    TextDrawShowForPlayer(playerid, Entrada[1]);
    TextDrawShowForPlayer(playerid, Entrada[2]);
    
    // ======================= [ Minha Casa ] ============================= //
	RemoveBuildingForPlayer(playerid, 3778, 553.3516, -1875.0000, 4.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3778, 498.4844, -1875.0000, 4.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 3615, 498.4844, -1875.0000, 4.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 3615, 553.3516, -1875.0000, 4.7891, 0.25);
	
	// =================== [ Minha Mansão ] ==================================== //
	RemoveBuildingForPlayer(playerid, 3295, 1099.1172, -358.4766, 77.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 3347, 1114.2969, -353.8203, 72.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3347, 1107.5938, -358.5156, 72.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3376, 1070.4766, -355.1641, 77.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 3404, 1019.3828, -300.2422, 72.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3404, 1045.5625, -300.6016, 72.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1012.2891, -282.5391, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1023.4219, -279.9063, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1503, 1019.3203, -282.7891, 73.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1047.3125, -280.3359, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1059.2266, -281.2656, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1082.9922, -283.6797, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 694, 1130.1719, -278.6172, 70.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 13451, 1146.1406, -369.1328, 49.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.7969, -385.0078, 71.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1042.9219, -386.4531, 70.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1042.9688, -374.4766, 72.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 3425, 1015.0938, -361.1016, 84.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.6719, -361.6250, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1042.8125, -368.1953, 73.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.6250, -349.8984, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.5234, -326.4453, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.4766, -314.7188, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.4297, -302.9922, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1007.3828, -291.2578, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3402, 1019.3828, -300.2422, 72.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1083.6641, -368.5313, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1071.9375, -368.5156, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1060.2109, -368.4922, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3375, 1070.4766, -355.1641, 77.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1094.4141, -367.9688, 72.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1092.7109, -327.0625, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1095.3984, -329.8203, 73.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1095.3828, -327.4766, 73.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1092.7969, -321.4844, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1092.9063, -315.9688, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1093.1953, -299.2969, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 3402, 1045.5625, -300.6016, 72.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 13206, 1072.9531, -289.1797, 72.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1093.3047, -293.7813, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1096.1563, -291.2656, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 656, 1096.6250, -294.4141, 72.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3286, 1099.1172, -358.4766, 77.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 3175, 1107.5938, -358.5156, 72.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, 1107.1172, -368.5703, 73.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3253, 1106.6406, -319.8750, 73.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1106.4922, -330.0234, 73.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1100.9141, -329.9297, 73.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1106.5469, -328.1641, 73.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1101.2891, -329.5313, 72.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3250, 1110.2422, -298.9453, 73.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1101.6719, -291.3750, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1107.2656, -291.4609, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 672, 1097.4688, -314.2109, 73.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3175, 1114.2969, -353.8203, 72.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1117.5781, -330.2109, 73.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1112.0000, -330.1250, 73.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 656, 1116.4453, -326.7578, 72.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1112.7813, -291.5703, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1118.3750, -291.6641, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1120.4297, -327.7656, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1121.0234, -294.5234, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1120.6250, -316.7344, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1120.9297, -300.1172, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1120.8203, -305.6328, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1120.7344, -311.2188, 73.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 1120.5391, -322.2500, 73.5703, 0.25);
	
	// ======================= [ Variaveis ] =================================== //
	SetPlayerColor(playerid, 0xFFFFFFFF);
	Logado[playerid] = false;
	Player[playerid][pAdmin] = 0;
	Player[playerid][pPres] = 0;
	Player[playerid][pvPres] = 0;
	Player[playerid][pOrg] = 0;
	Player[playerid][pPux] = 0;
	Player[playerid][pHelper] = 0;
	Player[playerid][pBope] = 0;
	Player[playerid][pChoque] = 0;
	Player[playerid][Cash] = 0;
	Player[playerid][Vip] = 0;
	Player[playerid][EmTrabalho] = false;
	Player[playerid][Score] = 0;
	Player[playerid][pCocaina] = 0;
	Player[playerid][pMaconha] = 0;
	Player[playerid][pSinalizadores] = 0;
	Player[playerid][pMP3] = 0;
	Player[playerid][pMateriais] = 0;
	Player[playerid][pFogos] = 0;
	Player[playerid][BlockTR] = false;
	Player[playerid][BlockIR] = false;
	Player[playerid][BlockPM] = false;
	Player[playerid][CityAdmin] = false;
	Player[playerid][ChatTorcida] = false;
	Player[playerid][DelayAsay] = false;
	Player[playerid][TempoPreso] = 0;
	VeiculoVeh[playerid] = 0;
	tentativaDeLogin[playerid] = 0;
	Player[playerid][pIniciante] = 0; // ZERA A VARIÁVEL
	CP[playerid] = 0;
	Player[playerid][TempoPreso] = 0;
	Player[playerid][NoHospital] = false;
	LimiteReparar[playerid] = 0;
	Player[playerid][gSpectateID] = INVALID_PLAYER_ID;
	Player[playerid][LastReport] = INVALID_PLAYER_ID;
 	Player[playerid][pRpt] = 0;
 	Player[playerid][DelayReport] = false;
 	Player[playerid][pMatou] = 0;
 	Player[playerid][pMorreu] = 0;
 	PresoADM[playerid] = 0;
 	Preso[playerid] = 0;
	Player[playerid][sutotal] = 0;
	Player[playerid][suabatidos] = 0;
	Player[playerid][Passagens] = 0;
	Player[playerid][pRpt] = 0;
	Player[playerid][DuelInvite] = INVALID_PLAYER_ID;
	Player[playerid][InDuel] = false;
	Player[playerid][PanosTomado] = 0;
	Player[playerid][PanosPerdido] = 0;
	Player[playerid][BermudasTomada] = 0;
	Player[playerid][BermudasPerdida] = 0;
	CrieiTapete[playerid] = 0;
	Equipamentos[playerid] = 0;
	Player[playerid][Cone] = 0;
	Player[playerid][pBarreira] = 0;
	Player[playerid][Grade] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
 	new string[60];
	switch(reason)
	{
		case 0:
		{
			format(string, sizeof(string), "** %s Saiu do servidor (Crash/Conexão).", Nome(playerid));
		}
		case 1:
		{
			format(string, sizeof(string), "** %s Saiu do servidor (Conta Própria).", Nome(playerid));
		}
		case 2:
		{
			format(string, sizeof(string), "** %s Saiu do servidor (Kikado/Banido).", Nome(playerid));
		}
	}
	MensagemPerto(playerid, 0xFFFFD2AA, string, 20);
	
	if(playerid == HighestID)
	{
	    new highID=0;
		for(new x=0; x < MAX_PLAYERS; x++)
		{
	    	if(IsPlayerConnected(x))
	    	{
	    	    if(x>highID)
				{
	    	        highID = x;
	    	    }
	    	}
		}
		HighestID = highID;
	}

	if(Player[playerid][InDuel] == true && Player[Player[playerid][DuelID]][InDuel] == true)
	{

        new type[26], str[128];
		if(Player[playerid][DuelInviteType] == 1) type = "Camisa";
		else if(Player[playerid][DuelInviteType] == 2) type = "Bermuda";

		format(str, sizeof(str),"[APOSTA] O player %s perdeu uma '%s' de sua torcida para %s.", Nome(playerid), type, Nome(Player[playerid][DuelID]));
	    SendClientMessageToAll(COR_USOCORRETO, str);

        if(Player[playerid][DuelInviteType] == 1)
	    {
	    	Player[Player[playerid][DuelID]][PanosTomado] ++;
			Player[playerid][PanosPerdido] ++;
	  		Player[playerid][Camisas] --;
	    }
	    else if(Player[playerid][DuelInviteType] == 2)
	    {
	    	Player[Player[playerid][DuelID]][BermudasTomada] ++;
	  		Player[playerid][BermudasPerdida] ++;
	   		Player[playerid][Bermudas] --;
	    }

        Player[playerid][InDuel] = false;
        Player[Player[playerid][DuelID]][InDuel] = false;

        Player[playerid][DuelID] = INVALID_PLAYER_ID;
        Player[Player[playerid][DuelID]][DuelID] = INVALID_PLAYER_ID;
	}
	
    Logado[playerid] = false;
   	if(Player[playerid][Cone] > 0) DestroyObject(Player[playerid][Cone]);
   	if(Player[playerid][pBarreira] > 0) DestroyObject(Player[playerid][pBarreira]);
   	if(Player[playerid][Grade] > 0) DestroyObject(Player[playerid][Grade]);
   	DestroyVehicle(VeiculoVeh[playerid]);
   	VeiculoVeh[playerid] = 0;
 	SetPVarInt(playerid, "laser", 0);
    RemovePlayerAttachedObject(playerid, 0);
   	if(Equipamentos[playerid] == 1)
	{
		RemovePlayerAttachedObject(playerid,3);
	}
    new house = GetHouseByOwner(playerid);
    if(houseCarSet[playerid])
    {
        new
            logString[400];

        GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
        format(logString, sizeof logString, "O jogador %s[%d], se desconectou e estava definindo o carro da casa %d", playerName, playerid, house);
        WriteLog(LOG_SYSTEM, logString);
        DestroyVehicle(vehicleHouseCarDefined[house]);
        adminCreatingVehicle[playerid] = false;
    }
   	SalvarPlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	// ============= [ Variaveis ] ============= //
    Logado[playerid] = true;
	Player[playerid][EmTrabalho] = false;
    SetPlayerHealth(playerid, 100);
	SetPlayerWantedLevel(playerid, Player[playerid][Procurado]);
    
    // ============= [ Textdraw's ] ============== //
    TextDrawShowForPlayer(playerid, Textdraw[0]);
    TextDrawShowForPlayer(playerid, Textdraw[1]);
    TextDrawShowForPlayer(playerid, Textdraw[2]);
    TextDrawShowForPlayer(playerid, Textdraw[3]);
    TextDrawShowForPlayer(playerid, Hora);
    TextDrawShowForPlayer(playerid, Data);
    TextDrawHideForPlayer(playerid, Box[0]);
    TextDrawHideForPlayer(playerid, Box[1]);
    TextDrawHideForPlayer(playerid, Box[2]);
    TextDrawHideForPlayer(playerid, Box[3]);
    TextDrawHideForPlayer(playerid, Entrada[0]);
    TextDrawHideForPlayer(playerid, Entrada[1]);
    TextDrawHideForPlayer(playerid, Entrada[2]);

  	if(Player[playerid][ReloadPlayer] == true)
	{
		Player[playerid][ReloadPlayer] = false;
		SetTimerEx("LoadVariables",300,false, "i",playerid);
	}
	
    if(PresoADM[playerid] == 1)
    {
  		SetPlayerPos(playerid, 197.3364,174.0059,1003.0234+1);
		SetPlayerInterior(playerid, 3);
		SendClientMessage(playerid, COR_NEGATIVO, "[PRESO]: Você está preso. Digite /presos para saber o tempo restante.");
		Player[playerid][NoHospital] = false;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
		SetPlayerSkin(playerid, 268);
		reduzirTempo(playerid);
		return 1;
	}
    if(Preso[playerid] == 1)
    {
  		SetPlayerPos(playerid, 197.3364,174.0059,1003.0234+1);
		SetPlayerInterior(playerid, 3);
		SendClientMessage(playerid, COR_NEGATIVO, "[PRESO]: Você está preso. Digite /presos para saber o tempo restante.");
		Player[playerid][NoHospital] = false;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
		SetPlayerSkin(playerid, 268);
		reduzirTempo(playerid);
		return 1;
	}

	// ============== [ Spawn ] =============== //
	new t = Player[playerid][pTorcida];
	if(t > 0)
    {
		SetPlayerPos(playerid,Torcidas[t][Spawn][0], Torcidas[t][Spawn][1],Torcidas[t][Spawn][2]);
		SetPlayerInterior(playerid, 0);
		SetPlayerColor(playerid, Torcidas[t][tCor]);
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
    if(Player[playerid][PegouKit] == true) LiberarKit(playerid);
	Player[killerid][pMatou]++;
	Player[playerid][pMorreu]++;
	GivePlayerMoney(killerid, 100);

	if(Player[killerid][pBope]>=1 || Player[killerid][pChoque]>=1)
	{
		if(GetPlayerWantedLevel(playerid) >= 1)
		{
			Preso[playerid] = 1;
			Player[killerid][suabatidos]++;
			Player[playerid][Passagens]++;
			new string[500];
   			format(string, sizeof(string), "{33AA33}HQ: Todas as unidades: Polícial {ffffff}%s{33AA33} completou uma sessão.", Nome(killerid));
			SendMessageToCops(-1, string);
			format(string, sizeof(string), "{33AA33}HQ: {ffffff}%s{33AA33} foi processado, preso no Presídio.", Nome(playerid));
			SendMessageToCops(-1, string);

			format(string, sizeof(string), "<< O procurado da justiça %s foi preso pelo Polícial %s >>", Nome(playerid), Nome(killerid));
			SendClientMessageToAll(COR_NEGATIVO,string);
			GameTextForPlayer(playerid, "~r~Preso!", 2500, 3);
			GameTextForPlayer(killerid, "~r~Suespeito Abatido", 2500, 3);

			if(GetPlayerWantedLevel(playerid) == 1){Player[playerid][TempoPreso] = 300;}
			if(GetPlayerWantedLevel(playerid) == 2){Player[playerid][TempoPreso] = 360;}
			if(GetPlayerWantedLevel(playerid) == 3){Player[playerid][TempoPreso] = 420;}
			if(GetPlayerWantedLevel(playerid) == 4){Player[playerid][TempoPreso] = 480;}
			if(GetPlayerWantedLevel(playerid) == 5){Player[playerid][TempoPreso] = 540;}
			if(GetPlayerWantedLevel(playerid) >= 6){Player[playerid][TempoPreso] = 900;}
		}
	}
    
	if(IsPlayerConnected(playerid))
	{
		if(Player[playerid][InDuel] == true && Player[killerid][InDuel] == true)
		{
		    if(Player[playerid][DuelID] == killerid && Player[killerid][DuelID] == playerid)
		    {
		        new type[26], str[128];
		        if(Player[playerid][DuelInviteType] == 1) type = "Camisa";
		        else if(Player[playerid][DuelInviteType] == 2) type = "Bermuda";

				format(str, sizeof(str),"[APOSTA] O player %s perdeu uma '%s' de sua torcida para %s.", Nome(playerid), type, Nome(killerid));
		        SendClientMessageToAll(COR_USOCORRETO, str);
		        Player[playerid][DuelID] = INVALID_PLAYER_ID;
		        Player[killerid][DuelID] = INVALID_PLAYER_ID;
		        Player[playerid][InDuel] = false;
		        Player[killerid][InDuel] = false;

		        if(Player[playerid][DuelInviteType] == 1)
		        {
		            Player[killerid][PanosTomado] ++;
		        	Player[playerid][PanosPerdido] ++;
		        	Player[playerid][Camisas]--;
		        }
		        else if(Player[playerid][DuelInviteType] == 2)
		        {
		            Player[killerid][BermudasTomada] ++;
		        	Player[playerid][BermudasPerdida] ++;
		        	Player[playerid][Bermudas]--;
		        }
		    }
		}
		else
		{
			if(Player[playerid][InDuel] == true)
			{
			    new type[26], str[128];
		        if(Player[playerid][DuelInviteType] == 1) type = "Camisa";
		        else if(Player[playerid][DuelInviteType] == 2) type = "Bermuda";

				format(str, sizeof(str),"[APOSTA] O player %s perdeu uma '%s' de sua torcida para %s.", Nome(playerid), type, Nome(Player[playerid][DuelID]));
			    SendClientMessageToAll(COR_USOCORRETO, str);

                if(Player[playerid][DuelInviteType] == 1)
		        {
		            Player[Player[playerid][DuelID]][PanosTomado] ++;
		        	Player[playerid][PanosPerdido] ++;
		        	Player[playerid][Camisas] --;
		        }
		        else if(Player[playerid][DuelInviteType] == 2)
		        {
		            Player[Player[playerid][DuelID]][BermudasTomada] ++;
		        	Player[playerid][BermudasPerdida] ++;
		        	Player[playerid][Bermudas] --;
		        }

				Player[playerid][DuelID] = INVALID_PLAYER_ID;
		        Player[Player[playerid][DuelID]][DuelID] = INVALID_PLAYER_ID;
		        Player[playerid][InDuel] = false;
		        Player[Player[playerid][DuelID]][InDuel] = false;
			}
		}
	}
    
    new string[126];
    format(string, sizeof(string),"Você matou %s da %s.", Nome(playerid), Torcidas[Player[playerid][pTorcida]][tNome]);
    SendClientMessage(killerid, -1, string);
    if(Player[killerid][pBope] >= 1 || Player[killerid][pChoque] >= 1 && Player[killerid][EmTrabalho] == true)
    {
    	format(string, sizeof(string),"Você foi morto por %s da Policia.", Nome(killerid));
	    SendClientMessage(playerid, -1, string);
	}
	else{
    format(string, sizeof(string),"Você foi morto por %s da %s.", Nome(killerid), Torcidas[Player[killerid][pTorcida]][tNome]);
    SendClientMessage(playerid, -1, string);
    }

	for(new x = 0; x < MAX_PLAYERS; x++)
	{
 		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Player[x][gSpectateID] == playerid)
		 {
              AdvanceSpectate(x);
		}
  	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(Logado[playerid] == false) return 0;

	new t = Player[playerid][pTorcida];
	if(text[0] == '!' && t > 0)
	{
	    if(Player[playerid][ChatTorcida] == true) {
	        SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está com o chat bloqueado!");
			return 0;
		}
		new str[128];
		new cor[24];
		format(cor, 24,"%s",Torcidas[t][tCor]);
		format(str, sizeof(str),"[Chat %s] %s (%d): {FFFFFF}%s", Torcidas[t][tNome], Nome(playerid), playerid, text[1]);
		SendMessageToTorc(t, Torcidas[t][tCor], str);
		return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new house = GetHouseByOwner(playerid);
    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
    {
        if(houseCarSet[playerid])
        {
            counting[playerid] = true;
            SendClientMessage(playerid, COLOR_WARNING, "* Você saiu do veículo que você comprou para sua casa e estava definindo.");
            SendClientMessage(playerid, COLOR_WARNING, "* Você tem {FF0000}50 {FFFFFF}segundos para voltar para o veículo, caso contrário ele vai ser destruído.");
            SendClientMessage(playerid, COLOR_WARNING, "* Se o tempo for esgotado você não vai ter seu dinheiro de volta.");
            timerC[playerid] = SetTimerEx("DestroySetVehicle", 50000, false, "i", playerid);
        }
        return 1;
    }
    else if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
    {
        if(vehicleid == vehicleHouseCarDefined[house])
        {
            if(counting[playerid])
            {
                SendClientMessage(playerid, COLOR_INFO, "* Você entrou no veículo a tempo e pode continuar definindo normalmente.");
                KillTimer(timerC[playerid]);
            }
        }
        return 1;
    }
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 16)
    {
        for(new house = 1; house < MAX_HOUSES; house++)
        {
            if(PlayerToPoint(2.0, playerid, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]))
            {
                if(IsPlayerAdmin(playerid))
                {
                    TogglePlayerControllable(playerid, 0);
                    ShowPlayerDialog(playerid, DIALOG_ADMIN, DIALOG_STYLE_MSGBOX, "{00F2FC}Escolha um menu.", "{FFFFFF}Qual menu você gostaria de ter acesso desta casa?", "Normal", "Admin.");
                    return 1;
                }

                ShowHouseMenu(playerid);
                GetPlayerPos(playerid, X, Y, Z);
                PlayerPlaySound(playerid, 1083, X, Y, Z);
            }
            else if(PlayerToPoint(2.0, playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]))
            {
                if(GetPlayerVirtualWorld(playerid) == houseData[house][houseVirtualWorld])
                {
                    SetPlayerPos(playerid, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
                    SetPlayerVirtualWorld(playerid, 0);
                    SetPlayerInterior(playerid, 0);

                    new logString[400];

                    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
                    format(logString, sizeof logString, "O jogador %s[%d], saiu da casa %d", playerName, playerid, house);
                    WriteLog(LOG_SYSTEM, logString);
                }
            }
        }
    }

    if(newkeys == ALARM_KEY)
    {
        for(new house = 1; house < MAX_HOUSES; house++)
        {
            new housePath[200], Float:Pos[3], engine, lights, alarm, doors, bonnet, boot, objective;

            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
    		GetVehicleParamsEx(houseVehicle[house][vehicleHouse], engine, lights, alarm, doors, bonnet, boot, objective);
    		GetVehiclePos(houseVehicle[house][vehicleHouse], Pos[0], Pos[1], Pos[2]);

    		if(!IsPlayerInVehicle(playerid, houseVehicle[house][vehicleHouse]))
    		{
                if((!strcmp(houseData[house][houseOwner], playerName, false)) || (!strcmp(houseData[house][houseTenant], playerName, false)))
                {
        			if(IsPlayerInRangeOfPoint(playerid, 30.0, Pos[0], Pos[1], Pos[2]))
        			{
        				if(houseVehicle[house][vehicleStatus] == 1)
        				{
        					houseVehicle[house][vehicleStatus] = 0;

        					DOF2_SetInt(housePath, "Status do Carro", 0, "Veículo");
        					DOF2_SaveFile();

        					SendClientMessage(playerid, COLOR_INFO, "* Você destrancou seu veículo.");

        					SetVehicleParamsEx(houseVehicle[house][vehicleHouse], engine, lights, alarm, 0, bonnet, boot, objective);

                            new
                                logString[128];

                            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
                            GetPlayerPos(playerid, X, Y, Z);

                            format(logString, sizeof logString, "O jogador %s[%d], trancou o carro da casa %d ", playerName, playerid, house);
                            WriteLog(LOG_VEHICLES, logString);

                            for(new s = GetMaxPlayers(), i; i < s; i++)
                            {
                                if(IsPlayerInRangeOfPoint(i, 20.0, X, Y, Z))
                                {
                					PlayerPlaySound(i, 1145, X, Y, Z);
            	      				PlayAudioStreamForPlayer(i, "https://dl.dropboxusercontent.com/u/70544925/LHouse/Alarme.mp3", Pos[0], Pos[1], Pos[2], 20.0);
                                }
                            }
        				}
        				else
        	   			{
        					houseVehicle[house][vehicleStatus] = 1;

        					DOF2_SetInt(housePath, "Status do Carro", 1, "Veículo");
        					DOF2_SaveFile();

        					SendClientMessage(playerid, COLOR_INFO, "* Você trancou seu veículo");


        					SetVehicleParamsEx(houseVehicle[house][vehicleHouse], engine, lights, alarm, 1, bonnet, boot, objective);

                            new
                                logString[128];

                            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
                            GetPlayerPos(playerid, X, Y, Z);

                            format(logString, sizeof logString, "O jogador %s[%d], destrancou o carro da casa %d", playerName, playerid, house);
                            WriteLog(LOG_VEHICLES, logString);

                            for(new s = GetMaxPlayers(), i; i < s; i++)
                            {
                                if(IsPlayerInRangeOfPoint(i, 20.0, X, Y, Z))
                                {
                					PlayerPlaySound(i, 1145, X, Y, Z);
            	      				PlayAudioStreamForPlayer(i, "https://dl.dropboxusercontent.com/u/70544925/LHouse/Alarme.mp3", Pos[0], Pos[1], Pos[2], 20.0);
                                }
                            }
        				}
					}
				}
			}
        }
    }

	if(newkeys == 16)
	{
		new t = Player[playerid][pTorcida];
		if(PlayerToPoint(1.0, playerid, Torcidas[t][Spawn][0], Torcidas[t][Spawn][1], Torcidas[t][Spawn][2]))
		{
		    new y = Player[playerid][pTorcida];
  			if(!VerificarRival(playerid)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não pode fazer isso agora, alguém que não é de sua torcida está próximo.");
	    	SetPlayerPos(playerid, 772.111999,-3.898649+1,1000.728820);
		    SetPlayerInterior(playerid, 5);
		    SetPlayerVirtualWorld(playerid, y);
		}
	}
	if(newkeys == 16)
	{
		if(PlayerToPoint(1.0, playerid, 772.3268,-5.1274,1000.7287))
		{
			new t = Player[playerid][pTorcida];
			SetPlayerPos(playerid, Torcidas[t][Spawn][0], Torcidas[t][Spawn][1], Torcidas[t][Spawn][2]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}
	}
	// ======================= [ ENTRAR DP BOPE ] ============================== //
	if(newkeys == 16) // DP LV BOPE
	{
		if(PlayerToPoint(1.0, playerid, 350.5490,1834.3707,2241.5850))
		{
			SetPlayerPos(playerid, 2296.7395,2460.0120,10.8203);
			SetPlayerFacingAngle(playerid, 268.4397);
		}
	}
	if(newkeys == 16) // DP LV BOPE
	{
		if(PlayerToPoint(1.0, playerid, 2296.7395,2460.0120,10.8203))
		{
			SetPlayerPos(playerid, 350.5490,1834.3707,2241.5850+3);
			SetPlayerFacingAngle(playerid, 69.7721);
		}
	}
    // ================================== [ EQUIPAR DP] ======================= //
   	if(newkeys == 16)
	{
		if(PlayerToPoint(1.0, playerid, 341.4738,1827.2454,2241.5850) )
		{
			if(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1)
			{
				ShowPlayerDialog(playerid, DIALOG_HQ, DIALOG_STYLE_LIST, "Batalhão Policial", "Limpar Ficha\nInformações", "Ok", "Cancelar");
			}
			else
			{
				SendClientMessage(playerid, COR_ERRO, "[ERRO]: Local exclusivo para corporações.");
			}
		}
	}
   	if(newkeys == 16)
	{
		if(PlayerToPoint(1.0, playerid, 298.9932,1829.0441,2241.5850) )
		{
			if(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1)
			{
				ShowPlayerDialog(playerid, DIALOG_EQUIPAR, DIALOG_STYLE_LIST, "Equipamento", "Equipar", "Ok", "Cancelar");
			}
			else
			{
				SendClientMessage(playerid, COR_ERRO, "[ERRO]: Local exclusivo para corporações.");
			}
		}
	}
	// ========================== [ PORTÃO BOPE ] ============================== //
	if((newkeys == KEY_CROUCH) && (IsPlayerInAnyVehicle(playerid)))
    {
    	if(PlayerToPoint(10.0, playerid, 2237.6,2453.08,12.45))
		{
	        if(Player[playerid][pBope]<1)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem permissão para abrir o portão.");
			MoveDynamicObject(portaoBOPE,2237.6,2453.08,1.45,10);
			SetTimerEx("FecharPortaoBOPE", 5000, 0, "i", playerid);
			for(new i=0; i <= MAX_PLAYERS; i++)
			if(GetDistanceBetweenPlayers(playerid, i) <= 20)
			{
				SendClientMessage(i, COR_PORTAO, "** Portão aberto irá fechar em 5 segundos.");
			}
		}
    }
 	if((newkeys == KEY_CROUCH) && (IsPlayerInAnyVehicle(playerid)))
    {
    	if(PlayerToPoint(10.0, playerid, 2334.43,2443.65,7.7906))
		{
	        if(Player[playerid][pBope]<1)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem permissão para abrir o portão.");
			SetTimerEx("FecharPortaoBOPE2", 5000, 0, "i", playerid);
			MoveDynamicObject(portaoBOPE2,2334.43,2443.65,0.0906,10);
			for(new i=0; i <= MAX_PLAYERS; i++)
			if(GetDistanceBetweenPlayers(playerid, i) <= 20)

			{
				SendClientMessage(i, COR_PORTAO, "** Portão aberto irá fechar em 5 segundos.");
			}
		}
    }
	// ======================= [ ELEVADOR BOPE ] =============================== //
	if(newkeys == 16) // ELEVADOR BOPE LV
	{
		if(Player[playerid][pBope] >= 1)
		{
			if(PlayerToPoint(1.0, playerid, 2297.1169,2451.4468,10.8203))
			{
				SetPlayerPos(playerid, 2291.1814,2458.5923,38.6875);
			}
		}
	}
	if(newkeys == 16) // ELEVADOR BOPE LV
	{
		if(PlayerToPoint(1.0, playerid, 2291.1814,2458.5923,38.6875))
		{
			SetPlayerPos(playerid, 2297.1169,2451.4468,10.8203);
		}
	}
	// ========================== [ PORTÃO MANSÃO e CAASA] ============================== //
	if((newkeys == KEY_CROUCH) && (IsPlayerInAnyVehicle(playerid)))
    {
    	if(PlayerToPoint(10.0, playerid, 1026.75684, -370.08450, 72.74670))
		{
		    if(strfind(Nome(playerid),"[GTB]Marola", false) != -1)
			{
				MoveDynamicObject(portaomansao, 1026.7568, -370.0845, 68.7343, 10);
				SetTimerEx("FecharPortaoMansao", 5000, 0, "i", playerid);
				for(new i=0; i <= MAX_PLAYERS; i++)
				if(GetDistanceBetweenPlayers(playerid, i) <= 20)
				{
					SendClientMessage(i, COR_PORTAO, "** Portão aberto irá fechar em 5 segundos.");
				}
			}
		}
	}
 	if((newkeys == KEY_CROUCH) && (IsPlayerInAnyVehicle(playerid)))
    {
    	if(PlayerToPoint(10.0, playerid, 527.52362, -1873.93237, 2.19100))
		{
		    if(strfind(Nome(playerid),"[GTB]Marola", false) != -1)
			{
				MoveDynamicObject(portaocasa, 527.52362, -1873.93237, -1.83260, 10);
				SetTimerEx("FecharPortaoCasa", 5000, 0, "i", playerid);
				for(new i=0; i <= MAX_PLAYERS; i++)
				if(GetDistanceBetweenPlayers(playerid, i) <= 20)
				{
					SendClientMessage(i, COR_PORTAO, "** Portão aberto irá fechar em 5 segundos.");
				}
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if (GetPVarInt(playerid, "laser"))
	{
            RemovePlayerAttachedObject(playerid, 0);
            if ((IsPlayerInAnyVehicle(playerid)) || (IsPlayerInWater(playerid))) return 1;
            switch (GetPlayerWeapon(playerid))
			{
                    case 23:
					{
                            if (MiraLaser(playerid))
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP standing aiming
                                            0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP crouched aiming
                                            0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
                                    }
                            } else
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP standing not aiming
                                            0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP crouched not aiming
                                            0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                    	            }
                            }
                    }
                    case 27:
					{
                            if (MiraLaser(playerid))
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS standing aiming
                                            0.588246, -0.022766, 0.138052, -11.531745, 347.712585, 352.784271);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS crouched aiming
                                            0.588246, -0.022766, 0.138052, 1.468254, 350.712585, 352.784271);
                                    }
                            } else
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS standing not aiming
                                            0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS crouched not aiming
                                            0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                                    }
                            }
                    }
                    case 30:
					{
                            if (MiraLaser(playerid))
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK standing aiming
                                            0.628249, -0.027766, 0.078052, -6.621746, 352.552642, 355.084289);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK crouched aiming
                                            0.628249, -0.027766, 0.078052, -1.621746, 356.202667, 355.084289);
                                    }
                            } else
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK standing not aiming
                                            0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK crouched not aiming
                                            0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                                    }
                            }
                    }
                    case 31:
					{
                            if (MiraLaser(playerid))
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 standing aiming
                                            0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 crouched aiming
                                            0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
                                    }
                            } else
							{
                                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 standing not aiming
                                            0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                                    } else
									{
                                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 crouched not aiming
                                            0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                                    }
                            }
                   }
					case 34:
					{
						if (MiraLaser(playerid))
						{
							/*if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
								SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // Sniper standing aiming
								0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
							} else {
								SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // Sniper crouched aiming
								0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
							}*/
							return 1;
						} else
						{
							if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
							{
								SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // Sniper standing not aiming
								0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
							} else
							{
								SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // Sniper crouched not aiming
								0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
							}
					    }
					}
     				case 29:
				 	{
      					if (MiraLaser(playerid))
				  		{
        					if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
							{
								SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 standing aiming
        						0.298249, -0.02776, 0.158052, -11.631746, 359.302673, 357.584259);
              				} else
	  						{
         						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 crouched aiming
               					0.298249, -0.02776, 0.158052, 8.368253, 358.302673, 352.584259);
               				}
            			} else
					   	{
         				if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					 	{
       						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 standing not aiming
             				0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
             			} else
					 	{
       						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 crouched not aiming
             				0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
		    	        }
					}
				}
			}
		}				  
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	    new Query[128];
	    switch(dialogid)
	    {
	        case DIALOG_INICIO:
	        {
	            switch(listitem)
			 	{
			  		case 0:
			    	{
						mysql_format(conectDB, Query, sizeof(Query), "SELECT * FROM `pinfo` WHERE `Nick` = '%e' LIMIT 1", Nome(playerid));
						mysql_function_query(conectDB, Query, true, "ProcurarUsuario", "i", playerid);
			    	}
			    	case 1:
			    	{
	           			mysql_format(conectDB, Query, sizeof(Query), "SELECT * FROM `pinfo` WHERE `Nick` = '%e' LIMIT 1", Nome(playerid));
						mysql_function_query(conectDB, Query, true, "ProcurarUsuario2", "i", playerid);
			    	}
			    	case 2:
			    	{
			    	    	ShowPlayerDialog(playerid, DIALOG_INICIO, DIALOG_STYLE_LIST, "{FFFFFF}Seja bem vindo a {FF0000}GTB Torcidas", "{FF0000}¤ {FFFFFF}Registrar\n{FF0000}¤ {FFFFFF}Logar\n{FF0000}¤ {FFFFFF}Esqueci minha senha {FF0000}(Desativado Temp.)\n{FF0000}¤ {FFFFFF}Sair", "Selecionar", "");
			    	}
			    	case 3:
			    	{
			    	    Kick(playerid);
			    	}
			   	}
	        }
	        case DIALOG_REGISTRO:
	        {
	            if(!response) Kick(playerid); //Botão Cancelar
	            else // Botão registrar
	            {
	                if(strlen(inputtext) < 5 || strlen(inputtext) > 32)
	                {
	                    new string1[250],string[250];
						format(string, -1, "{FFFFFF}Olá, bem vindo a {FFD700}GTB Torcidas\n\n");
						strcat(string1,string);
						format(string, -1, "{FFFFFF}INFORMAÇÕES DA SUA CONTA ABAIXO:\n\n");
						strcat(string1,string);
						format(string, -1, "{FFFFFF}Nick: {FF0000}%s\n", Nome(playerid));
						strcat(string1,string);
						format(string, -1, "{FFFFFF}Status: {FF0000}Não registrada\n\n");
						strcat(string1,string);
						format(string, -1, "{FF0000}* Sua senha deve ter pelo menos 5 caracteres.\n\n");
						strcat(string1,string);
						format(string, -1, "{FFFFFF}Escolha sua senha:\n");
						strcat(string1,string);
				        ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "{FF0000}¤ {FFFFFF}Registro 1/3", string1, "Registrar", "");
	                }
	                else // Se não for Registrado
	                {
	                    //Vai Registrar
	                    new pIP[16];
	    				GetPlayerIp(playerid, pIP, sizeof(pIP));
	                    mysql_format(conectDB, Query, sizeof(Query), "INSERT INTO `pinfo` (`Nick`,`Senha`,`IP`) VALUES ('%s','%s','%s')", Nome(playerid), inputtext, pIP);
	                    // INSIRA EM jogadores (nome, senha) valores (nome (nome do jogador), inputtext (o que foi digitado))
	                    // Executando a consulta
	                    mysql_function_query(conectDB, Query, false, "", "");
	                    GivePlayerMoney(playerid, 10000);
	                    Player[playerid][pIniciante] = 1;

	                    // Não precisamos obter nenhum resultado na consulta, logo, não precisamos de callback.
	                    // Portanto, no parâmetro onde ficou, por exemplo, ProcurarUsuario, na OnPlayerConnect, basta deixar ""
	                    // Mesma coisa para os especificadores, que vem logo após a callback, não usaremos callback, muito menos parametros, logo: ""

	                    //Depois de Registrar vai mostar dialog de Login
	                    new string1[28],string[28];
						format(string, -1, "{FFFFFF}Digite seu e-mail:\n");
						strcat(string1,string);
	                    ShowPlayerDialog(playerid, DIALOG_REGISTRO_EMAIL, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}Registro 2/3", string1, "Proximo", "Cancelar");
	                }
	            }
	        }
       		case DIALOG_NICK_EM_USO:
			{
		    	ShowPlayerDialog(playerid, DIALOG_INICIO, DIALOG_STYLE_LIST, "{FFFFFF}Seja bem vindo a {FF0000}GTB Torcidas", "{FF0000}¤ {FFFFFF}Registrar\n{FF0000}¤ {FFFFFF}Logar\n{FF0000}¤ {FFFFFF}Esqueci minha senha\n{FF0000}¤ {FFFFFF}Sair", "Selecionar", "");
			}
			case DIALOG_REGISTRO_EMAIL:
			{
			    if(!response) Kick(playerid);
				else
				{
					if(isEmail(inputtext) == 0)
					{
					    new string1[68], string[68];
					    format(string, -1, "{FF0000}ERRO: E-mail invalido.\n\n");
						strcat(string1,string);
	                    format(string, -1, "{FFFFFF}Digite seu e-mail:\n");
						strcat(string1,string);
				        ShowPlayerDialog(playerid, DIALOG_REGISTRO_EMAIL, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}Registro 2/3", string1, "Avançar", "");
					}
					else
					{
					    mysql_format(conectDB, Query, sizeof(Query), "UPDATE `pinfo` SET `Email` = '%s' WHERE `Nick` = '%s'", inputtext, Nome(playerid));
		                mysql_function_query(conectDB, Query, false, "", "");
			            new string1[250],string[250];
						format(string, -1, "{FFFFFF}Olá, bem vindo a {FF0000}GTB Torcidas\n\n");
						strcat(string1,string);
						format(string, -1, "{FFFFFF}INFORMAÇÕES DA SUA CONTA ABAIXO:\n\n");
						strcat(string1,string);
						format(string, -1, "{FFFFFF}Nick: {7CFC00}%s\n", Nome(playerid));
						strcat(string1,string);
						format(string, -1, "{FFFFFF}Status: {7CFC00}Registrada\n\n");
						strcat(string1,string);
						format(string, -1, "{FFFFFF}Digite sua senha:\n");
						strcat(string1,string);
			            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}¤ {FFFFFF}Login 3/3", string1, "Logar", "Cancelar");
		            }
				}
			}
	        case DIALOG_LOGIN:
	        {
	            if(!response)
	                Kick(playerid);

	            else // Botão login
	            {
	                // Agora vamos ao login
	                // Faremos uma consulta para o nome e a senha
	                mysql_format(conectDB, Query, sizeof(Query), "SELECT * FROM `pinfo` WHERE `Nick` = '%e' AND `Senha` = '%e'", Nome(playerid), inputtext);

	                // Traduzindo
	                // SELECIONE TUDO de jogadores AONDE nome = nome(variavel) E senha = inputtext (o que foi digitado)

	                // Executando a consulta
	                // Precisaremos de uma callback pois precisaremos obter o resultado por cache
	                mysql_function_query(conectDB, Query, true, "FazerLogin", "i", playerid);
	            }
	        }
	    }
  	  	if(dialogid == DIALOG_TORCIDA)
		{
			if(response ==0)
			{
			    if(Player[playerid][pIniciante]==1)
			    {
					Regras1(playerid);
				}
			}
			if(response == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha a região de sua torcida:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "");
			}
		}
		
		if(dialogid == DIALOG_TORCIDAS)
		{
			if(response)
			{
				if(listitem == 0)
				{
					ShowPlayerDialog(playerid, DIALOG_LS, DIALOG_STYLE_LIST, "Escolha um estado para poder continuar:", "Rio de Janeiro\nSão Paulo\nMinas Gerais", "Selecionar", "Voltar");
				}
				else if(listitem == 1)
				{
					ShowPlayerDialog(playerid, DIALOG_SF, DIALOG_STYLE_LIST, "Escolha um estado para poder continuar:", "Paraná\nRio Grande do Sul\nSanta Catarina\nGoias / Distrito Federal", "Selecionar", "Voltar");
				}
				else if(listitem == 2)
				{
					ShowPlayerDialog(playerid, DIALOG_LV, DIALOG_STYLE_LIST, "Escolha um estado para poder continuar:", "Pernambuco\nBahia\nCeará\nRio Grande do Norte\nPará\nSergipe\nAlagoas\nParaíba", "Selecionar", "Voltar");
				}
			}
			else
			{
				if(Player[playerid][GPS_Torcidas] == true)
				{
	                Player[playerid][GPS_Torcidas] = false;
					return 0;
				}

				if(Logado[playerid] == true)
				    return 0;

				ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha a região de sua torcida para continuar:", "Sudeste\nSul\nNordeste e Norte", "Selecionar", "");
			}
		}
		else if(dialogid == DIALOG_LS) // Sudeste
		{
			if(response)
			{
			    new txt[2048];
				for(new i = 0; i < MAX_TORCIDAS; i ++)
				{
				    if(Torcidas[i][Estado] == EstadosSudeste[listitem])
				    {
				        format(txt,2048,"%s%s\n", txt, Torcidas[i][tNome]);
				    }
				}
				ShowPlayerDialog(playerid, 1000+EstadosSudeste[listitem],DIALOG_STYLE_LIST, "Escolha uma equipe para poder continuar:", txt, "Selecionar", "Voltar");
			}
			else
			{
				if(Player[playerid][GPS_Torcidas] == true || Logado[playerid] == true)
				{
					ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha uma região para poder continuar:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "Cancelar");
				}
				else ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha uma região para poder continuar:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "");
			}
		}
		else if(dialogid == DIALOG_SF)   // Sul Centro-Oeste
		{
			if(response)
			{
			    new txt[2048];
				for(new i = 0; i < MAX_TORCIDAS; i ++)
				{
				    if(Torcidas[i][Estado] == EstadosSul[listitem])
				    {
				        format(txt,2048,"%s%s\n", txt, Torcidas[i][tNome]);
				    }
				}
				ShowPlayerDialog(playerid, 1000+EstadosSul[listitem],DIALOG_STYLE_LIST, "Escolha uma equipe para poder continuar:", txt, "Selecionar", "Voltar");

			}
			else
			{
				if(Player[playerid][GPS_Torcidas] == true || Logado[playerid] == true)
				{
					ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha uma região para poder continuar:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "Cancelar");
				}
				else ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha uma região para poder continuar:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "");
			}
		}
		else if(dialogid == DIALOG_LV)   // Sul Centro-Oeste
		{
			if(response)
			{
			    new txt[2048];
				for(new i = 0; i < MAX_TORCIDAS; i ++)
				{
				    if(Torcidas[i][Estado] == EstadosNorte[listitem])
				    {
				        format(txt,2048,"%s%s\n", txt, Torcidas[i][tNome]);
				    }
				}
				ShowPlayerDialog(playerid, 1000+EstadosNorte[listitem],DIALOG_STYLE_LIST, "Escolha uma equipe para poder continuar:", txt, "Selecionar", "Voltar");

			}
			else
			{
				if(Player[playerid][GPS_Torcidas] == true || Logado[playerid] == true)
				{
					ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha uma região para poder continuar:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "Cancelar");
				}
				else ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha uma região para poder continuar:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "");
			}
		}
		if(dialogid >= DIALOG_ESTADOS && dialogid <= 1500)
		{
		    if(!response)
		    {
	 			if(dialogid >= 1000+EstadosNorte[0])
				{
					ShowPlayerDialog(playerid, DIALOG_LV, DIALOG_STYLE_LIST, "Escolha um estado para poder continuar:", "Pernambuco\nBahia\nCeará\nRio Grande do Norte\nPará\nSergipe\nAlagoas\nParaíba", "Selecionar", "Voltar");
				}
				else if(dialogid >= 1000+EstadosSul[0])
				{
					ShowPlayerDialog(playerid, DIALOG_SF, DIALOG_STYLE_LIST, "Escolha um estado para poder continuar:", "Paraná\nRio Grande do Sul\nSanta Catarina\nGoias / Distrito Federal", "Selecionar", "Voltar");
				}
				else if(dialogid >= 1000+EstadosSudeste[0])
				{
					ShowPlayerDialog(playerid, DIALOG_LS, DIALOG_STYLE_LIST, "Escolha um estado para poder continuar:", "Rio de Janeiro\nSão Paulo\nMinas Gerais", "Selecionar", "Voltar");
				}
		    }
		   	else
			{
			//    printf("Dialogid: %d - Listitem: %d", dialogid, listitem);
			    new total = -1;
				for(new i = 0; i < MAX_TORCIDAS; i ++)
				{
				    if(Torcidas[i][Estado] == dialogid-1000)
				    {
				      //  printf("I found: %d", i);
				        total += 1;
				       // printf("Total: %d");
				        if(total == listitem)
				        {
				        //    printf("Total found");
							if(Player[playerid][GPS_Torcidas] == true)
							{
							    new string[126];
			                    SetPlayerCheckpoint(playerid,Torcidas[i][Spawn][0], Torcidas[i][Spawn][1], Torcidas[i][Spawn][2], 4.0);
								format(string, sizeof(string),"[INFO] Sede '%s' marcada em seu mapa.", Torcidas[i][tNome]);
								SendClientMessage(playerid, COR_PRINCIPAL, string);
								CP[playerid] = 2;
								Player[playerid][GPS_Torcidas] = false;
								return 1;
							}
							else
							{
							    if(Player[playerid][pTorcida] == i) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você já é dessa equipe!");
					            Player[playerid][pTorcida] = i;

								new string[128];
								format(string,128,"[INFO] %s escolhida!", Torcidas[i][tNome]);
								SendClientMessage(playerid, COR_PRINCIPAL, string);

								new cor[24];
								format(cor,24,"%s",Torcidas[i][tCor]);
								format(string,128,"[Chat %s] %s (%d): {FFFFFF}Olá! Acabei de entrar para a equipe, prazer em conhece-los.", Torcidas[i][tNome], Nome(playerid), playerid);
								SendMessageToTorc(i, Torcidas[i][tCor], string);

                                TogglePlayerSpectating(playerid, false);
								TogglePlayerControllable(playerid, 1);
								SpawnPlayer(playerid);
								SetPlayerSkin(playerid, Torcidas[i][tSkin]);
								Logado[playerid] = true;
								Player[playerid][pIniciante] = 0;
								SalvarPlayer(playerid);
								return 1;
							}
				        }
				    }
				}
			}
		}

		if(dialogid == DIALOG_TUNAR)
		{
			if(response)
			{
				if(listitem == 0)
				{
		 	        ShowPlayerDialog(playerid, PINTARV, DIALOG_STYLE_LIST, "Escolha a cor:", "Branco\nPreto\nVermelho\nRosa\nAmarelo\nAzul\n", "OK", "Cancelar");
				}
				if(listitem == 1)
				{
		 	        ShowPlayerDialog(playerid, DIALOG_RODAS, DIALOG_STYLE_LIST, "Escolha a Roda:", "Shadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutter\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nAhab\nVirtual\nAccess", "Ok", "Cancelar");
				}
				if(listitem == 2)
				{
					new vehicle;
					vehicle = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vehicle, 1087);// Suspenção Hidraulica
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: Você colocou suspenção hidraulica em seu veículo!");
				}
				if(listitem == 3)
				{
				    new vehicle;
				    vehicle = GetPlayerVehicleID(playerid);
		 	        AddVehicleComponent(vehicle, 1010); // nitro x10
		 	        SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: Você colocou nitro em seu veículo!");
				}
				if(listitem == 4)
				{
	                SetVehicleHealth(GetPlayerVehicleID(playerid), 99999999);
	                SendClientMessage(playerid, COR_PRINCIPAL, "[INFO] Você blindou seu veículo!");
				}
			}
		}

	    if(dialogid == DIALOG_RODAS)
	    {
	        if(!response) return 1;
	        new vehicleid = GetPlayerVehicleID(playerid);
			if(listitem == 0){  AddVehicleComponent(vehicleid, 1073); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Shadow no seu carro."); }
	  		if(listitem == 1){  AddVehicleComponent(vehicleid, 1074); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Mega no seu carro."); }
			if(listitem == 2){  AddVehicleComponent(vehicleid, 1075); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Rimshine no seu carro."); }
			if(listitem == 3){  AddVehicleComponent(vehicleid, 1076); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Wires no seu carro."); }
			if(listitem == 4){  AddVehicleComponent(vehicleid, 1077); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Classic no seu carro."); }
			if(listitem == 5){  AddVehicleComponent(vehicleid, 1078); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Twist no seu carro."); }
			if(listitem == 6){  AddVehicleComponent(vehicleid, 1079); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Cutter no seu carro."); }
			if(listitem == 7){  AddVehicleComponent(vehicleid, 1080); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Switch no seu carro."); }
			if(listitem == 8){  AddVehicleComponent(vehicleid, 1081); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Grove no seu carro."); }
			if(listitem == 9){  AddVehicleComponent(vehicleid, 1082); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Import no seu carro."); }
			if(listitem == 10){ AddVehicleComponent(vehicleid, 1083); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Dollar no seu carro."); }
			if(listitem == 11){ AddVehicleComponent(vehicleid, 1084); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Trance no seu carro."); }
			if(listitem == 12){ AddVehicleComponent(vehicleid, 1085); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Atomic no seu carro."); }
			if(listitem == 13){ AddVehicleComponent(vehicleid, 1096); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Ahab no seu carro."); }
			if(listitem == 14){ AddVehicleComponent(vehicleid, 1097); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Virtual no seu carro."); }
			if(listitem == 15){ AddVehicleComponent(vehicleid, 1098); SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você adicionou a roda Access no seu carro."); }
			return 1;
		}

		if(dialogid == PINTARV)
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(listitem == 0)
				{
					ChangeVehicleColor(vehicleid, 1, 1);
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: A cor de seu veículo foi mudada.");
				}
				if(listitem == 1)
				{
					ChangeVehicleColor(vehicleid, 0, 0);
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: A cor de seu veículo foi mudada.");
				}
				if(listitem == 2)
				{
					ChangeVehicleColor(vehicleid, 3, 3);
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: A cor de seu veículo foi mudada.");
				}
				if(listitem == 3)
				{
					ChangeVehicleColor(vehicleid, 18, 18);
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: A cor de seu veículo foi mudada.");
				}
				if(listitem == 4)
				{
					ChangeVehicleColor(vehicleid, 6, 6);
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: A cor de seu veículo foi mudada.");
				}
				if(listitem == 5)
				{
					ChangeVehicleColor(vehicleid, 20, 20);
					SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: A cor de seu veículo foi mudada.");
				}
			}
		}

 		if(dialogid == DIALOG_TEMPO)
		{
			new string[999];
			if(response)
			{
				if(listitem == 0)
				{
					SetWorldTime(01);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 01:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 1)
				{
					SetWorldTime(02);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 02:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 2)
				{
					SetWorldTime(03);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 03:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 3)
				{
					SetWorldTime(04);
					TempoReal[1]=false;
					format(string, sizeof(string), "[INFO]: O administrador %s configurou a hora para 04:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 4)
				{
					SetWorldTime(05);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 05:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 5)
				{
					SetWorldTime(06);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 06:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 6)
				{
					SetWorldTime(07);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 07:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 7)
				{
					SetWorldTime(08);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 08:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 8)
				{
					SetWorldTime(09);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 09:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 9)
				{
					SetWorldTime(10);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 10:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 10)
				{
					SetWorldTime(11);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 11:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 11)
				{
					SetWorldTime(12);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 12:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 12)
				{
					SetWorldTime(13);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 13:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 13)
				{
					SetWorldTime(14);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 14:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 14)
				{
					SetWorldTime(15);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 15:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 15)
				{
					SetWorldTime(16);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 16:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 16)
				{
					SetWorldTime(17);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 17:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 17)
				{
					SetWorldTime(18);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 18:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 18)
				{
					SetWorldTime(19);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 19:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 19)
				{
					SetWorldTime(20);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 20:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 20)
				{
					SetWorldTime(21);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 21:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 21)
				{
					SetWorldTime(22);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 22:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 22)
				{
					SetWorldTime(23);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 23:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 23)
				{
					SetWorldTime(24);
					TempoReal[1]=false;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a hora para 24:00h", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
				if(listitem == 24)
				{
					TempoReal[1]=true;
					format(string, sizeof(string), "AdmCMD: O administrador %s configurou a para hora automatico.", Nome(playerid));
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
			}
			return 1;
		}

      	if(dialogid == DIALOG_REGRAS)
		{
			if(response ==0)
			{
				Regras1(playerid);
			}
			if(response == 1)
			{
				Regras2(playerid);
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
				SetPlayerCameraPos(playerid, 1473.0959,-1587.3617,79.9308);
				SetPlayerCameraLookAt(playerid, 1483.7644,-1659.1058,28.7769);
			}
		}
		if(dialogid == DIALOG_REGRAS2)
		{
			if(response ==0)
			{
				Regras1(playerid);
			}
			if(response == 1)
			{
				Regras3(playerid);
    			PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
  				SetPlayerCameraPos(playerid, 563.3523,-1225.7898,117.8663);
				SetPlayerCameraLookAt(playerid, 627.3071,-1130.5742,113.2172);
			}
		}
	 	if(dialogid == DIALOG_REGRAS3)
		{
			if(response ==0)
			{
				Regras2(playerid);
			}
			if(response == 1)
			{
				Regras4(playerid);
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
  				SetPlayerCameraPos(playerid, 2081.1199,-1035.0262,113.4360);
				SetPlayerCameraLookAt(playerid, 2175.6904,-1027.3837,75.6326);
			}
		}
	  	if(dialogid == DIALOG_REGRAS4)
		{
			if(response ==0)
			{
				Regras3(playerid);
			}
			if(response == 1)
			{
				Regras5(playerid);
 				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
  				SetPlayerCameraPos(playerid, 2476.4539,-1374.4449,124.6351);
				SetPlayerCameraLookAt(playerid, 2414.1274,-1305.3009,99.3433);
			}
		}
	  	if(dialogid == DIALOG_REGRAS5)
		{
			if(response ==0)
			{
				Regras4(playerid);
			}
			if(response == 1)
			{
				Regras6(playerid);
 				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
  				SetPlayerCameraPos(playerid, -2216.310791, -356.810028, 78.435127);
				SetPlayerCameraLookAt(playerid, -2213.006591, -360.156188, 76.736457);
			}
		}
	  	if(dialogid == DIALOG_REGRAS6)
		{
			if(response ==0)
			{
				Regras5(playerid);
			}
			if(response == 1)
			{
				Regras7(playerid);
 				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
  				SetPlayerCameraPos(playerid, 1690.749389, 205.444198, 56.161457);
				SetPlayerCameraLookAt(playerid, 1690.556396, 210.341751, 55.173122);
			}
		}

  	  	if(dialogid == DIALOG_ENQUETE)
		{
			if(!response) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você cancelou a enquete.");
			SendClientMessageToAll(-1, " ");
			SendClientMessageToAll(COR_PRINCIPAL, "-------------------------------------------------------------------------------");
			format(SringEnquete,128, "O Administrador %s acaba de criar uma enquete:",  Nome(playerid));
			SendClientMessageToAll(COR_LARANJA, SringEnquete);
			format(SringEnquete,128, "Pergunta: %s", inputtext);
			SendClientMessageToAll(COR_BRANCO, SringEnquete);
			SendClientMessageToAll(COR_PRINCIPAL, "Para votar use /sim ou /nao conforme a enquete");
			SendClientMessageToAll(COR_PRINCIPAL, "-------------------------------------------------------------------------------");

			EnqueteAberta = true;
			format(NomeEnquete, 128, "%s", inputtext);
			SendClientMessage(playerid, COR_PRINCIPAL, "[ENQUETE]: Caso queira fechar enquete digite [/fechar]");
			return true;
		}
		if(dialogid == DIALOG_RADIO)
		{
			if(response)
			{
				if(listitem == 0)
				{
					PlayAudioStreamForPlayer(playerid, "http://streaming17.brlogic.com:8002/live");
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Voce Ligou a Radio GTB Torcidas.");
				}
				if(listitem == 1)
				{
					StopAudioStreamForPlayer(playerid);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Voce Desligou a Radio GTB Torcidas.");
				}
			}
		}
		if(dialogid == DIALOG_CASHS)
		{
			if(response)
			{
			    if(listitem == 0)
			    {

			    }
				if(listitem == 1)
				{
					ShowPlayerDialog(playerid, DIALOG_CASH1, DIALOG_STYLE_TABLIST_HEADERS, "Loja de Cash [1/2]:", "Item\tPreço\tQuantidade\nJetpack\t{FFFF00}80 Cash\t01\nKatana\t{FFFF00}10 Cash\t01\nColete\t{FFFF00}10 Cash\t100\nVida\t{FFFF00}10 Cash\t100\nParaquedas\t{FFFF00}10 Cash\t01", "Comprar", "Avançar");
				}
				if(listitem == 2)
				{
				    if(Player[playerid][Cash] <= 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem cash suficiente para fazer uma transição.");
					ShowPlayerDialog(playerid, DialogoTransferirCash, DIALOG_STYLE_INPUT, "Coloque o ID do jogador", "Coloque o ID do jogador que você quer transferir.\n\nColoque um ID Válido, Por favor.", "Proximo", "Cancelar");
				}
				if(listitem == 3)
				{
					ShowPlayerDialog(playerid, DIALOG_ENABLE_KEY, DIALOG_STYLE_INPUT, "VIP", "\nNos informe sua key para ativar seu beneficio VIP:\n\n", "Ativar", "Sair");
				}
			}
			return 1;
		}
		if(dialogid == DIALOG_CASH1)
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_CASH2, DIALOG_STYLE_TABLIST_HEADERS, "Loja de Cash [2/2]", "Vip\tPreço\tDias\n{FFFFFF}Vip\t{FFFF00}50 Cash\t1\nVip\t{FFFF00}80 Cash\t5\nVip\t{FFFF00}150 Cash\t10\nVip\t{FFFF00}200 Cash\t15", "Selecionar", "Sair");
			{
				if(listitem == 0)
				{
				    if(Player[playerid][Cash]<80)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem cash's suficiente para comprar.");
				    SendClientMessage(playerid,COR_PRINCIPAL,"[LOJA]: Parabéns você comprou um 'Jetpack', por 80 Cash.");
                    Player[playerid][Cash]-=80;
                    SetPlayerSpecialAction(playerid, 2);
				}
				if(listitem == 1)
				{
				    if(Player[playerid][Cash]<10)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem cash's suficiente para comprar.");
				    SendClientMessage(playerid,COR_PRINCIPAL,"[LOJA]: Parabéns você comprou uma 'Katana', por 10 Cash.");
                    Player[playerid][Cash]-=10;
					GivePlayerWeapon(playerid,8,1);
				}
				if(listitem == 2)
				{
				    if(Player[playerid][Cash]<100)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem cash's suficiente para comprar.");
				    SendClientMessage(playerid,COR_PRINCIPAL,"[LOJA]: Parabéns você comprou 'Colete', por 100 Cash.");
                    Player[playerid][Cash]-=100;
					SetPlayerArmour(playerid,100);
				}
				if(listitem == 3)
				{
				    if(Player[playerid][Cash]<10)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem cash's suficiente para comprar.");
				    SendClientMessage(playerid,COR_PRINCIPAL,"[LOJA]: Parabéns você comprou 'Vida', por 10 Cash.");
                    Player[playerid][Cash]-=10;
					SetPlayerHealth(playerid,100);
				}

				if(listitem == 4)
				{
				    if(Player[playerid][Cash]< 100)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem cash's suficiente para comprar.");
				    SendClientMessage(playerid,COR_PRINCIPAL,"[LOJA]: Parabéns você comprou um 'Paraquédas', por 100 Cash.");
                    Player[playerid][Cash]-=100;
					GivePlayerWeapon(playerid,46,1);
				}
			}
			return 1;
		}
		if(dialogid == DIALOG_CASH2)
		{
			if(!response) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você cancelou sua compra.");
			{
				if(listitem == 0)
				{
					new String[95];
					format(String, sizeof(String), "{FFFFFF}Quantidade de Cash: {FFFF00}[%d]\n{FFFFFF}Pegar 1 Dia VIP {FFFF00}[CUSTO: 50 CASH]",Player[playerid][Cash]);
					ShowPlayerDialog(playerid, DIALOG_CASH3, DIALOG_STYLE_MSGBOX, "{FFFFFF}Sistema de Cash", String, "Pegar VIP", "Sair");
				}
				if(listitem == 1)
				{
					new String[96];
					format(String, sizeof(String), "{FFFFFF}Quantidade de Cash: {FFFF00}[%d]\n{FFFFFF}Pegar 5 Dias VIP {FFFF00}[CUSTO: 80 CASH]",Player[playerid][Cash]);
					ShowPlayerDialog(playerid, DIALOG_CASH4, DIALOG_STYLE_MSGBOX, "{FFFFFF}Sistema de Cash", String, "Pegar VIP", "Sair");
				}
				if(listitem == 2)
				{
					new String[98];
					format(String, sizeof(String), "{FFFFFF}Quantidade de Cash: {FFFF00}[%d]\n{FFFFFF}Pegar 10 Dias VIP {FFFF00}[CUSTO: 150 CASH]",Player[playerid][Cash]);
					ShowPlayerDialog(playerid, DIALOG_CASH5, DIALOG_STYLE_MSGBOX, "{FFFFFF}Sistema de Cash", String, "Pegar VIP", "Sair");
				}
				if(listitem == 3)
				{
					new String[98];
					format(String, sizeof(String), "{FFFFFF}Quantidade de Cash: {FFFF00}[%d]\n{FFFFFF}Pegar 15 Dias VIP {FFFF00}[CUSTO: 200 CASH]",Player[playerid][Cash]);
					ShowPlayerDialog(playerid, DIALOG_CASH, DIALOG_STYLE_MSGBOX, "{FFFFFF}Sistema de Cash", String, "Pegar VIP", "Sair");
				}
			}
			return 1;
		}
		if(dialogid == DIALOG_VEH)
		{
			if(response)
			{
				if(listitem == 0)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(560, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 1)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(411, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 2)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(437, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 3)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(481, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 4)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(510, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 5)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(462, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 6)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(468, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 7)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(471, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 8)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(522, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
			}
		}
  		if(dialogid == DIALOG_VEHVIP)
		{
			if(response)
			{
				if(listitem == 0)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(560, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 1)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(411, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 2)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(437, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 3)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(481, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 4)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(510, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 5)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(462, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 6)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(468, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 7)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(471, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 8)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(522, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 9)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(454, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 10)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(424, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 11)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(429, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 12)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(446, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 13)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(559, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
				if(listitem == 14)
				{
					GetPlayerPos(playerid, X, Y, Z);
					VeiculoVeh[playerid]=1;
					GetPlayerFacingAngle(playerid, A);
					VeiculoVeh[playerid] = CreateVehicle(402, X, Y, Z, A, -1, -1, 30000);
					PutPlayerInVehicle(playerid, VeiculoVeh[playerid], 0);
					SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Veículo criado, ajude o servidor não deixe ele espalhado use /dcm para deletá-lo.");
				}
			}
		}
  	   	if(dialogid == DIALOG_ARMAS)
		{
			if(response)
			{
				if(listitem == 0)
				{
				    GivePlayerWeapon(playerid,3,2);
				    SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um cacetete.");
				}
				if(listitem == 1)
				{
					GivePlayerWeapon(playerid,4,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma faca.");
				}
				if(listitem == 2)
				{
					GivePlayerWeapon(playerid,1,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um soco inglês.");
				}
				if(listitem == 3)
				{
					GivePlayerWeapon(playerid,5,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um Taco de Baseball.");
				}
				if(listitem == 4)
				{
					GivePlayerWeapon(playerid,6,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Pá.");
				}
				if(listitem == 5)
				{
					GivePlayerWeapon(playerid,8,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Katana.");
				}
				if(listitem == 6)
				{
					GivePlayerWeapon(playerid,9,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Serra Elétrica.");
				}
				if(listitem == 7)
				{
					GivePlayerWeapon(playerid,10,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um Vibrador Roxo.");
				}
				if(listitem == 8)
				{
					GivePlayerWeapon(playerid,11,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Vibrador Pequeno.");
				}
				if(listitem == 9)
				{
					GivePlayerWeapon(playerid,12,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Vibrador Largo.");
				}
				if(listitem == 10)
				{
					GivePlayerWeapon(playerid,14,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um buquê de flores.");
				}
				if(listitem == 11)
				{
					GivePlayerWeapon(playerid,17,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma bomba de gás.");
				}
				if(listitem == 12)
				{
					GivePlayerWeapon(playerid,24,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Desert Eagle");
				}
				if(listitem == 13)
				{
					GivePlayerWeapon(playerid,25,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma ShotGun");
				}
				if(listitem == 14)
				{
					GivePlayerWeapon(playerid,26,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Sawnoff Shotgun");
				}
				if(listitem == 15)
				{
					GivePlayerWeapon(playerid,30,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma AK-47.");
				}
				if(listitem == 16)
				{
					GivePlayerWeapon(playerid,29,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma MP5.");
				}
				if(listitem == 17)
				{
					GivePlayerWeapon(playerid,31,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma M4-A1.");
				}
				if(listitem == 18)
				{
					GivePlayerWeapon(playerid,34,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Sniper.");
				}
				if(listitem == 19)
				{
					GivePlayerWeapon(playerid,41,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um Spray.");
				}
				if(listitem == 20)
				{
					GivePlayerWeapon(playerid,42,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um Extintor.");
				}
				if(listitem == 21)
				{
					GivePlayerWeapon(playerid,43,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou uma Camera.");
				}
				if(listitem == 22)
				{
					GivePlayerWeapon(playerid,46,999999);
					SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você pegou um Paraquedas.");
				}
			}
		}
  		if(dialogid == DIALOG_CONFIG)
		{
			if(response)
			{
				if(listitem == 0)
				{
	                if(Player[playerid][BlockTR] == false)
	                {
	                    Player[playerid][BlockTR] = true;
	                    SendClientMessage(playerid, COR_PRINCIPAL,"-ADMCmd-: Trazer bloqueado com sucesso para ativá-lo novamente digite /config.");
	                }
	                else
					{
					    Player[playerid][BlockTR] = false;
					    SendClientMessage(playerid, COR_PRINCIPAL, "-ADMCmd-: Trazer desbloqueado com sucesso.");
					}
				}
				if(listitem == 1)
				{
	                if(Player[playerid][BlockIR] == false)
	                {
	                    Player[playerid][BlockIR] = true;
	                    SendClientMessage(playerid, COR_PRINCIPAL,"-ADMCmd-: Ir bloqueado com sucesso para ativá-lo novamente digite /config.");
	                }
	                else
					{
					    Player[playerid][BlockIR] = false;
					    SendClientMessage(playerid, COR_PRINCIPAL, "-ADMCmd-: Ir desbloqueado com sucesso.");
					}
				}
				if(listitem == 2)
				{
	                if(Player[playerid][BlockPM] == false)
	                {
	                    Player[playerid][BlockPM] = true;
	                    SendClientMessage(playerid, COR_PRINCIPAL,"-ADMCmd-: Mensagem Privada bloqueada com sucesso para ativá-lo novamente digite /config.");
	                }
	                else
					{
					    Player[playerid][BlockPM] = false;
					    SendClientMessage(playerid, COR_PRINCIPAL, "-ADMCmd-: Mensagem Privada desbloqueada com sucesso.");
					}
				}
				if(listitem == 3)
				{
	                if(Player[playerid][ChatTorcida] == false)
	                {
	                    Player[playerid][ChatTorcida] = true;
	                    SendClientMessage(playerid, COR_PRINCIPAL,"-ADMCmd-: Chat Torcida bloqueado com sucesso para ativá-lo novamente digite /config.");
	                }
	                else
					{
					    Player[playerid][ChatTorcida] = false;
					    SendClientMessage(playerid, COR_PRINCIPAL, "-ADMCmd-: Chat Torcida desbloqueada com sucesso.");
					}
				}
			}
		}
		if(dialogid == DialogoTransferirCash)
		{
		    if(!response) return 1;
			if(response)
			{
				if(!IsPlayerConnected(strval(inputtext))) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este jogador não está conectado neste momento.");
				SetPVarInt(playerid, "IDDele", strval(inputtext));
				ShowPlayerDialog(playerid, DialogoTransferirCash2, DIALOG_STYLE_INPUT, "Coloque a quantidade de cash", "Coloque abaixo a quantidade de Cash que você quer transferir para o jogador\n\nColoque uma quantidade entre 0 - 1000, E Apenas Números.", "Transferir", "Cancelar");
			}
		}
		if(dialogid == DialogoTransferirCash2)
		{
		    if(!response) return 1;
			if(response)
			{
			    new Texto[400];
				if(!strval(inputtext)) return ShowPlayerDialog(playerid, DialogoTransferirCash2, DIALOG_STYLE_INPUT, "Coloque a quantidade de golds.", "Coloque abaixo a quantidade de Cash que você quer transferir para o jogador\n\nColoque uma quantidade entre 0 - 1000, E Apenas Números.", "Transferir", "Cancelar");
				if(strval(inputtext) < 0 || strval(inputtext) > 1000) ShowPlayerDialog(playerid, DialogoTransferirCash2, DIALOG_STYLE_INPUT, "Coloque a quantidade de golds.", "Coloque abaixo a quantidade de Cash que você quer transferir para o jogador\n\nColoque uma quantidade entre 0 - 1000, E Apenas Números.", "Transferir", "Cancelar");
				Player[GetPVarInt(playerid, "IDDele")][Cash] += strval(inputtext);
				Player[playerid][Cash] -= strval(inputtext);
				format(Texto, sizeof(Texto), "[INFO]: O %s transferiu %d de Cash para você.", Nome(playerid), strval(inputtext));
				SendClientMessage(GetPVarInt(playerid, "IDDele"), COR_PRINCIPAL, Texto);
				format(Texto, sizeof(Texto), "[INFO]: Você transferiu %d de Cash para %s.", strval(inputtext), Nome(GetPVarInt(playerid, "IDDele")));
				SendClientMessage(playerid, COR_PRINCIPAL, Texto);
			}
		}
		if(dialogid == DIALOG_EQUIPAR)
		{
			if(response)
			{
				if(listitem == 0)   //EQUIPAR
				{
					if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está em trabalho [/dp].");
					if(Player[playerid][pBope] == 1 || Player[playerid][pChoque] == 1)
					{
	            		GivePlayerWeapon(playerid, 3, 1);
	            		GivePlayerWeapon(playerid,24,9999);
						GivePlayerWeapon(playerid, 26, 600);
						GivePlayerWeapon(playerid, 41, 1200);
						SetPlayerArmour(playerid, 100);
						SetPlayerHealth(playerid, 100);
						new string[80];
						format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}se equipou.", Nome(playerid));
						MensagemPerto(playerid, COR_ROXO, string, 20);
					}
					if(Player[playerid][pBope] == 2 || Player[playerid][pChoque] == 2)
					{
	            		GivePlayerWeapon(playerid, 3, 1);
						GivePlayerWeapon(playerid, 26, 600);
						GivePlayerWeapon(playerid, 41, 1200);
                        GivePlayerWeapon(playerid, 29, 9999);
                        GivePlayerWeapon(playerid,24,9999);
						SetPlayerArmour(playerid, 100);
						SetPlayerHealth(playerid, 100);
						new string[80];
						format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}se equipou.", Nome(playerid));
						MensagemPerto(playerid, COR_ROXO, string, 20);
					}
					if(Player[playerid][pBope] == 3 || Player[playerid][pChoque] == 3)
					{
			            GivePlayerWeapon(playerid,3,1);
						GivePlayerWeapon(playerid,25,9999);
						GivePlayerWeapon(playerid,41,9999);
						GivePlayerWeapon(playerid,29,9999);
						GivePlayerWeapon(playerid,24,9999);
						GivePlayerWeapon(playerid,31,9999);
						GivePlayerWeapon(playerid,34,9999);
						SetPlayerArmour(playerid, 100);
						SetPlayerHealth(playerid, 100);
						new string[80];
						format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}se equipou.", Nome(playerid));
						MensagemPerto(playerid, COR_ROXO, string, 20);
					}
					if(Player[playerid][pBope] == 4 || Player[playerid][pChoque] == 4)
					{
	            		GivePlayerWeapon(playerid,3,1);
						GivePlayerWeapon(playerid,25,9999);
						GivePlayerWeapon(playerid,41,9999);
						GivePlayerWeapon(playerid,29,9999);
						GivePlayerWeapon(playerid,24,9999);
						GivePlayerWeapon(playerid,31,9999);
						GivePlayerWeapon(playerid,34,9999);
						SetPlayerArmour(playerid, 100);
						SetPlayerHealth(playerid, 100);
						new string[80];
						format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}se equipou.", Nome(playerid));
						MensagemPerto(playerid, COR_ROXO, string, 20);
					}
					if(Player[playerid][pBope] == 5 || Player[playerid][pChoque] == 5)
					{
	            	    GivePlayerWeapon(playerid,3,1);
						GivePlayerWeapon(playerid,25,800);
						GivePlayerWeapon(playerid,41,9999);
						GivePlayerWeapon(playerid,29,9999);
						GivePlayerWeapon(playerid,34,9999);
						GivePlayerWeapon(playerid,31,9999);
						GivePlayerWeapon(playerid,24,9999);
						SetPlayerArmour(playerid, 100);
						SetPlayerHealth(playerid, 100);
						new string[80];
						format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}se equipou.", Nome(playerid));
						MensagemPerto(playerid, COR_ROXO, string, 20);
					}
				}
			}
		}
		switch(dialogid)
		{
			case DIALOG_NEW_KEY:
			{
			    if(!response) return 1;
			    if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_NEW_KEY, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}KEYS VIP", "\nDigite uma nova key válida\n{FFFF00}Apenas letras são aceitas:\n\n", "Criar", "Cancelar");
			    format(Player[playerid][vKey], 50, inputtext);
				new Dialog[128];
				format(Dialog, sizeof Dialog, "{FFFFFF}Seu novo codigo VIP: {DE3A3A}%s\n\n{FFFFFF}Agora nos informe a quantidade de dias VIP:", Player[playerid][vKey]);
				ShowPlayerDialog(playerid, DIALOG_NEW_KEY_DAYS, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}KEYS VIP", Dialog, "Criar", "Cancelar");
			}

			case DIALOG_NEW_KEY_DAYS:
			{
	  			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Digite uma quantidade de dias válidos.");
	  			if(strval(inputtext) <= 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Não pode ser criada uma Key com 0 dias vips.");
				Player[playerid][vDias] = strval(inputtext);
				new Dialog[170];
				format(Dialog, sizeof Dialog, "{FFFFFF}Seu novo codigo VIP: {DE3A3A}%s\n{FFFFFF}Vencimento: {DE3A3A}%d dias\n\n{FFFFFF}Agora nos informe o nivel da key VIP: {DE3A3A}1 a 3\n\nNivel: 1 = VIP Bronze\nNivel 2 = Vip Prata\nNivel 3 = Vip Ouro", Player[playerid][vKey], Player[playerid][vDias]);
				ShowPlayerDialog(playerid, DIALOG_NEW_KEY_LEVEL, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}KEYS VIP", Dialog, "Criar", "Cancelar");
			}

			case DIALOG_NEW_KEY_LEVEL:
			{
			    new string[80];
	  			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Digite uma quantidade de nivel válidos 1 a 3.");
	            if(strval(inputtext) < 1 || strval(inputtext) > 3) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Digite uma quantidade de nivel válidos 1 a 3.");
				Player[playerid][vNivel] = strval(inputtext);
				if(strval(inputtext) == 1) format(string, sizeof(string),"VIP Bronze");
				if(strval(inputtext) == 2) format(string, sizeof(string),"VIP Prata");
				if(strval(inputtext) == 3) format(string, sizeof(string),"VIP Ouro");
				new Dialog[250];
				format(Dialog, sizeof Dialog, "{FFFFFF}Informações de sua nova key:\n\nCódigo: {DE3A3A}%s\n{FFFFFF}Vencimento: {DE3A3A}%d dias\n{FFFFFF}Nivel: {DE3A3A}%d - %s\n\n{FFFFFF}Deseja criar ?", Player[playerid][vKey], Player[playerid][vDias], Player[playerid][vNivel], string);
				ShowPlayerDialog(playerid, DIALOG_KEY_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF0000}¤ {FFFFFF}KEYS VIP", Dialog, "Sim", "Não");
			}

			case DIALOG_KEY_CONFIRM:
			{
			    if(!response) return 1;
			    new query[70];
			    mysql_format(Connection, query, sizeof(query),"SELECT * FROM `Keys` WHERE `Key` = '%e'", Player[playerid][vKey]);
	    		mysql_tquery(Connection, query, "KeyCheck", "isdd", playerid, Player[playerid][vKey], Player[playerid][vDias], Player[playerid][vNivel]);
			}

			case DIALOG_REMOVE_KEY:
			{
				new query[70];
				mysql_format(Connection, query, sizeof(query),"SELECT * FROM `Keys` WHERE `key` = '%e'", inputtext);
	   			mysql_tquery(Connection, query, "DeleteKey", "is", playerid, inputtext);
			}

			case DIALOG_ENABLE_KEY:
			{
			    if(!response) return 1;
				new query[70];
				mysql_format(Connection, query, sizeof(query),"SELECT * FROM `Keys` WHERE `key` = '%e'", inputtext);
	   			mysql_tquery(Connection, query, "CheckKeyExist", "is", playerid, inputtext);
			}
			case DIALOG_TOYS:
	        {
				if(!response) return 1;
	        	SendClientMessage(playerid, COR_VIP, "[INFO]: Use /tbrinq para remover o brinquedo.");
	        	GameTextForPlayer(playerid, "~g~/tbrinquedos", 2000, 3);
	        	switch(listitem)
	        	{
	              	case 0: SetPlayerAttachedObject(playerid, 0, 19330, 2, 0.166000, -0.038999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	              	case 1: SetPlayerAttachedObject(playerid, 0, 19161, 2, 0.078999, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	       			case 2: SetPlayerAttachedObject(playerid, 0, 18639, 2, 0.131000, 0.019000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	              	case 3: SetPlayerAttachedObject(playerid, 0, 18638, 2, 0.148999, 0.031000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	        		case 4: SetPlayerAttachedObject(playerid, 0, 18939, 2, 0.164000, 0.001999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	        		case 5: SetPlayerAttachedObject(playerid, 0, 19488, 2, 0.121999, 0.000000, -0.005999, -83.199966, 98.200027, -2.500000, 1.000000, 1.000000, 1.000000);
	        		case 6: SetPlayerAttachedObject(playerid, 0, 19352, 2, 0.106999, 0.016000, -0.010999, 4.500000, 82.099990, -3.100001, 1.000000, 1.000000, 1.000000);
	        		case 7: SetPlayerAttachedObject(playerid, 0, 19090, 2, -0.315999, 0.019999, 0.030000, 0.000000, 0.000000, 0.000000, 1.455999, 0.526000, 0.541000);
	        		case 8: SetPlayerAttachedObject(playerid, 0, 19424, 2, 0.070999, -0.026000, -0.002000, -85.299987, 1.600005, -99.500000, 0.944001, 0.915000, 0.809999);
	        		case 9: SetPlayerAttachedObject(playerid, 0, 19078, 1, -1.000000,-0.517000,0.000000,0.000000,0.299999,10.499994,8.673998,9.400999,7.410993);
	        		case 10: SetPlayerAttachedObject(playerid,0, 19078, 4, -0.067000,0.053999,0.018000,-168.400039,-169.800003,-2.800000,1.000000,1.000000,1.000000);
	        		case 11: SetPlayerAttachedObject(playerid,0, 19085, 2, 0.090999,0.035000,-0.015000,106.599983,83.199996,0.800003,1.000000,1.000000,1.000000);
	        		case 12: SetPlayerAttachedObject(playerid,1, 19086, 15, 0.051000,0.000000,-0.424999,0.000000,0.000000,-102.100006,1.000000,1.000000,1.000000);
	        		case 13: SetPlayerAttachedObject(playerid,0, 19137, 2, 0.101000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	        		case 14: SetPlayerAttachedObject(playerid,0, 19137, 15, 0.040999,0.000000,-0.130000,-86.300003,106.100013,-96.100051,7.741999,4.874000,5.584998);
	        		case 15: SetPlayerAttachedObject(playerid,0, 19315, 1, -0.247999,0.509999,-0.015999,4.300004,86.900024,85.500015,3.010000,4.463000,3.824000);
	        		case 16: SetPlayerAttachedObject(playerid,0, 19314, 2, 0.157000,0.000000,0.000000,-0.199999,-7.600006,-88.599998,1.000000,1.000000,1.000000);
	        		case 17: SetPlayerAttachedObject(playerid,0, 19314, 2, 0.157000,0.000000,0.000000,1.400000,-7.600006,-28.599973,0.711000,0.919999,0.361999);
	        		case 18: SetPlayerAttachedObject(playerid,0, 19320, 2, 0.000000,0.000000,0.000000,4.299999,72.999992,3.199999,3.594999,3.787999,4.951001);
	        		case 19: SetPlayerAttachedObject(playerid,0, 18963, 2, 0.261000,0.084999,0.004999,4.999999,85.400039,84.699974,2.097000,2.627000,3.033999);
	        		case 20: SetPlayerAttachedObject(playerid,0, 1607, 2, 0.267000,0.000000,0.000000,-0.199999,81.199996,-3.499999,1.135000,1.000000,1.126999);
	        		case 21: SetPlayerAttachedObject(playerid,0, 1608, 1, 0.000000,0.000000,0.000000,0.499999,89.200042,0.199999,1.000000,1.000000,1.000000);
	        		case 22: SetPlayerAttachedObject(playerid,0, 1609, 1, -0.358000,0.000000,0.170000,0.000000,93.099998,0.000000,1.427000,1.509000,1.641000);
	        		case 23: SetPlayerAttachedObject(playerid,0, 16442, 15, 0.000000,0.000000,0.259000,0.000000,0.000000,-104.400001,1.000000,1.000000,1.000000);
	        		case 24: SetPlayerAttachedObject(playerid,1, 373, 1, 0.33, -0.029, -0.15, 65, 25, 35);
	        		case 25: SetPlayerAttachedObject(playerid,1, 1240, 1, 0.15, 0.17, 0.06, 0.0, 90.0, 0.0);
	        		case 26: SetPlayerAttachedObject(playerid,1, 1252, 1, 0.1, -0.2, 0.0, 0.0, 90.0, 0.0);
	        		case 27: SetPlayerAttachedObject(playerid,1, 356, 1, -0.2, -0.15, 0.0, 0.0, 24.0, 0.0);
	        		case 28: SetPlayerAttachedObject(playerid,1 ,359, 15 ,-0.02 ,0.08 ,-0.3 ,0 ,50 ,-10);
	        		case 29: SetPlayerAttachedObject(playerid,0, 19065, 2, 0.120000, 0.040000, -0.003500, 0, 100, 100, 1.4, 1.4, 1.4);
	        		case 30: SetPlayerAttachedObject(playerid,0 ,1852 ,2 ,0.1 ,0 ,-0.01 ,0 ,15 ,0);
	        		case 31: SetPlayerAttachedObject(playerid,1, 1654, 1, 0.1,0.20,0.0,180.0,100.0,0.0);
				}
			}

			case DIALOG_EFECTS:
	        {
				if(!response) return 1;
	        	SendClientMessage(playerid, COR_VIP, "[INFO]: Use /tefeitos para remover o efeito.");
	        	GameTextForPlayer(playerid, "~g~/tefeitos", 2000, 3);
	        	switch(listitem)
	        	{
	              	case 0: SetPlayerAttachedObject(playerid,1,18688,1,-0.895839,0.631365,-1.828601,21.642332,7.385670,13.958697,1.232679,1.000000,1.090367); // fire - Bruno
	              	case 1: SetPlayerAttachedObject(playerid,1,18742,1,0.036487,-1.759890,1.772809,225.616638,1.132580,0.677276,1.000000,1.000000,1.000000); // water_speed - explosaoaquatica
	       			case 2: SetPlayerAttachedObject(playerid,1,18864,1,2.178843,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000); // FakeSnow1 - neve
	              	case 3: SetPlayerAttachedObject(playerid,1,867,1,-0.213616,-0.444311,0.070721,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000); // p_rubble04col - pedras
	        		case 4: SetPlayerAttachedObject(playerid,1,1254,1,0.448984,0.065604,0.006619,4.313228,89.284942,0.000000,1.000000,1.000000,1.000000); // killfrenzy - caveira
	        		case 5: SetPlayerAttachedObject(playerid,1,1242,1,0.090351,0.088730,-0.000036,0.000000,89.157951,0.000000,1.619548,1.000000,1.348966); // bodyarmour - colete
	        		case 6: SetPlayerAttachedObject(playerid,1,18735,1,0.000000,-0.479024,-1.590823,0.000000,0.000000,0.000000,13.498819,1.000000,0.678294); // vent2 - fumaÃ§ao
	        		case 7: SetPlayerAttachedObject(playerid,1,19065,15,-0.025,-0.04,0.23,0,0,270,2,2,2); // Toca de Natal

					case 8:
					{
	                	SetPlayerAttachedObject(playerid,1,18688,1,-0.895839,0.631365,-1.828601,21.642332,7.385670,13.958697,1.232679,1.000000,1.090367); // fire - Bruno
	            		SetPlayerAttachedObject(playerid,2,1254,1,0.448984,0.065604,0.006619,4.313228,89.284942,0.000000,1.000000,1.000000,1.000000); // killfrenzy - caveira
					}
	        		case 9:
					{
						SetPlayerAttachedObject(playerid,1,1242,1,0.090351,0.088730,-0.000036,0.000000,89.157951,0.000000,1.619548,1.000000,1.348966); // bodyarmour - colete
	            		SetPlayerAttachedObject(playerid,2,18735,1,0.000000,-0.479024,-1.590823,0.000000,0.000000,0.000000,13.498819,1.000000,0.678294); // vent2 - fumaÃ§ao

					}
	        		case 10:
					{
					    SetPlayerAttachedObject(playerid,1,867,1,-0.213616,-0.444311,0.070721,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000); // p_rubble04col - pedras
	            		SetPlayerAttachedObject(playerid,2,18742,1,0.036487,-1.759890,1.772809,225.616638,1.132580,0.677276,1.000000,1.000000,1.000000); // water_speed - explosaoaquatica
					}
	        		case 11:
					{
					    SetPlayerAttachedObject(playerid,1,19065,15,-0.025,-0.04,0.23,0,0,270,2,2,2); // Toca de Natal
	            		SetPlayerAttachedObject(playerid,2,18864,1,2.178843,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000); // FakeSnow1 - neve
					}
				}
			}
		}
	 	if(dialogid == DIALOG_AJUDA)
		{
			if(response)
			{
				if(listitem == 0)
				{
				    Ajuda(playerid);
				}
				if(listitem == 1)
				{
				   Comandos(playerid);
				}
	   			if(listitem == 2)
				{
				    new Str[200];
				    format(Str, sizeof(Str),"{F0E68C}-Ajuda-: O jogador %s[ID:%d] está pedindo ajuda de um administrador.",Nome(playerid),playerid);
			    	SendMessageToAdminsEx(Str);
				}
	   			if(listitem == 3)
				{
	            	ShowPlayerDialog(playerid, DIALOG_CREDITOS, DIALOG_STYLE_MSGBOX, "{ffffff}Créditos - {FF0000}GTB Torcidas", "{FF0000}Fundadores - {FFFFFF}Lelego\n{FF0000}Criadores do GM - {FFFFFF}Marola\n{FF0000}Mapa - {FFFFFF}Marola\n", "Fechar", "");
				}
			}
		}
	    switch(dialogid)
	    {
	        case DIALOG_ADMIN:
	        {
	            if(response)
	            {
	                ShowHouseMenu(playerid);
					TogglePlayerControllable(playerid, 1);
	                return 1;
	            }

	            if(!response)
	            {
	                ShowAdminMenu(playerid);
					TogglePlayerControllable(playerid, 1);
	                return 1;
	            }
	        }
	        case DIALOG_GUEST:
	        {
	            if (!response)
	                return TogglePlayerControllable(playerid, 1);

	            new house = GetProxHouse(playerid);

	            if(houseData[house][houseStatus] == 1)
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Esta casa está trancada.");
	                TogglePlayerControllable(playerid, 1);

	                new logString[700];

	                format(logString, sizeof logString, "O jogador %s[%d], tentou entrar na casa %d, mas ela estava trancada.", playerName, playerid, house);
	                WriteLog(LOG_HOUSES, logString);

	                return 1;
	            }

	            else
	            {
	                if(PlayerToPoint(5.0, playerid, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]))
	                {
	                    SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	                    SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	                    SetPlayerInterior(playerid, houseData[house][houseInterior]);

	                    TogglePlayerControllable(playerid, 1);
	                    SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");

	                    new
	                        logString[700];

	                    format(logString, sizeof logString, "O jogador %s[%d], entrou na casa %d como visitante.", playerName, playerid, house);
	                    WriteLog(LOG_HOUSES, logString);
	                }
	            }
	        }
	        case DIALOG_RENTING_GUEST:
	        {
	            if(!response)
	                return TogglePlayerControllable(playerid, 1);

	            new
	                house = GetProxHouse(playerid);

	            switch(listitem)
	            {
	                case 0:
	                {
	                    if(houseData[house][houseStatus] == 1)
	                    {
	                        SendClientMessage(playerid, COLOR_ERROR, "* Esta casa está trancada!");
	                        TogglePlayerControllable(playerid, 1);

	                        new
	                            logString[256];

	                        format(logString, sizeof logString, "O jogador %s[%d], tentou entrar na casa %d, mas ela estava trancada.", playerName, playerid, house);
	                        WriteLog(LOG_HOUSES, logString);
	                        return 1;
	                    }

	                    else
	                    {
	                        if(IsPlayerInRangeOfPoint(playerid, 5.0, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]))
	                        {
	                            SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	                            SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	                            SetPlayerInterior(playerid, houseData[house][houseInterior]);

	                            TogglePlayerControllable(playerid, 1);
	                            SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");

	                            new
	                                logString[128];

	                            format(logString, sizeof logString, "O jogador %s[%d], entrou na casa %d como visitante.", playerName, playerid, house);
	                            WriteLog(LOG_HOUSES, logString);
	                        }
	                    }
	                }
	                case 1:
	                {
	                    new
	                        ownerFile[200];

	                    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	                    if(DOF2_FileExists(ownerFile))
	                    {
	                        new
	                            alreadyOwner = DOF2_GetInt(ownerFile, "houseID"),
	                            string[128];

	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);

	                        format(string, sizeof string, "* Você já é dono da casa %d! Não pode alugar uma casa.!", alreadyOwner);
	                        SendClientMessage(playerid, COLOR_ERROR, string);

	                        TogglePlayerControllable(playerid, 1);
	                        new
	                            logString[700];

	                        format(logString, sizeof logString, "O jogador %s[%d], tentou alugar a casa %d, mais ele já é dono da casa %d.", playerName, playerid, house, alreadyOwner);
	                        WriteLog(LOG_HOUSES, logString);

	                        return 1;
	                    }

	                    new
	                        stringCat[600],
	                        string[100],
	                        string2[100],
	                        string3[100];

	                    GetPlayerName(playerIDOffer, playerName, MAX_PLAYER_NAME);
	                    TogglePlayerControllable(playerIDOffer, 1);

	                    format(string, sizeof string, "{00F2FC}Dono da casa a ser alugada: {46FE00}%s\n\n", houseData[house][houseOwner]);
	                    format(string2, sizeof string2, "{00F2FC}Valor a ser pago pelo aluguel da casa: {FFFFFF}$%d\n", houseData[house][houseRentPrice]);
	                    format(string3, sizeof string3, "{00F2FC}ID da casa a ser alugada: {FFFFFF}%d\n", house);

	                    strcat(stringCat, "{00F2FC}Após alugar a casa, o aluguel será cobrado todo dia 00:00! Se você não estiver online\n");
	                    strcat(stringCat, "o aluguel será cobrado quando você entrar novamente no servidor.\n\n");
	                    strcat(stringCat, string);
	                    strcat(stringCat, string2);
	                    strcat(stringCat, string3);
	                    strcat(stringCat, "{FD0900}ATENÇÃO:{FFFFFF} A casa dita acima vai ser alugada por você e você poderá trancar e destrancar a casa, tanto como nascerá nela.\nVocê também vai poder trancar e destrancar o carro caso ela tiver, caso não tiver você pode ajudar o dono a comprar um\npagando seu aluguel regurlamente.\n");
	                    strcat(stringCat, "Você deseja alugar a casa, baseada nas informações acima descritas?\n");

	                    ShowPlayerDialog(playerid, DIALOG_RENT_CONFIRM, DIALOG_STYLE_MSGBOX, "Venda de casa", stringCat, "Alugar", "Negar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	            }
	        }
	        case DIALOG_UNRENT_CONFIRM:
	        {
	            if (!response)
	                return SendClientMessage(playerid, COLOR_ERROR, "* Cancelado.");
	            new
	                tenantFile[200],
	                houseFile[200],
	                house = GetProxHouse(playerid),
	                logString[128];

	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", houseData[house][houseTenant]);
	            format(houseFile, sizeof houseFile, "LHouse/Casas/Casa %d.txt", house);
	            format(houseData[house][houseTenant], 24, "Ninguem");

	            DOF2_RemoveFile(tenantFile);
	            DOF2_SetString(houseFile, "Locador", "Ninguem", "Aluguel");

	            TogglePlayerControllable(playerid, 1);
	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(logString, sizeof logString, "O jogador %s[%d], desalugou a casa %d.", playerName, playerid, house);
	            WriteLog(LOG_HOUSES, logString);

	            return 1;
	        }
	        case DIALOG_RENT_CONFIRM:
	        {
	            if(!response)
	                return 1;

	            new
	                house = GetProxHouse(playerid),
	                tenantFile[200],
	                houseFile[200],
	                logString[128];

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", playerName);
	            format(houseFile, sizeof houseFile, "LHouse/Casas/Casa %d.txt", house);

	            if(DOF2_FileExists(tenantFile))
	            {
	                new
	                    alreadyTenant = DOF2_GetInt(tenantFile, "houseID"),
	                    string[128];

	                GetPlayerPos(playerid, X, Y, Z);
	                PlayerPlaySound(playerid, 1085, X, Y, Z);

	                format(string, sizeof string, "* Você já é locador da casa %d! Você só pode ter 1 casa alugada!", alreadyTenant);
	                SendClientMessage(playerid, COLOR_ERROR, string);

	                TogglePlayerControllable(playerid, 1);

	                format(logString, sizeof logString, "O jogador %s[%d], tentou alugar a casa %d, mas ele já é locador da casa %d.", playerName, playerid, house, alreadyTenant);
	                WriteLog(LOG_HOUSES, logString);
	                return 1;
	            }

	            format(houseData[house][houseTenant], 24, playerName);

	            DOF2_CreateFile(tenantFile);
	            DOF2_SetInt(tenantFile, "houseID", house);
	            DOF2_SetString(houseFile, "Locador", houseData[house][houseTenant], "Aluguel");

	            SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	            SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	            SetPlayerInterior(playerid, houseData[house][houseInterior]);

	            DOF2_SaveFile();
	            Update3DText(house);

	            format(logString, sizeof logString, "O jogador %s[%d], alugou a casa %d.", playerName, playerid, house);
	            WriteLog(LOG_HOUSES, logString);
	        }
	        case DIALOG_EDIT_HOUSE:
	        {
	            if(!response)
	                return TogglePlayerControllable(playerid, 1);

	            new
	                house = GetProxHouse(playerid);

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            switch(listitem)
	            {
	                case 0:
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 5.0, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]))
	                    {
	                        SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	                        SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	                        SetPlayerInterior(playerid, houseData[house][houseInterior]);

	                        TogglePlayerControllable(playerid, 1);
	                        SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");

	                        new
	                            logString[128];

	                        format(logString, sizeof logString, "O administrador %s[%d], entrou na casa %d como administrador.", playerName, playerid, house);
	                        WriteLog(LOG_HOUSES, logString);
	                        WriteLog(LOG_ADMIN, logString);


	                    }
	                }
	                case 1:
	                {
	                	if(strcmp(houseData[house][houseOwner], "Ninguem", true))
	                    {
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);

	                        SendClientMessage(playerid, COLOR_ERROR, "* Não é possível alterar o preço de uma casa que não está a venda.");

	                        new
	                            logString[128];

	                        format(logString, sizeof logString, "O administrador %s[%d], tentou alterar o preço da casa %d, mas ela não está a venda.", playerName, playerid, house);
	                        WriteLog(LOG_ADMIN, logString);

	                        ShowAdminMenu(playerid);
	                        return 1;
	                    }

	                    ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o preço da casa.", "{FFFFFF}Digite o novo preço que você quer abaixo\n{FFFFFF}Use somente números.\n", "Alterar", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 2:
	                {
	                	if(houseData[house][houseRentable] == 0)
	                    {
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);

	                        SendClientMessage(playerid, COLOR_ERROR, "* Não é possível alterar o preço do aluguel de uma casa que não está sendo alugada.");

	                        new
	                            logString[700];

	                        format(logString, sizeof logString, "O administrador %s[%d], tentou alterar o preço de aluguel da casa %d, mas ela não está sendo alugada.", playerName, playerid, house);
	                        WriteLog(LOG_ADMIN, logString);

	                        ShowAdminMenu(playerid);
	                        return 1;
	                    }

	                    ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_RENT_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o preço do aluguel.", "{FFFFFF}Digite o novo preço que você quer abaixo\n{FFFFFF}Use somente números.\n", "Alterar", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 3:
	                {
	                    new
	                        stringCat[1200];

	                    strcat(stringCat, "Interior {FB1300}1 \t{FCEC00}6 {FFFFFF}Comodos\n");
	                    strcat(stringCat, "Interior {FB1300}2 \t{FCEC00}3 {FFFFFF}Comodos\n");
	                    strcat(stringCat, "Interior {FB1300}3 \t{FCEC00}3 {FFFFFF}Comodos\n");
	                    strcat(stringCat, "Interior {FB1300}4 \t{FCEC00}1 {FFFFFF}Comodo\n");
	                    strcat(stringCat, "Interior {FB1300}5 \t{FCEC00}1 {FFFFFF}Comodo\n");
	                    strcat(stringCat, "Interior {FB1300}6 \t{FCEC00}3 {FFFFFF}Comodos \t{FFFFFF}(Casa do CJ)\n");
	                    strcat(stringCat, "Interior {FB1300}7 \t{FCEC00}5 {FFFFFF}Comodos\n");
	                    strcat(stringCat, "Interior {FB1300}8 \t{FCEC00}7 {FFFFFF}Comodos\n");
	                    strcat(stringCat, "Interior {FB1300}9 \t{FCEC00}4 {FFFFFF}Comodos\n");
	                    strcat(stringCat, "Interior {FB1300}10 \t{FCEC00}Muitos {FFFFFF}Comodos \t{FFFFFF} (Casa do Madd Dog)\n");
	                    strcat(stringCat, "Interior {FB1300}11 \t{FCEC00}7 {FFFFFF}Comodos\n");

	                    ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_INT, DIALOG_STYLE_LIST,"{00F2FC}Você escolheu alterar o interior da casa.", stringCat, "Continuar", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 4:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_HOUSE_STATUS, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu mudar o status dessa casa.", "{FFFFFF}Oque você gostaria de fazer com o status atual da casa?\n", "Trancar", "Destrancar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 5:
	                {
	                    new
	                        stringMessage[128];

	                    if (strlen(houseData[house][houseTitle]) > 0)
	                    {
	                        format(stringMessage, sizeof stringMessage, "{FFFFFF}Digite o novo título da casa.\n\nTítulo anterior: %s\n", houseData[house][houseTitle]);
	                        ShowPlayerDialog(playerid, DIALOG_HOUSE_TITLE_ADMIN, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar o título da casa.", stringMessage, "Alterar", "Voltar");
	                    }
	                    else
	                        ShowPlayerDialog(playerid, DIALOG_HOUSE_TITLE_ADMIN, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar o título da casa.", "{FFFFFF}Digite o novo título da casa.\n\nTítulo anterior: {FFFFFF}Título ainda não definido\n", "Alterar", "Voltar");

	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 6:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_CHANGE_OWNER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o dono da casa.", "{FFFFFF}Digite o {FFFFFF}ID {FFFFFF}ou {FFFFFF}nickname {FFFFFF}do novo dono", "Continuar", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 7:
	                {
	                	if(houseVehicle[house][vehicleModel] != 0)
	                    {
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);

	                        SendClientMessage(playerid, COLOR_ERROR, "* Essa casa já tem carro.");
	                        ShowAdminMenu(playerid);

	                        new
	                            logString[128];

	                        format(logString, sizeof logString, "O administrador %s[%d], tentou criar um carro para a casa %d, mas ela já tem carro.", playerName, playerid, house);
	                        WriteLog(LOG_ADMIN, logString);

	                        return 1;
	                    }

	                    houseIDReceiveCar = house;
	                    adminCreatingVehicle[playerid] = true;
	                    SendClientMessage(playerid, COLOR_INFO, "* Vá aonde você quer criar o carro (em uma rua de preferência) e digite {46FE00}/criaraqui.");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 8:
	                {
	                	if(!strcmp(houseData[house][houseOwner], "Ninguem", true))
	                    {
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);

	                        SendClientMessage(playerid, COLOR_ERROR, "* Não é possível vender uma casa que já está a venda.");
	                        ShowAdminMenu(playerid);

	                        new
	                            logString[128];

	                        format(logString, sizeof logString, "O administrador %s[%d], tentou vender a casa %d, mas ela já está à venda.", playerName, playerid, house);
	                        WriteLog(LOG_ADMIN, logString);

	                        return 1;
	                    }

	                    ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE_ADMIN, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu botar essa casa a venda", "{FFFFFF}Você tem certeza que deseja botar essa casa a venda?", "Sim", "Não");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 9:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_DELETE_HOUSE, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu deletar casa.", "{FFFFFF}Se a casa ter dono, ele não vai ter o dinheiro que gastou na casa novamente.\n{FFFFFF}Você confirma essa ação?", "Deletar", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	            }
	        }
	        case DIALOG_SELL_HOUSE_ADMIN:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            new
	                house = GetProxHouse(playerid),
	                filePath[200],
	                ownerFile[200],
	                tenantFile[200];

	        	format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);
	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", houseData[house][houseTenant]);
	            GetPlayerName(houseData[house][houseOwner], playerName, MAX_PLAYER_NAME);
	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	            if(DOF2_FileExists(ownerFile))
	                return DOF2_RemoveFile(ownerFile);

	            if(DOF2_FileExists(tenantFile))
	                return DOF2_RemoveFile(tenantFile);

				format(houseData[house][houseOwner], 255, "Ninguem");
				format(houseData[house][houseTenant], 255, "Ninguem");

				DOF2_SetString(filePath, "Dono", "Ninguem", "Informações");
				DOF2_SetString(filePath, "Locador", "Ninguem", "Aluguel");
				DOF2_RemoveFile(ownerFile);
	            DOF2_SaveFile();

	        	DestroyDynamicPickup(housePickupIn[house]);
	        	DestroyDynamicMapIcon(houseMapIcon[house]);

	            Update3DText(house);
	            SendClientMessage(playerid, COLOR_SUCCESS, "* Casa colocada a venda com sucesso.");

	            new
	                logString[128];

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(logString, sizeof logString, "O administrador %s[%d], botou a casa %d, à venda.", playerName, playerid, house);
	            WriteLog(LOG_ADMIN, logString);

	            houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 31, -1, -1, 0, -1, 100.0);
	            housePickupIn[house] = CreateDynamicPickup(1273, 23, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
	        }
	        case DIALOG_CHANGE_OWNER:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            GetPlayerPos(playerid, X, Y, Z);

	            if(sscanf(inputtext, "u", newOwnerID))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* ID ou nome inválido!");
	                ShowPlayerDialog(playerid, DIALOG_CHANGE_OWNER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o dono da casa.", "{FFFFFF}Digite o {FFFFFF}ID {FFFFFF}ou {FFFFFF}nickname {FFFFFF}do novo dono", "Continuar", "Cancelar");
	                return 1;
	            }

	            if(!IsPlayerConnected(newOwnerID) || newOwnerID == INVALID_PLAYER_ID)
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Player desconectado!");
	                ShowPlayerDialog(playerid, DIALOG_CHANGE_OWNER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o dono da casa.", "{FFFFFF}Digite o {FFFFFF}ID {FFFFFF}ou {FFFFFF}nickname {FFFFFF}do novo dono", "Continuar", "Cancelar");
	                return 1;
	            }

	            new
	                ownerFile[200];

	            GetPlayerName(newOwnerID, playerName, MAX_PLAYER_NAME);
	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	            if(DOF2_FileExists(ownerFile))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Esse jogador já tem uma casa!");
	                ShowPlayerDialog(playerid, DIALOG_CHANGE_OWNER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o dono da casa.", "{FFFFFF}Digite o {FFFFFF}ID {FFFFFF}ou {FFFFFF}nickname {FFFFFF}do novo dono", "Continuar", "Cancelar");
	                return 1;
	            }

	            new
	                dialogString[200],
	                house;

	            house = GetProxHouse(playerid);
	            GetPlayerName(newOwnerID, playerName, MAX_PLAYER_NAME);

	            format(dialogString, sizeof dialogString, "{00F2FC}Dono Atual: {46FE00}%s\n{00F2FC}Novo Dono: {46FE00}%s\n\n{FFFFFF}Você confirma está ação?", houseData[house][houseOwner], playerName);
	            ShowPlayerDialog(playerid, DIALOG_CHANGE_OWNER2, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu alterar o dono da casa.", dialogString, "Sim", "Não");
	        }
	        case DIALOG_CHANGE_OWNER2:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            new
	                house = GetProxHouse(playerid),
	                filePath[200],
	                playerName2[MAX_PLAYER_NAME],
	                playerName3[MAX_PLAYER_NAME],
	                logString[128],
	                ownerFile[200],
	                newOwnerFile[200];

	            GetPlayerName(newOwnerID, playerName, MAX_PLAYER_NAME);
	            GetPlayerName(houseData[house][houseOwner], playerName2, MAX_PLAYER_NAME);
	            GetPlayerName(playerid, playerName3, MAX_PLAYER_NAME);

	            format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);
	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName2);
	            format(newOwnerFile, sizeof newOwnerFile, "LHouse/Donos/%s.txt", playerName);

	            if (!strcmp(playerName2, "Ninguem", true))
	            {
	                DOF2_CreateFile(newOwnerFile);
	                DOF2_SetInt(newOwnerFile, "houseID", house);
	                DOF2_SetString(filePath, "Dono", playerName, "Informações");
	                DOF2_SaveFile();

	                format(houseData[house][houseOwner], 24, playerName);
	                houseData[house][houseStatus] = DOF2_SetInt(filePath,"Status", 0, "Informações");

	                DestroyDynamicPickup(housePickupIn[house]);
	                DestroyDynamicMapIcon(houseMapIcon[house]);
	                housePickupIn[house] = CreateDynamicPickup(1272, 23, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
	                houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 32, -1, -1, 0, -1, 100.0);

	                Update3DText(house);
	                return 1;
	            }

	            format(logString, sizeof logString, "O administrador %s[%d], alterou o dono da casa %d, de %s para %s.", playerName3, playerid, house, playerName2, playerName);
	            WriteLog(LOG_ADMIN, logString);

	            DOF2_RenameFile(ownerFile, newOwnerFile);
	            DOF2_RemoveFile(ownerFile);
	            DOF2_SetString(filePath, "Dono", playerName);
	            DOF2_SaveFile();

	            format(houseData[house][houseOwner], 255, playerName);

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Dono da casa alterado com sucesso.");

	            Update3DText(house);

	            return 1;
	        }
	        case DIALOG_DELETE_HOUSE:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            new
	                house = GetProxHouse(playerid),
	                filePath[150],
	                houseAtual[200],
	                checkID[200],
	                logString[128],
	                ownerFile[200],
	                tenantFile[200],
	                playerName2[MAX_PLAYER_NAME],
	                playerName3[MAX_PLAYER_NAME];

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	            GetPlayerName(houseData[house][houseOwner], playerName2, MAX_PLAYER_NAME);
	            GetPlayerName(houseData[house][houseTenant], playerName3, MAX_PLAYER_NAME);

	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", playerName3);
	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName2);
	            format(logString, sizeof logString, "O administrador %s[%d], deletou a casa %d.", playerName, playerid, house);

	            WriteLog(LOG_ADMIN, logString);

	            if(DOF2_FileExists(ownerFile))
	                return DOF2_RemoveFile(ownerFile);

	            if(DOF2_FileExists(tenantFile))
	                return DOF2_RemoveFile(tenantFile);

	            DestroyDynamicPickup(housePickupIn[house]);
	            DestroyDynamicMapIcon(houseMapIcon[house]);
	            DestroyDynamic3DTextLabel(houseLabel[house]);

	            if(houseVehicle[house][vehicleModel] != 0)
	                DestroyVehicle(houseVehicle[house][vehicleHouse]);

	            DOF2_RemoveFile(filePath);

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Casa removida com sucesso.");

	            format(houseAtual, sizeof houseAtual, "LHouse/CasaAtual.txt");

	            for(new i = 1; i < MAX_HOUSES; i++)
	            {
	                format(checkID, sizeof checkID, "LHouse/Casas/Casa %d.txt", i);
	                if(!DOF2_FileExists(checkID))
	                {
	                    DOF2_SetInt(houseAtual, "IDAtual", i);
	                    break;
	                }
	            }

	            DOF2_SaveFile();
	            return 1;
	        }
	        case DIALOG_EDIT_HOUSE_PRICE:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            GetPlayerPos(playerid, X, Y, Z);

	            if(!IsNumeric(inputtext))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Digite apenas números!");
	                ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_RENT_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o preço do aluguel.", "{FFFFFF}Digite o novo preço que você quer abaixo\n{FFFFFF}Use somente números.\n", "Alterar", "Cancelar");
	                return 1;
	            }

	            if(!strlen(inputtext))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Digite algo no campo ou cancele!");
	                ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_RENT_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o preço do aluguel.", "{FFFFFF}Digite o novo preço que você quer abaixo\n{FFFFFF}Use somente números.\n", "Alterar", "Cancelar");
	                return 1;
	            }

	            new
	                house = GetProxHouse(playerid),
	                file[100],
	                logString[128];

	            format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);

	            houseData[house][housePrice] = strval(inputtext);
	            DOF2_SetInt(file, "Preço", houseData[house][housePrice], "Informações");
	            DOF2_SaveFile();

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(logString, sizeof logString, "O administrador %s[%d], alterou o preço da casa %d.", playerName, playerid, house);
	            WriteLog(LOG_ADMIN, logString);

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Preço da casa alterado com sucesso.");

	            Update3DText(house);
	        }
	        case DIALOG_HOUSE_TITLE_ADMIN:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            new
	                house = GetProxHouse(playerid);

	            if (!strlen(inputtext) && strlen(houseData[house][houseTitle]) > 0)
	            {
	                SendClientMessage(playerid, COLOR_INFO, "* Você removeu o título da casa.");
	                format(houseData[house][houseTitle], 32, "%s", inputtext);
	                Update3DText(house);
	                return 1;
	            }

	            else if (!strlen(inputtext) && strlen(houseData[house][houseTitle]) == 0)
	            {
	                SendClientMessage(playerid, COLOR_WARNING, "* A casa ainda não tem um título, portanto não é possível remove-lo.");
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_TITLE_ADMIN, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar o título dessa casa.", "{FFFFFF}Digite o novo título da casa.\n\nTítulo anterior: {FFFFFF}SEM TÍTULO\n", "Alterar", "Voltar");
	                return 1;
	            }

	            format(houseData[house][houseTitle], 32, "%s", inputtext);
	            Update3DText(house);

	            new
	                file[100],
	                logString[160];

	            format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);

	            DOF2_SetString(file, "Título", houseData[house][houseTitle], "Informações");
	            DOF2_SaveFile();

	            SendClientMessage(playerid, COLOR_INFO, "* Título alterado com sucesso.");

	            format(logString, sizeof logString, "O jogador/administrador %s[%d], alterou o título da casa %d para %s.", playerName, playerid, house, houseData[house][houseTitle]);
	            WriteLog(LOG_ADMIN, logString);
	            WriteLog(LOG_HOUSES, logString);
	        }
	        case DIALOG_HOUSE_TITLE:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            new
	                house = GetProxHouse(playerid);

	            if (!strlen(inputtext) && strlen(houseData[house][houseTitle]) > 0)
	            {
	                SendClientMessage(playerid, COLOR_WARNING, "* Você removeu o título da casa.");
	                format(houseData[house][houseTitle], 32, "%s", inputtext);
	                Update3DText(house);
	                return 1;
	            }

	            else if (!strlen(inputtext) && strlen(houseData[house][houseTitle]) == 0)
	            {
	                SendClientMessage(playerid, COLOR_WARNING, "* A casa ainda não tem um título, portanto não é possível remove-lo.");
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_TITLE_ADMIN, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar o título dessa casa.", "{FFFFFF}Digite o novo título da casa.\n\nTítulo anterior: {FFFFFF}SEM TÍTULO\n", "Alterar", "Voltar");
	                return 1;
	            }

	            format(houseData[house][houseTitle], 32, "%s", inputtext);
	            Update3DText(house);

	            new
	                file[100],
	                logString[160];

	            format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);

	            DOF2_SetString(file, "Título", houseData[house][houseTitle], "Informações");
	            DOF2_SaveFile();

	            SendClientMessage(playerid, COLOR_INFO, "* Título alterado com sucesso.");

	            format(logString, sizeof logString, "O jogador/administrador %s[%d], alterou o título da casa %d para %s.", playerName, playerid, house, houseData[house][houseTitle]);
	            WriteLog(LOG_ADMIN, logString);
	            WriteLog(LOG_HOUSES, logString);
	        }
	        case DIALOG_EDIT_HOUSE_RENT_PRICE:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            GetPlayerPos(playerid, X, Y, Z);

	            if(!IsNumeric(inputtext))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Digite apenas números!");
	                ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o preço da casa.", "{FFFFFF}Digite o novo preço que você quer abaixo\n{FFFFFF}Use somente números.\n", "Alterar", "Cancelar");
	                return 1;
	            }

	            if(!strlen(inputtext))
	            {
	                GetPlayerPos(playerid, X, Y, Z);
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Digite algo no campo ou cancele!");
	                ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar o preço da casa.", "{FFFFFF}Digite o novo preço que você quer abaixo\n{FFFFFF}Use somente números.\n", "Alterar", "Cancelar");
	                return 1;
	            }

	            new
	                house = GetProxHouse(playerid),
	                file[100],
	                logString[128];

	            format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);

	            houseData[house][houseRentPrice] = strval(inputtext);
	            DOF2_SetInt(file, "Preço do Aluguel", houseData[house][houseRentPrice], "Informações");
	            DOF2_SaveFile();

	            format(logString, sizeof logString, "O administrador %s[%d], alterou o preço de aluguel da casa %d.", playerName, playerid, house);
	            WriteLog(LOG_ADMIN, logString);

	            Update3DText(house);

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Preço do aluguel alterado com sucesso.");
	        }
	        case DIALOG_EDIT_HOUSE_INT:
	        {
	            if(!response)
	                return ShowAdminMenu(playerid);

	            switch(listitem)
	            {
	                case 0:
	                {
	                    houseInteriorX[playerid] = 2196.84;
	                    houseInteriorY[playerid] = -1204.36;
	                    houseInteriorZ[playerid] = 1049.02;
	                    houseInteriorFA[playerid] = 94.0010;
	                    houseInteriorInt[playerid] = 6;
	                }
	                case 1:
	                {
	                    houseInteriorX[playerid] = 2259.38;
	                    houseInteriorY[playerid] = -1135.89;
	                    houseInteriorZ[playerid] = 1050.64;
	                    houseInteriorFA[playerid] = 275.3992;
	                    houseInteriorInt[playerid] = 10;
	                }
	                case 2:
	                {
	                    houseInteriorX[playerid] = 2282.99;
	                    houseInteriorY[playerid] = -1140.28;
	                    houseInteriorZ[playerid] = 1050.89;
	                    houseInteriorFA[playerid] = 358.4660;
	                    houseInteriorInt[playerid] = 11;
	                }
	                case 3:
	                {
	                    houseInteriorX[playerid] = 2233.69;
	                    houseInteriorY[playerid] = -1115.26;
	                    houseInteriorZ[playerid] = 1050.88;
	                    houseInteriorFA[playerid] = 358.4660;
	                    houseInteriorInt[playerid] = 5;
	                }
	                case 4:
	                {
	                    houseInteriorX[playerid] = 2218.39;
	                    houseInteriorY[playerid] = -1076.21;
	                    houseInteriorZ[playerid] = 1050.48;
	                    houseInteriorFA[playerid] = 95.2635;
	                    houseInteriorInt[playerid] = 1;
	                }
	                case 5:
	                {
	                    houseInteriorX[playerid] = 2496.00;
	                    houseInteriorY[playerid] = -1692.08;
	                    houseInteriorZ[playerid] = 1014.74;
	                    houseInteriorFA[playerid] = 177.8159;
	                    houseInteriorInt[playerid] = 3;
	                }
	                case 6:
	                {
	                    houseInteriorX[playerid] = 2365.25;
	                    houseInteriorY[playerid] = -1135.58;
	                    houseInteriorZ[playerid] = 1050.88;
	                    houseInteriorFA[playerid] = 359.0367;
	                    houseInteriorInt[playerid] = 8;
	                }
	                case 7:
	                {
	                    houseInteriorX[playerid] = 2317.77;
	                    houseInteriorY[playerid] = -1026.76;
	                    houseInteriorZ[playerid] = 1050.21;
	                    houseInteriorFA[playerid] = 359.0367;
	                    houseInteriorInt[playerid] = 9;
	                }
	                case 8:
	                {
	                    houseInteriorX[playerid] = 2324.41;
	                    houseInteriorY[playerid] = -1149.54;
	                    houseInteriorZ[playerid] = 1050.71;
	                    houseInteriorFA[playerid] = 359.0367;
	                    houseInteriorInt[playerid] = 12;
	                }
	                case 9:
	                {
	                    houseInteriorX[playerid] = 1260.6603;
	                    houseInteriorY[playerid] = -785.4005;
	                    houseInteriorZ[playerid] = 1091.9063;
	                    houseInteriorFA[playerid] = 270.9891;
	                    houseInteriorInt[playerid] = 5;
	                }
	                case 10:
	                {
	                    houseInteriorX[playerid] = 140.28;
	                    houseInteriorY[playerid] = 1365.92;
	                    houseInteriorZ[playerid] = 1083.85;
	                    houseInteriorFA[playerid] = 9.6901;
	                    houseInteriorInt[playerid] = 5;
	                }
	            }

	            new
	                house = GetProxHouse(playerid),
	                file[100];

	            format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);

	            houseData[house][houseIntX] = houseInteriorX[playerid];
	            houseData[house][houseIntY] = houseInteriorY[playerid];
	            houseData[house][houseIntZ] = houseInteriorZ[playerid];
	            houseData[house][houseIntFA] = houseInteriorFA[playerid];
	            houseData[house][houseInterior] = houseInteriorInt[playerid];

	            DOF2_SetFloat(file, "Interior X", houseInteriorX[playerid], "Coordenadas");
	            DOF2_SetFloat(file, "Interior Y", houseInteriorY[playerid], "Coordenadas");
	            DOF2_SetFloat(file, "Interior Z", houseInteriorZ[playerid], "Coordenadas");
	            DOF2_SetFloat(file, "Interior Facing Angle", houseInteriorFA[playerid], "Coordenadas");
	            DOF2_SetInt(file, "Interior", houseInteriorInt[playerid], "Coordenadas");
	            DOF2_SaveFile();

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Interior da casa alterado com sucesso.");

	        	DestroyDynamicPickup(housePickupOut[house]);
	            housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            new
	                logString[128];

	            format(logString, sizeof logString, "O administrador %s[%d], alterou o interior da casa %d.", playerName, playerid, house);
	            WriteLog(LOG_ADMIN, logString);
	        }
	        case DIALOG_HOUSE_SELL_MENU:
	        {
	            if(!response)
	                return TogglePlayerControllable(playerid, 1);

	            switch(listitem)
	            {
	                case 0:
	                {
	                	new
	                        string[260],
	                        filePath[200],
	                        house = GetProxHouse(playerid),
	                        alreadyOwner,
	                        ownerFile[200],
	                        tenantFile[200],
	                        logString[128];

	                    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	                    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);
	                    format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", playerName);
	                    format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);

	                    if(DOF2_FileExists(ownerFile))
	                    {
	                        alreadyOwner = DOF2_GetInt(ownerFile, "houseID");
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        format(string, sizeof string, "* Você já é dono da casa %d! Você só pode ter 1 casa!", alreadyOwner);
	                        SendClientMessage(playerid, COLOR_ERROR, string);
	                        TogglePlayerControllable(playerid, 1);
	                        return 1;
	                    }

	                    else if(DOF2_FileExists(tenantFile))
	                    {
	                        alreadyOwner = DOF2_GetInt(tenantFile, "houseID");
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        format(string, sizeof string, "* Você já é locador da casa %d! Você só pode ter 1 casa!", alreadyOwner);
	                        SendClientMessage(playerid, COLOR_ERROR, string);
	                        return 1;
	                    }

	                	else if(GetPlayerMoney(playerid) < houseData[house][housePrice])
	                    {
	                        GetPlayerPos(playerid, X, Y, Z);
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        SendClientMessage(playerid, COLOR_ERROR, "* Você não tem dinheiro o suficiente.");
	                        TogglePlayerControllable(playerid, 1);
	                        return 1;
	                    }

	                  	format(string, sizeof string, "%s comprou a casa de id %d", playerName, house);
	                	print(string);
	                    WriteLog(LOG_HOUSES, string);

	                    DOF2_CreateFile(ownerFile);
	                    DOF2_SetInt(ownerFile, "houseID", house);
	                    DOF2_SetString(filePath, "Dono", playerName, "Informações");
	                    DOF2_SaveFile();

	                    format(houseData[house][houseOwner], 24, playerName);
	                    houseData[house][houseStatus] = DOF2_SetInt(filePath, "Status", 0, "Informações");

	                    GivePlayerMoney(playerid, -houseData[house][housePrice]);
	                    SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	                    SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	                    SetPlayerInterior(playerid, houseData[house][houseInterior]);

	                    DestroyDynamicPickup(housePickupIn[house]);
	                    DestroyDynamicMapIcon(houseMapIcon[house]);
	                    housePickupIn[house] = CreateDynamicPickup(1272, 23, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
	                    houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 32, -1, -1, 0, -1, 100.0);

	                    Update3DText(house);
	                    SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");

	                    format(logString, sizeof logString, "O jogador %s[%d], comprou a casa %d.", playerName, playerid, house);
	                    WriteLog(LOG_HOUSES, logString);
	                }
	                case 1:
	                {
	                    ShowAdminMenu(playerid);
	                    TogglePlayerControllable(playerid, 1);
	                }
	            }
	        }
	        case DIALOG_HOUSE_TENANT_MENU:
	        {
	            if(!response)
	                return TogglePlayerControllable(playerid, 1);

	            new
	                house = GetProxHouse(playerid),
	                logString[128],
	                string[200];

	            switch(listitem)
	            {
	                case 0:
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 5.0, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]))
	                    {
	                        SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	                        SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	                        SetPlayerInterior(playerid, houseData[house][houseInterior]);

	                        TogglePlayerControllable(playerid, 1);
	                        SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");


	                        GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	                        format(logString, sizeof logString, "O jogador %s[%d], entrou na casa %d como locador.", playerName, playerid, house);
	                        WriteLog(LOG_HOUSES, logString);
	                    }
	                }
	                case 1:
	                {
	                    TogglePlayerControllable(playerid, 1);
	                    ShowPlayerDialog(playerid, DIALOG_HOUSE_STATUS, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu mudar o status da casa.", "{FFFFFF}Oque você gostaria de fazer com o status atual da casa?\n", "Trancar", "Destrancar");
	                    return 1;
	                }
	                case 2:
	                {
	                    format(string, sizeof string, "{FFFFFF}Você deseja desalugar essa casa? {FFFFFF}(%d)\n", house);
	                    ShowPlayerDialog(playerid, DIALOG_UNRENT_CONFIRM, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu desalugar a casa.", string, "Sim", "Não");
	                }
	            }
	        }
	        case DIALOG_HOUSE_OWNER_MENU:
	        {
	            if(!response)
	                return TogglePlayerControllable(playerid, 1);

	            new
	                house = GetProxHouse(playerid);

	            GetPlayerPos(playerid, X, Y, Z);

	            switch(listitem)
	            {
	                case 0:
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 5.0, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]))
	                    {
	                        SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
	                        SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	                        SetPlayerInterior(playerid, houseData[house][houseInterior]);

	                        TogglePlayerControllable(playerid, 1);
	                        SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");


	                        new
	                            logString[128];

	                        GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	                        format(logString, sizeof logString, "O jogador %s[%d], entrou na casa %d como dono da casa.", playerName, playerid, house);
	                        WriteLog(LOG_HOUSES, logString);
	                    }
	                }
	                case 1:
	                {
	                    TogglePlayerControllable(playerid, 1);
	                    ShowPlayerDialog(playerid, DIALOG_RENT, DIALOG_STYLE_MSGBOX, "{00F2FC}Aluguel.", "{FFFFFF}Oque você gostaria de fazer com o aluguel da sua casa?\n", "Ativar", "Desativar");
	                    return 1;
	                }
	                case 2:
	                {
	                    TogglePlayerControllable(playerid, 1);
	                    ShowPlayerDialog(playerid, DIALOG_HOUSE_STATUS, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu mudar o status da sua casa.", "{FFFFFF}Oque você gostaria de fazer com o status atual da sua casa?\n", "Trancar", "Destrancar");
	                    return 1;
	                }
	                case 3:
	                {
	                	if(houseVehicle[house][vehicleModel] != 0)
	                    {
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        SendClientMessage(playerid, COLOR_ERROR, "* Sua casa já tem um carro. Venda-o antes.");
	                        TogglePlayerControllable(playerid, 1);
	                        return 1;
	                    }

	                    new
	                        stringCat[2500];

	                    strcat(stringCat, "Modelo {FB1300}475 \t{FCEC00}Sabre       \t\t{00EAFA}R$ 19.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}496 \t{FCEC00}Blista      \t\t{00EAFA}R$ 25.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}560 \t{FCEC00}Sultan      \t\t{00EAFA}R$ 26.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}401 \t{FCEC00}Bravura     \t\t{00EAFA}R$ 27.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}404 \t{FCEC00}Perenniel   \t\t{00EAFA}R$ 28.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}559 \t{FCEC00}Jester      \t\t{00EAFA}R$ 29.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}402 \t{FCEC00}Buffalo     \t\t{00EAFA}R$ 32.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}562 \t{FCEC00}Elegy       \t\t{00EAFA}R$ 35.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}589 \t{FCEC00}Club        \t\t{00EAFA}R$ 38.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}603 \t{FCEC00}Phoenix     \t\t{00EAFA}R$ 42.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}400 \t{FCEC00}Landstalker \t\t{00EAFA}R$ 65.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}429 \t{FCEC00}Banshee     \t\t{00EAFA}R$ 131.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}415 \t{FCEC00}Cheetah     \t\t{00EAFA}R$ 145.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}411 \t{FCEC00}Infernus    \t\t{00EAFA}R$ 150.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}409 \t{FCEC00}Limosine    \t\t{00EAFA}R$ 230.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}477 \t{FCEC00}ZR-350      \t\t{00EAFA}R$ 250.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}506 \t{FCEC00}Super GT    \t\t{00EAFA}R$ 500.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}541 \t{FCEC00}Bullet      \t\t{00EAFA}R$ 700.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}451 \t{FCEC00}Turismo     \t\t{00EAFA}R$ 850.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}468 \t{FCEC00}Sanchez     \t\t{00EAFA}R$ 40.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}461 \t{FCEC00}PCJ-600     \t\t{00EAFA}R$ 55.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}521 \t{FCEC00}FCR-900     \t\t{00EAFA}R$ 60.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}463 \t{FCEC00}Freeway     \t\t{00EAFA}R$ 80.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}522 \t{FCEC00}NRG-500     \t\t{00EAFA}R$ 150.000,00 {FFFFFF} - MOTO\n");
	                    ShowPlayerDialog(playerid, DIALOG_VEHICLES_MODELS, DIALOG_STYLE_LIST, "{FFFFFF}Escolha um modelo e clique em continuar.", stringCat, "Continuar", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 4:
	                {
	                    new
	                        string[250];

	                	if(houseVehicle[house][vehicleModel] != 0)
	                    {
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        SendClientMessage(playerid, COLOR_ERROR, "* Sua casa casa tem um carro. Venda-o antes de vender sua casa.");
	                        TogglePlayerControllable(playerid, 1);
	                        return 1;
	                    }

	                    format(string, sizeof string, "{FFFFFF}Você deseja vender sua casa por {FFFFFF}R$%d{FFFFFF}?\n", houseData[house][housePrice]/2);
	                    ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu vender sua casa.", string, "Sim", "Não");
	                    TogglePlayerControllable(playerid, 1);
	                    return 1;
	                }
	                case 5:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Digite o ID/playerName do player abaixo, é possível utilizar parte do nick quanto ID do player\n", "Próximo", "Voltar");
	                    TogglePlayerControllable(playerid, 1);
	                    return 1;
	                }
	                case 6:
	                {
	                    new
	                        string[250];

	                    if(houseData[house][houseRentable] == 0)
	                    {
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        SendClientMessage(playerid, COLOR_ERROR, "* Sua casa casa não está sendo alugada. Ative o aluguel antes.");
	                        TogglePlayerControllable(playerid, 1);
	                        return 1;
	                    }

	                	if(!strcmp(houseData[house][houseTenant], "Ninguem", false))
	                    {
	                        PlayerPlaySound(playerid, 1085, X, Y, Z);
	                        SendClientMessage(playerid, COLOR_ERROR, "* Não tem ninguém alugando sua casa no momento.");
	                        TogglePlayerControllable(playerid, 1);
	                        return 1;
	                    }

	                    format(string, sizeof string, "{FFFFFF}Você deseja despejar o locador {46FE00}%s{FFFFFF}, da sua casa?\n", houseData[house][houseTenant]);
	                    ShowPlayerDialog(playerid, DIALOG_DUMP_TENANT, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu despejar o locador da sua casa.", string, "Sim", "Não");
	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 7:
	                {
	                    new
	                        stringMessage[128];

	                    if (strlen(houseData[house][houseTitle]) > 0)
	                    {
	                        format(stringMessage, sizeof stringMessage, "{FFFFFF}Digite o novo título da casa.\n\nTítulo anterior: {46FE00}%s\n", houseData[house][houseTitle]);
	                        ShowPlayerDialog(playerid, DIALOG_HOUSE_TITLE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar o título da casa.", stringMessage, "Alterar", "Voltar");
	                    }
	                    else
	                        ShowPlayerDialog(playerid, DIALOG_HOUSE_TITLE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar o título da casa.", "{FFFFFF}Digite o novo título da casa.\n\nTítulo anterior: {FFFFFF}SEM TÍTULO\n", "Alterar", "Voltar");

	                    TogglePlayerControllable(playerid, 1);
	                }
	                case 8:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_STORAGE_HOUSE, DIALOG_STYLE_LIST, "{00F2FC}Você escolheu acessar o armazamento.", "{FFFFFF}Coletes a prova de bala", "Acessar", "Voltar");
	                    return 1;
	                }
	            }
	        }
	        case DIALOG_STORAGE_HOUSE:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            switch(listitem)
	            {
	                case 0: return ShowStorageMenu(playerid, 1);
	            }
	        }
	        case DIALOG_STORAGE_ARMOUR:
	        {
	            if(!response)
	                return ShowPlayerDialog(playerid, DIALOG_STORAGE_HOUSE, DIALOG_STYLE_LIST, "{00F2FC}Você escolheu acessar o armazamento.", "{FFFFFF}Coletes a prova de bala", "Acessar", "Voltar");

	            new
	                storageFile[100],
	                slotStorageID[20],
	                house = GetProxHouse(playerid);

	            PlayerPlaySound(playerid, 1085, X, Y, Z);
	            GetPlayerArmour(playerid, oldArmour);

	            format(storageFile, sizeof storageFile, "LHouse/Armazenamento/Casa %d.txt", house);

	            for(new s; s < MAX_ARMOUR; s++)
	            {
	                if (listitem == s)
	                {
	                    if(houseData[house][houseArmourStored][s] > 0)
	                    {
	                        if(oldArmour > 0)
	                        {
	                            PlayerPlaySound(playerid, 1085, X, Y, Z);
	                            SendClientMessage(playerid, COLOR_WARNING, "* Você só pode pegar um colete quando você não estiver usando um.");
	                            ShowStorageMenu(playerid, 1);
	                            printf("debug: oldArmour = %f, error 00245", oldArmour);
	                            return 1;
	                        }

	                        SetPlayerArmour(playerid, houseData[house][houseArmourStored][s]);
	                        houseData[house][houseArmourStored][s] = 0;
	                        ShowStorageMenu(playerid, 1);

	                        SendClientMessage(playerid, COLOR_INFO, "* Você vestiu o colete com sucesso.");

	                        if(!DOF2_FileExists(storageFile))
	                            DOF2_CreateFile(storageFile);

	                        format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);
	                        DOF2_SetFloat(storageFile, slotStorageID, 0, "Colete");
	                        DOF2_SaveFile();

	                        return 1;
	                    }
	                    else if(houseData[house][houseArmourStored][s] == 0)
	                    {
	                        if(oldArmour == 0)
	                        {
	                            PlayerPlaySound(playerid, 1085, X, Y, Z);
	                            SendClientMessage(playerid, COLOR_WARNING, "* Você não tem colete para armazenar.");
	                            ShowStorageMenu(playerid, 1);
	                            return 1;
	                        }
	                        else if(oldArmour >= 1 && oldArmour <= 99)
	                        {
	                            PlayerPlaySound(playerid, 1085, X, Y, Z);
	                            SendClientMessage(playerid, COLOR_WARNING, "* É necessário que o seu colete esteja totalmente cheio para que possa ser armazenado.");
	                            ShowStorageMenu(playerid, 1);
	                            return 1;
	                        }

	                        houseData[house][houseArmourStored][s] = 100;
	                        SetPlayerArmour(playerid, 0);
	                        ShowStorageMenu(playerid, 1);

	                        SendClientMessage(playerid, COLOR_INFO, "* Colete armazenado com sucesso.");

	                        if(!DOF2_FileExists(storageFile))
	                            DOF2_CreateFile(storageFile);

	                        format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);
	                        DOF2_SetFloat(storageFile, slotStorageID, 100, "Colete");
	                        DOF2_SaveFile();

	                        return 1;
	                    }
	                }
	            }
	            return 1;
	        }

	        case DIALOG_DUMP_TENANT:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            new
	                house = GetProxHouse(playerid),
	                tenantFile[200],
	                houseFile[200],
	                string[128],
	                string2[128],
	                playerName2[MAX_PLAYER_NAME],
	                logString[128],
	                tenantID = GetTenantID(house);

	            if(tenantID != -255)
	            {
	                if(GetPlayerVirtualWorld(tenantID) == house)
	                {
	        			SetPlayerPos(tenantID, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
	        			SetPlayerInterior(tenantID, 0);
	        			SetPlayerVirtualWorld(tenantID, 0);
	                }
	            }

	            format(string, sizeof string, "* Você foi despejado. Procure {46FE00}%s {FFFFFF}para saber o motivo.", houseData[house][houseOwner]);
	            format(string2, sizeof string2, "* Você despejou {46FE00}%s {FFFFFF}com sucesso, ele deve te procurar para saber o motivo.", houseData[house][houseTenant]);

	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", houseData[house][houseTenant]);
	            format(houseFile, sizeof houseFile, "LHouse/Casas/Casa %d.txt", house);

	            SendClientMessage(houseData[house][houseTenant], COLOR_INFO, string);
	            SendClientMessage(playerid, COLOR_INFO, string2);

	            GetPlayerName(houseData[house][houseTenant], playerName2, MAX_PLAYER_NAME);
	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(logString, sizeof logString, "O jogador %s[%d], despejou o locador %s da casa %d.", playerName, playerid, playerName2, house);
	            WriteLog(LOG_HOUSES, logString);


	            DOF2_RemoveFile(tenantFile);
	            format(houseData[house][houseTenant], 24, "Ninguem");
	            DOF2_SetString(houseFile, "Locador", "Ninguem", "Aluguel");

	            return 1;
	        }
	        case DIALOG_HOUSE_SELL_PLAYER:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            new
	                targetID,
	                tenantFile[200],
	                ownerFile[200];

	            GetPlayerPos(playerid, X, Y, Z);

	            if(sscanf(inputtext, "u", targetID))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Digite o ID/playerName do player abaixo, é possível utilizar parte do nick quanto ID do player\n", "Próximo", "Cancelar");
	                return 1;
	            }

	            else if(!IsPlayerConnected(targetID) || targetID == INVALID_PLAYER_ID)
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Jogador não conectado!");
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Digite o ID/playerName do player abaixo, é possível utilizar parte do nick quanto ID do player\n", "Próximo", "Cancelar");
	                return 1;
	            }

	            GetPlayerName(targetID, playerName, MAX_PLAYER_NAME);

	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", playerName);
	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	            if(DOF2_FileExists(tenantFile))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Este player já é locador de uma casa!");
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Digite o ID/playerName do player abaixo, é possível utilizar parte do nick quanto ID do player\n", "Próximo", "Cancelar");
	                return 1;
	            }

	            else if(DOF2_FileExists(ownerFile))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Este player já é dono de uma casa!");
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Digite o ID/playerName do player abaixo, é possível utilizar parte do nick quanto ID do player\n", "Próximo", "Cancelar");
	                return 1;
	            }

	            else if(playerid == targetID)
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Você não pode vender a casa para você mesmo!");
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Digite o ID/playerName do player abaixo, é possível utilizar parte do nick quanto ID do player\n", "Próximo", "Cancelar");
	                return 1;
	            }

	            playerReceiveHouse = targetID;
	            ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER2, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Agora digite o preço abaixo e aguarde a confirmação\n{FFFFFF}Use somente números.\n", "Próximo", "Cancelar");
	        }
	        case DIALOG_HOUSE_SELL_PLAYER2:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            new
	                sellingHousePrice;

	            if(sscanf(inputtext, "d", sellingHousePrice))
	            {
	                GetPlayerPos(playerid, X, Y, Z);
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_PLAYER2, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu vender sua casa para um player.", "{FFFFFF}Agora digite o preço abaixo\n{FFFFFF}Use somente números.\n", "Próximo", "Cancelar");
	                return 1;
	            }

	            priceReceiveHouse = sellingHousePrice;

	            new
	                stringCat[600],
	                string[100],
	                string2[100],
	                string3[100],
	                string4[100],
	                playerName2[MAX_PLAYER_NAME],
	                ownerFile[200];

	            GetPlayerName(playerReceiveHouse, playerName, MAX_PLAYER_NAME);
	            GetPlayerName(playerid, playerName2, MAX_PLAYER_NAME);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName2);

	            houseSellingID = DOF2_GetInt(ownerFile, "houseID");
				playerIDOffer = playerid;

				format(string, sizeof string, "{00F2FC}Quem vai receber a casa: {46FE00}%s\n", playerName);
	            format(string2, sizeof string2, "{00F2FC}Valor a ser pago pela casa: {FFFFFF}$%d\n", sellingHousePrice);
	            format(string3, sizeof string3, "{00F2FC}ID da casa a ser vendida: {FFFFFF}%d\n", houseSellingID);
	            format(string4, sizeof string4, "{00F2FC}Dono da casa a ser vendida: {46FE00}%s\n\n", houseData[houseSellingID][houseOwner]);

				strcat(stringCat, string);
				strcat(stringCat, string2);
				strcat(stringCat, string3);
				strcat(stringCat, string4);
				strcat(stringCat, "{FD0900}ATENÇÃO:{FFFFFF} A casa dita acima vai ser do player para o qual a casa vai ser vendida, isso não pode ser desfeito,\nA menos que você a compre do player novamente.\n");
				strcat(stringCat, "Você deseja confirmar essa ação, baseada nas informações acima descritas?\n");

				ShowPlayerDialog(playerid, DIALOG_SELLING_CONFIRM, DIALOG_STYLE_MSGBOX, "Venda de casa para player", stringCat, "CONFIRMAR", "Cancelar");
	        }
	        case DIALOG_SELLING_CONFIRM:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            if (!IsPlayerConnected(playerReceiveHouse) || playerReceiveHouse == INVALID_PLAYER_ID)
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* O jogador se desconectou!");
	                playerReceiveHouse = 0;
	                return 1;
	            }

	            new
	                stringCat[600],
	                string[100],
	                string2[100],
	                string3[100];

	            GetPlayerName(playerIDOffer, playerName, MAX_PLAYER_NAME);
	            TogglePlayerControllable(playerIDOffer, 1);

	            strcat(stringCat, "{00F2FC}Há uma oferta para venda de uma casa para você!\n\n\n");

	            format(string, sizeof string, "{00F2FC}Dono da casa a ser vendida: {46FE00}%s\n\n", houseData[houseSellingID][houseOwner]);
	            format(string2, sizeof string2, "{00F2FC}Valor a ser pago pela casa: {FFFFFF}$%d\n", priceReceiveHouse);
	            format(string3, sizeof string3, "{00F2FC}ID da casa a ser vendida: {FFFFFF}%d\n", houseSellingID);

	            strcat(stringCat, string);
	            strcat(stringCat, string2);
	            strcat(stringCat, string3);
	            strcat(stringCat, "{FD0900}ATENÇÃO:{FFFFFF} A casa dita acima vai ser sua e isso não pode ser desfeito,\nA menos que você a venda para o player do qual você comprou.\n");
	            strcat(stringCat, "Você deseja comprar a casa, baseada nas informações acima descritas?\n");

	            ShowPlayerDialog(playerReceiveHouse, DIALOG_HOUSE_SELL_PLAYER3, DIALOG_STYLE_MSGBOX, "Venda de casa", stringCat, "Comprar", "Negar");
	        }
	        case DIALOG_HOUSE_SELL_PLAYER3:
	        {
	            GetPlayerPos(playerid, X, Y, Z);
	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            if(!response)
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                TogglePlayerControllable(playerid, 1);

	                new
	                    string[128];

	                format(string, sizeof string, "* O jogador {00F2FC}%s {FFFFFF}negou a sua oferta de comprar a casa número {00F2FC}%d {FFFFFF}por {00F2FC}$%d", playerName, houseSellingID, priceReceiveHouse);
	                SendClientMessage(playerIDOffer, COLOR_INFO, string);
	                return 1;
	            }

	            if(GetPlayerMoney(playerid) < priceReceiveHouse)
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                TogglePlayerControllable(playerid, 1);

	                new
	                    string[150];

	                format(string, sizeof string, "* O jogador {00F2FC}%s {FFFFFF}não tem dinheiro o suficiente para comprar a casa número {00F2FC}%d {FFFFFF}por {00F2FC}$%d", playerName, houseSellingID, priceReceiveHouse);
	                SendClientMessage(playerIDOffer, COLOR_INFO, string);
	                SendClientMessage(playerid, COLOR_ERROR, "* Você não tem dinheiro o suficiente!");
	                return 1;
	            }

	            new
	                housePath2[200],
	                playerName2[MAX_PLAYER_NAME],
	                house = houseSellingID,
	                ownerFile[200],
	                ownerFile2[200];

	            GivePlayerMoney(playerid, -priceReceiveHouse);
	            GivePlayerMoney(playerIDOffer, priceReceiveHouse);

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Negócio fechado! Divirta-se!");
	            SendClientMessage(playerIDOffer, COLOR_SUCCESS, "* Negócio fechado! Divirta-se!");

	            GetPlayerName(playerIDOffer, playerName2, 24);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName2);
	            format(ownerFile2, sizeof ownerFile2, "LHouse/Donos/%s.txt", playerName);
	            DOF2_RenameFile(ownerFile, ownerFile2);

	            format(housePath2, sizeof housePath2, "LHouse/Casas/Casa %d.txt", house);
				format(houseData[house][houseOwner], 255, playerName2);

				DOF2_SetString(housePath2, "Dono", playerName2);
				DOF2_SaveFile();

				SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
				SetPlayerVirtualWorld(playerid, house);
				SetPlayerInterior(playerid, houseData[house][houseInterior]);

				TogglePlayerControllable(playerid, 1);
				TogglePlayerControllable(playerIDOffer, 1);

				SendClientMessage(playerid, COLOR_INFO, "* Bem vindo!");

	            new
	                logString[128];

	            format(logString, sizeof logString, "O jogador %s[%d], vendeu a casa %d para o jogador %s[%d] por $%d.", playerName2, playerIDOffer, house, playerName, playerid, priceReceiveHouse);
	            WriteLog(LOG_HOUSES, logString);

				Update3DText(house);
	        }
	        case DIALOG_RENT:
	        {
	          	new
	                house = GetProxHouse(playerid);

	            GetPlayerPos(playerid, X, Y, Z);

	            if(response)
	            {
	                if(houseData[house][houseRentable] == 1)
	                {
	                    SendClientMessage(playerid, COLOR_ERROR, "* O aluguel da sua casa já está ativado!");
	                    PlayerPlaySound(playerid, 1085, X, Y, Z);
	                    return 1;
	                }
	                ShowPlayerDialog(playerid, DIALOG_RENT_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Insira o valor do aluguel.", "{FFFFFF}Insira o valor do aluguel que você quer.\nEsse valor vai ser entregue na sua casa a cada 24 horas se haver um locador na sua casa\n{FFFFFF}Use somente números.\n", "Alugar!", "Cancelar");
	            }
	            else
	            {
	                if(houseData[house][houseRentable] == 0)
	                {
	                    SendClientMessage(playerid, COLOR_ERROR, "* O aluguel da sua casa já está desativado!");
	                    PlayerPlaySound(playerid, 1085, X, Y, Z);
	                    return 1;
	                }

	            	if(strcmp(houseData[house][houseTenant], "Ninguem", false))
	                {
	                    GetPlayerPos(playerid, X, Y, Z);
	                    PlayerPlaySound(playerid, 1085, X, Y, Z);
	                    SendClientMessage(playerid, COLOR_ERROR, "* Não é possível desativar o aluguel com alguém alugando sua casa.");
	                    TogglePlayerControllable(playerid, 1);
	                    return 1;
	                }

	                houseData[house][houseRentable] = 0;
	                Update3DText(house);
	                SendClientMessage(playerid, COLOR_SUCCESS, "* Aluguel desativado com sucesso.");


	                new
	                    logString[128];

	                GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	                format(logString, sizeof logString, "O jogador %s[%d], desativou o aluguel da casa %d.", playerName, playerid, house);
	                WriteLog(LOG_HOUSES, logString);
	            }
	        }
	        case DIALOG_RENT_PRICE:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            GetPlayerPos(playerid, X, Y, Z);

	            if(!IsNumeric(inputtext))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Digite apenas números!");
	                ShowPlayerDialog(playerid, DIALOG_RENT_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Insira o valor do aluguel.", "{FFFFFF}Insira o valor do aluguel que você quer.\nEsse valor vai ser entregue na sua casa a cada 24 horas se haver um locador na sua casa\n{FFFFFF}Use somente números.\n", "Alugar!", "Cancelar");
	                return 1;
	            }

	            if(!strlen(inputtext))
	            {
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Digite algo no campo ou cancele!");
	                ShowPlayerDialog(playerid, DIALOG_RENT_PRICE, DIALOG_STYLE_INPUT, "{00F2FC}Insira o valor do aluguel.", "{FFFFFF}Insira o valor do aluguel que você quer.\nEsse valor vai ser entregue na sua casa a cada 24 horas se haver um locador na sua casa\n{FFFFFF}Use somente números.\n", "Alugar!", "Cancelar");
	                return 1;
	            }

	            new
	                house = GetProxHouse(playerid),
	                logString[128],
	                file[200];

	            format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);

	            houseData[house][houseRentable] = 1;
	            houseData[house][houseRentPrice] = strval(inputtext);

	            DOF2_SetInt(file, "Aluguel Ativado", houseData[house][houseRentable], "Aluguel");
	            DOF2_SetInt(file, "Preço do Aluguel", houseData[house][houseRentPrice], "Aluguel");
	            DOF2_SaveFile();

	            Update3DText(house);
	            SendClientMessage(playerid, COLOR_SUCCESS, "* Aluguel ativado com sucesso.");


	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	            format(logString, sizeof logString, "O jogador %s[%d], ativou o aluguel da casa %d por $%d.", playerName, playerid, house, houseData[house][houseRentPrice]);
	            WriteLog(LOG_HOUSES, logString);

	            return 1;
	        }
	        case DIALOG_CREATE_HOUSE:
	        {
	            if(!response)
	                return 1;

	            switch(listitem)
	            {
	                case 0:
	                {
	                    houseInteriorX[playerid] = 2196.84;
	                    houseInteriorY[playerid] = -1204.36;
	                    houseInteriorZ[playerid] = 1049.02;
	                    houseInteriorFA[playerid] = 94.0010;
	                    houseInteriorInt[playerid] = 6;
	                    houseIntPrice[playerid] = 65000;
	                }
	                case 1:
	                {
	                    houseInteriorX[playerid] = 2259.38;
	                    houseInteriorY[playerid] = -1135.89;
	                    houseInteriorZ[playerid] = 1050.64;
	                    houseInteriorFA[playerid] = 275.3992;
	                    houseInteriorInt[playerid] = 10;
	                    houseIntPrice[playerid] = 37000;
	                }
	                case 2:
	                {
	                    houseInteriorX[playerid] = 2282.99;
	                    houseInteriorY[playerid] = -1140.28;
	                    houseInteriorZ[playerid] = 1050.89;
	                    houseInteriorFA[playerid] = 358.4660;
	                    houseInteriorInt[playerid] = 11;
	                    houseIntPrice[playerid] = 37000;
	                }
	                case 3:
	                {
	                    houseInteriorX[playerid] = 2233.69;
	                    houseInteriorY[playerid] = -1115.26;
	                    houseInteriorZ[playerid] = 1050.88;
	                    houseInteriorFA[playerid] = 358.4660;
	                    houseInteriorInt[playerid] = 5;
	                    houseIntPrice[playerid] = 20000;
	                }
	                case 4:
	                {
	                    houseInteriorX[playerid] = 2218.39;
	                    houseInteriorY[playerid] = -1076.21;
	                    houseInteriorZ[playerid] = 1050.48;
	                    houseInteriorFA[playerid] = 95.2635;
	                    houseInteriorInt[playerid] = 1;
	                    houseIntPrice[playerid] = 20000;
	                }
	                case 5:
	                {
	                    houseInteriorX[playerid] = 2496.00;
	                    houseInteriorY[playerid] = -1692.08;
	                    houseInteriorZ[playerid] = 1014.74;
	                    houseInteriorFA[playerid] = 177.8159;
	                    houseInteriorInt[playerid] = 3;
	                    houseIntPrice[playerid] = 150000;
	                }
	                case 6:
	                {
	                    houseInteriorX[playerid] = 2365.25;
	                    houseInteriorY[playerid] = -1135.58;
	                    houseInteriorZ[playerid] = 1050.88;
	                    houseInteriorFA[playerid] = 359.0367;
	                    houseInteriorInt[playerid] = 8;
	                    houseIntPrice[playerid] = 320000;
	                }
	                case 7:
	                {
	                    houseInteriorX[playerid] = 2317.77;
	                    houseInteriorY[playerid] = -1026.76;
	                    houseInteriorZ[playerid] = 1050.21;
	                    houseInteriorFA[playerid] = 359.0367;
	                    houseInteriorInt[playerid] = 9;
	                    houseIntPrice[playerid] = 120000;
	                }
	                case 8:
	                {
	                    houseInteriorX[playerid] = 2324.41;
	                    houseInteriorY[playerid] = -1149.54;
	                    houseInteriorZ[playerid] = 1050.71;
	                    houseInteriorFA[playerid] = 359.0367;
	                    houseInteriorInt[playerid] = 12;
	                    houseIntPrice[playerid] = 95000;
	                }
	                case 9:
	                {
	                    houseInteriorX[playerid] = 1260.6603;
	                    houseInteriorY[playerid] = -785.4005;
	                    houseInteriorZ[playerid] = 1091.9063;
	                    houseInteriorFA[playerid] = 270.9891;
	                    houseInteriorInt[playerid] = 5;
	                    houseIntPrice[playerid] = 1200000;
	                }
	                case 10:
	                {
	                    houseInteriorX[playerid] = 140.28;
	                    houseInteriorY[playerid] = 1365.92;
	                    houseInteriorZ[playerid] = 1083.85;
	                    houseInteriorFA[playerid] = 9.6901;
	                    houseInteriorInt[playerid] = 5;
	                    houseIntPrice[playerid] = 660000;
	                }
	            }

	            new house, houseAtual[200], checkID[200], logString[128];

	            GetPlayerPos(playerid, X, Y, Z);
	            format(houseAtual, sizeof houseAtual, "LHouse/CasaAtual.txt");

	            if(!DOF2_FileExists(houseAtual))
	            {
	                DOF2_CreateFile(houseAtual);
	                DOF2_SetInt(houseAtual, "IDAtual", 1);
	                DOF2_SaveFile();
	                house = 1;
	            }

	            else
	            {
	                for(new i = 1; i < MAX_HOUSES; i++)
	                {
	                    format(checkID, sizeof checkID, "LHouse/Casas/Casa %d.txt", i);
	                    if(!DOF2_FileExists(checkID))
	                    {
	                        DOF2_SetInt(houseAtual, "IDAtual", i);
	                        DOF2_SaveFile();
	                        house = i;
	                        break;
	                    }
	                }
	            }

	            CreateHouse(house, X, Y, Z, houseInteriorX[playerid], houseInteriorY[playerid], houseInteriorZ[playerid], houseInteriorFA[playerid], houseIntPrice[playerid], houseInteriorInt[playerid]);
	            SendClientMessage(playerid, COLOR_SUCCESS, "* Casa criada com sucesso.");
	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(logString, sizeof logString, "O administrador %s[%d], criou a casa %d.", playerName, playerid, house);
	            WriteLog(LOG_ADMIN, logString);
	        }
	        case DIALOG_CAR_MENU:
	        {
	            if(!response)
	                return 1;

	            switch(listitem)
	            {
	                case 0:
	                {
	                    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	                    new ownerFile[200];

	                    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	                    new house = DOF2_GetInt(ownerFile, "houseID");

	                    houseCarSet[playerid] = true;
	                    if(!IsPlayerInVehicle(playerid, houseVehicle[house][vehicleHouse])) return SendClientMessage(playerid, COLOR_INFO, "* Entre no carro, estacione em um local e digite {46FE00}/estacionar{FFFFFF}.");

	                    SendClientMessage(playerid, COLOR_INFO, "* Estacione em um local e digite {46FE00}/estacionar{FFFFFF}.");
	                }
	                case 1:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_1, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Insira a cor 1 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                }
	                case 2:
	                {
	                    new
	                        stringCat[2500];

	                    strcat(stringCat, "Modelo {FB1300}475 \t{FCEC00}Sabre       \t\t{00EAFA}R$ 19.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}496 \t{FCEC00}Blista      \t\t{00EAFA}R$ 25.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}560 \t{FCEC00}Sultan      \t\t{00EAFA}R$ 26.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}401 \t{FCEC00}Bravura     \t\t{00EAFA}R$ 27.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}404 \t{FCEC00}Perenniel   \t\t{00EAFA}R$ 28.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}559 \t{FCEC00}Jester      \t\t{00EAFA}R$ 29.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}402 \t{FCEC00}Buffalo     \t\t{00EAFA}R$ 32.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}562 \t{FCEC00}Elegy       \t\t{00EAFA}R$ 35.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}589 \t{FCEC00}Club        \t\t{00EAFA}R$ 38.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}603 \t{FCEC00}Phoenix     \t\t{00EAFA}R$ 42.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}400 \t{FCEC00}Landstalker \t\t{00EAFA}R$ 65.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}429 \t{FCEC00}Banshee     \t\t{00EAFA}R$ 131.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}415 \t{FCEC00}Cheetah     \t\t{00EAFA}R$ 145.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}411 \t{FCEC00}Infernus    \t\t{00EAFA}R$ 150.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}409 \t{FCEC00}Limosine    \t\t{00EAFA}R$ 230.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}477 \t{FCEC00}ZR-350      \t\t{00EAFA}R$ 250.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}506 \t{FCEC00}Super GT    \t\t{00EAFA}R$ 500.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}541 \t{FCEC00}Bullet      \t\t{00EAFA}R$ 700.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}451 \t{FCEC00}Turismo     \t\t{00EAFA}R$ 850.000,00 \n");
	                    strcat(stringCat, "Modelo {FB1300}468 \t{FCEC00}Sanchez     \t\t{00EAFA}R$ 40.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}461 \t{FCEC00}PCJ-600     \t\t{00EAFA}R$ 55.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}521 \t{FCEC00}FCR-900     \t\t{00EAFA}R$ 60.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}463 \t{FCEC00}Freeway     \t\t{00EAFA}R$ 80.000,00 {FFFFFF} - MOTO\n");
	                    strcat(stringCat, "Modelo {FB1300}522 \t{FCEC00}NRG-500     \t\t{00EAFA}R$ 150.000,00 {FFFFFF} - MOTO\n");

	                    ShowPlayerDialog(playerid, DIALOG_CAR_MODELS_CHANGE, DIALOG_STYLE_LIST, "{FFFFFF}Escolha um modelo e clique em continuar.", stringCat, "Continuar", "Voltar");
	                }
	                case 3:
	                {
	                    ShowPlayerDialog(playerid, DIALOG_CHANGE_PLATE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar a placa do seu carro.", "{FFFFFF}Digite a nova placa.\n{FFFFFF}O número máximo de caracteres é 8!", "Alterar", "Voltar");
	                }
	                case 4:
	                {
	                    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	                    new
	                        ownerFile[200],
	                        string[200];

	                    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	                    new
	                        house = DOF2_GetInt(ownerFile, "houseID");

	                    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	                    format(string, sizeof string, "{FFFFFF}Tem certeza que deseja vender seu carro por {FFFFFF}$%d {FFFFFF}?\n{FFFFFF}Essa ação não pode ser desfeita", houseVehicle[house][vehiclePrice]/2);
						ShowPlayerDialog(playerid, DIALOG_SELL_CAR, DIALOG_STYLE_MSGBOX, "{00F2FC}Você escolheu vender o seu carro.", string, "Sim", "Não");
	                }
	            }
	        }
	        case DIALOG_CAR_MODELS_CREATED:
	        {
	            new vehiclePath2[200];

	            format(vehiclePath2, sizeof vehiclePath2, "LHouse/Casas/Casa %d.txt", houseIDReceiveCar);

	            if(!response)
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Você cancelou!");

	                DestroyVehicle(carSetted[playerid]);

	        		houseVehicle[houseIDReceiveCar][vehicleX] = 0.0;
	        		houseVehicle[houseIDReceiveCar][vehicleY] = 0.0;
	        		houseVehicle[houseIDReceiveCar][vehicleZ] = 0.0;
	                houseVehicle[houseIDReceiveCar][vehicleAngle] = 0.0;
	    			houseVehicle[houseIDReceiveCar][vehicleColor1] = 0;
	    			houseVehicle[houseIDReceiveCar][vehicleColor2] = 0;
	    			houseVehicle[houseIDReceiveCar][vehicleRespawnTime] = 0;
	                houseVehicle[houseIDReceiveCar][vehiclePrice] = 0;
	            	houseVehicle[houseIDReceiveCar][vehicleModel] = 0;

	            	DOF2_SetInt(vehiclePath2, "Modelo do Carro", houseVehicle[houseIDReceiveCar][vehicleModel], "Veículo");
	    			DOF2_SetFloat(vehiclePath2, "Coordenada do Veículo X", houseVehicle[houseIDReceiveCar][vehicleX], "Veículo");
	    			DOF2_SetFloat(vehiclePath2, "Coordenada do Veículo Y", houseVehicle[houseIDReceiveCar][vehicleY], "Veículo");
	    	   		DOF2_SetFloat(vehiclePath2, "Coordenada do Veículo Z", houseVehicle[houseIDReceiveCar][vehicleZ], "Veículo");
	                DOF2_SetFloat(vehiclePath2, "Angulo", houseVehicle[houseIDReceiveCar][vehicleAngle], "Veículo");
	    			DOF2_SetInt(vehiclePath2, "Cor 1", houseVehicle[houseIDReceiveCar][vehicleColor1], "Veículo");
	    			DOF2_SetInt(vehiclePath2, "Cor 2", houseVehicle[houseIDReceiveCar][vehicleColor2], "Veículo");
	    			DOF2_SetInt(vehiclePath2, "Valor", houseVehicle[houseIDReceiveCar][vehiclePrice], "Veículo");
	    			DOF2_SetInt(vehiclePath2, "Tempo de Respawn", houseVehicle[houseIDReceiveCar][vehicleRespawnTime], "Veículo");

	                DOF2_SaveFile();
	                return 1;
	            }

	            switch(listitem)
	            {
	                case 0:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 475;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 19000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 1:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 496;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 25000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 2:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 560;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 26000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 3:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 401;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 27000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 4:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 404;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 28000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 5:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 559;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 29000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 6:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 402;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 32000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 7:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 562;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 35000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 8:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 589;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 38000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 9:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 603;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 42000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 10:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 400;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 65000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 11:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 429;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 131000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 12:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 415;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 145000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 13:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 411;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 150000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 14:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 409;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 230000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 15:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 477;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 250000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 16:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 506;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 500000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 17:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 541;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 700000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 18:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 451;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 850000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 19:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 468;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 40000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 20:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 461;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 55000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 21:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 521;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 60000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 22:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 463;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 80000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	                case 23:
	                {
	            		houseVehicle[houseIDReceiveCar][vehicleModel] = 522;
	                    houseVehicle[houseIDReceiveCar][vehiclePrice] = 150000;
	                    CreateHouseVehicleBought(playerid, houseIDReceiveCar);
	                }
	            }
	        }

	        case DIALOG_CHANGE_PLATE:
	        {
	            if(!response)
	                return ShowHouseVehicleMenu(playerid);

	            if(!strlen(inputtext) || strlen(inputtext) > 8)
	            {
	                GetPlayerPos(playerid, X, Y, Z);
	                PlayerPlaySound(playerid, 1085, X, Y, Z);
	                SendClientMessage(playerid, COLOR_ERROR, "* Você não digitou nada ou digitou mais do que 8 caracteres!");

	                ShowPlayerDialog(playerid, DIALOG_CHANGE_PLATE, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu alterar a placa do seu carro.", "{FFFFFF}Digite a nova placa.\n{FFFFFF}O número máximo de caracteres é 8!", "Alterar", "Voltar");
	                return 1;
	            }

	            new
	                housePath[200],
	                plate[9],
	                ownerFile[200],
	                logString[128];

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	            new
	                house = DOF2_GetInt(ownerFile, "houseID");

	            format(housePath, sizeof housePath, "LHouse/Casas/Casa %d.txt", house);
				format(plate, sizeof plate, "%s", inputtext);

				houseVehicle[house][vehiclePlate] = plate;

	            DestroyVehicle(houseVehicle[house][vehicleHouse]);
	            houseVehicle[house][vehicleHouse] = CreateVehicle(houseVehicle[house][vehicleModel], houseVehicle[house][vehicleX], houseVehicle[house][vehicleY], houseVehicle[house][vehicleZ], houseVehicle[house][vehicleAngle], houseVehicle[house][vehicleColor1], houseVehicle[house][vehicleColor2], houseVehicle[house][vehicleRespawnTime]);
	            SetVehicleNumberPlate(houseVehicle[house][vehicleHouse], plate);

				DOF2_SetString(housePath, "Placa", houseVehicle[house][vehiclePlate], "Veículo");
				DOF2_SaveFile();

				SendClientMessage(playerid, COLOR_SUCCESS, "* Veículo atualizado com sucesso.");

	            format(logString, sizeof logString, "O jogador %s[%d], mudou a placa do carro da casa %d para %s.", playerName, playerid, house, plate);
	            WriteLog(LOG_VEHICLES, logString);

	            return 1;
	        }
	        case DIALOG_CAR_COLOR_1:
	        {
				if(!response)
	                return ShowHouseVehicleMenu(playerid);

	            if (!strval(inputtext))
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Utilize somente números.");
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_1, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Insira a cor 1 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            else if (!strlen(inputtext))
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Nâo deixe o campo vazio.");
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_1, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Insira a cor 1 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            else if (0 > strval(inputtext) || strval(inputtext) > 255)
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Use somente IDs entre 0 e 255.");
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_1, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Insira a cor 1 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            globalColor1 = strval(inputtext);

	            ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_2, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Agora insira a cor 2 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	        }
	        case DIALOG_CAR_COLOR_2:
	        {
	            if(!response)
	            {
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_1, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Insira a cor 1 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            if (!strval(inputtext))
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Utilize somente números.");
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_2, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Agora insira a cor 2 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            else if (!strlen(inputtext))
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Nâo deixe o campo vazio.");
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_2, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Agora insira a cor 2 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            else if (0 > strval(inputtext) || strval(inputtext) > 255)
	            {
	                SendClientMessage(playerid, COLOR_ERROR, "* Use somente IDs entre 0 e 255.");
	                ShowPlayerDialog(playerid, DIALOG_CAR_COLOR_2, DIALOG_STYLE_INPUT, "{00F2FC}Você escolheu mudar a cor do seu carro.", "{FFFFFF}Agora insira a cor 2 do carro.\n{FFFFFF}Utilize somente números de 0 a 255!", "Continuar", "Voltar");
	                return 1;
	            }

	            globalColor2 = strval(inputtext);

	            new
	                ownerFile[200];

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	            new
	                house = DOF2_GetInt(ownerFile, "houseID");

	            ChangeHouseVehicleColor(house, globalColor1, globalColor2);

	            new
	                logString[128];

	            format(logString, sizeof logString, "O jogador %s[%d], alterou a cor do carro da casa %d.", playerName, playerid, house);
	            WriteLog(LOG_VEHICLES, logString);

	            SendClientMessage(playerid, COLOR_SUCCESS, "* Veículo atualizado com sucesso.");
	        }
	        case DIALOG_CAR_MODELS_CHANGE:
	        {
	            if(!response)
	                return TogglePlayerControllable(playerid, 1);

	            new
	                filePath[200],
	                ownerFile[200];

	          	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

	            new
	                house = DOF2_GetInt(ownerFile, "houseID");

	            format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);

				switch(listitem)
				{
					case 0:
					{
						if(GetPlayerMoney(playerid) < 19000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 475, 19000, 0);
	                    GivePlayerMoney(playerid, -19000);
					}
					case 1:
					{
						if(GetPlayerMoney(playerid) < 25000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 496, 25000, 1);
	                    GivePlayerMoney(playerid, -25000);
					}
					case 2:
					{
						if(GetPlayerMoney(playerid) < 26000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 560, 26000, 1);
	                    GivePlayerMoney(playerid, -26000);
					}
					case 3:
					{
						if(GetPlayerMoney(playerid) < 27000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 401, 27000, 1);
	                    GivePlayerMoney(playerid, -27000);
					}
					case 4:
					{
						if(GetPlayerMoney(playerid) < 28000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

					    ChangeHouseVehicleModel(house, 404, 28000, 1);
	                    GivePlayerMoney(playerid, -28000);
					}
					case 5:
					{
						if(GetPlayerMoney(playerid) < 29000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 559, 29000, 1);
	                    GivePlayerMoney(playerid, -29000);
					}
					case 6:
					{
						if(GetPlayerMoney(playerid) < 32000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 402, 32000, 1);
	                    GivePlayerMoney(playerid, -32000);
					}
					case 7:
					{
						if(GetPlayerMoney(playerid) < 35000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 562, 35000, 1);
	                    GivePlayerMoney(playerid, -35000);
					}
					case 8:
					{
						if(GetPlayerMoney(playerid) < 38000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 589, 38000, 1);
	                    GivePlayerMoney(playerid, -38000);
					}
					case 9:
					{
						if(GetPlayerMoney(playerid) < 42000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 603, 42000, 1);
	                    GivePlayerMoney(playerid, -42000);
					}
					case 10:
					{
						if(GetPlayerMoney(playerid) < 65000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 400, 65000, 1);
	                    GivePlayerMoney(playerid, -65000);
					}
					case 11:
					{
						if(GetPlayerMoney(playerid) < 131000)
				     	{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 429, 131000, 1);
	                    GivePlayerMoney(playerid, -131000);
	                }
					case 12:
					{
						if(GetPlayerMoney(playerid) < 145000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 415, 145000, 1);
	                    GivePlayerMoney(playerid, -145000);
					}
					case 13:
					{
						if(GetPlayerMoney(playerid) < 150000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 411, 150000, 1);
	                    GivePlayerMoney(playerid, -150000);
					}
					case 14:
					{
						if(GetPlayerMoney(playerid) < 230000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 409, 230000, 1);
	                    GivePlayerMoney(playerid, -230000);
					}
					case 15:
					{
						if(GetPlayerMoney(playerid) < 250000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 477, 250000, 1);
	                    GivePlayerMoney(playerid, -250000);
					}
					case 16:
					{
						if(GetPlayerMoney(playerid) < 500000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 506, 500000, 1);
	                    GivePlayerMoney(playerid, -500000);
					}
					case 17:
					{
						if(GetPlayerMoney(playerid) < 700000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 541, 700000, 1);
	                    GivePlayerMoney(playerid, -700000);
					}
					case 18:
					{
						if(GetPlayerMoney(playerid) < 850000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 451, 850000, 1);
	                    GivePlayerMoney(playerid, -850000);
					}
					case 19:
					{
						if(GetPlayerMoney(playerid) < 40000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 468, 40000, 1);
	                    GivePlayerMoney(playerid, -40000);
					}
					case 20:
					{
						if(GetPlayerMoney(playerid) < 55000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 461, 55000, 1);
	                    GivePlayerMoney(playerid, -55000);
					}
					case 21:
					{
						if(GetPlayerMoney(playerid) < 60000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 521, 60000, 1);
	                    GivePlayerMoney(playerid, -60000);
					}
					case 22:
					{
						if(GetPlayerMoney(playerid) < 80000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 463, 80000, 1);
	                    GivePlayerMoney(playerid, -80000);
					}
					case 23:
					{
						if(GetPlayerMoney(playerid) < 150000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 522, 150000, 1);
	                    GivePlayerMoney(playerid, -150000);
					}
	            }
	        }
	        case DIALOG_VEHICLES_MODELS:
	        {
	            if(!response)
	            {
	                TogglePlayerControllable(playerid, 1);
	                return 1;
	            }
	            new filePath[200];
	          	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	            new ownerFile[200];
	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);
	            new house = DOF2_GetInt(ownerFile, "houseID");
	            format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);
				switch(listitem)
				{
					case 0:
					{
						if(GetPlayerMoney(playerid) < 19000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 475, 19000, 0);
						GivePlayerMoney(playerid, -19000);
						HouseVehicleDelivery(playerid);
					}
					case 1:
					{
						if(GetPlayerMoney(playerid) < 25000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

						ChangeHouseVehicleModel(house, 496, 25000, 0);
	                    GivePlayerMoney(playerid, -25000);
						HouseVehicleDelivery(playerid);
					}
					case 2:
					{
						if(GetPlayerMoney(playerid) < 26000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 560, 26000, 0);
					    GivePlayerMoney(playerid, -26000);
						HouseVehicleDelivery(playerid);
					}
					case 3:
					{
						if(GetPlayerMoney(playerid) < 27000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
	                    }

						ChangeHouseVehicleModel(house, 401, 27000, 0);
	                    GivePlayerMoney(playerid, -27000);
						HouseVehicleDelivery(playerid);
					}
					case 4:
					{
						if(GetPlayerMoney(playerid) < 28000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 404, 28000, 0);
	                    GivePlayerMoney(playerid, -28000);
	                    HouseVehicleDelivery(playerid);
					}
					case 5:
					{
						if(GetPlayerMoney(playerid) < 29000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 559, 28000, 0);
	                    GivePlayerMoney(playerid, -29000);
	                    HouseVehicleDelivery(playerid);
					}
					case 6:
					{
						if(GetPlayerMoney(playerid) < 32000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 402, 32000, 0);
	                    GivePlayerMoney(playerid, -32000);
	                    HouseVehicleDelivery(playerid);
					}
					case 7:
					{
						if(GetPlayerMoney(playerid) < 35000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 562, 35000, 0);
	                    GivePlayerMoney(playerid, -35000);
	                    HouseVehicleDelivery(playerid);
					}
					case 8:
					{
						if(GetPlayerMoney(playerid) < 38000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 589, 38000, 0);
	                    GivePlayerMoney(playerid, -38000);
	                    HouseVehicleDelivery(playerid);
					}
					case 9:
					{
						if(GetPlayerMoney(playerid) < 42000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 603, 42000, 0);
	                    GivePlayerMoney(playerid, -42000);
	                    HouseVehicleDelivery(playerid);
					}
					case 10:
					{
						if(GetPlayerMoney(playerid) < 65000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 400, 65000, 0);
	                    GivePlayerMoney(playerid, -65000);
	                    HouseVehicleDelivery(playerid);
					}
					case 11:
					{
						if(GetPlayerMoney(playerid) < 131000)
				     	{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 429, 131000, 0);
	                    GivePlayerMoney(playerid, -131000);
	                    HouseVehicleDelivery(playerid);
	                }
					case 12:
					{
						if(GetPlayerMoney(playerid) < 145000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 415, 145000, 0);
	                    GivePlayerMoney(playerid, -145000);
	                    HouseVehicleDelivery(playerid);
					}
					case 13:
					{
						if(GetPlayerMoney(playerid) < 150000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 411, 150000, 0);
	                    GivePlayerMoney(playerid, -145000);
	                    HouseVehicleDelivery(playerid);
					}
					case 14:
					{
						if(GetPlayerMoney(playerid) < 230000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 409, 230000, 0);
	                    GivePlayerMoney(playerid, -230000);
	                    HouseVehicleDelivery(playerid);
					}
					case 15:
					{
						if(GetPlayerMoney(playerid) < 250000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 477, 250000, 0);
	                    GivePlayerMoney(playerid, -250000);
	                    HouseVehicleDelivery(playerid);
					}
					case 16:
					{
						if(GetPlayerMoney(playerid) < 500000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 506, 500000, 0);
	                    GivePlayerMoney(playerid, -500000);
	                    HouseVehicleDelivery(playerid);
					}
					case 17:
					{
						if(GetPlayerMoney(playerid) < 700000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 541, 700000, 0);
	                    GivePlayerMoney(playerid, -700000);
	                    HouseVehicleDelivery(playerid);
					}
					case 18:
					{
						if(GetPlayerMoney(playerid) < 850000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 451, 850000, 0);
	                    GivePlayerMoney(playerid, -850000);
	                    HouseVehicleDelivery(playerid);
					}
					case 19:
					{
						if(GetPlayerMoney(playerid) < 40000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 468, 40000, 0);
	                    GivePlayerMoney(playerid, -40000);
	                    HouseVehicleDelivery(playerid);
					}
					case 20:
					{
						if(GetPlayerMoney(playerid) < 55000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 461, 55000, 0);
	                    GivePlayerMoney(playerid, -55000);
	                    HouseVehicleDelivery(playerid);
					}
					case 21:
					{
						if(GetPlayerMoney(playerid) < 60000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 521, 60000, 0);
	                    GivePlayerMoney(playerid, -60000);
	                    HouseVehicleDelivery(playerid);
					}
					case 22:
					{
						if(GetPlayerMoney(playerid) < 80000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 463, 80000, 0);
	                    GivePlayerMoney(playerid, -80000);
	                    HouseVehicleDelivery(playerid);
					}
					case 23:
					{
						if(GetPlayerMoney(playerid) < 150000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro insuficiente.");
							TogglePlayerControllable(playerid, 1);
							return 1;
						}

	                    ChangeHouseVehicleModel(house, 522, 150000, 0);
	                    GivePlayerMoney(playerid, -150000);
	                    HouseVehicleDelivery(playerid);
					}
	            }
	        }
	        case DIALOG_SELL_CAR:
	        {
	            if(!response)
	                return ShowHouseVehicleMenu(playerid);

	           	new
	                string[200],
	                filePath[200],
	                ownerFile[200],
	                logString[128];

	           	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);
	            new
	                house = DOF2_GetInt(ownerFile, "houseID");

	            format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);

				DestroyVehicle(houseVehicle[house][vehicleHouse]);
				DestroyVehicle(vehicleHouseCarDefined[house]);

				houseVehicle[house][vehicleHouse] = 0;
				houseVehicle[house][vehicleModel] = 0;
				houseVehicle[house][vehicleX] = 0;
				houseVehicle[house][vehicleY] = 0;
				houseVehicle[house][vehicleZ] = 0;
				houseVehicle[house][vehicleColor1] = 0;
				houseVehicle[house][vehicleColor2] = 0;

				DOF2_SetInt(filePath, "Carro", 0, "Veículo");
				DOF2_SetInt(filePath, "Modelo do Carro", 0, "Veículo");
				DOF2_SetFloat(filePath, "Coordenada do Veículo X", 0.0, "Veículo");
				DOF2_SetFloat(filePath, "Coordenada do Veículo Y", 0.0, "Veículo");
				DOF2_SetFloat(filePath, "Coordenada do Veículo Z", 0.0, "Veículo");
				DOF2_SetFloat(filePath, "Angulo", 0.0, "Veículo");
				DOF2_SetInt(filePath, "Cor 1", 0, "Veículo");
				DOF2_SetInt(filePath, "Cor 2", 0, "Veículo");
				DOF2_SetInt(filePath, "Status", 0, "Veículo");
				DOF2_SetString(filePath, "Placa", "LHouse S", "Veículo");
				DOF2_SaveFile();

	            carSell = houseVehicle[house][vehiclePrice]/2;
				GivePlayerMoney(playerid, carSell);

				format(string, sizeof string, "* Você vendeu seu carro por: {00EAFA}$%d", carSell);
				SendClientMessage(playerid, COLOR_SUCCESS, string);

	            format(logString, sizeof logString, "O jogador %s[%d], vendeu o carro da casa %d.", playerName, playerid, house);
	            WriteLog(LOG_VEHICLES, logString);

	        }
	        case DIALOG_HOUSE_STATUS:
	        {
	           	new
	                filePath[200],
	                house = GetProxHouse(playerid);

	           	format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);

	            GetPlayerPos(playerid, X, Y, Z);
	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            if(!response)
	            {
	                if(houseData[house][houseStatus] == 0)
	                {
	                    SendClientMessage(playerid, COLOR_ERROR, "* A casa já está destrancada!");
	                    PlayerPlaySound(playerid, 1085, X, Y, Z);
	                    return 1;
	                }

	                houseData[house][houseStatus] = 0;

	                DOF2_SetInt(filePath, "Status", 0, "Informações");
	                DOF2_SaveFile();

	                SendClientMessage(playerid, COLOR_SUCCESS, "* Casa destrancada com sucesso");

	                new
	                    logString[128];

	                format(logString, sizeof logString, "O jogador %s[%d], destrancou a casa %d.", playerName, playerid, house);
	                WriteLog(LOG_HOUSES, logString);
	                Update3DText(house);
	            }
	            else
	            {
	                if(houseData[house][houseStatus] == 1)
	                {
	                    PlayerPlaySound(playerid, 1085, X, Y, Z);
	                    SendClientMessage(playerid, COLOR_ERROR, "* A casa já está trancada!");
	                    return 1;
	                }

	                houseData[house][houseStatus] = 1;

	                DOF2_SetInt(filePath, "Status", 1, "Informações");
	                DOF2_SaveFile();

	                SendClientMessage(playerid, COLOR_SUCCESS, "* Casa trancada com sucesso");

	                new
	                    logString[128];

	                format(logString, sizeof logString, "O jogador %s[%d], destrancou a casa %d.", playerName, playerid, house);
	                WriteLog(LOG_HOUSES, logString);
	                Update3DText(house);
	            }
	        }
	        case DIALOG_SELL_HOUSE:
	        {
	            if(!response)
	                return ShowHouseMenu(playerid);

	            new
	                housePath[200],
	                ownerFile[200],
	                tenantFile[200],
	                annMessage[128],
	                logString[128],
	                totalPrice;

	            GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

	            format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt",playerName);

	            new
	                house = DOF2_GetInt(ownerFile, "houseID");

	            format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", houseData[house][houseTenant]);
	            format(housePath, sizeof housePath, "LHouse/Casas/Casa %d.txt", house);

	            totalPrice = houseData[house][housePrice]/2;

				GivePlayerMoney(playerid, totalPrice);

	            format(annMessage, sizeof annMessage, "* Você vendeu sua casa por $%d", totalPrice);
				SendClientMessage(playerid, COLOR_SUCCESS, annMessage);

				houseData[house][houseStatus] = DOF2_SetInt(housePath, "Status", 1, "Informações");
				format(houseData[house][houseOwner], 255, "Ninguem");
				format(houseData[house][houseTenant], 255, "Ninguem");

				DOF2_SetString(housePath, "Dono", "Ninguem", "Informações");
				DOF2_SetString(housePath, "Locador", "Ninguem", "Aluguel");
				DOF2_RemoveFile(ownerFile);

	            if(DOF2_FileExists(tenantFile))
	                return DOF2_RemoveFile(tenantFile);

				DestroyDynamicPickup(housePickupIn[house]);
				DestroyDynamicMapIcon(houseMapIcon[house]);

				SetPlayerPos(playerid, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				Update3DText(house);
				DOF2_SaveFile();

				houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 31, -1, -1, 0, -1, 100.0);
				housePickupIn[house] = CreateDynamicPickup(1273, 23, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);

	            format(logString, sizeof logString, "O jogador %s[%d], vendeu a casa %d.", playerName, playerid, house);
	            WriteLog(LOG_HOUSES, logString);

	        }
	    }
		return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)
	{
		SendClientMessage(playerid,COR_ERRO,"[ERRO]: Comando inexistente.");
	}
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	if(Player[playerid][pTorcida] == Player[damagedid][pTorcida])
	{
	    if(Player[playerid][EmTrabalho] == false)
		{
 			GameTextForPlayer(playerid, "~r~ Nao agrida alguem da sua mesma torcida.", 3000, 5);
		}
	}
	return 1;
}

// ========================= [ Comandos ] ===================================== //
CMD:comandosadmin(playerid)
{
	if(Player[playerid][pAdmin] < 1) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não tem permissão.");
	ComandosAdmin(playerid);
	return 1;
}

CMD:comandosrcon(playerid)
{
	if(!IsPlayerAdmin(playerid))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado na RCON.");
	ComandosRcon(playerid);
	return 1;
}

CMD:setadmin(playerid,params[])
{
	new id, level;
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(sscanf(params, "ud", id, level)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /setadmin [id] [level]");
	if(level > 5) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Level de administrador inválido!");
 	if(Logado[id] == false) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: O jogador selecionado não está logado.");

	new string[400];
	Player[id][pAdmin] = level;
	format(string, sizeof(string),"[INFO]: O %s %s setou seu level de Administrador para %d - %s.", AccountName(playerid), Nome(playerid), level,  AccountName(playerid));
	SendClientMessage(id, COR_PRINCIPAL, string);
 	format(string, sizeof(string),"[INFO]: Você mudou o level de Administrador da conta de %s (id: %d) para %d - %s.", Nome(id), id, level, AccountName(id));
	SendClientMessage(playerid, COR_PRINCIPAL, string);
	format(string, sizeof(string),"-AdmCMD- %s foi promovido a nível %d de Administrador pelo %s", Nome(id), level, Nome(playerid));
	SendMessageToAdminsEx(string);
	SalvarPlayer(id);
	if(level==0)
	{
		format(string,sizeof(string),"[INFO]: O %s %s te desetou de administrador.",AccountName(playerid),Nome(playerid));
		SendClientMessage(id,COR_PRINCIPAL,string);
		format(string,sizeof(string),"[INFO]: Você retirou o administrador do player %s.",Nome(id));
		SendClientMessage(playerid,COR_PRINCIPAL,string);
		Player[id][pAdmin]=level;
		format(string, sizeof(string),"AdmCMD O %s %s desetou %s de Administrador.", AccountName(playerid),Nome(playerid), Nome(id));
		SendMessageToAdminsEx(string);
		SalvarPlayer(id);
	}
	return 1;
}

CMD:admins(playerid)
{
	SendClientMessage(playerid, 0xADFF2FFF, "** Todos os administradores online");
	new AdmLevel[64], count=0, string[129];
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(Logado[playerid] == true)
			{
			    if(Player[i][pAdmin] >= 1)
			    {
					if(Player[i][pAdmin] == 5) { AdmLevel = "Game Master"; }
					if(Player[i][pAdmin] == 4) { AdmLevel = "Sub Game Master"; }
					if(Player[i][pAdmin] == 3) { AdmLevel = "Administrador Fixo"; }
					if(Player[i][pAdmin] == 2) { AdmLevel = "Administrador Ajudante"; }
					if(Player[i][pAdmin] == 1) { AdmLevel = "Administrador Temporário"; }

					if(Player[i][pAdmin] == 4 || Player[i][pAdmin] == 5)
					{
	    				format(string, sizeof(string),"Admin: %s [%s] [Função: %s]", Nome(i), AdmLevel);
						SendClientMessage(playerid, COR_BRANCO, string);
						count++;
					}

					else { format(string, sizeof(string), "Admin: %s [%s] [Reports Lidos: %d]", Nome(i), AdmLevel, Player[i][pRpt]); SendClientMessage(playerid, COR_BRANCO, string);}
					count++;
				}
			}
		}
	}
	if(count == 0) return SendClientMessage(playerid, COR_BRANCO, "** Não tem nem um administrador online no momento.");
	return 1;
}

CMD:funcaodegm(playerid, params[])
{
	new string[126], Query[200];
    if(Player[playerid][pAdmin] < 4) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");

    if(sscanf(params, "s", params))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /funcaodegm [texto]");

	format(string, sizeof(string),"[GM] Função escolhida: '%s'", params);
	SendClientMessage(playerid, COR_PRINCIPAL, string);
	mysql_format(conectDB, Query, sizeof(Query), "UPDATE `pinfo` SET `funcao` = '%s' WHERE `Nick` = '%s' ", params, Nome(playerid));
    mysql_tquery(conectDB, Query,"DadosSalvos","d", playerid);
	return 1;
}

CMD:setpres(playerid,params[])
{
	new id, level;
	if(Player[playerid][pAdmin] < 5) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(sscanf(params, "ud", id, level)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /setpres [id] [level]");
	if(level > 1) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Level de Presidente inválido!");
 	if(Logado[playerid] == false) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: O jogador selecionado não está logado.");

	new string[120];
	Player[id][pPres] = level;
	format(string, sizeof(string),"[INFO]: O %s %s setou você de Presidente da %s.", AccountName(playerid), Nome(playerid), Torcidas[Player[id][pTorcida]][tNome]);
	SendClientMessage(id, COR_PRINCIPAL, string);
 	format(string, sizeof(string),"[INFO]: Você setou %s (id: %d) de Presidente %s.", Nome(id), id, Torcidas[Player[id][pTorcida]][tNome]);
	SendClientMessage(playerid, COR_PRINCIPAL, string);
	format(string, sizeof(string),"-AdmCMD- %s foi promovido a  Presidente da %s pelo Administrador pelo %s", Nome(id), Torcidas[Player[id][pTorcida]][tNome], Nome(playerid));
	SendMessageToAdminsEx(string);
	SalvarPlayer(id);
	if(level==0)
	{
		format(string,sizeof(string),"[INFO]: O %s %s te desetou de Presidente da %s.", AccountName(playerid) ,Nome(playerid), Torcidas[Player[id][pTorcida]][tNome]);
		SendClientMessage(id, COR_PRINCIPAL,string);
		format(string,sizeof(string),"[INFO]: Você retirou o Presidente de %s da %s.",Nome(id), Torcidas[Player[id][pTorcida]][tNome]);
		SendClientMessage(playerid,COR_PRINCIPAL,string);
		Player[id][pPres] = level;
		format(string, sizeof(string),"AdmCMD O %s %s desetou %s de Presidente da %s.", AccountName(playerid),Nome(playerid), Nome(id), Torcidas[Player[id][pTorcida]][tNome]);
		SendMessageToAdminsEx(string);
		SalvarPlayer(id);
	}
	return 1;
}

CMD:darcash(playerid, params[])
{
    new id, cash, string[126];
    if(!IsPlayerAdmin(playerid))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado na RCON");
	if(sscanf(params, "ud", id, cash))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /darcash [id] [cash]");
	if(cash < 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Digite um numero de cash validos!");
    if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	Player[id][Cash]+=cash;
	format(string, sizeof(string),"[INFO]: Você deu %d de cash para %s.",cash,Nome(id));
	SendClientMessage(playerid, COR_PRINCIPAL, string);
    format(string, sizeof(string),"[INFO]: %s deu %d de cash para você.",Nome(playerid),cash);
	SendClientMessage(id,COR_PRINCIPAL, string);
	SalvarPlayer(id);
	return true;
}
CMD:darcasht(playerid, params[])
{
	new cash, string[200];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não está logado na RCON");
	if(sscanf(params, "d", cash)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /darcasht [cash]");
	for(new i = 0 ; i < MAX_PLAYERS; i++)
	{
	    Player[i][Cash]+= cash;
	    SalvarPlayer(i);
	}
	format(string,sizeof(string),"O Administrador %s deu %d de cash para todos do servidor.", Nome(playerid),cash);
 	SendClientMessageToAll(COR_PRINCIPAL, string);
	printf("AdmCMD: O Administrador %s deu %d de cash para todos do servidor.", Nome(playerid), cash);
	return 1;
}

CMD:irla(playerid)
{
	SetPlayerPos(playerid, 1102.21912, -343.25229, 75.73130);
	return 1;
}

CMD:trazertodossv(playerid)
{
    GetPlayerPos(playerid, X, Y, Z);
    for(new i = 0; i < MAX_PLAYERS; ++i)
    {
       if(IsPlayerConnected(i))
       {
          SetPlayerPos(i, X+1, Y+1, Z);
       }
    }
    return 1;
}

CMD:olhar(playerid, params[])  // exemplo de comando com 1 parâmetro
{
	if(Player[playerid][pAdmin] < 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão.");
	else
	{
		new specid;
		if(sscanf(params, "u", specid)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /olhar [id/off]");
		if(strcmp(params, "off", true)==0)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING )
			{
				StopSpectate(playerid);
				return 1;
			}
			else
			{
				return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está olhando ninguém.");
			}
		}
		if(!IsNumeric(params)) specid = ReturnPlayerID(params);
		else
		specid = strval(params);

		if(!IsPlayerConnected(specid))
		{
			SendClientMessage(playerid, COR_ERRO, "[ERRO]: Jogador não encontrado.");
			return 1;
		}
		else if(specid == playerid)
		{
			SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não pode dar olhar em si mesmo.");
			return 1;
		}
		else if(GetPlayerState(specid) == PLAYER_STATE_SPECTATING && Player[specid][gSpectateID] != INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COR_ERRO, "[ERRO]: Jogador escolhido já está espectando alguém.");
			return 1;
		}
		else if(GetPlayerState(specid) != 1 && GetPlayerState(specid) != 2 && GetPlayerState(specid) != 3)
		{
			SendClientMessage(playerid, COR_ERRO, "[ERRO]: O jogador não está jogando.");
			return 1;
		}
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
			SaveVariables(playerid);
			SendClientMessage(playerid, COR_NEGATIVO, "-GTBInfo-: Você entrou no modo espectador, para sair digite /olhar off.");
		}
		StartSpectate(playerid, specid);
	}
	return 1;
}

CMD:rtc(playerid)
{
	if(Player[playerid][pAdmin] < 5) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	ResetarCarros(playerid);
	return 1;
}

CMD:dtc(playerid)
{
	new string[90];
	if(!(Player[playerid][pAdmin] >= 4)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	new AdmLevel[50];
	if(Player[playerid][pAdmin] == 5) { AdmLevel = "Game Master"; }
	if(Player[playerid][pAdmin] == 4) { AdmLevel = "Sub Game Master"; }
	if(Player[playerid][pAdmin] == 3) { AdmLevel = "Administrador Fixo"; }
	if(Player[playerid][pAdmin] == 2) { AdmLevel = "Administrador Ajudante"; }
	if(Player[playerid][pAdmin] == 1) { AdmLevel = "Administrador Temporário"; }
    for(new x = 0; x < sizeof(VeiculoVeh); x++)
    {
    	if(!(IsPlayerInVehicle(x,VeiculoVeh[x])))
    	{
        	DestroyVehicle(VeiculoVeh[x]);
        	VeiculoVeh[x] = 0;
        }
    }
    format(string, sizeof(string), "-GFInfo-: O %s %s destruiu todos os veículos criados.", AccountName(playerid), Nome(playerid));
    SendClientMessageToAll(COR_NEGATIVO, string);
	return 1;
}

CMD:prender(playerid, params[])
{
	new id, motivo[128], tempo;
	if(!(Player[playerid][pAdmin] >= 1)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
 	if(sscanf(params, "uds", id, tempo, motivo)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /prender [id] [tempo] [motivo] ");
 	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	if(tempo >= 61) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: O maximo de tempo preso é 60 minutos");
 	if(PresoADM[id] == 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este player ja está na cadeia.");
 	if(tempo == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Para soltar alguém use /soltar [id].");
	new AdmLevel[50];
	if(Player[playerid][pAdmin] == 5) { AdmLevel = "Game Master"; }
	if(Player[playerid][pAdmin] == 4) { AdmLevel = "Sub Game Master"; }
	if(Player[playerid][pAdmin] == 3) { AdmLevel = "Administrador Fixo"; }
	if(Player[playerid][pAdmin] == 2) { AdmLevel = "Administrador Ajudante"; }
	if(Player[playerid][pAdmin] == 1) { AdmLevel = "Administrador Temporário"; }
 	Player[id][TempoPreso] = 60*tempo;
	SetPlayerPos(id, 197.3364,174.0059,1003.0234);
	SetPlayerInterior(id, 3);
    ResetPlayerWeapons(id);
    PresoADM[id] = 1;
    reduzirTempo(id);
    Player[playerid][EmTrabalho] = false;
    new string2[200];
	format(string2, sizeof(string2), "-GTBInfo-: %s foi preso pelo %s %s por %d minutos. | Motivo: %s", Nome(id), AdmLevel, Nome(playerid), tempo, motivo);
	SendClientMessageToAll(COR_NEGATIVO, string2);
	new string[200], string1[200];
	format(string, 128, "{FF0000}VOCÊ FOI PRESO, MOTIVO: {FF0000}%s\n\n",motivo);
	strcat(string1,string);
	format(string, sizeof(string), "{FFFFFF}Nick de quem te prendeu: {FF0000}%s\n", Nome(playerid));
	strcat(string1,string);
	format(string, sizeof(string), "{FFFFFF}Tempo Preso: {FF0000}%d minuto(s)\n", tempo);
	strcat(string1,string);
	ShowPlayerDialog(id, 7561, DIALOG_STYLE_MSGBOX, "{FF0000}» {FFFFFF}VOCÊ FOI PRESO {FF0000}«", string1, "Fechar", "");
	return 1;
}

CMD:soltar(playerid, params[])
{
	new id, motivo[128];
    if(!(Player[playerid][pAdmin] >= 1)) return SendClientMessage(playerid, COR_BRANCO, "[ERRO]: Você não tem permissão para usar este comando.");
    if(sscanf(params, "us", id, motivo)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /soltar [id] [motivo]");
    if(Logado[id] == false) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Este jogador não está logado.");
    if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
    if(PresoADM[id] == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO] Este jogador não está preso.");
 
	new AdmLevel[50];
	if(Player[playerid][pAdmin] == 5) { AdmLevel = "Game Master"; }
	if(Player[playerid][pAdmin] == 4) { AdmLevel = "Sub Game Master"; }
	if(Player[playerid][pAdmin] == 3) { AdmLevel = "Administrador Fixo"; }
	if(Player[playerid][pAdmin] == 2) { AdmLevel = "Administrador Ajudante"; }
	if(Player[playerid][pAdmin] == 1) { AdmLevel = "Administrador Temporário"; }
	Player[id][TempoPreso] = 0;
	PresoADM[id] = 1;
    new string2[200];
    format(string2, sizeof(string2), "-GTBInfo-: O %s foi solto pelo %s %s. | Motivo: %s", Nome(id), AdmLevel,Nome(playerid), motivo);
	SendClientMessageToAll(COR_NEGATIVO, string2);
	return 1;
}

CMD:respawn(playerid, params[])
{
	new string[500], id, motivo[500];
    if(!(Player[playerid][pAdmin] >= 1)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão!");
	if(sscanf(params, "us", id, motivo)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /respawn [id] [motivo]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este id está offline.");
	SpawnPlayer(id);
	Player[id][EmTrabalho] = false;
	format(string, sizeof(string),"AdmCMD: %s foi respawnado pelo %s %s | Motivo: %s",Nome(id), AccountName(playerid), Nome(playerid), motivo);
	SendClientMessageToAll(COR_NEGATIVO, string);
	new string1[300], string2[300];
	format(string1, 128, "{FF0000}VOCÊ FOI RESPAWNADO\n\n");
	strcat(string2,string1);
	format(string1, sizeof(string1), "{FFFFFF}Nick de quem te respawnou: {FF0000}%s\n", Nome(playerid));
	strcat(string2,string1);
	format(string1, sizeof(string1), "{FFFFFF}Motivo: {FF0000}%s\n",motivo);
	strcat(string2,string1);
	ShowPlayerDialog(id, 666, DIALOG_STYLE_MSGBOX, "{FF0000}» {FFFFFF}VOCÊ FOI RESPAWNADO {FF0000}«", string2, "Fechar", "");
	return 1;
}

CMD:tempban(playerid, params[])
{
    new id, dias, reason[60], string[150];
    if(Player[playerid][pAdmin] < 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar esse comando!");
	if(sscanf(params, "uds[60]", id, dias, reason)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /tempban [id ou nick] [dias] [motivo]");
	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Player não conectado.");
	format(string, sizeof(string), "AdmCMD: O %s %s baniu %s por %d dias. | Motivo: %s", AccountName(playerid), Nome(playerid), Nome(id), dias, reason);
	SendClientMessageToAll(COR_NEGATIVO, string);
	BanExtend(playerid, id, reason, dias);
	SetTimerEx("TimerKick", 200, 0, "i", id);
    return true;
}

CMD:desban(playerid, params[])
{
    if(Player[playerid][pAdmin] < 4) return SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não tem permissão para usar esse comando!");
    if(!strlen(params)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /desban [nick ou ip]");

	new Query[128], string[126];
    format(Query, sizeof(Query),"SELECT * FROM `banlist` WHERE (`Name`='%s' OR `IP`='%s') LIMIT 1", params, params);
    new Cache:result;
    mysql_query(conectDB, Query, true);

    if(cache_get_row_count(conectDB) > 0)
    {
        format(Query, sizeof(Query),"DELETE FROM `banlist` WHERE(`Name`='%s' OR `IP`='%s')", params, params);
        mysql_tquery(conectDB, Query);
	    new Str1[999];
	    format(Str1, sizeof(Str1),"{FFBD9D}-OpenServ- O %s %s desbaniu %s.", AccountName(playerid), Nome(playerid), params);
	    SendMessageToAdminsEx(Str1);
    }
    else
    format(string, sizeof(string),"[ERRO]: Não foi possivel encontrar \"%s\" no banco de dados.", params);
	SendClientMessage(playerid, COR_ERRO,string);
    cache_delete(result);
	return true;
}

CMD:desarmar(playerid, params[])
{
	new id, string[70];
	if(sscanf(params,"u",id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /desarmar [id]");
	if(!(Player[playerid][pAdmin] >= 2))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	if(Logado[id]==false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Esse jogador não está logado!");
	ResetPlayerWeapons(id);
	format(string, sizeof(string), "[INFO]: Você desarmou %s.", Nome(id));
	SendClientMessage(playerid, COR_PRINCIPAL, string);
	format(string, sizeof(string), "[INFO]: O Administrador %s te desarmou.", Nome(playerid));
	SendClientMessage(id, COR_PRINCIPAL, string);
	return 1;
}

CMD:dt(playerid)
{
	new string[80];
	if(!(Player[playerid][pAdmin] >= 4))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Logado{playerid} == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado para utilizar este comando!");
	for(new i = 0; i <= HighestID; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 50)
	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	{
		ResetPlayerWeapons(i);
		format(string, sizeof(string),"[ ! ] - {ffffff}%s {C798FA}desarmou todos ao seu redor.", Nome(playerid));
		SendClientMessage(i, COR_ROXO, string);
 	}
	return 1;
}

CMD:supertapa(playerid, params[])
{
	new id;
	if(Player[playerid][pAdmin] < 2)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(sscanf(params,"u",id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /supertapa [id]");
	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	if(Logado[id]==false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Esse jogador não está logado!");
	new Float: px, Float: py, Float: pz,string[120];
    GetPlayerPos(id, px, py, pz);
	SetPlayerPos(id, px, py, pz+90);
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}levou um super tapa de {ffffff}%s{C798FA}.", Nome(id), Nome(playerid));
	MensagemPerto(id, COR_ROXO, string, 60);
	return 1;
}

CMD:cnn(playerid, params[])
{
	if(!(Player[playerid][pAdmin] >= 1 || Player[playerid][pPres] >= 1 || Player[playerid][pOrg] >= 1 || Player[playerid][pPux] >= 1 || Player[playerid][pBope] >= 4 || Player[playerid][pChoque] >= 4))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	if(sscanf(params, "s", params)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /cnn [mensagem]");
	new string[70];
	format(string, sizeof(string), "~b~%s: ~w~%s", Nome(playerid), params);
	for(new i = 0; i <= HighestID; i++)
	{
		if(GetDistanceBetweenPlayers(playerid, i) <= 50)
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
			{
				if(IsPlayerConnected(i))
				{
					GameTextForPlayer(i, string, 5000, 5);
				}
			}
		}
	}
	return 1;
}

CMD:pinfo(playerid, params[])
{
	new id, text[40], string[400];
	if(Player[playerid][pAdmin] < 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para este comando");
	if(sscanf(params,"u",id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /pinfo [id]");
	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");

	new ammo = GetPlayerAmmo(id);
	new Float:health;
	new ip[24];
	new Float:armour;
	new ping = GetPlayerPing(id);
	new money = GetPlayerMoney(id);
	new level = GetPlayerScore(id);

    GetPlayerHealth(id,health);
	GetPlayerArmour(id,armour);
	GetPlayerIp(id, ip, sizeof ip);

	if(Player[id][Vip] >= 1) text = "Sim";
	else text = "Não";
	format(string, sizeof(string), "|{0000FF}__________ {FFFFFF}Informações de %s {0000FF}__________{FFFFFF}|", Nome(id));
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}IP: {FFFFFF}%s", ip);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Level: {FFFFFF}%d", level);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Vida: {FFFFFF}%.1f", health);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Colete: {FFFFFF}%.1f", armour);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Munição da arma na mão: {FFFFFF}%d", ammo);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Ping: {FFFFFF}%d", ping);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Dinheiro: {FFFFFF}%d", money);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Cash: {FFFFFF}%d", Player[id][Cash]);
	SendClientMessage(playerid, COR_BRANCO, string);
	format(string, sizeof(string),"{0000FF}Vip: {FFFFFF}%s", text);
	SendClientMessage(playerid, COR_BRANCO, string);
	return 1;
}

CMD:clima(playerid, params[])
{
	new id, string[150];
	if(Player[playerid][pAdmin] < 5) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para esse comando");
	if(sscanf(params,"d",id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /clima [id]");
    SetWeather(id);
    format(string, sizeof(string),  "AdmCMD: O Administrador %s mudou o clima para o id %d.", Nome(playerid), id);
	SendClientMessageToAll(COR_BRANCO, string);
	return 1;
}

CMD:tempo(playerid)
{
	if(Player[playerid][pAdmin] < 5)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	ShowPlayerDialog(playerid, DIALOG_TEMPO, DIALOG_STYLE_LIST, "Escolha o horario:", "1Hora\n2Horas \n3Horas \n4Horas \n5Horas \n6Horas \n7Horas \n8Horas \n9Horas \n10Horas \n11Horas \n12Horas \n13Horas \n14Horas \n15Horas \n16Horas \n17Horas \n18Horas \n19Horas \n20Horas \n21Horas \n22Horas \n23Horas \n24Horas\nTempo Automático", "OK", "Cancelar");
	return 1;
}

CMD:a(playerid,params[])
{
	new string[999];
	if(sscanf(params, "s", string))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /a [texto]");
	if(Player[playerid][pAdmin]<1)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não é um administrador para acessar este comando.");
	format(string, sizeof(string),"{FF00FF}[CHAT ADMINISTRADOR]: %s (%d): %s ", Nome(playerid), playerid, string);
    SendMessageToAdminsEx(string);
	return 1;
}

CMD:at(playerid)
{
	new string[150];
	if(Player[playerid][pAdmin] >= 1)
	{
		SendClientMessageToAll(-1, "|________________Administração Avisa________________|");
		format(string, sizeof(string),"Administrador %s: Viu Algo de Ilegal no Servidor? Use /reportar [id] [motivo]", Nome(playerid));
		SendClientMessageToAll(COR_USOCORRETO, string);
	}
	else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	return 1;
}

CMD:coletetvidat(playerid)
{
	if(!(Player[playerid][pAdmin] >= 1 || Player[playerid][pHelper] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	for(new i = 0; i <= HighestID; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 50)
	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	{
	    new string[110];
		SetPlayerArmour(i, 100);
		SetPlayerHealth(i, 100);
		format(string, sizeof(string),"[ ! ] - {ffffff}%s {C798FA}deu colete e vida para todos perto dele.", Nome(playerid));
		SendClientMessage(i, COR_ROXO, string);
	}
	return 1;
}

CMD:vidat(playerid)
{
	if(!(Player[playerid][pAdmin] >= 1 || Player[playerid][pHelper] >= 1 ))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	for(new i = 0; i <= HighestID; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 50)
	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	{
	    new string[100];
		SetPlayerHealth(i, 100);
		format(string, sizeof(string),"[ ! ] - {ffffff}%s {C798FA}deu vida para todos perto dele.", Nome(playerid));
		SendClientMessage(i, COR_ROXO, string);
	}
	return 1;
}

CMD:coletet(playerid)
{
	if(!(Player[playerid][pAdmin] >= 1 || Player[playerid][pHelper] >= 1 ))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	for(new i = 0; i <= HighestID; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 50)
	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	{
	    new string[85];
		SetPlayerArmour(i, 100);
		format(string, sizeof(string),"[ ! ] - {ffffff}%s {C798FA}deu colete para todos perto dele.", Nome(playerid));
		SendClientMessage(i, COR_ROXO, string);
	}
	return 1;
}

CMD:anunciar(playerid, params[]) {
	if(Player[playerid][pPres] <= 0 && Player[playerid][pOrg] <= 0 && Player[playerid][pPux] <= 0 && Player[playerid][pvPres] <= 0) return SendClientMessage(playerid, COR_VERMELHO,"VocÃª nÃ£o tem permissÃ£o");
	ShowPlayerDialog(playerid, ANUNCIAR, DIALOG_STYLE_LIST, "ANUNCIAR", "X3\nCF\nTreta", "Escolher", "Sair");
	return 1;
}

CMD:colete(playerid, params[]) {
	new id, string1[140];
	if(Player[playerid][pAdmin] <= 0) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não tem permissão.");
	if(sscanf(params,"uf",id,colete)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /vida [id] [quantidade]");
	if(colete < 0 || colete  > 100) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Quantidade invalida 0 - 100");
	SetPlayerArmour(id,colete);
	format(string1, sizeof(string1), "[ ! ] - O Administrador {FFFFFF}%s {C798FA}setou o colete de {FFFFFF}%s{C798FA}.", Nome(playerid), Nome(id));
	MensagemPerto(playerid, COR_ROXO, string1, 50);
	return 1;
}

CMD:mochila(playerid)
{
    MostrarMochila(playerid, playerid, 1, 1);
	return 1;
}

CMD:criar(playerid)
{
	if(Player[playerid][pAdmin] < 2)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem permissão.");
	if(EnqueteAberta == true) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: No momento já existe uma enquete aberta");
	ShowPlayerDialog(playerid,DIALOG_ENQUETE,DIALOG_STYLE_INPUT,"Criar Enquete","Por favor digite sua pergunta para enquete","Criar","Cancelar");
	return 1;
}

CMD:nao(playerid)
{
	if(PlayerVotou[playerid] == 1) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você já votou!");
	if(EnqueteAberta == false) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Nenhuma enquete está aberta!");
	if(Logado[playerid] == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado para utilizar este comando!");
	TotalDeVotosNao++;
	PlayerVotou[playerid] = 1;
	SendClientMessage(playerid,COR_PRINCIPAL,"[ENQUETE]: Obrigado por participar da enquete! Sua resposta: Não");
	return 1;
}

CMD:sim(playerid)
{
	if(PlayerVotou[playerid] == 1) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você já votou!");
	if(EnqueteAberta == false) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Nenhuma enquete está aberta!");
 	if(Logado[playerid] == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado para utilizar este comando!");
	TotalDeVotosSim++;
	SendClientMessage(playerid,COR_PRINCIPAL,"[ENQUETE]: Obrigado por participar da enquete! Sua resposta: Sim");
	PlayerVotou[playerid] = 1;
	return 1;
}

CMD:fechar(playerid)
{
	new string[50];
	if(Player[playerid][pAdmin] < 2)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem permissão.");
	if(EnqueteAberta == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: No momento já existe uma enquete aberta");
	SendClientMessageToAll(-1, " ");
	SendClientMessageToAll(COR_PRINCIPAL, "-------------------------------------------------------------------------------");
	format(SringEnquete, 128, "O Administrador %s acaba de fechar uma enquete.", Nome(playerid));
	SendClientMessageToAll(COR_LARANJA, SringEnquete);
	format(SringEnquete, 128, "A pergunta foi: %s", NomeEnquete);
	SendClientMessageToAll(COR_BRANCO, SringEnquete);
	if(TotalDeVotosSim > TotalDeVotosNao){ format(string, sizeof(string), "A Maioria Concorda");}
	if(TotalDeVotosNao > TotalDeVotosSim) {format(string, sizeof(string), "A Maioria Discorda");}
	format(SringEnquete, 128, "Resultado: Sim [%d] | Não [%d] | Votos [%d] | %s.", TotalDeVotosSim, TotalDeVotosNao, (TotalDeVotosSim + TotalDeVotosNao), string);
    SendClientMessageToAll(COR_PRINCIPAL, SringEnquete);
	SendClientMessageToAll(COR_PRINCIPAL, "-------------------------------------------------------------------------------");
	TotalDeVotosSim = 0;
	TotalDeVotosNao = 0;
	EnqueteAberta = false;
	for(new i; i <= HighestID; i++)
		if(PlayerVotou[i] == 1)
	{
		PlayerVotou[i] = 0;
	}
	return 1;
}

CMD:radio(playerid)
{
	if(Logado[playerid] == false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado para utilizar este comando!");
	ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "Radio GTB Torcidas","Ligar Radio\nDesligar","Selecionar","Cancelar");
	return 1;
}

CMD:creditos(playerid)
{
	if(Logado[playerid] == false)return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não está logado para utilizar este comando!");
	ShowPlayerDialog(playerid, DIALOG_CREDITOS, DIALOG_STYLE_LIST, "{FFFFFF}Créditos - {FF0000}GTB Torcidas", "{FFFFFF}Fundadores - Lelego\nCriadores do GM - Marola\nMapa - Marola\n", "Fechar", "");
	return 1;
}


CMD:cash(playerid,params[])
{
	new Str[200];
	if(Logado[playerid] == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está logado para utilizar este comando!");
	format(Str, sizeof(Str), "{FFFF00}¤ {FFFFFF}Meus Cash: [%d]\n{FFFF00}¤ {FFFFFF}Loja de Cash\n{FFFF00}¤ {FFFFFF}Transferir Cash\n{FFFF00}¤ {FFFFFF}Ativar VIP\n",Player[playerid][Cash]);
	ShowPlayerDialog(playerid, DIALOG_CASHS, DIALOG_STYLE_LIST, "{FFFFFF}Informações Cash", Str, "Selecionar", "Cancelar");
	return 1;
}

CMD:tr(playerid, params[])
return cmd_trazer(playerid, params);

CMD:trazer(playerid, params[])
{
	new id,Float:plocx,Float:plocy,Float:plocz;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /trazer [id]");
	if(!IsPlayerConnected(id))return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	if(Logado[id] == false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Esse jogador não está logado.");
	if(GetPlayerState(id) == PLAYER_STATE_SPECTATING && Player[id][gSpectateID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Jogador escolhido está de /olhar em alguém.");
	if(GetPlayerInterior(playerid) > 0)
	if(IsPlayerInAnyVehicle(id))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: O player que você quer puxar está em um veículo, não se pode trazer veículos à interiores.");
	if(Player[playerid][pAdmin] >= 1 )
	{
		if(Player[id][BlockTR] == false)
		{
			new str[150];
			format(str, sizeof(str), "[ ! ] - {FFFFFF}%s {C798FA}foi puxado por {FFFFFF}%s{C798FA}.", Nome(id), Nome(playerid));
			MensagemPerto(playerid, COR_ROXO, str, 50);

			format(str, sizeof(str), "[ ! ] - {FFFFFF}%s {C798FA}puxou {FFFFFF}%s{C798FA}.", Nome(playerid), Nome(id));
			MensagemPerto(id, COR_ROXO, str, 50);

			GetPlayerPos(playerid, plocx, plocy, plocz);

			new intid = GetPlayerInterior(playerid);
			SetPlayerInterior(id,intid);

			new world = GetPlayerVirtualWorld(playerid);
			SetPlayerVirtualWorld(id, world);

			if(GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
			}
			else
			{
				SetPlayerPos(id,plocx,plocy+2, plocz);
			}
		}
		else SendClientMessage(playerid,COR_ERRO,"[ERRO]: Este player está com o trazer bloqueado.");
	}
	else
	{
	    SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	}
	return 1;
}

CMD:pular(playerid)
{
	if(Player[playerid][TempoPreso] >= 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está preso.");
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);
	SetPlayerPos(playerid, px, py, pz+0.7);
	return 1;
}

CMD:veh(playerid, params[])
{
	if(VeiculoVeh[playerid] >=1 )return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você já tem um veículo criado, digite '/dcm' para pode criar outro veículo.");
	if(Player[playerid][TempoPreso] == 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está preso.");
 	if(Player[playerid][Vip] >= 1)
 	{
		if(VeiculoVeh[playerid] >= 1) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você já tem veiculo criado digite /dcm para deletar seu veiculo.");
		new string[65];
		ShowPlayerDialog(playerid, DIALOG_VEHVIP, DIALOG_STYLE_LIST, "Veiculos Vip", "Sultan\nInfernus\nOnibus\nBmx\nMountain Bike\nFaggio\nSanchez\nQuad\nNRG-500\nIate\nBugre\nBanshee\nSquallo\nJester\nBuffalo", "Selecionar", "Cancelar");
		format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}digitou /veh.", Nome(playerid));
		MensagemPerto(playerid, COR_ROXO, string, 60);
	}
	else if(Player[playerid][pAdmin] >= 1)
	{
		new string[65];
		ShowPlayerDialog(playerid, DIALOG_VEH, DIALOG_STYLE_LIST, "Veiculos", "Sultan\nInfernus\nOnibus\nBmx\nMountain Bike\nFaggio\nSanchez\nQuad\nNRG-500", "Selecionar", "Cancelar");
		format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}digitou /veh.", Nome(playerid));
		MensagemPerto(playerid, COR_ROXO, string, 60);
	}
	else SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem permissão para usar este comando.");
	return 1;
}

CMD:tapa(playerid, params[])
{
	if(!(Player[playerid][pAdmin] >=1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	new Float:health, id, Float:pos[3], string[110];
	if(sscanf(params,"u",id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /tapa [id]");
	if(!IsPlayerConnected(id))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: ID inválido!");
	if(Player[playerid][TempoPreso] >= 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está preso.");
 	if(Player[id][TempoPreso] >= 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este player está preso.");

	GetPlayerHealth(id, health);
	SetPlayerHealth(id, health-5);
	GetPlayerPos(id, pos[0], pos[1], pos[2]);
	SetPlayerPos(id, pos[0], pos[1], pos[2]+5);
	format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}levou um tapa de {FFFFFF}%s{C798FA}.", Nome(id), Nome(playerid));
	MensagemPerto(id, COR_ROXO, string, 60);
	return 1;
}

CMD:armas(playerid)
{
	if(Player[playerid][pAdmin] < 3)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	ShowPlayerDialog(playerid, DIALOG_ARMAS, DIALOG_STYLE_LIST, "Armas", "Cacetete\nFaca\nSoco Ingles\nTaco de beisebol\nPá\nKatana\nSerra elétrica\nVibrador Roxo\nVibrador Pequeno\nVibrador Largo\nFlores\nBomba de gás\nDeagle\nShotgun\nSawn-off Shotgun\nAK-K7\nMP5\nM4-A1\nSniper\nSpray\nExtintor\nCâmera\nParaquedas", "Pegar", "Cancelar");
	return 1;
}

CMD:config(playerid)
{
	new string[140], s[100], string2[100], s2[100], string3[100], s3[100],string4[100], s4[100];
	// Trazer
	if(Player[playerid][BlockTR] == false)
	{
		format(s, sizeof(s), "{00FF00}(Desbloqueado)");
		strcat(string, s, sizeof(string));
	}
	if(Player[playerid][BlockTR] == true)
	{
		format(s, sizeof(s), "{FF0000}(Bloqueado)");
		strcat(string, s, sizeof(string));
	}
	// IR
	if(Player[playerid][BlockIR] == false)
	{
		format(s2, sizeof(s2), "{00FF00}(Desbloqueado)");
		strcat(string2, s2, sizeof(string2));
	}
	if(Player[playerid][BlockIR] == true)
	{
		format(s2, sizeof(s2), "{FF0000}(Bloqueado)");
		strcat(string2, s2, sizeof(string2));
	}
	// PM
	if(Player[playerid][BlockPM] == false)
	{
		format(s3, sizeof(s3), "{00FF00}(Desbloqueada)");
		strcat(string3, s3, sizeof(string3));
	}
	if(Player[playerid][BlockPM] == true)
	{
		format(s3, sizeof(s3), "{FF0000}(Bloqueada)");
		strcat(string3, s3, sizeof(string3));
	}
	// CHAT TORCIDA
	if(Player[playerid][ChatTorcida] == false)
	{
		format(s4, sizeof(s4), "{00FF00}(Desbloqueada)");
		strcat(string4, s4, sizeof(string4));
	}
	if(Player[playerid][ChatTorcida] == true)
	{
		format(s4, sizeof(s4), "{FF0000}(Bloqueado)");
		strcat(string4, s4, sizeof(string4));
	}
	if(Player[playerid][Vip] >= 1 || Player[playerid][pOrg] == 1 || Player[playerid][pPux] == 1|| Player[playerid][pPres] == 1 || Player[playerid][pvPres] == 1)
	{
		format(string, sizeof(string), "Trazer %s\nIr %s\nMensagem Privada %s\nChat Torcida %s", string, string2, string3, string4);
		ShowPlayerDialog(playerid, DIALOG_CONFIG, DIALOG_STYLE_LIST, "Configurações", string, "Selecionar", "Fechar");
	}
	else {SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão.");}
	return 1;
}

CMD:skin(playerid,params[])
{
	new skin, string[45];
	if(sscanf(params,"d",skin)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /skin [id]");
	if(skin > 311) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: máximo de número de skins é 311.");
	SetPlayerSkin(playerid,skin);
	format(string, sizeof(string),"[INFO]: Você mudou sua skin (Skin %d).", skin);
	SendClientMessage(playerid, COR_PRINCIPAL, string);
	return 1;
}

CMD:dcm(playerid)
{
	if(VeiculoVeh[playerid] < 1) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem veiculo criado digite /veh para criar um.");
	if(Player[playerid][pAdmin] >= 1)
	{
	    DestroyVehicle(VeiculoVeh[playerid]);
	    VeiculoVeh[playerid] = 0;
	   	new string[70];
		format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}destruiu um veiculo.", Nome(playerid));
		MensagemPerto(playerid, COR_ROXO, string, 50);
	}
	else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	return 1;
}

CMD:dc(playerid)
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == 2)
	{
		if(Player[playerid][pAdmin] >= 1)
		{
	   		new vehicleid, Str[70];
			vehicleid = GetPlayerVehicleID(playerid);
   			if(Player[playerid][pAdmin] >= 1)
			{
			    if(Carros(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não pode deletar esse veículo, use /rc!");
				DestroyVehicle(vehicleid);
				VeiculoVeh[playerid] = 0;
				format(Str, sizeof(Str), "[ ! ] - {FFFFFF}%s {C798FA}deletou um veículo!", Nome(playerid));
				MensagemPerto(playerid, COR_ROXO, Str, 50);
				return 1;
			}
   		}
   		else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	}
	else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está em um veículo ou não está dirigindo ele.");
	return 1;
}

CMD:cityadmin(playerid)
{
	if(Player[playerid][pAdmin] < 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não é tem permissão para usar este comando!");
	Player[playerid][CityAdmin] = true;
	SetPlayerPos(playerid, -838.1016,502.8534,1358.2864);
	SetPlayerFacingAngle(playerid, 267.3420);
	SetPlayerInterior(playerid, 1);
	SetPlayerVirtualWorld(playerid, 0);
	new string[90];
	format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}foi para a cidade dos administradores.", Nome(playerid));
	MensagemPerto(playerid, COR_ROXO, string, 20);
	SendClientMessage(playerid, COR_PRINCIPAL, "[INFO] Para sair da cidade digite '/saircity'");
	return 1;
}

CMD:saircity(playerid)
{
	if(Player[playerid][pAdmin] < 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não é tem permissão para usar este comando!");
	SpawnPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	Player[playerid][CityAdmin] = false;
	new string[85];
	format(string, sizeof(string), "[ ! ] - {FFFFFF}%s {C798FA}saiu da cidade dos administradores.", Nome(playerid));
	MensagemPerto(playerid, COR_ROXO, string, 20);
	return 1;
}

CMD:asay(playerid, params[])
{
	new string[999];
	if(Player[playerid][DelayAsay] == true)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você usou o Asay recentemente, aguarde.");
	if(Logado[playerid] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está Logado para usar este comando!");
	if(sscanf(params, "s", string)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /asay [texto]");
	if(Player[playerid][pAdmin] >= 1)
	{
	    format(string, sizeof(string),"* Administrador %s: %s", Nome(playerid), string);
		SendClientMessageToAll(COR_ADMIN, string);
	}
	else if(Player[playerid][Vip] == 1)
	{
		format(string, sizeof(string),"[VIP BRONZE] {FFFFFF}%s>> %s", Nome(playerid), string);
		SendClientMessageToAll(BRONZE, string);
		Player[playerid][DelayAsay] = true;
		SetTimerEx("TempoAsay", 5000, 0, "i", playerid);
	}
	else if(Player[playerid][Vip] == 2)
	{
		format(string, sizeof(string),"[VIP PRATA] {FFFFFF}%s>> %s", Nome(playerid), string);
		SendClientMessageToAll(PRATA, string);
		Player[playerid][DelayAsay] = true;
		SetTimerEx("TempoAsay", 5000, 0, "i", playerid);
	}
	else if(Player[playerid][Vip] == 3)
	{
		format(string, sizeof(string),"[VIP GOLD] {FFFFFF}%s>> %s", Nome(playerid), string);
		SendClientMessageToAll(OURO, string);
		Player[playerid][DelayAsay] = true;
		SetTimerEx("TempoAsay", 5000, 0, "i", playerid);
	}
	else if(Player[playerid][pOrg] >= 1)
	{
		format(string, sizeof(string),"[GLOBAL ORGANIZADOR] {FFFFFF}%s>> {33AA33}%s", Nome(playerid), string);
		SendClientMessageToAll(COR_VERDE, string);
		Player[playerid][DelayAsay] = true;
		SetTimerEx("TempoAsay", 5000, 0, "i", playerid);
	}
	else if(Player[playerid][pPux] >= 1)
	{
		format(string, sizeof(string),"[GLOBAL PUXADOR] {FFFFFF}%s>> {33AA33}%s", Nome(playerid), string);
		SendClientMessageToAll(COR_VERDE, string);
		Player[playerid][DelayAsay] = true;
		SetTimerEx("TempoAsay", 5000, 0, "i", playerid);
	}
	else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	return 1;
}

CMD:reparar(playerid)
{
	if(LimiteReparar[playerid] == 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você só pode usar o /reparar de 120 em 120 segundos.");
	if(GetPlayerMoney(playerid) >= 500)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
			SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Seu veículo foi reparado com sucesso.");
			GivePlayerMoney(playerid, -500);
			LimiteReparar[playerid] = 1;
			SetTimerEx("TempoReparar", 120000, false, "i", playerid);
		}
		else
		{
			SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem um carro para utilizar este comando.");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem dinheiro suficiente, para reparar o carro.");
		return 1;
	}
	return 1;
}

CMD:toptorcidas(playerid)
{
    new bool:TopFoi[MAX_TORCIDAS], Valor_Maximo[10] = -1, TorcidaMelhor[10], Percorrido, nplayers[MAX_TORCIDAS], string[1024];

	for(new i = 0; i <= HighestID; i++)
    {
    	if(Player[i][pTorcida] > 0 && Player[i][pTorcida] < MAX_TORCIDAS)
			nplayers[Player[i][pTorcida]] += 1;
	}
    while(Percorrido < 10)
	{
    	for(new i = 0; i < MAX_TORCIDAS; i++)
     	{
            if(nplayers[i] > Valor_Maximo[Percorrido] && TopFoi[i] == false)
			{
                TorcidaMelhor[Percorrido] = i;
                Valor_Maximo[Percorrido] = nplayers[i];
                TopFoi[i] = true;
            }
	    }
	    Percorrido++;
	}
    Percorrido = 0;
	for(new i; i < 10;i++)
	{
	    if(TorcidaMelhor[i] != EOS)
	    {
            format(string, 1024,	"%s {ffffff}%d. {bcdc09}%s | %d Onlines{ffffff}\n", string, i+1, Torcidas[TorcidaMelhor[i]][tNome], Valor_Maximo[i]);
		    Valor_Maximo[i] = -1;
		}
    }

	ShowPlayerDialog(playerid, 666, DIALOG_STYLE_MSGBOX, "Top Equipes do Momento", string, "OK", "");
	return 1;
}

CMD:recusar(playerid, params[])
{
	new x_job[128], idx, string[128];
	x_job = strtok(params, idx);
	if(!strlen(x_job))
 	{
 	    SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /recusar [maconha/cocaina/aposta/entevista]");
		return 1;
	}
	if(strcmp(x_job,"aposta",true) == 0)
	{
		if(Player[playerid][InDuel]) return  SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você já está em um duelo.");
		if(Player[playerid][DuelInvite] == INVALID_PLAYER_ID) return  SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não foi convidado para um duelo.");
		format(string, sizeof(string),"[APOSTA] O jogador %s (id: %d) recusou seu desafio para um duelo.", Nome(playerid), playerid);
		SendClientMessage(Player[playerid][DuelInvite], COR_PRINCIPAL, string);
		SendClientMessage(playerid, COR_PRINCIPAL, "[APOSTA] Duelo recusado.");
		Player[Player[playerid][DuelInvite]][InDuel] = false;
		Player[playerid][InDuel] = false;
		Player[Player[playerid][DuelInvite]][DuelInvite] = INVALID_PLAYER_ID;
		Player[playerid][DuelInvite] = INVALID_PLAYER_ID;
		return 1;
	}
	return 1;
}

CMD:aceitar(playerid, params[])
{
	new x_job[128], idx, string[128];
	x_job = strtok(params, idx);
	if(!strlen(x_job))
 	{   SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /aceitar [maconha/cocaina/aposta/entrevista]");
		return 1;
	}
	if(strcmp(x_job,"aposta",true) == 0)
	{
		if(Player[playerid][InDuel]) return  SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você já está em um duelo.");
		if(Player[playerid][DuelInvite] == INVALID_PLAYER_ID || Player[playerid][DuelInvite] >= 1000) return  SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não foi convidado para um duelo.");
		format(string, sizeof(string),"[APOSTA] O jogador %s (id: %d) aceitou seu desafio para um duelo. Iniciando duelo em 5 segundos.", Nome(playerid), playerid);
		SendClientMessage(Player[playerid][DuelInvite], COR_PRINCIPAL, string);
		SendClientMessage(playerid, COR_PRINCIPAL, "[APOSTA] Iniciando duelo em 5 segundos.");
		GameTextForPlayer(playerid, "~g~Iniciando em 5 segundos", 2500, 3);
		GameTextForPlayer(Player[playerid][DuelInvite], "~g~Iniciando em 5 segundos", 2500, 3);
		SetTimerEx("StartDuel", 5000,false, "iiii",playerid, Player[playerid][DuelInvite], Player[playerid][DuelInviteType], Player[playerid][DuelInviteTypeArmour]);
		return 1;
	}
	return 1;
}

CMD:mudartorcida(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não pode mudar de torcida dentro de um veículo!");
	if(GetPlayerInterior(playerid) >= 1) return SendClientMessage(playerid, COR_ERRO, "ERRO: Você não pode mudar de torcida dentro de um interior!");
    ShowPlayerDialog(playerid, DIALOG_TORCIDAS, DIALOG_STYLE_LIST, "Escolha a região de sua torcida:", "Sudeste\nSul e Centro-Oeste\nNordeste e Norte", "Selecionar", "");
    return 1;
}

CMD:pagar(playerid, params[])
{
	new moneys, playermoney2, giveplayerid, giveplayer[MAX_PLAYER_NAME+1], sendername[MAX_PLAYER_NAME+1], tmp[256], string[256], idx;
	tmp = strtok(params, idx);
	if(!strlen(tmp)){SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /pagar [id] [quantidade]"); return 1;}
	giveplayerid = strval(tmp);
	tmp = strtok(params, idx);
	if(!strlen(tmp)){SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /pagar [id] [quantidade]"); return 1;}
	moneys = strval(tmp);
	if(moneys < 1 || moneys > 10000)
	{
		SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você só pode pagar entre 1 a 10.000.");
		return 1;
	}
	if (IsPlayerConnected(giveplayerid))
	{
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			if (ProxDetectorS(5.0, playerid, giveplayerid))
			{
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				playermoney2 = GetPlayerMoney(playerid);
				if (moneys > 0 && playermoney2 >= moneys)
				{
					GivePlayerMoney(playerid, (0 - moneys));
					GivePlayerMoney(giveplayerid, moneys);
					format(string, sizeof(string), "-GTBInfo-: Você pagou %d de dinheiro para o player %s.", moneys,giveplayer);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COR_PRINCIPAL, string);
					format(string, sizeof(string), "-GTBInfo-: %s pagou %d de dinheiro para você.",sendername, moneys);
					SendClientMessage(giveplayerid, COR_PRINCIPAL, string);
				}
				else
				{
					SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem essa quantidade de dinheiro!");
				}
			}
			else
			{
				SendClientMessage(playerid, COR_ERRO, "[ERRO]: Jogador está longe demais!");
			}
		}
	}
	else
	{
		SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este id não está online.");
	}
	return 1;
}

CMD:ajuda(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_AJUDA, DIALOG_STYLE_LIST, "{FF0000}¤ {FFFFFF}Tire suas dúvidas:", "{FF0000}¤ {FFFFFF}Ajuda Geral\n{FF0000}¤ {FFFFFF}Comandos do Servidor\n{FF0000}¤ {FFFFFF}Chamar um Administrador\n{FF0000}¤ {FFFFFF}Créditos", "Escolher", "Cancelar");
	return 1;
}

CMD:apostar(playerid, params[])
{
    new tmp[256], idx, cmd;
    new string[128];
    tmp = strtok(params, idx);

    if(!strlen(tmp)) return SendClientMessage(playerid,COR_USOCORRETO,"Uso correto: /apostar [convite]");

	if(strcmp(tmp, "convite", true)==0) cmd = 1;
	else return SendClientMessage(playerid,COR_USOCORRETO,"Uso correto: /apostar [convite]");

	if(cmd == 1)
	{
	    new id;
	    new tmp2[256], tmp3[256];
	    tmp = strtok(params, idx);
	    tmp2 = strtok(params, idx);
	    tmp3 = strtok(params, idx);

	    if(Player[playerid][DuelInvite] != INVALID_PLAYER_ID) return  SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você já convidou alguém. Aguarde.");

		if(Player[playerid][InDuel])
			return  SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você já está em um duelo.");

        if(!strlen(tmp)||!strlen(tmp2)||!strlen(tmp3)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /apostar convite [id] [camisa/bermuda] [comcolete/semcolete]");

        if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp);
		else id = strval(tmp);

        new type[26];
		new atype;
		if(strcmp(tmp2, "camisa", true)==0)
		{
			type = "Camisa";
			atype = 1;
		}
		else if(strcmp(tmp2, "bermuda", true)==0)
		{
			type = "Bermuda";
			atype = 2;
		}
		else return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /apostar convite [id] [camisa/bermuda] [comcolete/semcolete]");

        new typearmour[26];
		new btype;
		if(strcmp(tmp3, "comcolete", true)==0)
		{
			typearmour = "Com Colete";
			btype = 1;
		}
		else if(strcmp(tmp3, "semcolete", true)==0)
		{
			typearmour = "Sem Colete";
			btype = 2;
		}
		else return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /apostar convite [id] [camisa/bermuda] [comcolete/semcolete]");

		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este jogador não está conectado.");
		if(id == playerid) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Id inválido.");
		else if(Player[id][DuelInvite] != INVALID_PLAYER_ID) return  SendClientMessage(playerid, COR_ERRO,"[ERRP]: Esse jogador já convidou/foi convidado para um duelo.");

		else if (!ProxDetectorS(5.0, playerid, id)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está muito longe deste player!");

		else if(atype == 1 && Player[playerid][Camisas] == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem camisa para apostar!");
		else if(atype == 2 && Player[playerid][Bermudas] == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem bermuda para apostar!");
		else if(atype == 1 && Player[id][Camisas] == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este player não tem camisa para apostar!");
		else if(atype == 2 && Player[id][Bermudas] == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este player não tem bermuda para apostar!");

		format(string,128,"[APOSTA] %s (id: %d) desafiou você para uma aposta valendo '%s' da sua torcida, '%s'.", Nome(playerid), playerid, type, typearmour);
		SendClientMessage(id, COR_PRINCIPAL, string);
		SendClientMessage(id, COR_PRINCIPAL, "[APOSTA] Para aceitar digite '/aceitar aposta'.");
		SendClientMessage(id, COR_PRINCIPAL, "[APOSTA] Para recusar digite '/recusar aposta'.");
		SendClientMessage(playerid, COR_PRINCIPAL, "[APOSTA] Desafio enviado.");

		Player[id][DuelInvite] = playerid;
		Player[id][DuelInviteType] = atype;
		Player[id][DuelInviteTypeArmour] = btype;
        Player[playerid][DuelInvite] = 1000+playerid;

        SetTimerEx("ClearDuel",15000,false,"ii", playerid, id);
	}
	return 1;
}

CMD:reports(playerid)
{
	if(Player[playerid][pAdmin] >= 1)
	{
		SendClientMessage(playerid, 0xADFF2FFF,"** Últimos reports efetuados:");
		new string[200], acount;
		for(new i = 0; i < sizeof(Reports); i ++)
		{
			if(IsPlayerConnected(Reports[i]))
			{
			    if(Player[i][pRpt] == 0)
			    {
					format(string, sizeof(string),"** %d. %s (id: %d) | Motivo:%s", acount, Nome(Reports[i]), Reports[i], ReportsReasons[i]);
					SendClientMessage(playerid, COR_BRANCO, string);
					acount ++;
				}
			}
		}
		if(acount == 0)
		{
			SendClientMessage(playerid, COR_BRANCO, "Nenhum report encontrado.");
		}
	}
	return 1;
}

CMD:reportar(playerid, params[])
{
	new id,motivo[126], Str[300];
    if(sscanf(params,"us",id,motivo)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /reportar [id] [motivo]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Player não conectado.");
	if(Player[playerid][DelayReport] == true) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Por favor, sem floodar o '/reportar'.");
    SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: Obrigado por reportar, aguarde um administrador irá atender sua solicitação.");
    format(Str, sizeof(Str),"{FF0000}-ReportSystem-: %s reportou %s[ID:%d] | motivo: %s",Nome(playerid),Nome(id),id,motivo);
    SendMessageToAdminsEx(Str);
    new Index;
    motivo = strtok(params,Index);
    Player[playerid][LastReport] = id;
	Reports[rep_idx] = id;
	format(ReportsReasons[rep_idx],24, params[strlen(motivo)]);
	Player[playerid][DelayReport] = true;
 	SetTimerEx("TempoReport", 5000, 0, "i", playerid);
	rep_idx ++;
	if(rep_idx >= sizeof(Reports))
	rep_idx = 0;
    return true;
}

CMD:comandos(playerid)
{
	Comandos(playerid);
	return 1;
}

CMD:minhaconta(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_CONTA, DIALOG_STYLE_LIST, "Minha Conta", "Alterar Nick\nAlterar Senha\nMinhas Informações", "Selecionar", "Cancelar");
	return 1;
}

CMD:info(playerid)
{
    Status(playerid);
	return 1;
}

Status(playerid)
{
	new string[1100], dialogrande[1100], orgtext[20], orgtext1[20], orgtext2[20], orgtext3[20], orgtext4[20], orgtext5[20], orgtext6[20], orgtext7[20], cargotext[100];
	/* */
    if(Player[playerid][Vip] == 0) { orgtext = "Normal"; }
    if(Player[playerid][Vip] == 1) { orgtext = "VIP Bronze"; }
    if(Player[playerid][Vip] == 2) { orgtext = "VIP Prata"; }
    if(Player[playerid][Vip] == 3) { orgtext = "VIP Ouro"; }
 	/* */
  	if(Player[playerid][pPres] == 1) { orgtext1 = "Sim"; }
    if(Player[playerid][pPres] == 0) { orgtext1 = "Não"; }
 	/* */
   	if(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1) { orgtext2 = "Sim"; }
 	if(Player[playerid][pBope] == 0 && Player[playerid][pChoque] == 0) { orgtext2 = "Não"; }
 	/* */
   	if(Player[playerid][pReporter] >= 1) { orgtext3 = "Sim"; }
 	if(Player[playerid][pReporter] == 0) { orgtext3 = "Não"; }
 	/* */
   	if(Player[playerid][pHelper] >= 1) { orgtext4 = "Sim"; }
 	if(Player[playerid][pHelper] == 0) { orgtext4 = "Não"; }
 	/* */
 	if(Player[playerid][pvPres] == 1) { orgtext5 = "Sim"; }
    if(Player[playerid][pvPres] == 0) { orgtext5 = "Não"; }
 	/* */
 	if(Player[playerid][pOrg] == 1) { orgtext6 = "Sim"; }
    if(Player[playerid][pOrg] == 0) { orgtext6 = "Não"; }
    /* */
   	if(Player[playerid][pPux] == 1) { orgtext7 = "Sim"; }
    if(Player[playerid][pPux] == 0) { orgtext7 = "Não"; }
    /* */
 	if(Player[playerid][pChoque] == 5) { cargotext = "Coronel"; }
	if(Player[playerid][pChoque] == 4) { cargotext = "Tenente"; }
	if(Player[playerid][pChoque] == 3) { cargotext = "Sargento"; }
	if(Player[playerid][pChoque] == 2) { cargotext = "Cabo"; }
	if(Player[playerid][pChoque] == 1) { cargotext = "Soldado"; }
    /* */
	if(Player[playerid][pBope] == 5) { cargotext = "Coronel"; }
	if(Player[playerid][pBope] == 4) { cargotext = "Capitão"; }
	if(Player[playerid][pBope] == 3) { cargotext = "Sargento"; }
	if(Player[playerid][pBope] == 2) { cargotext = "Cabo"; }
	if(Player[playerid][pBope] == 1) { cargotext = "Aspira"; }

	format(string, sizeof(string),"%s%s",dialogrande,"{FFD519}• Informações da Conta\n\n"); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Nick: {ABABAB}%s\n", Nome(playerid)); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Tipo de Conta: {ABABAB}%s\n", orgtext); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Level: {ABABAB}%d\n", GetPlayerScore(playerid)); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Cash: {ABABAB}%d\n", Player[playerid][Cash]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Dinheiro: {ABABAB}%d\n", GetPlayerMoney(playerid)); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Skin ID: {ABABAB}%d\n", GetPlayerSkin(playerid)); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Policia: {ABABAB}%s\n", orgtext2); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Repórter: {ABABAB}%s\n", orgtext3); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Helper: {ABABAB}%s\n", orgtext4); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Matou: {ABABAB}%d\n", Player[playerid][pMatou]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Morreu: {ABABAB}%d\n", Player[playerid][pMorreu]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Maconha: {ABABAB}%d\n", Player[playerid][pMaconha]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Cocaina: {ABABAB}%d\n", Player[playerid][pCocaina]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Fogos: {ABABAB}%d\n", Player[playerid][pFogos]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Passagens pela Policia: {ABABAB}%d\n\n", Player[playerid][Passagens]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFD519}• Informações Relacionadas ao Torcedor\n\n"); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Pertence á {ABABAB}%s\n", Torcidas[Player[playerid][pTorcida]][tNome]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Presidente: {ABABAB}%s\n",orgtext1); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Vice-Presidente: {ABABAB}%s\n",orgtext5); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Organizador: {ABABAB}%s\n",orgtext6); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Puxador: {ABABAB}%s\n",orgtext7); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Camisas Tomadas: {ABABAB}%d\n",Player[playerid][PanosTomado]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Camisas Perdidas: {ABABAB}%d\n",Player[playerid][PanosPerdido]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Bermudas Tomadas: {ABABAB}%d\n",Player[playerid][BermudasTomada]); strcat(dialogrande, string);
	format(string, sizeof(string),"{FFFFFF}>> Bermudas Perdidas: {ABABAB}%d\n\n",Player[playerid][BermudasPerdida]); strcat(dialogrande, string);
	if(Player[playerid][pBope] >= 1 || Player[playerid][pChoque]>=1)
	{
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFD519}• Informações BTL\n\n");
		format(string, sizeof(string),"{FFFFFF}>> Su's Efetuados: {ABABAB}%d\n", Player[playerid][sutotal]); strcat(dialogrande, string);
		format(string, sizeof(string),"{FFFFFF}>> Abatimentos: {ABABAB}%d\n", Player[playerid][suabatidos]); strcat(dialogrande, string);
		format(string, sizeof(string),"{FFFFFF}>> Cargo: {ABABAB}%s\n", cargotext); strcat(dialogrande, string);
	}
	ShowPlayerDialog(playerid, 445, DIALOG_STYLE_MSGBOX, " ", dialogrande, "Fechar", "");
	return 1;	
}

//================= [COMANDOS CASAS] ==================//
CMD:menucarro(playerid)
{
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
    new house, ownerFile[200];

    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

    house = DOF2_GetInt(ownerFile, "houseID");

    if(!DOF2_FileExists(ownerFile))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Você não tem casa!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    if(houseVehicle[house][vehicleModel] == 0)
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Sua casa não tem um veículo!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    new
        Float: vehiclePos[3];

    GetVehiclePos(houseVehicle[house][vehicleHouse], vehiclePos[0], vehiclePos[1], vehiclePos[2]);

    if(!IsPlayerInRangeOfPoint(playerid, 20, vehiclePos[0], vehiclePos[1], vehiclePos[2]))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* O veículo está muito longe!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    ShowHouseVehicleMenu(playerid);
    return 1;
}

CMD:rebocarcarro(playerid)
{
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    new
        house,
        ownerFile[200];

    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

    house = DOF2_GetInt(ownerFile, "houseID");

    if(!DOF2_FileExists(ownerFile))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Você não tem casa!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    if(houseVehicle[house][vehicleModel] == 0)
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Sua casa não tem um veículo!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    if(GetPlayerMoney(playerid) < houseVehicle[house][vehiclePrice]/20)
    {
        GetPlayerPos(playerid, X, Y, Z);
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        SendClientMessage(playerid, COLOR_ERROR, "* Dinheiro Insuficiente!");
        TogglePlayerControllable(playerid, 1);

        return 1;
    }

    new
        string[128];

    format(string, 128, "Você solicitou o reboque do seu veículo por $%d.", houseVehicle[house][vehiclePrice]/20);
    SendClientMessage(playerid, COLOR_INFO, string);

    SendClientMessage(playerid, COLOR_INFO, "Ele será entregue na sua casa em até 3 minutos nas condições em que for encontrado");

    towRequired[house] = 1;
    GivePlayerMoney(playerid, -houseVehicle[house][vehiclePrice]/20);

    new
        logString[128];

    format(logString, sizeof logString, "O jogador %s[%d], solicitou o reboque do carro da casa %d.", playerName, playerid, house);
    WriteLog(LOG_VEHICLES, logString);

    return 1;
}

CMD:estacionar(playerid)
{
    GetPlayerPos(playerid, X, Y, Z);

    if(!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Você não está em nenhum veículo!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    else if(carSet[playerid] == 0 && !houseCarSet[playerid] && houseCarSetPos[playerid] == 0)
        return false;

    TogglePlayerControllable(playerid, 1);

    new
        housePath[200],
        vehiclePath[200],
        house,
        vehiclePath2[200],
        vehicleid = GetPlayerVehicleID(playerid);

    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    new
        ownerFile[200];

    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);

    house = DOF2_GetInt(ownerFile, "houseID");

	format(vehiclePath, sizeof vehiclePath, "LHouse/Casas/Casa %d.txt", house);

    if(vehicleid == carSetted[playerid])
    {
        if(carSet[playerid] == 1)
        {
        	format(vehiclePath2, sizeof vehiclePath2, "LHouse/Casas/Casa %d.txt", houseIDReceiveCar);

            new
                Float:PlayerFA;

            GetVehiclePos(carSetted[playerid], X, Y, Z);
            GetVehicleZAngle(carSetted[playerid], PlayerFA);

            carSet[playerid] = 0;

            new
                stringCat[2500];

            strcat(stringCat, "Modelo {FB1300}475 \t{FCEC00}Sabre                      \n");
            strcat(stringCat, "Modelo {FB1300}496 \t{FCEC00}Blista                     \n");
            strcat(stringCat, "Modelo {FB1300}560 \t{FCEC00}Sultan                     \n");
            strcat(stringCat, "Modelo {FB1300}401 \t{FCEC00}Bravura                    \n");
            strcat(stringCat, "Modelo {FB1300}404 \t{FCEC00}Perenniel                  \n");
            strcat(stringCat, "Modelo {FB1300}559 \t{FCEC00}Jester                     \n");
            strcat(stringCat, "Modelo {FB1300}402 \t{FCEC00}Buffalo                    \n");
            strcat(stringCat, "Modelo {FB1300}562 \t{FCEC00}Elegy                      \n");
            strcat(stringCat, "Modelo {FB1300}589 \t{FCEC00}Club                       \n");
            strcat(stringCat, "Modelo {FB1300}603 \t{FCEC00}Phoenix                    \n");
            strcat(stringCat, "Modelo {FB1300}400 \t{FCEC00}Landstalker                \n");
            strcat(stringCat, "Modelo {FB1300}429 \t{FCEC00}Banshee                    \n");
            strcat(stringCat, "Modelo {FB1300}415 \t{FCEC00}Cheetah                    \n");
            strcat(stringCat, "Modelo {FB1300}411 \t{FCEC00}Infernus                   \n");
            strcat(stringCat, "Modelo {FB1300}409 \t{FCEC00}Limosine                   \n");
            strcat(stringCat, "Modelo {FB1300}477 \t{FCEC00}ZR-350                     \n");
            strcat(stringCat, "Modelo {FB1300}506 \t{FCEC00}Super GT                   \n");
            strcat(stringCat, "Modelo {FB1300}541 \t{FCEC00}Bullet                     \n");
            strcat(stringCat, "Modelo {FB1300}451 \t{FCEC00}Turismo                    \n");
            strcat(stringCat, "Modelo {FB1300}468 \t{FCEC00}Sanchez     {FFFFFF} - MOTO\n");
            strcat(stringCat, "Modelo {FB1300}461 \t{FCEC00}PCJ-600     {FFFFFF} - MOTO\n");
            strcat(stringCat, "Modelo {FB1300}521 \t{FCEC00}FCR-900     {FFFFFF} - MOTO\n");
            strcat(stringCat, "Modelo {FB1300}463 \t{FCEC00}Freeway     {FFFFFF} - MOTO\n");
            strcat(stringCat, "Modelo {FB1300}522 \t{FCEC00}NRG-50      {FFFFFF} - MOTO\n");
            ShowPlayerDialog(playerid, DIALOG_CAR_MODELS_CREATED, DIALOG_STYLE_LIST, "{FFFFFF}Escolha um modelo e clique em continuar.", stringCat, "Continuar", "Cancelar");

            houseCarSet[playerid] = false;
    		houseVehicle[houseIDReceiveCar][vehicleX] = X;
    		houseVehicle[houseIDReceiveCar][vehicleY] = Y;
    		houseVehicle[houseIDReceiveCar][vehicleZ] = Z;
            houseVehicle[houseIDReceiveCar][vehicleAngle] = PlayerFA;
			houseVehicle[houseIDReceiveCar][vehicleColor1] = random(255);
			houseVehicle[houseIDReceiveCar][vehicleColor2] = random(255);
			houseVehicle[houseIDReceiveCar][vehicleRespawnTime] = 60*5;
            houseVehicle[houseIDReceiveCar][vehiclePrice] = 15000;

			DOF2_SetFloat(vehiclePath2, "Coordenada do Veículo X", houseVehicle[houseIDReceiveCar][vehicleX], "Veículo");
			DOF2_SetFloat(vehiclePath2, "Coordenada do Veículo Y", houseVehicle[houseIDReceiveCar][vehicleY], "Veículo");
			DOF2_SetFloat(vehiclePath2, "Coordenada do Veículo Z", houseVehicle[houseIDReceiveCar][vehicleZ], "Veículo");
            DOF2_SetFloat(vehiclePath2, "Angulo", houseVehicle[houseIDReceiveCar][vehicleAngle], "Veículo");
			DOF2_SetInt(vehiclePath2, "Cor 1", houseVehicle[houseIDReceiveCar][vehicleColor1], "Veículo");
			DOF2_SetInt(vehiclePath2, "Cor 2", houseVehicle[houseIDReceiveCar][vehicleColor2], "Veículo");
			DOF2_SetInt(vehiclePath2, "Valor", houseVehicle[houseIDReceiveCar][vehiclePrice], "Veículo");
			DOF2_SetInt(vehiclePath2, "Tempo de Respawn", houseVehicle[houseIDReceiveCar][vehicleRespawnTime], "Veículo");
            DOF2_SaveFile();

            adminCreatingVehicle[playerid] = false;
        }
    }
    else if(vehicleid == vehicleHouseCarDefined[house])
    {
        if(houseCarSet[playerid])
        {
            new
                Float:PlayerFA;

            GetVehiclePos(vehicleHouseCarDefined[house], X, Y, Z);
            GetVehicleZAngle(vehicleHouseCarDefined[house], PlayerFA);
            DestroyVehicle(vehicleHouseCarDefined[house]);
            SendClientMessage(playerid, COLOR_INFO, "* Carro salvo com sucesso!");

            houseCarSet[playerid] = false;
    		houseVehicle[house][vehicleX] = X;
    		houseVehicle[house][vehicleY] = Y;
    		houseVehicle[house][vehicleZ] = Z+3;
            houseVehicle[house][vehicleAngle] = PlayerFA;
			houseVehicle[house][vehicleColor1] = 0;
			houseVehicle[house][vehicleColor2] = 0;
			houseVehicle[house][vehicleRespawnTime] = 60*5;
            houseVehicle[house][vehiclePlate] = "LHouse S";

            DOF2_SetString(housePath, "Placa", houseVehicle[house][vehiclePlate], "Veículo");
            houseVehicle[house][vehicleHouse] = CreateVehicle(houseVehicle[house][vehicleModel], X, Y, Z, PlayerFA, 0, 0, 5*60);
    		DOF2_SetInt(vehiclePath, "Modelo do Carro", houseVehicle[house][vehicleModel], "Veículo");
			DOF2_SetFloat(vehiclePath, "Coordenada do Veículo X", houseVehicle[house][vehicleX], "Veículo");
			DOF2_SetFloat(vehiclePath, "Coordenada do Veículo Y", houseVehicle[house][vehicleY], "Veículo");
			DOF2_SetFloat(vehiclePath, "Coordenada do Veículo Z", houseVehicle[house][vehicleZ], "Veículo");
            DOF2_SetFloat(vehiclePath, "Angulo", houseVehicle[house][vehicleAngle], "Veículo");
			DOF2_SetInt(vehiclePath, "Cor 1", houseVehicle[house][vehicleColor1], "Veículo");
			DOF2_SetInt(vehiclePath, "Cor 2", houseVehicle[house][vehicleColor2], "Veículo");
			DOF2_SetInt(vehiclePath, "Valor", houseVehicle[house][vehiclePrice], "Veículo");
			DOF2_SetInt(vehiclePath, "Tempo de Respawn", houseVehicle[house][vehicleRespawnTime], "Veículo");
            DOF2_SaveFile();
        }
    }
    if(houseCarSetPos[playerid] == 1)
    {
        SendClientMessage(playerid, COLOR_INFO, "* Carro salvo com sucesso!");

        new
            CarroP = GetPlayerVehicleID(playerid),
            Float:PlayerFA;

        houseCarSetPos[playerid] = 0;

        GetVehiclePos(CarroP, X, Y, Z);
        GetVehicleZAngle(CarroP, PlayerFA);

    	houseVehicle[house][vehicleX] = X;
    	houseVehicle[house][vehicleY] = Y;
    	houseVehicle[house][vehicleZ] = Z;
        houseVehicle[house][vehicleAngle] = PlayerFA;

		DOF2_SetFloat(vehiclePath, "Coordenada do Veículo X", houseVehicle[house][vehicleX]);
		DOF2_SetFloat(vehiclePath, "Coordenada do Veículo Y", houseVehicle[house][vehicleY]);
		DOF2_SetFloat(vehiclePath, "Coordenada do Veículo Z", houseVehicle[house][vehicleZ]);
        DOF2_SetFloat(vehiclePath, "Angulo", houseVehicle[house][vehicleAngle]);
        DOF2_SaveFile();
    }
    return 1;
}

CMD:ircasa(playerid, params[])
{
    GetPlayerPos(playerid, X, Y, Z);

    if(!IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Sem autorização.");

        GetPlayerPos(playerid, X, Y, Z);
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    new
        house;

    if(sscanf(params, "i", house))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Use: {46FE00}/ircasa {00E5FF}[houseID]");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    new
        filePath[150];

	format(filePath, sizeof filePath, "LHouse/Casas/Casa %d.txt", house);

    if(!DOF2_FileExists(filePath))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Essa casa não existe!");
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    new
        string[200];

    if(!IsPlayerInAnyVehicle(playerid))
    {
        SetPlayerPos(playerid, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, -1);
    } else {
        new v = GetPlayerVehicleID(playerid);
        SetPlayerPos(playerid, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
        SetVehiclePos(v, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ] + 5);
        SetPlayerInterior(playerid, 0);
        LinkVehicleToInterior(v, 0);
        SetPlayerVirtualWorld(playerid, -1);
        SetVehicleVirtualWorld(v, -1);
        PutPlayerInVehicle(playerid, v, 0);
    }

    format(string, sizeof string, "* Você foi até a casa de ID {00E5FF}%d", house);
    SendClientMessage(playerid, COLOR_INFO, string);

    new
        logString[128];

    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
    format(logString, sizeof logString, "O administrador %s[%d], foi até a casa %d.", playerName, playerid, house);
    WriteLog(LOG_ADMIN, logString);

    return 1;
}

CMD:criarcasa(playerid, params[])
{
    ShowCreateHouseDialog(playerid);
    return 1;
}

CMD:criaraqui(playerid, params[])
{
    if (IsPlayerAdmin(playerid))
    {
        if (adminCreatingVehicle[playerid])
        {
            CreateHouseVehicleToPark(playerid);
            return 1;
        }
        else
            return 0;
    }
    else
        return 0;
}


// ======================= [ Repórteres ] ====================================== //
CMD:rtgrade(playerid)
{
	if(!(Player[playerid][pAdmin] >= 5 || Player[playerid][pReporter] >= 4))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	for(new i = 0; i <= HighestID; i++)
	{
		DestroyDynamicObject(Player[i][Grade]);
		Player[i][Grade] = 0;
	}
	new string[128];
	format(string,sizeof(string),"-Info-: Todas as Grades foram retiradas por %s.", Nome(playerid));
	SendClientMessageToAll(0x0000FFFF, string);
	return 1;
}
CMD:rgrade(playerid)
{
    if(Player[playerid][Grade] == 0)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não usou /grade!");
	if(!(Player[playerid][pAdmin] >= 2 || Player[playerid][pReporter] >= 2))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	DestroyDynamicObject(Player[playerid][Grade]);
	Player[playerid][Grade] = 0;
	new string[75];
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}destruiu uma grade.", Nome(playerid));
    MensagemPerto(playerid, COR_ROXO, string, 50);
	return 1;
}
CMD:grade(playerid)
{
    if(Player[playerid][Grade] >= 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você já usou /grade, use /rgrade para poder usar novamente!");
	if(!(Player[playerid][pAdmin] >= 2 || Player[playerid][pReporter] >= 2))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	Player[playerid][Grade] = CreateDynamicObject(971, X, Y, Z+2.6, 0.0, 0.0, A);
	SetPlayerPos(playerid, X-5, Y, Z);
	new string[70];
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}criou uma grade.", Nome(playerid));
    MensagemPerto(playerid, COR_ROXO, string, 50);
	return 1;
}

// ======================= [ Policiais ] ============================================= //
CMD:setbope(playerid,params[])
{
	new id, level,string[400];
	if(Player[playerid][pAdmin] >= 4 || Player[playerid][pBope] >= 5)
	{
	    new cargotext[60];
		if(Player[playerid][pBope] == 5) { cargotext = "Coronel"; }
		if(Player[playerid][pBope] == 4) { cargotext = "Capitão"; }
		if(Player[playerid][pBope] == 3) { cargotext = "Sargento"; }
		if(Player[playerid][pBope] == 2) { cargotext = "Cabo"; }
		if(Player[playerid][pBope] == 1) { cargotext = "Aspira"; }
		if(Player[playerid][pAdmin] == 5) { cargotext = "Game Master"; }
		if(Player[playerid][pAdmin] == 4) { cargotext = "Sub Game Master"; }

		if(sscanf(params,"ud",id,level)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /setbope [id] [level]");
		if(level > 5) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Máximo de Level a ser setado é 5.");
		if(Logado[id] == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este jogador não está Logado.");
		if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
		format(string,sizeof(string),"-BOPE-: O %s %s te setou de Level %d da BOPE .",cargotext, Nome(playerid),level);
		SendClientMessage(id,COR_BOPE,string);
		format(string,sizeof(string),"-BOPE-: Você setou %s de Level %d da BOPE.",Nome(id),level);
		SendClientMessage(playerid,COR_BOPE,string);
		Player[id][pBope]=level;
		format(string, 128,"{363636}-BOPE-: O %s %s setou %s de Level %d da BOPE.", cargotext, Nome(playerid), Nome(id), level);
		SendMessageToAdminsEx(string);
		format(string, 128,"{363636}-BOPE-: O %s %s setou %s de Level %d da BOPE.", cargotext, Nome(playerid), Nome(id), level);
		MensagemBope(string);
		SalvarPlayer(id);
	}
	else
	{
		SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	}
	return 1;
}

CMD:setchq(playerid,params[])
{
	new id, level,string[128];
	if(Player[playerid][pAdmin] >= 4 || Player[playerid][pBope] >= 5)
	{
	    new cargotext[60];
	  	if(Player[playerid][pChoque] == 5) { cargotext = "Coronel"; }
		if(Player[playerid][pChoque] == 4) { cargotext = "Tenente"; }
		if(Player[playerid][pChoque] == 3) { cargotext = "Sargento"; }
		if(Player[playerid][pChoque] == 2) { cargotext = "Cabo"; }
		if(Player[playerid][pChoque] == 1) { cargotext = "Soldado"; }
		if(Player[playerid][pAdmin] == 5) { cargotext = "Game Master"; }
		if(Player[playerid][pAdmin] == 4) { cargotext = "Sub Game Master"; }

		if(sscanf(params,"ud",id,level)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /setchq [id] [level]");
		if(level > 5) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Máximo de Level a ser setado é 5.");
		if(Logado[id] == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Este jogador não está Logado.");
		if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
		format(string,sizeof(string),"-CHOQUE-: O %s %s te setou de Level %d da CHOQUE .",cargotext, Nome(playerid),level);
		SendClientMessage(id,COR_CHOQUE,string);
		format(string,sizeof(string),"-CHOQUE-: Você setou %s de Level %d da CHOQUE.",Nome(id),level);
		SendClientMessage(playerid,COR_CHOQUE,string);
		Player[id][pChoque]=level;
		format(string, 128,"{A9A9A9}-CHOQUE-: O %s %s setou %s de Level %d da CHOQUE.", cargotext, Nome(playerid), Nome(id), level);
		SendMessageToAdminsEx(string);
		format(string, 128,"{A9A9A9}-CHOQUE-: O %s %s setou %s de Level %d da CHOQUE.", cargotext, Nome(playerid), Nome(id), level);
		MensagemChoque(string);
	}
	else
	{
		SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	}
	return 1;
}

CMD:bopes(playerid)
{
	SendClientMessage(playerid, 0xADFF2FFF, "** Todos os BOPE (2º Batalhão) online");
	new cargotext[64], string[126], trabalhando[40];
	new count=0;
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(Logado[playerid] == true)
			{
				if(Player[i][pBope] >= 1)
				{
					if(Player[i][pBope] == 5) { cargotext = "Coronel"; }
					if(Player[i][pBope] == 4) { cargotext = "Capitão"; }
					if(Player[i][pBope] == 3) { cargotext = "Sargento"; }
					if(Player[i][pBope] == 2) { cargotext = "Cabo"; }
					if(Player[i][pBope] == 1) { cargotext = "Aspira"; }
					if(Player[i][EmTrabalho] == true) { cargotext = "Trabalhando"; }
					if(Player[i][EmTrabalho] == false) { cargotext = "Jogando"; }
					format(string, sizeof(string),"Policial %s [Cargo: %s] [Status: %s]", Nome(i), cargotext, trabalhando);
					SendClientMessage(playerid, COR_BRANCO, string);
					count++;
				}
			}
		}
	}
	if(count == 0) return SendClientMessage(playerid, COR_BRANCO, "** Não tem nem um bope online no momento.");
	return 1;
}

CMD:procurados(playerid)
{
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	new count=0;
	new str[106],city[64];
	SendClientMessage(playerid, COR_PRINCIPAL, "________________|TODOS OS PROCURADOS ONLINE|________________");
	for(new i = 0; i <= HighestID; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(Logado[i] == true)
			{
				if(Player[i][Procurado] >= 1)
				{
						switch(GetPlayerCity(i))
						{
							case CIDADELS: city = "Los Santos";
							case CIDADESF: city = "San Fiero";
							case CIDADELV: city = "Las Venturas";
						}
						format(str, sizeof(str), "** Procurado: %s | [ID %d] | [Nivel %d] | [Está na cidade de: %s]", Nome(i), i, Player[i][Procurado], city);
						SendClientMessage(playerid, COR_BRANCO, str);
						count++;
				}
			}
		}
	}
	if(count == 0)
	{
		SendClientMessage(playerid, COR_BRANCO, "Não foi encontrado nenhum procurado!");
	}
	return 1;
}

CMD:su(playerid, params[]) //
{
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	new id, string[170];
	if(!(Player[id][pBope] < 1 || Player[id][pChoque] < 1))return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não pode dar nível de procurado para um policial.");
	if(sscanf(params, "us[100]", id, params))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /su [id] [crime]");
 	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	SetPlayerWantedLevel(id, GetPlayerWantedLevel(id) + 1);
	Player[id][Procurado] += 1;
	format(string,sizeof(string),"Você foi feito um procurado pelo polícial %s | Crime: %s.", Nome(playerid), params);
	SendClientMessage(id, COR_NEGATIVO,string);
	new city[64] = "Não identificado";
	switch(GetPlayerCity(id))
	{
		case CIDADELS: city = "Los Santos";
		case CIDADESF: city = "San Fierro";
		case CIDADELV: city = "Las Venturas";
	}

	format(string,sizeof(string),"HQ: Chamando todas as unidades, denunciante: %s.", Nome(playerid));
	SendMessageToCops(COR_VERDE, string);
	format(string,sizeof(string),"HQ: Crime: %s | Suspeito: %s (ID: %d) | Local: %s.", params, Nome(id), id, city);
	SendMessageToCops(COR_VERDE, string);
	Player[playerid][sutotal]++;
	SalvarPlayer(id);
	SalvarPlayer(playerid);
	return 1;
}

CMD:revistar(playerid, params[])
{
	new id, string[128];
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /revistar [id]");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: ID inválido!");
	if(Logado[id] == false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Esse jogador não está logado!");
	
    if(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1)
	{
        if (ProxDetectorS(5.0, playerid, id))
		{
		    MostrarMochila(playerid, id, 2, 0);
			format(string, sizeof(string), "[ ! ] {FFFFFF}%s {C798FA}foi revistado pelo Policial {FFFFFF}%s{C798FA}.", Nome(id), Nome(playerid));
			MensagemPerto(id, COR_ROXO, string, 60);
		}
		else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Esse player está muito distante de você!");
	}
	else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	return 1;
}

CMD:rdrogas(playerid, params[])
{
	new id, string[170];
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(sscanf(params, "d", id)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /rdrogas [id]");
 	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	if(Player[id][pMaconha] >=1 || Player[id][pCocaina]>=1)
	{
		if (ProxDetectorS(5.0, playerid, id))
		{
			Player[id][pMaconha] = 0;
			Player[id][pCocaina] = 0;
			format(string, sizeof(string),"[INFO]: O polícial %s retirou suas drogas.", Nome(playerid) );
			SendClientMessage(id, COR_PRINCIPAL, string);
			format(string, sizeof(string), "[INFO]: Você retirou as drogas de %s.", Nome(id) );
			SendClientMessage(playerid, COR_PRINCIPAL, string);
		}
	}
	else
	{
	    SendClientMessage(playerid,COR_ERRO,"[ERRO]: O player não tem drogas.");
	}
	return 1;
}

CMD:m(playerid, params[])
{
	if(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1)
	{
		if(sscanf(params, "s[200]", params)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /m [texto]");
		for(new i=0; i <= MAX_PLAYERS; i++)
			if(GetDistanceBetweenPlayers(playerid, i) <= 60)
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
			{
				new string[900];
				format(string, sizeof(string), "[Policial %s]: %s", Nome(playerid), params);
				SendClientMessage(i, COR_AMARELO,string);
			}
		}
	}
	return 1;
}

CMD:cone(playerid)
{
	if(!(Player[playerid][pReporter] >= 1 || Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está trabalhando pra poder usar este comando!");
	if(Player[playerid][Cone] >= 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você já usou /cone, use /rcone para poder usar novamente!");
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	Player[playerid][Cone] = CreateDynamicObject(1237, X, Y, Z-1.0, 0.0, 0.0, A);
	SetPlayerPos(playerid, X, Y, Z+4);

	new string[65];
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}criou um cone.", Nome(playerid));
	MensagemPerto(playerid, COR_ROXO, string, 50);
	return 1;
}
CMD:rcone(playerid)
{
	if(!(Player[playerid][pReporter] >= 1 || Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][Cone] == 0)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não usou /cone!");
	DestroyDynamicObject(Player[playerid][Cone]);
	Player[playerid][Cone] = 0;

	new string[70];
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}retirou seu cone.", Nome(playerid));
	MensagemPerto(playerid, COR_ROXO, string, 50);
	return 1;
}

CMD:rtcone(playerid)
{
	if(Player[playerid][pBope] >= 4 || Player[playerid][pChoque] >= 4 || Player[playerid][pReporter] >= 4)
	{
		for(new i = 0; i <= HighestID; i++)
		{
			if(Player[i][Cone] >= 1)
			{
				DestroyDynamicObject(Player[i][Cone]);
				Player[i][Cone] = 0;
			}
		}
		new string[128];
		format(string,sizeof(string),"[AVISO]: Todos os cones foram retiradas por %s.", Nome(playerid));
		SendMessageToCops(0x228B22FF, string);
	}
	else
	SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão pra poder usar esse comando!");
	return 1;
}

CMD:br(playerid)
{
	if(!(Player[playerid][pBope] >= 2 || Player[playerid][pChoque] >= 2))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(IsPlayerInRangeOfPoint(playerid, 20.0, 2314.5869,-4.6078,26.7422))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não pode criar barricadas no banco!");
	if(Player[playerid][pBarreira] >= 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você já tem barreira criada, use [/rbr] para deletar a barreira.");
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	Player[playerid][pBarreira] = CreateDynamicObject(981, X, Y, Z, 0.0, 0.0, A);
	SetPlayerPos(playerid, X, Y, Z+4);

	new string[70];
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}criou uma barreira.", Nome(playerid));
	MensagemPerto(playerid, COR_ROXO, string, 50);
	return 1;
}

CMD:rbr(playerid)
{
	if(!(Player[playerid][pBope] >= 2 || Player[playerid][pChoque] >= 2))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][pBarreira] == 0)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem barreira criada!");
	DestroyDynamicObject(Player[playerid][pBarreira]);
	Player[playerid][pBarreira] = 0;
	new string[75];
	format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}deletou uma barreira.", Nome(playerid));
	MensagemPerto(playerid, COR_ROXO, string, 50);
	return 1;
}
CMD:rtbr(playerid)
{
	if(Player[playerid][pBope] >= 5 || Player[playerid][pChoque] >= 5)
	{
		for(new i = 0; i <= HighestID; i++)
		{
			DestroyDynamicObject(Player[i][pBarreira]);
			Player[i][pBarreira] = 0;
		}
		new string[70];
		format(string,sizeof(string),"[HQ]: Todas as barreiras policiais foram retiradas por %s.", Nome(playerid));
		SendMessageToCops(0x228B22FF, string);
	}
	else
	SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão.");
	return 1;
}

CMD:pregos(playerid)
{
	if(!(Player[playerid][pBope] >= 3 || Player[playerid][pChoque] >= 3)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
    if(CrieiTapete[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você já colocou um Tapete de Pregos! Aguarde a remoção automática ou use /dpregos!");
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	}
	else
	{
		GetPlayerPos(playerid,TapeteX,TapeteY,TapeteZ);
		if(IsPlayerInAnyVehicle(playerid))
		{
			GetVehicleZAngle(GetPlayerVehicleID(playerid), AnguloTapete);
			new ModeloCOP = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(ModeloCOP == 599 || ModeloCOP == 528 || ModeloCOP == 490)
			{
				TapeteCOP[playerid] = CreateObject(2899, TapeteX,TapeteY,TapeteZ-1.0, 0, 0, AnguloTapete+268.0);
			}
			else if(ModeloCOP == 470 || ModeloCOP == 432)
			{
				TapeteCOP[playerid] = CreateObject(2899, TapeteX,TapeteY,TapeteZ-0.9, 0, 0, AnguloTapete+268.0);
			}
			else if(ModeloCOP == 461 || ModeloCOP == 510 || ModeloCOP == 521 || ModeloCOP == 522 || ModeloCOP == 523)
			{
				TapeteCOP[playerid] = CreateObject(2899, TapeteX,TapeteY,TapeteZ-0.4, 0, 0, AnguloTapete+268.0);
			}
			else
			{
				TapeteCOP[playerid] = CreateObject(2899, TapeteX,TapeteY,TapeteZ-0.6, 0, 0, AnguloTapete+268.0);
			}
			CrieiTapete[playerid] = 1;
			KillTimer(PassandoTapete[playerid]);
			PassandoTapete[playerid] = SetTimer("FurandoPneu",199,1);
			TempoTapete[playerid] = SetTimerEx("DeletarTapete", 60000, 0, "d", playerid);
			GameTextForPlayer(playerid,"~y~Tapete de pregos ~n~~w~foi colocado",5000,1);
			SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você colocou um Tapete de Pregos! Ele será removido em 30 segundos ou use /tpregos!");
			PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		}
		else
		{
			GetPlayerFacingAngle(playerid, AnguloTapete);
			CrieiTapete[playerid] = 1;
			TapeteCOP[playerid] = CreateObject(2899, TapeteX,TapeteY,TapeteZ-0.9, 0, 0, AnguloTapete+268.0);
			KillTimer(PassandoTapete[playerid]);
			PassandoTapete[playerid] = SetTimer("FurandoPneu",199,1);
			TempoTapete[playerid] = SetTimerEx("DeletarTapete", 30000, 0, "d", playerid);
			GameTextForPlayer(playerid,"~y~Tapete de pregos ~n~~w~foi colocado",5000,1);
			SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você colocou um Tapete de Pregos! Ele será removido em 30 segundos ou use /tpregos!");
			PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		}
	}
	return 1;
}

CMD:escudo(playerid)
{
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(Equipamentos[playerid] == 1)
	{
		RemovePlayerAttachedObject(playerid,3);
		SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você desativou o escudo protetor!");
		Equipamentos[playerid] = 0;
		return 1;
	}
	if(Equipamentos[playerid] == 0)
	{
		SetPlayerAttachedObject(playerid,3,18637,13,0.35,0.0,0.0,0.0,0.0,180.0);
		SendClientMessage(playerid,COR_PRINCIPAL,"[INFO]: Você ativou o escudo protetor!");
		Equipamentos[playerid] = 1;
		return 1;
	}
	return 1;
}

CMD:rtcdp(playerid)
{
	if(Player[playerid][pBope] >= 4)
	{
		SetVehicleToRespawn(CarBOPE[1]);
		SetVehicleToRespawn(CarBOPE[2]);
		SetVehicleToRespawn(CarBOPE[3]);
		SetVehicleToRespawn(CarBOPE[4]);
		SetVehicleToRespawn(CarBOPE[5]);
		SetVehicleToRespawn(CarBOPE[6]);
		SetVehicleToRespawn(CarBOPE[7]);
		SetVehicleToRespawn(CarBOPE[8]);
		SetVehicleToRespawn(CarBOPE[9]);
		SetVehicleToRespawn(CarBOPE[10]);
		SetVehicleToRespawn(CarBOPE[11]);
		SetVehicleToRespawn(CarBOPE[12]);
		SetVehicleToRespawn(CarBOPE[13]);
		SetVehicleToRespawn(CarBOPE[14]);
		SetVehicleToRespawn(CarBOPE[15]);
		SetVehicleToRespawn(CarBOPE[16]);
		SetVehicleToRespawn(CarBOPE[17]);
		SetVehicleToRespawn(CarBOPE[18]);
		SetVehicleToRespawn(CarBOPE[19]);
		SetVehicleToRespawn(CarBOPE[20]);
		SetVehicleToRespawn(CarBOPE[21]);
		SetVehicleToRespawn(CarBOPE[22]);
		SetVehicleToRespawn(CarBOPE[23]);
		SetVehicleToRespawn(CarBOPE[24]);
		SetVehicleToRespawn(CarBOPE[25]);
		new string[101];
		format(string, sizeof(string), "{0000FF}[HQ]: Todas as unidades: Polícial %s respawnou todos os carros do BOPE.", Nome(playerid));
		SendMessageToCops(-1, string);
	}
	return 1;
}

CMD:apbope2(playerid)
{
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(Player[playerid][pBope] < 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	MoveDynamicObject(portaoBOPE2,2334.43,2443.65,0.0906,10);
	SetTimerEx("FecharPortaoBOPE2", 5000, 0, "i", playerid);
	for(new i=0; i <= MAX_PLAYERS; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 20)
	{
		SendClientMessage(i, COR_PORTAO, "** Portão aberto irá fechar em 5 segundos.");
	}
	return 1;
}
CMD:apbope(playerid)
{
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(Player[playerid][pBope] < 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	MoveDynamicObject(portaoBOPE,2237.6,2453.08,1.45,10);
	SetTimerEx("FecharPortaoBOPE", 5000, 0, "i", playerid);
	for(new i=0; i <= MAX_PLAYERS; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 20)
	{
		SendClientMessage(i, COR_PORTAO, "** Portão aberto irá fechar em 5 segundos.");
	}
	return 1;
}

CMD:jogar(playerid)
{
	if(Player[playerid][pReporter] < 1 && Player[playerid][pBope] < 1 && Player[playerid][pChoque] < 1)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não tem permissão para usar este comando!");
	if(Player[playerid][EmTrabalho] == false) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não está em trabalho!");
	GetPlayerPos(playerid, Player[playerid][LastPos][0], Player[playerid][LastPos][1], Player[playerid][LastPos][2]);
	SetTimerEx("Jogar", 5000, false, "i", playerid);
	SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Aguarde sem se mover.");
	return 1;
}

CMD:dpregos(playerid)
{
	if(!(Player[playerid][pBope] >= 3 || Player[playerid][pChoque] >= 3)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
    if(CrieiTapete[playerid] == 0)
	{
		SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não pôs nenhum Tapete de Pregos!");
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return 1;
	}
	else
	{
		CrieiTapete[playerid] = 0;
		DestroyObject(TapeteCOP[playerid]);
		KillTimer(TempoTapete[playerid]);
		KillTimer(PassandoTapete[playerid]);
		GameTextForPlayer(playerid,"~y~Tapete de pregos ~n~~r~foi removido",5000,1);
		//Evita que os pneus sejam furados depois que o Tapete for retirado!
		TapeteX = 0.000000, TapeteY = 0.000000, TapeteZ = 0.000000;
	}
	return 1;
}

CMD:membros(playerid)
{
	if(Player[playerid][pBope] >= 1)
	{
		SendClientMessage(playerid, 0xADFF2FFF, "** Todos os Membros da Policia online");
		new cargotext[64], string[126], trabalhando[40];
		new count=0;
		for(new i=0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(Logado[playerid] == true)
				{
					if(Player[i][pBope] >= 1)
					{
						if(Player[i][pBope] == 5) { cargotext = "Coronel"; }
						if(Player[i][pBope] == 4) { cargotext = "Capitão"; }
						if(Player[i][pBope] == 3) { cargotext = "Sargento"; }
						if(Player[i][pBope] == 2) { cargotext = "Cabo"; }
						if(Player[i][pBope] == 1) { cargotext = "Aspira"; }
						if(Player[i][EmTrabalho] == true) { trabalhando = "Trabalhando"; }
						if(Player[i][EmTrabalho] == false) { trabalhando = "Jogando"; }
						format(string, sizeof(string),"Policial %s [Cargo: %s] [Status: %s]", Nome(i), cargotext, trabalhando);
						SendClientMessage(playerid, COR_BRANCO, string);
						count++;
					}
				}
			}
		}
		if(count == 0) return SendClientMessage(playerid, COR_BRANCO, "** Não tem nem um bope online no momento.");
	}
	else {SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão.");}
	return 1;
}

CMD:comandosbope(playerid)
{
	if(Player[playerid][pBope] < 1)return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	ComandosBOPE(playerid);
	return 1;
}

CMD:laseron(playerid)
{
	if(!(Player[playerid][pBope]>=2 || Player[playerid][pChoque]>=2))return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Acesso restrito as organizações policiais.");
	SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: Você ativou sua mira a laser.");
	SetPVarInt(playerid, "laser", 1);
    SetPVarInt(playerid, "color", GetPVarInt(playerid, "color"));
    return 1;
}

CMD:laseroff(playerid)
{
	if(!(Player[playerid][pBope]>=2 || Player[playerid][pChoque]>=2))return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Acesso restrito as organizações policais.");
	SendClientMessage(playerid, COR_PRINCIPAL,"[INFO]: Você desativou sua mira a laser.");
    SetPVarInt(playerid, "laser", 0);
    RemovePlayerAttachedObject(playerid, 0);
    return 1;
}

CMD:lasercor(playerid,params[])
{
    new tmp[256];
    if(!(Player[playerid][pBope]>=2 || Player[playerid][pChoque]>=2))return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Acesso restrito as organizações policais.");
    if(sscanf(params, "s", tmp)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /lasercor [vermelho,azul,rosa,laranja,verde,amarelo]");
    if (!strcmp(tmp, "vermelho", true)) SetPVarInt(playerid, "color", 18643);
    else if (!strcmp(tmp, "azul", true)) SetPVarInt(playerid, "color", 19080);
    else if (!strcmp(tmp, "rosa", true)) SetPVarInt(playerid, "color", 19081);
    else if (!strcmp(tmp, "laranja", true)) SetPVarInt(playerid, "color", 19082);
    else if (!strcmp(tmp, "verde", true)) SetPVarInt(playerid, "color", 19083);
    else if (!strcmp(tmp, "amarelo", true)) SetPVarInt(playerid, "color", 19084);
    else SendClientMessage(playerid, COR_ERRO, "[ERRO] Cor inválida!");
    return 1;
}

CMD:algemar(playerid,params[])
{
	new id, string[85];
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
 	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	if(sscanf(params, "u", id))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /algemar [id]");
	for(new i=0; i <= MAX_PLAYERS; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 20)
	{
		format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}algemou {ffffff}%s{C798FA}.", Nome(playerid), Nome(id));
		SendClientMessage(i,COR_ROXO,string);
	}
	SetPlayerSpecialAction(id, SPECIAL_ACTION_CUFFED);
	GameTextForPlayer(id, "~r~Algemado", 2500, 3);
	return 1;
}
CMD:desalgemar(playerid,params[])
{
	new id, string[110];
	if(Player[playerid][EmTrabalho] == false)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em trabalho [/dp].");
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(sscanf(params, "u", id))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /desalgemar [id]");
 	if(!IsPlayerConnected(id) && id != INVALID_PLAYER_ID)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Jogador não conectado.");
	SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
	GameTextForPlayer(id, "~r~Desalgemado", 2500, 3);
	for(new i=0; i <= MAX_PLAYERS; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= 20)
	{
		format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}desalgemou {ffffff}%s{C798FA}.", Nome(playerid), Nome(id));
		SendClientMessage(i,COR_ROXO,string);
	}
	return 1;
}

CMD:d(playerid, params[])
{
	if(!(Player[playerid][pBope] >= 1 || Player[playerid][pChoque] >= 1))return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	if(sscanf(params, "s[128]", params)) return SendClientMessage(playerid, COR_USOCORRETO,"Uso correto: /d [texto]");
	new cargotext[64];
	if(Player[playerid][pBope] >= 1) { cargotext = "BOPE"; }
	if(Player[playerid][pChoque] >= 1) { cargotext = "CHOQUE"; }
	new string[250];
	format(string, sizeof(string), "{3A5FCD}** %s %s (ID:%d): %s, desligo. **", cargotext, Nome(playerid), playerid, params);
	SendMessageToCops(COR_BOPE, string);
	return 1;
}

CMD:b(playerid, params[])
{
	if(sscanf(params, "s[200]", params))return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /b [mensagem]");
	if(Player[playerid][pBope] > 0)
	{
		new cargotext[64], string[200];
		if(Player[playerid][pBope] == 5) { cargotext = "Coronel"; }
		if(Player[playerid][pBope] == 4) { cargotext = "Capitão"; }
		if(Player[playerid][pBope] == 3) { cargotext = "Sargento"; }
		if(Player[playerid][pBope] == 2) { cargotext = "Cabo"; }
		if(Player[playerid][pBope] == 1) { cargotext = "Aspira"; }

		for(new i = 0; i <= HighestID; i ++)
		{
			if(IsPlayerConnected(i))
			{
				if(Player[i][pBope] >= 1)
				{
					format(string, sizeof(string),"[BOPE RÁDIO] %s %s (ID: %d): %s **", cargotext, Nome(playerid), playerid, params);
					SendClientMessage(i, COR_BOPE, string);
				}
			}
		}
	}
	else SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando!");
	return 1;
}

CMD:dp(playerid, params[])
{
	new string[110];
	new State = GetPlayerState(playerid);
	if(Player[playerid][TempoPreso] >= 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está preso.");
	if(Player[playerid][NoHospital] == true) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você está no hospital!");
	if(Player[playerid][pBope] >= 1)
	{
		if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
		{
			SetPlayerPos(playerid, 2296.7395,2460.0120,10.8203);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), 179.3871);
		}
		else
		{
			SetPlayerPos(playerid, 2296.7395,2460.0120,10.8203);
			SetPlayerFacingAngle(playerid, 268.4397);
		}
	  	new cargotext[30];
		if(Player[playerid][pBope] == 5) { cargotext = "Coronel"; }
		if(Player[playerid][pBope] == 4) { cargotext = "Capitão"; }
		if(Player[playerid][pBope] == 3) { cargotext = "Sargento"; }
		if(Player[playerid][pBope] == 2) { cargotext = "Cabo"; }
		if(Player[playerid][pBope] == 1) { cargotext = "Aspira"; }
		Player[playerid][EmTrabalho] = true;
		SetPlayerColor(playerid, COR_BOPE);
		SetPlayerSkin(playerid, 285);
		format(string, sizeof(string), "** O %s da BOPE %s foi para o batalhão.", cargotext, Nome(playerid));
		SendClientMessageToAll(COR_NEGATIVO, string);
	}
 	if(Player[playerid][pChoque] >= 1)
	{
		if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), 2610.2437,1846.6748,10.8203);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), 181.7650);
		}
		else
		{
			SetPlayerPos(playerid, 2622.1729,1869.6318,10.8203);
			SetPlayerFacingAngle(playerid, 269.1624);
		}
	  	new cargotext2[30];
	  	if(Player[playerid][pChoque] == 5) { cargotext2 = "Coronel"; }
		if(Player[playerid][pChoque] == 4) { cargotext2 = "Tenente"; }
		if(Player[playerid][pChoque] == 3) { cargotext2 = "Sargento"; }
		if(Player[playerid][pChoque] == 2) { cargotext2 = "Cabo"; }
		if(Player[playerid][pChoque] == 1) { cargotext2 = "Soldado"; }
		Player[playerid][EmTrabalho] = true;
		SetPlayerColor(playerid, COR_CHOQUE);
		SetPlayerSkin(playerid, 286);
		format(string, sizeof(string), "** O %s do CHOQUE %s foi para o batalhão.", cargotext2, Nome(playerid));
		SendClientMessageToAll(COR_NEGATIVO, string);
	}
	return 1;
}


// ======================= [ Comandos VIP Bronze ] ============================= //
CMD:comandosvip(playerid)
{
	//if(!VerificarNivelVip(playerid, 1)) return 1;
	new String[800];
	strcat(String, "{FFFFFF}.: COMANDOS VIP {8B5A2B}BRONZE{FFFFFF} :.\n\n");
	strcat(String, "{8B5A2B} /v {FFFFFF}- Falar no chat VIP\n");
	strcat(String, "{8B5A2B} /venc {FFFFFF}- Ver vencimento do seu VIP\n");
	strcat(String, "{8B5A2B} /jetpack {FFFFFF}- Criar um jetpack\n");
	strcat(String, "{8B5A2B} /veh {FFFFFF}- Criar carro VIP\n\n");
	strcat(String, "{FFFFFF}.: COMANDOS VIP {9C9C9C}PRATA{FFFFFF} :.\n\n");
	strcat(String, "{9C9C9C} /kitvip {FFFFFF}- Pegar KIT-VIP\n\n");
	strcat(String, "{FFFFFF}.: COMANDOS VIP {EEC900}OURO{FFFFFF} :.\n\n");
	strcat(String, "{EEC900} /efeitos {FFFFFF}- Abre um menu de efeitos VIP\n");
	strcat(String, "{EEC900} /brinquedos {FFFFFF}- Abre um menu de brinquedos VIP\n");
	ShowPlayerDialog(playerid, DIALOG_COMANDOS_VIP, DIALOG_STYLE_MSGBOX, "{FF0000}>> {FFFFFF}GTB - Comandos VIP {FF0000}<<", String, "Fechar", #);
	return 1;
}

CMD:venc(playerid)
{
	if(!VerificarNivelVip(playerid, 1)) return 1;
	new String[256], Str[128];
	format(Str, sizeof(Str), "{ffffff}NICK: {008B00}%s{FFFFFF} [{008B00}%d{FFFFFF}]   -   ", Nome(playerid), playerid);
	strcat(String, Str);
	format(Str, sizeof(Str), "{ffffff}VENCIMENTO EM: {008B00}%d {FFFFFF}DIAS\n\n", Player[playerid][DiasVip]);
	strcat(String, Str);
	ShowPlayerDialog(playerid, DIALOG_VENC_VIP, DIALOG_STYLE_MSGBOX, "{EEC900}GTB - Vencimento VIP ", String, "Fechar", #);
	return 1;
}

CMD:v(playerid, params[])
{
    if(!VerificarNivelVip(playerid, 1)) return 1;
	new texto[100], String[128];
	if(sscanf(params, "s", texto)) return SendClientMessage(playerid, COR_USOCORRETO, "Use: /cv [texto]");
	if(strval(texto) > 100) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Texto muito grande, diminua por favor!");
	format(String, sizeof(String), "%s {FFFF00}.:CHAT-VIP:.{FFFFFF} %s", Nome(playerid), texto);
	ChatVIP(String);
	return 1;
}
// ====================== [ Comandos VIP PRATA ] =============================== //
CMD:blindar(playerid)
{
	if(Player[playerid][Vip] >= 2)
	{
		if(GetPlayerMoney(playerid) >= 900)
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
				SetVehicleHealth(GetPlayerVehicleID(playerid), 99999999);
				GivePlayerMoney(playerid, -900);
				SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Você fez seu veiculo de um blindado!");
			}
			else
			{
				SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em um veículo para usar este comando.");
			}
		}
		else
		{
			SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não tem dinheiro suficiente para usar este comando!");
		}
	}
	else
	{
		SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você não é um membro vip para usar este este comando!");
	}
	return 1;
}

CMD:tunar(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(Player[playerid][Vip] < 2)return SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não é um membro vip.");
        ShowPlayerDialog(playerid, DIALOG_TUNAR, DIALOG_STYLE_LIST, "Escolha", "Pintar\nRodas\nSuspencao Hidraulica\nNitro\nBlindar", "Selecionar", "Cancelar");
	}
	else
	{
		SendClientMessage(playerid,COR_ERRO,"[ERRO]: Você não está em um veículo para usar este comando.");
	}
	return 1;
}

CMD:jetpack(playerid)
{
	if(Player[playerid][TempoPreso] >= 1) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você está preso.");
	if(Player[playerid][pAdmin] >= 1 || Player[playerid][Vip] >= 1)
	{
		SetPlayerSpecialAction(playerid, 2);
		new string[70];
		format(string, sizeof(string), "[ ! ] - {ffffff}%s {C798FA}criou um jetpack.", Nome(playerid));
		MensagemPerto(playerid, COR_ROXO, string, 50);
	}
	else
	{
 		SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não tem permissão para usar este comando.");
	}
	return 1;
}

CMD:kitvip(playerid)
{
	if(!VerificarNivelVip(playerid, 2)) return 1;
    if(Player[playerid][PegouKit] == true) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você já pegou seu Kit-Vip recentemente!");
    SendClientMessage(playerid, COR_VIP, "[INFO]: Você pegou seu Kit-Vip com sucesso!");
	GivePlayerWeapon(playerid,  4, 99999);
	GivePlayerWeapon(playerid, 24, 99999);
	GivePlayerWeapon(playerid, 26, 99999);
	GivePlayerWeapon(playerid, 31, 99999);
	GivePlayerWeapon(playerid, 32, 99999);
	GivePlayerWeapon(playerid, 34, 99999);
	Player[playerid][PegouKit] = true;
	return 1;
}
// =================== [ Comandos VIP OURO ] =================================== //
CMD:brinquedos(playerid)
{
	if(!VerificarNivelVip(playerid, 3)) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não pode utilizar esse comando em um veículo!");
    SendClientMessage(playerid, COR_VIP, "[INFO]: Lista de Brinquedos.");
	ShowToys(playerid);
    return 1;
}

CMD:tbrinquedos(playerid)
{
    if(!VerificarNivelVip(playerid, 3)) return 1;
    for(new i=0; i< MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
    }
    SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Brinquedos removidos com sucesso!");
    return 1;
}

CMD:efeitos(playerid)
{
	if(!VerificarNivelVip(playerid, 3)) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COR_ERRO, "[ERRO]: Você não pode utilizar esse comando em um veículo!");
    SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Lista de Efeitos.");
	ShowEfects(playerid);
    return 1;
}

CMD:tefeitos(playerid)
{
    if(!VerificarNivelVip(playerid, 3)) return 1;
    RemovePlayerAttachedObject(playerid, 1); // Remoçao dos Efeitos
    RemovePlayerAttachedObject(playerid, 2); // Remoçao dos Efeitos2
    SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Efeitos removidos com sucesso!");
    return 1;
}


CMD:vips(playerid)
{
	new ContVIP = 0, String[1000], Str[128];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && Player[i][Vip] > 0)
		{
			format(Str, sizeof(Str), "{ffffff}.:: VIP ON ::. {008B00}%s {FFFFFF}[{008B00}%i{FFFFFF}] [{008B00}%d Dias Restantes{ffffff}]\n", Nome(playerid), i, Player[i][DiasVip]);
			strcat(String, Str);
			ContVIP++;
		}
	}
	if(ContVIP == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_VIPS, DIALOG_STYLE_MSGBOX, "{FF0000}>> {FFFFFF}Vips Online {FF0000}<<", "{FF0000}Nenhum VIP online no momento!", "Fechar", #);
	} else {
	    ShowPlayerDialog(playerid, DIALOG_VIPS, DIALOG_STYLE_MSGBOX, "{FF0000}>> {FFFFFF}Vips Online {FF0000}<<", String, "Fechar", #);
	}
	return 1;
}
// ==================== [ Comandos Vip Rcon ] ================================== //
CMD:criarkey(playerid)
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não tem permissão.");
	ShowPlayerDialog(playerid, DIALOG_NEW_KEY, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}KEYS VIP", "\nDigite uma nova key válida\n{FFFF00}Apenas letras são aceitas:\n\n", "Criar", "Cancelar");
	return 1;
}

CMD:removerkey(playerid)
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não tem permissão.");
	ShowPlayerDialog(playerid, DIALOG_REMOVE_KEY, DIALOG_STYLE_INPUT, "{FF0000}¤ {FFFFFF}KEYS VIP", "\nDigite a Key que deseja Remover:\n\n", "Remover", "Cancelar");
	return 1;
}

CMD:darvip(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não tem permissão.");
	new Nivel, Dias, ID, string[126], text[40];
	if(sscanf(params, "udd", ID, Nivel, Dias)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /darvip [id] [nivel] [dias]");
    if(Nivel < 1 || Nivel > 3) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Nivel Inválido, 1 - Vip Bronze / 2 - Vip Prata / 3 - Vip Ouro.");
	if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Jogador não conectado.");
	if(Nivel == 1) { text = "VIP Bronze"; }
	if(Nivel == 2) { text = "VIP Prata"; }
	if(Nivel == 3) { text = "VIP Ouro"; }
	format(string, sizeof(string), "[INFO]: Você deu %d dias de Vip para %s - %s", Dias, Nome(ID), text);
    SendClientMessage(playerid, COR_PRINCIPAL, string);
	SetVip(ID, Nivel, Dias);
	return 1;
}

CMD:removervip(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_ERRO,"[ERRO]: Você não tem permissão.");
	new Motivo[100], Msg[128], ID;
	if(sscanf(params, "us", ID, Motivo)) return SendClientMessage(playerid, COR_USOCORRETO, "Uso correto: /removervip [id] [motivo]");
    if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Jogador não conectado.");
	format(Msg, sizeof Msg, "[INFO]: O admin %s retirou seu VIP. Motivo: %s.", Nome(playerid), Motivo);
	SendClientMessage(ID, COR_PRINCIPAL, Msg);
	format(Msg, sizeof Msg, "[INFO]: você retirou o VIP de %s Motivo: %s.", Nome(ID), Motivo);
	SendClientMessage(playerid, COR_PRINCIPAL, Msg);
	RemoveVip(ID);
	return 1;
}

// ======================= [ Stocks ] ========================================== //
MensagemPerto(playerid, cor, text[], distancia) {
	for(new i=0; i <= MAX_PLAYERS; i++)
	if(GetDistanceBetweenPlayers(playerid, i) <= distancia)
	{
		if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
		{
			new string[128];
			format(string, 128, text);
			SendClientMessage(i,cor,string);
		}
	}
	return 1;
}

GetDistanceBetweenPlayers(playerid,playerid2) {
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(tmpdis);
}

Nome(playerid) {
	new nome[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nome, sizeof(nome));
	return nome;
}

stock Carros(vehicleid)
{
	new result;
	new model = GetVehicleModel(vehicleid);
    switch(model)
    {
        case 415, 417, 420, 425, 427, 432, 433, 461, 470, 488, 490, 492, 497, 521, 523, 582, 548, 586, 596, 597, 598: result = model;
        default: result = 0;
    }
	return result;
}

stock isEmail(email[])
{
    if (!email[0]) return false;

    new
        len = strlen(email),
        arroba = 0,
        ponto = 0;

    for( ; arroba != len; arroba++) {
        if(!(email[arroba] - 64)) {
            for( ponto = arroba; ponto != len; ponto++) {
                if(!(email[ponto] - 46)) {
                    break;
                }
            }
            break;
        }
    }
    return (arroba + 1 < ponto < len && ponto && arroba);
}

stock Regras1(playerid)
{
	new dialogrande[800];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Objetivo do Jogo\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}GTB Torcidas é um servidor de SA-MP que tem como objetivo simular confrontos entre Torcidas\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Ao entrar no servidor, faça as missões primárias elas são muito importante para o seu bom desenvolvimento no server.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Level, XP e Dinheiro\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Você pode passar de level adquirindo XP!\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Para adquirir XP, basta você matar membros rivais de sua torcida e horários vagos no servidor irão destribuir 1 de XP.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Você pode usar seu dinheiro para comprar equipamentos.\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Para adquirir dinheiro, é muito fácil, basta matar membros rivais de sua torcida ou ganhar do servidor em horários vagos.\n\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Sua Torcida\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Você pode se comunicar com membros de sua Torcida usando '!' antes de digitar.\n\n");
	ShowPlayerDialog(playerid,DIALOG_REGRAS, DIALOG_STYLE_MSGBOX, "{FFFFFF}Explicação do Servidor {FF0000}1/7", dialogrande, "Próximo", "");
	return 1;
}
stock Regras2(playerid)
{
	new dialogrande[850];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Cargos da GTB Torcidas\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}Torcedor - {FFFFFF}É como você agora, um torcedor aprendiz, que está pegando experiência na Torcida para se tornar um braço!\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}Puxador - {FFFFFF}Este cargo é o primeiro cargo administrativo da hooligan, onde já ganha alguns comandos previlégiados para ajudar a Torcida.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}Organizador - {FFFFFF}O cargo de Organizador, tem como objetivo dá total suporte ao líder e liderar na ausência do mesmo.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}Presidente - {FFFFFF}É o cargo mandante da Torcida ou seja, responsável por qualquer atitude da Torcida.\n\n");
 	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Cargos Off-Game\n\n");
 	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Além dos cargos oficiais do jogo, existem cargos off-game, ou seja cargos criado pelos Presidentes fora do jogo, ou seja, rede sociais e etc..\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Lembrando que a Equipe não se responsabiliza a nem um tipo de atitudes inadequadas a cargos off-game.\n");
	ShowPlayerDialog(playerid,DIALOG_REGRAS2, DIALOG_STYLE_MSGBOX, "{FFFFFF}Cargos {FF0000}2/7", dialogrande, "Próximo", "Voltar");
	return 1;
}

stock Regras3(playerid)
{
	new dialogrande[700];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}EXTREMAMENTE PROIBIDO O USO DESSES TÓPICOS MAIS IMPORTANTES ABAIXO\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Não é permitido divulgações e propagandas que não seja relacionada a GTB Torcidas.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Não é permitido o uso de qualquer {FF0000}CHEAT/MOD/CLEO {FFFFFF}que tire vantagem de outro jogador.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Proibido o uso de bugs para ter benefícios próprios, ajude o servidor e reporte o BUG.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Proibido ANT Jogo - Exemplo: Apertar ESC em X1, Manter o veículo em cima de algum player, usar /q pra fuga.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Proibido Ofensas, Floods, palavras de origem ofensivas no chat público com intenção de ocasionar uma discussão.\n");
	ShowPlayerDialog(playerid,DIALOG_REGRAS3, DIALOG_STYLE_MSGBOX, "{FFFFFF}Regras Principais {FF0000}3/7", dialogrande, "Próximo", "Voltar");
	return 1;
}

stock Regras4(playerid)
{
	new dialogrande[215];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Página: {FF0000}www.facebook.com/gtboficial\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Grupo: {FF0000}www.facebook.com/groups/gtbtorcidasoficial\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Site: {FF0000}www.equipegtb.com\n\n");
	ShowPlayerDialog(playerid,DIALOG_REGRAS4, DIALOG_STYLE_MSGBOX, "{FFFFFF}Redes Sociais {FF0000}4/7", dialogrande, "Próximo", "Voltar");
	return 1;
}
stock Regras5(playerid)
{
	new dialogrande[490];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Qual é a função dos administradores ?\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Ajudar os novatos do servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Manter o servidor mais organizado para o melhor desempenho do game.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Punir os players que usam xiters ou mods proibido.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Como eu posso me tornar um administrador ?\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Sendo um player exemplar.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Seguindo todas as regras do servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Ajudando a organizar o servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Você comprando vip terá mais chances de se tornar um administrador.\n");
	ShowPlayerDialog(playerid,DIALOG_REGRAS5, DIALOG_STYLE_MSGBOX, "{FFFFFF}Administração {FF0000}5/7", dialogrande, "Próximo", "Voltar");
	return 1;
}
stock Regras6(playerid)
{
	new dialogrande[540];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Uma das melhores vantagens de ser um player vip é os comandos exclusivos.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Você sendo um player que dedica financeiramente ao server terá mais chances de ser um administrador.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Qualquer dúvida entre no servidor e Digite /Vantagensvip.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Qualquer tipo de pagamento é feito pelo nosso site oficial.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Nem um suporte em relação a vips que não venha da administração da GTB Torcidas é válido.\n");
	ShowPlayerDialog(playerid,DIALOG_REGRAS6, DIALOG_STYLE_MSGBOX, "{FFFFFF}Vantagens VIP {FF0000}6/7", dialogrande, "Próximo", "Voltar");
	return 1;
}

stock Regras7(playerid)
{
	new dialogrande[700];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Finalizando\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Ao completar o cadastro no nosso servidor e começar a jogar com a gente\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}você estará aceitando as regras contida neste tutorial automaticamente, ao violar as regras do nosso servidor\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}algum administrador do servidor poderá te levar a punição sem aviso prévio.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Agradecimento\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Obrigado por escolher a GTB Torcidas !\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Tenha um bom jogo.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Lembre-se humildade, lealdade, e perseverança sempre!\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Atenciosamente, Diretoria GTB Torcidas\n");
    ShowPlayerDialog(playerid, DIALOG_TORCIDA, DIALOG_STYLE_MSGBOX, "{FFFFFF}GTB Torcidas {ff0000}7/7", dialogrande, "Concluir", "");
	return 1;
}

stock AccountName(playerid) // aqui
{
	new accname[30];
	if(Player[playerid][pAdmin] == 1)
	{
		accname = "Administrador Tempórario";
	}
	else if(Player[playerid][pAdmin] == 2)
	{
		accname = "Administrador Ajudante";
	}
	else if(Player[playerid][pAdmin] == 3)
	{
		accname = "Administrador";
	}
	else if(Player[playerid][pAdmin] == 4)
	{
		accname = "Sub Game Master";
	}
	else if(Player[playerid][pAdmin] == 5)
	{
		accname = "Game Master";
	}
	return accname;
}

stock SendMessageToTorc(torc, cor, const str[])
{
	for(new i = 0; i <= HighestID; i ++)
	{
	    if(IsPlayerConnected(i) && Player[i][pTorcida] == torc && Player[i][ChatTorcida] == false)
	    {
	        SendClientMessage(i, cor, str);
	    }
	}
}

stock SendMessageToCops(color,const string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1)
		{
			if(Player[i][pBope] >= 1 || Player[i][pChoque] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

VerificarRival(id)
{
    for(new i=0; i <= MAX_PLAYERS; i++)
	if(GetDistanceBetweenPlayers(id, i) <= 20)
	{
	    if(Player[id][pTorcida] == Player[i][pTorcida])
	    {
	    }
	    else
	    {
	        return false;
	    }
	}
	return true;
}

stock CreatePickupsSedes()
{
	for(new i = 0; i < MAX_TORCIDAS; i ++)
 	{
		CreatePickup(1314, 1, Torcidas[i][Spawn][0], Torcidas[i][Spawn][1], Torcidas[i][Spawn][2], -1);
		new string[64];
		format(string, 64, "Sede %s\nPressione F", Torcidas[i][tNome]);
		Create3DTextLabel(string,0xE3E3E3FF, Torcidas[i][Spawn][0], Torcidas[i][Spawn][1], Torcidas[i][Spawn][2],25.0,0);
	}
}

stock ConnectedPlayers()
{
        new count;
        for(new x = 0; x < MAX_PLAYERS; x++)
		{
            if(IsPlayerConnected(x))
			{
                        count++;
   			}
        }
        return count;
}

stock Comandos(playerid)
{
	new dialogrande[2000];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}'!' - {FFFFFF}Manda uma mensagem no chat de sua torcida.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/info - {FFFFFF}Mostra suas informações.\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/reportar - {FFFFFF}Usado para reportar alguem que está fazendo algo errado no servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/animlist - {FFFFFF}Mostra todas as animações do servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/pagar - {FFFFFF}Para pagar um player.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/ajuda - {FFFFFF}Para tirar suas dúvidas sobre o servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/pular - {FFFFFF}Caso você bugar o /pular irá te auxiliar.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/mudartorcida - {FFFFFF}Para mudar de Torcida.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/apostar - {FFFFFF}Para apostar um pano de sua Torcida com outro player.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/pm - {FFFFFF}Para mandar uma mensagem privada.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/skin - {FFFFFF}Trocar sua skin.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/id - {FFFFFF}Para descobri o id de algum player.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/reparar - {FFFFFF}Para concertar seu veículo.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/toptorcidas - {FFFFFF}Ver as top 10 torcidas online.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/admins - {FFFFFF}Visualize os administradores online.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/duvida - {FFFFFF}Para relatar algo para administração.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/chamar - {FFFFFF}Chama um reporter/helper.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/fila - {FFFFFF}Ver a fila da chamada reporter/helper.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/sairfila - {FFFFFF}Sai da fila da chamada reporter/helper\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/mudarnick - {FFFFFF}Para mudar seu nick.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/virar - {FFFFFF}Para virar seu veículo.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/bopes - {FFFFFF}Para ver os Policiais do BOPE online no servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/choques - {FFFFFF}Para ver os Policiais do CHOQUE online no servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/helpers - {FFFFFF}Para ver os Helpers online no servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/reporteres - {FFFFFF}Para ver os Repórteres online no servidor.\n");
	ShowPlayerDialog(playerid,661, DIALOG_STYLE_MSGBOX, "{FF0000}¤ {FFFFFF}GTB Torcidas - Comandos", dialogrande, "OK", "");
}

stock ComandosRcon(playerid)
{
	new dialogrande[999];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Comandos RCON\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/darcash - {FFFFFF}Para dar cash para um player.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/darcasht - {FFFFFF}Para dar cash para todos os players do servidor.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/setadmin - {FFFFFF}Seta um player de administrador\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/criarkey - {FFFFFF}Cria uma key para Vip\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/removerkey - {FFFFFF}Remove uma key Vip\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}/editarinfo - {FFFFFF}Para editar as informações de algum player\n\n");
	ShowPlayerDialog(playerid,621, DIALOG_STYLE_MSGBOX, "{FFFFFF}Comandos RCON - {FF0000}GTB ", dialogrande, "OK", "");
}

stock ComandosBOPE(playerid)
{
	new dialogrande[550];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{363636}[Level 1]: {FFFFFF}/apbope - /apbope2 - /m - /revistar - /dp - /algemar - /desalgemar - /d - /su - /jogar - /procurados\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{363636}[Continuação Level 1]: {FFFFFF}/rdrogas - /escudo - /cone - /rcone - /localizar\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{363636}[Level 2]: {FFFFFF}/br - /rbr - /laseron - /laseroff - /lasercor\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{363636}[Level 3]: {FFFFFF}/rc - /pregos - /dpregos - /ir- /trazer\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{363636}[Level 4]: {FFFFFF}/gov - /veh - /kick - /rtcone - /rtcdp - /vidat - /coletet - /coletetvidat - /cnn\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{363636}[Level 5]: {FFFFFF}/sebope - /rtbr - /trazerbtl\n");
	ShowPlayerDialog(playerid, 100+100, DIALOG_STYLE_MSGBOX, "{FF0000}» {FFFFFF}GTB Torcidas - Comandos BOPE {FF0000}«", dialogrande, "OK", "");
	return 1;
}

stock Ajuda(playerid)
{
	new dialogrande[888];
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ff0000}GTB Torcidas{ffffff} é um servidor de SA-MP que tem como objetivo simular a vida das torcidas brasileiras.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ffffff}Aqui, você tem sua própria conta e pode interagir com membros de sua torcida e de outras torcidas.\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ffffff}utilizando '!' (ponto de exclamação sem aspas) sua mensagem é direcionada para o chat de sua torcida\n");
    format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ffffff}dos textos, suas mensagens serão direcionadas para o chat exclusivo de sua torcida.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ff0000}• {ffffff}Administradores\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Os administradores são os moderadores do servidor, eles tem o dever de manter a ordém.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Qualquer problema, se reporte a um.\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}Para ver os administradores on-line, digite /admins.\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ff0000}• {ffffff}Presidentes\n\n");
	format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{ffffff}É o cargo mandante da Torcida ou seja, responsável por qualquer atitude da Torcida.");
	ShowPlayerDialog(playerid,999, DIALOG_STYLE_MSGBOX, "{FF0000}GTB Torcidas - {FFFFFF}Explicação do Servidor", dialogrande, "Concluido", "Voltar");
	return 1;
}

stock ComandosAdmin(playerid)
{
	new dialogrande[700];
	if(Player[playerid][pAdmin]>=1)
	{
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Level 1\n");
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}/a - /asay - /vida - /colete - /tapa - /ir - /trazer - /rc - /prender - /pinfo - /jetpack - /veh - /at - /respawn - /cityadmin\n");
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"/slap - /reports - /dcm - /kick - /cnn - /coletet - /coletetvidat - /vidat - /dc - /tempban - /olhar\n\n");
	}
	if(Player[playerid][pAdmin]>=2)
	{
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Level 2\n");
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}/supertapa - /congelar - /desarmar - /grade - /rgrade\n\n");
	}
 	if(Player[playerid][pAdmin]>=3)
	{
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Level 3\n");
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}/criar - /armas\n\n");
	}
  	if(Player[playerid][pAdmin]>=4)
	{
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Level 4\n");
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}/setbope - /setchq - /setreporter -  /sethelper - /desban - /dt - /lerpm\n\n");
	}
  	if(Player[playerid][pAdmin]>=5)
	{
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FF0000}• Level 5\n");
		format(dialogrande, sizeof(dialogrande),"%s%s",dialogrande,"{FFFFFF}/clima - /tempo - /rtc - /dtc\n\n");
	}
	ShowPlayerDialog(playerid,666, DIALOG_STYLE_MSGBOX, "{FFFFFF}Comandos Administrador - {FF0000}GTB", dialogrande, "OK", "");
}

stock MostrarMochila(id, id2, tipo, dialog)
{
	new string[512], title[128];
	if(dialog == 1)
	{
		if(Player[id2][pMaconha] > 0)
		   	format(string, 512, "{ffffff}Maconha {fff200}[Quantidade: %d]\n", Player[id2][pMaconha]);
			else format(string, 512, "{ffffff}Slot 1 -- VAZIO\n");

		if(Player[id2][pCocaina] > 0)
 			format(string, 512, "%s{ffffff}Cocaina {fff200}[Quantidade: %d]\n", string, Player[id2][pCocaina]);
	    	else format(string, 512, "%s{ffffff}Slot 2 -- VAZIO\n", string);


	    if(Player[id2][pSinalizadores] > 0)
	    	format(string, 512, "%s{ffffff}Sinalizador {fff200}[Quantidade: %d]\n", string, Player[id2][pSinalizadores]);
	    	else format(string, 512, "%s{ffffff}Slot 3 -- VAZIO\n", string);

	    if(Player[id2][pFogos] > 0)
	    	format(string, 512, "%s{ffffff}Fogos de Artifício {fff200}[Quantidade: %d]\n", string, Player[id2][pFogos]);
	    	else format(string, 512, "%s{ffffff}Slot 4 -- VAZIO\n", string);

	    if(Player[id2][pMP3] > 0)
	    	format(string, 512, "%s{ffffff}MP3 {fff200}[Quantidade: %d]\n", string, Player[id2][pMP3]);
	    	else format(string, 512, "%s{ffffff}Slot 5 -- VAZIO\n", string);

	    if(Player[id2][pMateriais] > 0)
	    	format(string, 512, "%s{ffffff}Materiais {fff200}[Quantidade: %d]\n", string, Player[id2][pMateriais]);
	    	else format(string, 512, "%s{ffffff}Slot 6 -- VAZIO\n", string);

		format(title, 128, "Mochila de %s", Nome(id2));
		if(tipo == 1) ShowPlayerDialog(id, DIALOG_MOCHILA, DIALOG_STYLE_LIST, title, string, "Usar", "Cancelar");
		else if(tipo == 2) ShowPlayerDialog(id, DIALOG_MOCHILA+1, DIALOG_STYLE_LIST, title, string, "--", "Cancelar");
	}
	else
	{
		format(string, sizeof(string),"|__________ Mochila de %s __________|", Nome(id2));
		SendClientMessage(id, COR_ERRO, string);
	    if(Player[id2][pMaconha] > 0)
   		format(string, 512, "{ffffff}Maconha {ABABAB}[Quantidade: %d]", Player[id2][pMaconha]);
		else format(string, 512, "{ffffff}Slot 1 -- VAZIO");
		SendClientMessage(id, 0xE3E3E3FF, string);

		if(Player[id2][pCocaina] > 0)
 		format(string, 512, "{ffffff}Cocaina {ABABAB}[Quantidade: %d]", Player[id2][pCocaina]);
 		else format(string, 512, "{ffffff}Slot 2 -- VAZIO");
 		SendClientMessage(id, 0xE3E3E3FF, string);
		
	    if(Player[id2][pSinalizadores] > 0)
    	format(string, 512, "{ffffff}Sinalizador {ABABAB}[Quantidade: %d]", Player[id2][pSinalizadores]);
    	else format(string, 512, "{ffffff}Slot 3 -- VAZIO");
    	SendClientMessage(id, 0xE3E3E3FF, string);

	    if(Player[id2][pFogos] > 0)
    	format(string, 512, "{ffffff}Fogos de Artifício {ABABAB}[Quantidade: %d]", Player[id2][pFogos]);
    	else format(string, 512, "{ffffff}Slot 4 -- VAZIO");
    	SendClientMessage(id, 0xE3E3E3FF, string);

	    if(Player[id2][pMP3] > 0)
    	format(string, 512, "{ffffff}MP3 {ABABAB}[Quantidade: %d]", Player[id2][pMP3]);
    	else format(string, 512, "{ffffff}Slot 5 -- VAZIO");
		SendClientMessage(id, 0xE3E3E3FF, string);

	    if(Player[id2][pMateriais] > 0)
    	format(string, 512, "{ffffff}Materiais {ABABAB}[Quantidade: %d]", Player[id2][pMateriais]);
    	else format(string, 512, "{ffffff}Slot 6 -- VAZIO");
    	SendClientMessage(id, 0xE3E3E3FF, string);
	}
}

stock ResetarCarros(playerid)
{
	new string[128];
	GetPlayerName(playerid, string, MAX_PLAYER_NAME+1);
	format(string, sizeof(string), "AdmCMD: O Administrador '%s' respawnou todos os veiculos!", string);
	SendClientMessageToAll(0xFFFFFFFF, string);
	new bool:inVeh;
	for( new i = 0; i < MAX_VEHICLES; i++ )
	{
		inVeh = false;
		for( new j = 0; j < MAX_PLAYERS; j++ )
		{
			if(IsPlayerInVehicle( j, i ))
			{
				inVeh = true;
			}
		}
		if(!inVeh) SetVehicleToRespawn(i);
	}
	return true;
}

stock strtok(const string[], &index)
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

stock GetPlayerCity(playerid)
{
	new Float:playerX, Float:playerY, Float:playerZ;
	GetPlayerPos(playerid, playerX, playerY, playerZ);
	if(playerX >= -2997.40 && playerY >= -1115.50 && playerX <= -1213.90 && playerY <= 1659.60) return CIDADESF;
	else if(playerX >= 44.60 && playerY >= -2892.90 && playerX <= 2997.00 && playerY <= -768.00) return CIDADELS;
	else if(playerX >= 869.40 && playerY >= 596.30 && playerX <= 2997.00 && playerY <= 2993.80) return CIDADELV;
	return 3;
}

stock StartSpectate(playerid, specid)
{
	for(new x = 0; x < MAX_PLAYERS; x++)
	{
		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Player[x][gSpectateID] == playerid)
		{
			AdvanceSpectate(x);
		}
	}
	if(IsPlayerInAnyVehicle(specid))
	{
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specid));
		Player[playerid][gSpectateID] = specid;
		Player[playerid][gSpectateType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else
	{
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, specid);
		Player[playerid][gSpectateID] = specid;
		Player[playerid][gSpectateType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(specid));
    new string[128];
	for(new i = 0; i <= HighestID; i ++)
	{
		if(IsPlayerConnected(i) && Player[i][LastReport] == specid)
		{
		    format(string, sizeof(string),"Recebido do %s %s: Seu último report está sendo verificado por min.", AccountName(playerid), Nome(playerid));
		    SendClientMessage(i, COR_AMARELO, string);
		    Player[i][LastReport] = INVALID_PLAYER_ID;
		    Player[playerid][pRpt]++;
		}
	}
	format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%s - ID:%d~n~~y~~h~< Shift ~w~-~r~~h~ Space >", Nome(specid),specid);
	GameTextForPlayer(playerid,string,10000,3);
	return 1;
}
stock StopSpectate(playerid)
{
    SpawnPlayer(playerid);
	Player[playerid][ReloadPlayer] = true;
	TogglePlayerSpectating(playerid, 0);
	Player[playerid][gSpectateID] = INVALID_PLAYER_ID;
	Player[playerid][gSpectateType] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~r~Spectate Desligado",1000,3);
	return 1;
}
stock AdvanceSpectate(playerid)
{
	if(ConnectedPlayers() == 2)
	{
		StopSpectate(playerid); return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Player[playerid][gSpectateID] != INVALID_PLAYER_ID)
	{
		for(new x=Player[playerid][gSpectateID]+1; x<=MAX_PLAYERS; x++)
		{
			if(x == MAX_PLAYERS)
			{
				x = 0;
			}
			if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Player[x][gSpectateID] != INVALID_PLAYER_ID ||
				(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}
stock ReverseSpectate(playerid)
{
	if(ConnectedPlayers() == 2)
	{
		StopSpectate(playerid); return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Player[playerid][gSpectateID] != INVALID_PLAYER_ID)
	{
		for(new x=Player[playerid][gSpectateID]-1; x>=0; x--)
		{
			if(x == 0)
			{
				x = MAX_PLAYERS;
			}
			if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Player[x][gSpectateID] != INVALID_PLAYER_ID ||
				(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReturnPlayerID(PlayerName[])
{
	new found=0, id;
	for(new i=0; i <= MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			new foundname[MAX_PLAYER_NAME+1];
			GetPlayerName(i, foundname, MAX_PLAYER_NAME+1);
			new namelen = strlen(foundname);
			new bool:searched=false;
			for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(foundname,PlayerName,true) == pos)
					{
						found++;
						id = i;
					}
				}
			}
		}
	}
	if(found == 1) return id;
	else
	return INVALID_PLAYER_ID;
}
// ======================== [ Public ] ========================================= //
forward Kicka(p);
public Kicka(p)
{
    #undef Kick
    Kick(p);
    #define Kick(%0) SetTimerEx("Kicka", 100, false, "i", %0)
    return 1;
}

forward ProcurarUsuario(playerid);
public ProcurarUsuario(playerid)
{
    // Declaramos as variáveis para obter os resultados da consulta realizado anteriormente na OnPlayerConnect
    new linhas, colunas;

    // Obtemos o número de linhas e colunas resultantes da consulta
    cache_get_data(linhas, colunas, conectDB);

    // Caso não haja nenhuma linha, o jogador não está registrado, logo, vamos exibir o dialog de registro.
    if(!linhas)
    {
        new string1[250],string[250];
		format(string, -1, "{FFFFFF}Olá, bem vindo a {FF0000}GTB Torcidas\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}INFORMAÇÕES DA SUA CONTA ABAIXO:\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Nick: {FF0000}%s\n", Nome(playerid));
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Status: {FF0000}Não registrada\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Escolha sua senha:\n");
		strcat(string1,string);
        ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "{FF0000}¤ {FFFFFF}Registro 1/3", string1, "Avançar", "");
    }
    else
    {
        new string1[140],string[140];
		format(string, sizeof(string), "{FF0000}ATENÇÃO: {FFFFFF}O nick: {FF0000}%s {FFFFFF}já está em uso,\n", Nome(playerid));
		strcat(string1,string);
		format(string, sizeof(string), "{FFFFFF}mude o nick no SA-MP e logue novamente.\n", Nome(playerid));
		strcat(string1,string);
		ShowPlayerDialog(playerid, DIALOG_NICK_EM_USO, DIALOG_STYLE_MSGBOX, "{FF0000}¤ {FFFFFF}Registro - Nick indisponível", string1, "Voltar", "");
    }
    return 1;
}
forward ProcurarUsuario2(playerid);
public ProcurarUsuario2(playerid)
{
    // Declaramos as variáveis para obter os resultados da consulta realizado anteriormente na OnPlayerConnect
    new linhas, colunas;

    // Obtemos o número de linhas e colunas resultantes da consulta
    cache_get_data(linhas, colunas, conectDB);

    // Caso não haja nenhuma linha, o jogador não está registrado, logo, vamos exibir o dialog de registro.
    if(!linhas)
    {
        new string1[250],string[250];
		format(string, sizeof(string), "{FF0000}ATENÇÃO: {FFFFFF}O nick: {FF0000}%s {FFFFFF}não está registrado,\n", Nome(playerid));
		strcat(string1,string);
		format(string, sizeof(string), "{FFFFFF}registre-se e logue novamente.\n", Nome(playerid));
		strcat(string1,string);
		ShowPlayerDialog(playerid, DIALOG_NICK_EM_USO, DIALOG_STYLE_MSGBOX, "{FF0000}¤ {FFFFFF}Registro - Nick não registrado", string1, "Voltar", "");
    }
    else
    {
        new string1[215],string[215];
		format(string, -1, "{FFFFFF}Olá, bem vindo a {FF0000}GTB Torcidas\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}INFORMAÇÕES DA SUA CONTA ABAIXO:\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Nick: {7CFC00}%s\n", Nome(playerid));
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Status: {7CFC00}Registrada\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Digite sua senha:\n");
		strcat(string1,string);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}¤ {FFFFFF}Login 3/3", string1, "Logar", "Cancelar");
    }
    return 1;
}

forward FazerLogin(playerid);
public FazerLogin(playerid)
{
    // Declarando as variáveis para a obtenção de linhas e campos da consulta
    new linhas, colunas;
    // Obtendo os dados
    cache_get_data(linhas, colunas, conectDB);
    // Caso não hajam resultados
    if(!linhas)
    {
        // Senha incorreta
        if(tentativaDeLogin[playerid] == 2)
        {
            SendClientMessage(playerid, COR_ERRO, "[KICKADO] Você errou a senha 3 vezes e foi kickado.");
            Kick(playerid);
		}
        SendClientMessage(playerid, COR_ERRO, "[ERRO]: Senha incorreta!");
        tentativaDeLogin[playerid]++;
        new string1[250],string[250];
		format(string, -1, "{FFFFFF}Olá, bem vindo a {FFD700}GTB Torcidas\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}INFORMAÇÕES DA SUA CONTA ABAIXO:\n\n");
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Nick: {7CFC00}%s\n", Nome(playerid));
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Status: {7CFC00}Registrada\n\n");
		strcat(string1,string);
		format(string, -1, "{FF0000}* Senha incorreta, tentativa: %d/3.\n\n", tentativaDeLogin[playerid]);
		strcat(string1,string);
		format(string, -1, "{FFFFFF}Digite sua senha:\n");
		strcat(string1,string);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}¤ {FFFFFF}Login", string1, "Logar", "Cancelar");
    }
    else // Resultados encontrados, senha correta!
    {
		if(Player[playerid][pIniciante] == 1)
		{
			Regras1(playerid);
			return Regras1(playerid);
		}
		else if(Logado[playerid] == false)
		{
		    new query[256];
  			mysql_format(conectDB, query, sizeof(query), "SELECT * FROM `pinfo` WHERE `Nick` = '%s' LIMIT 1", Nome(playerid));
            mysql_tquery(conectDB, query, "IniciarConta", "i", playerid);
        }
    }
    return 1;
}


stock SalvarPlayer(playerid)
{
   	getdate(AnoL[playerid], MesL[playerid], DiaL[playerid]);
    gettime(HoraL[playerid], MinutoL[playerid]);
    Player[playerid][pSkin] = GetPlayerSkin(playerid); 
	new QueryVIP[80];
	mysql_format(Connection, QueryVIP, sizeof(QueryVIP), "UPDATE `Vips` SET `Dias`=%d, `Nivel`=%d, `TempoVip`=%d WHERE `Nick`='%e'", Player[playerid][DiasVip], Player[playerid][Vip], Player[playerid][TempoVip], Nome(playerid));
 	mysql_tquery(Connection, QueryVIP, "","");

    new Query[1200], Query2[1200]; //Cria as variaveis necessarias..
    mysql_format(conectDB, Query, sizeof(Query), "UPDATE `pinfo` SET `iniciante` ='%d', `minutol`='%d',`horal`='%d',`dial`='%d',`mesl`='%d',`anol`='%d', `nometorcida`= '%s', `torcida`= '%d', `skin` = '%d', `score`='%d', `cash`='%d', `dinheiro` = '%d',`admin` ='%d', `pres` = '%d', `vpres` = '%d', `org` = '%d', `pux` = '%d', `bope` = '%d', `choque` = '%d', `matou` = '%d', `morreu` = '%d', `procurado`='%d', `estrelaprocurado`='%d' WHERE `Nick` = '%s'",
	Player[playerid][pIniciante],
	MinutoL[playerid],
	HoraL[playerid],
	DiaL[playerid],
	MesL[playerid],
	AnoL[playerid],
	Torcidas[Player[playerid][pTorcida]][tNome],
	Player[playerid][pTorcida],
	Player[playerid][pSkin],
	GetPlayerScore(playerid),
	Player[playerid][Cash],
	GetPlayerMoney(playerid),
	Player[playerid][pAdmin],
	Player[playerid][pPres],
	Player[playerid][pvPres],
	Player[playerid][pOrg],
	Player[playerid][pPux],
	Player[playerid][pBope],
	Player[playerid][pChoque],
	Player[playerid][pMatou],
	Player[playerid][pMorreu],
	Player[playerid][Procurado],
	GetPlayerWantedLevel(playerid),
	Nome(playerid));
	mysql_tquery(conectDB, Query,"DadosSalvos","d", playerid);
	
	mysql_format(conectDB, Query2, sizeof(Query2), "UPDATE `pinfo` SET `suabatidos`='%d', `sutotal`='%d', `passagens`='%d', `reportslidos`='%d', `fumo`='%d', `cheiro`='%d', `tempopreso`='%d' WHERE `Nick`='%s'",
	Player[playerid][suabatidos],
	Player[playerid][sutotal],
	Player[playerid][Passagens],
	Player[playerid][pRpt],
	Player[playerid][pMaconha],
	Player[playerid][pCocaina],
	Player[playerid][TempoPreso],
	Nome(playerid));
	mysql_tquery(conectDB, Query2,"DadosSalvos","d", playerid);
}

forward DadosSalvos(playerid);
public DadosSalvos(playerid)
{
        return 1;
}

forward LoadVips(playerid);
public LoadVips(playerid)
{
    if(cache_get_row_count(Connection) == 1)
	{
	    Player[playerid][Vip] = cache_get_field_content_int(0, "Nivel");
	    Player[playerid][DiasVip] = cache_get_field_content_int(0, "Dias");
	    Player[playerid][TempoVip] = cache_get_field_content_int(0, "TempoVip");
	} else {
		Player[playerid][Vip] = 0;
		Player[playerid][DiasVip] = 0;
		Player[playerid][TempoVip] = 0;
	}
	CarregarDados(playerid);
	return 1;
}

forward IniciarConta(playerid);
public IniciarConta(playerid)
{
    MinutoL[playerid] = cache_get_field_content_int(0, "minutol");
    HoraL[playerid] = cache_get_field_content_int(0, "horal");
    DiaL[playerid] = cache_get_field_content_int(0, "dial");
    MesL[playerid] = cache_get_field_content_int(0, "mesl");
    AnoL[playerid] = cache_get_field_content_int(0, "anol");
    Player[playerid][pTorcida] = cache_get_field_content_int(0, "torcida");
    Player[playerid][pSkin] = cache_get_field_content_int(0, "skin");
    Player[playerid][Score] = cache_get_field_content_int(0, "score");
    Player[playerid][Cash] = cache_get_field_content_int(0, "cash");
    Player[playerid][Dinheiro] = cache_get_field_content_int(0, "dinheiro");
    Player[playerid][pMatou] = cache_get_field_content_int(0, "matou");
    Player[playerid][pMorreu] = cache_get_field_content_int(0, "morreu");
    Player[playerid][pAdmin] = cache_get_field_content_int(0, "admin");
    Player[playerid][pPres] = cache_get_field_content_int(0, "pres");
    Player[playerid][pvPres] = cache_get_field_content_int(0, "vpres");
    Player[playerid][pOrg] = cache_get_field_content_int(0, "org");
    Player[playerid][pPux] = cache_get_field_content_int(0, "pux");
    Player[playerid][pBope] = cache_get_field_content_int(0, "bope");
    Player[playerid][pChoque] = cache_get_field_content_int(0, "choque");
    Player[playerid][Procurado] = cache_get_field_content_int(0, "procurado");
    Player[playerid][TempoPreso] = cache_get_field_content_int(0, "tempopreso");
    Player[playerid][sutotal] = cache_get_field_content_int(0, "sutotal");
    Player[playerid][pRpt] = cache_get_field_content_int(0, "reportslidos");
    Player[playerid][suabatidos] = cache_get_field_content_int(0, "suabatidos");
    Player[playerid][Wanted] = cache_get_field_content_int(0, "estrelaprocurado");
    Player[playerid][Passagens] = cache_get_field_content_int(0, "passagens");
    Player[playerid][pMaconha] = cache_get_field_content_int(0, "fumo");
    Player[playerid][pCocaina] = cache_get_field_content_int(0, "cheiro");
	new Query[70];
 	mysql_format(Connection, Query, sizeof(Query), "SELECT * FROM `Vips` WHERE `Nick`='%e'", Nome(playerid));
	mysql_tquery(Connection, Query, "LoadVips", "d", playerid);
	return 1;
}

stock CarregarDados(playerid)
{
	new string[400];
	for(new i=0; i < 30; i++)
	{
	    SendClientMessage(playerid, COR_BRANCO,""); /* Equivale a 10 SendClientMessage VÁZIOS */
	}
    new str[400];
    format(str, sizeof(str),"{FFD700}** Seja bem vindo novamente{ffffff} %s | {FFD700}Último login: {ffffff}'%d/%d/%d' Ás %d Horas e %d Minutos.", Nome(playerid),DiaL[playerid], MesL[playerid], AnoL[playerid], HoraL[playerid], MinutoL[playerid]);
    SendClientMessage(playerid, -1, str);
    SendClientMessage(playerid, -1,">> ------------------------------------------------------------------------------------------------ <<");
	if(Player[playerid][pAdmin] >= 1) {
		format(string, sizeof(string),"- Você é Administrador level %d.", Player[playerid][pAdmin]);
		SendClientMessage(playerid, COR_BRANCO, string);
	}
	if(Player[playerid][pPres] == 1) {
		format(string, sizeof(string),"- Você é Presidente da Torcida %s.", Torcidas[Player[playerid][pTorcida]][tNome]);
		SendClientMessage(playerid, COR_BRANCO, string);
	}
	if(Player[playerid][pOrg] == 1) {
		format(string, sizeof(string),"- Você é Organizador da Torcida %s.", Torcidas[Player[playerid][pTorcida]][tNome]);
		SendClientMessage(playerid, COR_BRANCO, string);
	}
	if(Player[playerid][pPux] == 1) {
		format(string, sizeof(string),"- Você é Puxador da Torcida %s.", Torcidas[Player[playerid][pTorcida]][tNome]);
		SendClientMessage(playerid, COR_BRANCO, string);
	}
	if(Player[playerid][pBope] >= 1) {
		format(string, sizeof(string),"- Você é um Soldado do BOPE Level %d.", Player[playerid][pBope]);
		SendClientMessage(playerid, COR_BRANCO, string);
	}

	if(Player[playerid][Vip] == 1)
	{
		format(string, sizeof(string),"- Você é um membro {8B5A2B}VIP Bronze{ffffff} [%d] Dias Restantes.", Player[playerid][DiasVip]);
		SendClientMessage(playerid, -1, string);
	}
	if(Player[playerid][Vip] == 2)
	{
		format(string, sizeof(string),"- Você é um membro {9C9C9C}VIP Prata{ffffff} [%d] Dias Restantes.", Player[playerid][DiasVip]);
		SendClientMessage(playerid, -1, string);
	}
	if(Player[playerid][Vip] == 3)
	{
		format(string, sizeof(string),"- Você é um membro {EEC900}VIP Ouro{ffffff} [%d] Dias Restantes.", Player[playerid][DiasVip]);
		SendClientMessage(playerid, -1, string);
	}
	
	if(Player[playerid][Vip] <= 0) { SendClientMessage(playerid, -1, "- Você é um membro free."); }
    SendClientMessage(playerid, -1,">> ------------------------------------------------------------------------------------------------ <<");

    TogglePlayerSpectating(playerid, false);
    TogglePlayerControllable(playerid, 1);
    Logado[playerid] = true;
    SpawnPlayer(playerid);
    SetPlayerSkin(playerid, Player[playerid][pSkin]);
    return 1;
}

SetVip(playerid, Nivel, Dias)
{
	new stringV[90], Query[110], text[40];
	if(Nivel == 1) { text = "VIP Bronze"; }
	if(Nivel == 2) { text = "VIP Prata"; }
	if(Nivel == 3) { text = "VIP Ouro"; }
	if(Player[playerid][Vip] > 0)
	{
		format(stringV, sizeof stringV, "[INFO]: Seu VIP foi renovado. + %d dias. Nivel: %d - %s.", Dias, Nivel, text);
		Player[playerid][TempoVip] += Dias;
		Player[playerid][DiasVip] += Dias;
		Player[playerid][Vip] = Nivel;

   		mysql_format(Connection, Query, sizeof(Query), "UPDATE `Vips` SET `Dias`=%d, `Nivel`=%d, `TempoVip`=%d WHERE `Nick`='%e'", Player[playerid][DiasVip], Player[playerid][Vip], Player[playerid][TempoVip], Nome(playerid));
        mysql_tquery(Connection, Query, "", "");

	} else {

		format(stringV, sizeof stringV, "[INFO]: Seu VIP foi ativado. %d dias. Nivel: %d - %s. /comandosvip", Dias, Nivel, text);
		Player[playerid][TempoVip] = Dias;
		Player[playerid][DiasVip] = Dias;
		Player[playerid][Vip] = Nivel;

		mysql_format(Connection, Query, sizeof(Query), "INSERT INTO `Vips`(`Nick`, `Dias`, `Nivel`, `TempoVip`) VALUES ('%e', %d, %d, %d)", Nome(playerid), Player[playerid][DiasVip], Player[playerid][Vip], Player[playerid][TempoVip]);
		mysql_tquery(Connection, Query, "", "");

	}
	SendClientMessage(playerid, COR_PRINCIPAL, stringV);
	return 1;
}

RemoveVip(playerid)
{
	new query[70];
    mysql_format(Connection, query, sizeof(query), "DELETE FROM `Vips` WHERE `Nick` = '%e'", Nome(playerid));
    mysql_tquery(Connection, query, "", "");

	Player[playerid][TempoVip] = 0;
	Player[playerid][Vip] = 0;
	Player[playerid][DiasVip] = 0;
	SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Seus dias VIP chegaram ao fim. Para renovar adquira uma nova key VIP.");
	return 1;
}


forward SendMessageToAdminsEx(const string[]);
public SendMessageToAdminsEx(const string[])
{
	for(new i = 0; i <= HighestID; i++)
	{
		if(IsPlayerConnected(i) == 1)
		{
			if(Player[i][pAdmin] >= 1)
			{
				SendClientMessage(i, 0xFFBD9DFF, string);
			}
		}
	}
	return 1;
}

forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
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
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

forward Top1();
public Top1()
{
    new ntorcida, nrecorde, nplayers[MAX_TORCIDAS], string[256];

	for(new i = 0; i <= HighestID; i++)
    {
    	if(Player[i][pTorcida] > 0 && Player[i][pTorcida] < MAX_TORCIDAS)
			nplayers[Player[i][pTorcida]] += 1;
	}

    for(new x = 0; x < MAX_TORCIDAS; x ++)
	{
		if(nplayers[x] > nrecorde)
		{
			nrecorde = nplayers[x];
			ntorcida = x;
		}
	}

	format(string, sizeof(string),"{FF0000}[GTB INFORMA] {61615E}Torcida TOP do momento: %s com %d onlines. ({ff0000}/toptorcidas{61615E})", Torcidas[ntorcida][tNome], nrecorde);
	SendClientMessageToAll(-1, string);
}

forward TempoAsay(playerid);
public TempoAsay(playerid)
{
	Player[playerid][DelayAsay] = false;
}

forward hora(playerid);
public hora(playerid)
{
	new str[30], str2[30], str3[30], mes[12],year,month,day,hour,minute,second;

    getdate(year, month, day);
    gettime(hour,minute,second);

    if(month == 1) { mes = "1"; }
    else if(month == 2) {mes = "2";}
    else if(month == 3) {mes = "3";}
    else if(month == 4) {mes = "4";}
    else if(month == 5) {mes = "5";}
    else if(month == 6) {mes = "6";}
    else if(month == 7) {mes = "7";}
    else if(month == 8) {mes = "8";}
    else if(month == 9) {mes = "9";}
    else if(month == 10) {mes = "10";}
    else if(month == 11) {mes = "11";}
    else if(month == 12) {mes= "12";}

    format(str, sizeof(str), "%d:%d:%d", hour, minute, second);
    TextDrawSetString(Text:Hora, str);
    format(str, sizeof(str), "%d/%s/%d", day, mes,year);
    TextDrawSetString(Text:Data, str2);
    format(str, sizeof(str), "players on: ~w~%d/%d", ConnectedPlayers(), GetMaxPlayers());
    TextDrawSetString(Textdraw[3], str3);

    if(TempoReal[1]==true)
    {
	    TempoReal[1]=true;
	   	new wtime;
		if(hour == 16) wtime = 20;
		else if(hour == 17) wtime = 21;
		else if(hour == 18) wtime = 21;
		else if(hour == 19) wtime = 23;
		else if(hour == 20) wtime = 24;
		else if(hour == 21) wtime = 24;
		else if(hour >= 22 && hour <= 23) wtime = 24;
		else wtime = hour;
		for(new i; i <= HighestID; i++)
		{
			SetPlayerTime(i, wtime, 0);
		}
	}
}

forward MensagemBope(const string[]);
public MensagemBope(const string[])
{
	for(new i = 0; i <= HighestID; i++)
	{
		if(IsPlayerConnected(i) == 1)
		{
			if(Player[i][pBope] >= 1)
			{
				SendClientMessage(i, 0xFFBD9DFF, string);
			}
		}
	}
	return 1;
}

forward MensagemChoque(const string[]);
public MensagemChoque(const string[])
{
	for(new i = 0; i <= HighestID; i++)
	{
		if(IsPlayerConnected(i) == 1)
		{
			if(Player[i][pChoque] >= 1)
			{
				SendClientMessage(i, 0xA9A9A9FF, string);
			}
		}
	}
	return 1;
}

// ativar key
forward CheckKeyExist(playerid, Key[]);
public CheckKeyExist(playerid, Key[])
{
    if(cache_get_row_count(Connection) == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Key inexistente.");

	new ValorDias = cache_get_field_content_int(0, "Dias");
	new Nivel = cache_get_field_content_int(0, "Nivel");
    SetVip(playerid, Nivel, ValorDias);

    new query[70];
    mysql_format(Connection, query, sizeof(query), "DELETE FROM `Keys` WHERE `Key` = '%e'", Key);
    mysql_tquery(Connection, query, "", "");
	return 1;
}

forward KeyCheck(playerid, Key[], Dias, Nivel);
public KeyCheck(playerid, Key[], Dias, Nivel)
{
    if(cache_get_row_count(Connection) == 1) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Key ja existente.");

	new query[150];
	mysql_format(Connection, query, sizeof(query), "INSERT INTO `Keys` (`Key`, `Dias`, `Nivel`) VALUES ('%e', %d, %d)", Key, Dias, Nivel);
	mysql_tquery(Connection, query, "KeyCreated", "isii", playerid, Key, Dias, Nivel);
	return 1;
}


forward KeyCreated(playerid, Key[], Dias, Nivel);
public KeyCreated(playerid, Key[], Dias, Nivel)
{
	new MsgKeyVip[70], text[30];
	if(Nivel == 1) { text = "VIP Bronze"; }
	if(Nivel == 2) { text = "VIP Prata"; }
	if(Nivel == 3) { text = "VIP Ouro"; }
	SendClientMessage(playerid, COR_PRINCIPAL, "[INFO]: Nova Key VIP criada.");
	format(MsgKeyVip, sizeof MsgKeyVip, "[INFO]: Key: '%s' - Dias: [%d] - Nivel: [%d] - %s", Key, Dias, Nivel, text);
	SendClientMessage(playerid, COR_PRINCIPAL, MsgKeyVip);
    return 1;
}

forward DeleteKey(playerid, Key[]);
public DeleteKey(playerid, Key[])
{
    if(cache_get_row_count(Connection) == 0) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Key inexistente.");

	new query[70];
    mysql_format(Connection, query, sizeof(query), "DELETE FROM `Keys` WHERE `Key` = '%e'", Key);
    mysql_tquery(Connection, query, "KeyDeleted", "is", playerid, Key);
    return 1;
}

forward KeyDeleted(playerid, Key[]);
public KeyDeleted(playerid, Key[])
{
    new MsgKeyVip[60];
	format(MsgKeyVip, sizeof MsgKeyVip, "[INFO]: A key %s foi removida com sucesso.", Key);
	SendClientMessage(playerid, COR_PRINCIPAL, MsgKeyVip);
    return 1;
}

// verificar dias
forward CheckVip();
public CheckVip()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && Player[i][Vip] == 1)
		{
			if(Player[i][TempoVip] > 0)
			{
			    Player[i][TempoVip] = gettime() - ExpireVIP(i);
				} else {
			    RemoveVip(i);
			}
		}
	}
	return 1;
}

ExpireVIP(playerid)
{
	new Dias = Player[playerid][DiasVip] * 86400; // 86400 == 24horas
	return Dias;
}

IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

LiberarKit(playerid)
{
	SendClientMessage(playerid, COR_VIP, "[INFO]: Você ja pode pegar seu KIT-VIP novamente!");
	Player[playerid][PegouKit] = false;
}

VerificarNivelVip(playerid, lvl)
{
	if(Player[playerid][Vip] < lvl)
	{
	    new MsgErro[30];
		format(MsgErro, sizeof(MsgErro), "[ERRO]: Comando indisponivel. Vip %d+", lvl);
		SendClientMessage(playerid, COR_ERRO, MsgErro);
		return 0;
	}
	return 1;
}

stock IsPlayerInWater(playerid) {
    new anim = GetPlayerAnimationIndex(playerid);
    if (((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
    return 0;
}

stock MiraLaser(playerid) {
	new anim = GetPlayerAnimationIndex(playerid);
	if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1365) ||
	(anim == 1643) || (anim == 1453) || (anim == 220)) return 1;
    return 0;
}

ShowToys(playerid)
{
    new string[1700];
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu de Bombeiro {0088FF}Slot 1 \n"); // 0
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu de Policial {0088FF}Slot 1 \n"); //   1
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu Michael Jackson {0088FF}Slot 1 \n"); // 2
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu Operário {0088FF}Slot 1 \n"); // 3
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu de Funkeiro {0088FF}Slot 1 \n"); // 4
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu de Veio {0088FF}Slot 1 \n"); // 5
    strcat(string, "{FFFF00}-{FFFFFF} Chapéu do Harry Potter {0088FF}Slot 1 \n"); // 6
    strcat(string, "{FFFF00}-{FFFFFF} Bolsa de sequestrador {0088FF}Slot 1 \n");// 7
    strcat(string, "{FFFF00}-{FFFFFF} Fones de ouvido {0088FF}Slot 1 \n");// 8
    strcat(string, "{FFFF00}-{FFFFFF} Loro José Gigante {0088FF}Slot 1 \n");// 9
    strcat(string, "{FFFF00}-{FFFFFF} Loro José menor (Ombro) {0088FF}Slot 2 \n");// 10
    strcat(string, "{FFFF00}-{FFFFFF} Tapa olho de pirata {0088FF}Slot 2 \n");// 11
    strcat(string, "{FFFF00}-{FFFFFF} Dildo {0088FF}Slot 2\n");// 12
    strcat(string, "{FFFF00}-{FFFFFF} Cabeça de galo {0088FF}Slot 1 \n");// 13
    strcat(string, "{FFFF00}-{FFFFFF} Cabeça de galo gigante Slot 1 \n");// 14
    strcat(string, "{FFFF00}-{FFFFFF} Cervo {0088FF}Slot 1 \n");// 15
    strcat(string, "{FFFF00}-{FFFFFF} Chifre de boi 1 {0088FF}Slot 1 \n");// 16
    strcat(string, "{FFFF00}-{FFFFFF} Chifre de boi 2 {0088FF}Slot 1 \n");// 17
    strcat(string, "{FFFF00}-{FFFFFF} Fanstasia de obóbora {0088FF}Slot 1 \n");// 18
    strcat(string, "{FFFF00}-{FFFFFF} Cabeção do CJ {0088FF}Slot 1 \n"); // 19
    strcat(string, "{FFFF00}-{FFFFFF} Golfinho {0088FF}Slot 1 \n"); // 20
    strcat(string, "{FFFF00}-{FFFFFF} Tubarão {0088FF}Slot 1 \n"); // 21
    strcat(string, "{FFFF00}-{FFFFFF} Fantasia de tartaruga {0088FF}Slot 1 \n"); // 22
    strcat(string, "{FFFF00}-{FFFFFF} Vaca {0088FF}Slot 1 \n"); // 23
    strcat(string, "{FFFF00}-{FFFFFF} Colete no corpo {0088FF}Slot 2 \n");// 24
    strcat(string, "{FFFF00}-{FFFFFF} Coração no peito {0088FF}Slot 2 \n");// 25
    strcat(string, "{FFFF00}-{FFFFFF} C4 nas costas {0088FF}Slot 2 \n");// 26
    strcat(string, "{FFFF00}-{FFFFFF} M4 nas costas  {0088FF}Slot 2 \n");// 27
    strcat(string, "{FFFF00}-{FFFFFF} Bazzuka nas costas  {0088FF}Slot 2 \n");// 28
    strcat(string, "{FFFF00}-{FFFFFF} Toca do Papai Noel  {0088FF}Slot 1 \n");// 29
    strcat(string, "{FFFF00}-{FFFFFF} Dado na cabeça  {0088FF}Slot 1 \n");// 30
    strcat(string, "{FFFF00}-{FFFFFF} C4 no peito  {0088FF}Slot 2 \n");// 31
    ShowPlayerDialog(playerid, DIALOG_TOYS, DIALOG_STYLE_LIST, "[INFO]: Selecione para adicionar a seu skin:", string, "APLICAR", "SAIR");
    return 1;
}

ShowEfects(playerid)
{
    new string[800];
    strcat(string, "{FFFF00}-{FFFFFF} Fogo na Skin {0088FF}Slot 1\n"); // 0
    strcat(string, "{FFFF00}-{FFFFFF} Explosão Aquatica {0088FF}Slot 1\n"); //   1
    strcat(string, "{FFFF00}-{FFFFFF} Neve {0088FF}Slot 1\n"); // 2
    strcat(string, "{FFFF00}-{FFFFFF} Pedras {0088FF}Slot 1\n"); // 3
    strcat(string, "{FFFF00}-{FFFFFF} Caveira {0088FF}Slot 1\n"); // 4
    strcat(string, "{FFFF00}-{FFFFFF} Colete {0088FF}Slot 1\n"); // 5
    strcat(string, "{FFFF00}-{FFFFFF} Fumaça {0088FF}Slot 1\n"); // 6
    strcat(string, "{FFFF00}-{FFFFFF} Touca de Natal {0088FF}Slot 1\n");// 7
    strcat(string, "{FFFF00}-{FFFFFF} Caveira e Fogo {0088FF}Slot 1 e 2\n");// 8
    strcat(string, "{FFFF00}-{FFFFFF} Colete e Fumaça {0088FF}Slot 1 e 2\n");// 9
    strcat(string, "{FFFF00}-{FFFFFF} Pedras e Explosão Aquatica {0088FF}Slot 1 e 2\n");// 10
    strcat(string, "{FFFF00}-{FFFFFF} Touca de Natal e Neve {0088FF}Slot 1 e 2\n");// 11
    ShowPlayerDialog(playerid, DIALOG_EFECTS, DIALOG_STYLE_LIST, "[INFO]: Selecione para adicionar a seu skin:", string, "APLICAR", "SAIR");
    return 1;
}

forward SendVipMessageToAll(playerid, const string[]);
public SendVipMessageToAll(playerid, const string[])
{
	switch(Player[playerid][Vip])
	{
		case 1: SendClientMessageToAll(BRONZE, string);
		case 2: SendClientMessageToAll(PRATA, string);
		case 3: SendClientMessageToAll(OURO, string);
	}
	return 1;
}

forward ChatVIP(const string[]);
public ChatVIP(const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && Player[i][Vip] > 0)
		{
			switch(Player[i][Vip])
			{
				case 1: SendClientMessage(i, BRONZE, string);
				case 2: SendClientMessage(i, PRATA, string);
				case 3: SendClientMessage(i, OURO, string);
			}
		}
	}
	return 1;
}

forward TempoReparar(playerid);
public TempoReparar(playerid)
{
	LimiteReparar[playerid] = 0;
}

stock BanExtend(playerid, id, reason[], days)
{
    // -- BanInfo --
    new bannedby[24],bantime, banreason[60];
	// -------------
	new ip[24];
    GetPlayerIp(id, ip, sizeof ip);
	bantime = gettime()+((60*60*24)*days);
	format(bannedby, 24, Nome(playerid));
	format(banreason, 60, reason);
	new Query[500];
	format(Query, sizeof(Query), "INSERT INTO `banlist`(Name, banreason, bantime, bannedby, data, days, IP) VALUES('%s', '%s', %d, '%s', '%s', %d, '%s')", Nome(id), banreason, bantime, bannedby, ReturnDate(), days, ip);
    mysql_tquery(conectDB, Query);
	return KickEx(id);
}

forward OnPlayerBanned(playerid);
public OnPlayerBanned(playerid)
{
    new rows, fields, dialog[512];
    // -- BanInfo --
    new data[30],reason[60],bannedby[24],bantime;
	// -------------
	cache_get_data(rows, fields, conectDB);
	if(rows)
	{
		cache_get_field_content(0, "banreason", reason);
		cache_get_field_content(0, "bannedby", bannedby);
		cache_get_field_content(0, "data", data);
		new ip[24];
		GetPlayerIp(playerid, ip, sizeof ip);
        bantime = cache_get_field_content_int(0, "bantime");
		if(bantime > gettime())
		{
	        format(dialog, sizeof(dialog),
		    "{FF0000}\tVocê está banido, abaixo as informações.\n\n\
		    {ffffff}Nick: {FF0000}%s\n\
		    {ffffff}IP: {FF0000}%s\n\
		    {ffffff}Banido pelo Admin: {FF0000}%s\n\
			{ffffff}Motivo: {FF0000}%s\n\
			{ffffff}Tempo restante: {FF0000}%s\n\
			{ffffff}Ocorrido em {FF0000}%s\n\n\
			{ffffff}Se você acha que foi banido injustamente,\n\
			crie uma revisão no fórum: www.equipegtb.com/forum",
			Nome(playerid), ip, bannedby, reason, Convert3(bantime), data);
		    ShowPlayerDialog(playerid, DIALOG_MESSAGE, DIALOG_STYLE_MSGBOX, "{FF0000}# Banido", dialog, "Fechar", "");
	        Kick(playerid);
		}
		else
		{
		    new Query[256];
			format(Query, sizeof(Query),"DELETE FROM `banlist` WHERE(`Name`='%s' OR `IP`='%s')", Nome(playerid), ip);
            mysql_tquery(conectDB, Query);
		    new Str1[999];
		    format(Str1, sizeof(Str1),"-OpenServ- O banimento de %s chegou ao fim.", Nome(playerid));
		    SendMessageToAdminsEx(Str1);
		}
	}
	return true;
}

stock ReturnDate()
{
	static date[36];
	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);
	format(date, sizeof(date), "%02d/%02d/%d às %02d:%02d", date[0], date[1], date[2], date[3], date[4]);
	return date;
}

stock Convert3(n)
{
	static t[5];
	t[4] = n-gettime();

	t[0] = t[4] / 3600; // Hour
	t[1] = ((t[4] / 60) - (t[0] * 60)); // Minutes
	t[2] = (t[4] - ((t[0] * 3600) + (t[1] * 60))); // Seconds
	t[3] = (t[0] / 24); // Days
	new String[500];
	if(t[3] > 0)
	t[0] = t[0] % 24,
	format(String, sizeof(String), "%ddias, %02dh %02dm e %02ds", t[3], t[0], t[1], t[2]);
	else if(t[0] > 0)
	format(String, sizeof(String), "%02dh %02dm e %02ds", t[0], t[1], t[2]);
	else
	format(String, sizeof(String), "%02dm e %02ds", t[1], t[2]);
	return String;
}

stock KickEx(playerid)
{
	if(Player[playerid][Kicked]) return 0;
	Player[playerid][Kicked] = 1;
	SetTimerEx("KickTimer", 200, false, "d", playerid);
	return 1;
}
forward KickTimer(playerid);
public KickTimer(playerid)
{
	if (Player[playerid][Kicked])
	return Kick(playerid);
	return 0;
}

forward SaveVariables(id);
public SaveVariables(id)
{
	new Float: health, Float: armour, Float: SX, Float: SY, Float: SZ, Float:ang;
	GetPlayerHealth(id, health);
	GetPlayerArmour(id, armour);
	GetPlayerPos(id, SX, SY, SZ);
	GetPlayerFacingAngle(id, ang);
	Variable[id][VirtualWorld] = GetPlayerVirtualWorld(id);

	Variable[id][pSkin] = GetPlayerSkin(id);
	Variable[id][pHealth] = floatround(health);

	if(armour > 0)
		Variable[id][pArmour] = floatround(armour);

	Variable[id][Float_X] = SX;
	Variable[id][Float_Y] = SY;
	Variable[id][Float_Z] = SZ;
	Variable[id][pAngle] = ang;
	Variable[id][Inter] = GetPlayerInterior(id);
	Variable[id][WantedLevel] = GetPlayerWantedLevel(id);
	SetPlayerWantedLevel(id,0);

	for (new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(id, i, Weapons[id][i][0], Weapons[id][i][1]);
	}
	ResetPlayerWeapons(id);
}
forward LoadVariables(id);
public LoadVariables(id)
{
	ResetPlayerWeapons(id);
	for (new i; i < 13; i++)
	{
		if(Weapons[id][i][0] > 0)
		GivePlayerWeapon(id, Weapons[id][i][0], Weapons[id][i][1]);
	}

	SetPlayerWantedLevel(id,Variable[id][WantedLevel]);
	SetPlayerArmour(id, float(Variable[id][pArmour]));
	SetPlayerHealth(id, float(Variable[id][pHealth]));

	if (Variable[id][pArmour] > 1) SetPlayerArmour(id, Variable[id][pArmour]);

	SetPlayerSkin(id, Variable[id][pSkin]);
	SetPlayerVirtualWorld(id, Variable[id][VirtualWorld]);
	SetPlayerPos(id, Variable[id][Float_X], Variable[id][Float_Y], Variable[id][Float_Z]);
	SetPlayerFacingAngle(id, Variable[id][pAngle]);
	SetPlayerInterior(id, Variable[id][Inter]);
	SendClientMessage(id, COR_PRINCIPAL,"[INFO]: Suas últimas configurações salvas foram carregadas.");
	return 1;
}

forward TempoReport(playerid);
public TempoReport(playerid)
{
	Player[playerid][DelayReport] = false;
}

forward reduzirTempo(id);
public reduzirTempo(id)
{
	if(IsPlayerConnected(id))
	{
	    new string[62];
		if(Player[id][TempoPreso] == 0)
		{
		    format(string, sizeof(string),"~r~VOCE ESTA SOLTO");
			GameTextForPlayer(id, string, 1000, 3);
			if(PresoADM[id]==0)
			{
				SetPlayerWantedLevel(id, 0);
				Player[id][Procurado] =0;
			}
			PresoADM[id] = 0;
			Player[id][EmTrabalho] = false;
			Player[id][TempoPreso] = 0;
			SetPlayerInterior(id, 0);
			SalvarPlayer(id);
	  		SpawnPlayer(id);
			return 1;
		}
		Player[id][TempoPreso]--;
	    SetTimerEx("reduzirTempo", 1000, false, "d", id);
	}
    return 1;
}

forward ProxDetectorS(Float:radi, playerid, targetid);
public ProxDetectorS(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

forward StartDuel(p1, p2,type,armour);
public StartDuel(p1,p2,type,armour)
{
    if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
    {
		Player[p2][InDuel] = false;
		Player[p1][InDuel] = false;
        return 0;
    }

	Player[p1][InDuel] = true;
	Player[p2][InDuel] = true;

	Player[p1][DuelID] = p2;
	Player[p2][DuelID] = p1;

	Player[p1][DuelInviteType] = type;
	Player[p2][DuelInviteType] = type;

	GameTextForPlayer(p1, "~g~GO GO!", 2500, 3);
	GameTextForPlayer(p2, "~g~GO GO!", 2500, 3);

	Player[p1][DuelInvite] = INVALID_PLAYER_ID;
	Player[p2][DuelInvite] = INVALID_PLAYER_ID;

    SetPlayerDrunkLevel(p1, 0);
    SetPlayerDrunkLevel(p2, 0);

    //Player[p1][SavedMoney] = Player[p1][Money];
    //Player[p2][SavedMoney] = Player[p2][Money];
    //ResetPlayerMoneyEx(p1);
    //ResetPlayerMoneyEx(p2);
    //ResetPlayerWeapons(p1);
    //ResetPlayerWeapons(p2);
	//SetPlayerInterior(p1,0);
	//SetPlayerInterior(p2,0);

	if(armour == 1)
	{
		SetPlayerHealth(p1, 100);
		SetPlayerHealth(p2, 100);
		SetPlayerArmour(p1, 100);
		SetPlayerArmour(p2, 100);
	}
	else if(armour == 2)
	{
	    SetPlayerHealth(p1, 100);
		SetPlayerHealth(p2, 100);
		SetPlayerArmour(p1, 0);
		SetPlayerArmour(p2, 0);
	}

    return 1;
}

forward ClearDuel(p1, p2);
public ClearDuel(p1,p2)
{
    if(Player[p1][InDuel] == false && Player[p2][InDuel] == false)
    {
	    SendClientMessage(p1,COR_ERRO,"[APOSTA] O desafio expirou.");
	    SendClientMessage(p2,COR_ERRO,"[APOSTA] O desafio expirou.");
	    Player[p1][DuelInvite] = INVALID_PLAYER_ID;
	    Player[p2][DuelInvite] = INVALID_PLAYER_ID;
	 }
}

forward DeletarTapete(playerid);
public DeletarTapete(playerid)
{
	if(CrieiTapete[playerid] == 1)
	{
		CrieiTapete[playerid] = 0;
		DestroyObject(TapeteCOP[playerid]);
		GameTextForPlayer(playerid,"~y~Tapete de pregos ~n~~r~foi removido",5000,1);
		KillTimer(PassandoTapete[playerid]);
		KillTimer(TempoTapete[playerid]);
		TapeteX = 0.000000, TapeteY = 0.000000, TapeteZ = 0.000000;
	}
	return 1;
}

forward FurandoPneu();
public FurandoPneu()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		new Dano[4];
		if(IsPlayerInAnyVehicle(i))
		{
			new veiculoid = GetVehicleModel(GetPlayerVehicleID(i));
			if(!VeiculosPoliciais(veiculoid))
			{
				if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
				{
					if(PlayerToPoint(4.0, i,TapeteX,TapeteY,TapeteZ))
					{
						GetVehicleDamageStatus(GetPlayerVehicleID(i), Dano[0], Dano[1], Dano[2], Dano[3]);
						UpdateVehicleDamageStatus(GetPlayerVehicleID(i), Dano[0], Dano[1], Dano[2], TireDano(1, 1, 1, 1));
						return 1;
					}
				}
			}
		}
	}
	return 0;
}

stock VeiculosPoliciais(veiculoid)
{
	if(veiculoid == 599 || veiculoid == 528 || veiculoid == 490 || veiculoid == 470 ||
	veiculoid == 432 ||  veiculoid == 461 ||  veiculoid == 510 ||  veiculoid == 521 ||
	veiculoid == 522 ||  veiculoid == 523)
	{
		return 1;
	}
	return 0;
}


forward FecharPortaoMansao(playerid);
public FecharPortaoMansao(playerid)
{
	MoveDynamicObject(portaomansao,1026.75684, -370.08450, 72.74670,10);
}

forward FecharPortaoCasa(playerid);
public FecharPortaoCasa(playerid)
{
	MoveDynamicObject(portaocasa,527.52362, -1873.93237, 2.19100,10);
}


forward FecharPortaoBOPE(playerid);
public FecharPortaoBOPE(playerid)
{
	MoveDynamicObject(portaoBOPE,2237.6,2453.08,12.45,10);
}

forward FecharPortaoBOPE2(playerid);
public FecharPortaoBOPE2(playerid)
{
	MoveDynamicObject(portaoBOPE2,2334.43,2443.65,7.7906,10);
}

forward Jogar(playerid);
public Jogar(playerid)
{
    new Float:Pos[3], string[72];
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    if(Pos[0] != Player[playerid][LastPos][0] || Pos[1] != Player[playerid][LastPos][1]) return SendClientMessage(playerid, COR_ERRO, "[ERRO]: Você se moveu.");
    SpawnPlayer(playerid);
    Player[playerid][EmTrabalho] = false;
	format(string,sizeof(string), "O %s %s saiu do modo trabalho.", CheckOrg(playerid), Nome(playerid));
	SendClientMessageToAll(COR_NEGATIVO, string);
	return 1;
}

stock CheckOrg(playerid)
{
	new text[28] = "Nenhuma";
	if(Player[playerid][pBope] >= 1) text = "Policial";
	else if(Player[playerid][pChoque] >= 1) text = "Policial";
	else if(Player[playerid][pReporter] >= 1) text = "Repórter";
	return text;
}

forward @PayDay();
@PayDay()
{
	for(new i; i <= HighestID; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(Logado[i] == true)
			{
				if(GetPlayerMoney(i) <= 0)
				{
					ResetPlayerMoney(i);
				}
				new var10[80];
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
 				if(Player[i][Vip]<1)
			    {
			    	SendClientMessage(i, COR_PRINCIPAL, "------------[PAY DAY]-----------------");
					SendClientMessage(i, COR_BRANCO, "Você recebeu +1 hora jogada.");
					format(var10,sizeof(var10),"Level [%d]", GetPlayerScore(i)+1);
	    			SendClientMessage(i, COR_BRANCO, var10);
					SetPlayerScore(i, GetPlayerScore(i) + 1);
					SendClientMessage(i, COR_BRANCO, "Salario: R$ [30.000]");
   					GivePlayerMoney(i, 30000);
					Player[i][Cash]++;
					format(var10, sizeof(var10), "Cash: [%d]", Player[i][Cash]);
					SendClientMessage(i, COR_BRANCO, var10);
  				}
  				else
  				{
  					SendClientMessage(i, COR_PRINCIPAL, "------------[PAY DAY VIP]-----------------");
					SendClientMessage(i, COR_BRANCO, "Você recebeu +2 horas jogada.");
					format(var10,sizeof(var10),"Level [%d]", GetPlayerScore(i)+2);
	    			SendClientMessage(i, COR_BRANCO, var10);
					SetPlayerScore(i, GetPlayerScore(i) + 2);
     				SendClientMessage(i, COR_BRANCO, "Salario: R$ [60.000]");
			    	GivePlayerMoney(i, 60000);
   					Player[i][Cash]++;
					Player[i][Cash]++;
					format(var10, sizeof(var10), "Cash: [%d]", Player[i][Cash]);
					SendClientMessage(i, COR_BRANCO, var10);
  				}
   				format(var10, sizeof(var10),"Dinheiro: R$ [%d]\n", GetPlayerMoney(i));
			    SendClientMessage(i, COR_BRANCO, var10);
				SendClientMessage(i, COR_BRANCO, "------------------------------------------------");
				SalvarPlayer(i);
			}
		}
	}
}

//========================= [ CASAS ] ========================================== //
ShowAdminMenu(playerid)
{
    new
        stringCat[1200];

    strcat(stringCat, "Visualizar interior\n");
    strcat(stringCat, "Alterar Preço\n");
    strcat(stringCat, "Alterar Preço Aluguel\n");
    strcat(stringCat, "Alterar Interior\n");
    strcat(stringCat, "Alterar Status\n");
    strcat(stringCat, "Alterar Título\n");
    strcat(stringCat, "Mudar dono\n");
    strcat(stringCat, "Criar Carro\n");
    strcat(stringCat, "{FD0100}Vender casa\n");
    strcat(stringCat, "{FD0100}Deletar casa\n");
    ShowPlayerDialog(playerid, DIALOG_EDIT_HOUSE, DIALOG_STYLE_LIST, "Menu Administrativo", stringCat, "Selecionar", "Cancelar");
    return 1;
}

ShowHouseMenu(playerid)
{
	new house = GetProxHouse(playerid), stringCat[1200];

	if(!strcmp(houseData[house][houseOwner], "Ninguem", true))
    {
        ShowPlayerDialog(playerid, DIALOG_HOUSE_SELL_MENU, DIALOG_STYLE_LIST, "Menu house", "Comprar Casa\n", "Selecionar", "Cancelar");
        TogglePlayerControllable(playerid, 0);
    }

    else if(!strcmp(houseData[house][houseOwner], Nome(playerid), true))
    {
        strcat(stringCat, "{00FAF7}Entrar em casa\n");
        strcat(stringCat, "{09FD00}Ativar{46FE00}/{FD0300}Desativar {FFFFFF}aluguel da casa\n");
        strcat(stringCat, "{09FD00}Trancar{46FE00}/{FD0300}Destrancar {FFFFFF}a casa\n");
        strcat(stringCat, "Comprar um carro para a casa\n");
        strcat(stringCat, "Vender sua casa\n");
        strcat(stringCat, "Vender sua casa para um player\n");
        strcat(stringCat, "Despejar Locador\n");
        strcat(stringCat, "Alterar Título da casa\n");
        strcat(stringCat, "{0080C0}Armazenamento da casa\n");

        ShowPlayerDialog(playerid, DIALOG_HOUSE_OWNER_MENU, DIALOG_STYLE_LIST, "Menu house", stringCat, "Selecionar", "Cancelar");
        TogglePlayerControllable(playerid, 0);
    }
    else if(strcmp(houseData[house][houseOwner], Nome(playerid), true))
    {
        if(houseData[house][houseRentable] == 1)
        {
            if(strcmp(houseData[house][houseTenant], Nome(playerid), true))
            {
                strcat(stringCat, "{00FAF7}Entrar na casa\n");
                strcat(stringCat, "Alugar casa\n");
                ShowPlayerDialog(playerid, DIALOG_RENTING_GUEST, DIALOG_STYLE_LIST, "Menu house", stringCat, "Selecionar", "Cancelar");
                TogglePlayerControllable(playerid, 0);
                return 1;
            }

            else
            {
                strcat(stringCat, "{00FAF7}Entrar em casa\n");
                strcat(stringCat, "{09FD00}Trancar{46FE00}/{FD0300}Destrancar {FFFFFF}a casa\n");
                strcat(stringCat, "{FD0100}Desalugar\n");
                ShowPlayerDialog(playerid, DIALOG_HOUSE_TENANT_MENU, DIALOG_STYLE_LIST, "Menu house", stringCat, "Selecionar", "Cancelar");
                TogglePlayerControllable(playerid, 0);
            }
        }
        else
        {
            ShowPlayerDialog(playerid, DIALOG_GUEST, DIALOG_STYLE_MSGBOX, "Menu house", "{FFFFFF}Você deseja entrar nesta casa?", "Sim", "Não");
            TogglePlayerControllable(playerid, 0);
            return 1;
        }
    }

    new logString[128];

    format(logString, sizeof logString, "O jogador %s[%d], abriu o menu da casa %d.", Nome(playerid), playerid, house);
    WriteLog(LOG_HOUSES, logString);
    return 1;
}

ShowHouseVehicleMenu(playerid)
{
    new stringCat[300];
    strcat(stringCat, "Estacionar Carro\n");
    strcat(stringCat, "Mudar cor do carro\n");
    strcat(stringCat, "Escolher novo modelo\n");
    strcat(stringCat, "Mudar Placa\n");
    strcat(stringCat, "Vender Carro\n");
    ShowPlayerDialog(playerid, DIALOG_CAR_MENU, DIALOG_STYLE_LIST, "Menu Carro", stringCat, "Selecionar", "Cancelar");
    return 1;
}

ShowStorageMenu(playerid, type)
{
    //1 = colete
    if (type == 1)
    {
        new
            stringCat[1000],
            string[256],
            slotid,
            house = GetProxHouse(playerid);

        GetPlayerArmour(playerid, oldArmour);

        for(new s; s < MAX_ARMOUR; s++)
        {
            slotid = s + 1;

            if(houseData[house][houseArmourStored][s] > 0)
            {
                format(string, sizeof string, "{FFFFFF}SLOT {46FE00}%d{FFFFFF}:\t\t%.2f%%\n", slotid, houseData[house][houseArmourStored][s]);
                strcat(stringCat, string);
            }
            else if(houseData[house][houseArmourStored][s] == 0)
            {
                format(string, sizeof string, "{FFFFFF}SLOT {46FE00}%d{FFFFFF}:\t\t{FFFFFF}VAZIO\n", slotid);
                strcat(stringCat, string);
            }
        }
        ShowPlayerDialog(playerid, DIALOG_STORAGE_ARMOUR, DIALOG_STYLE_LIST, "{00F2FC}Coletes armazenados.", stringCat, "Equipar", "Voltar");
    }
    return 1;
}

ShowCreateHouseDialog(playerid)
{
    if(!IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, COLOR_ERROR, "* Sem autorização.");

        GetPlayerPos(playerid, X, Y, Z);
        PlayerPlaySound(playerid, 1085, X, Y, Z);
        return 1;
    }

    new stringCat[1200];

    strcat(stringCat, "Interior {FB1300}1 \t{FCEC00}6 {FFFFFF}Comodos \t\t{00EAFA}R$ 65.000,00 \n");
    strcat(stringCat, "Interior {FB1300}2 \t{FCEC00}3 {FFFFFF}Comodos \t\t{00EAFA}R$ 37.000,00 \n");
    strcat(stringCat, "Interior {FB1300}3 \t{FCEC00}3 {FFFFFF}Comodos \t\t{00EAFA}R$ 37.000,00 \n");
    strcat(stringCat, "Interior {FB1300}4 \t{FCEC00}1 {FFFFFF}Comodo  \t\t{00EAFA}R$ 20.000,00 \n");
    strcat(stringCat, "Interior {FB1300}5 \t{FCEC00}1 {FFFFFF}Comodo  \t\t{00EAFA}R$ 20.000,00 \n");
    strcat(stringCat, "Interior {FB1300}6 \t{FCEC00}3 {FFFFFF}Comodos \t\t{00EAFA}R$ 150.000,00 {FFFFFF}| (Casa do CJ)\n");
    strcat(stringCat, "Interior {FB1300}7 \t{FCEC00}5 {FFFFFF}Comodos \t\t{00EAFA}R$ 320.000,00 \n");
    strcat(stringCat, "Interior {FB1300}8 \t{FCEC00}7 {FFFFFF}Comodos \t\t{00EAFA}R$ 120.000,00 \n");
    strcat(stringCat, "Interior {FB1300}9 \t{FCEC00}4 {FFFFFF}Comodos \t\t{00EAFA}R$ 95.000,00 \n");
    strcat(stringCat, "Interior {FB1300}10 \t{FCEC00}Muitos {FFFFFF}Comodos \t{00EAFA}R$ 1.200.000,00 {FFFFFF}| (Casa do Madd Dog)\n");
    strcat(stringCat, "Interior {FB1300}11 \t{FCEC00}7 {FFFFFF}Comodos \t\t{00EAFA}R$ 660.000,00 \n");
    ShowPlayerDialog(playerid, DIALOG_CREATE_HOUSE, DIALOG_STYLE_LIST,"Criando Casa", stringCat, "Continuar", "Cancelar");
    return 1;
}

CreateHouse(house, Float:PickupX, Float:PickupY, Float:PickupZ, Float:InteriorX, Float:InteriorY, Float:InteriorZ, Float:InteriorFA, houseValue, houseInt)
{
	new storageFile[100], file[100];

	format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);
    format(storageFile, sizeof storageFile, "LHouse/Armazenamento/Casa %d.txt", house);

	if(!DOF2_FileExists(file))
    {
        format(houseData[house][houseOwner], 24, "Ninguem");
        format(houseData[house][houseTenant], 24, "Ninguem");
        format(houseData[house][houseTitle], 32, "Título não definido");

        houseData[house][houseX] = PickupX;
        houseData[house][houseY] = PickupY;
        houseData[house][houseZ] = PickupZ;
        houseData[house][houseIntX] = InteriorX;
        houseData[house][houseIntY] = InteriorY;
        houseData[house][houseIntZ] = InteriorZ;
        houseData[house][houseIntFA] = InteriorFA;
        houseData[house][houseInterior] = houseInt;
        houseData[house][housePrice] = houseValue;
        houseData[house][houseVirtualWorld] = house;
        houseData[house][houseStatus] = 1;
        houseData[house][houseRentable] = 0;
        houseData[house][houseRentPrice] = 0;
        houseVehicle[house][vehicleHouse] = 0;
        houseVehicle[house][vehicleModel] = 0;
        houseVehicle[house][vehicleX] = 0;
        houseVehicle[house][vehicleY] = 0;
        houseVehicle[house][vehicleZ] = 0;
        houseVehicle[house][vehicleColor1] = 0;
        houseVehicle[house][vehicleColor2] = 0;
        houseVehicle[house][vehiclePrice] = 0;

        DOF2_CreateFile(file);

        DOF2_SetInt(file, "ID", house, "Informações");
        DOF2_SetInt(file, "Preço", houseValue, "Informações");
        DOF2_SetString(file, "Dono", "Ninguem", "Informações");
        DOF2_SetString(file, "Título", "Título não definido", "Informações");
        DOF2_SetInt(file, "Status", 1, "Informações");

        DOF2_SetInt(file, "Aluguel Ativado", 0, "Aluguel");
        DOF2_SetInt(file, "Preço do Aluguel", 0, "Aluguel");
        DOF2_SetString(file, "Locador", "Ninguem", "Aluguel");

        DOF2_SetInt(file, "Interior", houseInt, "Coordenadas");
        DOF2_SetFloat(file, "Exterior X", PickupX, "Coordenadas");
        DOF2_SetFloat(file, "Exterior Y", PickupY, "Coordenadas");
        DOF2_SetFloat(file, "Exterior Z", PickupZ, "Coordenadas");
        DOF2_SetFloat(file, "Interior X", InteriorX, "Coordenadas");
        DOF2_SetFloat(file, "Interior Y", InteriorY, "Coordenadas");
        DOF2_SetFloat(file, "Interior Z", InteriorZ, "Coordenadas");
        DOF2_SetFloat(file, "Interior Facing Angle", InteriorFA, "Coordenadas");
        DOF2_SetInt(file, "Virtual World", house, "Coordenadas");

        DOF2_SetInt(file, "Modelo do Carro", 0, "Veículo");
        DOF2_SetFloat(file, "Coordenada do Veículo X", 0, "Veículo");
        DOF2_SetFloat(file, "Coordenada do Veículo Y", 0, "Veículo");
        DOF2_SetFloat(file, "Coordenada do Veículo Z", 0, "Veículo");
        DOF2_SetFloat(file, "Angulo", 0, "Veículo");
        DOF2_SetInt(file, "Cor 1", 0, "Veículo");
        DOF2_SetInt(file, "Cor 2", 0, "Veículo");
    	DOF2_SetInt(file, "Valor", 0, "Veículo");
        DOF2_SetInt(file, "Tempo de Respawn", 0, "Veículo");
        DOF2_SetString(file, "Placa", "LHouse", "Veículo");

        DOF2_SaveFile();

        DOF2_CreateFile(storageFile);

        new slotStorageID[20];

        for(new s; s < MAX_ARMOUR; s++)
        {
            format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);
            DOF2_SetFloat(storageFile, slotStorageID, 0, "Colete");
        }

        DOF2_SaveFile();
    }
    else
    {
	    houseData[house][housePrice] = DOF2_GetInt(file, "Preço", "Informações");
        format(houseData[house][houseOwner], 24, DOF2_GetString(file, "Dono", "Informações"));
        format(houseData[house][houseTitle], 32, DOF2_GetString(file, "Título", "Informações"));
        houseData[house][houseStatus] = DOF2_GetInt(file, "Status", "Informações");

        houseData[house][houseRentable] = DOF2_GetInt(file, "Aluguel Ativado", "Aluguel");
        houseData[house][houseRentPrice] = DOF2_GetInt(file, "Preço do Aluguel", "Aluguel");
        format(houseData[house][houseTenant], 24, DOF2_GetString(file, "Locador", "Aluguel"));

        houseData[house][houseX] = DOF2_GetFloat(file, "Exterior X", "Coordenadas");
        houseData[house][houseY] = DOF2_GetFloat(file, "Exterior Y", "Coordenadas");
        houseData[house][houseZ] = DOF2_GetFloat(file, "Exterior Z", "Coordenadas");
        houseData[house][houseIntX] = DOF2_GetFloat(file, "Interior X", "Coordenadas");
        houseData[house][houseIntY] = DOF2_GetFloat(file, "Interior Y", "Coordenadas");
        houseData[house][houseIntZ] = DOF2_GetFloat(file, "Interior Z", "Coordenadas");
        houseData[house][houseInterior] = DOF2_GetInt(file, "Interior", "Coordenadas");
        houseData[house][houseVirtualWorld] = DOF2_GetInt(file, "Virtual World", "Coordenadas");

        new slotStorageID[20], Float:valueOnFile;

        if(!DOF2_FileExists(storageFile))
            DOF2_CreateFile(storageFile);

        for(new s; s < MAX_ARMOUR; s++)
        {
            format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);

            if(!DOF2_IsSet(storageFile, slotStorageID, "Colete"))
                DOF2_SetFloat(storageFile, slotStorageID, 0, "Colete");

            valueOnFile = DOF2_GetFloat(storageFile, slotStorageID, "Colete");

            if(valueOnFile != 0)
                houseData[house][houseArmourStored][s] = valueOnFile;
        }

    }

    new houseStatusName[20], houseRentName[20], textlabel[200];

    if(!strcmp(houseData[house][houseOwner], "Ninguem", true))
    {
		housePickupIn[house] = CreateDynamicPickup(1273, 1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
        housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
 		houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 31, -1, -1, 0, -1, 100.0);
        if(houseData[house][houseStatus] == 1) houseStatusName = "Trancada";
        else if(houseData[house][houseStatus] == 0) houseStatusName = "Destrancada";
        format(textlabel, sizeof textlabel, TEXT_SELLING_HOUSE, houseData[house][housePrice], house);
        houseLabel[house] = CreateDynamic3DTextLabel(textlabel, -1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 20.0);
    }
    else
	{
        if(houseData[house][houseRentable] == 1)
        {
    		housePickupIn[house] = CreateDynamicPickup(1272, 1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
            housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
            houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 32, -1, -1, 0, -1, 100.0);
            if(houseData[house][houseStatus] == 1) houseStatusName = "Trancada";
            else if(houseData[house][houseStatus] == 0) houseStatusName = "Destrancada";
            format(textlabel, sizeof textlabel, TEXT_RENT_HOUSE, houseData[house][houseTitle], houseData[house][houseOwner], houseData[house][houseTenant], houseData[house][houseRentPrice], houseStatusName, house);
            houseLabel[house] = CreateDynamic3DTextLabel(textlabel, -1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 20.0);
            return 1;
        }

        else
        {
    		housePickupIn[house] = CreateDynamicPickup(1272, 1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
            housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
            houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 32, -1, -1, 0, -1, 100.0);
            if(houseData[house][houseStatus] == 1) houseStatusName = "Trancada";
            else if(houseData[house][houseStatus] == 0) houseStatusName = "Destrancada";
            if(houseData[house][houseRentable] == 1) houseRentName = "Ativado";
            else if(houseData[house][houseRentable] == 0) houseRentName = "Desativado";
            format(textlabel, sizeof textlabel, TEXT_HOUSE, houseData[house][houseTitle], houseData[house][houseOwner], houseRentName, houseStatusName, house);
            houseLabel[house] = CreateDynamic3DTextLabel(textlabel, -1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 20.0);
            return 1;
        }
    }

    new
        logString[128];

    format(logString, sizeof logString, "-------- A CASA DE ID %d FOI CRIADA COM SUCESSO! --------", house);
    WriteLog(LOG_SYSTEM, logString);
    return 1;
}

public SaveHouses()
{
    new
        storageFile[100],
        file[200];

    for(new house = 1; house < MAX_HOUSES; house++)
    {
        format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);
        format(storageFile, sizeof storageFile, "LHouse/Armazenamento/Casa %d.txt", house);

        if(DOF2_FileExists(file))
        {
            DOF2_SetInt(file, "ID", house, "Informações");
            DOF2_SetInt(file, "Preço", houseData[house][housePrice], "Informações");
            DOF2_SetString(file, "Dono", houseData[house][houseOwner], "Informações");
            DOF2_SetString(file, "Título", houseData[house][houseTitle], "Informações");
            DOF2_SetInt(file, "Status", houseData[house][houseStatus], "Informações");

            DOF2_SetString(file, "Locador", houseData[house][houseTenant], "Aluguel");
            DOF2_SetInt(file, "Aluguel Ativado", houseData[house][houseRentable], "Aluguel");
            DOF2_SetInt(file, "Preço do Aluguel", houseData[house][houseRentPrice], "Aluguel");

            DOF2_SetInt(file, "Interior", houseData[house][houseInterior], "Coordenadas");
            DOF2_SetFloat(file, "Exterior X", houseData[house][houseX], "Coordenadas");
            DOF2_SetFloat(file, "Exterior Y", houseData[house][houseY], "Coordenadas");
            DOF2_SetFloat(file, "Exterior Z", houseData[house][houseZ], "Coordenadas");
            DOF2_SetFloat(file, "Interior X", houseData[house][houseIntX], "Coordenadas");
            DOF2_SetFloat(file, "Interior Y", houseData[house][houseIntY], "Coordenadas");
            DOF2_SetFloat(file, "Interior Z", houseData[house][houseIntZ], "Coordenadas");
            DOF2_SetFloat(file, "Interior Facing Angle", houseData[house][houseIntFA], "Coordenadas");
            DOF2_SetInt(file, "Virtual World", houseData[house][houseVirtualWorld], "Coordenadas");

    		DOF2_SetInt(file, "Modelo do Carro", houseVehicle[house][vehicleModel], "Veículo");
			DOF2_SetFloat(file, "Coordenada do Veículo X", houseVehicle[house][vehicleX], "Veículo");
			DOF2_SetFloat(file, "Coordenada do Veículo Y", houseVehicle[house][vehicleY], "Veículo");
			DOF2_SetFloat(file, "Coordenada do Veículo Z", houseVehicle[house][vehicleZ], "Veículo");
            DOF2_SetFloat(file, "Angulo", houseVehicle[house][vehicleAngle], "Veículo");
			DOF2_SetInt(file, "Cor 1", houseVehicle[house][vehicleColor1], "Veículo");
			DOF2_SetInt(file, "Cor 2", houseVehicle[house][vehicleColor2], "Veículo");
            DOF2_SetInt(file, "Status do Carro", houseVehicle[house][vehicleStatus], "Veículo");
			DOF2_SetInt(file, "Valor", houseVehicle[house][vehiclePrice], "Veículo");
			DOF2_SetInt(file, "Tempo de Respawn", houseVehicle[house][vehicleRespawnTime], "Veículo");
            DOF2_SetString(file, "Placa", houseVehicle[house][vehiclePlate], "Veículo");

            DOF2_SaveFile();

            if(!DOF2_FileExists(storageFile))
                DOF2_CreateFile(storageFile);

            new
                slotStorageID[20];

            for(new s; s < MAX_ARMOUR; s++)
            {
                format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);
                DOF2_SetFloat(storageFile, slotStorageID, houseData[house][houseArmourStored][s], "Colete");
            }

            DOF2_SaveFile();

            return 1;
        }
    }
    return 1;
}

public SaveHouse(house)
{
    new
        storageFile[100],
        file[200];

    format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);
    format(storageFile, sizeof storageFile, "LHouse/Armazenamento/Casa %d.txt", house);

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "ID", house, "Informações");
        DOF2_SetInt(file, "Preço", houseData[house][housePrice], "Informações");
        DOF2_SetString(file, "Dono", houseData[house][houseOwner], "Informações");
        DOF2_SetString(file, "Título", houseData[house][houseTitle], "Informações");
        DOF2_SetInt(file, "Status", houseData[house][houseStatus], "Informações");

        DOF2_SetString(file, "Locador", houseData[house][houseTenant], "Aluguel");
        DOF2_SetInt(file, "Aluguel Ativado", houseData[house][houseRentable], "Aluguel");
        DOF2_SetInt(file, "Preço do Aluguel", houseData[house][houseRentPrice], "Aluguel");

        DOF2_SetInt(file, "Interior", houseData[house][houseInterior], "Coordenadas");
        DOF2_SetFloat(file, "Exterior X", houseData[house][houseX], "Coordenadas");
        DOF2_SetFloat(file, "Exterior Y", houseData[house][houseY], "Coordenadas");
        DOF2_SetFloat(file, "Exterior Z", houseData[house][houseZ], "Coordenadas");
        DOF2_SetFloat(file, "Interior X", houseData[house][houseIntX], "Coordenadas");
        DOF2_SetFloat(file, "Interior Y", houseData[house][houseIntY], "Coordenadas");
        DOF2_SetFloat(file, "Interior Z", houseData[house][houseIntZ], "Coordenadas");
        DOF2_SetFloat(file, "Interior Facing Angle", houseData[house][houseIntFA], "Coordenadas");
        DOF2_SetInt(file, "Virtual World", houseData[house][houseVirtualWorld], "Coordenadas");

        DOF2_SetInt(file, "Modelo do Carro", houseVehicle[house][vehicleModel], "Veículo");
        DOF2_SetFloat(file, "Coordenada do Veículo X", houseVehicle[house][vehicleX], "Veículo");
        DOF2_SetFloat(file, "Coordenada do Veículo Y", houseVehicle[house][vehicleY], "Veículo");
        DOF2_SetFloat(file, "Coordenada do Veículo Z", houseVehicle[house][vehicleZ], "Veículo");
        DOF2_SetFloat(file, "Angulo", houseVehicle[house][vehicleAngle], "Veículo");
        DOF2_SetInt(file, "Cor 1", houseVehicle[house][vehicleColor1], "Veículo");
        DOF2_SetInt(file, "Cor 2", houseVehicle[house][vehicleColor2], "Veículo");
        DOF2_SetInt(file, "Status do Carro", houseVehicle[house][vehicleStatus], "Veículo");
        DOF2_SetInt(file, "Valor", houseVehicle[house][vehiclePrice], "Veículo");
        DOF2_SetInt(file, "Tempo de Respawn", houseVehicle[house][vehicleRespawnTime], "Veículo");
        DOF2_SetString(file, "Placa", houseVehicle[house][vehiclePlate], "Veículo");

        DOF2_SaveFile();

        if(!DOF2_FileExists(storageFile))
            DOF2_CreateFile(storageFile);

        new
            slotStorageID[20];

        for(new s; s < MAX_ARMOUR; s++)
        {
            format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);
            DOF2_SetFloat(storageFile, slotStorageID, houseData[house][houseArmourStored][s], "Colete");
        }

        DOF2_SaveFile();

        return 1;
    }
    return 1;
}

GetProxHouse(playerid)
{
    for(new i = 1; i < MAX_HOUSES; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, houseData[i][houseX], houseData[i][houseY], houseData[i][houseZ]))
	    {
	        return i;
		}
	    else if(IsPlayerInRangeOfPoint(playerid, 2, houseData[i][houseIntX], houseData[i][houseIntY], houseData[i][houseIntZ]))
	    {
	        return i;
		}
	}
	return -255;
}

GetHouseByOwner(playerid)
{
    new
        ownerFilePath[200],
        house;

    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
    format(ownerFilePath, sizeof ownerFilePath, "LHouse/Donos/%s.txt", playerName);

    if(!DOF2_FileExists(ownerFilePath))
        return -255;

    house = DOF2_GetInt(ownerFilePath, "houseID");
    return house;
}

CreateAllHousesVehicles()
{
    new
        vehiclesCreated,
        houseStatusName[20],
        vehiclePath[128],
        logString[128],
        engine,lights,alarm,doors,bonnet,boot,objective;

    for(new houses = 1; houses < MAX_HOUSES; houses++)
    {
	    format(vehiclePath, sizeof vehiclePath, "LHouse/Casas/Casa %d.txt", houses);
		if(DOF2_GetInt(vehiclePath, "Modelo do Carro", "Veículo") != 0)
		{
            houseVehicle[houses][vehicleModel] = DOF2_GetInt(vehiclePath, "Modelo do Carro", "Veículo");
    	    houseVehicle[houses][vehicleX] = DOF2_GetFloat(vehiclePath, "Coordenada do Veículo X", "Veículo");
        	houseVehicle[houses][vehicleY] = DOF2_GetFloat(vehiclePath, "Coordenada do Veículo Y", "Veículo");
        	houseVehicle[houses][vehicleZ] = DOF2_GetFloat(vehiclePath, "Coordenada do Veículo Z", "Veículo");
        	houseVehicle[houses][vehicleAngle] = DOF2_GetFloat(vehiclePath, "Angulo", "Veículo");
        	houseVehicle[houses][vehicleColor1] = DOF2_GetInt(vehiclePath, "Cor 1", "Veículo");
        	houseVehicle[houses][vehicleColor2] = DOF2_GetInt(vehiclePath, "Cor 2", "Veículo");
            houseVehicle[houses][vehiclePrice] = DOF2_GetInt(vehiclePath, "Valor", "Veículo");
        	houseVehicle[houses][vehicleRespawnTime] = DOF2_GetInt(vehiclePath, "Tempo de Respawn", "Veículo");
            houseVehicle[houses][vehicleStatus] = DOF2_GetInt(vehiclePath, "Status do Carro", "Veículo");
    	    format(houseVehicle[houses][vehiclePlate], 10, DOF2_GetString(vehiclePath, "Placa", "Veículo"));
            houseVehicle[houses][vehicleHouse] = CreateVehicle(houseVehicle[houses][vehicleModel], houseVehicle[houses][vehicleX], houseVehicle[houses][vehicleY], houseVehicle[houses][vehicleZ], houseVehicle[houses][vehicleAngle], houseVehicle[houses][vehicleColor1], houseVehicle[houses][vehicleColor2], houseVehicle[houses][vehicleRespawnTime]);
            SetVehicleNumberPlate(houseVehicle[houses][vehicleHouse], houseVehicle[houses][vehiclePlate]);
            vehiclesCreated++;

			if(houseVehicle[houses][vehicleStatus] == 1)
                houseStatusName = "Trancado";

			else if(houseVehicle[houses][vehicleStatus] == 0)
                houseStatusName = "Destrancado";

            format(logString, sizeof logString, "-------- O CARRO DA CASA DE ID %d FOI CRIADO COM SUCESSO! --------", houses);
            WriteLog(LOG_SYSTEM, logString);

            GetVehicleParamsEx(houseVehicle[houses][vehicleHouse], engine, lights, alarm, doors, bonnet, boot, objective);
            if(houseVehicle[houses][vehicleStatus] == 1)
            {
                SetVehicleParamsEx(houseVehicle[houses][vehicleHouse], engine, lights, alarm, 1, bonnet, boot, objective);
            }
            else
            {
                SetVehicleParamsEx(houseVehicle[houses][vehicleHouse], engine, lights, alarm, 0, bonnet, boot, objective);
            }
        }
    }
    if(vehiclesCreated == 0)
    {
        print("\n\t Não foi detectado nenhum carro de casa criado. ");
        print("\t Para criar um, logue no servidor, entre na RCON  ");
        print("\t e abra o menu administrativo da casa.            ");
    }
    else
    {
        printf("\t Foram criados %d carros.                                 ", vehiclesCreated);
    }
    return 1;
}

CreateAllHouses()
{
    new
        housesCreated,
        file[200],
        houseStatusName[20],
        textlabel[250],
        houseRentName[20],
        storageFile[100],
        logString[700];

    for(new house = 1; house < MAX_HOUSES; house++)
    {
	    format(file, sizeof file, "LHouse/Casas/Casa %d.txt", house);
        format(storageFile, sizeof storageFile, "LHouse/Armazenamento/Casa %d.txt", house);

		if(DOF2_FileExists(file))
		{
            houseData[house][housePrice] = DOF2_GetInt(file, "Preço", "Informações");
            houseData[house][houseStatus] = DOF2_GetInt(file, "Status", "Informações");
            format(houseData[house][houseOwner], 24, DOF2_GetString(file, "Dono", "Informações"));
            format(houseData[house][houseTitle], 32, DOF2_GetString(file, "Título", "Informações"));

            houseData[house][houseRentable] = DOF2_GetInt(file, "Aluguel Ativado", "Aluguel");
            houseData[house][houseRentPrice] = DOF2_GetInt(file, "Preço do Aluguel", "Aluguel");
            format(houseData[house][houseTenant], 24, DOF2_GetString(file, "Locador", "Aluguel"));

            houseData[house][houseX] = DOF2_GetFloat(file, "Exterior X", "Coordenadas");
            houseData[house][houseY] = DOF2_GetFloat(file, "Exterior Y", "Coordenadas");
            houseData[house][houseZ] = DOF2_GetFloat(file, "Exterior Z", "Coordenadas");
            houseData[house][houseIntX] = DOF2_GetFloat(file, "Interior X", "Coordenadas");
            houseData[house][houseIntY] = DOF2_GetFloat(file, "Interior Y", "Coordenadas");
            houseData[house][houseIntZ] = DOF2_GetFloat(file, "Interior Z", "Coordenadas");
            houseData[house][houseVirtualWorld] = DOF2_GetInt(file, "Virtual World", "Coordenadas");
            houseData[house][houseInterior] = DOF2_GetInt(file, "Interior", "Coordenadas");

            if(!DOF2_FileExists(storageFile))
                DOF2_CreateFile(storageFile);

            new
                slotStorageID[20],
                Float:valueOnFile;

            for(new s; s < MAX_ARMOUR; s++)
            {
                format(slotStorageID, sizeof slotStorageID, "SLOT %d", s);

                if(!DOF2_IsSet(storageFile, slotStorageID, "Colete"))
                    DOF2_SetFloat(storageFile, slotStorageID, 0, "Colete");

                valueOnFile = DOF2_GetFloat(storageFile, slotStorageID, "Colete");

                if(valueOnFile != 0)
                    houseData[house][houseArmourStored][s] = valueOnFile;
            }

            if(houseData[house][houseStatus] == 1)
                houseStatusName = "Trancada";

            else if(houseData[house][houseStatus] == 0)
                houseStatusName = "Destrancada";

            if(houseData[house][houseRentable] == 1)
                houseRentName = "Ativado";

            else if(houseData[house][houseRentable] == 0)
                houseRentName = "Desativado";

            housesCreated++;

            format(logString, sizeof logString, "-------- A CASA DE ID %d FOI CRIADA COM SUCESSO! --------", house);
            WriteLog(LOG_SYSTEM, logString);

            if(!strcmp(houseData[house][houseOwner], "Ninguem", true))
            {
		        housePickupIn[house] = CreateDynamicPickup(1273, 1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
                housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
 		        houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 31, -1, -1, 0, -1, 100.0);
                format(textlabel, sizeof textlabel, TEXT_SELLING_HOUSE, houseData[house][housePrice], house);
                houseLabel[house] = CreateDynamic3DTextLabel(textlabel, -1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 20.0);
            }
            else
	        {
                if(houseData[house][houseRentable] == 1)
                {
    		        housePickupIn[house] = CreateDynamicPickup(1272, 1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
                    housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
                    houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 32, -1, -1, 0, -1, 100.0);
                    format(textlabel, sizeof textlabel, TEXT_RENT_HOUSE, houseData[house][houseTitle], houseData[house][houseOwner], houseData[house][houseTenant], houseData[house][houseRentPrice], houseStatusName, house);
                    houseLabel[house] = CreateDynamic3DTextLabel(textlabel, -1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 20.0);
                }
                else
                {
    		        housePickupIn[house] = CreateDynamicPickup(1272, 1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ]);
                    housePickupOut[house] = CreateDynamicPickup(1318, 1, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
                    houseMapIcon[house] = CreateDynamicMapIcon(houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 32, -1, -1, 0, -1, 100.0);
                    format(textlabel, sizeof textlabel, TEXT_HOUSE, houseData[house][houseTitle], houseData[house][houseOwner], houseRentName, houseStatusName, house);
                    houseLabel[house] = CreateDynamic3DTextLabel(textlabel, -1, houseData[house][houseX], houseData[house][houseY], houseData[house][houseZ], 20.0);
                }
            }
        }
    }
    if(housesCreated == 0)
    {
        print("\n\n\t========================= LHOUSE ========================");
        print("\t Não foi detectado nenhuma casa criada.                  ");
        print("\t Para criar uma, logue no servidor, entre na RCON        ");
        print("\t e digite /criarcasa.                                   ");
    }
    else
    {
        print("\n\n\t========================= LHOUSE ========================");
        printf("\t Foram criadas %d casa(s).                                ", housesCreated);
    }
    return 1;
}

HouseVehicleDelivery(playerid)
{
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    new
        house = GetHouseByOwner(playerid),
        logString[128];

    format(logString, sizeof logString, "O jogador %s[%d], comprou um carro novo para a casa %d.", playerName, playerid, house);
    WriteLog(LOG_VEHICLES, logString);

    #if LHOUSE_CITY == 1
    	#if LHOUSE_DELIVERY_METHOD == 1
    		new
                rand = random(sizeof vehicleRandomSpawnLS);

    		houseCarSet[playerid] = true;
    		vehicleHouseCarDefined[house] = CreateVehicle(houseVehicle[house][vehicleModel], vehicleRandomSpawnLS[rand][0], vehicleRandomSpawnLS[rand][1], vehicleRandomSpawnLS[rand][2], vehicleRandomSpawnLS[rand][3], 0, 0, 5*60);
    		PutPlayerInVehicle(playerid, vehicleHouseCarDefined[house], 0);
    		SendClientMessage(playerid, COLOR_INFO, "* Estacione seu carro aonde quer que ele de spawn e digite {46FE00}/estacionar");

    		return 1;
    	#else
    		new
                rand = random(sizeof vehicleRandomSpawnLS);

    		houseCarSet[playerid] = true;
    		vehicleHouseCarDefined[house] = CreateVehicle(houseVehicle[house][vehicleModel], vehicleRandomSpawnLS[rand][0], vehicleRandomSpawnLS[rand][1], vehicleRandomSpawnLS[rand][2], vehicleRandomSpawnLS[rand][3], 0, 0, 5*60);
    		SendClientMessage(playerid, COLOR_INFO, "* Vá buscar seu carro na concessionária grotti.");

    		return 1;
    	#endif
	#elseif LHOUSE_CITY == 2
    	#if LHOUSE_DELIVERY_METHOD == 1
    		new
                rand = random(sizeof vehicleRandomSpawnSF);

    		houseCarSet[playerid] = true;
    		vehicleHouseCarDefined[house] = CreateVehicle(houseVehicle[house][vehicleModel], vehicleRandomSpawnSF[rand][0], vehicleRandomSpawnSF[rand][1], vehicleRandomSpawnSF[rand][2], vehicleRandomSpawnSF[rand][3], 0, 0, 5*60);
    		PutPlayerInVehicle(playerid, vehicleHouseCarDefined[house], 0);
    		SendClientMessage(playerid, COLOR_INFO, "* Estacione seu carro aonde quer que ele de spawn e digite {46FE00}/estacionar");

    		return 1;
    	#else
    		new
                rand = random(sizeof vehicleRandomSpawnSF);
    		houseCarSet[playerid] = true;
    		vehicleHouseCarDefined[house] = CreateVehicle(houseVehicle[house][vehicleModel], vehicleRandomSpawnSF[rand][0], vehicleRandomSpawnSF[rand][1], vehicleRandomSpawnSF[rand][2], vehicleRandomSpawnSF[rand][3], 0, 0, 5*60);
    		SendClientMessage(playerid, COLOR_INFO, "* Vá buscar seu carro na concessionária Otto's Auto.");

    		return 1;
    	#endif
	#else
	   #if LHOUSE_DELIVERY_METHOD == 1
    		new
                rand = random(sizeof vehicleRandomSpawnLV);

    		houseCarSet[playerid] = true;
    		vehicleHouseCarDefined[house] = CreateVehicle(houseVehicle[house][vehicleModel], vehicleRandomSpawnLV[rand][0], vehicleRandomSpawnLV[rand][1], vehicleRandomSpawnLV[rand][2], vehicleRandomSpawnLV[rand][3], 0, 0, 5*60);
    		PutPlayerInVehicle(playerid, vehicleHouseCarDefined[house], 0);
    		SendClientMessage(playerid, COLOR_INFO, "* Estacione seu carro aonde quer que ele de spawn e digite {46FE00}/estacionar");

    		return 1;
    	#else
    		new
                rand = random(sizeof vehicleRandomSpawnLV);

    		houseCarSet[playerid] = true;
    		vehicleHouseCarDefined[house] = CreateVehicle(houseVehicle[house][vehicleModel], vehicleRandomSpawnLV[rand][0], vehicleRandomSpawnLV[rand][1], vehicleRandomSpawnLV[rand][2], vehicleRandomSpawnLV[rand][3], 0, 0, 5*60);
    		SendClientMessage(playerid, COLOR_INFO, "* Vá buscar seu carro na Auto Bahn.");

    		return 1;
    	#endif
	#endif
}

Update3DText(house)
{
    new
        houseRentName[20],
        textlabel[200],
        houseStatusName[20];

    if(!strcmp(houseData[house][houseOwner], "Ninguem", true))
    {
        if(houseData[house][houseStatus] == 1) houseStatusName = "Trancada";
        else if(houseData[house][houseStatus] == 0) houseStatusName = "Destrancada";

        format(textlabel, sizeof textlabel, TEXT_SELLING_HOUSE, houseData[house][housePrice], house);
        UpdateDynamic3DTextLabelText(houseLabel[house], -1, textlabel);
        return 1;
    }

    else if(strcmp(houseData[house][houseOwner], "Ninguem", true))
    {
        if(houseData[house][houseRentable] == 1)
        {
            if(houseData[house][houseStatus] == 1)
                houseStatusName = "Trancada";

            else if(houseData[house][houseStatus] == 0)
                houseStatusName = "Destrancada";

            format(textlabel, sizeof textlabel, TEXT_RENT_HOUSE, houseData[house][houseTitle], houseData[house][houseOwner], houseData[house][houseTenant], houseData[house][houseRentPrice], houseStatusName, house);
            UpdateDynamic3DTextLabelText(houseLabel[house], -1, textlabel);
            return 1;
        }
        else
        {
            if(houseData[house][houseStatus] == 1)
                houseStatusName = "Trancada";

            else if(houseData[house][houseStatus] == 0)
                houseStatusName = "Destrancada";

            if(houseData[house][houseRentable] == 1)
                houseRentName = "Ativado";

            else if(houseData[house][houseRentable] == 0)
                houseRentName = "Desativado";

            format(textlabel, sizeof textlabel, TEXT_HOUSE, houseData[house][houseTitle], houseData[house][houseOwner], houseRentName, houseStatusName, house);
            UpdateDynamic3DTextLabelText(houseLabel[house], -1, textlabel);
            return 1;
        }
    }
    return 1;
}

GetTenantID(house)
{
    new
        tenantID;

    for(new s = GetMaxPlayers(), i; i < s; i++) {
        GetPlayerName(i, playerName, MAX_PLAYER_NAME);
        if (!strcmp(playerName, houseData[house][houseTenant], true)) {
            if (IsPlayerConnected(i)) {
                tenantID = i;
                break;
            }
            else {
                tenantID = -255;
            }
        }
    }

    return tenantID;
}

CreateHouseVehicleBought(playerid, house)
{
    new
        vehiclePath[200];

    format(vehiclePath, sizeof vehiclePath, "LHouse/Casas/Casa %d.txt", house);

    houseVehicle[house][vehiclePlate] = "LHouse S";
    houseVehicle[house][vehicleHouse] = \
        CreateVehicle(houseVehicle[house][vehicleModel], \
            houseVehicle[house][vehicleX], \
            houseVehicle[house][vehicleY], \
            houseVehicle[house][vehicleZ], \
            houseVehicle[house][vehicleAngle], \
            houseVehicle[house][vehicleColor1], \
            houseVehicle[house][vehicleColor2], \
            houseVehicle[house][vehicleRespawnTime]);

    DestroyVehicle(carSetted[playerid]);

    DOF2_SetString(vehiclePath, "Placa", houseVehicle[house][vehiclePlate], "Veículo");
    DOF2_SetInt(vehiclePath, "Modelo do Carro", houseVehicle[house][vehicleModel], "Veículo");
    DOF2_SetInt(vehiclePath, "Valor", houseVehicle[house][vehiclePrice], "Veículo");
    DOF2_SaveFile();

    return 1;
}

ChangeHouseVehicleColor(house, carColor1, carColor2)
{
    new housePath[200];

    format(housePath, sizeof housePath, "LHouse/Casas/Casa %d.txt", house);

    houseVehicle[house][vehicleColor1] = carColor1;
    houseVehicle[house][vehicleColor2] = carColor2;

    DOF2_SetInt(housePath, "Cor 1", houseVehicle[house][vehicleColor1], "Veículo");
    DOF2_SetInt(housePath, "Cor 2", houseVehicle[house][vehicleColor2], "Veículo");
    DOF2_SaveFile();

    ChangeVehicleColor(houseVehicle[house][vehicleHouse], houseVehicle[house][vehicleColor1], houseVehicle[house][vehicleColor2]);
    return 1;
}

ChangeHouseVehicleModel(house, model, price, mode)
{
    new
        housePath[200];

    format(housePath, sizeof housePath, "LHouse/Casas/Casa %d.txt", house);

    houseVehicle[house][vehicleModel] = model;
    houseVehicle[house][vehiclePrice] = price;

    DOF2_SetInt(housePath, "Modelo do Carro", houseVehicle[house][vehicleModel], "Veículo");
    DOF2_SetInt(housePath, "Valor", houseVehicle[house][vehiclePrice], "Veículo");
    DOF2_SaveFile();

    if(mode > 0)
    {
        DestroyVehicle(houseVehicle[house][vehicleHouse]);
        houseVehicle[house][vehicleHouse] = CreateVehicle(houseVehicle[house][vehicleModel], houseVehicle[house][vehicleX], houseVehicle[house][vehicleY], houseVehicle[house][vehicleZ], houseVehicle[house][vehicleAngle], houseVehicle[house][vehicleColor1], houseVehicle[house][vehicleColor2], houseVehicle[house][vehicleRespawnTime]);
    }

    return 1;
}

public TowVehicles()
{
    new string[128], houseTows;

    for(new houses = 1; houses < MAX_HOUSES; houses++)
    {
        if(towRequired[houses] == 1)
        {
            houseTows++;
            SetVehicleToRespawn(houseVehicle[houses][vehicleHouse]);
            towRequired[houses] = 0;
            format(string, sizeof string, "* O guincho acabou de entregar os carros solicitados!");
        }
    }

    if(houseTows == 0)
        return 1;

    SendClientMessageToAll(COLOR_INFO, string);
    return 1;
}

public DestroySetVehicle(playerid)
{
    SendClientMessage(playerid, COLOR_ERROR, "* Você não voltou para o veículo a tempo.");
    SendClientMessage(playerid, COLOR_ERROR, "* O veículo foi destruído.");
    new house = GetHouseByOwner(playerid);
    DestroyVehicle(vehicleHouseCarDefined[house]);
    houseCarSet[playerid] = false;
    return 1;
}

public CreateLogs()
{
    if(!LogExists(LOG_HOUSES))
    {
        CreateLog(LOG_HOUSES);
        WriteLog(LOG_HOUSES, "Log de casas criado.");
        print("\n\t Log de casas criado.");
    }
    if(!LogExists(LOG_VEHICLES))
    {
        CreateLog(LOG_VEHICLES);
        WriteLog(LOG_VEHICLES, "Log de veículos das casas criado.");
        print("\t Log de veículos das casas criado.");
    }
    if(!LogExists(LOG_ADMIN))
    {
        CreateLog(LOG_ADMIN);
        WriteLog(LOG_ADMIN, "Log de administração das casas criado.");
        print("\t Log de administração das casas criado.");
    }
    if(!LogExists(LOG_SYSTEM))
    {
        CreateLog(LOG_SYSTEM);
        WriteLog(LOG_SYSTEM, "Log do sistema criado.");
        print("\t Log do sistema criado.");
    }
    return 1;
}

public CreateHouseVehicleToPark(playerid)
{
    new Float: facingAngle;

    SendClientMessage(playerid, COLOR_INFO, "* Agora estacione e digite {46FE00}/estacionar{FFFFFF}.");

    GetPlayerPos(playerid, X, Y, Z);
    GetPlayerFacingAngle(playerid, facingAngle);

    carSet[playerid] = 1;
    carSetted[playerid] = CreateVehicle(542, X, Y, Z, facingAngle, 0, 0, 90000);

    PutPlayerInVehicle(playerid, carSetted[playerid], 0);
    SendClientMessage(playerid, COLOR_INFO, "* Veículo criado.");


    return 1;
}

public RentalCharge()
{
    new housesCharged,
        playersDumped,
        ownerID,
        tenantID,
        logString[700],
        playerName2[MAX_PLAYER_NAME],
        playerName3[MAX_PLAYER_NAME],
        ownerFile[200],
        tenantFile[200],
        houseFile[200],
        string[128];

    gettime(timeHour, timeMinute, timeSecond);

    for(new i = 1; i < MAX_HOUSES; i++)
    {
        format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", houseData[i][houseOwner]);
        format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", houseData[i][houseTenant]);
        format(houseFile, sizeof houseFile, "LHouse/Casas/Casa %d.txt", i);

        if(DOF2_FileExists(ownerFile) || DOF2_FileExists(tenantFile))
        {
            for(new ids = 0; ids < MAX_PLAYERS; ids++)
            {
                if(IsPlayerConnected(ids))
                {
                    GetPlayerName(ids, playerName, MAX_PLAYER_NAME);

                    if(!strcmp(houseData[i][houseOwner], playerName, true))
                    {
                       ownerID = ids;
                       GetPlayerName(ownerID, playerName2, MAX_PLAYER_NAME);
                    }

                    if(!strcmp(houseData[i][houseTenant], playerName, true))
                    {
                       tenantID = ids;
                       GetPlayerName(tenantID, playerName3, MAX_PLAYER_NAME);
                    }
                }
            }
        }
        if(timeHour == 15)
        {
            if(timeMinute == 43)
            {
                if(timeSecond == 00)
                {
                    if(strcmp(houseData[i][houseTenant], "Ninguem", true))
                    {
                        housesCharged++;
                        houseData[i][houseOutcoming] += houseData[i][houseRentPrice];
                        houseData[i][houseIncoming] += houseData[i][houseRentPrice];
                        DOF2_SetInt(ownerFile, "ValorAreceber", houseData[i][houseIncoming]);
                        DOF2_SetInt(tenantFile, "ValorApagar", houseData[i][houseOutcoming]);

                        if(IsPlayerConnected(ownerID))
                        {
                            format(string, sizeof string, "* Hora de receber o aluguel! Você recebeu {FFFFFF}$%d {FFFFFF}do locador.", houseData[i][houseIncoming]);
                            SendClientMessage(ownerID, -1, string);
                            GivePlayerMoney(ownerID, houseData[i][houseIncoming]);
                            houseData[i][houseIncoming] = 0;
                            DOF2_SetInt(ownerFile, "ValorAreceber", houseData[i][houseIncoming]);
                        }

                        if(IsPlayerConnected(tenantID))
                        {
                            if(GetPlayerMoney(tenantID) < houseData[i][houseOutcoming])
                            {
                                playersDumped++;
                                GetPlayerPos(tenantID, X, Y, Z);
                                PlayerPlaySound(tenantID, 1085, X, Y, Z);
                                SendClientMessage(tenantID, COLOR_ERROR, "* Você não tem dinheiro o suficiente para pagar o aluguel. Você foi despejado.");
                    			format(houseData[i][houseTenant], 255, "Ninguem");
                    			DOF2_SetString(houseFile, "Locador", "Ninguem", "Aluguel");
                                DOF2_RemoveFile(tenantFile);
                                Update3DText(i);
                                return 1;
                            }

                            format(string, sizeof string, "* Hora de pagar o aluguel! Você pagou {FFFFFF}$%d {FFFFFF}de aluguel.", houseData[i][houseOutcoming]);
                            SendClientMessage(tenantID, COLOR_INFO, string);
                            GivePlayerMoney(tenantID, -houseData[i][houseOutcoming]);
                            houseData[i][houseOutcoming] = 0;
                            DOF2_SetInt(tenantFile, "ValorApagar", houseData[i][houseOutcoming]);
                        }
                    }
                }
            }
        }
    }

    if(housesCharged != 0)
    {
        format(logString, sizeof logString, "Foram cobrado os alugueis de %d casas, %d jogadores que não tinham dinheiro para pagar aluguel estavam conectados e foram despejados.", housesCharged, playersDumped);
        return WriteLog(LOG_SYSTEM, logString);
    }
    return 1;
}

public SpawnInHome(playerid)
{
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    new house, tenantHouseID, tenantFile[200], houseFile[200], houseFile2[200], ownerFile[200], logString[700];

    format(ownerFile, sizeof ownerFile, "LHouse/Donos/%s.txt", playerName);
    format(tenantFile, sizeof tenantFile, "LHouse/Locadores/%s.txt", playerName);

    house = DOF2_GetInt(ownerFile, "houseID");
    tenantHouseID = DOF2_GetInt(tenantFile, "houseID");

    format(houseFile, sizeof houseFile, "LHouse/Casas/Casa %d.txt", house);
    format(houseFile2, sizeof houseFile2, "LHouse/Casas/Casa %d.txt", tenantHouseID);

    if(DOF2_FileExists(ownerFile))
    {
        new value = DOF2_GetInt(ownerFile, "ValorAreceber");
    	SetPlayerVirtualWorld(playerid, houseData[house][houseVirtualWorld]);
	    SetPlayerPos(playerid, houseData[house][houseIntX], houseData[house][houseIntY], houseData[house][houseIntZ]);
    	SetPlayerFacingAngle(playerid, houseData[house][houseIntFA]);
    	SetPlayerInterior(playerid, houseData[house][houseInterior]);

        format(logString, sizeof logString, "O jogador %s[%d], foi spawnado na casa %d.", playerName, playerid, house);
        WriteLog(LOG_HOUSES, logString);

        if(value != 0)
        {
            format(logString, sizeof logString, "O jogador %s[%d], foi spawnado na casa %d, e coletou o aluguel de $%d.", playerName, playerid, house, houseData[house][houseIncoming]);
            WriteLog(LOG_HOUSES, logString);
            GivePlayerMoney(playerid, houseData[house][houseIncoming]);
            houseData[house][houseIncoming] = 0;
            DOF2_SetInt(ownerFile, "ValorAreceber", houseData[house][houseIncoming]);
            return 1;
        }

        return 1;
    }

    else if(DOF2_FileExists(tenantFile))
    {
        new value = DOF2_GetInt(tenantFile, "ValorApagar");
    	SetPlayerVirtualWorld(playerid, houseData[tenantHouseID][houseVirtualWorld]);
	    SetPlayerPos(playerid, houseData[tenantHouseID][houseIntX], houseData[tenantHouseID][houseIntY], houseData[tenantHouseID][houseIntZ]);
    	SetPlayerFacingAngle(playerid, houseData[tenantHouseID][houseIntFA]);
    	SetPlayerInterior(playerid, houseData[tenantHouseID][houseInterior]);
        format(logString, sizeof logString, "O jogador %s[%d], foi spawnado na casa %d.", playerName, playerid, tenantHouseID);
        WriteLog(LOG_HOUSES, logString);
        if(value != 0)
        {
            if(GetPlayerMoney(playerid) < value)
            {
                GetPlayerPos(playerid, X, Y, Z);
                PlayerPlaySound(playerid, 1085, X, Y, Z);
                SendClientMessage(playerid, COLOR_ERROR, "* Você não tem dinheiro o suficiente para pagar o aluguel e foi despejado.");

    			format(houseData[tenantHouseID][houseTenant], 255, "Ninguem");
    			DOF2_SetString(houseFile2, "Locador", "Ninguem", "Aluguel");
                DOF2_RemoveFile(tenantFile);
                Update3DText(tenantHouseID);

                format(logString, sizeof logString, "O jogador %s[%d], não tinha dinheiro o suficiente para pagar o aluguel da casa %d e foi despejado.", playerName, playerid, tenantHouseID);
                WriteLog(LOG_HOUSES, logString);

                return 1;
            }

            format(logString, sizeof logString, "O jogador %s[%d], foi spawnado na casa %d e pagou $%d de aluguel.", playerName, playerid, tenantHouseID, value);
            WriteLog(LOG_HOUSES, logString);

            GivePlayerMoney(playerid, -value);
            houseData[tenantHouseID][houseOutcoming] = 0;

            DOF2_SetInt(tenantFile, "ValorApagar", houseData[tenantHouseID][houseOutcoming]);
            return 1;
        }

        return 1;
    }

    return 1;
}
