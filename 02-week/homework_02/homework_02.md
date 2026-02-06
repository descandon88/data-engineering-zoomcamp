# Homework 02 - Questions and Answers

## Submitting the solutions

- Form for submitting: https://courses.datatalks.club/de-zoomcamp-2026/homework/hw2
- Check the link above to see the due date

---

### Question 1: Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size?

- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

**Answer: 128.3 MiB**

---

### Question 2: What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?

- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv`
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

**Answer: green_tripdata_2020-04.csv**

---

### Question 3: How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?

- 13,537.299
- 24,648,499
- 18,324,219
- 29,430,127

![Q3 Result](img/q3.png)

**Answer: 24,648,499**

---

### Question 4: How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?

- 5,327,301
- 936,199
- 1,734,051
- 1,342,034

![Q4 Result](img/q4.png)

**Answer: 1,734,051**

---

### Question 5: How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?

- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

![Q5 Result](img/q5.png)

**Answer: 1,925,152**

---

### Question 6: How would you configure the timezone to New York in a Schedule trigger?

- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  

**Answer: Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration**

---

## Implementation Details

The `homework_02.yaml` script is the Kestra workflow used to execute and answer questions 3-5. This workflow orchestrates the ETL pipeline to extract, transform, and load NYC Taxi data into PostgreSQL, allowing us to count the rows for different taxi types and years.


## Learning in Public

We encourage everyone to share what they learned. This is called "learning in public".

Read more about the benefits [here](https://alexeyondata.substack.com/p/benefits-of-learning-in-public-and).
