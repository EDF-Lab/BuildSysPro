within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ExtConvection
  "Convective heat exchange coefficient taking into account the wind"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
parameter Real a;
parameter Real n;
parameter Real b;
parameter Modelica.SIunits.Area S;

  Modelica.Blocks.Interfaces.RealInput v "Wind speed [m/s]"
                                         annotation (Placement(transformation(
          extent={{-110,26},{-70,66}}), iconTransformation(extent={{-120,20},{
            -80,60}})));
equation
  Q_flow = (a*v^n+b)*dT*S;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic correlation of the convective heat exchange coefficient depending on the wind speed :</p>
<p><code>hcv = a * v<sup>n</sup> + b</code></p>
<p><u><b>Bibliography</b></u></p>
<p>See notice TF112 of CLIM2000 for examples from the bibliography.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EAB 04/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end ExtConvection;
