//+------------------------------------------------------------------+
//|                                            Risk_01.mq4           |
//|                                            Copyright 2012 chew-z |
//|  Tylko OHLC i znaczniki timestamp                                |
//| Wersja kompaktowa dla Python                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, 2015 by chew-z"
#property link      "Risk_01"
#include <TradeTools\TradeTools5.mqh>
#include <TradeContext.mq4>
static int handle = 0;
int OnInit()  {
   //handle = FileOpen(Symbol()+Period()+"_03a.csv", FILE_CSV|FILE_WRITE);
   if (Digits == 5 || Digits == 3){    // Adjust for five (5) digit brokers.
            pips2dbl    = Point*10; pips2points = 10;   Digits_pips = 1; dbl2pips = 0.1/Point;
     } else {    pips2dbl    = Point;    pips2points =  1;   Digits_pips = 0; dbl2pips = 1.0/Point; }
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason)  {
   //FileClose(handle);
}
void OnStart() {
  int bars_count=5;
  int iDay = 1;
  double ATR, R, Risk, RiskPLN;
  string S = "";
  for(int i=bars_count-1; i>=0; i--) {
        H = High[i]; L = Low[i];
        ATR = f_TrueATR(3, i)*dbl2pips; R = (H-L)*dbl2pips;
        Risk = (H - L) * dbl2pips;
        if (IsTesting())
            RiskPLN = Risk; // During testing MarketInfo( "PAIR", MODE_ASK) is always 0;
         else
            RiskPLN = Risk * pipsValuePLN(Symbol());
         Print( Symbol(), ", Risk =  ", Risk, ", RiskPLN = ", RiskPLN );
        //S1 = StringSubstr( Symbol(), 0, 3 ); S2 = StringSubstr( Symbol(), 3, 3 );
        Print(Symbol(), " ", ATR, " ",Low[i], " ",High[i], " ", R, " ", pipsValue(Symbol()), " ", pipsValuePLN(Symbol()));
        Print(Symbol(), " ", ATR*pipsValue(Symbol()), " ", ATR*pipsValuePLN(Symbol()), " ",R*pipsValue(Symbol()), " ", R*pipsValuePLN(Symbol()));
     }
  return;
}
