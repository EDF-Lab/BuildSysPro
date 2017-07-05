within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model FLUXsurfLWRinc
  "Calculation of global incident irradiance on a particular surface"

  FLUXsurf fLUXsurf(
    albedo=albedo,
    azimut=azimut,
    incl=incl,
    diffus_isotrope=diffus_isotrope)
    annotation (Placement(transformation(extent={{-62,-10},{-32,20}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{44,-2},{58,12}})));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Surface azimuth (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°";
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Surface tilt - downwards = 180° skyward = 0°, vertical = 90°";
  parameter Real albedo=0.2 "Albedo of the environment";
parameter Integer diffus_isotrope=1 "Model for diffuse irradiance"
    annotation (Dialog(
      compact=true), choices(
      choice=1 "Isotropic",
      choice=2 "Circumsolar diffuse model (Hay Davies Kluch Reindl))"));

Modelica.Blocks.Interfaces.RealInput G[10]
    "Inputs data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle}"
    annotation (Placement(transformation(extent={{-120,-18},{-80,22}},
        rotation=0), iconTransformation(extent={{-120,-10},{-100,10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxIncExt
    "Global irradiance in [W/m²]" annotation (Placement(transformation(extent=
            {{65,-12},{99,22}}, rotation=0), iconTransformation(extent={{100,-11},
            {120,9}})));
equation
  connect(fLUXsurf.FluxIncExt[1], add.u1) annotation (Line(
      points={{-30.5,3.85},{-12.25,3.85},{-12.25,9.2},{42.6,9.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf.FluxIncExt[2], add.u2) annotation (Line(
      points={{-30.5,4.85},{-12.25,4.85},{-12.25,0.8},{42.6,0.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExt, add.y) annotation (Line(
      points={{82,5},{58.7,5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(G, fLUXsurf.G) annotation (Line(
      points={{-100,2},{-82,2},{-82,5},{-63.5,5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(graphics={
        Polygon(
          points={{-100,-83},{100,-23},{100,-42},{-100,-100},{-100,-83}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-92,81},{41,-53}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,104},{98,51}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Az = %azimut °"),
        Text(
          extent={{-128,60},{88,19}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Incl = %incl °")}),
    Documentation(revisions="<html>
<p>Aurélie Kaemmerlen 05/2011 : Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</p>
<p>Hassan Bouia 03/2013 : simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Amy Lindsay 03/2013 : ajout du paramètre diffus_isotrope pour choisir entre un modèle de diffus isotrope ou le modèle de diffus HDKR</p>
</html>", info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Model which takes as input the vector G from a weather reader to calculate the surface irradiance on a particular surface (tilt and orientation given). G contains:
<ul>
 <li> (1) Horizontal diffuse flux</li>
 <li>(2) Normal direct flux</li>
 <li>(3) Horizontal direct flux</li>
 <li>(4) Horizontal global flux</li>
 <li>(5) Time in UTC at time t = 0 (start of the simulation)</li>
 <li>(6-7-8) Sun's direction cosines (6-sinH, 7-cosW, 8-cosS)</li>
 <li>(9) Solar azimuth angle</li>
 <li>(10) Solar elevation angle</li>
</ul></p>
<p>You can choose which diffuse model to use. The isotropic diffuse model is considered more conservative (tendency to underestimate the incident radiation on an inclined plane) but is easier to use. The diffuse model Hay Davies Klucher Reindl (HDKR) is preferred in solar applications (photovoltaic, solar thermal ...).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author :   Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>
"));
end FLUXsurfLWRinc;
