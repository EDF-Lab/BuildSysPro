within BuildSysPro.Systems.Controls;
model Switch
  extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

  parameter Boolean valeur_On=true
    "valeur de OnOff pour laquelle le flux existe";

  Modelica.Blocks.Interfaces.BooleanInput OnOff annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,60}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={0,46})));

equation
  if OnOff == valeur_On then
    dT = 0;
  else
    Q_flow = 0;
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-80,-60},{
            80,60}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-80,-60},{80,
            60}}), graphics={
        Text(
          extent={{-82,80},{78,60}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-66,0},{-44,0},{-22,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-22,2},{-18,-2}},
          lineColor={0,0,0},
          lineThickness=0),
        Line(
          points={{-18,2},{12,12}},
          color={0,0,0},
          thickness=0,
          smooth=Smooth.None),
        Rectangle(
          extent={{-78,24},{-64,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135}),
        Line(
          points={{8,0},{44,0},{66,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{64,24},{78,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135}),
        Rectangle(
          extent={{-78,32},{78,-46}},
          lineColor={0,0,0},
          lineThickness=0.2)}),
    Documentation(info="<html>
<p><i><b>Interrupteur - Régulateur tout ou rien permettant de couper la connexion entre les entrées et sorties </b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p><b>Fonctionnement :</b> </p>
<p>Si l'interrupteur est <u>fermé</u>, il y a égalité entre les températures des ports thermiques (par défaut si OnOff=1)</p>
<p>Si l'interrupteur est <u>ouvert</u>, aucun flux ne circule entre les deux ports (par défaut si OnOff&LT;&GT;1)</p>
<p><br>Il est possible de changer la valeur pour laquelle l'interrupteur est fermé en changeant la valeur du paramètre valeur_On.</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 04/2014 : modification du IntegerInput en BooleanInput, pour plus de logique</p>
</html>"));
end Switch;
