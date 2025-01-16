within BuildSysPro.Utilities.Time;
function ApparentSolarTimeToUniversalTime
  "Calculation of Universal Time (UT in hours) according to solar time RST"

input Real t0=0 "Time in seconds at t=0";
// input Real d0 "Number of the day in the month at t=0"; // deleted
  input Modelica.Units.SI.Time t "Elapsed time since t=0 [s]";

  input Modelica.Units.NonSI.Angle_deg long "Longitude, in degrees [°]";
  output Modelica.Units.NonSI.Time_hour tu "Universal Time, in hours [h]";

protected
          constant Real omega=2*Modelica.Constants.pi/365.25;

algorithm
  tu :=t/3600 - long/15 +
    BuildSysPro.BoundaryConditions.Solar.Utilities.TimeEquation(t0=t0, t=t);

  annotation (
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Aurélie Kaemmerlen 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Aurélie KEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Hassan Bouia 03/2013 - Modification des fonctions temps et remplacement de d0 par t0</p>
</html>"));
end ApparentSolarTimeToUniversalTime;
