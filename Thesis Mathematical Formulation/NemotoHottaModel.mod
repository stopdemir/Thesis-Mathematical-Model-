int numZones=...;
int numDistricts=...;
int numParties=...;

range Zone=1..numZones;
range Party=1..numParties;
range District=1..numDistricts;
range District_Source=0..numDistricts;
range DistrictAll=0..(numDistricts*2);
//range Party=1..numParties;
	
//PARAMETERS

float p[District]=...;                       //Population of each unit i
float arcs[DistrictAll][DistrictAll]=...;          //To  control the arc sets

float v[District][Party]=...;
float bigM=...;
float Beta=...;
float sBar=(sum(i in District) p[i])/numZones;

//DECISION VARIABLES
dvar boolean y[District][Zone];                 // y_ih=1 if in the h^th copy of G the flow enters through node i
dvar boolean z[District][Zone];                 // z_ih=1 if unit i assigned to zone h
dvar float+ flow[DistrictAll][DistrictAll][Zone];     // arc flow amount 

                             

dvar boolean c[Party][Zone];
dvar float o[Party][Zone];
dvar boolean dum[Party][Party][Zone];
dvar float t[Zone];




maximize  sum(h in Zone) c[1][h];
subject to
{


forall(i in District, h in Zone) //parametere'nin 0 da olmasý ile alakalý sorun çýkabilir arcs[0][2] gibi'
       sum(j in DistrictAll:i!=j) flow[j][i][h]*arcs[j][i]==sum(j in DistrictAll:i!=j) flow[i][j][h]*arcs[i][j];
       
forall(i in District, h in Zone) flow[0][i][h]==200*y[i][h];
forall(h in Zone)                sum(i in District) y[i][h]==1;
forall(i in District, h in Zone) sum(j in DistrictAll:i!=j) flow[j][i][h]*arcs[j][i]<=200*z[i][h];
forall(i in District, h in Zone) z[i][h]<=flow[i][i+numDistricts][h]; 
forall(i in District)            sum(h in Zone) z[i][h]==1;
  
//From old models
forall(h in Zone, k in Party) sum(i in District) z[i][h]*v[i][k]==o[k][h];
forall(h in Zone, k in Party, p in Party) o[p][h]-o[k][h]+bigM*dum[k][p][h]>=0;
forall(h in Zone, k in Party) sum(p in Party:k!=p) dum[k][p][h]-numParties+2<=c[k][h];
forall(h in Zone) sum(k in Party) c[k][h]==1; 
forall(h in Zone) sum(i in District) z[i][h]*p[i]==t[h];
forall(h in Zone) t[h]<=sBar*(1+Beta);
forall(h in Zone) t[h]>=sBar*(1-Beta);   

}




