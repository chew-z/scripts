//+------------------------------------------------------------------+
//|                                             Export_Python_03.mq4 |
//|                                            Copyright 2012 chew-z |
//| Dosyæ dojrza³a wersja - wymaga uwagi w linii poleceñ textscan( .)|
//| Mniej parametrów do eksportu                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, 2015 by chew-z"
#property link      "Export_Python_03"
/*extern int minPeriod = 5;
extern int maxPeriod = 20;
extern int Shift = 1; // Przesuniêcie o dni przy liczeniu zmiennoœci ze StdDev
extern int EMA = 60;
extern int K = 3;     // filtr trendu
static int lookBackDays = 5;
static double deltaVol = 0.0;
*/
static int handle = 0;
void init()  {
   handle = FileOpen(Symbol()+Period()+"_03.csv", FILE_CSV|FILE_WRITE);
}
void deinit()  {
   FileClose(handle);
}
int start() {
  int bars_count=Bars;
  int iDay = 1;
  int lookBackDays = 20;

  if(handle < 1)    {
     Print(" Export_Python_03: Problem z plikiem export.dat. Error ", GetLastError());
     return(false);
  } else    {
     FileWrite(handle, "#","DATETIME", "iDay","OPEN","HIGH","LOW", "CLOSE");
     //, "Costf L", "6-Stochatic Main","7-Stochatic Signal", "8-RSI", "9-ADX 5", "10-ADX 14", "11-HC_D1", "12-LC_D1", "13-HH_D1", "14-LL_D1", "15-MA_D1", "16-lookBackDays4", "17-dV","18-isT_L_D1", "19-isT_S_D1");
     for(int i=bars_count-1; i>=0; i--) {
       //
       datetime t = Time[i];
 /*      double stoch_main = iStochastic(NULL,0,14,3,3,MODE_EMA,0,MODE_MAIN,i);
       double stoch_sign = iStochastic(NULL,0,14,3,3,MODE_EMA,0,MODE_SIGNAL,i);
       double rsi = iRSI(NULL,0,14,PRICE_CLOSE,i);
       double adx5 = iADX(NULL,0,5,PRICE_CLOSE,MODE_MAIN,i);
       double adx14 = iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,i);
*/
         iDay = iBarShift(NULL, PERIOD_D1, Time[i],false) + 1; //Zamienia indeks bie¿¹cego baru na indeks dziennego Open (!! z poprzedniego dnia !!)
/*       lookBackDays = f_lookBackDays(iDay); //
      double  HC_D1 = iClose(NULL, PERIOD_D1, iHighest(NULL,PERIOD_D1,MODE_CLOSE,lookBackDays,iDay));
       double  LC_D1 = iClose(NULL, PERIOD_D1, iLowest(NULL,PERIOD_D1,MODE_CLOSE,lookBackDays,iDay));
       double  HH_D1 = iHigh(NULL, PERIOD_D1, iHighest(NULL,PERIOD_D1,MODE_HIGH,lookBackDays,iDay));
       double  LL_D1 = iLow(NULL, PERIOD_D1, iLowest(NULL,PERIOD_D1,MODE_LOW,lookBackDays,iDay));
       double  MA_D1 = iMA(NULL, PERIOD_D1, EMA, 0, MODE_EMA, PRICE_MEDIAN, iDay);
       bool isTL = isTrending_L(iDay);
       bool isTS = isTrending_S(iDay);
*/
       //Numeracja wierszy jest wed³ug konwencji MQL czyli wstecz...
       FileWrite(handle, i+1,t,iDay, Open[i],High[i], Low[i], Close[i]);
       FileFlush(handle); // Flush every line?
     } // for(i=bars_count,...
     Print(" Export_Python_03 - Done: ", Bars);
  }
  return;
}

/*
double costf(int b) { //Funkcja kosztu L (dla S -costf) - znormalizowana do stóp zwrotu
double x = 0.0;
   //Indeksacja specyficzna dla MQL dlatego ostatnie 20 barów daje absurdalne wyniki (nie znamy przysz³oœci niestety)
   if( b >= 20)
      x = (3.0 * Close[b] - Close[b-5] - Close[b-10] - Close[b-20]) / Close[b];
   else
      x = 0.0;
   return (x);
}

double f_lookBackDays(int iDay) {
double TodayVol, YestVol;

// Pierwszy wskaznik to aktualne StdDev
   TodayVol = iStdDev(NULL,PERIOD_D1,EMA,iDay,MODE_EMA,PRICE_CLOSE,0);
// Drugi wskaŸnik to StdDev cofniête o Shift dni (!!) niezale¿nie od timeframe wykresu
   YestVol = iStdDev(NULL,PERIOD_D1,EMA,Shift+iDay,MODE_EMA,PRICE_CLOSE,0);
// A gdyby odwróciæ logikê? Gdy wiêksza zmiennoœæ na rynku to przebicie krótszych szczytów ma znaczenie?
      if(YestVol!=0)
      deltaVol = MathLog(TodayVol  / YestVol) ;        // Te poziomy to 1 Std dla EURUSD
      lookBackDays = maxPeriod / 2;
      if(deltaVol > 0.028)
         lookBackDays = maxPeriod;
      if(deltaVol < -0.028)
         lookBackDays = minPeriod;
      return(lookBackDays);
}
bool isTrending_L(int iDay) { // Czy œrednia szybka powy¿ej wolnej?
int i;
double M;
int sig = 0;
   for (i = K; i>0; i--) {
      M = iMA(NULL, PERIOD_D1, maxPeriod, i, MODE_EMA, PRICE_CLOSE, iDay);
      if (iMA(NULL, PERIOD_D1, minPeriod, i, MODE_EMA, PRICE_CLOSE, iDay) > M)
         sig++;
   }
   if(sig < K)
      return(false);
   else
      return(true);
}
bool isTrending_S(int iDay) { // Czy œrednia szybka poni¿ej wolnej?
int i;
double M;
int sig = 0;
   for (i = K; i>0; i--) {
      M = iMA(NULL, PERIOD_D1, maxPeriod, i, MODE_EMA, PRICE_CLOSE, iDay);
      if (iMA(NULL, PERIOD_D1, minPeriod, i, MODE_EMA, PRICE_CLOSE, iDay) < M)
         sig++;
   }
   if(sig < K)
      return(false);
   else
      return(true);
}
*/
