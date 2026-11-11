# ============================================================
# FOOD DELIVERY AND LOGISTICS TRACKER
# Data Visualization Laboratory Project
# Language: R
# Packages: dplyr, ggplot2
#
# Required input file:
#   food_delivery_data.csv
#
# Expected columns:
# Order_ID, Order_Date, City, Distance_km, Prep_Time_min,
# Delivery_Time_min, Delivery_Person, Vehicle, Order_Status,
# Customer_Rating, Order_Value_INR
# ============================================================

# 1. Install packages if they are not already installed
required_packages <- c("dplyr", "ggplot2")

for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
}

# 2. Load packages
library(dplyr)
library(ggplot2)

# 3. Import the dataset
data_file <- "food_delivery_data.csv"

if (!file.exists(data_file)) {
  stop(
    paste0(
      "Cannot find ", data_file,
      ". Place the CSV file in the same folder as this R script ",
      "or set the working directory to the project folder."
    )
  )
}

orders <- read.csv(data_file, stringsAsFactors = FALSE)

# 4. Prepare and inspect the data
# Convert the order date into Date format.
orders$Order_Date <- as.Date(orders$Order_Date)

cat("Dataset imported successfully\n\n")

# Display first six records
print(head(orders))

# Display dataset dimensions
cat("\nDataset dimensions:\n")
print(dim(orders))

# Display column names
cat("\nColumn names:\n")
print(names(orders))

# Display structure and data types
cat("\nDataset structure:\n")
str(orders)

# Display descriptive statistics
cat("\nDescriptive statistics:\n")
print(summary(orders))

# Check missing values in each column
cat("\nMissing values in each column:\n")
print(colSums(is.na(orders)))

# 5. Statistical analysis and key performance indicators

total_orders <- nrow(orders)

delivered_orders <- sum(
  orders$Order_Status == "Delivered",
  na.rm = TRUE
)

delayed_orders <- sum(
  orders$Order_Status == "Delayed",
  na.rm = TRUE
)

cancelled_orders <- sum(
  orders$Order_Status == "Cancelled",
  na.rm = TRUE
)

delivery_rate <- round(
  delivered_orders / total_orders * 100,
  1
)

# Average delivery time is calculated for delivered orders.
average_delivery_time <- orders %>%
  filter(
    Order_Status == "Delivered",
    !is.na(Delivery_Time_min)
  ) %>%
  summarise(
    Average_Time = round(mean(Delivery_Time_min), 1)
  )

average_order_value <- round(
  mean(orders$Order_Value_INR, na.rm = TRUE),
  2
)

cat("\nKEY PERFORMANCE INDICATORS\n")
cat("Total Orders:", total_orders, "\n")
cat("Delivered Orders:", delivered_orders, "\n")
cat("Delayed Orders:", delayed_orders, "\n")
cat("Cancelled Orders:", cancelled_orders, "\n")
cat("Delivery Rate:", delivery_rate, "%\n")
cat("Average Delivery Time:\n")
print(average_delivery_time)
cat("Average Order Value: Rs.", average_order_value, "\n")

# 6. Order status summary
status_table <- orders %>%
  count(Order_Status, name = "Number_of_Orders") %>%
  mutate(
    Percentage = round(
      Number_of_Orders / sum(Number_of_Orders) * 100,
      1
    )
  )

cat("\nORDER STATUS SUMMARY\n")
print(status_table)

# 7. Vehicle-wise average delivery time
# Cancelled orders and missing delivery times are excluded.
vehicle_table <- orders %>%
  filter(
    Order_Status != "Cancelled",
    !is.na(Delivery_Time_min)
  ) %>%
  group_by(Vehicle) %>%
  summarise(
    Orders = n(),
    Average_Delivery_Time = round(mean(Delivery_Time_min), 1),
    .groups = "drop"
  )

cat("\nVEHICLE-WISE DELIVERY SUMMARY\n")
print(vehicle_table)

# 8. Visualization 1: Bar chart - Order status
status_plot <- ggplot(
  orders,
  aes(x = Order_Status, fill = Order_Status)
) +
  geom_bar() +
  labs(
    title = "Number of Orders by Status",
    x = "Order Status",
    y = "Number of Orders"
  ) +
  theme_minimal()

print(status_plot)

# 9. Visualization 2: Vehicle-wise average delivery time
vehicle_plot <- orders %>%
  filter(
    Order_Status != "Cancelled",
    !is.na(Delivery_Time_min)
  ) %>%
  ggplot(
    aes(
      x = Vehicle,
      y = Delivery_Time_min,
      fill = Vehicle
    )
  ) +
  stat_summary(fun = mean, geom = "bar") +
  labs(
    title = "Average Delivery Time by Vehicle",
    x = "Vehicle Type",
    y = "Average Delivery Time (Minutes)"
  ) +
  theme_minimal()

print(vehicle_plot)

# 10. Visualization 3: Line graph - Daily order volume
daily_orders <- orders %>%
  count(Order_Date, name = "Number_of_Orders")

daily_plot <- ggplot(
  daily_orders,
  aes(x = Order_Date, y = Number_of_Orders)
) +
  geom_line() +
  geom_point() +
  labs(
    title = "Daily Order Volume",
    x = "Order Date",
    y = "Number of Orders"
  ) +
  theme_minimal()

print(daily_plot)

# 11. Visualization 4: Histogram - Delivery-time distribution
# Cancelled orders are excluded.
delivery_time_plot <- orders %>%
  filter(
    Order_Status != "Cancelled",
    !is.na(Delivery_Time_min)
  ) %>%
  ggplot(aes(x = Delivery_Time_min)) +
  geom_histogram(
    bins = 8,
    color = "black"
  ) +
  labs(
    title = "Distribution of Delivery Time",
    x = "Delivery Time (Minutes)",
    y = "Frequency"
  ) +
  theme_minimal()

print(delivery_time_plot)

# 12. Visualization 5: Scatter plot - Distance versus delivery time
distance_plot <- orders %>%
  filter(
    Order_Status != "Cancelled",
    !is.na(Distance_km),
    !is.na(Delivery_Time_min)
  ) %>%
  ggplot(
    aes(
      x = Distance_km,
      y = Delivery_Time_min
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Delivery Distance vs Delivery Time",
    x = "Distance (km)",
    y = "Delivery Time (Minutes)"
  ) +
  theme_minimal()

print(distance_plot)

# 13. Save summary tables as CSV files
write.csv(
  status_table,
  "order_status_summary.csv",
  row.names = FALSE
)

write.csv(
  vehicle_table,
  "vehicle_delivery_summary.csv",
  row.names = FALSE
)

# 14. Save all visualizations as PNG images
if (!dir.exists("plots")) {
  dir.create("plots")
}

ggsave(
  "plots/order_status_chart.png",
  plot = status_plot,
  width = 8,
  height = 5
)

ggsave(
  "plots/vehicle_delivery_chart.png",
  plot = vehicle_plot,
  width = 8,
  height = 5
)

ggsave(
  "plots/daily_order_volume.png",
  plot = daily_plot,
  width = 8,
  height = 5
)

ggsave(
  "plots/delivery_time_histogram.png",
  plot = delivery_time_plot,
  width = 8,
  height = 5
)

ggsave(
  "plots/distance_vs_delivery_time.png",
  plot = distance_plot,
  width = 8,
  height = 5
)

cat("\nAnalysis completed successfully.\n")
cat("Summary CSV files and chart images have been saved.\n")
