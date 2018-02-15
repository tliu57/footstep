
%% Put all directlda m-files in matlab

% % Run this part first
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
% for z = 1:length(idAAR)
%     i = idAAR(z);
%     [x,y]= size(w.(n(i).s));
%     for j = 1:y
%         if ((z ==3 || z == 7 || z == 8 || z == 9 || z == 10)) %remove lockstep bad data
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
% %  %Energy section
% %             for k = 1900:1950
% %                 WDE(:,k) = sum(TFR(:,k));%1 x 300 row vector
% %             end
% %             WD_ARE(1+lit,:) = sum(WDE);%a number
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
%             cutTFRfinal = TFR(100:5:400,1950:2000);
% %     
% %             [cutrow,cutcol]=size(cutTFRfinal);
% %             figure;
% %             imagesc(abs(cutTFRfinal));
% %             axis xy;
%  %------------------              
%              colstack = cutTFRfinal(:);
%              rowstack = colstack';
%              Mult1(lit+1,:) = rowstack;
%             
%             WDtime = sum(TFR(200,:)); %ignore this part, from last time
%             WD_ChildWalkTM(rnum,:) = WDtime; %ignore
%             lit = lit+1;
%         end
%     end
% end
% % 
% % 
% % lit = 0;
% % for z = 1:length(idAAW)
% %     i = idAAW(z);
% %     [x,y]= size(w.(n(i).s));
% %     for j = 1:y
% %         if (((z ==2) && (j<=3)) || ((z ==5) && (j==3)) || z == 6 || z == 8 || ((z ==10) && (j==1)) ) %remove lockstep bad data
% %         else
% %             if(lit == 0)
% %                 rnum = 1;
% %             else
% %                 rnum = length(WD_ChildWalkTM) + 1;
% %             end
% %             sig = w.(n(i).s);
% %             v = sig(:,j);
% %             va = hilbert(v);
% %             
% %             [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065
% % %  %Energy section
% % %             for k = 1900:1950
% % %                 WDE(:,k) = sum(TFR(:,k));%1 x 300 row vector
% % %             end
% % %             WD_ARE(1+lit,:) = sum(WDE);%a number
% %            
% % %plotting TFR section  
% % %             figure;
% % %             imagesc(abs(TFR));
% % %             axis xy;
% % %             %axis([2000, 2080, 50, 200]);
% % %             %axis([1800, 2100, 50, 500]);
% % %             axis([1850, 2050, 50, 400]);
% % 
% % 
% % %trimming section                        
% %             cutTFRfinal = TFR(100:5:200,1850:2050);
% %     
% % %             [cutrow,cutcol]=size(cutTFRfinal);
% % %             figure;
% % %             imagesc(abs(cutTFRfinal));
% % %             axis xy;
% %  %------------------   
% %             
% %              colstack = cutTFRfinal(:);
% %              rowstack = colstack';
% %              Mult2(lit+1,:) = rowstack;
% %             
% %             WDtime = sum(TFR(200,:)); %ignore
% %             WD_ChildWalkTM(rnum,:) = WDtime; %ignore
% %             lit = lit+1;
% %         end
% %     end
% % end
% % 
% lit = 0;
% for z = 1:length(idAAAR)
%     i = idAAAR(z);
%     [x,y]= size(w.(n(i).s));
%     for j = 1:y
%         if (((z ==1) && (j==2)) || ((z ==2) && (j==4)) || ((z ==4) && (j==4)) || ((z ==7) && (j<=3)) || ((z ==10) && (j >=2 && j<=4)) ) %remove bad data
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
%             
% %  %Energy section
% %             for k = 1900:1950
% %                 WDE(:,k) = sum(TFR(:,k));%1 x 300 row vector
% %             end
% %             WD_ARE(1+lit,:) = sum(WDE);%a number
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
%             cutTFRfinal = TFR(100:5:400,1950:2000);
%     
% %             [cutrow,cutcol]=size(cutTFRfinal);
% %             figure;
% %             imagesc(abs(cutTFRfinal));
% %             axis xy;
%  %------------------  
%             
%              colstack = cutTFRfinal(:);
%              rowstack = colstack';
%              Mult3(lit+1,:) = rowstack;
%             
%             WDtime = sum(TFR(200,:)); %ignore
%             WD_ChildWalkTM(rnum,:) = WDtime; %ignore
%             lit = lit+1;
%         end
%     end
% end
% % 
% % lit = 0;
% % for z = 1:length(idAAAW)
% %     i = idAAAW(z);
% %     [x,y]= size(w.(n(i).s));
% %     for j = 1:y
% %         if (((z ==2) && (j==1))) || ((z ==4) && ((j==1)||(j==4))) || ((z ==7) && ((j==1)||(j==2))) || ((z ==8) && ((j==1)||(j==4))) || ((z ==9) && ((j==1)||(j==2)) ) %remove bad data
% %         else
% %             if(lit == 0)
% %                 rnum = 1;
% %             else
% %                 rnum = length(WD_ChildWalkTM) + 1;
% %             end
% %             sig = w.(n(i).s);
% %             v = sig(:,j);
% %             va = hilbert(v);
% %             
% %             [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065
% %             
% % %  %Energy section
% % %             for k = 1900:1950
% % %                 WDE(:,k) = sum(TFR(:,k));%1 x 300 row vector
% % %             end
% % %             WD_ARE(1+lit,:) = sum(WDE);%a number
% %            
% % %plotting TFR section  
% % %             figure;
% % %             imagesc(abs(TFR));
% % %             axis xy;
% % %             %axis([2000, 2080, 50, 200]);
% % %             %axis([1800, 2100, 50, 500]);
% % %             axis([1850, 2050, 50, 400]);
% % 
% % 
% % %trimming section                        
% %             cutTFRfinal = TFR(100:5:200,1850:2050);
% %     
% % %             [cutrow,cutcol]=size(cutTFRfinal);
% % %             figure;
% % %             imagesc(abs(cutTFRfinal));
% % %             axis xy;
% %  %------------------  
% %             
% %              colstack = cutTFRfinal(:);
% %              rowstack = colstack';
% %              Mult4(lit+1,:) = rowstack;
% %             
% %             WDtime = sum(TFR(200,:)); %ignore
% %             WD_ChildWalkTM(rnum,:) = WDtime; %ignore
% %             lit = lit+1;
% %         end
% %     end
% % end
% % 
% %Multiple Vector matrix
% MultVect = [Mult1; Mult3];
% %MultE = [WD_Mult1E; WD_Mult2E; WD_Mult3E; WD_Mult4E];
% %save MultVector.mat MultVect;
% 
% %Single Vector matrix
% d = load('ARAWVector','ARAWVect');
% e = load('CRCWVector','CRCWVect');
% % f = load('ARAWVectorE','ARAWVectE');
% % g = load('CRCWVectorE','CRCWVectE');
% 
% A = d.ARAWVect;
% B = e.CRCWVect;
% % C = f.ARAWVectE;
% % D = g.CRCWVectE;
% 
% SingleVect = [A; B];
% % SingleVectE = [C; D];
% 
% MultSingleVect2 = [MultVect; SingleVect];
% save MultSingleVect2.mat MultSingleVect2;


%% Run this part 2nd
%call lda function here.
method = 'directlda';
array = load('MultSingleVect2','MultSingleVect2');
X = array.MultSingleVect2;
third = -0.0001*ones(1,3111); %get two-dimmensions...not really neccessary
%fourth = 1.5*ones(1,3111);
%fifth = 1.2*ones(1,3926);
X = [X; third];
%Y = [ones(109,1) ; 2*ones(311,1); 3*ones(1,1); 4*ones(1,1); 5*ones(1,1)];

Y = [ones(51,1) ; 2*ones(320,1); 3*ones(1,1) ];



[A,T]= directlda(X,Y,2,method);
display_pts(X,Y,A,fld(X,Y,2)');

Z = X*T'; %Z is the feature vector that goes into classifier is (160 x 1)
%MultSingleE = [MultE; SingleVectE; 0];
%MultSingleE = [MultE; SingleVectE; 0; 0; 0];

%allmultfeat = [Z MultSingleE];
allmultfeat = [Z];
save MultSingleFeat3.mat allmultfeat;








  