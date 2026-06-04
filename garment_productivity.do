
* Import data
import delimited "C:\Users\lenovo\Downloads\DataSets\productivity+prediction+of+garment+employees (1)\garments_worker_productivity.csv", ///
    varnames(1) stringcols(1 2 3 4) clear


* Data Cleaning and preparation
replace department = trim(department)
replace department = "sewing" if department == "sweing"

* Rename quarter to week
rename quarter week
replace week = "Week1" if week == "Quarter1"
replace week = "Week2" if week == "Quarter2"
replace week = "Week3" if week == "Quarter3"
replace week = "Week4" if week == "Quarter4"
replace week = "Week5" if week == "Quarter5"


* Dropping variable wip
drop wip

* Encode categoricals
encode department, gen(dept)
encode day,        gen(day_num)
encode week,       gen(week_num)

* Date and month
gen date2 = date(date, "MDY")
format date2 %td
gen month = month(date2)
label variable month "Month"
label define month_lbl 1 "Jan" 2 "Feb" 3 "Mar"
label values month month_lbl

* Target achieved dummy
gen target_achieved = (actual_productivity >= targeted_productivity)
label variable target_achieved "Target Achieved (1=Yes, 0=No)"

* Converting incentive from BDT to USD (2015 exchange rate: 1 USD = 110 BDT)
gen incentive_usd = incentive / 110


* target achieved by department
tabstat target_achieved, by(department) stats(sum)

* Bar chart: target achievement by department
graph bar (count) if target_achieved == 1, over(department) ///
    title("Target Achievement by Department") ///
    ytitle("Number of Times Target Achieved") ///
    blabel(bar, format(%9.0f)) ///
    bar(1, color(navy)) bar(2, color(teal))

* Department, week, and day dummies
tab dept,     gen(dept_)
tab week_num, gen(week_)
tab day_num,  gen(day_)


* descriptive statistics
describe
summarize
misstable summarize

tab dept
tab day_num
tab week_num
tab team


* Productivity by month
tabstat actual_productivity, by(month) stats(sum mean)

* Correlation analysis
correlate actual_productivity targeted_productivity smv over_time ///
    incentive idle_time idle_men no_of_style_change no_of_workers

pwcorr actual_productivity targeted_productivity smv over_time ///
    incentive idle_time idle_men no_of_style_change no_of_workers, star(0.05)

tab target_achieved


* Distributions
histogram actual_productivity, normal kdensity ///
    title("Distribution of Actual Productivity")

histogram smv, normal kdensity ///
    title("Distribution of SMV")


* Box plots
graph box actual_productivity, over(department) ///
    title("Actual Productivity by Department") ///
    ytitle("Actual Productivity")


* Bar: total productivity by month
graph bar (sum) actual_productivity, over(month) ///
    title("Total Actual Productivity by Month", size(medium)) ///
    ytitle("Total Actual Productivity", size(small)) ///
    blabel(bar, format(%9.1f) size(vsmall)) ///
    bar(1, color(navy)) ///
    ylabel(, grid)

* Bar: target achievement counts
graph bar (count), ///
    over(target_achieved, relabel(1 "Not Achieved" 2 "Achieved")) ///
    title("Productivity Target Achievement", size(medium)) ///
    ytitle("Number of Observations", size(small)) ///
    blabel(bar, format(%9.0f) size(small)) ///
    bar(1, color(cranberry)) bar(2, color(teal)) ///
    note("Total Observations = 1,197", size(vsmall)) ///
    ylabel(0(100)1000, grid)


* Correlation Analysis
correlate targeted_productivity smv incentive_usd idle_time idle_men no_of_style_change no_of_workers


*Model 1*
reg actual_productivity targeted_productivity smv incentive_usd idle_time idle_men no_of_style_change no_of_workers


* Check VIF for multicollinearity
vif


* Model 2
reg actual_productivity targeted_productivity smv incentive_usd idle_time idle_men no_of_style_change no_of_workers dept_2 week_2 week_3 week_4 week_5 day_2 day_3 day_4 day_5 day_6

vif

* Model 3
reg actual_productivity targeted_productivity smv incentive_usd idle_men no_of_style_change dept_2 week_5


* Model 4
gen target_dept = targeted_productivity * dept_2


reg actual_productivity targeted_productivity smv incentive_usd idle_men no_of_style_change dept_2 week_5 target_dept

*Checking for heteroskedasticity by adding robust error
reg actual_productivity targeted_productivity smv incentive_usd idle_men no_of_style_change dept_2 week_5 target_dept, robust


* Final model diagnostics
vif

* Residual plots
rvfplot, yline(0) title("Residuals vs Fitted Plot")


predict resid, resid
qnorm resid, title("Normal Q–Q Plot of Regression Residual")




