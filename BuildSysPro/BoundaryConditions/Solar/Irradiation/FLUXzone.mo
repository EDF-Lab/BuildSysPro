within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model FLUXzone "Calculation of irradiance and illuminance for a zone model"

parameter Real albedo=0.2 "Albedo of the environment";
parameter Boolean ChoixAzimuth=false
    "Provide azimuth for each surface or considered a parallelepipedic zone"
    annotation(choices(choice=true "Azimuth defined for each surface", choice=false
        "Defined zone orientation (beta)",                                                                       radioButtons=true));
parameter Real beta=0
    "Zone orientation azimut=beta+azimut, (if beta=0 : azimut={N=180,S=0,E=-90,O=90})"
    annotation(Dialog(enable=not ChoixAzimuth));
parameter Real azim[5]={0,beta+180,beta,beta-90,beta+90}
    "Walls azimuth, by default 1-Ceiling, 2-North, 3-South, 4-East, 5-West"
      annotation(Dialog(enable=ChoixAzimuth));
parameter Real incl[5]={0,90,90,90,90}
    "Walls tilt, by default 1-Ceiling, 2-North, 3-South, 4-East, 5-West";
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExtNorth[3]
    "Irradiance for the North facing surface [W/m²] 1-Diffuse, 2-Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{80,31},{118,69}}, rotation=0),
        iconTransformation(extent={{100,32},{120,52}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExtSouth[3]
    "Irradiance for the South facing surface [W/m²] 1-Diffuse, 2-Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{80,-9},{118,29}}, rotation=0),
        iconTransformation(extent={{100,-6},{120,14}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExtRoof[3]
    "Irradiance for the sky facing surface [W/m²] 1-Diffuse, 2-Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{81,62},{118,99}}, rotation=0),
        iconTransformation(extent={{100,74},{120,94}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExtEast[3]
    "Irradiance for the East facing surface [W/m²] 1-Diffuse, 2-Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{81,-49},{118,-12}}, rotation=
            0), iconTransformation(extent={{100,-46},{120,-26}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExtWest[3]
    "Irradiance for the West facing surface [W/m²] 1-Diffuse, 2-Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{80,-89},{118,-51}}, rotation=
            0), iconTransformation(extent={{100,-86},{120,-66}})));

Modelica.Blocks.Interfaces.RealInput G[10]
    "Inputs data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle}"
    annotation (Placement(transformation(extent={{-133,-25},{-93,15}},
        rotation=0), iconTransformation(extent={{-113,-5},{-93,15}})));

  Modelica.Units.SI.HeatFlux DIRH;
  Modelica.Units.SI.HeatFlux DIRN;
  Modelica.Units.SI.HeatFlux GLOH;
  Modelica.Units.SI.HeatFlux DIFH;
  Real FLUX[15];
  Real DiffusSol[5];
  output Real sin_h;
  output Real cosi[5];
protected
  parameter Real azim_in[5]=if ChoixAzimuth then azim[1:5] else {0,beta+180,beta,beta-90,beta+90};
  constant Real d2r=Modelica.Constants.pi/180;
  final parameter Real s[5]={incl[i]*d2r for i in 1:5} "tilt";
  final parameter Real g[5]={azim_in[i]*d2r  for i in 1:5} "Orientation";
  final parameter Real coef1[5]={0.5*(1 - cos(s[i]))*albedo for i in 1:5};
  final parameter Real coef2[5]={0.5*(1 + cos(s[i])) for i in 1:5};
  // Direction cosines of the plan
  final parameter Real l[5]={cos(s[i]) for i in 1:5};
  final parameter Real m[5]={sin(s[i])*sin(g[i]) for i in 1:5};
  final parameter Real n[5]={sin(s[i])*cos(g[i]) for i in 1:5};

  Real Idn "Direct normal irradiance";
  Real Idi "Isotropic horizontal diffuse irradiance";
  Real Edn "Direct normal illuminance";
  Real Edi "Diffuse horizontal illuminance";
  Real gamma "Solar elevation angle above the horizon [rad]";
  Real pi=Modelica.Constants.pi;
  Real phi "Sun azimuth relative to South [rad]";
  Real teta[5] "Angle between solar beam and surface normal [rad]";
  Real Erp[5] "Direct illuminance on the surfaces [lux]";
  Real Efp[5] "Diffuse illuminance on the surfaces [lux]";
  Real ERrp[5] "Illuminance reflected by the ground on the surfaces [lux]";

public
  Modelica.Blocks.Interfaces.RealOutput IlluSouth[3]
    "Illuminance for the South facing surface [lumen] 1-Direct, 2-Diffuse and 3-Reflected"
    annotation (Placement(transformation(extent={{-20,-15},{26,31}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,110})));

  Modelica.Blocks.Interfaces.RealOutput IlluNorth[3]
    "Illuminance for the North facing surface [lumen] 1-Direct, 2-Diffuse and 3-Reflected"
    annotation (Placement(transformation(extent={{-20,45},{26,91}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,110})));
  Modelica.Blocks.Interfaces.RealOutput IlluWest[3]
    "Illuminance for the West facing surface [lumen] 1-Direct, 2-Diffuse and 3-Reflected"
    annotation (Placement(transformation(extent={{-20,-45},{26,1}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,110})));
  Modelica.Blocks.Interfaces.RealOutput IlluEast[3]
    "Illuminance for the East facing surface [lumen] 1-Direct, 2-Diffuse and 3-Reflected"
    annotation (Placement(transformation(extent={{-20,-75},{26,-29}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealOutput IlluRoof[3]
    "Illuminance for the sky facing surface [lumen] 1-Direct, 2-Diffuse and 3-Reflected"
    annotation (Placement(transformation(extent={{-20,15},{26,61}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,110})));

algorithm
  // sin_h and cosi computations
  sin_h :=G[6];  //First direction consine of the solar vector
  cosi:={max(0, l[i]*G[6] + m[i]*G[7] + n[i]*G[8]) for i in 1:5};

//equation
//// Irradiance computation
//Direct irradiance calculation: if sin h is negative, direct irradiance is canceled"
  DIFH:=G[1];
  DIRN:=G[2];
  DIRH:=G[3];
  GLOH:=G[4];

 for i in 1:5 loop
   // FLUX vector for irradiance on the surfaces: diffuse, direct, cosi
   DiffusSol[i] :=max(0, coef1[i]*GLOH);
   FLUX[3*i-2] :=max(0, coef2[i]*DIFH) + DiffusSol[i];
   FLUX[3*i-1] :=if noEvent(sin_h > 0.01) then max(0, cosi[i])*DIRN else 0; //To avoid cases with a non-zero direct irradiance when the sun is below the horizon
   FLUX[3*i] :=cosi[i];
 end for;
  FluxIncExtRoof := FLUX[1:3];
  FluxIncExtNorth := FLUX[4:6];
  FluxIncExtSouth := FLUX[7:9];
  FluxIncExtEast := FLUX[10:12];
  FluxIncExtWest := FLUX[13:15];

equation

 //Computation of natural illuminance (French building regulation RT2012)
  Idn=DIRN;
  Idi=DIFH;
  gamma=G[10]*pi/180;
  Edn=Idn*(-1.0375321*10^(-8)*gamma^6+2.90312257*10^(-6)*gamma^5-3.31804423*10^(-4)*gamma^4+1.99283162*10^(-2)*gamma^3-6.72171072*10^(-1)*gamma^2+1.24650445*10*gamma+2.38954889);
  if Idn<1 then
    Edi=124*Idi;
  else if Idn>120 then
        Edi=128*Idi;
  else Edi=116*Idi;
  end if;
  end if;

algorithm
  // Computation of illuminance (direct, diffuse and reflected) without shading
  phi:=G[9]*pi/180;
  for i in 1:5 loop
  teta[i]:=min(pi/2, acos(cos(gamma)*sin(incl[i]*pi/180)*cos(phi - azim[i]*pi/180)+ sin(gamma)*cos(incl[i]*pi/180)));
  Erp[i]:=cos(teta[i])*Edn;
  Efp[i]:=Edi*0.5*(1 + cos(incl[i]*pi/180));
  ERrp[i]:=(Edn*sin(gamma) + Edi)*albedo*0.5*(1 - abs(cos(incl[i]*pi/180)));
  end for;

  IlluRoof := {Erp[1],Efp[1],ERrp[1]};
  IlluNorth := {Erp[2],Efp[2],ERrp[2]};
  IlluSouth := {Erp[3],Efp[3],ERrp[3]};
  IlluEast := {Erp[4],Efp[4],ERrp[4]};
  IlluWest
         :={Erp[5],Efp[5],ERrp[5]};

annotation (Documentation(info="<html>
<p><i><b> Calculation of irradiance and illuminance for a zone model (tilt and azimuth given) </b></i></p>

<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>French Building regulation 2012 (RT 2012) for the illuminance model</p>
<p><u><b>Instructions for use</b></u></p>
<p>Model which takes as input the vector G from a weather reader to calculate the surface irradiance on a particular surface (tilt and orientation given). G contains:</p>
<ul>
 <li>(1) Horizontal diffuse flux</li>
 <li>(2) Normal direct flux</li>
 <li>(3) Horizontal direct flux</li>
 <li>(4) Horizontal global flux</li>
 <li>(5) Time in UTC at time t = 0 (start of the simulation)</li>
 <li>(6-7-8) Sun's direction cosines (6-sinH, 7-cosW, 8-cosS)</li>
 <li>(9) Solar azimuth angle</li>
 <li>(10) Solar elevation angle</li>
</ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (identical to the one used in the BESTEST except for the time base: UTC instead of true solar time (TST)) - Aurélie Kaemmerlen 09/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : Ajout de la paramétrisation de la moyenne des flux mesurés (Booléen MoyFlux), du choix des flux en entrée et de l'orientation supplémentaire par rapport au Sud</p>
<p>Aurélie Kaemmerlen 05/2011 : Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</p>
<p>Hassan Bouia 03/2013 : simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Aurélie Kaemmerlen 10/2013 : Ajout de sécurités quant au paramétrage entre le vecteur azim et le paramètre beta + équation conditionnelle ajoutée pour s'assurer de azim par défaut si on renseigne beta.</p>
<p>Laura Sudries, Vincent Magnaudeix 05/2015 : Ajout du calcul des éclairements naturels direct, diffus et réfléchi par le sol sur chaque orientation du local.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1)),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}},
        grid={1,1},
        initialScale=0.1), graphics={Ellipse(
          extent={{-89,90},{20,-20}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,-54},{-20,-80}},
          lineColor={0,0,255},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,-54},{-54,-40},{21,-40},{-20,-54},{-96,-54}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{21,-40},{21,-66},{-20,-80},{-20,-54},{21,-40}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid)}),
              Icon(graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end FLUXzone;
