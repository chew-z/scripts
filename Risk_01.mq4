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
  double H, L, ATR, R;
  string S = "";
  for(int i=bars_count-1; i>=0; i--) {
        H = High[i]; L = Low[i];
        ATR = f_TrueATR(3, i)*dbl2pips; R = (H-L)*dbl2pips;
        //S1 = StringSubstr( Symbol(), 0, 3 ); S2 = StringSubstr( Symbol(), 3, 3 );
        Print(Symbol(), " ", ATR, " ",Low[i], " ",High[i], " ", R, " ", pipsValue(Symbol()), " ", pipsValuePLN(Symbol()));
        Print(Symbol(), " ", ATR*pipsValue(Symbol()), " ", ATR*pipsValuePLN(Symbol()), " ",R*pipsValue(Symbol()), " ", R*pipsValuePLN(Symbol()));
     }
  return;
}

double pipsValue(string S) {
// returns dollar value of one pips (for FX) or one integral (point, dollar) (for CFD)
// requires some improvements
    string S1 = StringSubstr( S, 0, 3 );
    string S2 = StringSubstr( S, 3, 3 );
    if (S == "JPN225")
        return ( 1000.00/MarketInfo("USDJPY",MODE_ASK) );
    if (S == "US500")
        return ( 50.0 );
    if (S == "WTI")
        return ( 1000.00 );
    if (S == "COPPER")
        return ( 200.00 );
    if ( S2 == "USD")
        return ( 10.0 );
    if ( S2 == "JPY" )
        return ( 1000.00/MarketInfo("USDJPY",MODE_ASK) );
    if ( S2 == "CAD")
        return ( 10.0/MarketInfo( "USDCAD", MODE_ASK) );

    return (0.0);
}

double pipsValuePLN(string symbol) {
        return (pipsValue(symbol) * MarketInfo( "USDPLN", MODE_ASK));
}
