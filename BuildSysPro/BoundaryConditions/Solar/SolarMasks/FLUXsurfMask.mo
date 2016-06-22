within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
model FLUXsurfMask
  "Solar incident irradiance and illuminance on a surface considering solar mask"
  parameter Boolean useEclairement=false
  annotation(choices(choice=true "With calculation of natural lighting",                                    choice=false
        "Without calculation of natural lighting",                                                                                                  radioButtons=true), Dialog(group="Options"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "Surface azimuth (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°"   annotation(Dialog(group="Surface description"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Surface tilt - downwards = 180° skyward = 0°, vertical = 90°"                                   annotation(Dialog(group="Surface description"));

parameter Real albedo=0.2 "Albedo of the environment" annotation(Dialog(group="Environment description"));
parameter Integer diffus_isotrope=1 "Model for diffuse irradiance"
    annotation (Dialog(
      compact=true,group="Environment description"), choices(
      choice=1 "Isotropic",
      choice=2 "Circumsolar diffuse model (Hay Davies Kluch Reindl))"));
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

  Irradiation.FLUXsurf fLUXsurf(
    azimut=azimut,
    incl=incl,
    albedo=albedo,
    diffus_isotrope=diffus_isotrope)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Masks masques(
    azimut=azimut,
    Av=Av,
    Ha=Ha,
    Lf=Lf,
    Hf=Hf,
    Dd=Dd,
    Dg=Dg,
    TypeMasque=TypeMasque,
    MasqueLointain=MasqueLointain,
    useEclairement=useEclairement,
    dE=dE,
    hpE=hpE) annotation (Placement(transformation(extent={{-6,-10},{28,10}})));
  Interfaces.SolarFluxOutput FluxMasques[3]
    "Solar irradiation for the surface considering the shading effects 1-Diffuse, 2- Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{60,-20},{100,20}}, rotation=0),
        iconTransformation(extent={{100,-12},{124,12}})));
Modelica.Blocks.Interfaces.RealInput G[10]
    "Inputs data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle}"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}},
        rotation=0), iconTransformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Natural incident illuminance -direct -diffuse -reflected [lumen]"     annotation (
      Placement(transformation(extent={{-120,-56},{-80,-16}}),
        iconTransformation(extent={{-100,-36},{-80,-16}})));
  Modelica.Blocks.Interfaces.RealOutput EclMasques[3] if useEclairement
    "Natural illuminance considering shading effects -direct -diffuse -reflected [lumen]"
    annotation (Placement(transformation(extent={{20,-56},{60,-16}}),
        iconTransformation(extent={{40,-36},{60,-16}})));

equation
  connect(fLUXsurf.FLUX, masques.FLUX) annotation (Line(
      points={{-39,-0.1},{-29.5,-0.1},{-29.5,0},{5.9,0}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf.AzHSol, masques.AzHSol) annotation (Line(
      points={{-39,8},{-30,8},{-30,5},{-4.81,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G, fLUXsurf.G) annotation (Line(
      points={{-100,10},{-80,10},{-80,0},{-61,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masques.FluxMasques, FluxMasques) annotation (Line(
      points={{30.04,0},{80,0}},
      color={255,192,1},
      smooth=Smooth.None));
  if useEclairement then
    connect(Ecl, masques.Ecl) annotation (Line(
        points={{-100,-36},{-20,-36},{-20,-5},{-4.81,-5}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(masques.EclMasques, EclMasques) annotation (Line(
        points={{24.09,-5},{30,-5},{30,-14},{12,-14},{12,-36},{40,-36}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;
  annotation (
    Documentation(info="<html>
<p><i><b>
Calculation of solar boundary conditions for the (Lf x Hf)-sized surface considering near and distant mask</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p> This model relies on the <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.SolarMasks.Masks\"><code>Masks</code></a> model to estimate effects of near and distant solar masks.</p>
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
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Benoît Charrier 05/2015 : adaptation du modèle pour l'intégration des masques lointains</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{30,34},{-70,34},{-70,-26},{30,-26},{30,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-70,-26},{-70,-26},{-80,-36},{-34,-26},{-70,-26}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,8},{30,-26}},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{30,34},{20,24},{20,-36},{30,-26},{30,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,34},{-80,24},{-80,-36},{-70,-26},{-70,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Polygon(
          points={{-70,34},{-80,24},{20,24},{30,34},{-70,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-70,-26},{20,24}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-48,14},{-2,-14}},
          fillColor={139,175,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,8},{-2,-14}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end FLUXsurfMask;
