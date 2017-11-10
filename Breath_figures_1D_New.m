clear all
%close all

% Carico i dati per scrivere il titolo
%------------------------------------------------------------------------
i_fig = 141;

parametri=load('Risultati\parameters.dat');
r0_dimens     =parametri(1)*10^(-6);
eps0  =parametri(2)*10^(-6);
l_wire_dimens = parametri(3)*10^(-6);
r_wire_dimens = parametri(4)*10^(-6);
r_equi=parametri(5)*10^(-6);
phi0  =parametri(6)*10^(-12); 
n0    = parametri(7);
isize = parametri(8);
lambda0 = parametri(9);
t0      = parametri(10);


% l_wire = 10^-2;
% n0 = 20;
% r0 = 10^-6;
% r_equi = 1;

% First_line=['l_w = ',num2str(l_wire),' \mum/s, r_w = ',num2str(r_wire)'];
% Second_line=['R_0= ',num2str(r0),' \mum, \epsilon_0= ',num2str(eps0),' \mum, N_0 = ',num2str(n0)];


l_wire = l_wire_dimens/r_equi;
r0     = r0_dimens/r_equi;

delta_time_min = 5*10^(-3) ; %MIN delta_t tra istanti per plottare gocce


% Carico i dati per i plottaggi
%--------------------------------------------------------------------------
dati = load('Risultati\x.dat','r');
x_data=dati(:,2:end);            %Position of the centers of the droplets

dati = load('Risultati\r.dat','r');
r_data=dati(:,2:end);            %Radii of the droplets

dati = load('Risultati\n_drop.dat','r');
n_data=dati(:,2);            %Radii of the droplets

dati = load('Risultati\icoll_j.dat','r');
icoll_data=dati(:,2);            %Radii of the droplets

dati = load('Risultati\t.dat','r');
t_data=dati(:,2);            %Radii of the droplets
nt = length(t_data);

it_min = 2;   %Di solito it_min = 1
time_min = t_data(it_min);   %First instant when I start to plot

dati = load('Risultati\i_NewDrops.dat','r');
i_NewDrops_data=dati(:,2:end);            %Index of new nucleated droplets

dati = load('Risultati\x_NewDrops.dat','r');
x_NewDrops_data=dati(:,2:end);           %Position of the centre of new droplets

dati = load('Risultati\r_NewDrops.dat','r');
r_NewDrops_data=dati(:,2:end);                %Radii of new droplets


dati = load('Risultati\i_merge_AfterNucl.dat','r');
i_merge_AfterNucl_data = dati(:,2:end);            %Index of droplets merging after nucleation and absorbtion of water from bridges

dati = load('Risultati\i_AfterMerge.dat','r');
i_AfterMerge_data = dati(:,2:end);             %Index of droplets resulting from merged droplets (after nucleation and bridges)


% Se voglio fare PLOT DIMENSIONALI
x_data = x_data * r_equi;
r_data = r_data * r_equi;
x_NewDrops_data = x_NewDrops_data * r_equi;
r_NewDrops_data = r_NewDrops_data * r_equi;
l_wire = l_wire * r_equi;
r0     = r0 * r_equi;
t_data      = t_data   * t0;
time_min    = time_min * t0;
delta_time_min = delta_time_min * t0; 



%NORMALIZZO (tolgo se sono gia' normalizzate)
%t_data = t_data * phi0 / r0^2.;   %Normalizzo
%time_min = time_min * phi0 / r0^2.;
%***********************************************
% Find MIN and MAX RADIUS for each time step
for it = 1:nt
    rMax(it) = max(r_data(it,:));
    dum = r_data(it,:);
    rMin(it) = min(dum(dum~=0));
end


%***********************************************
%               FIGURES
%***********************************************
x_axes = [0:l_wire/(n0*200):l_wire];
n_x_axes = length(x_axes);

%nt = 20
for it = (it_min+1):nt
    dt(it) = t_data(it) - t_data(it-1);
end    

% %Scansion of time instants
% for it = 1:nt-1
% 
%     x_cen  = x_data(it,:);
%     r      = r_data(it,:);
%     n_drop = n_data(it);
%     icoll  = icoll_data(it+1);
%     time   = t_data(it + 1);
%     
%     %Scansion of the droplets    
%     for j=1:n_drop  
%             
%         for i = 1:n_x_axes
%          
%             if ( x_axes(i) < x_cen(j)-r(j) | x_axes(i) > x_cen(j)+r(j) )  
%                 y(i) = 0;    
%             else   
%                 y(i) = sqrt(r(j)^2 - (x_axes(i)-x_cen(j))^2);
%             end
%         end
%         
%         figure (1)
%         if (j == icoll | j == icoll+1) 
%             plot(x_axes,y,'r')
%         elseif  (j == 1 & icoll==n_drop ) 
%             plot(x_axes,y,'r')
%         else
%             plot(x_axes,y,'b')
%         end    
%         xlim([x_axes(1)  x_axes(end)])
%         ylim([0  x_axes(end)/10])
%         hold on              
%         
%     end
%     hold off
%     
%     F(it) = getframe(gcf);
%     
% end
% 
% %title({First_line;Second_line})
% xlabel('x')
% %xlim([0 x_axes(end)])
% 
% %PLAY MOVIE
% figure(2)
% xlim([x_axes(1)  x_axes(end)])
% ylim([0  x_axes(end)/10])
% movie(2,F,1,0.3)

    

%DIAGRAM WITH DROPLETS : SEGMENTS
%--------------------------------------------------------------------------
%Scansion of time instants
for it = it_min:nt-1

    x_cen  = x_data(it,:);
    r      = r_data(it,:);
    n_drop = n_data(it);
    icoll  = icoll_data(it+1);
    time   = t_data(it);
    
    %New droplets that will appear at the next time instant
    i_NewDrops = i_NewDrops_data(it+1,:);
    x_NewDrops = x_NewDrops_data(it+1,:);
    r_NewDrops = r_NewDrops_data(it+1,:);

    i_NewDrops = i_NewDrops(i_NewDrops~=0);
    x_NewDrops = x_NewDrops(i_NewDrops~=0);
    r_NewDrops = r_NewDrops(i_NewDrops~=0);
    
      % Set flag that tells me if the droplet (j) (without having considered merging droplets yet) is new
     nn = n_drop + length(i_NewDrops); 
     flag_NewDrops = zeros(1,nn);
     for j = 1:nn
          for k = 1: length(i_NewDrops)
               if (j == i_NewDrops(k)) 
                    flag_NewDrops(j) = 1;    
               end    
          end      
     end
    
    
    if (it > it_min)    %In general it it_min =1 
      i_NewDrops_PrecDt = i_NewDrops_data(it,:);
      x_NewDrops_PrecDt = x_NewDrops_data(it,:);
      r_NewDrops_PrecDt = r_NewDrops_data(it,:);

      i_NewDrops_PrecDt = i_NewDrops_PrecDt(i_NewDrops_PrecDt~=0);
      x_NewDrops_PrecDt = x_NewDrops_PrecDt(i_NewDrops_PrecDt~=0);
      r_NewDrops_PrecDt = r_NewDrops_PrecDt(i_NewDrops_PrecDt~=0);
      
      n_drop_AfterNucl_PrecDt = n_data(it-1) + length(i_NewDrops_PrecDt);
      
    end
    
    %Index of the droplets that will merge by absorbing the water from the
    %water bridges (in the vector of the OLD + NUCLEATED droplets, between time it and it+1)
    i_merge_AfterNucl = i_merge_AfterNucl_data(it+1,:);
    i_merge_AfterNucl = i_merge_AfterNucl(i_merge_AfterNucl~=0);
    
    if (it > it_min)
        i_merge_AfterNucl_PrecDt = i_merge_AfterNucl_data(it,:);
        i_merge_AfterNucl_PrecDt = i_merge_AfterNucl_PrecDt(i_merge_AfterNucl_PrecDt~=0);
    end  
    
    %Index of the new droplets resulting from merging
    i_AfterMerge = i_AfterMerge_data(it,:);
    i_AfterMerge = i_AfterMerge(i_AfterMerge~=0);
   
    
    
   % Set flag that tells me if droplets will merge  
   nn = n_drop + length(i_NewDrops);
   flag_merge_AfterNucl = zeros(1,nn);
   for j = 1:nn
          for k = 1: length(i_merge_AfterNucl)
               if (j == i_merge_AfterNucl(k)) 
                    flag_merge_AfterNucl(j) = 1;    
               end    
           end      
   end
   
   if (it > it_min)
      nn_prec = n_drop_prec + length(i_NewDrops_PrecDt);
      flag_merge_AfterNucl_PrecDt = zeros(1,nn_prec);
      for j = 1:nn_prec
          for k = 1: length(i_merge_AfterNucl_PrecDt)
               if (j == i_merge_AfterNucl_PrecDt(k)) 
                    flag_merge_AfterNucl_PrecDt(j) = 1;    
               end    
          end      
      end
   end
   
   
   % Set flag that tells me if droplets comes from merging     
   flag_HaveMerged = zeros(1,n_drop);
   for j = 1:n_drop
          for k = 1: length(i_AfterMerge)
               if (j == i_AfterMerge(k)) 
                    flag_HaveMerged(j) = 1;    
               end    
           end      
   end

 %---------------------------------------------------------------------------    
  
    %I build a vector with the indexes of the droplets that will merge in
    %dtcoll due to the absorbtion of the water from the bridges (index in
    %the vecto of the OLD droplets)
    i_merge_BeforeNucl = [];    %In time = it
    i_merge_with_nucleated_BeforeNucl = [];
    ii = 1;
    kk = 1;
    nn = n_drop + length(i_NewDrops);
     
    for j = 1:length(i_merge_AfterNucl)
        
       i_Merge = i_merge_AfterNucl(j);      

       n_new_L = length(find( i_NewDrops < i_Merge ));   %Number of NEW nucleated droplets on the left of i_merge_AfterNucl(j)
                                                         % i_NewDrops = vector                                     
       i_merge_BeforeNucl(ii) =  i_Merge - n_new_L;                                          
                    
       
        %I build a vector with the indexes of the droplets that
        %WILL merge with a nucleated droplet
        if (length(i_NewDrops(i_NewDrops==i_Merge|i_NewDrops==i_Merge+1))~=0)    
            if ( kk==1 | i_merge_with_nucleated_BeforeNucl(kk-1)~=i_merge_BeforeNucl(ii) )
                  i_merge_with_nucleated_BeforeNucl(kk) = i_merge_BeforeNucl(ii);
                  kk = kk + 1;
            end
        end
       
       %-------------------------------------------------------------------
       % NB:
       % - In i_merge_AfterNucl  :when (i) and (i+1) will merge, I write only
       %        (i). In the same way, when (i) is merging with a new nucleated
       %        droplet, I write only (i)
       % - In i_merge_BeforeNucl :when (i) and (i+1) (at time step it) will
       %          merge, I write both (i) and (i+1). When (i) is merging
       %          with a new nucleated droplets, I write only (i)
       %-------------------------------------------------------------------
       if (i_Merge ~= nn)  
           
          if ( length(i_NewDrops) == 0 |...
               (n_new_L ~= length(i_NewDrops) & flag_NewDrops(i_Merge+1)~=1  & flag_NewDrops(i_Merge)~=1) | ...
               (n_new_L == length(i_NewDrops) & flag_NewDrops(i_Merge)~=1) )
        
                i_merge_BeforeNucl(ii + 1) = i_merge_BeforeNucl(ii) + 1;
                ii = ii + 1;         
             
          end
       
       elseif (length(i_NewDrops)==0 | i_NewDrops(1)~=1 )
           ii = ii + 1;
           i_merge_BeforeNucl(ii) = 1;
           i_merge_BeforeNucl = sort(i_merge_BeforeNucl);  
           
           i_merge_with_nucleated_BeforeNucl = sort(i_merge_with_nucleated_BeforeNucl);
       end
      
       
       ii = ii + 1;
    end
    
    %I eliminate duplicated indexes (due to 3 by 3 merging)
    for i = 1:length(i_merge_BeforeNucl)-1
        if (i_merge_BeforeNucl(i) == i_merge_BeforeNucl(i+1))
            i_merge_BeforeNucl(i:end) = [i_merge_BeforeNucl(i+1:end) 0];
        end
    end
    i_merge_BeforeNucl = i_merge_BeforeNucl(i_merge_BeforeNucl~=0);

 
    
   % Set flag that tells me if droplets (at the instant it, before considering nucleation) will merge  
   flag_Merge = zeros(1,n_drop);
   for j = 1:n_drop
          for k = 1: length(i_merge_BeforeNucl)
               if (j == i_merge_BeforeNucl(k)) 
                    flag_Merge(j) = 1;    
               end    
           end      
   end

    % Set flag that tells me if droplets (at the instant it, before
    % considering nucleation) will merge with a NEW nucleated droplets
    % (between time (it) and (it+1) )
   flag_MergeWithNucleated = zeros(1,n_drop);
   for j = 1:n_drop
          for k = 1: length(i_merge_with_nucleated_BeforeNucl)
               if (j == i_merge_with_nucleated_BeforeNucl(k)) 
                    flag_MergeWithNucleated(j) = 1;    
               end    
           end      
   end
   
%---------------------------------------------------------------------------    
    %I build a vector with the indexes of the droplets that have nucleated
    %in dtcoll
    i_Nucleated = [];   %At time = it + 1
    i_Nucleated_And_HaveMerged = [];   %Droplets that result from both nucleation and merging
    if (it > it_min)
        
      ii = 1;               %Initialize index to scan vector of new droplets
      kk = 1;
      nn      = n_drop + length(i_NewDrops);
      nn_prec = n_drop_prec + length(i_NewDrops_PrecDt);  % = n_drop_AfterNucl_PrecDt !**CHECK
        for j = 1:length(i_NewDrops_PrecDt)
        
               i_New = i_NewDrops_PrecDt(j);      
    
               n_merge_L = length(find( i_merge_AfterNucl_PrecDt < i_New ));   %Number of merging droplets (after nucleation) on the left of i_New
                                                                               % i_merge_AfterNucl = vector = vector   
               %Periodic BC
               if (flag_merge_AfterNucl_PrecDt(n_drop_AfterNucl_PrecDt)==1 &...
                   flag_HaveMerged(n_drop) == 1)               
                        n_merge_L = n_merge_L + 1;
               end
                                                                               
                                                                               
               if (i_New == nn & flag_merge_AfterNucl_PrecDt(nn) == 1 & ...
                     flag_merge_AfterNucl_PrecDt(1) == 1 & flag_HaveMerged(1) == 1)
                     %Don't add any nucleation droplet at the end
                        
               elseif  ( (i_New > 1  & flag_merge_AfterNucl_PrecDt(i_New-1)~=1) |... 
                         (i_New == 1 & (flag_merge_AfterNucl_PrecDt(nn_prec)~=1 | flag_merge_AfterNucl_PrecDt(1)~=1))| ...
                         (i_New == 1 & flag_merge_AfterNucl_PrecDt(nn_prec)==1 & flag_merge_AfterNucl_PrecDt(1)==1 & i_NewDrops_PrecDt(end)==nn_prec & flag_HaveMerged(1)==1) )
               
                    i_Nucleated(ii) =  i_New - n_merge_L;  
                    ii = ii + 1;
                    
               elseif( (i_New > 1  & flag_merge_AfterNucl_PrecDt(i_New-1)==1) |...   
                        (i_New == 1 & flag_merge_AfterNucl_PrecDt(nn_prec)==1 & flag_merge_AfterNucl_PrecDt(1)==1))
                       %To avoid to have doubles
                       if (kk ==1| i_Nucleated_And_HaveMerged(kk-1) ~= i_New - n_merge_L)    
                            i_Nucleated_And_HaveMerged(kk) = i_New - n_merge_L;     %Vector of the indexes of the droplets resulting from nucleation + merging
                            kk = kk + 1;
                        end    
               end    
                                                                    
        end     
    end      
    
    if (length(i_Nucleated) == 0)
        i_Nucleated(1) = 0;
    end
  
   
  % Set flag that tells me if the droplet (j) is new
   flag_Nucleated = zeros(1,n_drop);
   for j = 1:n_drop
        for k = 1: length(i_Nucleated)
               if (j == i_Nucleated(k)) 
                    flag_Nucleated(j) = 1;
               end 
        end     
   end
   
   
   % Set flag that tells me if the droplet (j) is new
   flag_Nucleated_And_HaveMerged = zeros(1,n_drop);
   for j = 1:n_drop
        for k = 1: length(i_Nucleated_And_HaveMerged)
               if (j == i_Nucleated_And_HaveMerged(k)) 
                    flag_Nucleated_And_HaveMerged(j) = 1;
               end 
        end     
   end
   
   
   %I build a vector that tells me the type of the droplet:
   %   0 =  Normal type
   %   1 =  Next collision event
   %   2 =  New droplet
   %   3 =  Droplets merging because of the addition of water 
   type_drop = zeros(1,n_drop); 

   for j = 1: n_drop
       if (icoll == j | icoll == j-1 | (j == 1 & icoll == n_drop) ) 
                    type_drop(j) = 1;                
       else
           if (flag_Nucleated(j) == 1) 
                    type_drop(j) = 2;
           end
           
           if (flag_Merge(j) == 1)
                    type_drop(j) = 3;
           end       
       end
   end   
   
   
   
    %Scansion and plot of the droplets   
  %if (time>time_min  )
   if (time>=time_min)
       
    for j=1:n_drop  
    
        L_drop(j) = x_cen(j) - r(j);   %Left border of the droplet(j)
        R_drop(j) = x_cen(j) + r(j);   %Right border of the droplet(j)
        
        
%        x_plot = x_axes( x_axes > L_drop(j) & x_axes < R_drop(j) );        
%        x_plot = [L_drop(j) x_plot R_drop(j)];    
        x_plot = [L_drop(j) R_drop(j)];  
        y_plot = time * ones(size(x_plot));

      %**if (time>time_min  )
        figure (i_fig)
%%           hold on 
%           %WITHOUT COLORS
%            %* if (type_drop(j)~=0) 
%                 %if (type_drop(j)~=0 && type_drop(j)~=1)          
%                 if (dt(it) >= delta_time_min)
%                   semilogy(x_plot,y_plot,'Color','k','LineWidth',1.2)      
%                   %LinePlotReducer(x_plot,y_plot,'Color','k','LineWidth',1.2)
%             end 
            
          %WITH COLOURS  
        if (type_drop(j) == 1) 
                semilogy(x_plot,y_plot,'Color','r','LineWidth',1)         
        elseif (type_drop(j) == 2 )
                semilogy(x_plot,y_plot,'Color','g','LineWidth',1)
        elseif (type_drop(j) == 3)
                semilogy(x_plot,y_plot,'Color','k','LineWidth',1)
        else
               if (icoll == 0)
                  semilogy(x_plot,y_plot,'Color','m','LineWidth',1)  
               else 
                  semilogy(x_plot,y_plot,'Color','b','LineWidth',1)    
               end 
        end    
        hold on
        
      end
      
    end
    
    xlim([x_axes(1)  x_axes(end)])
    xlabel('x/R_0')
    ylabel('t/T')
  
    
    %Linee oblique che congiungono bordi SX e DX man mano che il tempo
    %evolve
    if (it>=it_min+1 & time>time_min )
    %------------------------------------------------------------------    
       i = 1;
       jT = 1;    %Index to scan TOP line (current time) 
       jB = 1;    %Index to scan BOTTOM line (previous time)
       Lpoint_prec = zeros(1,n_drop-length(i_Nucleated));
       Rpoint_prec = zeros(1,n_drop-length(i_Nucleated));
       Lpoint = zeros(1,n_drop-length(i_Nucleated));
       Rpoint = zeros(1,n_drop-length(i_Nucleated));

       ii = 1;
       while (flag_Nucleated(ii)==1 & flag_Nucleated_And_HaveMerged(ii)~=1)
                        jT = jT + 1;
                        ii = ii + 1;
       end
       
       if (flag_Merge_prec(1)==1 & flag_Merge_prec(n_drop_prec)==1) 
           if (flag_HaveMerged(jT)~=1)
              jB = 2;   
           end
       end
       
%      while  ( i <= n_drop-length(i_Nucleated) & jB<=n_drop_prec)
       while  ( jT <= n_drop & jB <= n_drop_prec)
                
           
              if ( (x_cen(jT) == x_cen_prec(jB) | (flag_Nucleated_And_HaveMerged(jT)==1 & flag_Nucleated(jT)~=1)) & jB~=icoll_prec ) 
                  
                    Lpoint_prec(i) = L_drop_prec(jB);
                    Rpoint_prec(i) = R_drop_prec(jB);
                    Lpoint(i) = L_drop(jT);
                    Rpoint(i) = R_drop(jT);                  
                    jB = jB + 1;
                    jT = jT + 1;
                    i = i + 1;
                    
              else              
                    if (flag_Nucleated(jT)==1) %& flag_HaveMerged(jT) ~=1)
                        jT = jT + 1;

                    else
                        
                        if((x_cen(jT)<x_cen_prec(jB) & flag_Nucleated(jT)~=1 & jB~=icoll_prec)|...
                           (flag_HaveMerged(jT)==1 & flag_Nucleated(jT)==1 & jB~=icoll_prec) )
                       
                           Lpoint_prec(i) = L_drop_prec(jB);
                           Rpoint_prec(i) = R_drop_prec(jB);
                           Lpoint(i) = L_drop(jT);
                           Rpoint(i) = R_drop(jT);                  
                           jB = jB + 1;
                           jT = jT + 1;
                           i = i + 1;
                        
                        %if (x_cen(jT) < x_cen_prec(jB+1) & ...
                        %    flag_HaveMerged(jT) == 1 )
                        
                        else
                            
                            if ( (jB <= n_drop_prec-2 &  flag_Merge_prec(jB+1)==1 & flag_Merge_prec(jB+2)~=1 ) | ...
                                 (jB <= n_drop_prec-3 &  flag_Merge_prec(jB+1)==1 & flag_Merge_prec(jB+2)==1 & flag_Merge_prec(jB+3)==1)|...
                                 (jB <= n_drop_prec-2 & flag_Merge_prec(jB+1)==1 & flag_Merge_prec(jB+2)==1 & x_cen_prec(jB+2)>=x_cen(jT+1))|...
                                 (jB > n_drop_prec-2 &  flag_Merge_prec(1)~=1 ))    
                                Lpoint_prec(i) = L_drop_prec(jB);
                                Rpoint_prec(i) = R_drop_prec(jB+1);
                                Lpoint(i) = L_drop(jT);
                                Rpoint(i) = R_drop(jT);                  
                                jB = jB + 2;
                                jT = jT + 1;
                                i = i + 1;
                                
                            else  
                                Lpoint_prec(i) = L_drop_prec(jB);
                                
                                if (jB < n_drop_prec-1)
                                    Rpoint_prec(i) = R_drop_prec(jB+2);
                                elseif (jB == n_drop_prec - 1)    
                                    Rpoint_prec(i) = R_drop_prec(jB) + l_wire + R_drop_prec(1); 
                                elseif (jB == n_drop_prec) 
                                    Rpoint_prec(i) = R_drop_prec(jB) + l_wire + R_drop_prec(2); 
                                end
                                Lpoint(i) = L_drop(jT);
                                Rpoint(i) = R_drop(jT);                  
                                jB = jB + 3;
                                jT = jT + 1;
                                i = i + 1;
                            end
                        end                       
                    end       
             
              end

               x_Left_line = [Lpoint_prec(i-1) Lpoint(i-1)];
               y_Left_line = [time_prec time];
               x_Right_line = [Rpoint_prec(i-1) Rpoint(i-1)];
               y_Right_line = [time_prec time];
          
               semilogy(x_Left_line,y_Left_line,'k','LineWidth',1)
               hold on
               semilogy(x_Right_line,y_Right_line,'k','LineWidth',1)
               hold on   
               
%                LinePlotReducer(x_Left_line,y_Left_line,'k','LineWidth',1);
%                hold on
%                LinePlotReducer(x_Right_line,y_Right_line,'k','LineWidth',1);
%                hold on   
       end

       %Plot linee oblique
%        for i = 1 : n_drop-length(i_Nucleated)
%            
%            x_Left_line = [Lpoint_prec(i) Lpoint(i)];
%            y_Left_line = [time_prec time];
%            x_Right_line = [Rpoint_prec(i) Rpoint(i)];
%            y_Right_line = [time_prec time];
%           
%            plot(x_Left_line,y_Left_line,'k')
%            hold on
%            plot(x_Right_line,y_Right_line,'k')
%            hold on   
%        
%        end
%        
 %------------------------------------------------------------------                   
    end

  %Salvo valori per l'istante successivo  
  n_drop_prec = n_drop;
  time_prec = time;
  type_drop_prec = type_drop;   
  icoll_prec = icoll;      
  flag_Merge_prec = flag_Merge;
  L_drop_prec = L_drop;
  R_drop_prec = R_drop;
  x_cen_prec = x_cen; 
  
end
    

