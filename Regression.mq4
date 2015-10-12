#property copyright "Copyright © 2014-2015, chew-z"
#property link      "trendline_4a"
#include <TradeTools\TradeTools5.mqh>
#include <TradeContext.mq4>

int OnInit()  {
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason)  {
}

void OnStart() {

    int i = 20;

    double m_X = (i + 1) * 0.5;
    double m_Y = mean_H(i);
    double r = pearson_r(i, m_Y);
    double b = r * (std_H(i, m_Y) / std_X(i));
    double A = m_Y - b * m_X;

    Print ("m_X: "+m_X+" m_Y: "+m_Y+" b: "+b+" A: "+ A+" r: "+r);

    while(i > 0)    {                                      // Loop for uncounted bars
        Print(i+": "+line(i, b, A));
        i--;
      }

    return;
}

double mean_H(int n) {
    double sigma = 0.0;
    for(int j = n; j > 0; j--) {
        sigma += High[j];
    }
    Print("mean_H: " + sigma / n);
    return sigma / n;
}

double std_H(int n, double m) {
    double sigma = 0.0;
    for(int j = n; j > 0; j--) {
        sigma += MathPow(High[j] - m, 2);
    }
    Print("std_H: " + 1.0 / (n-1) * sigma);
    return 1.0 / (n-1) * sigma;
}

double std_X(int n) {
// standard deviation arithmetic progression
    Print("std_X: " + 1 * MathSqrt( (n - 1) * (n + 1) / 12 ));
    return 1 * MathSqrt( (n - 1) * (n + 1) / 12 );
}

double pearson_r(int n, double m_Y) {
    double sum_xy = 0.0;
    double sum_sq_v_x = 0.0;
    double sum_sq_v_y = 0.0;
    double m_X = 0.5 * (n + 1); //sum of arithmetic progression
    for(int j = n; j > 0; j--) {
        double var_x = j - m_X;
        double var_y = High[j] - m_Y;
        sum_xy += var_x * var_y;
        sum_sq_v_x += MathPow(var_x, 2);
        sum_sq_v_y += MathPow(var_y, 2);
    }
    Print("Pearson_r: " + sum_xy / MathSqrt(sum_sq_v_x * sum_sq_v_y));
    return sum_xy / MathSqrt(sum_sq_v_x * sum_sq_v_y);
}

double line(double x, double b, double A) {
    return b * x + A;
}