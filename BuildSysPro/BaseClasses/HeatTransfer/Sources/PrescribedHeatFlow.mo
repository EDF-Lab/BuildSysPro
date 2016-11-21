within BuildSysPro.BaseClasses.HeatTransfer.Sources;
model PrescribedHeatFlow "Prescribed heat flow boundary condition"
  parameter Modelica.SIunits.Temperature T_ref=293.15 "Reference temperature";
  parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of heat flow rate";

  Modelica.Blocks.Interfaces.RealInput Q_flow
        annotation (Placement(transformation(
        origin={-90,-14},
        extent={{20,-20},{-20,20}},
        rotation=180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
                             annotation (Placement(transformation(
          extent={{100,-24},{120,-4}}, rotation=0)));
equation
  port.Q_flow = -Q_flow*(1 + alpha*(port.T - T_ref));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{-50,-34},{50,-34}},
          color={191,0,0},
          thickness=0.5),
        Line(points={{-50,6},{50,6}}, color={191,0,0}),
        Line(
          points={{-70,-14},{-50,-34}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-70,-14},{-50,6}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{50,-14},{50,26},{80,6},{50,-14}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,-54},{50,-14},{80,-34},{50,-54}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{80,26},{100,-54}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(extent={{-124,106},{142,46}}, textString="%name")}),
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
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">PrescribedHeatFlow</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
end PrescribedHeatFlow;
