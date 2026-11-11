# Food Delivery and Logistics Tracker

A Data Visualization Laboratory project developed using R.

## Project overview

This project analyzes food delivery and logistics records. It calculates order statistics and creates five visualizations:

1. Number of orders by status (bar chart)
2. Average delivery time by vehicle (bar chart)
3. Daily order volume (line graph)
4. Delivery-time distribution (histogram)
5. Delivery distance versus delivery time (scatter plot with a linear trend line)

## Technologies

- R
- RStudio
- dplyr
- ggplot2
- CSV dataset

## Files

- `food_delivery_tracker.R` — main R program
- `food_delivery_data.csv` — required input dataset (not included in this package)
- `plots/` — folder where generated chart images are saved
- `order_status_summary.csv` — generated order-status summary
- `vehicle_delivery_summary.csv` — generated vehicle-wise summary

## Dataset requirement

The report describes an illustrative dataset of 30 records and 11 columns, stored as `food_delivery_data.csv`. The uploaded report does not contain the complete 30-row CSV data file. Add the original CSV file to this folder before running the script.

The CSV must contain these exact column names:

`Order_ID`, `Order_Date`, `City`, `Distance_km`, `Prep_Time_min`, `Delivery_Time_min`, `Delivery_Person`, `Vehicle`, `Order_Status`, `Customer_Rating`, `Order_Value_INR`

Dates should use `YYYY-MM-DD`. Order statuses should use `Delivered`, `Delayed`, and `Cancelled`.

## How to run

1. Install R and RStudio.
2. Open this folder as the RStudio working directory.
3. Put `food_delivery_data.csv` in the same folder as `food_delivery_tracker.R`.
4. Open `food_delivery_tracker.R` in RStudio.
5. Click **Source** or run the script.
6. The summary CSV files and five PNG charts will be generated.

## Note

The script uses the same analysis and chart types described in the project report. Some file paths and inconsistent capitalization in the report screenshots have been standardized so the script can run from the project folder.
