clear

%% Load Data
d = load('datacds');

n = fieldnames(d.data);
[r,c] = size(n);
n = cell2struct(n, 's', r);

%% Set Parameters
c = 4; % 0 - Data, 1 - Spectogram, 2 - Ambiguity, 3 - RID, 4 - WD

fs = 1.6128e+03;

if(exist('Images','file') == 0)
    mkdir('Images');
end

%% Generate and Save Data
for i = 10:20
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
            Spectrogram.(trial).(sensor).S = S;
            %Spectrogram.(trial).(sensor).F = F;
            %Spectrogram.(trial).(sensor).T = T;
            %Spectrogram.(trial).(sensor).P = P;
            %                 figure,
            %                 mtime = min(time(:,1));
            %                 Mtime = max(time(:,1));
            %                 len = length(T);
            %                 ptime = mtime:(Mtime-mtime)/length(T):Mtime;
            %                 ptime = ptime(1:len);
            %                 surf(ptime,F,10*log10(abs(P)),'edgecolor','none');
            %                 axis tight;
            %                 view(0,90);
            %                 title([trial,' ', tstr, ' for Sensor ', num2str(j)]);
            %                 xlabel('Time (s)');
            %                 ylabel('Frequency (Hz)');
        elseif (c == 2)
            trans = 'Ambiguity';
            tstr = 'Ambiguity Function';
            [AF, DLR, DV] = ambifunb(sen);
            Ambiguity.(trial).(sensor).AF = AF;
            %Ambiguity.(trial).(sensor).DLR = DLR;
            %Ambiguity.(trial).(sensor).DV = DV;
            figure,
            axis tight;
            contour(abs(AF));
            axis xy;
            title([trial, ' ', tstr, ' for Sensor ', num2str(j)]);
            xlabel('Time Lag (s)');
            ylabel('Frequency Lag (Hz)');
        elseif (c == 3)
            trans = 'RID';
            tstr = 'Reduced Interfecence Distribution';
            [TFR, T, F] = tfrridh(sen, 1:length(sen), 300);
%             mtime = min(time(:,1));
%             Mtime = max(time(:,1));
%             len = length(T);
%             ptime = mtime:(Mtime-mtime)/length(T):Mtime;
%             ptime = ptime(1:len);
%             F = F.*(fs/2);
             RID.(trial).(sensor).TFR = TFR;
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
            [TFR, T, F] = tfrwv(sen,1:lth, 300);
%             mtime = min(time(:,1));
%             Mtime = max(time(:,1));
%             len = length(T);
%             ptime = mtime:(Mtime-mtime)/len:Mtime;
%             ptime = ptime(1:len);
%             F = F.*(fs/2);
             WD.(trial).(sensor).TFR = TFR;
%             figure
%             contour(ptime, F, abs(TFR));
%             axis xy;
%             axis([-Inf,Inf,-Inf,Inf]);
%             title([trial,' ', tstr, ' for Sensor ', num2str(j)]);
%             xlabel('Time (s)');
%             ylabel('Frequency(Hz)');
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
%     close all
end

if(exist(fullfile('Images', trans),'file') == 0)
         mkdir(fullfile('Images', trans));
     end

if (c == 1)
    file = [trans, '.mat'];
    save(fullfile('Images', trans, file), 'Spectrogram', '-v7.3');
elseif (c == 2)
    file = [trans, '.mat'];
    save(fullfile('Images', trans, file), 'Ambiguity');
elseif (c == 3)
    file = [trans, '.mat'];
    save(fullfile('Images', trans, file), 'RID');
elseif (c == 4)
    file = [trans, '.mat'];
    save(fullfile('Images', trans, file), 'WD', '-v7.3');
end