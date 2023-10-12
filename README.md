# MarketingAndSalesAnalysis

## Service Under Analysis
This study focuses on analyzing a "consulting service in Advanced Analytics for Business and Industry" with the purpose of identifying the preferences of potential consumers in relation to a set of offered attributes.
The decision to investigate this business model was made because it is considered to offer significant opportunities. The objective of the analysis is to understand which aspects of the service are most valued by customers.

## Definition of Service Attributes Under Analysis
To define the attributes of the value proposition, various ways of offering this type of service were investigated, and the most important considerations for customers were identified. Three attributes of the highest relevance, apart from price, were then selected. Different combinations of these attributes offer services with distinct characteristics, generating varying levels of preference based on each customer's interests.

The attributes are defined as follows:

**Data Security:** This pertains to the measures and practices implemented to protect the confidentiality, integrity, and availability of information. This is of paramount importance because, in most cases, customers must provide critical and confidential information to conduct predictive and prescriptive analyses. Therefore, a high level of responsibility is required to safeguard information and instill confidence. Two levels are offered:
Standard:Two-factor authentication, Confidentiality agreements, Secure data disposal.
High: All features of the Standard version, Data encryption during transfer and storage, Strict access policies, Real-time monitoring.

**Value Delivery Time:** This refers to the estimated period for delivering results to the customer. After each value delivery, the time for the next delivery can be redefined if necessary. Three levels are offered:
Slow: Less than 4 weeks.
Medium: Less than 2 weeks.
Fast: Less than 1 week.

**Tracking Methodology:** This pertains to the approach and frequency with which deliverables are monitored and evaluated. Three levels are offered:
Passive: No scheduled tracking meetings. Results are presented at the defined value delivery time.
Regular: Weekly meetings to review progress and facilitate ongoing communication.
Active: Daily meetings and constant feedback. Implementation of agile methodologies for tracking.

**Price:** This refers to the cost of the service. Three levels are offered:
Low: $500 USD.
Medium: $750 USD.
High: $1000 USD.

Since we have 4 attributes with the following levels (2 * 3 * 3 * 3), there are 54 possible combinations. However, this model table reduces the total number of relevant profiles to analyze to 18.
The obtained combinations are as follows:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/d5908d6d-2b16-4daa-a881-c805d5fa0b4c)

Once the combinations were defined, a survey was created with the aim of collecting responses from 15 individuals to evaluate the 18 service profiles. The survey used a scoring system from 1 (very unsatisfied) to 9 (very satisfied).
https://forms.gle/ooLJ5rniHbKBUuJ37
Given that the service is geared towards addressing challenges in the business and industry sector, and recognizing the difficulty in accessing information about the preferences of large companies, the objective was to survey individuals associated with small and medium-sized enterprises, specialized consultants in this field, and professionals working in this industry. The results of the surveys conducted by the 15 participants were pre-processed to generate a .csv format table, which was subsequently subjected to a conjoint analysis using RStudio.
**Data used: RespuestasFormulario.csv**

## Linear Regressions to Estimate Partial Values for Each Respondent
Linear regressions were applied to each respondent with the dependent variable "Preference" to gain a better understanding of how these attributes impact the respondents' decisions.
As an example, here is the regression for respondent number 1:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/f646afb2-3c18-4796-8320-7ab135e9089a)
As observed, the coefficients for the attributes "SeguridadDatosEstandar," "TiempoEntregaValorLento," "MetodologiaSeguimientoPasIva," and "Price1000" return 'NA' (Not Available). This is because these attributes were previously selected in the code to be treated as the reference category, as they are considered the least desirable combination of attributes to offer.
Hence, the coefficients for these reference categories are not estimated separately, unlike the other categories. They are implicitly included within the "intercept" coefficient.

For example, let's consider the coefficients for "Intercept" and "SeguridadDatosAlta" for respondent number 1:
(Intercept): The coefficient represents the expected value of the dependent variable (Preference) when all other predictors are equal to zero. In this context, it signifies the level of preference when all attributes are in their reference categories. This means that the predicted level of preference for a service that offers "SeguridadDatosEstandar," "TiempoEntregaValorLento," "Price1000," and "MetodologiaSeguimientoPasIva" is 1.49 units for that person.
SeguridadDatosAlta: The "SeguridadDatosAlta" coefficient represents the change in the expected value of the dependent variable (Preference) when the attribute "Seguridad Datos" changes from its reference category "Estándar" to the "Alta" category, while keeping all other predictors constant. This means that, on average, when data security is considered "Alta" instead of "Estándar," the preference increases by 1.60 units for this respondent.

NOTE: For the analysis, it is assumed that all variables are statistically significant, even though some may not be. This assumption is due to the small sample size analyzed.

## Relative Importance of Each Attribute for Each Respondent
The relative importance of each attribute for each respondent was calculated to understand the effect of these attributes on service preference. The formula used for the calculation is as follows:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/9067e1b6-571c-421c-8603-9efa9b832c79)
Here is an example of the attribute importance for respondent number 1:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/b6bf4c37-84d9-4f94-a352-9cf4eda72367)

As observed in the graph, the first respondent assigned the highest importance to the value delivery time, followed by price, data security, and, finally, the tracking methodology to determine their service preference.

## Partial Values Associated with Price for Each Respondent

The estimated coefficients for the levels of the price attribute represent the estimated utilities of the part-worth associated with each price level in the conjoint analysis. These coefficients are essential for understanding how the utility of the service offered changes with price variations.

In this analysis, the highest price was selected as the base level to assess how utility is affected as the price decreases.  Below is an example of the part-worth values associated with the price for respondent number 1:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/4eb150f7-8d1a-4683-931c-a5583939b4d4)

In this specific case, we observe that reducing the price from $1000 to $500 results in an increase in the utility of the service offered by 1.75 units. This indicates that a price reduction has a positive impact on the perceived value for this respondent.

The implications of these graphs for management decisions are significant. This information suggests that, in this particular case, a price decrease can lead to an improvement in the perception of the service and, potentially, an increase in demand for customers with similar characteristics to the surveyed individual. However, it's also crucial to consider the costs associated with the chosen combination of attributes to ensure the service remains profitable.

Furthermore, while this behavior was expected, not all respondents reacted in the same way. For example, respondent number 6:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/7267b60f-d98d-4b6a-b1f0-f697c905c8a5)

In this specific case, we observe that reducing the price from $1000 to $500 results in a decrease in the utility of the service offered by 1 unit. It's apparent that this individual places a high level of importance on quick value delivery and is willing to pay a higher price for it. It's also valid to assume that this person associates a price reduction with a decrease in service quality. Given their understanding that the benefits they can derive from the consultancy far outweigh the cost, they don't see much utility in a lower price. Therefore, this analysis provides valuable insights for decision-making, indicating that individuals like this place higher value on service quality than on price reductions.

These results highlight the importance of defining a dynamic and flexible pricing strategy based on consumer preferences. Management decisions can use these insights to optimize pricing and, ultimately, enhance competitiveness and profitability in the market.

## Willingness to Pay for Improvements in the Most Important Attribute

To calculate the willingness of respondents to pay for changing their most preferred attribute from its lowest level to its highest level, the following steps were followed:

The attribute with the highest relative importance was selected. If it was the price, the second most important attribute was chosen.

The relative utility of moving from the maximum level of the attribute of interest to the minimum level was calculated:

attribute_ut_range = u(max_value) - u(min_value)

The relative utility in relation to price was calculated:

price_ut_range = u(max_price) - u(min_price)

The price range offered was determined:

price_range = max_price - min_price

Finally, the willingness to pay (WTP) was calculated as follows:

wtp = (price_range / price_ut_range) * attribute_ut_range

The calculations for each respondent are shown below:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/c1438671-bbce-44e5-9613-c115abfd93b6)

As illustrated in the table, respondent number 1 is willing to pay $849 to change from the lowest offered level of Value Delivery Time (less than 4 weeks) to the highest offered level (less than 1 week).

Analyzing respondent number 6, who, as mentioned earlier, placed significant importance on the Value Delivery Time attribute, their willingness to improve the Value Delivery Time is $3,298, considerably higher than what respondent 1 is willing to pay.

Similarly, respondent 14 is willing to pay $3,681 to maximize the security of their data, which aligns with their relative importance of attributes, where data security significantly outweighed other attributes for this individual.

## Respondent Segmentation

Respondents were segmented into groups based on the preferences obtained through the calculated regressions. For this purpose, the unsupervised learning model K-means was used, along with the elbow method to determine the optimal number of clusters for this case. Since the model focuses on distances to evaluate similarities in attribute observations, the data was standardized beforehand.

This approach allowed for the classification of customers into four segments. Subsequently, the attribute averages for each group were analyzed to identify the common characteristics that make them similar to each other and distinct from the rest. Below is a graph displaying the results:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/f301c5a3-58fa-4363-b17f-340caf281378)
Different value propositions were defined for each analyzed segment based on their preferences. It's worth noting that the "Intercept" attribute includes the combination of "Standard Data Security," "Value Delivery Time Slow," "Passive Follow-up Methodology," and "Price $1000."
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/8d732d1a-41ec-48e8-acdd-f763619487fa)
As shown in the table above, the value proposition is summarized in four alternatives where customers can choose the one that best suits their primary preferences.

## Analysis of Product Profiles Not Included in the Created Questionnaire

Two product profiles that are not included in the created questionnaire were generated to simulate that they are the only alternatives offered in the market by competitors X and Y. The aim is to understand the market share of each competitor based on the results obtained from the respondents. The two new profiles generated are as follows:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/493c94db-1e27-4269-90a6-6201f746f087)

The utility of the offerings from consumers X and Y was calculated for each of the respondents, resulting in the following outcomes:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/6b574dad-9490-40ad-8a86-6566bce075f3)

For the analysis, it was assumed that customers choose the service that provides them with the highest utility. Subsequently, the market share of each offering among the respondents was calculated, yielding the following outcome:
![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/77fe129b-ead2-46b2-a14a-e952b74ad8e1)

As seen in the graph, competitor Y has an estimated 60% market share. This indicates that, for the respondents in general, the profile offered by competitor Y would generate more utility than the profile of competitor X, and therefore, they would tend to choose it.

THE END -- THANKS IN ADVANCE! 
