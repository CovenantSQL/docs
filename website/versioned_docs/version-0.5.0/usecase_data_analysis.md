---
id: version-0.5.0-usecase_data_analysis
title: Data Analysis
original_id: usecase_data_analysis
---

# Financial data analysis based on Quandl

## About Quandl

Quandl is a big data platform for the financial investment industry. Its data sources include public data such as the United Nations, the World Bank, and the Central Bank. The core financial data comes from CLS Group, Zacks and ICE. All data comes from more than 500 publishers. It is the preferred platform for investment professionals to provide financial, economic and alternative data with vast economic and financial data.

## Quandl Data Index

### Introduction to CovenantSQL

First, we have stored the data in CovenantSQL based on Quandl's open API. Next, you should take a look at the introduction of CovenantSQL to know how to connect and use CovenantSQL.

Now due to client compatibility issues, please use our HTTP service to query the Quandl database directly. This document will be updated as soon as possible after the current cql client is compatible.

Use CovenantSQL specifically through the HTTP service. Please refer to the Python driver documentation and the NodeJS driver documentation.

Required parameters:

```
host: 'e.morenodes.com'
port: 11111
database: '057e55460f501ad071383c95f691293f2f0a7895988e22593669ceeb52a6452a'
```

### How to use CQL-Quandl

Quandl data is divided into tables and sub-tables

In the database, the table name is `quandl_ + database_code` for the full table name

View the contents of the table by querying the table name	

For specific use, you need to use the `quandl_updateindex` index table to use it. (When querying the index table, be sure to limit less than 100,000 because the full data is too large)

Please using the `where` statement to qualify the `quandlcode` field to query the sub table data in the table.

## Example

1. We want to query the data of the European Commission's annual macroeconomic database. We find the database code of its first index is `quandl_ameco`, so we can query its second index, using the following SQL command line:

   ```SQL
   select * from quandl_updateindex where databasecode like 'ameco' group by quandlcode limit 10000;
   ```

2. Then through the third column, we can see the description corresponding to the `quandlcode`

   For example, `AMECO/ALB_1_0_0_0_AAGE` corresponds to the import and export information of Albania from 1960 to 1988.

   <u>Average share of imports and exports of goods in world trade excluding intra EU trade; Foreign trade statistics (1960-1998 Former EU-15) - Albania</u>

   So, we can query this subtable in the following way.

   ```SQL
   select * from quandl_ameco where quandlcode like 'AMECO/ALB_1_0_0_0_AAGE' limit 10000;
   ```

3. Note: If the content of the content is null, it belongs to the field that does not exist in the table structure itself, you can remove it yourself.

# Quandl Data Excel Plugin Instructions

You can download the Quandl Data Excel plugin without having to install it, unzip it into any folder. This plugin currently only supports Office 2010 and above, and Office 2007 and below are currently not supported.

## Configuring the Excel plugin

Unzip the downloaded package. There are two .xll files in the folder, `ClassLibrary7-AddIn.xll` and `ClassLibrary7-AddIn64.xll` files. These two files correspond to 32-bit Excel and 64-bit Excel respectively. Please refer to your The computer configuration uses the corresponding plugin.

### Modify the xml configuration

Each .xll file corresponds to a .config configuration file, which is `ClassLibrary7-AddIn.xll.config` and `ClassLibrary7-AddIn64.xll.config`, configured for the following xml:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <appSettings>
    <add key="certpath" value="C:\Cert\read.data.covenantsql.io.pfx" />
    <add key="keypassword" value="" />
    <add key="url" value="https://e.morenodes.com:11111/v1/query" />
    <add key="database" value="057e55460f501ad071383c95f691293f2f0a7895988e22593669ceeb52a6452a" />
  </appSettings>
</configuration>
```

The following configuration needs to be modified and saved:

`Certpath`: Please fill in the absolute path of the `read.data.covenantsql.io.pfx` certificate

### Plugin installation 

There are two ways to use this Excel plugin

1. Double-click the corresponding 32-bit or 64-bit Excel xll file to open it.

![quandl_ext_1](https://raw.githubusercontent.com/CovenantSQL/cql-excel-extension/master/refs/quandl_ext_1.png)

If the above dialog box shows up, select the first one: Enable this add-on only for this callback. Then create a new Excel table. If you see CovenantSQL in the upper tab of Excel, the plugin is loaded successfully.

2. Open Excel, then select File - Options - Add-ons, Manage Select Excel Add-Ins, click Go and browse to select the .xll file for the corresponding version after decompression, and then click OK. If you successfully load CovenantSQL in the tab, Successfully loaded, as shown below:

![quandl_ext_2](https://raw.githubusercontent.com/CovenantSQL/cql-excel-extension/master/refs/quandl_ext_2.png)

### How to use plugin

Select the CovenantSQL tab to see the Quandl data query. Click on the Quandl data query and a pop-up will appear as shown below:

![quandl_ext_3](https://raw.githubusercontent.com/CovenantSQL/cql-excel-extension/master/refs/quandl_ext_3_en.png)

- The part of the list that is framed by red is the first-level directory, and the lower part is the specific description of the selected item.
- The green button queries the se	condary directory by selecting the primary directory. The query time will vary depending on the size of the secondary directory being queried and the user's own network speed. The query time may exceed 1 minute. Please be patient.
- The list on the left of the yellow part is the secondary directory, and the form on the right is the description of the table selected by the list item.

- The blue part is an option to export data 
  - Limit Number is the maximum number of data exported at a time. The default is 10000, and the maximum value can be filled in 100000.
  - Offset Number is derived from the first few columns of the database, because the number of bars is limited. For example, we exported 10000 data before, but the obvious data has not been exported yet. We can use this function to select offset 10000 to start from the 10000th. Export (Note: the database count starts from 0, so the first 10000 is 0-9999)



## Attachment

| Database     | Name                                                         | description                                                  |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| PIKETTY      | Thomas Piketty                                               | Data on Income and Wealth from "Capital in the 21st Century",   Harvard University Press 2014. |
| BUNDESBANK   | Deutsche Bundesbank Data Repository                          | Data on the German economy, money and capital markets, public finances,   banking, households, Euro-area aggregates, trade and external debt. |
| URC          | Unicorn Research Corporation                                 | Advance and decline data for the   NYSE, AMEX, and NASDAQ stock exchanges. From various publicly-available   sources and the median value is reported. |
| DCE          | Dalian Commodities Exchange                                  | Agriculture and commodities futures from DCE, with history spanning   almost a decade for select futures. |
| WFC          | Wells Fargo Home Mortgage Loans                              | This database offers mortgage purchase and refinance rates from Wells   Fargo Home Mortgage, a division of Wells Fargo Bank. |
| USDAFNS      | U.S. Department of Agriculture FNS                           | Food and Nutrition Service administrates federal nutrition assistance   programs for low-income households and children. Data on costs and   participation rates. |
| LJUBSE       | Ljubljana Stock Exchange (Slovenia)                          | This database contains the Ljubljana Stock Exchange indexes and is based   in Ljubljana, Slovenia. |
| TOCOM        | Tokyo Commodities Exchange                                   | Agriculture and commodities futures from Tokyo Commodities Exchange   (TOCOM), with history spanning almost a decade for select futures. |
| WCSC         | World Bank Corporate Scorecard                               | This database is designed to   provide a strategic overview of the World Bank Group’s performance toward   ending extreme poverty and promoting shared prosperity. |
| CMHC         | Canadian Mortgage and Housing Corporation                    | The CMHC is a gov’t-owned corporation that provides affordable housing to   Canadian citizens and collects data such as prices, construction, and supply. |
| WGEC         | World Bank Global Economic Monitor (GEM) Commodities         | Data containing commodity prices and indices from 1960 to present. |
| FED          | US Federal Reserve Data Releases                             | Official US figures on money supply, interest rates, mortgages,   government finances, bank assets and debt, exchange rates, industrial   production. |
| WPSD         | World Bank Public Sector Debt                                | Data jointly developed by the   World Bank and the International Monetary Fund, which brings together   detailed public sector government debt data. |
| UGID         | United Nations Global Indicators                             | This database offers a wide range of global indicators, covering   population, public health, employment, trade, education, inflation and   external debt. |
| RBA          | Reserve Bank of Australia                                    | Central bank and monetary authority, regulates banking industry, sets   interest rates, and services governments debt. Data on key economic   indicators. |
| UCOM         | United Nations Commodity Trade                               | This database offers comprehensive global data on imports and exports of   commodities such as food, live animals, pharmaceuticals, metals, fuels and   machinery. |
| SIDC         | Solar Influences Data Analysis Center                        | The SIDC hosts data spanning from the 1700s on solar activity,   specifically sunspot activity. |
| ZCE          | Zhengzhou Commodities Exchange                               | Agriculture and commodities futures from ZCE, with history spanning   almost a decade for select futures. |
| USDAFAS      | U.S. Department of Agriculture FAS                           | The USDA Foreign Agricultural Service connects U.S. agriculture with the   world markets. It provides statistics on production and exports in foreign   countries. |
| OECD         | Organisation for Economic Co-operation and Development       | International organization of developed countries that promotes economic   welfare. Collects data from members and others to make policy   recommendations. |
| OPEC         | Organization of the Petroleum Exporting Countries            | International organization and economic cartel overseeing policies of   oil-producers, such as Iraq, Iran, Saudi Arabia, and Venezuela. Data on oil   prices. |
| MCX          | Multi Commodity Exchange India                               | Indias largest commodity exchange servicing futures trading in metals,   energy, and agriculture. Worlds 3rd largest exchange in contracts and trading   volume. |
| ECONOMIST    | The Economist - Big Mac Index                                | The Big Mac index was invented by The Economist in 1986 as a lighthearted   guide to whether currencies are at their “correct” level. It is based on the   theory of purchasing-power parity (PPP). |
| NSDL         | National Securities Depository Limited (India)               | Depository in India responsible for economic development of the country   that has established a national infrastructure of international standards   that handles most of the securities held and settled in dematerialised form   in the Indian capital market. |
| GDT          | Global Dairy Trade                                           | nan                                                          |
| CFFEX        | China Financial Futures Exchange                             | Index and bond futures from CFFEX, with history spanning almost a decade   for select futures. |
| CITYPOP      | Thomas Brinkhoff: City Populations                           | Thomas Brinkhoff provides population data for cities and administrative   areas in most countries. |
| BCHARTS      | Bitcoin Charts Exchange Rate Data                            | Exchange rates for bitcoin against a large number of currencies, from all   major bitcoin exchanges, including current and historical exchange rates. |
| LOCALBTC     | Local Bitcoins                                               | nan                                                          |
| JODI         | JODI Oil World Database                                      | JODI oil and gas data comes from over 100 countries consisting of   multiple energy products and flows in various methods of measurement. |
| UENG         | United Nations Energy Statistics                             | This database offers comprehensive global statistics on production,   trade, conversion, and final consumption of new and renewable energy sources. |
| ULMI         | United Nations Labour Market Indicators                      | This database offers comprehensive youth unemployment figures broken up   by gender for all countries in the world. |
| MAURITIUSSE  | Stock Exchange of Mauritius                                  | Stock Exchange of Mauritius indices data.                    |
| UKRSE        | Ukrainian Exchange                                           | UKRSE presents the most current available data related to the largest   stock exchanges in Ukraine. The exchange is located in Kiev and accounts for   roughly three-quarters of Ukraines total equity trading volume |
| BITSTAMP     | Bitstamp                                                     | Bitstamp is a trading platform for Bitcoin.                  |
| UNAE         | United Nations National Accounts Estimates                   | This database offers global data on gross domestic product, gross   national income, and gross value added by different sectors for all countries   in the world. |
| UNAC         | United Nations National Accounts Official Country Data       | This database offers global data on national accounts, such as assets and   liabilities of households, corporations and governments. |
| UTOR         | United Nations World Tourism                                 | This database offers comprehensive data on international tourism. Data   includes number of tourist arrivals and tourism expenditures for all   countries. |
| WFE          | World Federation of Exchanges                                | A trade association of sixty publicly regulated stock, futures, and   options exchanges that publishes data for its exchanges, like market   capitalization. |
| FRBC         | Federal Reserve Bank of Cleveland                            | The Federal Reserve Bank of Cleveland collects data from hundreds of   financial institutions, including depository institutions, bank holding   companies, and other entities that is used to assess financial institution   conditions and also to glean insights into how the economy and financial   system are doing. |
| UGEN         | United Nations Gender Information                            | This database offers comprehensive global data on a wide range of   gender-related indicators, covering demography, health, education and   employment. |
| BITFINEX     | Bitfinex                                                     | Bitfinex is a trading platform for Bitcoin, Litecoin and Darkcoin with   many advanced features including margin trading, exchange and peer to peer   margin funding. |
| UGHG         | United Nations Greenhouse Gas Inventory                      | This database offers comprehensive global data on anthropogenic emissions   of the six principal greenhouse gases. Data goes back to 1990. |
| UIST         | United Nations Industrial Development Organization           | This database offers global data on industrial development indicators,   including output, employees, wages, value added for a wide range of   industries. |
| PRAGUESE     | Prague Stock Exchange                                        | Price index data from the Prague Stock Exchange.             |
| PFTS         | PFTS Stock Exchange (Ukraine)                                | Index data from the PFTS Stock Exchange, the largest marketplace in   Ukraine. |
| WARSAWSE     | Warsaw Stock Exchange                                        | WIG20 index has been calculated since April 16, 1994 based on the value   of portfolio with shares in 20 major and most liquid companies in the WSE   Main List. |
| TUNISSE      | Tunis Stock Exchange                                         | The main reference index of Tunis Stock Exchange.            |
| FRKC         | Federal Reserve Bank of Kansas City                          | FRKC is the regional central bank for the 10th District of the Federal   Reserve, publishing data on banking in mostly agricultural transactions. |
| UENV         | United Nations Environment Statistics                        | This database offers global data on water and waste related indicators,   including fresh water supply and precipitation, and generation and collection   of waste. |
| UFAO         | United Nations Food and Agriculture                          | This database offers global food and agricultural data, covering crop   production, fertilizer consumption, use of land for agriculture, and   livestock. |
| TAIFEX       | Taiwan Futures Exchange                                      | Index and bond futures from TAIFEX, with history spanning over a decade   for select futures. |
| GDAX         | GDAX (Global Digital Asset Exchange)                         | GDAX is the world’s most popular place to buy and sell bitcoin. |
| ARES         | Association for Real Estate Securitization                   | ARES protects investors,   contributes to development of the real estate securitization product market,   and facilitates expansion of the real estate investment market. |
| SHADOWS      | Wu-Xia Shadow Federal Funds Rate                             | This dataset contains the three major indicators from the Wu-Xia papers   which serve to identify the shadow rates on all three major banks. |
| NAAIM        | NAAIM Exposure Index                                         | The NAAIM Exposure Index represents the average exposure to US Equity   markets reported by NAAIM members. |
| CBRT         | Central Bank of the Republic of Turkey                       | CBRT is responsible for taking measures to sustain the stability of the   financial system in Turkey. |
| CEGH         | Central European Gas Hub                                     | No description for this database yet.                        |
| FINRA        | Financial Industry Regulatory Authority                      | Financial Industry Regulatory Authority provides short interest data on   securities firms and exchange markets. |
| NASDAQOMX    | NASDAQ OMX Global Index Data                                 | Over 35,000 global indexes published by NASDAQ OMX including Global   Equity, Fixed Income, Dividend, Green, Nordic, Sharia and more.  Daily data. |
| EURONEXT     | Euronext Stock Exchange                                      | Historical stock data from Euronext, the largest European exchange. |
| UICT         | United Nations Information and Communication Technology      | This database offers comprehensive global data on information and   communication technology, including telephone, cellular and internet usage   for all countries. |
| USAID        | U.S. Agency for International Development                    | US Agency for International Development provides a complete historical   record of all foreign assistance provided by the United States to the rest of   the world. |
| ZAGREBSE     | Zagreb Stock Exchange                                        | Croatias only stock exchange. It publishes data on the performance of its   stock and bond indexes. |
| QUITOSE      | Quito Stock Exchange (Ecuador)                               | The indexes of the national Stock Exchange of Ecuador.       |
| ECBCS        | European Commission Business and Consumer Surveys            | Data in this database is derived   from harmonized surveys for different sectors of the economies in the   European Union (EU) and in the EU applicant countries. |
| PSE          | Paris School of Economics                                    | This database describes the distribution of top incomes in a growing   number of countries. Numbers are derived using tax data. |
| MALTASE      | Malta Stock Exchange                                         | The Malta Stock Exchange carries out the role of providing a structure   for admission of financial instruments to its recognised lists which may   subsequently be traded on a regulated, transparent and orderly market place   (secondary market).The main participants in the market are Issuers, Stock   Exchange Members (stockbrokers), and the investors in general. |
| GPP          | Global Petroleum Prices                                      | No description for this database yet.                        |
| PPE          | Polish Power Exchange (TGE)                                  | No description for this database yet.                        |
| UKONS        | United Kingdom Office of National Statistics                 | Data on employment, investment, housing, household expenditure, national   accounts, and many other socioeconomic indicators in the United Kingdom. |
| NCDEX        | National Commodity & Derivatives Exchange Limited (India)    | A professionally managed on-line multi-commodity exchange in India |
| WSE          | Warsaw Stock Exchange (GPW)                                  | No description for this database yet.                        |
| TFX          | Tokyo Financial Exchange                                     | The Tokyo Financial Exchange is a futures exchange that primary deals in   financial instruments markets that handle securities and market   derivatives. |
| WGFD         | World Bank Global Financial Development                      | Data on financial system characteristics, including measures of size,   use, access to, efficiency, and stability of financial institutions and   markets. |
| CEPEA        | Center for Applied Studies on Applied Economics (Brazil)     | CEPEA is an economic research center at the University of Sao Paulo   focusing on agribusiness issues, publishing price indices for commodities in   Brazil. |
| SBJ          | Statistics Bureau of Japan                                   | A Japanese government statistical agency that provides statistics related   to employment and the labour force. |
| WGEM         | World Bank Global Economic Monitor                           | Data on global economic   developments, with coverage of high-income, as well as developing   countries. |
| WGDF         | World Bank Global Development Finance                        | Data on financial system   characteristics, including measures of size, use, access to, efficiency, and   stability of financial institutions and markets. |
| WWDI         | World Bank World Development Indicators                      | Most current and accurate development indicators, compiled from   officially-recognized international sources. |
| WESV         | World Bank Enterprise Surveys                                | Company-level private sector data, covering business topics including   finance, corruption, infrastructure, crime, competition, and performance   measures. |
| WDBU         | World Bank Doing Business                                    | Data on business regulations and   their enforcement for member countries and selected cities at the subnational   and regional level. |
| OSE          | Osaka Securities Exchange                                    | The second largest securities exchange in Japan. Unlike the TSE, OSE is   strongest in derivatives trading, the majority of futures and options in   Japan. |
| RFSS         | Russian Federation Statistics Service                        | The Russian governmental statistical agency that publishes social,   economic, and demographic statistics for Russia at the national and local   levels. |
| SHFE         | Shanghai Futures Exchange                                    | Commodities exchange for energy, metal, and chemical-related industrial   products. A derivatives marketplace for many commodities futures. |
| WGEP         | World Bank GEP Economic Prospects                            | Data on the short-, medium, and long-term outlook for the global economy   and the implications for developing countries and poverty reduction. |
| USMISERY     | United States Misery Index                                   | Developed by economist Arthur Okun, the Misery Index is the unemployment   rate added to the inflation rate. |
| WJKP         | World Bank Jobs for Knowledge Platform                       | Indicators on labor-related   topics.                        |
| WMDG         | World Bank Millennium Development Goals                      | Data drawn from the World   Development Indicators, reorganized according to the goals and targets of the   Millennium Development Goals (MDGs). |
| WPOV         | World Bank Poverty Statistics                                | Indicators on poverty headcount ratio, poverty gap, and number of poor at   both international and national poverty lines. |
| EUREKA       | Eurekahedge                                                  | A research company focused on hedge funds and other alternative   investment funds. It publishes data on the performances of hedge funds. |
| MOFJ         | Ministry of Finance Japan                                    | Japanese government bond interest rate data, published daily by the   Ministry of Finance. |
| PSX          | Pakistan Stock Exchange                                      | Daily closing stock prices from the Pakistan Stock Exchange. |
| SGX          | Singapore Exchange                                           | Asian securities and derivatives exchange that trades in equities for   many large Singaporean and other Asian companies. Listed on its own exchange. |
| UIFS         | United Nations International Financial Statistics            | This database offers comprehensive data on international financial   indicators, such as average earnings, bond yields, government revenues and   expenditures. |
| UINC         | United Nations Industrial Commodities                        | This database offers global data on production of industrial commodities,   such as ores and minerals, food products, transportable goods, and metal   products. |
| INSEE        | National Institute of Statistics and Economic Studies (France) | INSEE is the national statistical agency of France. It collects data on   Frances economy and society, such as socioeconomic indicators and national   accounts. |
| SNB          | Swiss National Bank                                          | Central bank responsible for monetary policy and currency. Data on   international accounts, interest rates, money supply, and other macroeconomic   indicators. |
| ODE          | Osaka Dojima Commodity Exchange                              | A non-profit commodity exchange in the Kansai region of Japan that trades   in seven key agricultural commodities. |
| WGEN         | World Bank Gender Statistics                                 | Data describing gender differences in earnings, types of jobs, sectors of   work, farmer productivity, and entrepreneurs’ firm sizes and profits. |
| WHNP         | World Bank Health Nutrition and Population Statistics        | Key health, nutrition and   population statistics.           |
| WIDA         | World Bank International Development Association             | Data on progress on aggregate outcomes for IDA (International Development   Association) countries for selected indicators. |
| ECMCI        | European Commission Monetary Conditions Index                | Updated monthly, this database provides monetary conditions index values   in the Euro zone. History goes back to 1999. |
| NBSC         | National Bureau of Statistics of China                       | Statistics of China relating to finance, industry, trade, agriculture,   real estate, and transportation. |
| MAS          | Monetary Authority of Singapore                              | No description for this database yet.                        |
| MGEX         | Minneapolis Grain Exchange                                   | A marketplace of futures and options contracts for regional commodities   that facilitates trade of agricultural indexes. |
| WWGI         | World Bank Worldwide Governance Indicators                   | Data on aggregate and individual   governance indicators for six dimensions of governance. |
| ISM          | Institute for Supply Management                              | ISM promotes supply-chain management practices and publishes data on   production and supply chains, new orders, inventories, and capital   expenditures. |
| UKR          | Ukrainian Exchange                                           | No description for this database yet.                        |
| FRBNY        | Federal Reserve Bank of New York                             | The FRBNY is the largest regional central bank in the US. Sets monetary   policy for New York, most of Connecticut and New Jersey, and some   territories. |
| FRBP         | Federal Reserve Bank of Philadelphia                         | The FRBP is a regional central bank for the Federal Reserve. It publishes   data on business confidence indexes, GDP, consumption, and other economic   indicators. |
| FMSTREAS     | US Treasury - Financial Management Service                   | The monthly receipts/outlays and deficit/surplus of the United States of   America. |
| EIA          | U.S. Energy Information Administration Data                  | US national and state data on production, consumption and other   indicators on all major energy products, such as electricity, coal, natural   gas and petroleum. |
| SOCSEC       | Social Security Administration                               | Provides data on the US social security program, particularly   demographics of beneficiaries; disabled, elderly, and survivors. |
| TFGRAIN      | Top Flight Grain Co-operative                                | Cash price of corn and soybeans including basis to front month futures   contract. |
| IRPR         | Puerto Rico Institute of Statistics                          | Puerto Rico Institute of Statistics statistics on manufacturing. |
| BCHAIN       | Blockchain                                                   | Blockchain is a website that publishes data related to Bitcoin, updated   daily. |
| BITCOINWATCH | Bitcoin Watch                                                | Bitcoin mining statistics.                                   |
| ODA          | IMF Cross Country Macroeconomic Statistics                   | IMF primary commodity prices and world economic outlook data, published   by Open Data for Africa. Excellent cross-country macroeconomic data. |
| WADI         | World Bank Africa Development Indicators                     | A collection of development   indicators on Africa, including national, regional and global   estimates. |
| WEDU         | World Bank Education Statistics                              | Internationally comparable   indicators on education access, progression, completion, literacy, teachers,   population, and expenditures. |
| WGLF         | World Bank Global Findex (Global Financial Inclusion database) | Indicators of financial inclusion measures on how people save, borrow,   make payments and manage risk. |
| WWID         | World Wealth and Income Database                             | The World Wealth and Income Database aims to provide open and convenient   access to the most extensive available database on the historical evolution   of the world distribution of income and wealth, both within countries and   between countries. |
| BTER         | BTER                                                         | Historical exchange rate data for crypto currencies.         |
| CFTC         | Commodity Futures Trading Commission Reports                 | Weekly Commitment of Traders and Concentration Ratios. Reports for   futures positions, as well as futures plus options positions. New and legacy   formats. |
| BOE          | Bank of England Official Statistics                          | Current and historical exchange rates, interest rates on secured loans   and time deposits, Euro-commercial paper rates, and yields on government   securities. |
| EXMPL        | Quandl Example Time-Series Data                              | An example time series database.                             |
| WORLDAL      | Aluminium Prices                                             | World Aluminium capacity and production in thousand metric tonnes. |
| WGC          | Gold Prices                                                  | The World Gold Council is a market development organization for the gold   industry. It publishes data on gold prices in different currencies. |
| MX           | Canadian Futures                                             | Montreal Exchange is a derivatives exchange that trades in futures   contracts and options for equities, indices, currencies, ETFs, energy, and   interest rates. |
| UMICH        | Consumer Sentiment                                           | The University of Michigan’s consumer survey - data points for the most   recent 6 months are unofficial; they are sourced from articles in the Wall   Street Journal. |
| JOHNMATT     | Rare Metals                                                  | Current and historical data on platinum group metals such as prices,   supply, and demand. |
| NAHB         | US Housing Indices                                           | Housing and economic indices for the United States.          |
| RATEINF      | Inflation Rates                                              | Inflation Rates and the Consumer Price Index CPI for Argentina,   Australia, Canada, Germany, Euro area, France, Italy, Japan, New Zealand and   more. |
| RENCAP       | IPOs                                                         | Data on the IPO market in the United States.                 |
| ML           | Corporate Bond Yield Rates                                   | Merrill Lynch, a major U.S. bank, publishes data on yield rates for   corporate bonds in different regions. |
| MULTPL       | S&P 500 Ratios                                               | No description for this database yet.                        |
| RICI         | Commodity Indices                                            | Composite, USD based, total return index, representing the value of a   basket of commodities consumed in the global economy. |
| AAII         | Investor Sentiment                                           | American Association of Individual Investor’s sentiment data. |
| BIS          | Bank for International Settlements                           | BIS serves central banks with administration of monetary and financial   stability, fosters international cooperation, and acts as bank for central   banks. |
| BCB          | Central Bank of Brazil Statistical Database                  | Brazilian macroeconomic data, covering public finances, national   accounts, payment systems, inflation, exchange rates, trade, and   international reserves. |
| BCRA         | Central Bank of Argentina                                    | The Central Bank of Argentina is responsible monetary policy and provides   data on foreign exchange markets and key macroeconomic indicators. |
| FSE          | Frankfurt Stock Exchange                                     | Daily stock prices from the Frankfurt Stock Exchange         |
| BLSN         | BLS International                                            | Import and export price statistics for various countries, published by   the Bureau of Labor Statistics. |
| BLSP         | BLS Productivity                                             | US manufacturing, labor and business statistics, published by the Bureau   of Labor Statistics. |
| FDIC         | Federal Deposit Insurance Corporation                        | The FDIC is a federal insurer of bank deposits up to $250k and collects   finance data on commercial banking and savings institutions. |
| BLSI         | BLS Inflation & Prices                                       | US national and state-level inflation data, published by the Bureau of   Labor Statistics. |
| BLSE         | BLS Employment & Unemployment                                | US national and state-level employment and unemployment statistics,   published by the Bureau of Labor Statistics. |
| BLSB         | BLS Pay & Benefits                                           | US work stoppage statistics, published by the Bureau of Labor Statistics. |
| BP           | Energy Production and Consumption                            | BP is a large energy producer and distributor. It provides data on energy   production and consumption in individual countries and larger subregions. |
| LPPM         | Platinum & Palladium Prices                                  | Price data on the market-clearing level for Palladium and Platinum around   the world. |
| CASS         | Freight Indices                                              | Since 1990, CASS provides monthly Cass Freight Index Reports on freight   trends as they relate to other economic and supply chain indicators. |
| MORTGAGEX    | ARM Indices                                                  | Historical housing data on ARM indexes.                      |
| BUCHARESTSE  | Bucharest Stock Exchange                                     | The Bucharest Stock Exchange publishes data on it activity in equity,   rights, bonds, fund units, structured products, and futures contracts. |
| AMECO        | European Commission Annual Macro-Economic Database           | Annual macro-economic database of the European Commissions Directorate   General for Economic and Financial Affairs (DG ECFIN). |
| ACC          | American Chemistry Council                                   | Chemical Activity Barometer (CAB) published by the American Chemistry   Council (ACC). The CAB is an economic indicator that helps anticipate peaks   and troughs in the overall US economy and highlights potential trends in   other industries in the US. |
| ABMI         | Asia Bond Market Initiative                                  | Indicators of Chinese and Japanese bond markets, such as size and   composition, market liquidity, yield returns, and volatility. |
| BITAL        | Borsa Italiana                                               | This database provides data on stock future contracts from the Borsa   Italiana, now part of London Stock Exchange Group. |
| BANKRUSSIA   | Bank of Russia                                               | Primary indicators from the Bank of Russia, including data on the banking   sector, money supply, financial markets and macroeconomic statistical data. |
| BOC          | Bank of Canada Statistical Database                          | Economic, financial and banking data for Canada. Includes interest rates,   inflation, national accounts and more.    Daily updates. |
| HKEX         | Hong Kong Exchange                                           | Hong Kong Exchange stock prices, historical divided futures, etc. updated   daily. |
| AMFI         | Association of Mutual Funds in India                         | This database represents fund information from The Association of Mutual   Funds in India. |
| BDM          | Bank of Mexico                                               | The Bank of Mexico is responsible for monetary policy and the national   currency (peso), and provides data on accounts and all macroeconomic   variables. |
| BATS         | BATS U.S. Stock Exchanges                                    | Bats is an equities market operator in the U.S., operating four equities   exchanges — BZX Exchange, BYX Exchange, EDGA Exchange, and EDGX Exchange |
| BSE          | Bombay Stock Exchange                                        | End of day prices, indices, and   additional information for companies trading on the Bombay Stock Exchange in   India. |
| FRED         | Federal Reserve Economic Data                                | Growth, employment, inflation, labor, manufacturing and other US economic   statistics from the research department of the Federal Reserve Bank of St.   Louis. |
| FMAC         | Freddie Mac                                                  | Data from Freddie Mac’s Primary Mortgage Market Survey and other region   specific historical mortgage rates. |
| EUREX        | EUREX Futures Data                                           | Index, rate, agriculture and energy futures from EUREX, Europes largest   futures exchange, with history spanning a decade for select futures. |
| ECB          | European Central Bank                                        | The central bank for the European Union oversees monetary policy and the   Euro, and provides data on related macroeconomic variables. |
| BOF          | Bank of France                                               | The Banque de France is responsible for monetary policy through policies   of the European System of Central Banks and providing data on key economic   indictors. |
| BELGRADESE   | Belgrade Stock Exchange                                      | Belgrade Stock Exchange data, updated daily.                 |
| CHRIS        | Wiki Continuous Futures                                      | Continuous contracts for all 600 futures on Quandl. Built on top of raw   data from CME, ICE, LIFFE etc. Curated by the Quandl community. 50 years   history. |
| BOJ          | Bank of Japan                                                | nan                                                          |
| USTREASURY   | US Treasury                                                  | The U.S. Treasury ensures the nations financial security, manages the   nations debt, collects tax revenues, and issues currency, provides data on   yield rates. |
| LBMA         | London Bullion Market Association                            | An international trade association in the London gold and silver market,   consisting of central banks, private investors, producers, refiners, and   other agents. |
| PERTH        | Perth Mint                                                   | The Perth Mint’s highs, lows and averages of interest rates and   commodities prices, updated on a monthly basis. |
| ZILLOW2      | Zillow Real Estate Research                                  | Home prices and rents by size, type and tier; housing supply, demand and   sales. Sliced by zip code, neighbourhood, city, metro area, county and state. |
