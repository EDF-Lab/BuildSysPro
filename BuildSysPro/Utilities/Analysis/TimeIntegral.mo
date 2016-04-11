within BuildSysPro.Utilities.Analysis;
model TimeIntegral
  "Calculation of the integral of a value on a given time step"

  Real It(start=0) "Total integral";
  Real It0(start=0) "Total integral at the previous time";
  Real preIt(start=0) "Total integral at the previous time step Dt";
  parameter Integer Dt=3600 "Integration step (hourly step by default)";
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-138,-20},{-98,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput integrale
    annotation (Placement(transformation(extent={{100,-18},{140,22}}),
        iconTransformation(extent={{100,-20},{140,20}})));

initial equation
  It=0;

equation
It=It0+der(It)-u/Dt;

algorithm
    when sample(0,Dt) then
      preIt:=It;
    end when;

    integrale := It - preIt;

    It0:=It;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Use the output <i>Integral</i> only when the box <i>\"Store variables at events\"</i> is checked in the simulation setup. Otherwise, use a difference on the variable <i>It</i> (total integrale).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (on condition that the recovery time step is identical to the integration time step)  - Aurélie Kaemmerlen 03/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>12/2014 Anne-Sophie Coince : Correction du calcul de l'intégrale pour que le pas de temps renseigné (Dt) soit bien pris en compte</p>
</html>"),
   Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,128},{86,98}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Bitmap(extent={{-94,-82},{104,92}},fileName=
              "modelica://BuildSysPro/Resources/Images/equations/Integrale.png")}));
end TimeIntegral;
