//+------------------------------------------------------------------+
//|                                             Export_Python_03a.mq4       |
//|                                            Copyright 2012 chew-z             |
//|  Tylko OHLC i znaczniki timestamp                                |
//| Wersja kompaktowa dla Python                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, 2015 by chew-z"
#property link      "Export_Python_03a"

static int handle = 0;
int OnInit()  {
   handle = FileOpen(Symbol()+Period()+"_03a.csv", FILE_CSV|FILE_WRITE);
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason)  {
   FileClose(handle);
}
void OnStart() {
  int bars_count=Bars;
  int iDay = 1;
  int lookBackDays = 20;

  if(handle < 1)    {
     Print(" Export_Python_03a: Problem z plikiem export.dat. Error ", GetLastError());
  } else    {
     FileWrite(handle, "#","DATETIME", "iDay","OPEN","HIGH","LOW", "CLOSE");
     for(int i=bars_count-1; i>=0; i--) {
       datetime t = Time[i];
        iDay = iBarShift(NULL, PERIOD_D1, Time[i],false) + 1; //Zamienia indeks bie¿¹cego baru na indeks dziennego Open (!! z poprzedniego dnia !!)
       //Numeracja wierszy jest wed³ug konwencji MQL czyli wstecz...
       FileWrite(handle, i+1,t,iDay, Open[i],High[i], Low[i], Close[i]);
       FileFlush(handle); // Flush every line?
     } // for(i=bars_count,...
     Print(" Export_Python_03a - Done: ", Bars);
  }
  return;
}
