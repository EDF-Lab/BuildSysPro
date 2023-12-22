within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model FLUXsurf "Calculation of irradiance on a particular surface"

  parameter Modelica.Units.NonSI.Angle_deg azimut
    "Surface azimuth (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°";
  parameter Modelica.Units.NonSI.Angle_deg incl
    "Surface tilt - downwards = 180° skyward = 0°, vertical = 90°";
    parameter Boolean use_Albedo_in=false "Variable Albedo "
  annotation(choices(choice=true "yes", choice=false "no (constant)",radioButtons=true));
parameter Real albedo=0.2 "Albedo of the environment" annotation(Dialog(enable=not use_Albedo_in));
parameter Integer diffus_isotrope=1 "Model for diffuse irradiance"
    annotation (Dialog(
      compact=true), choices(
      choice=1 "Isotropic",
      choice=2 "Circumsolar diffuse model (Hay Davies Kluch Reindl))"));

// Model parameterization: selection of a specific time, of time interval for measurement of fluxes and input data fluxes

  Modelica.Units.SI.HeatFlux DIRH;
  Modelica.Units.SI.HeatFlux DIRN;
  Modelica.Units.SI.HeatFlux GLOH;
  Modelica.Units.SI.HeatFlux DIFH;

  Modelica.Units.SI.HeatFlux DiffusSol
    "Part of the diffuse irradiance from the ground reflection";

output Real sin_h;
output Real cosi;

Modelica.Blocks.Interfaces.RealInput G[10]
    "Inputs data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle}"
    annotation (Placement(transformation(extent={{-140,-30},{-100,
        10}},
        rotation=0), iconTransformation(extent={{-120,-10},{-100,10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExt[3]
    "Surface irradiance in [W/m²] 1-Diffuse, 2-Direct and 3-Cosi" annotation (
      Placement(transformation(extent={{83,-26},{117,8}}, rotation=0),
        iconTransformation(extent={{100,-11},{120,9}})));

  Modelica.Blocks.Interfaces.RealOutput AzHSol[3]
    "Solar azimuth and elevation angle and diffuse irradiation"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));

Modelica.Blocks.Interfaces.RealInput Albedo_in if use_Albedo_in "Albedo"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
        rotation=0), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));

// Internal connector
protected
  Modelica.Blocks.Interfaces.RealInput Albedo_in_internal
    "Internal connector required in the case of conditional connection";
  constant Real d2r=Modelica.Constants.pi/180;
  constant Modelica.Units.SI.HeatFlux Isc=1367 "solar constant";
  final parameter Real coef1=0.5*(1 - cos(incl*d2r));
  final parameter Real coef2=0.5*(1 + cos(incl*d2r));
  final parameter Real coef3=sin(incl*d2r/2)^3;
  final parameter Real s=incl*d2r "Surface tilt";
  final parameter Real g=azimut*d2r "Orientation";
  // Direction cosines of the plan
  final parameter Real l=cos(s);
  final parameter Real m=sin(s)*sin(g);
  final parameter Real n=sin(s)*cos(g);
  //cosi:=max(0,{l,m,n}*CosDir);
  // For the HDKR model
  Real AI "anisotropy index";
  Real f "correction factor for the horizon irradiance";
  Modelica.Units.SI.HeatFlux I0
    "extraterrestrial illumination on a horizontal surface (outside the atmosphere)";

algorithm
  // sin_h and cosi calculations
  sin_h := G[6]; //First sun's direction cosine
  cosi :=max(0,l*G[6]+m*G[7]+n*G[8]);
  // Calculation of parameters for diffuse modelling with the model HDKR
  I0 :=max(0, Isc*(1 + 0.033*cos(360*(floor((time + G[5])/86400) + 1)/365))*
    sin_h);
  AI :=if noEvent(sin_h > 0) then DIRH/I0 else 0;
  f :=if noEvent(DIRH > 0 and GLOH > 0) then sqrt(DIRH/GLOH) else 0;

equation

connect(Albedo_in, Albedo_in_internal);
  if not use_Albedo_in then
    Albedo_in_internal=albedo;
  end if;
  //// irradiance CALCULATION
//Direct irradiance calculation: if sin h is negative, direct fluxes are canceled"
  {DIFH,DIRN,DIRH,GLOH}=G[1:4];

 // Vector FLUX on an output inclined surface: diffuse, direct, cosi
   DiffusSol = max(0, coef1*GLOH*Albedo_in_internal);
  FluxIncExt[1] = if diffus_isotrope == 1 then max(0, coef2*DIFH) + DiffusSol
     else max(0, coef2*(1 - AI)*(1 + f*coef3)*DIFH) + DiffusSol;
  FluxIncExt[2] = if noEvent(sin_h > 0.01) then (if diffus_isotrope == 1 then
    max(0, cosi)*max(0, DIRN) else max(0, cosi)*max(0, DIRN) + max(0, AI*cosi*
    DIFH/sin_h)) else 0;
   //To avoid cases with a non-zero direct irradiance when the sun is below the horizon
  FluxIncExt[3] = cosi;
 //FLUX[4] = FLUX[1]+FLUX[2];

  //AzHSol[1] = AzHaut[1];
  //AzHSol[2] = AzHaut[2];
  AzHSol[1] = G[9];
  AzHSol[2] = G[10];
  AzHSol[3] = DiffusSol;

annotation (Documentation(info="<html>
<p><i><b> Calculation of diffuse and direct incident irradiance on a particular surface (tilt and azimuth given) </b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>In the diffuse isotropic model, the total irradiance on an particular surface is given by:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/diffus_isotrope.png\" alt=\"FLUX_tot=cos(incidence)*FLUX_DIRN+(1+cos(inclinaison))/2*FLUX_DIFH+(1-cos(inclinaison))/2*albedo*FLUX_GLOH\"/></p>
<p>In the HDKR (Hay, Davies, Klucher, Reindl) model, the total radiation on an inclined surface is given by:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/diffus_HDKR.png\"/></p>
<p>where:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/AI_HDKR.png\"/>,</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/f_HDKR.png\"/>,</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/GLOH_extraterrestre.png\"/></p>
<p>where n is the calendar day (day number within the month) and Isc the solar constant (in this model Isc = 1367 W / m²). </p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
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
<p>You can choose which diffuse model to use. The isotropic diffuse model is considered more conservative (tendency to underestimate the incident radiation on an inclined plane) but is easier to use. The diffuse model Hay Davies Klucher Reindl (HDKR) is preferred in solar applications (photovoltaic, solar thermal ...).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model: </p>
 <ul>
 <li> Aurélie Kaemmerlen 02/2011:
Validation of similar model developed for BESTEST (time in RST) and DIRH and GLOH input fluxes: verification with TRNSYSv16: TMY reading with Type89i and calculation of incidents fluxes with Type16g
Analytical Validation (Via Excel calculations) on the model parametrization: type of weather, type of average and flows considered </li>
 <li>Amy Lindsay 03/2013: validation du modèle de diffus HDKR sur données d'ensoleillement à PV ZEN </li>
 </ul>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 :</p>
<p><ul>
<li>Ajout de la paramétrisation de la moyenne des flux mesurés (Booléen MoyFlux) et du choix des flux en entrée</li>
<li>Correction dans le calcul du cosi : il manquait le paramètre h0 !</li>
</ul></p>
<p><br>Aurélie Kaemmerlen 05/2011 : </p>
<p><ul>
<li>Ajout de sorties : hauteur et azimut du soleil, Rayonnement incident diffus provenant du sol</li>
<li>Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</li>
<li>Ajout d'une sécurité pour éviter un flux direct infini : sin_h&gt;0.01 au lieu de &gt;0 pour le calcul de FDIRN/FDIRH</li>
</ul></p>
<p><br>Hassan Bouia 03/2013 : Simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Amy Lindsay 03/2013 : Ajout du paramètre diffus_isotrope pour choisir entre un modèle de diffus isotrope ou le modèle de diffus HDKR</p>
<p>Aurélie Kaemmerlen 09/2013 : Ajout du choix de mettre un albédo variable (mesures BESTLAB par exemple) et ajout d'un max entre 0 et DIRN pour éviter les valeurs négatives au lever-coucher de soleil</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1)),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}},
        grid={1,1},
        initialScale=0.1), graphics={
        Ellipse(
          extent={{-92,81},{41,-53}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-83},{100,-23},{100,-42},{-100,-100},{-100,-83}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,104},{98,51}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Az = %azimut °"),
        Text(
          extent={{-125,65},{126,14}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Incl = %incl °")}),
              Icon(graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end FLUXsurf;
