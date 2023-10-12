# MarketingAndSalesAnalysis

## Service Under Analysis
This study focuses on analyzing a "consulting service in Advanced Analytics for Business and Industry" with the purpose of identifying the preferences of potential consumers in relation to a set of offered attributes.
The decision to investigate this business model was made because it is considered to offer significant opportunities. The objective of the analysis is to understand which aspects of the service are most valued by customers.

Data used: RespuestasFormulario.csv

## Linear Regressions to Estimate Partial Values for Each Respondent
Linear regressions were applied to each respondent with the dependent variable "Preference" to gain a better understanding of how these attributes impact the respondents' decisions.

As observed, the coefficients for the attributes "SeguridadDatosEstandar," "TiempoEntregaValorLento," "MetodologiaSeguimientoPasIva," and "Price1000" return 'NA' (Not Available). This is because these attributes were previously selected in the code to be treated as the reference category, as they are considered the least desirable combination of attributes to offer.
Hence, the coefficients for these reference categories are not estimated separately, unlike the other categories. They are implicitly included within the "intercept" coefficient.

For example, let's consider the coefficients for "Intercept" and "SeguridadDatosAlta" for respondent number 1:
(Intercept): The coefficient represents the expected value of the dependent variable (Preference) when all other predictors are equal to zero. In this context, it signifies the level of preference when all attributes are in their reference categories. This means that the predicted level of preference for a service that offers "SeguridadDatosEstandar," "TiempoEntregaValorLento," "Price1000," and "MetodologiaSeguimientoPasIva" is 1.49 units for that person.
SeguridadDatosAlta: The "SeguridadDatosAlta" coefficient represents the change in the expected value of the dependent variable (Preference) when the attribute "Seguridad Datos" changes from its reference category "Estándar" to the "Alta" category, while keeping all other predictors constant. This means that, on average, when data security is considered "Alta" instead of "Estándar," the preference increases by 1.60 units for this respondent.

NOTE: For the analysis, it is assumed that all variables are statistically significant, even though some may not be. This assumption is due to the small sample size analyzed.

## Relative Importance of Each Attribute for Each Respondent
The relative importance of each attribute for each respondent was calculated to understand the effect of these attributes on service preference. The formula used for the calculation is as follows:

![image](https://github.com/SantiagoRomanoOddone/MarketingAndSalesAnalysis/assets/93267679/9067e1b6-571c-421c-8603-9efa9b832c79)
