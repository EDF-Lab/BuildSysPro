within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model B_Coefficient
  "Combinaison linéaire de température pour les conditions limites plafond/plancher"
parameter Real b=0.1 "Coefficient de pondération";
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_ext
    annotation (Placement(transformation(extent={{-100,20},{-80,40}}),
        iconTransformation(extent={{-100,20},{-80,40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tponder
    annotation (Placement(transformation(extent={{40,-12},{60,8}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_int
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}}),
        iconTransformation(extent={{-100,-40},{-80,-20}})));

equation
  Tponder.T=b*port_ext.T+(1-b)*port_int.T;
  port_int.Q_flow=0;
  port_ext.Q_flow=-Tponder.Q_flow;

annotation (Documentation(info="<html>
<p>Un local non chauffé peut être considéré comme une zone supplémentaire du bâtiment. Toutefois, une étude réalisée au sein du département EDF/R&D/ADEB a montré qu'une paroi (horizontale ou verticale) en contact avec un local non chauffé, pouvait être traitée comme une paroi externe possédant une couche d'isolant supplémentaire et donnant sur l'extérieur. L'épaisseur de cette couche supplémentaire se calcule en considérant l'égalité entre les déperditions de la paroi réelle et celles de la paroi fictive (i.e. avec l'isolant supplémentaire). Le coefficient thermique de la paroi ainsi obtenue permet de modéliser l'influence du local non chauffé. </p>
<p>Pour cela, on introduit le coefficient réglementaire b de réduction de température. Ce paramètre est défini en fonction de la nature du local non chauffé comme suit : </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/coefficient_b2.bmp\"/></p>
<p>Dans le cas où l'on souhaite un calcul plus précis du coefficient b on peut s'aider de la méthode suivante:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Coefficient_b.png\"/></p>
<p>Modèle validé - Gilles Plessis 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2011 : Fusion des deux anciens modèles afin de prendre en compte en plus de la condition en température une condition de flux. La précédente version (2010.12) induisait en effet des problèmes de bilan d'énergie lors du calcul de GV de certains bâtiments avec l'apparition de termes sources ou puits.</p>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                               graphics={
        Polygon(
          points={{-80,60},{-80,-60},{46,0},{-80,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-82,-16},{-26,-40}},
          lineColor={255,255,255},
          textString="*(1-b)"),
        Text(
          extent={{-94,42},{-30,16}},
          lineColor={255,255,255},
          textString="*b"),
        Text(
          extent={{-32,12},{4,-10}},
          lineColor={255,255,255},
          textString="+")}),
              Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics), Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Polygon(
          points={{-80,60},{-80,-56},{48,0},{-80,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid)}));
end B_Coefficient;
