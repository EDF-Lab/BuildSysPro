within BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal;
model EfficiencyFunctionOfTemp
  "Photovoltaic performance model depending on temperature"

  parameter Real eta_STC=0.15
    "PV panel (electric) efficiency in STC conditions";
  parameter Real mu_T=-0.5 "Temperature coefficient on the performance (% / K)";

  Modelica.Blocks.Interfaces.RealInput T "PV cells temperature (K)"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=270,
        origin={0,62})));

  Modelica.Blocks.Interfaces.RealOutput eta "Real electrical efficiency"
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
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model uses a simple equation to determine the electrical efficiency of the PV panel according to the temperature:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/eta_T.png\" alt=\"eta_T=eta_STC+mu_T*(T_cell-T_STC)\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/mu_T.png\" alt=\"mu_T\"/> is the temperature coefficient on the power (of the order of -0.5&#37;/K) and STC means Standard Testing Conditions.</p>
<p><u><b>Bibliography</b></u></p>
<p>Solar Engineering of Thermal processes, Duffie &amp; Beckmann, Wiley, 2006, p. 757</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end EfficiencyFunctionOfTemp;
