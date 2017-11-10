clear all
close all

% Carico i dati per scrivere il titolo
%------------------------------------------------------------------------

parametri=load('Risultati\parameters.dat');
r0    =parametri(1)*10^(-6);
eps0  =parametri(2)*10^(-6);
l_wire=parametri(3)*10^(-6);
r_wire=parametri(4)*10^(-6);
r_equi=parametri(5)*10^(-6);
phi0  =parametri(6)*10^(-12); 
n0 = parametri(7);
isize = parametri(8);

% l_wire = 10^-2;
% n0 = 20;
% r0 = 10^-6;
% r_equi = 1;

% First_line=['l_w = ',num2str(l_wire),' \mum/s, r_w = ',num2str(r_wire)'];
% Second_line=['R_0= ',num2str(r0),' \mum, \epsilon_0= ',num2str(eps0),' \mum, N_0 = ',num2str(n0)];


l_wire = l_wire/r_equi;
r0 = r0/r_equi;


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

%***********************************************
%               FIGURES
%***********************************************
x_axes = [0:l_wire/(n0*200):l_wire];
n_x_axes = length(x_axes);

%nt = 20
for it = 2:nt
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
for it = 1:nt-1

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
    
    
    if (it ~=1)
      i_NewDrops_PrecDt = i_NewDrops_data(it,:);
      x_NewDrops_PrecDt = x_NewDrops_data(it,:);
      r_NewDrops_PrecDt = r_NewDrops_data(it,:);

      i_NewDrops_PrecDt = i_NewDrops_PrecDt(i_NewDrops_PrecDt~=0);
      x_NewDrops_PrecDt = x_NewDrops_PrecDt(i_NewDrops_PrecDt~=0);
      r_NewDrops_PrecDt = r_NewDrops_PrecDt(i_NewDrops_PrecDt~=0);
      
      n_drop_AfterNucl_PrecDt = n_data(it-1) + length(i_NewDrops_PrecDt);
      
    end
    
    %Index of the droplets that will merge by absorbing the water from the
    %water bridges
    i_merge_AfterNucl = i_merge_AfterNucl_data(it+1,:);
    i_merge_AfterNucl = i_merge_AfterNucl(i_merge_AfterNucl~=0);
    
    if (it ~=1)
        i_merge_AfterNucl_PrecDt = i_merge_AfterNucl_data(it,:);
        i_merge_AfterNucl_PrecDt = i_merge_AfterNucl_PrecDt(i_merge_AfterNucl_PrecDt~=0);
    end  
    
    %Index of the new droplets resulting from merging
    i_AfterMerge = i_AfterMerge_data(it,:);
    i_AfterMerge = i_AfterMerge(i_AfterMerge~=0);
    
    %I build a vector with the indexes of the droplets that will merge in
    %dtcoll due to the absorbtion of the water from the bridges
    i_merge_BeforeNucl = [];    %In time = it
    ii = 1;
    for j = 1:length(i_merge_AfterNucl)
        
       i_Merge = i_merge_AfterNucl(j);      
       i_merge_BeforeNucl(ii) = i_merge_AfterNucl(j);     %Initialize

       i_NewSx = 0;           %Initialize (last new drop on the left of the merging ones
       k_iNewSx = 1;
       for k = 1:length(i_NewDrops)
           
           i_New = i_NewDrops(k);  %Dummy       
           if (i_New < i_Merge )  
             i_merge_BeforeNucl(ii) = i_merge_BeforeNucl(ii) - 1;
             i_NewSx = i_New;
             k_iNewSx= k;    %Index corresponding to the last i_New on the left of the merging
           end
       end      
              
       if (k_iNewSx~=length(i_NewDrops))
             if ( length(i_NewDrops)==0 | (length(i_NewDrops)~=0 & i_NewDrops(k_iNewSx+1)~=i_Merge+1) )
                 ii = ii + 1;      
                 i_merge_BeforeNucl(ii) = i_merge_BeforeNucl(ii-1)+1;
             end    
       end
       
       if ( i_Merge == n_drop & (length(i_NewDrops)==0 | i_NewDrops(1)~=1) )
           ii = ii + 1;
           i_merge_BeforeNucl(ii) = 1;
           i_merge_BeforeNucl = sort(i_merge_BeforeNucl);  
       end
       
       ii = ii + 1;

    end
    
    
    %I build a vector with the indexes of the droplets that have nucleated
    %in dtcoll
    i_Nucleated = [];   %In time = it + 1
    jj = 0;             %Initialize index to scan vector of new droplets
    if (it~= 1)
        for j = 1:length(i_NewDrops_PrecDt)
        
           i_New = i_NewDrops_PrecDt(j);      
           
           jj = jj + 1;
           i_Nucleated(jj) = i_NewDrops_PrecDt(j);  %Initialize
           if (i_merge_AfterNucl_PrecDt(end)==n_drop_AfterNucl_PrecDt & i_AfterMerge(1)~=1)
               i_Nucleated(jj) = i_Nucleated(jj)-1;
           end
           
           for k = 1:length(i_merge_AfterNucl_PrecDt)
                
                i_Merge = i_merge_AfterNucl_PrecDt(k);
                if ( i_Merge < i_New )  
                   i_Nucleated(j) = i_Nucleated(j) - 1;
                end
           end      
        end     
    end      
    
    if (length(i_Nucleated) == 0)
        i_Nucleated(1) = 0;
    end

  % Set flag that tells me if droplets will merge    
   flag_Merge = zeros(1,n_drop);
   for j = 1:n_drop
          for k = 1: length(i_merge_BeforeNucl)
               if (j == i_merge_BeforeNucl(k)) 
                    flag_Merge(j) = 1;    
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
  
   
  % Set flag that tells me if the droplet (j) is new
   flag_Nucleated = zeros(1,n_drop);
   for j = 1:n_drop
        for k = 1: length(i_Nucleated)
               if (j == i_Nucleated(k)) 
                    flag_Nucleated(j) = 1;
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
    for j=1:n_drop  
    
        L_drop(j) = x_cen(j) - r(j);   %Left border of the droplet(j)
        R_drop(j) = x_cen(j) + r(j);   %Right border of the droplet(j)
        
        
%        x_plot = x_axes( x_axes > L_drop(j) & x_axes < R_drop(j) );        
%        x_plot = [L_drop(j) x_plot R_drop(j)];    
        x_plot = [L_drop(j) R_drop(j)];  
        y_plot = time * ones(size(x_plot));

        
        figure (3)
        if (type_drop(j) == 1) 
            plot(x_plot,y_plot,'Color','r','LineWidth',2)         
        elseif (type_drop(j) == 2 )
            plot(x_plot,y_plot,'Color','g','LineWidth',2)
        elseif (type_drop(j) == 3)
            plot(x_plot,y_plot,'Color','k','LineWidth',2)
        else
            plot(x_plot,y_plot,'Color','b','LineWidth',2)       
        end    
        hold on 
    
    end
    
    xlim([x_axes(1)  x_axes(end)])
    xlabel('x/L')
    ylabel('t/T')
  
      
end
    

