within BuildSysPro.Utilities.Math;
function LeastSquares "Least squares problem"

  input Integer N=6 "Number of points";
  input Integer q=3 "Degree of the sought polynomial";
  input Real x[N]={1.,2,3,4,5,7} "X-axis";
  input Real y[N]={1,2,3.2,4,4.5,7.2} "Y-axis";
  output Real c[q+1] "Coefficients of the sought polynomial";
protected
  Integer na=q+1;
  Real A[N,na] "Matrix minimizing the norm ||A*c-y||²";
algorithm
  for i in 1:N loop
    A[i,1]:=1;
    for j in 2:na loop
        A[i,j]:=A[i, j - 1]*x[i];
      end for;
    end for;
  c:= Modelica.Math.Matrices.leastSquares(A=A,b=y);

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Given a cloud of N points (xi, yi), the best degree polynomial q <img src=\"../Resources/Images/MC/2.gif\"/> which minimizes <img src=\"../Resources/Images/MC/1.gif\"/>.</p>
<p>Finding the polynomial P means finding the vector <img src=\"../Resources/Images/MC/3.gif\"/> which minimizes the norm <img src=\"../Resources/Images/MC/4.gif\"/> avec <img src=\"../Resources/Images/MC/5.gif\"/> and y the vector {yi}i=1,N.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p><b>Example with Excel :</b> we seek a polynomial trend curve of degree 3 with the following cloud of points :</p>
<p><img src=\"../Resources/Images/MC/6.jpg\"/></p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan Bouia, Sila Filfli 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Hassan BOUIA, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 01/2016 : Adaptation pour compatibilité avec OpenModelica</p>
</html>"));
end LeastSquares;
