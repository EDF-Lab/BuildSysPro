within BuildSysPro.Utilities.Math;
function f_Pow "Power function"
  input Real x "X-axis";
  input Real xc "Junction X-axis";
  input Real n "Exponent of the function";
  output Real g "Value of the function g at x";
  output Real g1 "Value of the derivative function of g at x";
protected
  parameter Real a=(n - 1)*xc^(n - 2) "Coefficient a";
  parameter Real b=(2 - n)*xc^(n - 1) "Coefficient b";
  parameter Real y=abs(x);
  parameter Integer eps=if x<0 then -1 else 1;
algorithm
  g:=eps*(if y > xc then y^n else (a*y + b)*y);
  g1:=eps*(if y > xc then n*y^(n-1) else (2*a*y + b));
  annotation (Documentation(info="<html>
<p><b>Power function y = xn for n &lt; 1</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Let f be the real function f(x) = xn with 0 &lt; n &lt; 1.</p>
<p>To avoid a derivative that tends to infinity near 0, f is replaced by the function g such that g (x) = bx + ax&sup2; for 0 &lt; x &lt; xc and g(x) = f(x) for x &gt; xc.</p>
<p>The coefficients a and b are selected so as to keep the continuity of g and its derivative at xc, real chosen close to 0 and depending on the applications. It is shown that a = (n-1) xcn-2 and b = (2-n) xcn-1.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Example of calling of the function for n = 0.66, xc = 2.5</p>
<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr>
<td bgcolor=\"#e0e0e0\" valign=\"top\"><p><font style=\"font-size: 9pt; color: #0000ff; \">model</font> Unnamed </p><p><font style=\"font-size: 9pt; \">  <font style=\"color: #ff0000; \">Real</font> f <font style=\"font-size: 9pt; color: #006400; \">\"Function f\"</font>; </p><p><font style=\"font-size: 9pt; \">  <font style=\"color: #ff0000; \">Real</font> g <font style=\"font-size: 9pt; color: #006400; \">\"Function g\"</font>; </p><p><font style=\"font-size: 9pt; \">  <font style=\"color: #ff0000; \">Real</font> g1 <font style=\"font-size: 9pt; color: #006400; \">&quot;Derivative function of g&quot;</font>; </p><p><font style=\"font-size: 9pt; \">  <font style=\"color: #0000ff; \">parameter </font><font style=\"color: #ff0000; \">Real</font> n=0.66 <font style=\"font-size: 9pt; color: #006400; \">\"Exponent of f(x)=x^n\"</font>; </p><p><font style=\"font-size: 9pt; \">  <font style=\"color: #0000ff; \">parameter </font><font style=\"color: #ff0000; \">Real</font> xc=2.5 <font style=\"font-size: 9pt; color: #006400; \">\"Abscissa of the junction point \"</font>; </p><p><font style=\"font-size: 9pt; color: #0000ff; \">equation </font> </p><p><font style=\"font-size: 9pt; \">  f=time^n; </p><p>  (g,g1)=</font><font style=\"color: #ff0000; \">f_Pow</font>(x=time,xc=xc,n=n); </p><p><font style=\"font-size: 9pt; color: #0000ff; \">end </font>Unnamed; </p></td>
</tr>
</table>
<p><br/><br/><img src=\"modelica://BuildSysPro/Resources/Images/Courbe_fPuiss.bmp\"/></p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan Bouia 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Hassan BOUIA, EDF (2010)<br>
--------------------------------------------------------------</b></p></html>",
   revisions="<html>
</html>"));
end f_Pow;
