within BuildSysPro.BoundaryConditions.Weather.Functions;
function CalculPs "Compute the saturation pressure"
  parameter Real Tmin=273.16;
  parameter Real Tmax=647.3;
  output Real ps;
  input Real T;

protected
  Real tk;
  Real a;
  Real b;
  Real c;
  Real d;

algorithm
  tk:=min(Tmax,max(Tmin,T));
  if tk<=273.15 then
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
  ps:=exp(a/tk + b*log(tk) + c*tk + d);

  annotation (Documentation(info="<html>
<p><i><b>Compute the water saturation pressure</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Reference needed.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - 2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.3.0<br>
Author : EDF 2010<br>
--------------------------------------------------------------</b></p>
</html>"));
end CalculPs;
