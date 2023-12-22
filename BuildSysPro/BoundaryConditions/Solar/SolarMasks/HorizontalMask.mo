within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
function HorizontalMask
  "Calculation of the sunny area for an horizontal shading device"

  input Modelica.Units.SI.Distance Av "Overhang";
  input Modelica.Units.SI.Distance Ha
    "Distance between the overhang and the top of the surface (window)";
  input Modelica.Units.SI.Distance Lf "Surface (window) width";
  input Modelica.Units.SI.Distance Hf "Surface (window) height";
  input Modelica.Units.SI.Distance Dd "Lateral overhang (right hand side)";
  input Modelica.Units.SI.Distance Dg "Lateral overhang (left hand side)";
  input Modelica.Units.NonSI.Angle_deg AzimutSoleil
    "Solar azimuth angle (orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°";
  input Modelica.Units.NonSI.Angle_deg HauteurSoleil "Solar elevation angle";
  input Modelica.Units.NonSI.Angle_deg azimut
    "Surface tilt - downwards = 180° skyward = 0°, vertical = 90°";
  output Modelica.Units.SI.Area Asol "Sunny surface of the window";

protected
Integer Cas
    "Number of the shading shape - see ISO 13791 standard - For validations";
  Modelica.Units.SI.Area A0 "Shadow surface on the window";
constant Real Convert=Modelica.Constants.pi/180
    "Conversion factor degrees->radians";
  Modelica.Units.NonSI.Angle_deg Phi "Sun azimuth - Surface azimuth";
Boolean DebordGauche
    "=true if the sun comes through the left overhang, false otherwise";
  Modelica.Units.SI.Distance T "Shadow depth";
  Modelica.Units.SI.Distance M "Shadow offset";
  Modelica.Units.SI.Distance X0
    "X coordinates of the horizontal mask corner projection on the wall";
  Modelica.Units.SI.Distance Y0
    "Y coordinates of the horizontal mask corner projection on the wall";
    Boolean Inclus "=true if the point belongs to the surface";
    Real Xdeb "Overhang X coordinates";
    Real Ydeb "Overhang Y coordinates";
    Boolean continue=true "True while the good case is not found";
Real b;

// Intersections with the vertical and horizontal edges
Real Yi0;
Real YiL;
Real Xi0;
Real XiH;
Real X2iH
    "Intermediate Size - intersection of the other overhang for case 1 discrimination";

algorithm
   Phi := AzimutSoleil-azimut; //Beware if Phi = 0 => M=0 => shape of the shadow determined according to the value of T
   DebordGauche := if (Phi < 0) then true else false;
   T := Av * tan(HauteurSoleil*Convert)/cos(Phi*Convert);
   M := Av * tan(Phi*Convert);

// First cases determined if Phi = 0
if (not (M<>0)) then
  continue := false;
  // Particular cases 1,2 or 3
  if (T >= Ha+Hf) then
    Cas := 2;
  elseif (T <= Ha) then
    Cas := 1;
  else
    Cas := 3;
  end if;
end if;

//Cases determined through the knowledge of the horizontal mask corner projection coordinates in the direction of light rays
if DebordGauche==true then
  b := Dg;
  Xdeb := Lf +Dg;
else
  b := Dd;
  Xdeb:= -Dd;
end if;
Ydeb := Ha + Hf;
X0 := Xdeb + M;
Y0 := Ydeb - T;

if (continue == true) then
  //Calculation of the coordinates (X,Y) of the intersection between the incident ray from (Xdeb,Ydeb) and the edges of the window
  //Calculation of Y coordinates of the intersection with the window edge x=0
  Yi0 :=Ydeb+T*Xdeb/M;
  // Calculation of Y coordinates of the intersection with the window edge x=Lf
  YiL :=Ydeb+(T/M)*(Xdeb-Lf);
  // Calculation of X coordinates of the intersection with the window edge y=0
  Xi0 :=Xdeb+M*Ydeb/T;
  // Calculation of X coordinates of the intersection with the window edge y=Hf
  XiH :=Xdeb+(M/T)*Ha;

  // Cases 4 &amp; 7 depending if 0 belongs to the glazing or not
    Inclus :=BuildSysPro.BoundaryConditions.Solar.SolarMasks.PointOnSurface(
      Lf=Lf,
      Hf=Hf,
      X0=X0,
      Y0=Y0);

  if (Inclus == true) then
    continue := false;
    // Case 4 or 7
    if ((XiH>=0) and (XiH<=Lf)) then
      Cas := 4;
    else
      Cas := 7;
    end if;
  end if;
end if;

// Case 1 discrimination
if (continue == true) then
   X2iH := if DebordGauche then (M/T)*Ha-Dd else (M/T)*Ha+Dg+Lf;
   if ((T<=Ha) or ((not DebordGauche) and X2iH >=Lf and XiH >=Lf) or (DebordGauche and X2iH <=0 and XiH <=0)) then
     continue := false;
     Cas := 1;
   end if;
end if;

// Cases 2,3,5,6,8,9
if (continue == true) then
  if (XiH >=0 and XiH <=Lf) then
    //Case 5 or 6
    if (Xi0 >=0 and Xi0 <=Lf) then
      Cas := 5;
    else
      Cas := 6;
    end if;
  else
    //Cases 2,3,8,9
    if (Yi0 >=0 and Yi0 <=Hf) and (YiL >=0 and YiL <=Hf) and ((DebordGauche and X0<=0) or ((not DebordGauche) and X0 >=Lf)) then
      Cas := 9;
    else
      //Cases 2,3,8
      if (Y0 >=0 and Y0 <=Hf) then
        Cas := 3;
      else
        if (Xi0 >=0 and Xi0 <=Lf) then
          Cas := 8;
        else
          Cas := 2;
        end if;
      end if;
    end if;
  end if;
end if;

////// Calculation of shadow area (A0) and sunny area (Asol)
M := abs(M); // For following areas formulas the absolute value of M is taken
if Cas == 1 then
  A0 := 0;
elseif Cas == 2 then
  A0 := Hf*Lf;
elseif Cas == 3 then
  A0 := Lf*(T-Ha);
elseif Cas == 4 then
  A0 := (T-Ha)*(Lf+b-M*0.5*(1+Ha/T));
elseif Cas == 5 then
  A0 := Hf*(Lf+b-(Ha+0.5*Hf)*M/T);
elseif Cas == 6 then
 A0 := ((((Lf+b)*T/M)-Ha)^2)*0.5*M/T;
elseif Cas == 7 then
  A0 := (T-Ha)*Lf-((M-b)^2)*T*0.5/M;
elseif Cas == 8 then
  A0 := Hf*Lf-0.5*(T/M)*(M*(Ha+Hf)/T-b)^2;
else //Cas 9
  A0 := Lf*((b+0.5*Lf)*T/M-Ha);
end if;

Asol := Hf*Lf - A0;

  annotation (Documentation(info="<html>
<p><i><b>Function inspired by calculation of overhang effects described in ISO 13791 standard</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
Horizontal shading devices (near mask) are considered. See diagram below:
<p><img src=\"modelica://BuildSysPro/Resources/Images/MasqueHorizontal.bmp\"/></p>
<p><u><b>Bibliography</b></u></p>
<p>ISO 13791 standard</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This function should only be called for an absolute value of Phi strictly lower than 90°, corresponding to the sun that reaches the window plane (abs(azimut-AzimutSoleil) &lsaquo; 90).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (according the standard ISO13791-2004) - Aurélie Kaemmerlen 05/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 10/2011 : correction du modèle - Nouveau chemin de calcul suite à la détection d'erreurs détectées </p>
</html>"));
end HorizontalMask;
