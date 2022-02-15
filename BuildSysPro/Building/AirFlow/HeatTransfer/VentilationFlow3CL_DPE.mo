within BuildSysPro.Building.AirFlow.HeatTransfer;
model VentilationFlow3CL_DPE
  "Ventilation model with default values from 3CL DPE v1.3 method"

  replaceable parameter Ventilation3CL_DPE.GenericVentilationDPE Ventilation
    "Ventilation system"
    annotation (choicesAllMatching=true, Dialog(group="Ventilation"));

  replaceable parameter Permea3CL_DPE.GenericPermeaDPE Permea "Permeability"
    annotation (choicesAllMatching=true, Dialog(group="Permeability"));

  parameter Modelica.Units.SI.Area Shab "Living space"
    annotation (Dialog(group="Housing description"));
  parameter Modelica.Units.SI.Area Sdep
    "Total surface of walls with heat losses (floor excluded)"
    annotation (Dialog(group="Housing description"));

Real Qv4Pa "Total air change in m3/h";
Real QvInfiltration "Air change due to the air permeability of the building in m3/h";
Real QvVentilation "Air change due to the ventilation system in m3/h";

Modelica.Blocks.Interfaces.RealInput                               Text
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
Modelica.Blocks.Interfaces.RealInput                               Tint
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(extent={{100,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealOutput QvRenouvAir
    "Total air change in m3/h" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-80}), iconTransformation(extent={{80,-90},{100,-70}})));

equation
Qv4Pa = Permea.I4Pa*Sdep+0.45*Ventilation.SmeaConv*Shab;
QvInfiltration = 0.0146*Qv4Pa*(0.7*abs(Tint-Text))^(0.667);
QvVentilation = Ventilation.QvarepConv*Shab;
QvRenouvAir = QvInfiltration+QvVentilation;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Ellipse(extent={{-42,96},{-14,68}}, lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-28,112},
          rotation=360),
        Ellipse(
          extent={{-30,84},{-26,80}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-66,26},
          rotation=180),
        Line(
          points={{-44,92},{-28,100},{-14,92}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-14,94},{-12,90},{-16,92},{-14,94}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,-2},{-56,6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,22},{-58,4}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,22},{-62,42},{-62,44},{-60,46},{-60,46},{-58,44},{-58,42},
              {-58,42},{-58,22},{-62,22}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-62,23},{-62,5}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-58,22},{-58,5}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-68,34},{-62,34}}, color={0,0,0}),
        Line(points={{-68,20},{-62,20}}, color={0,0,0}),
        Line(points={{-68,10},{-62,10}},   color={0,0,0}),
        Ellipse(
          extent={{56,-4},{64,4}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,20},{62,2}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{58,20},{58,40},{58,42},{60,44},{60,44},{62,42},{62,40},{62,
              40},{62,20},{58,20}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{58,21},{58,3}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{62,20},{62,3}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{52,32},{58,32}},   color={0,0,0}),
        Line(points={{52,18},{58,18}},   color={0,0,0}),
        Line(points={{52,8},{58,8}},       color={0,0,0}),
        Rectangle(
          extent={{-40,40},{-20,-100}},
          lineColor={0,0,0},
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,40},{0,80},{20,80},{-20,40},{-40,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,40},{20,80},{20,-60},{-20,-100},{-20,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,12},{12,34},{12,-12},{-10,-38},{-10,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-8,10},{10,28},{10,-10},{-8,-32},{-8,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-10,12},{-4,8}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{0,22},{6,18}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-4,18},{2,14}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{6,26},{12,22}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-10,4},{-4,0}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-10,-2},{-4,-6}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-10,-16},{-4,-20}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-10,-12},{-4,-16}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-8,-26},{-2,-30}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-8,-34},{-2,-38}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{0,-26},{6,-30}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{6,-16},{12,-20}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{10,-6},{16,-10}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{10,4},{16,0}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{10,14},{16,10}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{10,24},{16,20}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-58,82},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-28,52},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={2,82},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-43,72},
          rotation=90)}),
    Documentation(info="<html>
<p>Ventilation model for residential buildings from the DPE method (April 2013 decree) - French regulatory method for building energy performance diagnosis</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>In the DPE model, infiltration calculation only takes into account the effect of thermal draft and neglects the effect of wind.</p>
<p>The DPE performs an average calculation with an indoor temperature of 19&deg;C and an average outdoor temperature for the 3 climate zones. This model lets the deltaT vary throughout the simulatio.</p>
<p><br>QvRenouvAir = QvInfiltration + QvVentilation</p>
<p>QvRenouvAir : total air change (m3/h)</p>
<p>QvInfiltration : air change due to the air permeability of the building (caused by thermal draft, the impact of the wind is being neglected)</p>
<p>QvVentilation : air change due to the ventilation system</p>
<p><br>QvVentilation = QvarepConv*Shab</p>
<p>QvarepConv : conventional air change per unit of living space (m3/h/m&sup2;) (depends on the ventilation system)</p>
<p>Shab : living space area (m&sup2;)</p>
<p><br><b><img src=\"modelica://BuildSysPro/Resources/Images/equations/debitVentilation3CL_DPE.png\" alt=\"QvInfiltration=0.0146*Qv4Pa*(0.7*abs(Tint-Text))^0.667\"/></b></p>
<p>Qv4Pa : permeability of the zone at 4 Pa (m3/h)</p>
<p>Qv4Pa = Qv4Pa_env + 0.45 * Smea_conv * Shab</p>
<p>Qv4Pa_env : permeability of building envelope (m3/h)</p>
<p>Smea_conv : conventional value of the sum of air inlet modules at 20 Pa per unit of living area (m3/h/m&sup2;)</p>
<p>Qv4Pa_env = I4Pa * Sdep</p>
<p>I4Pa : conventional value of permeability at 4 Pa (m3/h)</p>
<p>Sdep : Total surface of walls with heat losses (floor excluded)</p>
<p><br><u><b>Bibliography</b></u></p>
<p>Annex 1 - 3CL-DPE v1.3 method</p>
<p><u><b>Instructions for use</b></u></p>
<p>Venting systems and infiltration configurations can be selected through drop-down menus.</p>
<p>Extracted airflow, air inlet modules, and I4Pa values ​​can also be changed manually.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Vincent MAGNAUDEIX 04/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Vincent MAGNAUDEIX, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end VentilationFlow3CL_DPE;
