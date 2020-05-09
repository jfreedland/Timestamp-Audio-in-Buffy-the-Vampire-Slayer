function finalSubtitle = estimateTimepoints(formattedSubtitle)

    % Fill in timespots
    for a = 1:size(formattedSubtitle,1) % Each unique character
        if isempty(formattedSubtitle{a,1}) % Two-line
            if (isequal(formattedSubtitle{a,3},formattedSubtitle{a-1,3})) % Same character
                formattedSubtitle{a,1} = formattedSubtitle{a-1,1};
                formattedSubtitle{a,2} = formattedSubtitle{a-1,2};
            else % Dialogue between characters
                sz1 = length(formattedSubtitle{a-1,4});
                sz2 = length(formattedSubtitle{a,4});

                r = (formattedSubtitle{a-1,2} - formattedSubtitle{a-1,1});
                formattedSubtitle{a,2} = formattedSubtitle{a-1,2};
                formattedSubtitle{a-1,2} = round(formattedSubtitle{a-1,1} + r * (sz1/(sz1+sz2)),2);
                formattedSubtitle{a,1} = formattedSubtitle{a-1,2};
            end
        end
    end
    finalSubtitle = formattedSubtitle;
end