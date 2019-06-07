# Administrative Data Research Facilities Site

This repository replaces the Administrative Data Research Facilities (ADRF) website.

## About

Across multiple disciplines, from healthcare to justice to poverty to housing, there are projects that benefit greatly from use of the administrative datasets made available by the government. Our project seeks to clean and combine two of these administrative datasets and then build an easily accessible, open source, cloud-based platform that can be used by social scientists to analyze the data. This was a joint effort between Urban's Housing Finance Policy Center and the Data Science and Technology team at Urban.

This project was funded by the Alfred P. Sloan Foundation.

## The Data

The project explored data collection and sampling from public sources that offer robust information regarding mortgages, people and place. We have standardized and linked key data variables over time from two government data sources, the [Home Mortgage Disclosure Act (HMDA)](https://www.ffiec.gov/hmda/hmdaproducts.htm) and the [Census American Community Survey (ACS)](https://www.census.gov/programs-surveys/acs/).

[Urban ADRF 101 Slides]()

[Download Data Dictionary]()

Citation: Urban Institute Sloan ADRF Database. Retrieved from http://adrf.urban.org. 2017.

Note that we no longer make the data available, but it can be reproduced using the files, data, and links in this repository.

### Geographic Crosswalks Used to Create the Data
Crosswalk data sourced from: Missouri Census Data Center, MABLE/Geocorr2k and MABLE/Geocorr14, Version 1.0: Geographic Correspondence Engine. Web application accessed August, 2017 at: http://mcdc.missouri.edu/websas/geocorr14.html

## Sample Research Products

Housing Profile of Areas Affected by Hurricane Harvey
Bing Bai, Sarah Strochak, Bhargavi Ganesh
October 27, 2017

Housing Profile of Areas Affected by Hurricane Irma
Bing Bai, Sarah Strochak, Bhargavi Ganesh
October 27, 2017

Housing Affordability: Local and National Perspectives
Laurie Goodman, Wei Li, Jun Zhu
March 28, 2018

Is Limited English Proficiency a Barrier to Homeownership?
Edward Golding, Laurie Goodman, Sarah Strochak
March 26, 2018

## Spark for Social Science

SPARK FOR SOCIAL SCIENCE
Urban has developed an elastic and powerful approach to the analysis of massive datasets using Amazon Web Services’ Elastic MapReduce (EMR) and the Spark framework for distributed memory and processing. For tutorials and to use Spark to analyze the linked datasets we’ve created using HMDA and ACS data, visit our project on GitHub.

https://github.com/UrbanInstitute/spark-social-science

## Code for Generating the ADRF Data

This repository holds the code for creating the linked Home Mortgage Disclosure Act (HMDA) and American Community Survey Public Use Microdata (ACS PUMS) files on the [Administrative Data Research Facilities (ADRF) page](https://adrf.urban.org). All code is written in SAS and authored by [Jun Zhu](https://www.urban.org/author/jun-zhu), of the Urban Institute. Please see the [ADRF website](https://adrf.urban.org) for more information on citation.

## License

MIT License

Copyright (c) 2018 Urban Institute

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
