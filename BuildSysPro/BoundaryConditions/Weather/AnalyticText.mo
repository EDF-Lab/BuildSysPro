within BuildSysPro.BoundaryConditions.Weather;
model AnalyticText "External temperature scenario"

  Modelica.Blocks.Interfaces.RealOutput Text "Analytic external temperature" annotation (Placement(
        transformation(extent={{0,40},{20,60}}), iconTransformation(extent={{0,
            40},{20,60}})));

parameter Real Htmax=14 "Hour of maximum temperature [h]";
parameter Real midi=12 "Hour of solar noon [h]";
parameter Real Tmin=15 "Minimum temperature [°C]";
parameter Real Tmax=30 "Maximum temperature [°C]";
parameter Real DureeJour = 10 "Day duration [h]";

protected
Real t "Current time [h] and equal to 0 at solar noon";
parameter Real t0 = 0.5*DureeJour "Time of sunset, with the convention on t";

equation
t=  time/3600 - midi;
Text=  Tmax + (Tmin-Tmax)*( cos(Modelica.Constants.pi*(t-Htmax+midi)/(2*t0)) - 1)  / ( cos(Modelica.Constants.pi*(t0+Htmax+midi)/(2*t0)) - 1);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-52,42},{-28,-66}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,-96},{-20,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,42},{-52,82},{-50,88},{-46,90},{-40,92},{-34,90},
              {-30,88},{-28,82},{-28,42},{-52,42}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-52,42},{-28,-66}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-28,42},{-28,-62}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-52,40},{-52,-64}},
          color={0,0,0},
          thickness=0.5),
        Text(
          extent={{-40,12},{46,-24}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.CrossDiag,
          textString="Analytic
external
temperature")}),
Documentation(info="<html>
<p><i><b>Analytic profil for external temperature</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>See reference.</p>
<p><u><b>Bibliography</b></u></p>
<p>S. KRAUTER, Betriebsmodell der optischen, thermischen und elektrischen Parameter von photovoltaischen Modulen, édition Koester Verlag, 1993.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Emmanuel AMY DE LA BRETEQUE 07/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Emmanuel AMY DE LA BRETEQUE, EDF 07/2010<br>
--------------------------------------------------------------</b></p>
</html>
"));
end AnalyticText;
