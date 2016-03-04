within BuildSysPro.BoundaryConditions.Scenarios;
block StepFunctionSimpleXY
  "Simple constant-segment interpolation defined from 2 vectors"
  parameter Real periode=24
    "Period in vector X units. If <=0 then periodicity is not considered";
  parameter Real X[:] "X Vector";
  parameter Real Y[size(X,1)] "Y Vector";

  Modelica.Blocks.Interfaces.RealInput x "Dependent variable" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=sum(Y[1:n - 1] .* u) + (if xp >= X[n] then 1 else 0)*Y[n]
    "Interpolated variable"                                                                                                 annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));

protected
  parameter Integer n=size(X,1);
  Real xp=if periode > 0 then mod(x,periode) else x;
  Integer u[n-1]={if xp>=X[i] and xp<X[i+1] then 1 else 0 for i in 1:n-1};
  annotation (                               Icon(graphics={Line(
          points={{-60,-60},{-20,-60},{-20,0},{6,0},{40,0},{40,40}},
          color={0,0,255},
          smooth=Smooth.None), Rectangle(extent={{-100,100},{100,-100}},
                                                                     lineColor={
              0,0,255}),
        Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,255},
          textString="%name")}),
                           Documentation(info="<html>
<p><i><b>Periodic constant-segment interpolation.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Constant-segment interpolation in one dimension specified by 2 vectors.</p>
<p>It could be periodic or not.</p>
<p>The dependent variable (homogenous to the input) is specified in the parameter <b>X vector</b>.</p>
<p>The independent variable to be interpolated are defined in the parameter <b>Yvector</b>.</p>
<p><u><b>Instructions for use</b></u></p>
<p>X vector (dependent variable) et Y vector (data to be interpolated) are 2 vectors having the same size: n elements each.</p>
<p>For all i from 1 to n-1, for any x in [Xi, X (i + 1) [, calculation of y = Yi</p>
<p>For all x &GT;= Xn : y = Yn</p>
<p>For all x, calculation of xp = >if period &GT; 0 then mod(x,period) else x and calculation of y=y(xp)</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 07/2012 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end StepFunctionSimpleXY;
