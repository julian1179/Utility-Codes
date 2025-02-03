% This code takes a CSV file of citations exported from Google Scholar and
% formats them, exporting the result as a TXT file. Currently, there are
% two format options:
%   HTML:   The citations will be in list format. Each citation will have a
%           selectable author name in bold, and the title in italics.
%   Text:   Each citation will appear in a new line. More formatting can be
%           added as needed.
% In all cases, the most recent year appears at the top of the list, with
% the oldest publications at the end.
% Here's an example of an output publication in 'Text' format:
%   J. Gamboa, T. Hamidfar, X. Shen, S.M. Shahriar, "Elimination of optical
%   phase sensitivity in a shift, scale, and rotation invariant hybrid
%   opto-electronic correlator via off-axis operation," Optics Express 31
%   (4), 5990-6002 (2023).
% And here's the same publicatoin in 'HTML' format:
%   <li><strong>J. Gamboa</strong>, T. Hamidfar, X. Shen, S.M. Shahriar,
%   "<em>Elimination of optical phase sensitivity in a shift, scale, and
%   rotation invariant hybrid opto-electronic correlator via off-axis
%   operation</em>," Optics Express 31 (4), 5990-6002 (2023).</li>

clear *
clc


% The input CSV should be exported from Google Scholar
file_dir = 'C:\Users\Username\Documents\Publication list\';
in_file_name = 'citations.csv'; 
out_file_name = 'Formatted_pub_list.txt';

format = 'HTML'; % options: 'Text', 'HTML'
author_to_embolden = 'A. Einstein';

tab = readtable([file_dir,in_file_name]);
%%

publications = strings(height(tab),1);
for i=1:height(tab)
    % ---------------------------- Author List ----------------------------
    authors = tab.Authors{i};
    authList = split(authors,';');
    authors_formatted = strings(size(authList,1)-1,1);
    for ii=1:size(authors_formatted,1)
        name = split(authList{ii},' ');

        empty = cellfun('isempty',name);
        name(all(empty,2)) = []; % Delete empty cells

        name = cellfun(@(n) erase(n,','),name,'UniformOutput',false); % Remove commas

        if size(name,1)==2 % Author has first and last name
            authors_formatted(ii) = sprintf('%s. %s',name{2}(1), name{1});
        else % Author has first, middle, and last name
            authors_formatted(ii) = sprintf('%s.%s. %s',name{2}(1), name{3}(1), name{1});
        end
        
        if strcmpi(authors_formatted(ii), author_to_embolden) % If this is the author of interest
            if strcmpi(format, 'HTML')
                authors_formatted(ii) = sprintf('<strong>%s</strong>',authors_formatted(ii));
            elseif strcmpi(format, 'text')
                % Add special formatting here.
            end
        end

    end
    all_authors = strjoin(authors_formatted,', ');

    % ---------------------------- Formatting -----------------------------
    if strcmpi(format, 'HTML')
        title = sprintf('<em>%s</em>',tab.Title{i});
    elseif strcmpi(format, 'text')
        title = tab.Title{i};
    end
    journal =  tab.Publication{i};

    entry = sprintf('%s, "%s," %s', all_authors, title, journal);

    if ~isnan(tab.Volume(i))
        entry = sprintf('%s %d', entry, tab.Volume(i));
    end
    if ~isnan(tab.Number(i))
        entry = sprintf('%s (%d)', entry, tab.Number(i));
    end
    if ~isempty(tab.Pages{i})
        entry = sprintf('%s, %s', entry, tab.Pages{i});
    end
    if ~isempty(tab.Year(i))
        entry = sprintf('%s (%d).', entry, tab.Year(i));
    end

    if strcmpi(format, 'HTML')
        entry = sprintf('<li>%s</li>',entry);
    elseif strcmpi(format, 'text')
        % Add special formatting here.
    end
    
    publications(i) = entry;
end

% ---------------------------- Sorting by year ----------------------------
% Google Scholar places the most recent publications at the bottom, so we
% have to invert the order
order = (length(publications) : -1 : 1)';
publications = publications(order);


%% Saving to file
[fid,msg] = fopen([file_dir,out_file_name],'wt');
assert(fid>=3,msg);

for i= 1:length(publications)
    fprintf(fid,'%s\n',publications(i));
end

fclose(fid);









