function [] = print_endTime(duration_s)
% This function takes a 'duration' in seconds, checks the current date and
% time, and then prints out how many days, hours, minutes, and seconds
% until the duration is met.
% This code was written to be used in simulations where you can estimate
% its approximate duration. You can then print out roughly how long it'll
% take to run, and ask the user if they wish to proceed.

    time = datetime;
    
    hr = hour(time);
    min = minute(time);

    duration_day = floor(duration_s / (60*60*24));
    duration_s = duration_s - duration_day*(60*60*24);
    
    duration_hr = floor(duration_s / (60*60));
    duration_s = duration_s - duration_hr*(60*60);
    
    duration_min = floor(duration_s / (60));

    duration_text = 'This will take approximately:    ';
    if duration_day > 0;    duration_text = sprintf([duration_text,' %d days '],duration_day);       end
    if duration_hr > 0;     duration_text = sprintf([duration_text,' %d hours '],duration_hr);      end
    if duration_min > 0;    duration_text = sprintf([duration_text,' %d minutes'],duration_min);    end
    disp(duration_text);

    end_min = min+duration_min;
    if end_min >=60
        end_min = end_min-60;
        duration_hr = duration_hr+1;
    end
    end_hr = hr + duration_hr;
    if end_hr >=24
        end_hr = end_hr-24;
        duration_day = duration_day+1;
    end

    if end_hr < 12
        ampm = 'am';
    elseif end_hr == 12
        ampm = 'pm';
    else
        ampm = 'pm';
        end_hr = end_hr-12;
    end
    fprintf(['This will finish at about:       %d:%02d ',ampm], end_hr,end_min);
    if duration_day >0
        if duration_day >1
            fprintf(' in %d days',duration_day);
        else
            fprintf(' tomorrow');
        end
    end
    fprintf('\n');
    
end



