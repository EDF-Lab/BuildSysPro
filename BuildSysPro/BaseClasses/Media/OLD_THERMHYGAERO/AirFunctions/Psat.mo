within BuildSysPro.BaseClasses.Media.OLD_THERMHYGAERO.AirFunctions;
function Psat "Saturation pressure depending on temperature"
  AirConstants.CteAH AH;
  input Real T "Air temperature [K]";
  output Real Psat "Vapour saturation pressure [Pa]";
protected
  parameter Real Tmin=273.16;
  parameter Real Tmax=647.3;
  parameter Real tk=min(Tmax,max(Tmin,T));
  Real a;
  Real b;
  Real c;
  Real d;
algorithm
  if tk<=AH.TKref then
        a :=-6086.67457;
        b :=0.258146988;
        c :=0;
        d :=27.2497986;
  elseif (tk <= 333.15) then
        a :=-6722.94637;
        b :=-4.77551358;
        c :=0;
        d :=57.8181266;
  else  a :=-7797.09834;
        b :=-11.2831932;
        c :=0.00993664096;
        d :=95.5324251;
  end if;
  Psat:=exp(a/tk + b*log(tk) + c*tk + d);

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end Psat;
