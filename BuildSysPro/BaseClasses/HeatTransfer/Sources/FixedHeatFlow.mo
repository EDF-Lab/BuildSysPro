within BuildSysPro.BaseClasses.HeatTransfer.Sources;
model FixedHeatFlow "Fixed heat flow boundary condition"
  parameter Modelica.SIunits.HeatFlowRate Q_flow "Fixed heat flow rate at port";
  parameter Modelica.SIunits.Temperature T_ref=293.15 "Reference temperature";
  parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of heat flow rate";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
                             annotation (Placement(transformation(
          extent={{100,0},{120,20}}, rotation=0)));
equation
  port.Q_flow = -Q_flow*(1 + alpha*(port.T - T_ref));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(extent={{-124,130},{142,70}}, textString="%name"),
        Text(
          extent={{-127,-42},{143,-90}},
          lineColor={0,0,0},
          textString="Q_flow=%Q_flow"),
        Line(
          points={{-90,-10},{58,-10}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-90,30},{56,30}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{50,10},{50,50},{80,30},{50,10}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,-30},{50,10},{80,-10},{50,-30}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{80,50},{100,-30}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows a specified amount of heat flow rate to be &quot;injected&quot; into a thermal system at a given port. The constant amount of heat flow rate Q_flow is given as a parameter. The heat flows into the component to which the component FixedHeatFlow is connected, if parameter Q_flow is positive.</p>
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
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">FixedHeatFlow</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end FixedHeatFlow;
