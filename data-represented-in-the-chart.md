# Data represented in the chart

The appearance of the chart is determined by the following data  
1. Start date of the chart
2. End date of the chart
3. End date of burndown line

### 1. Start date of the chart

Set from the following conditions:  
* If a "start date" is set for an issue in a version 
  * set the earliest start date of the issue in the version 

* If a "start date" is not set for an issue in a version
  * set the creation date of the version

### 2. End date of the chart
Set from the following conditions:

* If all issues in a version have been completed
  * Set from the most recent date below
    * due date of the version
     * completion date of the issue in the version

* If not all issues in a version have been completed
  * If none of the issues in a version have been completed
    * Set from the most recent date below
    * due date of the version, if not, today's date   
    * creation date of the issue in the version

  * If more than one issue has been completed
    * Set from the most recent date below
    * due date of the version, if not, today's date
    * creation date of the issue in the version
    * completion date of the issue in the version

### 3 The end date of burndown line

Set from the most earliest date below:
* today's date
* end date of the chart

## line to be drawn on the chart

1. Ideal line
2. Number of all issues - Number of issues that have been completed
3. Number of issues that have not been completed

### 1. ideal line

Drawn under the following conditions:
* If a due date is set for the version
  * A straight line is drawn with the following two points
  * Start date of the chart -> Total number of issues in the version
  * Completion date of the version -> 0 issues
* If a due date is not set for the version 
  * No line is drawn

### 2. Total number of issues - Number of issues that have been completed

The following numbers are drawn for each day from the start date of the chart to the end date of the line

`Total number of issues in the version - Number of issues that have been completed as of that date`

### 3. Number of issues that have not been completed

The following number of issues are drawn for each day between the start date of the chart and the end date of the line

`Number of issues that have not been completed as of that date`
