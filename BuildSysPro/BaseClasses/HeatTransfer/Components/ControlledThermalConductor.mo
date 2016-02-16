within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ControlledThermalConductor
  "Résistance thermique dont la valeur est commandée - Lumped thermal element transporting heat without storing it"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;

  Modelica.Blocks.Interfaces.RealInput G annotation (Placement(
        transformation(extent={{-40,52},{0,92}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,80})));
equation
  Q_flow = G*dT;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-74,-68},{80,-88}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),           Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),            graphics),
    Documentation(info="<html>
<p>This is a model for transport of heat without storing it. It may be used for complicated geometries where the thermal conductance G (= inverse of thermal resistance) is determined by measurements and is assumed to be constant over the range of operations. If the component consists mainly of one type of material and a regular geometry, it may be calculated, e.g., with one of the following equations: </p>
<ul>
<li>Conductance for a <b>box</b> geometry under the assumption that heat flows along the box length: </li>
<pre>    G = k*A/L
    k: Thermal conductivity (material constant)
    A: Area of box
    L: Length of box
<li>Conductance for a <b>cylindrical</b> geometry under the assumption that heat flows from the inside to the outside radius of the cylinder: </li>
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
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.ThermalConductor\">ThermalConductor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end ControlledThermalConductor;
