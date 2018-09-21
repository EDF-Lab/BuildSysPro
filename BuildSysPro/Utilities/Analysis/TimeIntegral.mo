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
  Modelica.Blocks.Interfaces.RealOutput Integral annotation (Placement(
        transformation(extent={{100,40},{140,80}}), iconTransformation(extent={
            {100,40},{140,80}})));

  Modelica.Blocks.Interfaces.RealOutput TotalIntegral annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent=
           {{100,-80},{140,-40}})));
initial equation
  It=0;

equation
It=It0+der(It)-u/Dt;
TotalIntegral=It;

algorithm
    when sample(0,Dt) then
      preIt:=It;
    end when;

  Integral := It - preIt;

    It0:=It;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Use the output <i>Integral</i> only when the box <i>\"Store variables at events\"</i> is checked in the simulation setup. Otherwise, use the output <i>TotalIntegral</i>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (on condition that the recovery time step is identical to the integration time step)  - Aurélie Kaemmerlen 03/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Anne-Sophie Coince 12/2014 : correction du calcul de l'intégrale pour que le pas de temps renseigné (Dt) soit bien pris en compte</p>
<p>Benoît Charrier 05/2017 : adding <code>TotalIntegral</code> as output to get the total value of integrated signal</p>
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
