within BuildSysPro.Utilities.Math;
function FindMultiExtremum
  "Extract the n smallest values (ascending=true) or greatest values (ascending=false) of a vector X"
  input Integer n "Number of extreme values to extract to the vector X";
  input Real[:] X "Vector of reals";
  input Boolean ascending=false;
  output Real Xm[n] "Ordered extreme values of the vector X";
  output Integer Indm[n] "Corresponding indexes in the vector X";
//  output Integer z[size(X,1)]=fill(0,size(X,1));

protected
  constant Real eps=Modelica.Constants.eps;
  parameter Integer k=size(X,1);
  Integer z[k]=fill(0,k);
  Real Y[k];
  Integer useless_index[k];
  Integer i;
  Integer j;

algorithm
  (Y, useless_index) := Modelica.Math.Vectors.sort(X, ascending);
  assert(n<=k, "The input parameter n must be lower than or equal to the size of X");
  assert(n>0, "The input parameter n must be greater than 0");
  Xm:=Y[1:n];
  for i in 1:n loop
     j:=1;
     while abs(Xm[i]-X[j])>eps or z[j]>0 loop
         j:=j+1;
     end while;
     z[j]:=i;
     Indm[i]:=j;
  end for;

  annotation (Documentation(info="<html>
<p><i><b>FindMultiExtremum returns a vector containing the n (where n &lt;N) extreme values of the input vector X and their indexes.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function takes as input : </p>
<ul>
<li>a vector <i>X</i> made of N real values,</li>
<li><i>n</i>, the number of extreme values to extract from the vector <i>X</i></li>
<li>The boolean <i>ascending</i>, to set if extreme values wanted are the smallest ones (=true) or the greatest ones (=false)</li>
</ul>
<p>FindMultiExtremum returns a vector <i>Xm</i> contenant les n (où n &lt; N) containing the n (where n &lt; N) extreme values of the input vector <i>X</i> and the vector <i>Indm</i> containing their indexes in the vector <i>X</i>.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>u = {1, 3, 4, 5, 4, 3}</p>
<p>(X,Ind)=FindMultiExtremum(X=u,n=4,ascending=false)</p>
<p>Declaring variable: Real X [4];</p>
<p>Declaring variable: Integer Ind [4];</p>
<p>X = {5.0, 4.0, 4.0, 3.0}, Ind = {4, 3, 5, 2}</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Gilles Plessis, Hassan Bouia 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 01/2016 : Adaptation pour compatibilité avec OpenModelica</p>
</html>"));
end FindMultiExtremum;
