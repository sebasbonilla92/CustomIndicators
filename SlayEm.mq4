//+------------------------------------------------------------------+
//|                                                       SlayEm.mq4 |
//|                               Copyright 2016, Sebastian Bonilla. |
//|                                  https://www.sebastianbonilla.me |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Sebastian Bonilla."
#property link      "https://www.sebastianbonilla.me"
#property description "this indicator uses a scalping method using candles and volumes. Use in conjunction with other tools."
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrDarkGreen
#property indicator_color2 clrFuchsia
#property indicator_width1 2
#property indicator_width2 2


//--- input parameters
extern int minCandles = 4;
double up[];
double down[];
double minCandlesFused = MathMax(2, minCandles);

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,up); //assign up to the first buffer
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,236);
   SetIndexLabel(0, "Up Arrow");
   
   //stuff for 1
   SetIndexBuffer(1,down); //assign down to the seconf buffer
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,238);
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
  {//------------------------------------------
  
    double limit = rates_total-prev_calculated+minCandlesFused; 
    int bull_count = 0;
    int bear_count = 0;
    
    if(Bars + limit < minCandlesFused + 1) return(0);
    
    for (int i = 1000; i > 0; i--){
    
    
    //up[i] = High[i];
    
    //--bears-----------------------------------------
    if(Open[i] > Open[i-1]){
       bear_count++;
       if (bear_count > minCandlesFused){ //if there is minCandlesFused in a row
         if(i != 1){      //lets not go to [0]
              
             double body_first = MathAbs(Open[i]-Close[i]);  //get body size
             double body_second = MathAbs(Open[i-1]-Close[i-1]); //get body size for following candle
              
             if(body_second > body_first){ //body has to be larger than previous
                  if(Volume[i-1] > Volume[i]) up[i] = High[i]; 
             }               
        }         
      } 
    }
    else bear_count = 0;

   
   // --- bulls ----------------------------------------
    
    if(Open[i] < Open[i-1]){
       bull_count++;
       if (bull_count > minCandles){  
          if(i != 1){      //lets not go to [0]
              
             double body_first = MathAbs(Open[i]-Close[i]);  //get body size
             double body_second = MathAbs(Open[i-1]-Close[i-1]); //get body size for following candle
              
             if(body_second < body_first){ //body has to be larger than previous
                  if(Volume[i-1] > Volume[i]) down[i] = Low[i];
             }               
          }
       } 
    }
    else bull_count = 0;  
   
   
   Comment((string)Volume[7], " -- " + (string)Volume[8]);
   
   }  
         
//--- return value of prev_calculated for next call
   return(rates_total);
  }

  
//+------------------------------------------------------------------+
