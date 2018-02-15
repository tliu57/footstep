d = load('datacds');

fs = 1.6128e+03;
n = fieldnames(d.data);
[r,c] = size(n);
n = cell2struct(n, 's', r);

[r1, c1] = size(d.data.(n(1).s));

for i = 1:r
    trial = n(i).s;
    [x,y] = size(d.data.(n(i).s));
    p = zeros(round(x), y);
    sig = d.data.(n(i).s);
    senc = zeros(x,1);
    timeo = d.time.(n(i).s);
    for j = 1:y
        sen = sig(:,j);
        [X, Y] = butter(10, 300/(fs/2));
        p(:,j) = (filter(X, Y, sen));
    end
    
    timev = timeo;
    
    sens = mod(i,10);
    if(sens == 0)
        sens = 10;
    end
    
    if (i >= 1 && i <= 10)
        t = ['CW', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 11 && i <= 20)
        t = ['CR', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 21 && i <= 30)
        t = ['ACW', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 31 && i <= 40)
        t = ['ACR', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 41 && i <= 50)
        t = ['AWT', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 51 && i <= 60)
        t = ['ART', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 61 && i <= 70)
        t = ['ADW', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 71 && i <= 80)
        t = ['ADR', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 81 && i <= 90)
        t = ['AAW', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 91 && i <= 100)
        t = ['AAR', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 101 && i <= 110)
        t = ['AAAW', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 111 && i <= 120)
        t = ['AAAR', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 121 && i <= 130)
        t = ['AWB', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 131 && i <= 140)
        t = ['ARB', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 141 && i <= 150)
        t = ['AWL', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 151 && i <= 160)
        t = ['ARL', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 161 && i <= 170)
        t = ['AWK', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
        
    elseif (i >= 171 && i <= 180)
        t = ['ARK', num2str(sens)];
        data.(t) = p;
        time.(t) = timev;
    end
end

save('datacdsl.mat','data', 'time')