clear all; close all;

preproc_and_write  =  1;

Controls_listE = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6','S7', 'S8', 'S9', 'S10'}; %, 'YH'
Patients_listE = {'S11', 'S12','S13','S14','S15', 'S16', 'S17', 'S18', 'S19', 'S20'};

ListE = [Controls_listE, Patients_listE];
condE = {'ORI10','COL10','SW10','SW20','COL20','ORI20'};


screen_width  =  58.42;
screen_resolution  =  [1920 1080];%[w h];                 % screen resolution
screen_distance  =  55;                      % distance between observer and screen (in cm)
screen_angle  =  2*(180/pi)*(atan((screen_width/2) / screen_distance)) ; % total visual angle of screen
screen_ppd  =  screen_resolution(1) / screen_angle;  % pixels per degree
screen_fixposxy  =  screen_resolution .* [.5 .5] % fixation position


cd('alldata_sample/')

xx_std_1 = nan(length(ListE),length(condE),320);
xx_std_2 = nan(length(ListE),length(condE),320);

for l  =  1%:length(ListE) % loop over participants
    par  =  ListE{l} 

    cd([par, '/'])
    
    for c  =  1%:6 % loop over conditions
        cond = condE{c};
        
        
        ts1 = dlmread(sprintf('%s%s%s',par,cond,'_parsed_A2TT.txt'));  % delay1, stim and delay 2
        ts5 = dlmread(sprintf('%s%s%s',par,cond,'_parsed_A5TT.txt'));
        ts5R = dlmread(sprintf('%s%s%s',par,cond,'_parsed_A5TT.txt'));
        
        
        [lia1, loc1] = ismember(ts5R(:,2), ts1(:,2));
        [lia5, loc5] = ismember(ts5R(:,2), ts5(:,2));
        ts1  =  ts1(loc1,:);
        ts5  =  ts5(loc5,:);
        
        
        matr  =  dlmread(sprintf('%s%s%s',par,cond,'_parsed_A_B_C_D.txt'));
        
        
        matr(:,2)  =  (matr(:,2)-screen_fixposxy(1))/screen_ppd;
        matr(:,3)  =  (matr(:,3)-screen_fixposxy(1))/screen_ppd;
        
        % also transloc
        ts  =  [];
        xx  =  [];
        pu  =  [];
        len_pu  =  nan(length(ts1),1);
        for i  =  1:length(ts1) %should be 100 or resp 200
            
            
            if i == 1 & length(find(matr == ts1(i)))>0
                
                xx_add_ind = find(matr == ts1(i)):find(matr == ts5(i)-1);
                xx  =  [xx; matr(xx_add_ind,2:3)];
                
                
            elseif i>1 & length(find(matr == ts1(i)))>0 &  length(find(matr == ts5(i)-1))>0 %transloc
                
                xx_add_ind = find(matr == ts1(i)):find(matr == ts5(i)-1);
                xx  =  [xx; bsxfun(@minus,matr(xx_add_ind,2:3), (-xx(length(ts),:)+matr(xx_add_ind(1),2:3)-[0.0001 0.0001]))];
                
            elseif i>1 & length(find(matr == ts1(i)))>0 &  length(find(matr == ts5(i)-1)) == 0 ...
                    &  length(find(matr == ts5(i)-3))>0 %transloc, one weird case
                
                xx_add_ind = find(matr == ts1(i)):find(matr == ts5(i)-3);
                xx  =  [xx; bsxfun(@minus,matr(xx_add_ind,2:3), (-xx(length(ts),:)+matr(xx_add_ind(1),2:3)-[0.0001 0.0001]))];
                
            elseif i>1 & length(find(matr == ts1(i)))>0 &  length(find(matr == ts5(i)-1)) == 0 ...
                    &  length(find(matr == ts5(i)-3)) == 0 &  length(find(matr == ts5(i)-40))>0 %transloc, one weird case
                
                xx_add_ind = find(matr == ts1(i)):find(matr == ts5(i)-40);
                xx  =  [xx; bsxfun(@minus,matr(xx_add_ind,2:3), (-xx(length(ts),:)+matr(xx_add_ind(1),2:3)-[0.0001 0.0001]))];
                
            elseif i>1 & length(find(matr == ts1(i)))>0 &  length(find(matr == ts5(i)-1)) == 0 ...
                    &  length(find(matr == ts5(i)-3)) == 0 &  length(find(matr == ts5(i)-40)) == 0  &...
                    length(find(matr == ts5(i)-70))>0%transloc, one weird case
                
                xx_add_ind = find(matr == ts1(i)):find(matr == ts5(i)-70);
                xx  =  [xx; bsxfun(@minus,matr(xx_add_ind,2:3), (-xx(length(ts),:)+matr(xx_add_ind(1),2:3)-[0.0001 0.0001]))];
                
                
            elseif i>1 & length(find(matr == ts1(i))) == 0
                
                xx_add_ind =  min(find(matr(:,1)-ts1(i)>0)):find(matr == ts5(i)-1);
                xx  =  [xx; bsxfun(@minus,matr(xx_add_ind,2:3), (-xx(length(ts),:)+matr(xx_add_ind(1),2:3)-[0.0001 0.0001]))];
                
                
            elseif i == 1 & length(find(matr == ts1(i))) == 0
                
                xx_add_ind = min(find(matr(:,1)-ts1(i)>0)):find(matr == ts5(i)-1);
                xx  =  [xx; matr(xx_add_ind,2:3)];
                
                
            end
            
            ts  =  [ts xx_add_ind];
            
            pu  =  [pu; matr(xx_add_ind,4)];
            len_pu(i) =  length(matr(xx_add_ind,4));
            
            xx_std_1(l,c,i)  =  std(diff(matr(xx_add_ind,2)));
            xx_std_2(l,c,i)  =  std(diff(matr(xx_add_ind,3)));
            
        end
        
        % determine the microsaccades with the Engbert and Kliegl 2003
        % algorithm
        vel = vecvel(xx, 1000,2); %5 sized window, 
        sac = [];
        [sac radius] = microsaccwonan(xx, vel, 6, 6); 
        
        
        sac_all{l,c}  =  sac;
        radius_all{l,c}  =  radius;
        pu_all{l,c}  =  pu;
        len_pu_all{l,c} = len_pu;
        
        
        %pre-process xx and write
        if preproc_and_write
            %estimate the noise level with the median absolute deviation of the
            %acceleration (see manuscript)
            sigmax = nanmean([sqrt(nanmedian(diff(diff(xx(:,1))).^2)) sqrt(nanmedian(diff(diff(xx(:,2))).^2))]);
            sigmax_x = sqrt(nanmedian(diff(diff(xx(:,1))).^2));
            sigmax_y = sqrt(nanmedian(diff(diff(xx(:,2))).^2));
            
            %rescale the noise in the y dimension by the one in the x dimension to
            %match the isotropy assumption in our generative model
            xx2 = [];
            xx2(:,1) = xx(:,1);
            xx2(:,2) = sigmax_x/sigmax_y*xx(:,2);
            
            
            %write to file x1.txt
            fid_int_table = fopen([ListE{l},'_',condE{c}, '_BMD.txt'], 'w');
            fprintf(fid_int_table,'%i\n', length(xx2));
            for j = 1:length(xx2)
                if ~isnan(xx2(j,1)) && ~isnan(xx2(j,2))
                    fprintf(fid_int_table,'%d\t%d\t\n',xx2(j,1), xx2(j,2));
                end
            end
            fclose(fid_int_table);
        end
        
    end
    cd ..
end
