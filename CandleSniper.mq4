//+------------------------------------------------------------------+
//|                                                 CandleSniper.mq4 |
//|                               Copyright 2016, Sebastian Bonilla. |
//|                                  https://www.sebastianbonilla.me |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Sebastian Bonilla."
#property link      "https://www.sebastianbonilla.me"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2 //we will need 2 buffers
#property indicator_color1 clrDarkBlue
#property indicator_color2 clrFireBrick
#property indicator_width1 1
#property indicator_width2 1
//--- input parameters
extern double   bmi = 20.0;
extern int minSize = 100;
double up[];
double down[];
datetime currenttime;
datetime candletime;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  
   bmi *= 0.01;
  
//--- indicator buffers mapping
   
   //stuff for 0
   SetIndexBuffer(0,up); //assign up to the first buffer
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,233);
   SetIndexLabel(0, "Up Arrow");
   
   //stuff for 1
   SetIndexBuffer(1,down); //assign down to the seconf buffer
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,234);
   SetIndexLabel(1, "Down Arrow");
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   currenttime=Time[0];
   int limit = MathMax(rates_total-prev_calculated,2); //start with 1k and then only new tick
      
   for(int i =1; 1 < limit; i++){
   
   double total = High[i]-Low[i];
   double body = MathAbs(Open[i]-Close[i]);
   double maxSize = total*bmi;
   
   if (body<maxSize && total > minSize*Point
      && Open[i]<=Close[i] 
      && High[i]-Open[i] < maxSize 
      && Low[i]<Low[i+1] 
      && Low[i]<Low[i+2]){ //end of if statement conditions
      
      //place arrow
      up[i] = Low[i];
      
      //send notification
      if(currenttime != candletime && i==1){
         Alert((string)Period() +"M ", Symbol()," "+"Just made a bullish pinbar!");
         SendNotification((string)Period() +"M "+ Symbol()+" "+"Just made a bullish pinbar!");
      }
      candletime=Time[0];      
      } 
      
   
   if (body<maxSize && total > minSize*Point
      && Open[i]>=Close[i] 
      && High[i]-Close[i] < maxSize 
      && Low[i]<Low[i+1] 
      && Low[i]<Low[i+2]){
      
      //pace arrow
      up[i] = Low[i];      
      
      //send notification
      if(currenttime != candletime && i==1){
         Alert((string)Period() +"M ", Symbol()," "+"Just made a bullish pinbar!");
         SendNotification((string)Period() +"M "+ Symbol()+" "+"Just made a bullish pinbar!");
      }
      candletime=Time[0];      
      }
      
   
   else if(body<maxSize && total > minSize*Point
      && Open[i]>Close[i] 
      && Open[i]-Low[i] < maxSize 
      && High[i]>High[i+1] 
      && High[i]>High[i+2]){
      
      //place arrow
      down[i] = High[i];   
      
      //send notification
      if(currenttime != candletime && i==1){
         Alert((string)Period() +"M ", Symbol()," "+"Just made a bullish pinbar!");
         SendNotification((string)Period() +"M "+ Symbol()+" "+"Just made a bearish pinbar!");
      }
      candletime=Time[0];      
      } 
      
      
   else if(body<maxSize && total > minSize*Point
      && Open[i]<Close[i] 
      && Close[i]-Low[i] < maxSize 
      && High[i]>High[i+1] 
      && High[i]>High[i+2]){
      
      //place arrow
      down[i] = High[i];   
      
      //send notification
      if(currenttime != candletime && i==1){
         Alert((string)Period() +"M ", Symbol()," "+"Just made a bullish pinbar!");
         SendNotification((string)Period() +"M "+ Symbol()+" "+"Just made a bearish pinbar!");
      }
      candletime=Time[0];      
      }
      
      
   }
 
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


