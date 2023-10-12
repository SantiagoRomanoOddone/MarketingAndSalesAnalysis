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

As observed, the coefficients for the attributes "SeguridadDatosEstandar," "TiempoEntregaValorLento," "MetodologiaSeguimientoPasIva," and "Price1000" return 'NA' (Not Available). This is because these attributes were previously selected in the code to be treated as the reference category, as they are considered the least desirable combination of attributes to offer.
Hence, the coefficients for these reference categories are not estimated separately, unlike the other categories. They are implicitly included within the "intercept" coefficient.

For example, let's consider the coefficients for "Intercept" and "SeguridadDatosAlta" for respondent number 1:
(Intercept): The coefficient represents the expected value of the dependent variable (Preference) when all other predictors are equal to zero. In this context, it signifies the level of preference when all attributes are in their reference categories. This means that the predicted level of preference for a service that offers "SeguridadDatosEstandar," "TiempoEntregaValorLento," "Price1000," and "MetodologiaSeguimientoPasIva" is 1.49 units for that person.
SeguridadDatosAlta: The "SeguridadDatosAlta" coefficient represents the change in the expected value of the dependent variable (Preference) when the attribute "Seguridad Datos" changes from its reference category "Estándar" to the "Alta" category, while keeping all other predictors constant. This means that, on average, when data security is considered "Alta" instead of "Estándar," the preference increases by 1.60 units for this respondent.

NOTE: For the analysis, it is assumed that all variables are statistically significant, even though some may not be. This assumption is due to the small sample size analyzed.

## Relative Importance of Each Attribute for Each Respondent
The relative importance of each attribute for each respondent was calculated to understand the effect of these attributes on service preference. The formula used for the calculation is as follows:

![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/9067e1b6-571c-421c-8603-9efa9b832c79)
