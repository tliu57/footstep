file = 'RID.mat';

for i = 1:80
    for j = 1:8
        filename = strcat('RID', num2str(i), '-', num2str(j), '.mat');
        mat = load(filename);
        mat = mat.TFR;
        mat = mat(1:100,1976:2076);
        stackmat = abs(mat(:));
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
        filename = strcat('RID', num2str(i), '-', num2str(j), '.mat');
        mat = load(filename);
        mat = mat.TFR;
        mat = mat(1:100,1976:2076);
        stackmat = abs(mat(:));
        colstack = stackmat.';
        TFR = [TFR; colstack];
    end
end

for i = 121:140
    for j = 1:8
        filename = strcat('RID', num2str(i), '-', num2str(j), '.mat');
        mat = load(filename);
        mat = mat.TFR;
        mat = mat(1:100,1976:2076);
        stackmat = abs(mat(:));
        colstack = stackmat.';
        TFR = [TFR ; colstack];
    end
end

for i = 141:180
    for j = 1:4
        filename = strcat('RID', num2str(i), '-', num2str(j), '.mat');
        mat = load(filename);
        mat = mat.TFR;
        mat = mat(1:100,1976:2076);
        stackmat = abs(mat(:));
        colstack = stackmat.';
        TFR = [TFR ; colstack];
    end
end

save(file, 'TFR');