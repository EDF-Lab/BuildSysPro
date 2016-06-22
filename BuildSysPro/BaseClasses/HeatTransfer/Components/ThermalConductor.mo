within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ThermalConductor
  "Lumped thermal element transporting heat without storing it"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
  parameter Modelica.SIunits.ThermalConductance G
    "Constant thermal conductance of material";

equation
  Q_flow = G*dT;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag), Text(
          extent={{-105,-66},{123,-106}},
          lineColor={0,0,0},
          textString="G=%G W/K")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-64,32},{66,18}},
          lineColor={0,0,0},
          textString="dT = port_a.T - port_b.T"),
        Line(
          points={{-60,0},{60,0}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-34,-8},{32,-26}},
          lineColor={255,0,0},
          textString="Q_flow")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is a model for transport of heat without storing it. It may be used for complicated geometries where the thermal conductance G (= inverse of thermal resistance) is determined by measurements and is assumed to be constant over the range of operations. If the component consists mainly of one type of material and a regular geometry, it may be calculated, e.g., with one of the following equations: </p>
<ul>
<li>Conductance for a <b>box</b> geometry under the assumption that heat flows along the box length:</li>
<pre>    G = k*A/L
    k: Thermal conductivity (material constant)
    A: Area of box
    L: Length of box
<li>Conductance for a <b>cylindrical</b> geometry under the assumption that heat flows from the inside to the outside radius of the cylinder:</li>
<pre>    G = 2*pi*k*L/log(r_out/r_in)
    pi   : Modelica.Constants.pi
    k    : Thermal conductivity (material constant)
    L    : Length of cylinder
    log  : Modelica.Math.log;
    r_out: Outer radius of cylinder
    r_in : Inner radius of cylinder</ul>
<p><pre>Typical values for k at 20 degC in W/(m.K):
      aluminium   220
      concrete      1
      copper      384
      iron         74
      silver      407
      steel        45 .. 15 (V2A)
      wood         0.1 ... 0.2</pre></p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.ThermalConductor\">ThermalConductor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end ThermalConductor;
