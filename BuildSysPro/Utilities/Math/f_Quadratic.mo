within BuildSysPro.Utilities.Math;
function f_Quadratic "Square law and power law"
  input Real x "Abscissa";
  input Real u "Junction abscissa";
  input Real n "Exponent of the function, in range ]1/2,1[";
  output Real q "Value of the function q at x";
  output Real q1 "Value of the derivative function of q at x";

protected
  parameter Real v=u^n "Value of q at u";
  parameter Real w=n*v/u "Value of q' at u";

  // Parameters of the square law
  parameter Real alpha=(1/w-u/v)/v "Coefficient alpha";
  parameter Real beta=2*u/v-1/w "Coefficient beta";

  // Auxiliary parameters
  parameter Real a=1/alpha "Coefficient alpha";
  parameter Real b=beta/(2*alpha) "Coefficient beta";
  parameter Real y=abs(x);
  parameter Integer eps=if x<0 then -1 else 1;
algorithm
  assert(n>0.5 and n<1,"incorrect value of n, the value of n should be strictly greater than 0.5 and less than 1");
  q:=eps*(if y >= u then y^n else sqrt(a*y+b*b)-b);
  q1:=eps*(if y >= u then n*y^(n-1) else a/2/(eps*q+b));

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Loi_Quadratique1.bmp\"/> </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Loi_Quadratique2.bmp\"/> </p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan Bouia 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Hassan BOUIA, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
   revisions=""));
end f_Quadratic;
