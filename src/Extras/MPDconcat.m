for i = 1:55
    filename = strcat('a_mp', num2str(i), '.mat');
    new_am = load(filename);
    if i == 1
        a_mp = new_am;
    else
        a_mp = [am new_am];
    end
end
