function lambda = lai2n(lai,bleaf,pft)

sla_scale =  0.2;
sla_inter =  2.4;
sla_slope = -0.46;
   
SLA = pft;
z = find(pft==2);
SLA(z) = 10^(sla_inter+sla_slope*log10(12/1.0))*sla_scale;
z = find(pft==3);
SLA(z) = 10^(sla_inter+sla_slope*log10(12/0.5))*sla_scale;
z = find(pft==4);
SLA(z) = 10^(sla_inter+sla_slope*log10(12/0.333333333333333))*sla_scale;
z = find(pft==6);
SLA(z) = 6;
%SLA(z) = 3;
z = find(pft==7);
SLA(z) = 9;
%SLA(z) = 4.5;
z = find(pft==8);
SLA(z) = 10;
%SLA(z) = 5;
z = find(pft==9);
SLA(z) = 30;
%SLA(z) = 20;
z = find(pft==10);
SLA(z) = 24.2;
%SLA(z) = 15;
z = find(pft==11);
SLA(z) = 60.0;
%SLA(z) = 30;

lambda = lai./(SLA.*bleaf);



