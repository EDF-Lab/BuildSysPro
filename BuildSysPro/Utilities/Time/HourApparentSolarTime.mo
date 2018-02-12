within BuildSysPro.Utilities.Time;
function HourApparentSolarTime "True Solar Time between 0 and 24"

  input Modelica.SIunits.Conversions.NonSIunits.Time_hour h0
    "Universal Time (in hours) at t=0";
  input Real t0=0 "Time in second at t=0";
  //Real d0 "Number of the day at t=0"; // replaced by t0
  input Modelica.SIunits.Time t "Elapsed time since t=0 [s]";

input Modelica.SIunits.Conversions.NonSIunits.Angle_deg long
    "Longitude, in degrees [°]";
output Modelica.SIunits.Conversions.NonSIunits.Time_hour tsv
    "True Solar Time, in hours [h]";

protected
          constant Real omega=2*Modelica.Constants.pi/365.25;

algorithm
  tsv :=BuildSysPro.Utilities.Time.UniversalTime(t0=t0, t=t) + long/15 -
    BuildSysPro.BoundaryConditions.Solar.Utilities.TimeEquation(t0=t0, t=t);

  tsv := mod(tsv,24);

  annotation (
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Calculates the time of the day in Real Solar Time (RST)</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Aurélie Kaemmerlen 05/2011- Modification du calcul pour avoir un TSV compris entre 0 et 24h</p>
<p>Hassan Bouia 03/2013 - Modification des fonctions temps et remplacement de d0 par t0</p>
</html>"));
end HourApparentSolarTime;
