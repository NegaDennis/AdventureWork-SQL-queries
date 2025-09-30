# AdventureWork-SQL-queries
Perform SQL Queries on AdventureWork dataset, simulating practical SQL skills in business context

For queries results ---> /QueriesResults/anyfile.rpt
For queries themselves ---> Queries.sql

The short project makes use of the classic sample dataset, AdventureWork, provided by Microsoft ([link](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks)). For this particular instance, the *AdventureWorks2022.bak* was used. The goal of the project is to demonstrate SQL skills needed for answering business questions with data.

As I am not bipolar, I could not assume both roles, the business person requesting data/report and the data analyst making the queries. Luckily, advanced chatbots exist and I asked chatGPT to pretend to be the former :)

Here are the 10 questions that I was asked:

1️⃣ **Sales & Revenue**
 
 *“Can you give me total internet sales revenue by month for the last 12 months?”*
 
2️⃣ **Top Products**
 
 *“Which 10 products generated the highest sales revenue last quarter?”*

(Assumption: "Last quarter" means the period from 1/4/2014-30/6/2014)

3️⃣ **Customer Segmentation**
 
 *“List our top 20 individual customers by lifetime sales (internet orders only).”*

4️⃣ **Territory Performance**
 
 *“Compare sales revenue by sales territory and month for this year.”*

5️⃣ **Product Category Trends**
 
 *“What are the sales trends by product category over the last two years?”*

   (Assumption: "Last two year" means 2013 and 2014 despite 2014 have only progressed for 6 months)

6️⃣ **Employee Performance (Sales Staff)**
 
 *“Show me each salesperson’s total sales and the number of orders they handled in the past 6 months.”*

7️⃣ **Repeat Customers**
 
 *“How many customers placed more than one order in the last year?”*

8️⃣ **Shipping & Fulfillment**
 
 *“Give me the average days between order date and ship date by territory.”*

9️⃣ **Profitability**
 
 *“Estimate gross profit by product for last year.”*

🔟 **Inventory**
 
 *“Which products are out of stock or have less than 10 units available?”*

