within BuildSysPro.BoundaryConditions.Scenarios;
block StepFunctionSimpleXY
  "Fonction en escalier simple à l'aide de 2 vecteurs (H. BOUIA - 07/2012)"
  parameter Real periode=24
    "Période en unités du vecteur X. Si <=0 alors la fonction n'est pas périodique";
  parameter Real X[:] "Vecteur X";
  parameter Real Y[size(X,1)] "Vecteur Y";

  Modelica.Blocks.Interfaces.RealInput x "variable dépendante" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=sum(Y[1:n - 1] .* u) + (if xp >= X[n] then 1 else 0)*Y[n]
    "variable indépendante"                                                                                                 annotation (Placement(transformation(
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
<h4>Fonction en escalier périodique ou non y=f(x) définie par 2 vecteurs X et Y</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>X (variable dépendante) et Y(variable indépendante) sont deux vecteurs de même taille : n éléments chacun.</p>
<p>Pour tout i de 1 à n-1, pout tout x de [Xi, X(i+1)[, on calcule y = Yi</p>
<p>Pout tout x &GT;= Xn : y = Yn</p>
<p>Pout tout x, on calcule xp = if periode &GT; 0 then mod(x,periode) else x et on calcule y=y(xp)</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Hassan Bouia 07/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end StepFunctionSimpleXY;
