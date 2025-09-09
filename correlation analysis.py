import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the Excel file (update the file path accordingly)
df = pd.read_excel(r"C:\Users\abhir\Downloads\nithin_sales_report new.xlsx", engine='openpyxl')

# Rename the inventory days column for convenience (if it has spaces)
df.rename(columns={'inventory days': 'Inventory_Days'}, inplace=True)

# Preview the first few rows
print(df.head())

# Drop rows with missing values in Inventory_Days or Profit columns
df_clean = df.dropna(subset=['Inventory_Days', 'Profit'])

# Calculate the Pearson correlation coefficient
corr_value = df_clean['Inventory_Days'].corr(df_clean['Profit'])
print(f'Correlation between Inventory Days and Profit: {corr_value:.4f}')

# Visualize the correlation with scatter plot and regression line
sns.lmplot(x='Inventory_Days', y='Profit', data=df_clean, height=6, aspect=1.5)
plt.title('Inventory Days vs Profit Correlation')
plt.xlabel('Inventory Days')
plt.ylabel('Profit')
plt.show()
