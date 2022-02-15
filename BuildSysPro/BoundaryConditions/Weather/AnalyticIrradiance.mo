within BuildSysPro.BoundaryConditions.Weather;
model AnalyticIrradiance "Irradiance scenario"

  Modelica.Blocks.Interfaces.RealOutput G
    "Global irradiance on south facing surface"                                   annotation (Placement(transformation(
          extent={{76,40},{96,60}}), iconTransformation(extent={{80,40},{100,60}})));

parameter Real midi=12 "Hour of solar noon [h]";
parameter Real DureeJour=10 "Day duration [h]";
parameter Real H=5000 "Solar energy over the day [Wh/m²]";
parameter Real Gmax=1000 "Maximum irradiance (at solar noon)";

protected
  Real t "Current time [h] and equal to 0 at solar noon";
parameter Real t0 = 0.5*DureeJour "Time of sunset, with the convention on t";
parameter Real s=(Modelica.Constants.pi*H/(4*t0*Gmax)-1)/(1-Modelica.Constants.pi/4);

equation
t= mod(time/3600,24)- midi;
G=  if t>-t0 and t<t0 then max(0,Gmax*cos(Modelica.Constants.pi*t/(2*t0)) * (1 + s*(1-cos(Modelica.Constants.pi*t/(2*t0))))) else
                                                                                              0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Ellipse(
          extent={{-80,86},{80,-84}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.CrossDiag), Text(
          extent={{-66,36},{70,-20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.CrossDiag,
          textString="Analytic irradiance")}),
    Documentation(info="<html>
<p><i><b>Analytic expression for daily solar profiles</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Analytic expression for daily solar profiles (irradiance in [W/m²]) on a south-facing surface.</p>
<p>This expression is obtained by developing the function which represents the irradiance in Fourier series, considering it periodic with a period of 2*day. This method is equivalent to the standard EN 61725.</p>
<p><u><b>Bibliography</b></u></p>
<p>EN 61725</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Emmanuel Amy DE LA BRETEQUE 07/2010.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author :  Emmanuel Amy DE LA BRETEQUE, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>
", revisions="<html>
Gilles PLESSIS: modification to periodic function.
</html>"));
end AnalyticIrradiance;
