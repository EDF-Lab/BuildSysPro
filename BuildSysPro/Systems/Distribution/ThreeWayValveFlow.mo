within BuildSysPro.Systems.Distribution;
model ThreeWayValveFlow

  parameter Modelica.Units.SI.MassFlowRate m_flow=0.01
    "Nominal flow rate";

  Modelica.Blocks.Interfaces.RealInput Port1[2]
    "Vector including 1-fluid temperature (K), 2-flow rate (kg/s)"                             annotation (
      Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput Port3[2]
   "Vector including 1-fluid temperature (K), 2-flow rate (kg/s)"                              annotation (
      Placement(transformation(extent={{100,-60},{80,-40}}),
        iconTransformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Interfaces.RealOutput Port2[2]
    "Vector including 1-fluid temperature (K), 2-flow rate (kg/s)"                            annotation (
      Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealOutput Port4[2]
   "Vector including 1-fluid temperature (K), 2-flow rate (kg/s)"                              annotation (
      Placement(transformation(extent={{-80,-60},{-100,-40}}),
        iconTransformation(extent={{-80,-80},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput x
    "Ratio of valve opening (entre 0 et 1)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,68}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,58})));

equation
  Port2[2] = (1-x)*m_flow;
  Port2[1] = Port1[1];

  Port4[2] = m_flow;
  Port4[1] = x*Port1[1] + (1-x)*Port3[1];

  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,60}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            60}}, preserveAspectRatio=true),
                                      graphics={
        Rectangle(
          extent={{-92,56},{92,-96}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,0},{-60,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-60,10},{-40,-10}},lineColor={0,0,255}),
        Line(
          points={{-56,8},{-44,-8}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-56,-8},{-44,8}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{0,0},{-20,10}},
          lineColor={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{0,0},{-8,-20},{10,-20},{0,0}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,0},{-20,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{80,-70},{-82,-70},{-80,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{20,0},{80,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{0,-20},{0,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{0,60},{20,40}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="x"),
        Text(
          extent={{18,20},{52,0}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="1-x",
          textStyle={TextStyle.Italic}),
        Text(
          extent={{0,-20},{20,-40}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="x",
          textStyle={TextStyle.Italic}),
        Line(
          points={{-4,-66},{-4,-24}},
          color={0,0,0},
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.None}),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={10,0},
          rotation=180)}),
    Documentation(revisions="<html>
<p>Hubert Blervaque 02/2013 : Première implémentation.</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>",
      info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic flow control model for a secondary hydraulic circuit including a pump.</p>
<p><u><b>Bibliography</b></u></p>
<p>none </p>
<p><u><b>Instructions for use</b></u></p>
<p>The input x, between 0 and 1, diverts the flow via 3-way velva. When x is greater than 0.5, it means that the secondary circuit emits too much heat and therefore the sound flow must bereduced. x:=1: no flow in the secondary circuit, everything is redirected to the secondary circuit. x=0: all the flow fixed to the pump is sent to the secondary circuit.</p>
<p>The pump is an all or nothing system which stops when there is no need in the secondary circuit (when x=1.)</p> 
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>"));
end ThreeWayValveFlow;
