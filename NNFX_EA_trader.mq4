//+------------------------------------------------------------------+
//|                                               NNFX_EA_trader.mq4 |
//|                                                 Henrique.Pfeifer |
//|                                       henrique.pfeifer@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Henrique.Pfeifer"
#property link      "henrique.pfeifer@gmail.com"
#property version   "1.00"
#property strict

//--- Numbers ans symbols traded
#define Strategy_A 27
#define HR2400 PERIOD_D1 * 60    // 86400 = 24 * 3600
input ENUM_TIMEFRAMES Period_A0      = PERIOD_D1;
double ATR_K=1.5;

//--- Input parameters
input string          Data_for_Strategy_A="Strategy A - No Nonsense Forex";
double risk=0.02;

//--- Symbol 1
string          Symbol_A0      = "EURUSD";   // Symbol
input bool            IsTrade_A0     = true;       // EURUSD Trading enable 

//--- Symbol 1
string          Symbol_A1      = "GBPUSD";   // Symbol
input bool            IsTrade_A1     = true;       // GBPUSD Trading enable 

//--- Symbol 2
string          Symbol_A2      = "USDJPY";   // Symbol
input bool            IsTrade_A2     = true;       // USDJPY Trading enable 

//--- Symbol 3
string          Symbol_A3      = "USDCHF";   // Symbol
input bool            IsTrade_A3     = true;       // USDCHF Trading enable 

//--- Symbol 4
string          Symbol_A4      = "USDCAD";   // Symbol
input bool            IsTrade_A4     = true;       // USDCAD Trading enable 

//--- Symbol 5
string          Symbol_A5      = "AUDCAD";   // Symbol
input bool            IsTrade_A5     = true;       // AUDCAD Trading enable 

//--- Symbol 6
string          Symbol_A6      = "AUDCHF";   // Symbol
input bool            IsTrade_A6     = true;       // AUDCAD Trading enable 

//--- Symbol 7
string          Symbol_A7      = "AUDJPY";   // Symbol
input bool            IsTrade_A7     = true;       // AUDJPY Trading enable 

//--- Symbol 8
string          Symbol_A8      = "AUDNZD";   // Symbol
input bool            IsTrade_A8     = true;       // AUDNZD Trading enable 

//--- Symbol 9
string          Symbol_A9      = "AUDUSD";   // Symbol
input bool            IsTrade_A9     = true;       // AUDUSD Trading enable 

//--- Symbol 10
string          Symbol_A10      = "CADCHF";   // Symbol
input bool            IsTrade_A10     = true;       // CADCHF Trading enable 

//--- Symbol 11
string          Symbol_A11      = "CADJPY";   // Symbol
input bool            IsTrade_A11     = true;       // CADJPY Trading enable 

//--- Symbol 12
string          Symbol_A12      = "CHFJPY";   // Symbol
input bool            IsTrade_A12     = true;       // CHFJPY Trading enable 

//--- Symbol 13
string          Symbol_A13      = "EURAUD";   // Symbol
input bool            IsTrade_A13     = true;       // EURAUD Trading enable 

//--- Symbol 14
string          Symbol_A14      = "EURCAD";   // Symbol
input bool            IsTrade_A14     = true;       // EURCAD Trading enable 

//--- Symbol 15
string          Symbol_A15      = "EURGBP";   // Symbol
input bool            IsTrade_A15     = true;       // EURGBP Trading enable 

//--- Symbol 16
string          Symbol_A16      = "EURJPY";   // Symbol
input bool            IsTrade_A16     = true;       // EURJPY Trading enable 

//--- Symbol 17
string          Symbol_A17      = "EURNZD";   // Symbol
input bool            IsTrade_A17     = true;       // EURNZD Trading enable 

//--- Symbol 18
string          Symbol_A18      = "GBPAUD";   // Symbol
input bool            IsTrade_A18     = true;       // GBPAUD Trading enable 

//--- Symbol 19
string          Symbol_A19      = "GBPCAD";   // Symbol
input bool            IsTrade_A19     = true;       // GBPCAD Trading enable 

//--- Symbol 20
string          Symbol_A20      = "GBPCHF";   // Symbol
input bool            IsTrade_A20     = true;       // GBPCHF Trading enable 

//--- Symbol 21
string          Symbol_A21      = "GBPJPY";   // Symbol
input bool            IsTrade_A21     = true;       // GBPJPY Trading enable 

//--- Symbol 22
string          Symbol_A22      = "GBPNZD";   // Symbol
input bool            IsTrade_A22     = true;       // GBPNZD Trading enable 

//--- Symbol 23
string          Symbol_A23      = "NZDCAD";   // Symbol
input bool            IsTrade_A23     = true;       // NZDCAD Trading enable 

//--- Symbol 24
string          Symbol_A24      = "NZDCHF";   // Symbol
input bool            IsTrade_A24     = true;       // NZDCHF Trading enable 

//--- Symbol 25
string          Symbol_A25      = "NZDJPY";   // Symbol
input bool            IsTrade_A25     = true;       // NZDJPY Trading enable 

//--- Symbol 26
string          Symbol_A26      = "NZDUSD";   // Symbol
input bool            IsTrade_A26     = true;       // NZDUSD Trading enable 

//--- Indicators parameters



//--- Strategy parameters
//--- External parameters and matrix
string          Symbol_A[Strategy_A];
bool            IsTrade_A[Strategy_A];
ENUM_TIMEFRAMES Period_A[Strategy_A];
int             M_positions[8][8];
double          M_risk[8][8];

//--- Matrices and global parameters
double          tick_value[Strategy_A],point[Strategy_A];
uint            DealNumber_A[Strategy_A];
datetime        Locked_bar_time_A[Strategy_A],time_arr_A[];

//--- Matrices for indicators values
double   bl[Strategy_A][3];
double   i_azul[Strategy_A][5];
double   i_vermelho[Strategy_A][4];
double   i2[Strategy_A][5];
double   v_azul[Strategy_A][3];
double   ex[Strategy_A][3];


//--- Matrices for indicators signals
int   bl_sig[Strategy_A][3]; //Baseline
int   ind[Strategy_A][4]; //C1
int   v_perm[Strategy_A][3]; //Volume
int   ind2[Strategy_A][4]; //C2
int   exit[Strategy_A][3]; //Exit
int   signal[Strategy_A];
int   open_orders_array[Strategy_A];
double   TrailingStop[Strategy_A];
double positions_divider[Strategy_A];
double current_risk_BUY[Strategy_A];
double current_risk_SELL[Strategy_A];


//--- News Array
datetime List_EUR[11],List_USD[11],List_GBP[11],List_CAD[11],List_AUD[11],List_JPY[11],List_NZD[11],List_CHF[11];
datetime List[22];
//--- News flag
bool news=false;

datetime LastActionTime[Strategy_A];
datetime Exit_hold[Strategy_A];

int OnInit()
  {
//--- How much time wait between EA execution
   EventSetTimer(600); // 600 seconds

//--- NEWS
//--- Array initialization
   ArrayInitialize(List_EUR,0);
   ArrayInitialize(List_USD,0);
   ArrayInitialize(List_GBP,0);
   ArrayInitialize(List_CAD,0);
   ArrayInitialize(List_AUD,0);
   ArrayInitialize(List_JPY,0);
   ArrayInitialize(List_NZD,0);
   ArrayInitialize(List_CHF,0);
   ArrayInitialize(open_orders_array,0);



// NEWS DATE, ADD ACCORDINGLY TO THE FORMAT
// Only the day matters, set hour at 00:00
//---USD
   List_USD[0]=StringToTime("2019/01/04 00:00");
   List_USD[1]=StringToTime("2019/01/10 00:00");
   List_USD[2]=StringToTime("2019/01/11 00:00");
   List_USD[3]=StringToTime("2019/01/30 00:00");
   List_USD[4]=StringToTime("2019/02/01 00:00");
   List_USD[5]=StringToTime("2019/02/06 00:00");
   List_USD[6]=StringToTime("2019/02/12 00:00");
   List_USD[7]=StringToTime("2019/02/13 00:00");
   List_USD[8]=StringToTime("2019/02/26 00:00");
   List_USD[9]=StringToTime("2019/02/27 00:00");
   List_USD[10]=StringToTime("2019/02/28 00:00");

//---EUR
   List_EUR[0]=StringToTime("2019/01/15 00:00");
   List_EUR[1]=StringToTime("2019/01/24 00:00");
   List_EUR[2]=StringToTime("2019/01/28 00:00");
   List_EUR[3]=StringToTime("2019/02/22 00:00");
   List_EUR[4]=StringToTime("2019/03/07 00:00");
   List_EUR[5]=StringToTime("2019/03/27 00:00");
   List_EUR[6]=StringToTime("2019/04/10 00:00");
   List_EUR[7]=StringToTime("2019/05/08 00:00");
   List_EUR[8]=StringToTime("2019/05/22 00:00");
   List_EUR[9]=StringToTime("2019/06/12 00:00");
   List_EUR[10]=StringToTime("2019/06/17 00:00");

//---GBP
   List_GBP[0]=StringToTime("2019/01/11 00:00");
   List_GBP[1]=StringToTime("2019/02/07 00:00");
   List_GBP[2]=StringToTime("2019/02/11 00:00");
   List_GBP[3]=StringToTime("2019/03/21 00:00");
   List_GBP[4]=StringToTime("2019/03/29 00:00");
   List_GBP[5]=StringToTime("2019/04/10 00:00");
   List_GBP[6]=StringToTime("2019/05/02 00:00");
   List_GBP[7]=StringToTime("2019/05/10 00:00");
   List_GBP[8]=StringToTime("2019/06/10 00:00");
   List_GBP[9]=StringToTime("2019/06/20 00:00");
   List_GBP[10]=StringToTime("2019/06/28 00:00");

//---CAD
   List_CAD[0]=StringToTime("2019/01/04 00:00");
   List_CAD[1]=StringToTime("2019/01/09 00:00");
   List_CAD[2]=StringToTime("2019/01/18 00:00");
   List_CAD[3]=StringToTime("2019/01/23 00:00");
   List_CAD[4]=StringToTime("2019/02/08 00:00");
   List_CAD[5]=StringToTime("2019/02/22 00:00");
   List_CAD[6]=StringToTime("2019/02/27 00:00");
   List_CAD[7]=StringToTime("2019/03/06 00:00");
   List_CAD[8]=StringToTime("2019/03/08 00:00");
   List_CAD[9]=StringToTime("2019/03/22 00:00");
   List_CAD[10]=StringToTime("2019/04/05 00:00");

//---AUD
   List_AUD[0]=StringToTime("2019/01/23 00:00");
   List_AUD[1]=StringToTime("2019/02/04 00:00");
   List_AUD[2]=StringToTime("2019/02/20 00:00");
   List_AUD[3]=StringToTime("2019/03/04 00:00");
   List_AUD[4]=StringToTime("2019/20/03 00:00");
   List_AUD[5]=StringToTime("2019/04/01 00:00");
   List_AUD[6]=StringToTime("2019/04/17 00:00");
   List_AUD[7]=StringToTime("2019/05/07 00:00");
   List_AUD[8]=StringToTime("2019/05/15 00:00");
   List_AUD[9]=StringToTime("2019/06/04 00:00");
   List_AUD[10]=StringToTime("2019/06/12 00:00");

//---JPY
   List_JPY[0]=StringToTime("2019/01/22 00:00");
   List_JPY[1]=StringToTime("2019/03/14 00:00");
   List_JPY[2]=StringToTime("2019/04/24 00:00");
   List_JPY[3]=StringToTime("2019/06/19 00:00");
   List_JPY[4]=StringToTime("2019/07/29 00:00");
   List_JPY[5]=StringToTime("2019/10/19 00:00");
   List_JPY[6]=StringToTime("2019/10/31 00:00");

//---NZD
   List_NZD[0]=StringToTime("2019/01/15 00:00");
   List_NZD[1]=StringToTime("2019/02/06 00:00");
   List_NZD[2]=StringToTime("2019/02/12 00:00");
   List_NZD[3]=StringToTime("2019/02/19 00:00");
   List_NZD[4]=StringToTime("2019/03/05 00:00");
   List_NZD[5]=StringToTime("2019/03/16 00:00");
   List_NZD[6]=StringToTime("2019/03/19 00:00");
   List_NZD[7]=StringToTime("2019/03/20 00:00");
   List_NZD[8]=StringToTime("2019/03/26 00:00");
   List_NZD[9]=StringToTime("2019/04/02 00:00");
   List_NZD[10]=StringToTime("2019/04/16 00:00");

//---CHF
   List_CHF[0]=StringToTime("2019/03/21 00:00");
   List_CHF[1]=StringToTime("2019/04/21 00:00");
   List_CHF[2]=StringToTime("2019/10/19 00:00");


//--- Copying the input parameter to the matrices
   Symbol_A[0]     =Symbol_A0;
   Symbol_A[1]     =Symbol_A1;
   Symbol_A[2]     =Symbol_A2;
   Symbol_A[3]     =Symbol_A3;
   Symbol_A[4]     =Symbol_A4;
   Symbol_A[5]     =Symbol_A5;
   Symbol_A[6]     =Symbol_A6;
   Symbol_A[7]     =Symbol_A7;
   Symbol_A[8]     =Symbol_A8;
   Symbol_A[9]     =Symbol_A9;
   Symbol_A[10]    =Symbol_A10;
   Symbol_A[11]    =Symbol_A11;
   Symbol_A[12]    =Symbol_A12;
   Symbol_A[13]    =Symbol_A13;
   Symbol_A[14]    =Symbol_A14;
   Symbol_A[15]    =Symbol_A15;
   Symbol_A[16]    =Symbol_A16;
   Symbol_A[17]    =Symbol_A17;
   Symbol_A[18]    =Symbol_A18;
   Symbol_A[19]    =Symbol_A19;
   Symbol_A[20]    =Symbol_A20;
   Symbol_A[21]    =Symbol_A21;
   Symbol_A[22]    =Symbol_A22;
   Symbol_A[23]    =Symbol_A23;
   Symbol_A[24]    =Symbol_A24;
   Symbol_A[25]    =Symbol_A25;
   Symbol_A[26]    =Symbol_A26;

   IsTrade_A[0]    =IsTrade_A0;
   IsTrade_A[1]    =IsTrade_A1;
   IsTrade_A[2]    =IsTrade_A2;
   IsTrade_A[3]    =IsTrade_A3;
   IsTrade_A[4]    =IsTrade_A4;
   IsTrade_A[5]    =IsTrade_A5;
   IsTrade_A[6]    =IsTrade_A6;
   IsTrade_A[7]    =IsTrade_A7;
   IsTrade_A[8]    =IsTrade_A8;
   IsTrade_A[9]    =IsTrade_A9;
   IsTrade_A[10]    =IsTrade_A10;
   IsTrade_A[11]    =IsTrade_A11;
   IsTrade_A[12]    =IsTrade_A12;
   IsTrade_A[13]    =IsTrade_A13;
   IsTrade_A[14]    =IsTrade_A14;
   IsTrade_A[15]    =IsTrade_A15;
   IsTrade_A[16]    =IsTrade_A16;
   IsTrade_A[17]    =IsTrade_A17;
   IsTrade_A[18]    =IsTrade_A18;
   IsTrade_A[19]    =IsTrade_A19;
   IsTrade_A[20]    =IsTrade_A20;
   IsTrade_A[21]    =IsTrade_A21;
   IsTrade_A[22]    =IsTrade_A22;
   IsTrade_A[23]    =IsTrade_A23;
   IsTrade_A[24]    =IsTrade_A24;
   IsTrade_A[25]    =IsTrade_A25;
   IsTrade_A[26]    =IsTrade_A26;

// Array initialization
   ArrayInitialize(Period_A,Period_A0);
   ArrayInitialize(TrailingStop,0);
   ArrayInitialize(LastActionTime,0);
   ArrayInitialize(Exit_hold,0);


//--- Check if symbol is in Market Watch
   for(int i=0; i<Strategy_A; i++)
     {
      if(IsTrade_A[i]==false)
         continue;
      if(IsSymbolInMarketWatch(Symbol_A[i])==false)
        {
         Print(Symbol_A[i]," isn't at Market Watch!, Please ADD and insert the EA again.");
         ExpertRemove();
        }
     }

   for(int i=0; i<Strategy_A; i++)
     {
      //--- Get tick value
      tick_value[i]=MarketInfo(Symbol_A[i],MODE_TICKVALUE);
      //--- Get point info
      point[i]=MarketInfo(Symbol_A[i],MODE_POINT);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Stop the event trigger
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTimer()
  {

//--- Verificamos se o terminal está conectado ao servidor de negociacao
   if(TerminalInfoInteger(TERMINAL_CONNECTED)==false)
     {
      Print("Terminal not connected to server");
      return;
     }//*/

   datetime data_teste=TimeCurrent();

   MqlDateTime data_teste_str;
   TimeToStruct(data_teste,data_teste_str);

   if(((data_teste_str.hour>=23)&&(data_teste_str.min>=40))&&(data_teste_str.hour<24))
     {
      for(int A=0; A<Strategy_A; A++)
        {
         Print("Symbol= ",Symbol_A[A]);
         //--- A.1: Check if trading is enable for the symbol
         if((IsTrade_A[A]==false))
           {
            Print(Symbol_A[A], " trading not enabled");
            continue;
           }

         //If the action wasn't executed for this symbol
         if(LastActionTime[A]!=Time[0])
           {
            Print("Indicators calculations for ",Symbol_A[A]);
            RefreshRates();
            while(!download_history(PERIOD_D1, Symbol_A[A]))
              {
               Sleep(1000);
               RefreshRates();
              }

            //Read indicator data
            //--- C1
            //Confirmation 1
            // CHANGE HERE: C1 INDICATOR DATA. We usually need some past data, the diference between those lines are Matrix Indice and 
            // shift on iCustom (last parameter).
            i_azul[A][0]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,0)-1;
            i_azul[A][1]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,1)-1;
            i_azul[A][2]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,2)-1;
            i_azul[A][3]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,3)-1;
            i_azul[A][4]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,4)-1;

            //--- C2
            // CHANGE HERE: C2 INDICATOR DATA
            i2[A][0]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,0);
            i2[A][1]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,1);
            i2[A][2]=iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,2);

            //--- Baseline
            // CHANGE HERE: BASELINE
            bl[A][0]=iCustom(Symbol_A[A],Period_A[A],"167T-NonLagMA_v4",4,15,0,0,0,1,0,0,0);
            bl[A][1]=iCustom(Symbol_A[A],Period_A[A],"167T-NonLagMA_v4",4,15,0,0,0,1,0,0,1);
            bl[A][2]=iCustom(Symbol_A[A],Period_A[A],"167T-NonLagMA_v4",4,15,0,0,0,1,0,0,2);

            //--- Volume
            // CHANGE HERE: VOLUME INDICATOR DATA
            v_azul[A][0]=iCustom(NULL,PERIOD_CURRENT,"V203-volatility-indicator-2",9,0.1,1,0);
            v_azul[A][1]=iCustom(NULL,PERIOD_CURRENT,"V203-volatility-indicator-2",9,0.1,1,0);
            v_azul[A][2]=iCustom(NULL,PERIOD_CURRENT,"V203-volatility-indicator-2",9,0.1,1,1);

            //--- Exit
            // CHANGE HERE: EXIT INDICATOR DATA
            ex[A][0]=iCustom(NULL,PERIOD_CURRENT,"T53-TrendWave_2",10,21,8,0);
            ex[A][1]=iCustom(NULL,PERIOD_CURRENT,"T53-TrendWave_2",10,21,8,1);
            ex[A][2]=iCustom(NULL,PERIOD_CURRENT,"T53-TrendWave_2",10,21,8,2);


            //--- Signal array initialization
            for(int j=0; j<2; j++)
              {
               bl_sig[A][j]=0;
               v_perm[A][j]=0;
               ind2[A][j]=0;
               exit[A][j]=0;
              }

            for(int j=0; j<3; j++)
              {
               ind[A][j]=0;
              }

            // Signal array values

            //--- Confirmation 1

            for(int z=0; z<4; z++)
              {
               // CHANGE HERE: C1 STRATEGY - in this example, the function return 1 when indicator is above 0.0023 and -1
               // when indicator is above 0.0023. The function is defined in the bottom.
               ind[A][z]=strategy_line_cross(i_azul[A][z],0.0023,i_azul[A][z+1],0.0023);
              }

            //--- Confirmation 2
            i2[A][4]=0;
            for(int k=0; k<3; k++)
              {
               // CHANGE HERE: C2 STRATEGY - line cross again, indicator cross 1
               ind2[A][k]=strategy_line_cross(i2[A][k]-1,0,i2[A][k+1]-1,0);
              }

            //--- Baseline
            // CHANGE HERE: BASELINE, actually, is the same as line cross but simpler.
            // Works as VP described
            // 1 is for buy positions, -1 is for sell positions
            bl_sig[A][0]=strategy_mean_cross(bl[A][0],iClose(Symbol_A[A],Period_A[A],0));
            bl_sig[A][1]=strategy_mean_cross(bl[A][1],iClose(Symbol_A[A],Period_A[A],1));
            bl_sig[A][2]=strategy_mean_cross(bl[A][2],iClose(Symbol_A[A],Period_A[A],2));

            //--- Volume
            for(int i=0; i<3; i++)
              {
               // CHANGE HERE: VOLUME - In this case, trade is allowed when the indicator data is different than EMPTY_VALUE
               // 1 is for allowed, 0 is not allowed
               if(v_azul[A][i]!=EMPTY_VALUE)
                  v_perm[A][i]=1;
              }

            //--- Exit
            //  CHANGE HERE: EXIT
            exit[A][0]=(int)ex[A][0];
            exit[A][1]=(int)ex[A][1];
            exit[A][2]=(int)ex[A][2];

            //--- Check if there is NEWS
            //--- Copy the news array corresponding to the current currency pair
            if(StringFind(Symbol_A[A],"USD",0)>-1)
              {
               ArrayCopy(List,List_USD,0,0,WHOLE_ARRAY);
              }

            if(StringFind(Symbol_A[A],"EUR",0)>-1)
              {
               ArrayCopy(List,List_EUR,ArraySize(List),0,WHOLE_ARRAY);
              }
            if(StringFind(Symbol_A[A],"GBP",0)>-1)
              {
               ArrayCopy(List,List_GBP,ArraySize(List),0,WHOLE_ARRAY);
              }

            if(StringFind(Symbol_A[A],"CAD",0)>-1)
              {
               ArrayCopy(List,List_CAD,ArraySize(List),0,WHOLE_ARRAY);
              }
            if(StringFind(Symbol_A[A],"AUD",0)>-1)
              {
               ArrayCopy(List,List_AUD,ArraySize(List),0,WHOLE_ARRAY);
              }
            if(StringFind(Symbol_A[A],"JPY",0)>-1)
              {
               ArrayCopy(List,List_JPY,ArraySize(List),0,WHOLE_ARRAY);
              }
            if(StringFind(Symbol_A[A],"NZD",0)>-1)
              {
               ArrayCopy(List,List_NZD,ArraySize(List),0,WHOLE_ARRAY);
              }
            if(StringFind(Symbol_A[A],"CHF",0)>-1)
              {
               ArrayCopy(List,List_CHF,ArraySize(List),0,WHOLE_ARRAY);
              }

            //--- Get today and tomorrow dates
            // the EA runs before the candle close
            datetime dia1=Tomorrow();
            datetime dia2=After_Tomorrow();

            news=false;

            for(int z=0; z<ArraySize(List); z++)
              {
               if((dia1==List[z])||(dia2==List[z]))
                 {
                  news=true;

                 }

              }
            //--- Current pair signal
            // initialization
            signal[A]=0;


            //--- 1. One Candle Rule
            // happened already, don't inhibit current signal
            // if ind2 or v_perm did'nt allow the trade when ind or bl_sig give the signal,
            // we wait a candle as a second chance
            if(((ind[A][1]!=ind[A][2])&&(ind[A][1]==bl_sig[A][1])&&
                (((ind2[A][1]==ind2[A][2])&&(ind2[A][1]==ind[A][2]))||(v_perm[A][1]==0))&&(MathAbs(bl[A][1]-iClose(Symbol_A[A],Period_A[A],1))<iATR(Symbol_A[A],Period_A[A],14,0)))     //Sinal de ind no candle passado foi bloqueado por ind2 ou por volume
               &&((ind2[A][0]==ind[A][0])&&(v_perm[A][0]==1)&&(ind[A][0]==bl_sig[A][0])&&(ind[A][0]==ind[A][1])&&(MathAbs(bl[A][0]-iClose(Symbol_A[A],Period_A[A],0))<iATR(Symbol_A[A],Period_A[A],14,0))))
              {
               signal[A]=ind[A][0];
               Print("---------- ONE CANDLE RULE Symbol:, ",Symbol_A[A]);
              }

            //--- 2. Continuation trade Condition
            // If the price crosses the baseline, continuation trades are not allowed anymore

            bool continuation_trade=false;
            bool exit_do=false;
            int contador=0;
            bool was_opposite=false;
            bool was_same=false;

            double close=iClose(Symbol_A[A],Period_A[A],contador);
            
            // CHANGE HERE: BASELINE INDICATOR
            // the last part "0,contador);" must remain
            double ma=bl[A][0]=iCustom(Symbol_A[A],Period_A[A],"167T-NonLagMA_v4",4,15,0,0,0,1,0,0,contador);

            if(ind[A][0]!=ind[A][1])
              {
               while(((strategy_mean_cross(ma,close)==ind[A][0])//se bl inverteu no candle "contador", sai do loop
                      ||(!was_opposite&&!was_same))
                     &&(contador<200))
                 {
                  if(!was_opposite)
                    {
                     // CHANGE HERE: CONFIRMATION 1 INDICATOR
                     // The structure: if current signal of C1 != past C1 signal
                     // if (ind[A][0]!=strategy_line_cross(iCustom(..., contador)-1,0.0023, iCustom(..., contador+1)-1,0.0023))
                     if(ind[A][0]!=strategy_line_cross(iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,contador)-1,0.0023,iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,contador+1)-1,0.0023))
                       {
                        was_opposite=true;
                        Print("foi oposto= ",Time[contador]);
                       }
                    }
                  if(was_opposite)
                    {
                    // CHANGE HERE: CONFIRMATION 1 INDICATOR
                     if(ind[A][0]==strategy_line_cross(iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,contador)-1,0.0023,iCustom(Symbol_A[A],Period_A[A],"259T-XaosExplore_PerkyMod",20,false,true,1.0023, 0.9979,0,contador+1)-1,0.0023))
                       {
                        was_same=true;
                        Print("foi igual= ",Time[contador]);
                       }
                    }
                  contador++;
                  close=iClose(Symbol_A[A],Period_A[A],contador);
                  // CHANGE HERE: BASELINE INDICATOR
                  ma=bl[A][0]=iCustom(Symbol_A[A],Period_A[A],"167T-NonLagMA_v4",4,15,0,0,0,1,0,0,contador);
                 }
              }//*/

            if(was_same&&was_opposite)
               continuation_trade=true;


            //Continuation trades bypass Volume indicator and distance between price and BL
            if(continuation_trade)
              {
               if((bl_sig[A][0]==bl_sig[A][1])&&(bl_sig[A][0]==bl_sig[A][2]))
                 {
                  if((ind[A][0]!=ind[A][1])&&
                     (ind[A][0]==bl_sig[A][0])&&
                     (ind[A][0]==ind2[A][0]))
                    {
                     signal[A]=ind[A][0];
                     Print("---------- CONTINUATION Symbol:, ",Symbol_A[A]);
                    }
                 }
              }


            //---3. Pullback
            if(((bl_sig[A][1]!=bl_sig[A][2]))&&   //1.0 BL or C1 inversion 
               (ind[A][1]==bl_sig[A][1])&&
               (ind2[A][1]==bl_sig[A][1])&&
               (v_perm[A][1]==1)&&
               (MathAbs(bl[A][1]-iClose(Symbol_A[A],Period_A[A],1))>iATR(Symbol_A[A],Period_A[A],14,2))) // Incoming signal by BL crossing, but price was too far from BL
              {
               Print("------- Price is too far from BL Symbol:, ",Symbol_A[A]);
               if((bl_sig[A][0]==bl_sig[A][1])&&
                  (ind[A][0]==bl_sig[A][0])&&
                  (ind2[A][0]==ind[A][0])&&
                  (v_perm[A][0]==1)&&
                  (MathAbs(bl[A][0]-iClose(Symbol_A[A],Period_A[A],0))<=iATR(Symbol_A[A],Period_A[A],14,0)))
                 {
                  signal[A]=bl_sig[A][0];
                  Print("---------- PULLBACK Symbol:, ",Symbol_A[A]);
                 }
              }


            //---4. Ordinary signal
            if(((bl_sig[A][0]!=bl_sig[A][1])||(ind[A][0]!=ind[A][1]))&&   //1.0 BL or C1 inversion
               (ind[A][0]==bl_sig[A][0])&&
               (ind2[A][0]==ind[A][0])&&
               (v_perm[A][0]==1))
              {
               if(MathAbs(bl[A][0]-iClose(Symbol_A[A],Period_A[A],0))<=iATR(Symbol_A[A],Period_A[A],14,0))
                 {
                  signal[A]=ind[A][0];

                  Print("---------- Ordinary trade signal for Symbol:, ",Symbol_A[A]);
                  Print("ATR= ",iATR(Symbol_A[A],Period_A[A],14,0));
                  Print("MathAbs(bl[0]-Close[1])= ",MathAbs(bl[A][0]-iClose(Symbol_A[A],Period_A[A],0)));
                  Print("(bl_sig[0]!=bl_sig[1])= ",(bl_sig[A][0]!=bl_sig[A][1]));
                  Print("(ind[0]!=ind[1])= ",(ind[A][0]!=ind[A][1]));
                 }
              }

            // Log
            Print("___",Symbol_A[A],"___");
            Print("iTime= ",iTime(Symbol_A[A], PERIOD_H1, 0));
            Print("Signal= ",signal[A]);
            Print("v_perm[0]= ",v_perm[A][0]);
            Print("bl_sig[0]= ",bl_sig[A][0]);
            Print("ind[0]= ",ind[A][0]);
            Print("ind2[0]= ",ind2[A][0]);
            Print("exit[0]= ",exit[A][0]);
            Print("Atr= ",iATR(Symbol_A[A],Period_A[A],14,0));
            Print("Close[0]= ",iClose(Symbol_A[A],Period_A[A],0));
            Print("_____________________");



            //-- NEWS:
            if(news)
              {
               signal[A] = 0;
               if((array_open_orders(Symbol_A[A])==2))
                 {
                  exit[A][0]=-ind[A][0];
                 }
               if((array_open_orders(Symbol_A[A])==1))
                 {

                  for(int order_id=0; order_id<OrdersTotal(); order_id++)
                    {
                     bool check=OrderSelect(order_id,SELECT_BY_POS,MODE_TRADES);

                       {
                        if((MarketInfo(Symbol_A[A],MODE_BID)-OrderOpenPrice()>(MarketInfo(Symbol_A[A],MODE_ASK)+iATR(Symbol_A[A],Period_A[A],14,0)))&&(OrderType()==OP_BUY))
                           exit[A][0]=-ind[A][0];
                        if(((OrderOpenPrice()-MarketInfo(Symbol_A[A],MODE_ASK))>(MarketInfo(Symbol_A[A],MODE_BID)-iATR(Symbol_A[A],Period_A[A],14,0)))&&(OrderType()==OP_SELL))
                           exit[A][0]=-ind[A][0];
                       }
                    }
                 }
              }
            // If signal == 0, the EA is not going to create orders or recalculate signals
            if(signal[A]==0)
               LastActionTime[A]=Time[0];
           }

         //-----------------------------------------------------------------------------------------
         //-- EXIT:
         if(Exit_hold[A]!=Time[0])
           {
            if((array_open_orders(Symbol_A[A])>0))
              {
               for(int order_id=0; order_id<OrdersTotal(); order_id++)
                 {
                  bool check_exit=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
                  if(!check_exit)
                    {
                     Print("E3. OrderSelect returned the error of ",GetLastError());
                     Print("Order Id= ",order_id);
                     continue;
                    }

                  if(OrderSymbol()==Symbol_A[A])
                    {
                     if(((OrderType()==OP_BUY)&&((ind[A][0]==-1)||(bl_sig[A][0]==-1)||(exit[A][0]==-1))))
                       {
                        bool cu=OrderClose(OrderTicket(),OrderLots(),MarketInfo(Symbol_A[A],MODE_BID),100,clrNONE);
                        if(!cu)
                           Print("E1. OrderClose returned the error of ",GetLastError());
                       }
                     if((OrderType()==OP_SELL)&&((ind[A][0]==1)||(bl_sig[A][0]==1)||(exit[A][0]==1)))
                       {
                        bool cu=OrderClose(OrderTicket(),OrderLots(),MarketInfo(Symbol_A[A],MODE_BID),100,clrNONE);
                        if(!cu)
                           Print("E2. OrderClose returned the error of ",GetLastError());
                       }
                    }
                 }
              }

           }
        }//END LOOP

      //---- Check signals to split risk
      datetime data_atual=TimeCurrent();

      MqlDateTime data_atual_str;
      TimeToStruct(data_atual,data_atual_str);

      //Orders are placed between 23:40 and 00:00
      if(((data_atual_str.hour>=23)&&(data_atual_str.min>=40))&&(data_atual_str.hour<24))
        {

         // Check if there are open positions that not hit 1st TP
         for(int A=0; A<Strategy_A; A++)
           {

            if(LastActionTime[A]==Time[0])
              {
               continue;
              }

            ZeroMemory(open_orders_array);

            if(IsTrade_A[A]==false)
               continue;

            if(array_open_orders(Symbol_A[A])==1)
              {
               Sleep(2000);
               for(int order_id=0; order_id<OrdersTotal(); order_id++)
                 {

                  bool check_trail=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
                  if(!check_trail)
                    {
                     Print("E5. OrderSelect returned the error of ",GetLastError());
                     Print("Order Id= ",order_id);
                     continue;
                    }

                  if(OrderSymbol()==Symbol_A[A])
                    {
                     if(OrderType()==OP_BUY)
                       {
                        open_orders_array[A]=1;
                       }
                     else
                       {
                        if(OrderType()==OP_SELL)
                          {
                           open_orders_array[A]=-1;
                          }
                       }
                    }
                 }
              }
            switch(open_orders_array[A])
              {
               case 1:
                  open_orders_array[A]=0;
                  break;
               case 2:
                  open_orders_array[A]=1;
                  signal[A]=0;
                  break;
               case -1:
                  open_orders_array[A]=0;
                  signal[A]=0;
                  break;
               case -2:
                  open_orders_array[A]=-1;
                  break;
              }
           }

         // Get position matrix:
         // 1 buy, -1 sell
         //       0   1   2   3   4   5   6   7
         //      AUD CAD CHF EUR GBP JPY NZD USD
         //0 AUD  0   1   1   1   1   1   1   1
         //1 CAD -1   0   1   1   1   1   1   1
         //2 CHF -1  -1   0   1   1   1   1   1
         //3 EUR -1  -1  -1   0   1   1   1   1
         //4 GBP -1  -1  -1  -1   0   1   1   1
         //5 JPY -1  -1  -1  -1  -1   0   1   1
         //6 NZD -1  -1  -1  -1  -1  -1   0   1
         //7 USD -1  -1  -1  -1  -1  -1  -1   0

         // Risk matrix
         // same structure as above, values are Risk at each currency

         // signal[] array order:
         //EURUSD GBPUSD USDJPY USDCHF USDCAD AUDCAD AUDCHF AUDJPY AUDNZD AUDUSD CADCHF CADJPY CHFJPY EURAUD
         //EURCAD EURGBP EURJPY EURNZD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD NZDCAD NZDCHF NZDJPY NZDUSD

         //EURUSD
         M_positions[3][7]=signal[0];
         M_positions[7][3]=-signal[0];

         M_risk[3][7]=0;
         M_risk[7][3]=0;

         if(array_open_orders("EURUSD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="EURUSD")
                 {
                  Print("Posicao em EURUSD");
                  Print("Risco em EURUSD= ",(1/MarketInfo("EURUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURUSD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[3][7]=(1/MarketInfo("EURUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURUSD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[7][3]=-(1/MarketInfo("EURUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURUSD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }

         //GBPUSD
         M_positions[4][7]=signal[1];
         M_positions[7][4]=-signal[1];

         M_risk[4][7]=0;
         M_risk[7][4]=0;

         if(array_open_orders("GBPUSD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="GBPUSD")
                 {
                  Print("Posicao em GBPUSD");
                  Print("Risco em GBPUSD= ",(1/MarketInfo("GBPUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPUSD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[4][7]=(1/MarketInfo("GBPUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPUSD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[7][4]=-(1/MarketInfo("GBPUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPUSD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //USDJPY
         M_positions[7][5]=signal[2];
         M_positions[5][7]=-signal[2];

         M_risk[7][5]=0;
         M_risk[5][7]=0;

         if(array_open_orders("USDJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="USDJPY")
                 {
                  Print("Posicao em USDJPY");
                  Print("Risco em USDJPY= ",(1/MarketInfo("USDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[7][5]=(1/MarketInfo("USDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[5][7]=-(1/MarketInfo("USDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //USDCHF
         M_positions[7][2]=signal[3];
         M_positions[2][7]=-signal[3];

         M_risk[7][2]=0;
         M_risk[2][7]=0;

         if(array_open_orders("USDCHF")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="USDCHF")
                 {
                  Print("Posicao em USDCHF");
                  Print("Risco em USDCHF= ",(1/MarketInfo("USDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDCHF",MODE_TICKVALUE)/AccountBalance());
                  M_risk[7][2]=(1/MarketInfo("USDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDCHF",MODE_TICKVALUE)/AccountBalance();
                  M_risk[2][7]=-(1/MarketInfo("USDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDCHF",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //USDCAD
         M_positions[7][1]=signal[4];
         M_positions[1][7]=-signal[4];

         M_risk[7][1]=0;
         M_risk[1][7]=0;

         if(array_open_orders("USDCAD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="USDCAD")
                 {
                  Print("Posicao em USDCAD");
                  Print("Risco em USDCAD= ",(1/MarketInfo("USDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDCAD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[7][1]=(1/MarketInfo("USDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDCAD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[1][7]=-(1/MarketInfo("USDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("USDCAD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //AUDCAD
         M_positions[0][1]=signal[5];
         M_positions[1][0]=-signal[5];

         M_risk[0][1]=0;
         M_risk[1][0]=0;

         if(array_open_orders("AUDCAD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="AUDCAD")
                 {
                  Print("Posicao em AUDCAD");
                  Print("Risco em AUDCAD= ",(1/MarketInfo("AUDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDCAD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[0][1]=(1/MarketInfo("AUDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDCAD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[1][0]=-(1/MarketInfo("AUDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDCAD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //AUDCHF
         M_positions[0][2]=signal[6];
         M_positions[2][0]=-signal[6];

         M_risk[0][2]=0;
         M_risk[2][0]=0;

         if(array_open_orders("AUDCHF")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="AUDCHF")
                 {
                  Print("Posicao em AUDCHF");
                  Print("Risco em AUDCHF= ",(1/MarketInfo("AUDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDCHF",MODE_TICKVALUE)/AccountBalance());
                  M_risk[0][2]=(1/MarketInfo("AUDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDCHF",MODE_TICKVALUE)/AccountBalance();
                  M_risk[2][0]=-(1/MarketInfo("AUDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDCHF",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //AUDJPY
         M_positions[0][5]=signal[7];
         M_positions[5][0]=-signal[7];

         M_risk[0][5]=0;
         M_risk[5][0]=0;

         if(array_open_orders("AUDJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="AUDJPY")
                 {
                  Print("Posicao em AUDJPY");
                  Print("Risco em AUDJPY= ",(1/MarketInfo("AUDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[0][5]=(1/MarketInfo("AUDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[5][0]=-(1/MarketInfo("AUDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //AUDNZD
         M_positions[0][6]=signal[8];
         M_positions[6][0]=-signal[8];

         M_risk[0][6]=0;
         M_risk[6][0]=0;

         if(array_open_orders("AUDNZD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="AUDNZD")
                 {
                  Print("Posicao em AUDNZD");
                  Print("Risco em AUDNZD= ",(1/MarketInfo("AUDNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDNZD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[0][6]=(1/MarketInfo("AUDNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDNZD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[6][0]=-(1/MarketInfo("AUDNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDNZD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }

         //AUDUSD
         M_positions[0][7]=signal[9];
         M_positions[7][0]=-signal[9];

         M_risk[0][7]=0;
         M_risk[7][0]=0;

         if(array_open_orders("AUDUSD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="AUDUSD")
                 {
                  Print("Posicao em AUDUSD");
                  Print("Risco em AUDUSD= ",(1/MarketInfo("AUDUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDUSD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[0][7]=(1/MarketInfo("AUDUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDUSD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[7][0]=-(1/MarketInfo("AUDUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("AUDUSD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //CADCHF
         M_positions[1][2]=signal[10];
         M_positions[2][1]=-signal[10];

         M_risk[1][2]=0;
         M_risk[2][1]=0;

         if(array_open_orders("CADCHF")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="CADCHF")
                 {
                  Print("Posicao em CADCHF");
                  Print("Risco em CADCHF= ",(1/MarketInfo("CADCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CADCHF",MODE_TICKVALUE)/AccountBalance());
                  M_risk[1][2]=(1/MarketInfo("CADCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CADCHF",MODE_TICKVALUE)/AccountBalance();
                  M_risk[2][1]=-(1/MarketInfo("CADCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CADCHF",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //CADJPY
         M_positions[1][5]=signal[11];
         M_positions[5][1]=-signal[11];

         M_risk[1][5]=0;
         M_risk[5][1]=0;

         if(array_open_orders("CADJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="CADJPY")
                 {
                  Print("Posicao em CADJPY");
                  Print("Risco em CADJPY= ",(1/MarketInfo("CADJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CADJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[5][1]=(1/MarketInfo("CADJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CADJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[1][5]=-(1/MarketInfo("CADJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CADJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //CHFJPY
         M_positions[2][5]=signal[12];
         M_positions[5][2]=-signal[12];

         M_risk[2][5]=0;
         M_risk[5][2]=0;

         if(array_open_orders("CHFJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="CHFJPY")
                 {
                  Print("Posicao em CHFJPY");
                  Print("Risco em CHFJPY= ",(1/MarketInfo("CHFJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CHFJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[2][5]=(1/MarketInfo("CHFJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CHFJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[5][2]=-(1/MarketInfo("CHFJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("CHFJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //EURAUD
         M_positions[3][0]=signal[13];
         M_positions[0][3]=-signal[13];

         M_risk[3][0]=0;
         M_risk[0][3]=0;

         if(array_open_orders("EURAUD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="EURAUD")
                 {
                  Print("Posicao em EURAUD");
                  Print("Risco em EURAUD= ",(1/MarketInfo("EURAUD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURAUD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[3][0]=(1/MarketInfo("EURAUD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURAUD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[0][3]=-(1/MarketInfo("EURAUD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURAUD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //EURCAD
         M_positions[3][1]=signal[14];
         M_positions[1][3]=-signal[14];

         M_risk[3][1]=0;
         M_risk[1][3]=0;

         if(array_open_orders("EURCAD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="EURCAD")
                 {
                  Print("Posicao em EURCAD");
                  Print("Risco em EURCAD= ",(1/MarketInfo("EURCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURCAD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[3][1]=(1/MarketInfo("EURCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURCAD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[1][3]=-(1/MarketInfo("EURCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURCAD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //EURGBP
         M_positions[3][4]=signal[15];
         M_positions[4][3]=-signal[15];

         M_risk[3][4]=0;
         M_risk[4][3]=0;

         if(array_open_orders("EURGBP")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="EURGBP")
                 {
                  Print("Posicao em EURGBP");
                  Print("Risco em EURGBP= ",(1/MarketInfo("EURGBP",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURGBP",MODE_TICKVALUE)/AccountBalance());
                  M_risk[3][4]=(1/MarketInfo("EURGBP",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURGBP",MODE_TICKVALUE)/AccountBalance();
                  M_risk[4][3]=-(1/MarketInfo("EURGBP",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURGBP",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //EURJPY
         M_positions[3][5]=signal[16];
         M_positions[5][3]=-signal[16];

         M_risk[3][5]=0;
         M_risk[5][3]=0;

         if(array_open_orders("EURJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="EURJPY")
                 {
                  Print("Posicao em EURJPY");
                  Print("Risco em EURJPY= ",(1/MarketInfo("EURJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[3][5]=(1/MarketInfo("EURJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[5][3]=-(1/MarketInfo("EURJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //EURNZD
         M_positions[3][6]=signal[17];
         M_positions[6][3]=-signal[17];

         M_risk[3][6]=0;
         M_risk[6][3]=0;

         if(array_open_orders("EURNZD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="EURNZD")
                 {
                  Print("Posicao em EURNZD");
                  Print("Risco em EURNZD= ",(1/MarketInfo("EURNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURNZD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[3][6]=(1/MarketInfo("EURNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURNZD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[6][3]=-(1/MarketInfo("EURNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("EURNZD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //GBPAUD
         M_positions[4][0]=signal[18];
         M_positions[0][4]=-signal[18];

         M_risk[4][0]=0;
         M_risk[0][4]=0;

         if(array_open_orders("GBPAUD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="GBPAUD")
                 {
                  Print("Posicao em GBPAUD");
                  Print("Risco em GBPAUD= ",(1/MarketInfo("GBPAUD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPAUD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[4][0]=(1/MarketInfo("GBPAUD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPAUD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[0][4]=-(1/MarketInfo("GBPAUD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPAUD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //GBPCAD
         M_positions[4][1]=signal[19];
         M_positions[1][4]=-signal[19];

         M_risk[4][1]=0;
         M_risk[1][4]=0;

         if(array_open_orders("GBPCAD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="GBPCAD")
                 {
                  Print("Posicao em GBPCAD");
                  Print("Risco em GBPCAD= ",(1/MarketInfo("GBPCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPCAD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[4][1]=(1/MarketInfo("GBPCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPCAD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[1][4]=-(1/MarketInfo("GBPCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPCAD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //GBPCHF
         M_positions[4][2]=signal[20];
         M_positions[2][4]=-signal[20];

         M_risk[4][2]=0;
         M_risk[2][4]=0;

         if(array_open_orders("GBPCHF")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="GBPCHF")
                 {
                  Print("Posicao em GBPCHF");
                  Print("Risco em GBPCHF= ",(1/MarketInfo("GBPCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPCHF",MODE_TICKVALUE)/AccountBalance());
                  M_risk[4][2]=(1/MarketInfo("GBPCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPCHF",MODE_TICKVALUE)/AccountBalance();
                  M_risk[2][4]=-(1/MarketInfo("GBPCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPCHF",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //GBPJPY
         M_positions[4][5]=signal[21];
         M_positions[5][4]=-signal[21];

         M_risk[4][5]=0;
         M_risk[5][4]=0;

         if(array_open_orders("GBPJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="GBPJPY")
                 {
                  Print("Posicao em GBPJPY");
                  Print("Risco em GBPJPY= ",(1/MarketInfo("GBPJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[4][5]=(1/MarketInfo("GBPJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[5][4]=-(1/MarketInfo("GBPJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }

         //GBPNZD
         M_positions[4][6]=signal[22];
         M_positions[6][4]=-signal[22];

         M_risk[4][6]=0;
         M_risk[6][4]=0;

         if(array_open_orders("GBPNZD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="GBPNZD")
                 {
                  Print("Posicao em GBPNZD");
                  Print("Risco em GBPNZD= ",(1/MarketInfo("GBPNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPNZD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[4][6]=(1/MarketInfo("GBPNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPNZD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[6][4]=-(1/MarketInfo("GBPNZD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("GBPNZD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //NZDCAD
         M_positions[6][1]=signal[23];
         M_positions[1][6]=-signal[23];

         M_risk[6][1]=0;
         M_risk[1][6]=0;

         if(array_open_orders("NZDCAD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="NZDCAD")
                 {
                  Print("Posicao em NZDCAD");
                  Print("Risco em NZDCAD= ",(1/MarketInfo("NZDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDCAD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[6][1]=(1/MarketInfo("NZDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDCAD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[1][6]=-(1/MarketInfo("NZDCAD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDCAD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //NZDCHF
         M_positions[6][2]=signal[24];
         M_positions[2][6]=-signal[24];

         M_risk[6][2]=0;
         M_risk[2][6]=0;

         if(array_open_orders("NZDCHF")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="NZDCHF")
                 {
                  Print("Posicao em NZDCHF");
                  Print("Risco em NZDCHF= ",(1/MarketInfo("NZDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDCHF",MODE_TICKVALUE)/AccountBalance());
                  M_risk[6][2]=(1/MarketInfo("NZDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDCHF",MODE_TICKVALUE)/AccountBalance();
                  M_risk[2][6]=-(1/MarketInfo("NZDCHF",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDCHF",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //NZDJPY
         M_positions[6][5]=signal[25];
         M_positions[5][6]=-signal[25];

         M_risk[6][5]=0;
         M_risk[5][6]=0;

         if(array_open_orders("NZDJPY")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="NZDJPY")
                 {
                  Print("Posicao em NZDJPY");
                  Print("Risco em NZDJPY= ",(1/MarketInfo("NZDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDJPY",MODE_TICKVALUE)/AccountBalance());
                  M_risk[6][5]=(1/MarketInfo("NZDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDJPY",MODE_TICKVALUE)/AccountBalance();
                  M_risk[5][6]=-(1/MarketInfo("NZDJPY",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDJPY",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }
         //NZDUSD
         M_positions[6][7]=signal[26];
         M_positions[7][6]=-signal[26];

         M_risk[6][7]=0;
         M_risk[7][6]=0;

         if(array_open_orders("NZDUSD")==2)
           {
            for(int order_id=0; order_id<OrdersTotal(); order_id++)
              {
               bool check_M_risk=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
               if(OrderSymbol()=="NZDUSD")
                 {
                  Print("Posicao em NZDUSD");
                  Print("Risco em NZDUSD= ",(1/MarketInfo("NZDUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDUSD",MODE_TICKVALUE)/AccountBalance());
                  M_risk[6][7]=(1/MarketInfo("NZDUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDUSD",MODE_TICKVALUE)/AccountBalance();
                  M_risk[7][6]=-(1/MarketInfo("NZDUSD",MODE_POINT))*2*OrderLots()*MathAbs(OrderStopLoss()-OrderOpenPrice())*MarketInfo("NZDUSD",MODE_TICKVALUE)/AccountBalance();
                 }
              }
           }

         ZeroMemory(positions_divider);

         //for(int i=0; i<8; i++)

         double r1=0, r2=0;

         //EURUSD
         positions_divider[0]=MathMax(MathAbs(M_positions[3][0]+M_positions[3][1]+M_positions[3][2]+M_positions[3][3]+M_positions[3][4]+M_positions[3][5]+M_positions[3][6]+M_positions[3][7]),
                                     MathAbs(M_positions[0][7]+M_positions[1][7]+M_positions[2][7]+M_positions[3][7]+M_positions[4][7]+M_positions[5][7]+M_positions[6][7]+M_positions[7][7]));

         r1= M_risk[3][0]+M_risk[3][1]+M_risk[3][2]+M_risk[3][3]+M_risk[3][4]+M_risk[3][5]+M_risk[3][6]+M_risk[3][7];
         r2= M_risk[0][7]+M_risk[1][7]+M_risk[2][7]+M_risk[3][7]+M_risk[4][7]+M_risk[5][7]+M_risk[6][7]+M_risk[7][7];

         current_risk_BUY[0]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[0]=MathMin(MathMin(r1,r2),0);

         //GBPUSD
         positions_divider[1]=MathMax(MathAbs(M_positions[4][0]+M_positions[4][1]+M_positions[4][2]+M_positions[4][3]+M_positions[4][4]+M_positions[4][5]+M_positions[4][6]+M_positions[4][7]),
                                     MathAbs(M_positions[0][7]+M_positions[1][7]+M_positions[2][7]+M_positions[3][7]+M_positions[4][7]+M_positions[5][7]+M_positions[6][7]+M_positions[7][7]));

         r1= M_risk[4][0]+M_risk[4][1]+M_risk[4][2]+M_risk[4][3]+M_risk[4][4]+M_risk[4][5]+M_risk[4][6]+M_risk[4][7];
         r2= M_risk[0][7]+M_risk[1][7]+M_risk[2][7]+M_risk[3][7]+M_risk[4][7]+M_risk[5][7]+M_risk[6][7]+M_risk[7][7];

         current_risk_BUY[1]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[1]=MathMin(MathMin(r1,r2),0);

         //USDJPY
         positions_divider[2]=MathMax(MathAbs(M_positions[7][0]+M_positions[7][1]+M_positions[7][2]+M_positions[7][3]+M_positions[7][4]+M_positions[7][5]+M_positions[7][6]+M_positions[7][7]),
                                     MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));

         r1= M_risk[7][0]+M_risk[7][1]+M_risk[7][2]+M_risk[7][3]+M_risk[7][4]+M_risk[7][5]+M_risk[7][6]+M_risk[7][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[2]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[2]=MathMin(MathMin(r1,r2),0);

         //USDCHF
         positions_divider[3]=MathMax(MathAbs(M_positions[7][0]+M_positions[7][1]+M_positions[7][2]+M_positions[7][3]+M_positions[7][4]+M_positions[7][5]+M_positions[7][6]+M_positions[7][7]),
                                     MathAbs(M_positions[0][2]+M_positions[1][2]+M_positions[2][2]+M_positions[3][2]+M_positions[4][2]+M_positions[5][2]+M_positions[6][2]+M_positions[7][2]));

         r1= M_risk[7][0]+M_risk[7][1]+M_risk[7][2]+M_risk[7][3]+M_risk[7][4]+M_risk[7][5]+M_risk[7][6]+M_risk[7][7];
         r2= M_risk[0][2]+M_risk[1][2]+M_risk[2][2]+M_risk[3][2]+M_risk[4][2]+M_risk[5][2]+M_risk[6][2]+M_risk[7][2];

         current_risk_BUY[3]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[3]=MathMin(MathMin(r1,r2),0);

         //USDCAD
         positions_divider[4]=MathMax(MathAbs(M_positions[7][0]+M_positions[7][1]+M_positions[7][2]+M_positions[7][3]+M_positions[7][4]+M_positions[7][5]+M_positions[7][6]+M_positions[7][7]),
                                     MathAbs(M_positions[0][1]+M_positions[1][1]+M_positions[2][1]+M_positions[3][1]+M_positions[4][1]+M_positions[5][1]+M_positions[6][1]+M_positions[7][1]));

         r1= M_risk[7][0]+M_risk[7][1]+M_risk[7][2]+M_risk[7][3]+M_risk[7][4]+M_risk[7][5]+M_risk[7][6]+M_risk[7][7];
         r2= M_risk[0][1]+M_risk[1][1]+M_risk[2][1]+M_risk[3][1]+M_risk[4][1]+M_risk[5][1]+M_risk[6][1]+M_risk[7][1];

         current_risk_BUY[4]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[4]=MathMin(MathMin(r1,r2),0);


         //AUDCAD
         positions_divider[5]=MathMax(MathAbs(M_positions[0][0]+M_positions[0][1]+M_positions[0][2]+M_positions[0][3]+M_positions[0][4]+M_positions[0][5]+M_positions[0][6]+M_positions[0][7]),
                                     MathAbs(M_positions[0][1]+M_positions[1][1]+M_positions[2][1]+M_positions[3][1]+M_positions[4][1]+M_positions[5][1]+M_positions[6][1]+M_positions[7][1]));

         r1= M_risk[0][0]+M_risk[0][1]+M_risk[0][2]+M_risk[0][3]+M_risk[0][4]+M_risk[0][5]+M_risk[0][6]+M_risk[0][7];
         r2= M_risk[0][1]+M_risk[1][1]+M_risk[2][1]+M_risk[3][1]+M_risk[4][1]+M_risk[5][1]+M_risk[6][1]+M_risk[7][1];

         current_risk_BUY[5]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[5]=MathMin(MathMin(r1,r2),0);


         //AUDCHF
         positions_divider[6]=MathMax(MathAbs(M_positions[0][0]+M_positions[0][1]+M_positions[0][2]+M_positions[0][3]+M_positions[0][4]+M_positions[0][5]+M_positions[0][6]+M_positions[0][7]),
                                     MathAbs(M_positions[0][2]+M_positions[1][2]+M_positions[2][2]+M_positions[3][2]+M_positions[4][2]+M_positions[5][2]+M_positions[6][2]+M_positions[7][2]));

         r1= M_risk[0][0]+M_risk[0][1]+M_risk[0][2]+M_risk[0][3]+M_risk[0][4]+M_risk[0][5]+M_risk[0][6]+M_risk[0][7];
         r2= M_risk[0][2]+M_risk[1][2]+M_risk[2][2]+M_risk[3][2]+M_risk[4][2]+M_risk[5][2]+M_risk[6][2]+M_risk[7][2];

         current_risk_BUY[6]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[6]=MathMin(MathMin(r1,r2),0);

         //AUDJPY
         positions_divider[7]=MathMax(MathAbs(M_positions[0][0]+M_positions[0][1]+M_positions[0][2]+M_positions[0][3]+M_positions[0][4]+M_positions[0][5]+M_positions[0][6]+M_positions[0][7]),
                                     MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));

         r1= M_risk[0][0]+M_risk[0][1]+M_risk[0][2]+M_risk[0][3]+M_risk[0][4]+M_risk[0][5]+M_risk[0][6]+M_risk[0][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[7]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[7]=MathMin(MathMin(r1,r2),0);


         //AUDNZD
         positions_divider[8]=MathMax(MathAbs(M_positions[0][0]+M_positions[0][1]+M_positions[0][2]+M_positions[0][3]+M_positions[0][4]+M_positions[0][5]+M_positions[0][6]+M_positions[0][7]),
                                     MathAbs(M_positions[0][6]+M_positions[1][6]+M_positions[2][6]+M_positions[3][6]+M_positions[4][6]+M_positions[5][6]+M_positions[6][6]+M_positions[7][6]));

         r1= M_risk[0][0]+M_risk[0][1]+M_risk[0][2]+M_risk[0][3]+M_risk[0][4]+M_risk[0][5]+M_risk[0][6]+M_risk[0][7];
         r2= M_risk[0][6]+M_risk[1][6]+M_risk[2][6]+M_risk[3][6]+M_risk[4][6]+M_risk[5][6]+M_risk[6][6]+M_risk[7][6];

         current_risk_BUY[8]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[8]=MathMin(MathMin(r1,r2),0);


         //AUDUSD
         positions_divider[9]=MathMax(MathAbs(M_positions[0][0]+M_positions[0][1]+M_positions[0][2]+M_positions[0][3]+M_positions[0][4]+M_positions[0][5]+M_positions[0][6]+M_positions[0][7]),
                                     MathAbs(M_positions[0][7]+M_positions[1][7]+M_positions[2][7]+M_positions[3][7]+M_positions[4][7]+M_positions[5][7]+M_positions[6][7]+M_positions[7][7]));

         r1= M_risk[0][0]+M_risk[0][1]+M_risk[0][2]+M_risk[0][3]+M_risk[0][4]+M_risk[0][5]+M_risk[0][6]+M_risk[0][7];
         r2= M_risk[0][7]+M_risk[1][7]+M_risk[2][7]+M_risk[3][7]+M_risk[4][7]+M_risk[5][7]+M_risk[6][7]+M_risk[7][7];

         current_risk_BUY[9]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[9]=MathMin(MathMin(r1,r2),0);


         //CADCHF
         positions_divider[10]=MathMax(MathAbs(M_positions[1][0]+M_positions[1][1]+M_positions[1][2]+M_positions[1][3]+M_positions[1][4]+M_positions[1][5]+M_positions[1][6]+M_positions[1][7]),
                                      MathAbs(M_positions[0][2]+M_positions[1][2]+M_positions[2][2]+M_positions[3][2]+M_positions[4][2]+M_positions[5][2]+M_positions[6][2]+M_positions[7][2]));

         r1= M_risk[1][0]+M_risk[1][1]+M_risk[1][2]+M_risk[1][3]+M_risk[1][4]+M_risk[1][5]+M_risk[1][6]+M_risk[1][7];
         r2= M_risk[0][2]+M_risk[1][2]+M_risk[2][2]+M_risk[3][2]+M_risk[4][2]+M_risk[5][2]+M_risk[6][2]+M_risk[7][2];

         current_risk_BUY[10]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[10]=MathMin(MathMin(r1,r2),0);

         //CADJPY
         positions_divider[11]=MathMax(MathAbs(M_positions[1][0]+M_positions[1][1]+M_positions[1][2]+M_positions[1][3]+M_positions[1][4]+M_positions[1][5]+M_positions[1][6]+M_positions[1][7]),
                                      MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));

         r1= M_risk[1][0]+M_risk[1][1]+M_risk[1][2]+M_risk[1][3]+M_risk[1][4]+M_risk[1][5]+M_risk[1][6]+M_risk[1][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[11]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[11]=MathMin(MathMin(r1,r2),0);

         //CHFJPY
         positions_divider[12]=MathMax(MathAbs(M_positions[2][0]+M_positions[2][1]+M_positions[2][2]+M_positions[2][3]+M_positions[2][4]+M_positions[2][5]+M_positions[2][6]+M_positions[2][7]),
                                      MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));

         r1= M_risk[2][0]+M_risk[2][1]+M_risk[2][2]+M_risk[2][3]+M_risk[2][4]+M_risk[2][5]+M_risk[2][6]+M_risk[2][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[12]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[12]=MathMin(MathMin(r1,r2),0);

         //EURAUD
         positions_divider[13]=MathMax(MathAbs(M_positions[3][0]+M_positions[3][1]+M_positions[3][2]+M_positions[3][3]+M_positions[3][4]+M_positions[3][5]+M_positions[3][6]+M_positions[3][7]),
                                      MathAbs(M_positions[0][0]+M_positions[1][0]+M_positions[2][0]+M_positions[3][0]+M_positions[4][0]+M_positions[5][0]+M_positions[6][0]+M_positions[7][0]));

         r1= M_risk[3][0]+M_risk[3][1]+M_risk[3][2]+M_risk[3][3]+M_risk[3][4]+M_risk[3][5]+M_risk[3][6]+M_risk[3][7];
         r2= M_risk[0][0]+M_risk[1][0]+M_risk[2][0]+M_risk[3][0]+M_risk[4][0]+M_risk[5][0]+M_risk[6][0]+M_risk[7][0];

         current_risk_BUY[13]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[13]=MathMin(MathMin(r1,r2),0);

         //EURCAD
         positions_divider[14]=MathMax(MathAbs(M_positions[3][0]+M_positions[3][1]+M_positions[3][2]+M_positions[3][3]+M_positions[3][4]+M_positions[3][5]+M_positions[3][6]+M_positions[3][7]),
                                      MathAbs(M_positions[0][1]+M_positions[1][1]+M_positions[2][1]+M_positions[3][1]+M_positions[4][1]+M_positions[5][1]+M_positions[6][1]+M_positions[7][1]));

         r1= M_risk[3][0]+M_risk[3][1]+M_risk[3][2]+M_risk[3][3]+M_risk[3][4]+M_risk[3][5]+M_risk[3][6]+M_risk[3][7];
         r2= M_risk[0][1]+M_risk[1][1]+M_risk[2][1]+M_risk[3][1]+M_risk[4][1]+M_risk[5][1]+M_risk[6][1]+M_risk[7][1];

         current_risk_BUY[14]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[14]=MathMin(MathMin(r1,r2),0);

         //EURGBP
         positions_divider[15]=MathMax(MathAbs(M_positions[3][0]+M_positions[3][1]+M_positions[3][2]+M_positions[3][3]+M_positions[3][4]+M_positions[3][5]+M_positions[3][6]+M_positions[3][7]),
                                      MathAbs(M_positions[0][4]+M_positions[1][4]+M_positions[2][4]+M_positions[3][4]+M_positions[4][4]+M_positions[5][4]+M_positions[6][4]+M_positions[7][4]));

         r1= M_risk[3][0]+M_risk[3][1]+M_risk[3][2]+M_risk[3][3]+M_risk[3][4]+M_risk[3][5]+M_risk[3][6]+M_risk[3][7];
         r2= M_risk[0][4]+M_risk[1][4]+M_risk[2][4]+M_risk[3][4]+M_risk[4][4]+M_risk[5][4]+M_risk[6][4]+M_risk[7][4];

         current_risk_BUY[15]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[15]=MathMin(MathMin(r1,r2),0);

         //EURJPY
         positions_divider[16]=MathMax(MathAbs(M_positions[3][0]+M_positions[3][1]+M_positions[3][2]+M_positions[3][3]+M_positions[3][4]+M_positions[3][5]+M_positions[3][6]+M_positions[3][7]),
                                      MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));

         r1= M_risk[3][0]+M_risk[3][1]+M_risk[3][2]+M_risk[3][3]+M_risk[3][4]+M_risk[3][5]+M_risk[3][6]+M_risk[3][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[16]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[16]=MathMin(MathMin(r1,r2),0);

         //EURNZD
         positions_divider[17]=MathMax(MathAbs(M_positions[3][0]+M_positions[3][1]+M_positions[3][2]+M_positions[3][3]+M_positions[3][4]+M_positions[3][5]+M_positions[3][6]+M_positions[3][7]),
                                      MathAbs(M_positions[0][6]+M_positions[1][6]+M_positions[2][6]+M_positions[3][6]+M_positions[4][6]+M_positions[5][6]+M_positions[6][6]+M_positions[7][6]));

         r1= M_risk[3][0]+M_risk[3][1]+M_risk[3][2]+M_risk[3][3]+M_risk[3][4]+M_risk[3][5]+M_risk[3][6]+M_risk[3][7];
         r2= M_risk[0][6]+M_risk[1][6]+M_risk[2][6]+M_risk[3][6]+M_risk[4][6]+M_risk[5][6]+M_risk[6][6]+M_risk[7][6];

         current_risk_BUY[17]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[17]=MathMin(MathMin(r1,r2),0);

         //GBPAUD
         positions_divider[18]=MathMax(MathAbs(M_positions[4][0]+M_positions[4][1]+M_positions[4][2]+M_positions[4][3]+M_positions[4][4]+M_positions[4][5]+M_positions[4][6]+M_positions[4][7]),
                                      MathAbs(M_positions[0][0]+M_positions[1][0]+M_positions[2][0]+M_positions[3][0]+M_positions[4][0]+M_positions[5][0]+M_positions[6][0]+M_positions[7][0]));

         r1= M_risk[4][0]+M_risk[4][1]+M_risk[4][2]+M_risk[4][3]+M_risk[4][4]+M_risk[4][5]+M_risk[4][6]+M_risk[4][7];
         r2= M_risk[0][0]+M_risk[1][0]+M_risk[2][0]+M_risk[3][0]+M_risk[4][0]+M_risk[5][0]+M_risk[6][0]+M_risk[7][0];

         current_risk_BUY[18]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[18]=MathMin(MathMin(r1,r2),0);

         //GBPCAD
         positions_divider[19]=MathMax(MathAbs(M_positions[4][0]+M_positions[4][1]+M_positions[4][2]+M_positions[4][3]+M_positions[4][4]+M_positions[4][5]+M_positions[4][6]+M_positions[4][7]),
                                      MathAbs(M_positions[0][1]+M_positions[1][1]+M_positions[2][1]+M_positions[3][1]+M_positions[4][1]+M_positions[5][1]+M_positions[6][1]+M_positions[7][1]));

         r1= M_risk[4][0]+M_risk[4][1]+M_risk[4][2]+M_risk[4][3]+M_risk[4][4]+M_risk[4][5]+M_risk[4][6]+M_risk[4][7];
         r2= M_risk[0][1]+M_risk[1][1]+M_risk[2][1]+M_risk[3][1]+M_risk[4][1]+M_risk[5][1]+M_risk[6][1]+M_risk[7][1];

         current_risk_BUY[19]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[19]=MathMin(MathMin(r1,r2),0);

         //GBPCHF
         positions_divider[20]=MathMax(MathAbs(M_positions[4][0]+M_positions[4][1]+M_positions[4][2]+M_positions[4][3]+M_positions[4][4]+M_positions[4][5]+M_positions[4][6]+M_positions[4][7]),
                                      MathAbs(M_positions[0][2]+M_positions[1][2]+M_positions[2][2]+M_positions[3][2]+M_positions[4][2]+M_positions[5][2]+M_positions[6][2]+M_positions[7][2]));

         r1= M_risk[4][0]+M_risk[4][1]+M_risk[4][2]+M_risk[4][3]+M_risk[4][4]+M_risk[4][5]+M_risk[4][6]+M_risk[4][7];
         r2= M_risk[0][2]+M_risk[1][2]+M_risk[2][2]+M_risk[3][2]+M_risk[4][2]+M_risk[5][2]+M_risk[6][2]+M_risk[7][2];

         current_risk_BUY[20]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[20]=MathMin(MathMin(r1,r2),0);


         //GBPJPY
         positions_divider[21]=MathMax(MathAbs(M_positions[4][0]+M_positions[4][1]+M_positions[4][2]+M_positions[4][3]+M_positions[4][4]+M_positions[4][5]+M_positions[4][6]+M_positions[4][7]),
                                      MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));

         r1= M_risk[4][0]+M_risk[4][1]+M_risk[4][2]+M_risk[4][3]+M_risk[4][4]+M_risk[4][5]+M_risk[4][6]+M_risk[4][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[21]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[21]=MathMin(MathMin(r1,r2),0);


         //GBPNZD
         positions_divider[22]=MathMax(MathAbs(M_positions[4][0]+M_positions[4][1]+M_positions[4][2]+M_positions[4][3]+M_positions[4][4]+M_positions[4][5]+M_positions[4][6]+M_positions[4][7]),
                                      MathAbs(M_positions[0][6]+M_positions[1][6]+M_positions[2][6]+M_positions[3][6]+M_positions[4][6]+M_positions[5][6]+M_positions[6][6]+M_positions[7][6]));

         r1= M_risk[4][0]+M_risk[4][1]+M_risk[4][2]+M_risk[4][3]+M_risk[4][4]+M_risk[4][5]+M_risk[4][6]+M_risk[4][7];
         r2= M_risk[0][6]+M_risk[1][6]+M_risk[2][6]+M_risk[3][6]+M_risk[4][6]+M_risk[5][6]+M_risk[6][6]+M_risk[7][6];

         current_risk_BUY[22]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[22]=MathMin(MathMin(r1,r2),0);

         //NZDCAD
         positions_divider[23]=MathMax(MathAbs(M_positions[6][0]+M_positions[6][1]+M_positions[6][2]+M_positions[6][3]+M_positions[6][4]+M_positions[6][5]+M_positions[6][6]+M_positions[6][7]),
                                      MathAbs(M_positions[0][1]+M_positions[1][1]+M_positions[2][1]+M_positions[3][1]+M_positions[4][1]+M_positions[5][1]+M_positions[6][1]+M_positions[7][1]));

         r1= M_risk[6][0]+M_risk[6][1]+M_risk[6][2]+M_risk[6][3]+M_risk[6][4]+M_risk[6][5]+M_risk[6][6]+M_risk[6][7];
         r2= M_risk[0][1]+M_risk[1][1]+M_risk[2][1]+M_risk[3][1]+M_risk[4][1]+M_risk[5][1]+M_risk[6][1]+M_risk[7][1];

         current_risk_BUY[23]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[23]=MathMin(MathMin(r1,r2),0);

         //NZDCHF
         positions_divider[24]=MathMax(MathAbs(M_positions[6][0]+M_positions[6][1]+M_positions[6][2]+M_positions[6][3]+M_positions[6][4]+M_positions[6][5]+M_positions[6][6]+M_positions[6][7]),
                                      MathAbs(M_positions[0][2]+M_positions[1][2]+M_positions[2][2]+M_positions[3][2]+M_positions[4][2]+M_positions[5][2]+M_positions[6][2]+M_positions[7][2]));

         r1= M_risk[6][0]+M_risk[6][1]+M_risk[6][2]+M_risk[6][3]+M_risk[6][4]+M_risk[6][5]+M_risk[6][6]+M_risk[6][7];
         r2= M_risk[0][2]+M_risk[1][2]+M_risk[2][2]+M_risk[3][2]+M_risk[4][2]+M_risk[5][2]+M_risk[6][2]+M_risk[7][2];

         current_risk_BUY[24]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[24]=MathMin(MathMin(r1,r2),0);

         //NZDJPY
         positions_divider[25]=MathMax(MathAbs(M_positions[6][0]+M_positions[6][1]+M_positions[6][2]+M_positions[6][3]+M_positions[6][4]+M_positions[6][5]+M_positions[6][6]+M_positions[6][7]),
                                      MathAbs(M_positions[0][5]+M_positions[1][5]+M_positions[2][5]+M_positions[3][5]+M_positions[4][5]+M_positions[5][5]+M_positions[6][5]+M_positions[7][5]));
         r1= M_risk[6][0]+M_risk[6][1]+M_risk[6][2]+M_risk[6][3]+M_risk[6][4]+M_risk[6][5]+M_risk[6][6]+M_risk[6][7];
         r2= M_risk[0][5]+M_risk[1][5]+M_risk[2][5]+M_risk[3][5]+M_risk[4][5]+M_risk[5][5]+M_risk[6][5]+M_risk[7][5];

         current_risk_BUY[25]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[25]=MathMin(MathMin(r1,r2),0);

         //NZDUSD
         positions_divider[26]=MathMax(MathAbs(M_positions[6][0]+M_positions[6][1]+M_positions[6][2]+M_positions[6][3]+M_positions[6][4]+M_positions[6][5]+M_positions[6][6]+M_positions[6][7]),
                                      MathAbs(M_positions[0][7]+M_positions[1][7]+M_positions[2][7]+M_positions[3][7]+M_positions[4][7]+M_positions[5][7]+M_positions[6][7]+M_positions[7][7]));

         r1= M_risk[6][0]+M_risk[6][1]+M_risk[6][2]+M_risk[6][3]+M_risk[6][4]+M_risk[6][5]+M_risk[6][6]+M_risk[6][7];
         r2= M_risk[0][7]+M_risk[1][7]+M_risk[2][7]+M_risk[3][7]+M_risk[4][7]+M_risk[5][7]+M_risk[6][7]+M_risk[7][7];

         current_risk_BUY[26]=MathMax(MathMax(r1,r2),0);
         current_risk_SELL[26]=MathMin(MathMin(r1,r2),0);

         //--- Execucao das ordens
         for(int A=0; A<Strategy_A; A++)
           {
            Print(Symbol_A[A],"= ",IsTrade_A[A]);
            if(!IsTrade_A[A])
               continue;

            if((array_open_orders(Symbol_A[A])==0)&&(signal[A]!=0))
              {

               Print("Point= ",Point());
               Print("MarketInfo(Symbol(),MODE_TICKVALUE)= ",MarketInfo(Symbol_A[A],MODE_TICKVALUE));
               Print("ATR_K*iATR(Symbol_A[A],Period_A[A],14,0)= ",ATR_K*iATR(Symbol_A[A],Period_A[A],14,0));
               Print("positions_divider[A]= ",positions_divider[A]);
               Print("Current bought risk= ", current_risk_BUY[A]);
               Print("Current sold risk= ", current_risk_SELL[A]);
               Print("Symbol= ",Symbol_A[A]);
               Print("A= ",A);
               Print("signal[a]= ",signal[A]);
               Exit_hold[A]=Time[0];

               if(positions_divider[A]==0)
                 {
                  positions_divider[A]=1;
                 }


               //double Lots=NormalizeDouble((2*0.02*AccountBalance()/MathAbs(positions_divider[A]))/(ATR_K*iATR(Symbol_A[A],Period_A[A],14,0)*MarketInfo(Symbol_A[A],MODE_TICKVALUE)/Point()),2);


               if(signal[A]==1)
                 {
                  //COMPRA

                  double Lots=NormalizeDouble(((MathMin(2,risk-current_risk_BUY[A]))*AccountBalance()/MathAbs(positions_divider[A]))/(ATR_K*iATR(Symbol_A[A],Period_A[A],14,0)*MarketInfo(Symbol_A[A],MODE_TICKVALUE))/(1/MarketInfo(Symbol_A[A],MODE_POINT)),2);
                  Print("Lots= ",Lots);
                  Lots=MathMax(Lots,2*SymbolInfoDouble(Symbol_A[A],SYMBOL_VOLUME_MIN));
                  double SL=MarketInfo(Symbol_A[A],MODE_ASK)-ATR_K*iATR(Symbol_A[A],Period_A[A],14,0);
                  double TP=MarketInfo(Symbol_A[A],MODE_ASK)+iATR(Symbol_A[A],Period_A[A],14,0);
                  int ticket=OrderSend(Symbol_A[A],OP_BUY,0.5*Lots,MarketInfo(Symbol_A[A],MODE_ASK),3,SL,NULL,NULL,0,0,Green);
                  int buyscale=OrderSend(Symbol_A[A],OP_BUY,0.5*Lots,MarketInfo(Symbol_A[A],MODE_ASK),3,SL,TP,NULL,0,0,Green);
                  TrailingStop[A]=ATR_K*iATR(Symbol_A[A],Period_A[A],14,0);

                  if(ticket<0)
                     Print("OrderSend failed with error #",GetLastError());

                  if(buyscale<0)
                     Print("OrderSend failed with error #",GetLastError());

                 }

               if(signal[A]==-1)
                 {
                  //VENDE
                  double Lots=NormalizeDouble(((MathMin(2,risk-MathAbs(current_risk_SELL[A])))*AccountBalance()/MathAbs(positions_divider[A]))/(ATR_K*iATR(Symbol_A[A],Period_A[A],14,0)*MarketInfo(Symbol_A[A],MODE_TICKVALUE))/(1/MarketInfo(Symbol_A[A],MODE_POINT)),2);
                  Print("Lots= ",Lots);
                  Lots=MathMax(Lots,2*SymbolInfoDouble(Symbol_A[A],SYMBOL_VOLUME_MIN));
                  double SL=MarketInfo(Symbol_A[A],MODE_BID)+ATR_K*iATR(Symbol_A[A],Period_A[A],14,0);
                  double TP=MarketInfo(Symbol_A[A],MODE_BID)-iATR(Symbol_A[A],Period_A[A],14,0);
                  int sellscale=OrderSend(Symbol_A[A],OP_SELL,0.5*Lots,MarketInfo(Symbol_A[A],MODE_BID),3,SL,TP,NULL,0,0,Red);
                  int ticket=OrderSend(Symbol_A[A],OP_SELL,0.5*Lots,MarketInfo(Symbol_A[A],MODE_BID),3,SL,NULL,NULL,0,0,Red);
                  TrailingStop[A]=ATR_K*iATR(Symbol_A[A],Period_A[A],14,0);

                  if(ticket<0)
                     Print("OrderSend failed with error #",GetLastError());

                  if(sellscale<0)
                     Print("OrderSend failed with error #",GetLastError());

                 }
              }

            LastActionTime[A]=Time[0];

           }
        }
     }


   for(int A=0; A<Strategy_A; A++)
     {
      //-----------------------------------------------------------------------------------------
      //-- Trailing Stop:

      //SCALE OUT MODE 1+ TRAILING STOP

      if((array_open_orders(Symbol_A[A])==1))
        {

         if((TrailingStop[A]==0)||(TrailingStop[A]==EMPTY_VALUE))
           {
            TrailingStop[A]=ATR_K*iATR(Symbol_A[A],Period_A[A],14,0);
           }

         for(int order_id=0; order_id<OrdersTotal(); order_id++)
           {
            bool check_trail=OrderSelect(order_id, SELECT_BY_POS, MODE_TRADES);
            if(!check_trail)
              {
               Print("E4. OrderSelect returned the error of ",GetLastError());
               Print("Order Id= ",order_id);
               continue;
              }
            if(OrderSymbol()==Symbol_A[A])
              {

               if(OrderType()==OP_BUY)
                 {
                  //If Pc - P> Ts
                  if(MarketInfo(Symbol_A[A],MODE_BID)-OrderOpenPrice()>TrailingStop[A])
                    {
                     //If SL < P - Ts
                     // Raise New SL, price rises
                     if(OrderStopLoss()<(MarketInfo(Symbol_A[A],MODE_BID)-TrailingStop[A]))
                       {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(MarketInfo(Symbol_A[A],MODE_BID)-TrailingStop[A],2),OrderTakeProfit(),0,Blue);
                       }
                    }
                  else
                     if(OrderStopLoss()<OrderOpenPrice())
                       {
                        double SL=OrderOpenPrice();//-(OrderOpenPrice()-OrderStopLoss());
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),SL,OrderTakeProfit(),0,Blue);
                       }
                 }

               if(OrderType()==OP_SELL)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     if((OrderOpenPrice()-MarketInfo(Symbol_A[A],MODE_ASK))>TrailingStop[A])
                       {
                        if(OrderStopLoss()>MarketInfo(Symbol_A[A],MODE_ASK)+TrailingStop[A])
                          {
                           //Ask+Point*TrailingStop,Digits
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(MarketInfo(Symbol_A[A],MODE_ASK)+TrailingStop[A],2),OrderTakeProfit(),0,Blue);
                          }
                       }
                     else
                        if(OrderStopLoss()>OrderOpenPrice())
                          {
                           double SL=OrderOpenPrice();//+(OrderStopLoss()-OrderOpenPrice());
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Blue);
                          }
                    }
                 }
              }
           }
        }
     }


  }
//+------------------------------------------------------------------+
//--- Funcao IsSymbolInMarketWatch()
bool IsSymbolInMarketWatch(string f_Symbol)
  {
   for(int s=0; s<SymbolsTotal(false); s++)
     {
      if(f_Symbol==SymbolName(s,false))
         return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//--- Funcao strategy MEAN CROSS
int strategy_mean_cross(double azull, double Price)
  {
   int indicacao=0;
   if(azull<Price)
      indicacao=1;
   else
      if(azull>Price)
         indicacao=-1;
   return(indicacao);
  }
//+------------------------------------------------------------------+
//--- Funcao Today
int      TimeOfDay(datetime when) {  return(when % 86400);         }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime DateOfDay(datetime when) {  return(when - TimeOfDay(when));         }
datetime Today() {                   return(DateOfDay(TimeCurrent()));       }

//+------------------------------------------------------------------+
//--- Funcao Tomorrow
datetime Tomorrow() {                return(Today() + 86400);                 }

//+------------------------------------------------------------------+
//--- Funcao Yesterday
datetime After_Tomorrow() {               return(Today() + 2*86400);      }


//+------------------------------------------------------------------+
//--- Funcao strategy_line_cross
int strategy_line_cross(double Vermelho, double Azul, double Vermelho_, double Azul_)
  {
   int indicacao=0;
   if(Vermelho>Azul)
      indicacao=-1;
   if(Vermelho<Azul)
      indicacao=1;
   if(indicacao==0)
     {
      if(Vermelho_>Azul_)
         indicacao=-1;
      if(Vermelho_<Azul_)
         indicacao=1;
     }
   return(indicacao);

  }
//+------------------------------------------------------------------+
//--- Funcao Ordens Abertas
int array_open_orders(string simbolo)
  {
   int count_ordem_aberta=0;
   for(int iPos = OrdersTotal()-1; iPos >= 0; iPos--)
     {
      bool check=OrderSelect(iPos, SELECT_BY_POS);
      if(OrderSymbol() == simbolo)
         count_ordem_aberta++;
     }
   return(count_ordem_aberta);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool download_history(ENUM_TIMEFRAMES period_check, string symbol_check)
  {
   datetime today = TimeCurrent();
   datetime other = iTime(symbol_check, period_check, 0);

   MqlDateTime today_str, other_str;
   TimeToStruct(today,today_str);
   TimeToStruct(other,other_str);

   ResetLastError();

   if((_LastError == 0) && (today_str.day == other_str.day) && (today_str.year == other_str.year) && (today_str.mon == other_str.mon))
      return true;

   if((_LastError != ERR_HISTORY_WILL_UPDATED) && (_LastError != ERR_NO_HISTORY_DATA))
      Print(StringFormat("iTime(%s,%i) Failed: %i", symbol_check, period_check,_LastError));
   return false;

  }

//+------------------------------------------------------------------+
// For backtesting only
/*void OnTick()
  {
//---
   OnTimer();
  }//*/
//+------------------------------------------------------------------+
