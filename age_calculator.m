function [age] = age_calculator(date_of_birth,date_of_participation)
    dob_month = date_of_birth(1);
    dob_day = date_of_birth(2);
    dob_year = date_of_birth(3);
    dop_month = date_of_participation(1);
    dop_day = date_of_participation(2);
    dop_year = date_of_participation(3);
    years = dop_year - dob_year;
    days_per_month = [31,28,31,30,31,30,31,31,30,31,30,31];
    if dop_month == 1
        dop_month_days = 0;
    else
        dop_month_days = sum(days_per_month(1:dop_month-1));
    end
    if dob_month == 1
        dob_month_days = 0;
    else
        dob_month_days = sum(days_per_month(1:dob_month-1));
    end
    days = (dop_month_days + dop_day) - (dob_month_days + dob_day);
    age = years + (days/365);
end