within BuildSysPro.Systems.Solar.Thermal;
model SolarThermalCollector

parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg Azimut=0
    "Surface azimuth (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°"             annotation (Dialog(group="Orientation of the solar collector"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg Inclinaison=30
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°"
                                                                                                        annotation (Dialog(group="Orientation of the solar collector"));
                                                                                                      parameter Real Albedo=0.2
    "Albedo of the environment"                                                                                                     annotation (Dialog(group="Orientation of the solar collector"));
parameter Modelica.SIunits.Area Surface= 1 "Surface of the solar collector"
                                                                annotation (Dialog(group="Characteristics of the solar collector"));
parameter Real FacteurOptique(min=0, max=1)=0.65
    "Optical factor (generally between 0,5 and 0,9)"                                annotation (Dialog(group="Characteristics of the solar collector"));
parameter Real CoeffTransmission=4
    "Transmission coefficient, depends on insulation and nature of the coverage."                       annotation (Dialog(group="Characteristics of the solar collector"));

Real Psol;
Real Pisolation;

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurfLWRinc fLUXsurfGLOH(
    azimut=Azimut,
    incl=Inclinaison,
    albedo=Albedo)
    annotation (Placement(transformation(extent={{-18,60},{2,80}})));
  Modelica.Blocks.Interfaces.RealInput MeteoFlux[10]
    "Solar data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle , Solar elevation angle}"
                                                annotation (Placement(
        transformation(extent={{-120,50},{-80,90}}), iconTransformation(extent={{-70,38},
            {-50,58}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a MeteoTseche(Q_flow=0)
    annotation (Placement(transformation(extent={{-70,64},{-50,84}}),
        iconTransformation(extent={{-70,64},{-50,84}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b ChaleurRecuperee
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
equation
    Psol = Surface * FacteurOptique * fLUXsurfGLOH.FLUX;
    Pisolation = Surface * ( CoeffTransmission * (ChaleurRecuperee.T-MeteoTseche.T));
  ChaleurRecuperee.Q_flow = max(0,Surface * (FacteurOptique * fLUXsurfGLOH.FLUX - CoeffTransmission * (ChaleurRecuperee.T-MeteoTseche.T)));

  connect(MeteoFlux, fLUXsurfGLOH.G) annotation (Line(
      points={{-100,70},{-19,70}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Polygon(
          points={{-60,-80},{20,60},{100,60},{20,-100},{-60,-80}},
          smooth=Smooth.None,
          fillColor={44,44,44},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Ellipse(
          extent={{-100,100},{-20,20}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,42},{-6,30},{-8,28},{-2,30},{-4,34},{-4,32},{-26,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-16,60},{4,48},{2,46},{8,48},{6,52},{6,50},{-16,60}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-36,24},{-16,12},{-18,10},{-12,12},{-14,16},{-14,14},{-36,
              24}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,10},{-24,-2},{-26,-4},{-20,-2},{-22,2},{-22,0},{-44,10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}), Diagram(graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Sila Filfli 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Hubert Blervaque - 07/2012 : Modification du signe de la chaleur récupérée</p>
</html>"));
end SolarThermalCollector;
