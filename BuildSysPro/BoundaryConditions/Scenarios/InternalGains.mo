within BuildSysPro.BoundaryConditions.Scenarios;
model InternalGains "Fixed internal heat gains"

parameter Modelica.SIunits.Power Pint=200 "Internal heat gains";

  Modelica.Blocks.Sources.Constant ConsignePint(k=Pint)
    "Time-invariant internal heat gains"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          extent={{80,-10},{100,10}}), iconTransformation(extent={{80,-10},{100,
            10}})));
equation
  connect(ConsignePint.y, y) annotation (Line(
      points={{-19,0},{90,0}},
      smooth=Smooth.None,
      color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{12,0},{90,0}},  color={0,0,255}),
        Line(points={{-90,0},{-12,0}},  color={191,0,0}),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},
              {12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Text(
          extent={{-110,134},{112,96}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p><i><b>Fixed internal heat gains </b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>ideal internal heat gains from various sources (eg. occupancy, lighting).</p>
<p><u><b>Bibliography</b></u></p>
<p>IEA BESTEST procedure.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (BESTEST) - Aurélie Kaemmerlen 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>
"));
end InternalGains;
