within BuildSysPro.BaseClasses.HeatTransfer.Sources;
model PrescribedHeatFlow "Prescribed heat flow boundary condition"
  parameter Modelica.Units.SI.Temperature T_ref=293.15 "Reference temperature";
  parameter Modelica.Units.SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of heat flow rate";

  Modelica.Blocks.Interfaces.RealInput Q_flow
        annotation (Placement(transformation(
        origin={-90,-14},
        extent={{20,-20},{-20,20}},
        rotation=180), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,0})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port
                             annotation (Placement(transformation(
          extent={{90,-10},{110,10}},  rotation=0), iconTransformation(extent={{90,-10},
            {110,10}})));
equation
  port.Q_flow = -Q_flow*(1 + alpha*(port.T - T_ref));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{-60,-20},{40,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(points={{-60,20},{40,20}},
                                      color={191,0,0}),
        Line(
          points={{-80,0},{-60,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-80,0},{-60,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{40,0},{40,40},{70,20},{40,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{40,0},{70,-20},{40,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,40},{90,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(extent={{-140,110},{140,50}}, textString="%name")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows a specified amount of heat flow rate to be &quot;injected&quot; into a thermal system at a given port. The amount of heat is given by the input signal Q_flow into the model. The heat flows into the component to which the component PrescribedHeatFlow is connected, if the input signal is positive.</p>
<p>If parameter alpha is &gt; 0, the heat flow is mulitplied by (1 + alpha*(port.T - T_ref)) in order to simulate temperature dependent losses (which are given an reference temperature T_ref).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">PrescribedHeatFlow</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Mathias Bouquerel 12/2016 : remplacement du port thermique Modelica par le port thermique BuildSysPro</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
end PrescribedHeatFlow;
