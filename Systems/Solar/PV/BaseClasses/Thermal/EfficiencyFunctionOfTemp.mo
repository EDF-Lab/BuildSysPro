within BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal;
model EfficiencyFunctionOfTemp
  "Modèle de rendement photovoltaïque en fonction de la température"

  parameter Real eta_STC=0.15
    "rendement (électrique) dans les conditions STC du panneau PV";
  parameter Real mu_T=-0.5 "Coefficient de température sur le rendement %/K";

  Modelica.Blocks.Interfaces.RealInput T "température des cellules PV (K)"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=270,
        origin={0,62})));

  Modelica.Blocks.Interfaces.RealOutput eta "rendement électrique réel"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

equation
  eta = eta_STC*(1 + mu_T*(T - 298.15)/100);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                        graphics={Rectangle(extent={{-54,42},{54,-42}},
            lineColor={0,0,255}), Text(
          extent={{24,18},{-24,-16}},
          lineColor={0,0,255},
          textString="eta"),
        Line(
          points={{-40,40},{-40,-40},{40,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-40,40},{-42,36}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-40,40},{-38,36}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,-40},{38,-38}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,-40},{38,-42}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,30},{32,2}},
          color={255,0,0},
          smooth=Smooth.None),    Text(
          extent={{68,-24},{28,-46}},
          lineColor={0,0,255},
          textString="T")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Modèle de rendement photovolta&iuml;que en fonction de la température</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle utilise une équation simple pour déterminer le rendement électrique du panneau PV en fonction de la température : </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/eta_T.png\" alt=\"eta_T=eta_STC+mu_T*(T_cell-T_STC)\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/mu_T.png\" alt=\"mu_T\"/> est le coefficient de température sur la puissance (de l'ordre de -0,5%/K) et STC signifie Standard Testing Conditions.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Solar Engineering of Thermal processes, Duffie & Beckmann, Wiley, 2006, p. 757</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end EfficiencyFunctionOfTemp;
