clear

%% Load Data
d = load('datacds');

n = fieldnames(d.data);
[r,c] = size(n);
n = cell2struct(n, 's', r);

%% Set Parameters
c = 1; % 0 - Data, 1 - Spectogram, 2 - Ambiguity, 3 - RID, 4 - WD

fs = 1.6128e+03;

if(exist('Images','file') == 0)
    mkdir('Images');
end

%% Generate and Save Data
for i = 1:r
    trial = n(i).s;
    %     if(exist(fullfile('Images', trial),'file') == 0)
    %         mkdir(fullfile('Images', trial));
    %     end
    [x,y] = size(d.data.(n(i).s));
    sig = d.data.(n(i).s);
    time = d.time.(n(i).s);
    for j = 1:y
        sensor = ['Sensor', num2str(j)];
        sen = hilbert((sig(:,j)));
        lth = 2^(nextpow2(length(sen)));
        if (c == 0)
            trans = 'Signal';
            tstr = 'Signal';
            figure,
            plot(time(:,j), sen);
            title([trial,' ', tstr, ' for Sensor ', num2str(j)]);
            axis([min(time(:,j)), max(time(:,j)), -Inf, Inf]);
            xlabel('Time (s)');
            ylabel('Collected Data');
        elseif (c == 1)
            trans = 'Spectrogram';
            tstr = trans;
            [S,F,T,P] = spectrogram(sen,64,60,400,fs);
            filename = strcat(trans, num2str(i), '-', num2str(j), 'lda', '.mat');
            %Spectrogram.(trial).(sensor).S = S;
            %Spectrogram.(trial).(sensor).F = F;
            %Spectrogram.(trial).(sensor).T = T;
            %Spectrogram.(trial).(sensor).P = P;
            %                 figure,
%             mtime = min(time(:,1));
%             Mtime = max(time(:,1));
%             len = length(T);
%             ptime = mtime:(Mtime-mtime)/length(T):Mtime;
%             ptime = ptime(1:len);
            cutTFRbot1 = S(50:2:58,:);
            cutTFRbot2 = S(100:2:108,:);
            cutTFRbot3 = S(150:2:158,:);
            cutTFRbot4 = S(200:2:208,:);
            cutTFRbot5 = S(250:2:258,:);
            cutTFR = [cutTFRbot1; cutTFRbot2; cutTFRbot3; cutTFRbot4; cutTFRbot5];
            S = cutTFR(:,425:575);
            %                 surf(ptime,F,10*log10(abs(P)),'edgecolor','none');
            %                 axis tight;
            %                 view(0,90);
            %                 title([trial,' ', tstr, ' for Sensor ', num2str(j)]);
            %                 xlabel('Time (s)');
            %                 ylabel('Frequency (Hz)');
        elseif (c == 2)
            trans = 'Ambiguity';
            tstr = 'Ambiguity Function';
            senlen = 1:length(sen);
            [AF] = ambifunb(sen, senlen ,300);
            filename = strcat(trans, num2str(i), '-', num2str(j), '.mat');
            %Ambiguity.(trial).(sensor).AF = AF;
            %Ambiguity.(trial).(sensor).DLR = DLR;
            %Ambiguity.(trial).(sensor).DV = DV;
            %             figure,
            %             axis tight;bg
            %             contour(abs(AF));
            %             axis xy;
            %             title([trial, ' ', tstr, ' for Sensor ', num2str(j)]);
            %             xlabel('Time Lag (s)');
            %             ylabel('Frequency Lag (Hz)');
        elseif (c == 3)
            trans = 'RID';
            tstr = 'Reduced Interfecence Distribution';
            [TFR, T, F] = tfrridh(sen, 1:length(sen), 2048);
            filename = strcat(trans, num2str(i), '-', num2str(j), 'LFA', '.mat');
            cutTFRtop = TFR(300:8:400,1850:2050);
            cutTFRbot = TFR(75:8:175,1850:2050);
            cutTFR = [cutTFRbot; cutTFRtop];
            cutTFRright = cutTFR(:,150:200);
            cutTFRleft = cutTFR(:,1:100);
            TFR = [cutTFRleft cutTFRright];
            %             mtime = min(time(:,1));
            %             Mtime = max(time(:,1));
            %             len = length(T);
            %             ptime = mtime:(Mtime-mtime)/length(T):Mtime;
            %             ptime = ptime(1:len);
            %             F = F.*(fs/2);
            %             figure
            %             contour(ptime, F, abs(TFR));
            %             axis xy;
            %             axis([-Inf,Inf,-Inf,Inf]);
            %             title([trial,' ', tstr, ' for Sensor ', num2str(j)]);
            %             xlabel('Time (s)');
            %             ylabel('Frequency(Hz)');
        elseif (c == 4)
            trans = 'WD';
            tstr = 'Wigner Distribution';
            [TFR, T, F] = tfrpwv(sen,1:lth, 2048);
            filename = strcat(trans, num2str(i), '-', num2str(j), 'LFA', '.mat');
            cutTFRtop = TFR(300:8:400,1850:2050);
            cutTFRbot = TFR(75:8:175,1850:2050);
            cutTFR = [cutTFRbot; cutTFRtop];
            cutTFRright = cutTFR(:,150:200);
            cutTFRleft = cutTFR(:,1:100);
            TFR = [cutTFRleft cutTFRright];
            
            %             mtime = min(time(:,1));
            %             Mtime = max(time(:,1));
            %             len = length(T);
            %             ptime = mtime:(Mtime-mtime)/len:Mtime;
            %             ptime = ptime(1:len);
            %             F = F.*(fs/2);
            %             WD.(trial).(sensor).TFR = TFR;
            %             figure
            %             contour(ptime, F, abs(TFR));
            %             axis xy;
            %             axis([-Inf,Inf,-Inf,Inf]);
            %             title([trial,' ', tstr, ' for Sensor ', num2str(j)]);
            %             xlabel('Time (s)');
            %             ylabel('Frequency(Hz)');
        end
        if(exist(fullfile('Images', trans),'file') == 0)
            mkdir(fullfile('Images', trans));
        end
        
        if (c == 1)
            save(fullfile('Images', trans, filename), 'S');
        elseif (c == 2)
            save(fullfile('Images', trans, filename), 'AF');
        elseif (c == 3)
            save(fullfile('Images', trans, filename), 'TFR');
        elseif (c == 4)
            save(fullfile('Images', trans, filename), 'TFR');
        end
        
    end
    
    %     if(exist(fullfile('Images', trial, trans),'file') == 0)
    %         mkdir(fullfile('Images', trial, trans));
    %     end
    %     h=get(0,'children');
    %     h=sort(h);
    %
    %     for z = 1:length(h)
    %         print (h(z), '-dpdf', fullfile('Images', trial, trans,...
    %             ['Sensor ', num2str(z)]));
    %     end
    %     close
end

% load gong;
% player = audioplayer(y,Fs);
% play(player);