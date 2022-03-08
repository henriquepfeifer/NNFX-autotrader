# NNFX-autotrader
NNFX MQL4 Expert Advisor. Made to forward test and live trading.

Between 23:40 h and 00:00 h this EA gather information of indicators and current open positions. Just before that, the positions are going to be managed accordingly to the signals of your algorithm, total risk allowed per currency and incoming news.
If a order is refused, the EA waits 10 minutes and tries again until all the requirements are fulfilled or the clock reaches 00:00 h. The EA runs before the daily candle close for spread optimization.

Every time that a new position has to be open, the available risk will be splited between all new positions that contains that currency. It is done in a way that is very hard to exceed 2% risk each currency. If the total risk is reached, the position size is equal the minimum lot x2, so the 2% risk can be exceeded.

Trailing stop is updated every 10 minutes and works as VP describes.
Scaling out is also implemented.

Setting the EA for your algo:

The code contain my last NNFX algorithm.
Some tweaks are needed to insert your algo.
I let "CHANGE HERE: " commented over the code to ease your work.

You have to add NEWS date as well. It is done at OnInit() function and the format is described on the code.

The only thing not implemented yet is the EVZ part.
Feel free to contribute on github (/henriquepfeifer/NNFX-autotrader)

If you want to run my version of the algorithm:
Xaos Pattern Expplorer by Edward Samokhvalov https://www.mql5.com/en/code/8285 (rename file to 259T-XaosExplore_PerkyMod)
NonLagMA_v4 by TrendLaboratory (rename to 167T-NonLagMA_v4)
Volatility by Ivan Kornilov (rename to V203-volatility-indicator-2)
TrendWave_2 (T53-TrendWave_2)
All indicators are free and available to download.
