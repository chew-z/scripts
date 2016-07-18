//+------------------------------------------------------------------+
//|                                            Risk_02.mq4           |
//|                                            Copyright 2012 chew-z |
//|  liczy ryzyko w zależności od lot  size                          |
//| it seems to work                                                 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012-2016 by chew-z"
#property link      "Risk_02"
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
  int bars_count = 5;
  double divisor = 0.0;

  for(int i=bars_count-1; i>=0; i--) {
        divisor = f_riskUSD(Symbol())/f_pointUSD(Symbol());
        Print(Symbol(), ", Lot size = ", MarketInfo(Symbol(), MODE_LOTSIZE), ", Point = ", DoubleToStr(Point, Digits), ", Tick =", MarketInfo(Symbol(), MODE_TICKVALUE)/MarketInfo("USDPLN", MODE_ASK));
        Print(Symbol(), ", Maximum risk [$] = ", f_riskUSD(Symbol()), ", Maximum risk [Point] = ", f_riskPoint(Symbol()), ", Maximum risk [Tick] = ", f_riskTick(Symbol()));
        Print(Symbol(), ", Point size [$] = ", f_pointUSD(Symbol()), ", Divisor = ", divisor);
        Print(Symbol(), ", SL = ", MarketInfo(Symbol(), MODE_ASK) - Point * divisor );
     }
  return;
}

double f_riskPoint(string S) {

    double lotsize = MarketInfo(S, MODE_LOTSIZE);
    double price = MarketInfo(S, MODE_ASK);
    double riskUSD = (MaxRiskPct/100.0) * lotsize * price;
    return (riskUSD / Point);
}

double f_riskTick(string S) {

    double lotsize = MarketInfo(S, MODE_LOTSIZE);
    double price = MarketInfo(S, MODE_ASK);
    double riskUSD = (MaxRiskPct/100.0) * lotsize * price;
    double tick = MarketInfo(Symbol(), MODE_TICKVALUE)/MarketInfo("USDPLN", MODE_ASK);
    return (riskUSD / tick);
}


