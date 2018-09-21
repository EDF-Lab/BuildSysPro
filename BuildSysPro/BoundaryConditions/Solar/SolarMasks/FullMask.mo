within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
function FullMask
  "Calculation of the sunny area for the full mask (horizontal+vertical)"

input Modelica.SIunits.Distance Av "Overhang";
input Modelica.SIunits.Distance Ha
    "Distance between the overhang and the top of the surface (window)";
input Modelica.SIunits.Distance Lf "Surface (window) width";
input Modelica.SIunits.Distance Hf "Surface (window) height";
input Modelica.SIunits.Distance Dd "Lateral overhang (right hand side)";
input Modelica.SIunits.Distance Dg "Lateral overhang (left hand side)";
input Modelica.SIunits.Conversions.NonSIunits.Angle_deg AzimutSoleil
    "Solar azimuth angle (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°";
input Modelica.SIunits.Conversions.NonSIunits.Angle_deg HauteurSoleil
    "Solar elevation angle";
input Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Surface tilt - downwards = 180° skyward = 0°, vertical = 90°";

output Modelica.SIunits.Area A0 "Sunny surface of the window";

protected
Modelica.SIunits.Distance X0 "Intermediate variable for the calculation of A0";
Modelica.SIunits.Distance  Y0 "Intermediate variable for the calculation of A0";
constant Real Convert=Modelica.Constants.pi/180
    "Conversion factor degrees->radians";

algorithm
  //Calculation of Y0
  Y0 := Av * tan(HauteurSoleil*Convert)/cos((azimut-AzimutSoleil)*Convert);
  if Y0 <= Ha then
    Y0 := Ha;
  end if;
  if Y0 >= Ha+Hf then
    Y0 := Ha+Hf;
  end if;

  //Calculation of X0
  if AzimutSoleil<=azimut then
    X0 :=Av * tan((azimut-AzimutSoleil)*Convert);
    if X0 <= Dg then
      X0 := Dg;
    end if;
    if X0 >= Dg + Lf then
      X0 := Dg + Lf;
    end if;
    A0 := (Lf+Dg-X0)*(Ha+Hf-Y0);
  else
    X0 :=Av * tan((AzimutSoleil-azimut)*Convert);
    if X0 <= Dd then
      X0 := Dd;
    end if;
    if X0 >= Dd + Lf then
      X0 := Dd + Lf;
    end if;
    A0 := (Lf+Dd-X0)*(Ha+Hf-Y0);
  end if;

  annotation (Documentation(info="<html>
<p><i><b>
Calculation of the sunny share of a surface considering shading devices</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
Shading devices (near mask) with both overhang and lateral fin (such as egg crate) are considered. See diagram below:
<p><img src=\"modelica://BuildSysPro/Resources/Images/MasqueIntegral.bmp\"/> </p>
<p><u><b>Bibliography</b></u></p>
<p>ISO 13791 standard</p>
<p>RT2012 standard for the consideration of vertical distant masks</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>These models are valid only for vertical walls.</p>
<p>The accumulation of several masks of near types for a same wall is prohibited</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (according to the standard ISO13791-2004) - Aurélie Kaemmerlen 05/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>

"));
end FullMask;
