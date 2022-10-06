<!-- badges: start -->
[![Rmarkdown](https://github.com/JGCRI/trackingC/workflows/Rmarkdown/badge.svg)](https://github.com/JGCRI/trackingC/actions)
<!-- badges: end -->

_your zenodo badge here_

# Pressburger-etal_2022_journal

**Quantifying Airborne Fraction Trends and the Ultimate Fate of Anthropogenic CO~2~ by Tracking Carbon Flows in a Simple Climate Model**

Leeya Pressburger<sup>1\*</sup>, Kalyn Dorheim<sup>1</sup>, Trevor Keenan<sup>2,</sup><sup>3</sup>, Haewon McJeon<sup>1</sup>, Steven J. Smith<sup>1</sup>, and Ben Bond-Lamberty<sup>1</sup>

<sup>1 </sup> Joint Global Change Research Institute, Pacific Northwest National Laboratory, 5825 University Research Ct. #3500, College Park MD, USA

<sup>2 </sup> Department of Environmental Science, Policy and Management, UC Berkeley, Berkeley CA, USA

<sup>3 </sup>Climate and Ecosystem Sciences Division, Lawrence Berkeley National Laboratory, Berkeley CA, USA

\* corresponding author: leeya.pressburger@gmail.com

## Abstract
Carbon dioxide (CO<sub>2</sub>) concentrations have increased in the atmosphere as a direct result of human activity and are at their highest level over the last 2-3 million years, with profound impacts on the Earth system. However, the magnitude and future dynamics of land and ocean carbon sinks are not well understood; therefore, the amount of anthropogenic emissions that remains in the atmosphere (the airborne fraction) is poorly constrained. As such, this work aims to quantify the sources and controls of atmospheric CO<sub>2</sub>, the ultimate fate of anthropogenic CO<sub>2</sub>, and the trend and robustness of the airborne fraction. We use Hector v3.0, a reduced form process-based coupled climate and carbon cycle model, with the novel ability to explicitly track carbon as it flows through the Earth system. This provides an unambiguous computation of metrics such as the airborne fraction irrespective of model feedbacks. We use _a priori_ probability distribution functions for key model parameters in a Monte Carlo analysis of 10,000 model runs from 1750 to 2300. Results are filtered for physical realism against historical observations and CMIP6 projection data, and we calculate variance decomposition and the relative importance of parameters controlling how much CO<sub>2</sub> ends up in the atmosphere. We find that anthropogenic emissions are the dominant source of near- and long-term atmospheric CO<sub>2</sub>, composing roughly 45% of the atmosphere. This is consistent with observational studies of the airborne fraction. However, when looking at the destination of anthropogenic emissions, only a quarter ends up in the atmosphere while more than half of emissions are taken up by the land sink. We also find statistically significant evidence for a negative trend in the airborne fraction from 1960-2020, implying that current-day land and ocean sinks are more than keeping up with anthropogenic emissions. This study evaluates the likelihood of airborne fraction trends and provides insights into the dynamics and final destination of anthropogenic CO<sub>2</sub> in the Earth system.

## Journal reference
TBD.

## Code reference

TBD.

## Data reference

### Input data

### Output data


## Contributing modeling software
| Model | Version | Repository Link | DOI |
|-------|---------|-----------------|-----|
| Hector | 3.0.0 | https://github.com/JGCRI/hector | TBD |


## Reproduce my experiment
For local test/debugging purposes, you may want to do
```r
Sys.setenv(CI = "true")
```
before running; this will limit the number of Hector runs.


1. Install the software components required to conduct the experiment from [the Hector repository](https://github.com/JGCRI/hector)
2. Download and install the supporting input data required to conduct the experiment from [the Hector CMIP6 data processing repository](https://github.com/JGCRI/hector_cmip6data/tree/main/outputs)
3. Run the following script in the `workflow` directory to re-create this experiment:

| Script Name | Description | 
| --- | --- |
| `01_generate_data.Rmd` | Script to create list of input parameters and run Hector |


## Reproduce my figures
Use these scripts found in the `workflow` directory to reproduce the figures used in this publication.

| Script Name | Description | How to Run |
| --- | --- | --- |
| `02_pre_processing.Rmd` | Script to generate calibration figures (CO2 and temperature) and produce updated output data |
| `03_generate_figures.Rmd` | Script to generate primary report figures |
| `04_supplementary_figures.Rmd` | Script to generate supplementary report figures | 

