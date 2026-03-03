🥊 UFC Historical Analysis — Data Analysis Project (CodersLab Bootcamp)

End-to-end data analysis project completed as part of the CodersLab Data Science / Data Analysis course.

Goal: prepare analytical insights about the history of the UFC (Ultimate Fighting Championship) based on historical fight data and answer key business questions provided by UFC management.

1) Problem Framing
Business context

MMA is one of the fastest-growing combat sports globally. UFC management requested a data-driven summary of the organization’s history to publish on ufc.com for fans worldwide.

Key analytical questions

The analysis focuses on answering:

How many fighters have fought in the UFC at least once?

What was the age of the oldest fighter at fight time?

How many events have been organized and where most frequently?

How many fights were held by weight class?

How do fights end?

Distribution of KO/TKO, submission, decision, other

What percentage ended in KO/TKO?

Who are the most successful fighters?

TOP 10 fighters by number of wins (alphabetical tie-break)

Which fighters are the most effective strikers?

Highest number of recorded knockouts

Hypothesis examples

Higher strike volume → higher significant strike output

KO/TKO represents a substantial share of finishes

Fight activity varies across weight classes

A small group of fighters dominates total wins

2) Data Collection
Sources

Historical UFC fight data covering the period:

1993 — March 2021

Dataset consists of three relational tables:

fights

fighters

locations

Data was provided in bootcamp materials.

3) Data Understanding

The dataset contains detailed fight-level and fighter-level statistics, including:

Fighter attributes

fighter_id

fighter_name

weight_pounds

date_of_birth

height (feet + inches)

Performance metrics

kd (knockdowns)

sig_str (significant strike accuracy)

total_str (total strike accuracy)

td, sub_att, rev, ctrl

head, leg, distance, clinch, ground

Fight metadata

win_by

date

fight_type (weight class)

winner (corner color)

location (city, country)

Special note: prefixes r_ and b_ indicate red and blue corner fighters.

4) Data Cleaning & Processing (Excel)
Key cleaning steps

Verified and corrected data types

Handled missing values (DOB, age calculations)

Converted height to centimeters

Converted weight to kilograms where needed

Calculated fighter age at fight time

Standardized categorical values (winner, win_by)

Built helper columns for fighter-level aggregations

Removed or validated extreme values

Tools used

IF, ISBLANK, DATEDIF

XLOOKUP, COUNTIF(S), COUNTA

UNIQUE, FILTER

Pivot Tables

Custom helper columns

5) Exploratory Data Analysis (EDA)
Task 1 — UFC participation scale

Calculated:

total unique fighters

total number of events

city with most events

oldest fighter age at fight time

Insight: UFC has hosted thousands of fights across a global set of cities with participation from a large and diverse fighter pool.

Task 2 — Fights by weight class

Used Pivot Tables to compute fight counts per weight division.

Insight: Fight distribution is uneven across divisions, with certain weight classes dominating total fight volume.

Task 3 — Fight outcome analysis

Analyzed win_by distribution.

Computed:

counts by finish type

percentage of KO/TKO finishes

Insight: KO/TKO represents a significant share of fight endings, confirming the importance of striking effectiveness in MMA outcomes.

Task 4 — Top 10 fighters by wins

Built fighter-level aggregation:

counted wins per fighter

sorted descending

applied alphabetical tie-break

Insight: UFC win distribution is highly concentrated among a relatively small group of fighters.

Task 5 — Best knockout artists

Identified fighters with the highest number of KO victories.

Insight: Elite strikers distinguish themselves through consistent finishing ability rather than only fight volume.

Additional analysis — Striking relationship

Performed correlation and regression between:

total strikes

significant strikes

Results:

Pearson r ≈ 0.80

R² ≈ 0.64

Insight: Fighters who throw more strikes tend to land more significant strikes, which is expected since significant strikes are a subset of total strikes.

6) Pivot Tables Used

Pivot tables were used to:

summarize fights by weight class

compute finish type distributions

aggregate fighter wins

validate event counts by location

Typical setup

Rows: fight_type / fighter_name / city

Values: count of fights or wins

Show values as: % of total (where relevant)

7) Key Insights (Summary)

UFC fight activity has grown substantially since the organization’s founding.

Fight distribution varies notably by weight class.

KO/TKO finishes represent a meaningful portion of outcomes.

Fighter success is highly concentrated among top performers.

Striking volume strongly correlates with significant strike output.

Geographic analysis shows certain cities act as major UFC hubs.

8) Deliverables

Fighter participation summary

Event distribution by city

Fight counts by weight class

Finish type percentage breakdown

TOP 10 fighters by wins

Top knockout artists

Scatter plot + regression (total vs significant strikes)

9) How to Reproduce

Load the three UFC tables into Excel.

Validate data types and handle missing DOB values.

Compute fighter age at fight time.

Build helper columns for winner name resolution.

Create Pivot Tables for weight class and finish analysis.

Aggregate wins per fighter and rank TOP 10.

Build scatter plot (total vs significant strikes).

Compute Pearson correlation using:

=CORREL(total_str_range, sig_str_range)

Add linear trendline and R².

10) Notes / Possible Improvements

Future analytical extensions:

striking efficiency analysis (sig_str / total_str)

fighter career trajectory modeling

weight-class normalization

advanced regression or classification models

time-series analysis of UFC growth

Python/SQL pipeline for scalability

Course: CodersLab Bootcamp — Data Analysis / Data Science
Author: Uroš Vukmanović