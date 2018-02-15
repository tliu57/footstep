
%% Put all directlda m-files in matlab

%% Run this part first
% array = load('datacds');
% 
% w = array.data;
% [r,c] = size(w);
% power = nextpow2(r);
% %lth = 2^power;
% %lth = 4096;
% lth = 8192;
% 
% n = fieldnames(w);
% [r1,c1] = size(n);
% n = cell2struct(n, 's', r1);
% 
% idCW = 1:10;
% idCR = 11:20;
% idACW = 21:30;
% idACR = 31:40;
% idAW = 41:50;
% idAR = 51:60;
% idADW = 61:70;
% idADR = 71:80;
% idAAW = 81:90;
% idAAR = 91:100;
% idAAAW = 101:110;
% idAAAR = 111:120;
% 
% 
% lit = 0;
% for z = 1:length(idCR)
%     i = idCR(z);
%     [x,y]= size(w.(n(i).s));
%     for j = 1:y
%         if ((i >= 1 && i <= 9) && (j==5)) %remove bad data
%         else
%             if(lit == 0)
%                 rnum = 1;
%             else
%                 rnum = length(WD_ChildWalkTM) + 1;
%             end
%             sig = w.(n(i).s);
%             v = sig(:,j);
%             va = hilbert(v);
%            
%             
%             [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065
%             
% %              %Energy section
% %             for k = 1900:1950
% %                 WDE(:,k) = sum(TFR(:,k));%1 x 300 row vector
% %             end
% %             WD_CRE(1+lit,:) = sum(WDE);%a number
%            
% %plotting TFR section 
% %             figure;
% %             imagesc(abs(TFR));
% %             axis xy;
% %             %axis([2000, 2080, 50, 200]);
% %             %axis([1800, 2100, 50, 500]);
% %             axis([1850, 2050, 50, 400]);
% 
% 
% %trimming section                        
%             cutTFRtop = TFR(300:8:400,1850:2050);
%             cutTFRbot = TFR(75:8:175,1850:2050);
%             cutTFR = [cutTFRbot; cutTFRtop];
%              cutTFRright = cutTFR(:,150:200);
%              cutTFRleft = cutTFR(:,1:100);
%              cutTFRfinal = [cutTFRleft cutTFRright];
%     
% %             [cutrow,cutcol]=size(cutTFRfinal);
% %             figure;
% %             imagesc(abs(cutTFRfinal));
% %             axis xy;
%  %------------------             
%              colstack = cutTFRfinal(:);
%              rowstack = colstack';
%              RunVect(lit+1,:) = rowstack;
%             
%             
%             
%             WDtime = sum(TFR(200,:)); %ignore this part, from last time
%             WD_ChildWalkTM(rnum,:) = WDtime; %ignore
%             lit = lit+1;
%         end
%     end
% end
% 
% 
% lit = 0;
% for z = 1:length(idCW)
%     i = idCW(z);
%     [x,y]= size(w.(n(i).s));
%     for j = 1:y
%         if ((i >= 1 && i <= 9) && (j==5)) %remove bad data
%         else
%             if(lit == 0)
%                 rnum = 1;
%             else
%                 rnum = length(WD_ChildWalkTM) + 1;
%             end
%             sig = w.(n(i).s);
%             v = sig(:,j);
%             va = hilbert(v);
%             
%             [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065
% % %Energy section
% %             for k = 1900:1950
% %                 WDE(:,k) = sum(TFR(:,k));%1 x 300 row vector
% %             end
% %             WD_CWE(1+lit,:) = sum(WDE);%a number
%            
% %plotting TFR section                         
% %trimming section                        
%             cutTFRtop = TFR(300:8:400,1850:2050);
%             cutTFRbot = TFR(75:8:175,1850:2050);
%             cutTFR = [cutTFRbot; cutTFRtop];
%              cutTFRright = cutTFR(:,150:200);
%              cutTFRleft = cutTFR(:,1:100);
%              cutTFRfinal = [cutTFRleft cutTFRright];
%     
% %             [cutrow,cutcol]=size(cutTFRfinal);
% %             figure;
% %             imagesc(abs(cutTFRfinal));
% %             axis xy;
%  %------------------  
%             
%              colstack = cutTFRfinal(:);
%              rowstack = colstack';
%              WalkVect(lit+1,:) = rowstack;
%             
%             WDtime = sum(TFR(200,:)); %ignore
%             WD_ChildWalkTM(rnum,:) = WDtime; %ignore
%             lit = lit+1;
%         end
%     end
% end
% 
% % %Energy matrix
% % CRCWVectE = [WD_CRE; WD_CWE];
% % save CRCWVectorE.mat CRCWVectE;
% 
% %Vector matrix
% CRCWVect = [RunVect; WalkVect];
% save CRCWVector.mat CRCWVect;

%% Run this part 2nd
%call lda function here.
method = 'directlda';
array = load('CRCWVector','CRCWVect');
X = array.CRCWVect;
 third = -0.0001*ones(1,3926); %get two-dimmensions...not really neccessary
 X = [X;third];
% Y = [ones(80,1) ; 2*ones(80,1); 3*ones(1,1)];
Y = [ones(80,1) ; 2*ones(71,1);3*ones(1,1)];


[A,T]= directlda(X,Y,2,method);
display_pts(X,Y,A,fld(X,Y,2)');

Z = X*T'; %Z is the feature vector that goes into classifier is (160 x 1)
save CRCWfeat2.mat Z;












  