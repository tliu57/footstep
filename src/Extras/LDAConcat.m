file = 'WD.mat';
filetype = 'WD';

for i = 1:80
    for j = 1:8
        filename = strcat(filetype, num2str(i), '-', num2str(j), 'LFA', '.mat');
        mat = load(filename);
        mat = mat.TFR;
        stackmat = mat(:);
        colstack = stackmat.';
        if(i == 1 && j == 1)
            TFR = colstack;
        else
            TFR = [TFR ; colstack];
        end
    end
end

for i = 81:120
    for j = 1:4
            filename = strcat(filetype, num2str(i), '-', num2str(j),'LFA', '.mat');
            mat = load(filename);
            mat = mat.TFR;
            stackmat = mat(:);
            colstack = stackmat.';
            TFR = [TFR; colstack];
        end
end

for i = 121:140
    for j = 1:8
        filename = strcat(filetype, num2str(i), '-', num2str(j),'LFA', '.mat');
        mat = load(filename);
        mat = mat.TFR;
        stackmat = mat(:);
        colstack = stackmat.';
        TFR = [TFR ; colstack];
    end
end

for i = 141:180
    for j = 1:4
        filename = strcat(filetype, num2str(i), '-', num2str(j),'LFA', '.mat');
        mat = load(filename);
        mat = mat.TFR;
        stackmat = mat(:);
        colstack = stackmat.';
        TFR = [TFR ; colstack];
    end
end

save(file, 'TFR');