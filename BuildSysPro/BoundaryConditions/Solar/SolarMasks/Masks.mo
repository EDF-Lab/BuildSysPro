within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
model Masks
  "Base model - Solar incident irradiance and illuminance on a surface considering solar mask"

// Paramètres propres au masque
parameter Boolean useEclairement=false
  annotation(choices(choice=true "With calculation of natural lighting",                                    choice=false
        "Without calculation of natural lighting",                                                                                                  radioButtons=true), Dialog(group="Options"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "Surface azimuth (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°"   annotation(Dialog(group="Surface description"));
parameter Integer TypeMasque annotation(Dialog(group="Shading devices"),choices(choice=0
        "Vertical + horizontal",                                                                                choice=1
        "Horizontal overhang",choice=2 "No shading device", radioButtons=true));
parameter Modelica.SIunits.Distance Av=0.5 "Overhang" annotation(Dialog(enable=TypeMasque<>2,group="Shading devices"));
parameter Modelica.SIunits.Distance Ha=0.3
    "Distance between the overhang and the top of the surface (window)"
                                                                       annotation(Dialog(enable=TypeMasque<>2,group="Shading devices"));
parameter Modelica.SIunits.Distance Lf=1 "Surface (window) width"
                                                                 annotation(Dialog(enable=TypeMasque<>2,group="Shading devices"));
parameter Modelica.SIunits.Distance Hf=1 "Surface (window) height"
                                                                  annotation(Dialog(enable=TypeMasque<>2,group="Shading devices"));
parameter Modelica.SIunits.Distance Dd=0.5 "Lateral overhang (right hand side)"
                                                               annotation(Dialog(enable=TypeMasque<>2,group="Shading devices"));
parameter Modelica.SIunits.Distance Dg=0.5 "Lateral overhang (left hand side)"
                                                              annotation(Dialog(enable=TypeMasque<>2,group="Shading devices"));

parameter Boolean MasqueLointain=false
annotation(Dialog(group="Options"),choices(choice=true
        "With vertical distant mask",                                                             choice=false
        "Without vertical distant mask",                                                                                                  radioButtons=true));
parameter Modelica.SIunits.Distance dE=5
    "Distance from the surface (window) to the distant masks" annotation(Dialog(enable=MasqueLointain,group="Distant masks"));
    parameter Modelica.SIunits.Distance hpE=2 "Height of the distant mask" annotation(Dialog(enable=MasqueLointain,group="Distant masks"));

Modelica.SIunits.Conversions.NonSIunits.Angle_deg AzimutSoleil
    "Solar azimuth angle";
Modelica.SIunits.Conversions.NonSIunits.Angle_deg HauteurSoleil
    "Solar elevation angle";
Modelica.SIunits.HeatFlux DiffusSol
    "Share of the diffuse incident radiation from the reflection on the ground";
output Real FacMasqueDir
    "Close mask factor for direct fluxes (these are the same for thermal flux and luminous flux)";
output Real FacMasqueDif
    "Close mask factor for diffuse fluxes (these are the same for thermal flux and luminous flux)";
output Real FE_dir
    "Direct solar radiation attenuation factor due to a vertical distance mask";

Modelica.SIunits.Area A0 "Sunny window surface";

Real pi=Modelica.Constants.pi;
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxMasques[3]
    "Solar irradiation for the surface considering the shading effects 1-Diffuse, 2- Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{30,-20},{70,20}}, rotation=0),
        iconTransformation(extent={{100,-12},{124,12}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt[3]
    "Incident irradiance 1-Diffuse, 2- Direct and 3-Cosi" annotation (Placement(
        transformation(extent={{-77,-18},{-43,16}}, rotation=0),
        iconTransformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealInput AzHSol[3]
    "Irradiation data: 1-Solar azimuth angle 2-Solar elevation angle 3-Incident flux from ground"    annotation (Placement(transformation(
          extent={{-99,19},{-59,59}}), iconTransformation(extent={{-100,23},{-86,
            37}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Natural incident illuminance -direct -diffuse -reflected [lumen]"                                  annotation (Placement(transformation(
          extent={{-80,-51},{-40,-11}}),
                                       iconTransformation(extent={{-100,-37},{-86,
            -23}})));
  Modelica.Blocks.Interfaces.RealOutput EclMasques[3] if useEclairement
    "Natural illuminance considering shading effects -direct -diffuse -reflected [lumen]"
    annotation (Placement(transformation(extent={{50,-57},{84,-23}}),
        iconTransformation(extent={{70,-37},{84,-23}})));
  Modelica.Blocks.Sources.RealExpression CalculEclMasques[3](y={Ecl[1]*
        FacMasqueDir*FE_dir,Ecl[2]*FacMasqueDif,Ecl[3]}) if              useEclairement
    "Lighting illuminations with close mask vector: direct, diffuse, reflected"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
algorithm

AzimutSoleil:=AzHSol[1];
HauteurSoleil:=AzHSol[2];
DiffusSol:=AzHSol[3];

if TypeMasque==0 then

  //Full mask
  if noEvent(abs(azimut-AzimutSoleil)>=90) or (noEvent(HauteurSoleil<=0)) then
      A0:=0;
  else
      A0 :=BuildSysPro.BoundaryConditions.Solar.SolarMasks.FullMask(
        Av=Av,
        Ha=Ha,
        Lf=Lf,
        Hf=Hf,
        Dd=Dd,
        Dg=Dg,
        AzimutSoleil=AzimutSoleil,
        HauteurSoleil=HauteurSoleil,
        azimut=azimut);
      FacMasqueDir:= A0/(Lf*Hf);
  end if;
  FacMasqueDif:=(Dd+Lf+Dg)*(Ha+Hf)/((Dd+Lf+Dg)*(Ha+Hf)+(Dd+Lf+Dg)*Av+2*(Hf+Ha)*Av);
else if TypeMasque==1 then
  //Horizontal mask
  if noEvent(abs(azimut-AzimutSoleil)>=90) or (noEvent(HauteurSoleil<=0)) then
      A0:=0;
  else
      A0 :=BuildSysPro.BoundaryConditions.Solar.SolarMasks.HorizontalMask(
          Av=Av,
          Ha=Ha,
          Lf=Lf,
          Hf=Hf,
          Dd=Dd,
          Dg=Dg,
          AzimutSoleil=AzimutSoleil,
          HauteurSoleil=HauteurSoleil,
          azimut=azimut);
      FacMasqueDir:= A0/(Lf*Hf);
     //FacMasqueDir:= min(max(0,1-(max(0,Av*tan(HauteurSoleil*Convert)/cos((AzimutSoleil-azimut)*Convert))-Ha)/Hf),1); //Formule RT2012
  end if;
  FacMasqueDif:=((Dd+Lf+Dg)*(Ha+Hf)+2*Av*(Ha+Hf))/((Dd+Lf+Dg)*(Ha+Hf)+(Dd+Lf+Dg)*Av+2*(Hf+Ha)*Av);
  //FacMasqueDif:=(2/Modelica.Constants.pi)*atan((Ha+Hf/2)/Av); //Formule RT2012
else
  FacMasqueDir:=1;
  FacMasqueDif:=1;
end if;
end if;

//Distant mask defined by a vertical plan
if MasqueLointain==true and cos((AzimutSoleil-azimut)*pi/180)>10^(-5) then //if distant mask and sun entry in the considered plan
       if hpE>0 then
         if (dE*tan(HauteurSoleil*pi/180)/cos((AzimutSoleil-azimut)*pi/180))>hpE then FE_dir:=1;else FE_dir:=0;end if;
    else FE_dir:=1;
    end if;
else FE_dir:=1;
       end if;

equation
  //Vector FLUX on a glazing with close mask / output: diffuse, direct, cosi
 FluxMasques[1] =((FluxIncExt[1] - DiffusSol)*FacMasqueDif + DiffusSol)*FE_dir;
 FluxMasques[2] =FacMasqueDir*FluxIncExt[2];
 FluxMasques[3] =FluxIncExt[3];

  if useEclairement then
    connect(CalculEclMasques.y, EclMasques) annotation (Line(
      points={{21,-30},{44,-30},{44,-40},{67,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
  annotation (Documentation(info="<html>
<p><i><b>Calculation of solar boundary conditions for the (Lf x Hf)-sized surface considering near and distant mask</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p> This model is used in <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.SolarMasks.FLUXsurfMask\"><code>FLUXsurfMask</code></a></p>
Following masks are considered:
<ul>
<li>Shading devices (near mask)</li>
<ul>
<li>Horizontal overhang such as awning</li>
<p><img src=\"modelica://BuildSysPro/Resources/Images/MasqueHorizontal.bmp\"/></p>
<li>Lateral fin</li>
<li>Both overhang and lateral fin (such as egg crate)</li>
<p><img src=\"modelica://BuildSysPro/Resources/Images/MasqueIntegral.bmp\"/> </p>
</ul>
<li>Vertical distant masks (such as building)</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>ISO 13791 standard</p>
<p>RT2012 standard for the consideration of vertical distant masks</p>
<p>Intégration de la protection solaire dans le logiciel PAPTER, M. ABDESSELAM, AIRab Consultant, Fevrier 2000 - Corrections effectuées car modèle incorrect</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>These models are valid only for vertical walls.</p>
<p>The accumulation of several masks of near types for a same wall is prohibited</p>
<p><u><b>Validations</b></u></p>
<p>Non validated model - Aurélie Kaemmerlen 11/2013</p>
<p>Non validated model for distant masks - Laura Sudries 05/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>
",                                                                           revisions="<html>
<p>Aurélie Kaemmerlen 04/2013 : Ajout d'une condition sur la hauteur du soleil pour le calcul de la surface ensoleillée. Fait suite à la correction des flux solaires (calcul de l'azimut corrigé - avant il n'était pas déterminé si sinh&lt;=0)</p>
<p>Laura Sudries, Vincent Magnaudeix 05/2015 : Ajout de la prise en compte des masques lointains verticaux</p>
<p>Benoît Charrier 05/2015 : Ajout du choix possible de prise en compte ou non des masques lointains verticaux</p>
<p>Benoît Charrier 05/2015 : Correction sur le facteur d'affaiblissement du rayonnement solaire direct dû à un masque lointain vertical, qui était appliqué par erreur au rayonnement diffus.</p>
</html>"), Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        grid={1,1}),
                graphics={
        Polygon(
          points={{56,34},{-44,34},{-44,-26},{56,-26},{56,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,-26},{-44,-26},{-54,-36},{-8,-26},{-44,-26}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-8,8},{56,-26}},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{56,34},{46,24},{46,-36},{56,-26},{56,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,34},{-54,24},{-54,-36},{-44,-26},{-44,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Polygon(
          points={{-44,34},{-54,24},{46,24},{56,34},{-44,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-44,-26},{46,24}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-22,14},{24,-14}},
          fillColor={139,175,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-8,8},{24,-14}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        grid={1,1})));
end Masks;
