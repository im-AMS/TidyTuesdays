### [2022 Week 26:](https://github.com/im-AMS/TidyTuesdays/blob/main/Plots/2022/W26) Gender Pay Gap in UK 

![./Plots/2022/W26/W26.png](https://github.com/im-AMS/TidyTuesdays/blob/main/Plots/2022/W26/W26.png)


# UK Paygap

The data this week comes from [gender-pay-gap.service.gov.uk](https://gender-pay-gap.service.gov.uk/viewing/download). The online [tool](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/articles/findoutthegenderpaygapforyourjob/2016-12-09) reports by gender and occupation. The online [quiz](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/articles/testyourknowledgeonthegenderpaygap/2016-12-09) lets you test your knowledge/guesses.



### Data Dictionary

# `paygap.csv`

| **Field**                 | **Description**                                                                                                                                                                                                         | **Source**                                                                        |
|:--------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------|
| EmployerName              | The name of the employer at the time of reporting                                                                                                                                                                       | Via CoHo API or manually entered by user when adding an employer to their account |
| EmployerID                | Unique ID assigned to each employer that is consistent across every reporting year                                                                                                                                      | Generated by the system                                                           |
| Address                   | The current registered address of the employer                                                                                                                                                                          | Via CoHo API or manually entered by user when adding an employer to their account |
| PostCode                  | The postal code of the current registered address of the employer                                                                                                                                                       | Via CoHo API or manually entered by user when adding an employer to their account |
| CompanyNumber             | The Company Number of the employer as listed on Companies House (null for public sector)                                                                                                                                | Via CoHo API                                                                      |
| SicCodes                  | List of comma-separated SIC codes used to describe the employer's purpose and sectors of work at the time of reporting                                                                                                  | Via CoHo API or manually entered by user when adding an employer to their account |
| DiffMeanHourlyPercent     | Mean % difference between male and female hourly pay (negative = women's mean hourly pay is higher)                                                                                                                     | Entered by a user when reporting GPG data                                         |
| DiffMedianHourlyPercent   | Median % difference between male and female hourly pay (negative = women's median hourly pay is higher)                                                                                                                 | Entered by a user when reporting GPG data                                         |
| DiffMeanBonusPercent      | Mean % difference between male and female bonus pay (negative = women's mean bonus pay is higher)                                                                                                                       | Entered by a user when reporting GPG data                                         |
| DiffMedianBonusPercent    | Median % difference between male and female bonus pay (negative = women's median bonus pay is higher)                                                                                                                   | Entered by a user when reporting GPG data                                         |
| MaleBonusPercent          | Percentage of male employees paid a bonus                                                                                                                                                                               | Entered by a user when reporting GPG data                                         |
| FemaleBonusPercent        | Percentage of female employees paid a bonus                                                                                                                                                                             | Entered by a user when reporting GPG data                                         |
| MaleLowerQuartile         | Percentage of males in the lower hourly pay quarter                                                                                                                                                                     | Entered by a user when reporting GPG data                                         |
| FemaleLowerQuartile       | Percentage of females in the lower hourly pay quarter                                                                                                                                                                   | Entered by a user when reporting GPG data                                         |
| MaleLowerMiddleQuartile   | Percentage of males in the lower middle hourly pay quarter                                                                                                                                                              | Entered by a user when reporting GPG data                                         |
| FemaleLowerMiddleQuartile | Percentage of females in the lower middle hourly pay quarter                                                                                                                                                            | Entered by a user when reporting GPG data                                         |
| MaleUpperMiddleQuartile   | Percentage of males in the upper middle hourly pay quarter                                                                                                                                                              | Entered by a user when reporting GPG data                                         |
| FemaleUpperMiddleQuartile | Percentage of females in the upper middle hourly pay quarter                                                                                                                                                            | Entered by a user when reporting GPG data                                         |
| MaleTopQuartile           | Percentage of males in the top hourly pay quarter                                                                                                                                                                       | Entered by a user when reporting GPG data                                         |
| FemaleTopQuartile         | Percentage of females in the top hourly pay quarter                                                                                                                                                                     | Entered by a user when reporting GPG data                                         |
| CompanyLinkToGPGInfo      | Voluntary link to additional GPG data published by the reporting employer                                                                                                                                               | Entered by a user when reporting GPG data                                         |
| ResponsiblePerson         | The name of the responsible person who confirms that the published information is accurate - Employers covered by the private sector regulations only                                                                   | Entered by a user when reporting GPG data                                         |
| EmployerSize              | Number of employees employed by an employer                                                                                                                                                                             | Entered by a user when reporting GPG data                                         |
| CurrentName               | The current name of the employer                                                                                                                                                                                        | Via CoHo API or manually entered by user when adding an employer to their account |
| SubmittedAfterTheDeadline | TRUE/FALSE value showing whether the employee submitted their GPG data after the relevant reporting deadline. If a report is updated after the initial submission, it is marked as late only if the figures are changed | Generated by the system                                                           |
| DueDate                   | The date that the GPG data should have been submitted by. Format: dd/MM/yyyy HH:mm:ss                                                                                                                                   | Generated by the system                                                           |
| DateSubmitted             | Date that GPG data was submitted (if this was updated after the initial submission, this date also changes). Format: dd/MM/yyyy HH:mm:ss                                                                                | Generated by the system                                                           |