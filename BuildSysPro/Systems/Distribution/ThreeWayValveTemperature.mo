within BuildSysPro.Systems.Distribution;
model ThreeWayValveTemperature

 parameter Modelica.SIunits.MassFlowRate m_flow=0.01
    "Nominal flow rate of the pump";

  Modelica.Blocks.Interfaces.RealInput Port1[2]
    "Circuit input 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput Port3[2]
    "Circuit input 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{100,-60},{80,-40}}),
        iconTransformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Interfaces.RealOutput Port2[2]
    "Circuit output 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealOutput Port4[2]
    "Circuit output 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-80,-60},{-100,-40}}),
        iconTransformation(extent={{-80,-80},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput x
    "Opening ratio of the valve (between 0 and 1)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,70}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,58})));

equation
  Port2[2]=m_flow;
  Port2[1]=x*Port1[1]+(1-x)*Port3[1];

  Port4[2]=x*m_flow;
  Port4[1]=Port3[1];

  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,60}}),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            60}}, preserveAspectRatio=true),
                                      graphics={
        Rectangle(
          extent={{-92,56},{92,-96}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{20,0},{40,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{40,10},{60,-10}},  lineColor={0,0,255}),
        Line(
          points={{44,8},{56,-8}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{44,-8},{56,8}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{0,0},{-8,-20},{10,-20},{0,0}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{60,0},{80,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{80,-70},{-82,-70},{-80,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{-20,0}},
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
          extent={{-4,-20},{36,-40}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="1-x",
          textStyle={TextStyle.Italic}),
        Text(
          extent={{-40,20},{-20,0}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="x",
          textStyle={TextStyle.Italic}),
        Line(
          points={{-4,-24},{-4,-66}},
          color={0,0,0},
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.None}),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-10,0},
          rotation=360),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          origin={10,0},
          rotation=180)}),
    Documentation(revisions="<html>
<p>Hubert Blervaque 02/2013 : Première implémentation.</p>
<p>Hubert Blervaque 09/2013 : Modification de l'affection de &QUOT;x&QUOT; au débit provenant du circuit praimaire pour faciliter les assemblages de régulation (plus on a besoin de chaleur, plus x augmente).</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T & m_flow.</p>
</html>",
      info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic model of temperature control of a secondary hyraulic circuit including a pump. Input x is included between 0 and 1, orient thle fluid flow with a three way valve.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 01/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hubert BLERVAQUE, EDF (2013)<br>
--------------------------------------------------------------</b></p></html>"));
end ThreeWayValveTemperature;
