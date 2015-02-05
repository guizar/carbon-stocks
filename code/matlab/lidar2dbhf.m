function [CList,CSS,BB] = lidar2dbhf(shotnumber,LGE,LGW,pft)

% INPUT
% shotnumber = waveform number
% LGE = ground elevation file
% LGW = waveform file
% pft = percent plant functional type
%       pft6,8 = early, late successional conifers (e.g. pine)/(e.g. hemlock / spruce)
%       pft9,10,11 = early, mid, late successional hardwoods (e.g.birch/ash)/(e.g. maple, oak)/(e.g. beech)
% OUTPUT
% CList = columns=Basal area bins of 10cm / rows=pfts 6,8,9,10,11
% CSS = ED2 initialization file. see line 91
% BB = Basal areas of each pulse

CSS = zeros(1,10);

for i = 1:size(shotnumber,1)
        i/size(shotnumber,1)
        i
    
    [LAI,FAVD,P,Wave,CC] = wave2lai(shotnumber(i,:),LGE,LGW);
    base = find(Wave(:,1) < (2+0.15) & Wave(:,1) > (2-0.15));
    
    LAIc = -log(P)/(0.5.*0.735).*(pft(i,1)+pft(i,2));
    LAIh = -log(P)/(0.5.*0.84).*(pft(i,3)+pft(i,4)+pft(i,5));
    LAI = (LAIc+LAIh).*1;
    density(i,:) = LAI(base,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LLL = LAI(1:base,1);
LLL = diff(LLL);
LAI = [LLL;0];

dbh6 = (10.^(0.0331.*Wave(1:base,1)+0.8273));
dbh8 = (10.^(0.0324.*Wave(1:base,1)+0.9692));
dbh9 = (10.^(0.0445.*Wave(1:base,1)+0.5680));
dbh10 = (10.^(0.0476.*Wave(1:base,1)+0.5192));
dbh11 = (10.^(0.0290.*Wave(1:base,1)+0.8264));

dbhfull = (dbh6*pft(i,1))+(dbh8*pft(i,2))+(dbh9*pft(i,3))+(dbh10*pft(i,4))+(dbh11*pft(i,5));

    
        %NEW BLEAF MIXTURE 
        h1 = 15; h2 = 15; %max heights for bleaf
        maxhite = find(Wave(:,1) < (h1+0.15) & Wave(:,1) > (h1-0.15));  if Wave(1,1)<h1; maxhite = 1; end; maxhite = maxhite(1,1);
        maxhite2 = find(Wave(:,1) < (h2+0.15) & Wave(:,1) > (h2-0.15)); if Wave(1,1)<h2; maxhite2 = 1; end; maxhite2 = maxhite2(1,1);
        Bleafpft6 = 0.024.*dbh6.^1.899; zz = find(Bleafpft6>Bleafpft6(maxhite2,1)); Bleafpft6(zz) = Bleafpft6(maxhite2,1);
        Bleafpft8 = 0.045.*dbh8.^1.683; zz = find(Bleafpft8>Bleafpft8(maxhite2,1)); Bleafpft8(zz) = Bleafpft8(maxhite2,1);
        Bleafpft9 = 0.0031.*dbh9.^2.249; zz = find(Bleafpft9>Bleafpft9(maxhite,1)); Bleafpft9(zz) = Bleafpft9(maxhite,1);
        Bleafpft10 = 0.0148.*dbh10.^1.86; zz = find(Bleafpft10>Bleafpft10(maxhite,1)); Bleafpft10(zz) = Bleafpft10(maxhite,1);
        Bleafpft11 = 0.0085.*dbh11.^1.731; zz = find(Bleafpft11>Bleafpft11(maxhite,1)); Bleafpft11(zz) = Bleafpft11(maxhite,1);

        %figure,plot(dbh6,6.*Bleafpft6,'b', dbh8,10.*Bleafpft8,'k', dbh9,30.*Bleafpft9,'r', dbh10,24.2.*Bleafpft10,'y', dbh11,60.*Bleafpft11,'g'); ylim([1 160]);

        lambdapft6d = lai2n(LAI,Bleafpft6,(dbhfull*0+6)).*pft(i,1);
        lambdapft8d = lai2n(LAI,Bleafpft8,(dbhfull*0+8)).*pft(i,2);
        lambdapft9d = lai2n(LAI,Bleafpft9,(dbhfull*0+9)).*pft(i,3);
        lambdapft10d = lai2n(LAI,Bleafpft10,(dbhfull*0+10)).*pft(i,4);
        lambdapft11d = lai2n(LAI,Bleafpft11,(dbhfull*0+11)).*pft(i,5);

            %density(i,:) = sum(lambdapft6d+lambdapft8d+lambdapft9d+lambdapft10d+lambdapft11d);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % canopy modes to nplant
            %z = find(dbhfull >= dbhmin & dbhfull < dbhmax);
            nplant(:,1) = lambdapft6d;
            nplant(:,2) = lambdapft8d;
            nplant(:,3) = lambdapft9d;
            nplant(:,4) = lambdapft10d;
            nplant(:,5) = lambdapft11d;
            
            lambdapft6d = []; lambdapft8d = []; lambdapft9d = []; lambdapft10d = []; lambdapft11d = [];
            SLA6 = []; SLA8 = []; SLA9 = []; SLA10 = []; SLA11 = []; zz = [];
            dbh6ed = []; dbh8ed = []; dbh9ed = []; dbh10ed = []; dbh11ed = [];
            
        nplant(find(isnan(nplant)))=0;
                
        
        // %BA(i,:) = sum(dbhfull.*dbhfull.*pi.*0.25.*nplant(:,2)*3);
        // ba = dbhfull.*dbhfull.*pi.*0.25.*(nplant(:,1)+nplant(:,2)+nplant(:,3)+nplant(:,4)+nplant(:,5));
        // for bb = 1:200
        //     z = find(dbhfull<=bb & dbhfull>(bb-1));
        //     BAA(i,bb) = sum(ba(z));
        // end
            
        // LLL = [];
        // LLLdbh = [];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Create CSS File
        css6 = zeros(size(dbh6,1),10);
        css6(:,2) = i; % plot number
        css6(:,4) = dbh6; % dbh
        css6(:,5) = (log10(dbh6)-0.8273)./0.0331; % height
        css6(:,6) = 6; % pft
        css6(:,7) = nplant(:,1); % density ||| plants per unit area (#/m2). In this case only 1 plant each time.
        
        css8 = zeros(size(dbh8,1),10);
        css8(:,2) = i;
        css8(:,4) = dbh8;
        css8(:,5) = (log10(dbh8)-0.9692)./0.0324;
        css8(:,6) = 8;
        css8(:,7) = nplant(:,2);
          
        css9 = zeros(size(dbh9,1),10);
        css9(:,2) = i;
        css9(:,4) = dbh9;
        css9(:,5) = (log10(dbh9)-0.5680)./0.0445;
        css9(:,6) = 9;
        css9(:,7) = nplant(:,3);
                
        css10 = zeros(size(dbh10,1),10);
        css10(:,2) = i;
        css10(:,4) = dbh10;
        css10(:,5) = (log10(dbh10)-0.5192)./0.0476;
        css10(:,6) = 10;
        css10(:,7) = nplant(:,4);
                
        css11 = zeros(size(dbh11,1),10);
        css11(:,2) = i;
        css11(:,4) = dbh11;
        css11(:,5) = (log10(dbh11)-0.8264)./0.0290;
        css11(:,6) = 11;
        css11(:,7) = nplant(:,5);
        
        css = [css6;css8;css9;css10;css11];
        CSS = [CSS;css6;css8;css9;css10;css11];
  nplant = [];
  
  // BB(i,1) = sum(css(:,4).*css(:,4).*css(:,7).*0.25.*pi);
  // BB(i,2) = sum(LAI);
  // BB(i,3) = Wave(1,1);
  // LAI = [];
// end
// CSS(:,3) = 1:size(CSS,1);
// CSS(1,:) = [];


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Create BA File
ptcharea = max(CSS(:,2));
BA = (CSS(:,4).*CSS(:,4).*CSS(:,7)*0.25*pi*(1/ptcharea));
CList = zeros(1,20);
for k = 1:6
for i = 1:20
z = find(CSS(:,4) < (i*10) & CSS(:,6)==(k+5));
CList(k,i) = sum(BA(z));
end
CList(k,2:20) = diff(CList(k,:));
end

CList(2,:) = [];
C = rot90(CList); C = flipud(C);

%
xaxis = 10:10:((size(CList,2))*10); xaxis = xaxis(:);
if min(CSS(:,6))>4.5
%mycolor=[0.627 0.322 0.176;0.804 0.522 0.247;0.871 0.721 0.529;0.604 0.804 0.196;0.133 0.545 0.133;0.420 0.557 0.137];
mycolor=[0.55 0.47 0.14;0.36 0.2 0.09;0.0 1.0 0.0;0.137 0.556 0.137;0.184 0.309 0.184];
bar(xaxis,C(:,1:5),'stack'); colormap(mycolor);
%legend('ECf','LCf','EHw','MHw','LHw','Location','SouthEastOutside');
else
mycolor=[0.604 0.804 0.196;0.133 0.545 0.133;0.420 0.557 0.137];
bar(xaxis,C(:,1:3),'stack'); colormap(mycolor);
%legend('ES','MS','LS','Location','SouthEastOutside');
end
xlabel('DBH (cm)','fontsize',20);
ylabel('Basal Area (m^2/ha)','fontsize',20);
%title('Basal Area DBH size classes');
xlim([0 100]);
ylim([0 15]);
set(gca,'FontSize',20);
set(gca,'XTick',[0:10:100]);
set(gca,'YTick',[0:5:15]);
%}
  
            