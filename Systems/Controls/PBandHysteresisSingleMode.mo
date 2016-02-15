within BuildSysPro.Systems.Controls;
model PBandHysteresisSingleMode

  Modelica.Blocks.Interfaces.RealInput X
    annotation (Placement(transformation(extent={{-110,40},{-90,60}})));
  Modelica.Blocks.Interfaces.RealInput X_ref
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Modelica.Blocks.Interfaces.RealOutput epsilon
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  parameter Real epsmin=0.3 "valeur minimale du paramètre de sortie";
  parameter Real epsmax=1 "valeur maximale du paramètre de sortie";
  parameter Real Range=0.5
    "Ecart (X-X_ref) maximal avant saturation de la sortie";

protected
  Boolean preeps(start=true)
    "Booléen qui situe la précédente valeur de epsilon: 1 si epsilon>0, 0 si epsilon=0";

algorithm
  if (X<X_ref-Range) then //Si X-X_ref trop négatif, espilon sature à epsmax
    epsilon:=abs(epsmax);
    preeps := true;

  elseif X>X_ref+Range then     //Si X-X_ref trop positif, epsilon passe à 0"
    epsilon := 0;
    preeps := false;
  else
    if preeps then       //Boucle hysteresis: Régulation linéaire si X augmente, ou à 0 si X diminue
     epsilon := min(abs(epsmax),max(abs(epsmin),abs(epsmax - (X-(X_ref-Range))*(epsmax-epsmin)/(2*Range))));
    else
      epsilon := 0;
    end if;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-86},{0,88},{0,86},{0,82}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-88,-40},{86,-40},{30,-40},{20,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-2,86},{2,86},{0,96},{-2,86}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{3,6},{-1,6},{1,-4},{3,6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={92,-41},
          rotation=90),
        Line(
          points={{-88,64},{-38,64},{38,-16},{38,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-4,64},{4,64}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{6,58},{22,70}},
          lineColor={0,0,0},
          textString="epsmax"),
        Line(
          points={{-38,-44},{-38,-36}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-44,-54},{-34,-44}},
          lineColor={0,0,0},
          textString="-e"),
        Text(
          extent={{34,-54},{44,-44}},
          lineColor={0,0,0},
          textString="e"),
        Line(
          points={{38,-44},{38,-36}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-4,-16},{4,-16}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{4,74},{24,86}},
          lineColor={0,0,0},
          textString="epsilon"),
        Text(
          extent={{84,-38},{102,-24}},
          lineColor={0,0,0},
          textString="X-X_ref"),
        Text(
          extent={{-16,-20},{0,-8}},
          lineColor={0,0,0},
          textString="epsmin"),
        Line(
          points={{4,22},{6,18},{2,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{2,-42},{-2,-40},{2,-38}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,-26},{38,-30},{36,-26}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{88,-40},{-38,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{38,-40},{38,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,-40},{-38,64}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-36,6},{-38,10},{-40,6}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>Régulation propotionnel à Hysteresis</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le modèle renvoit une valeur entre 0 et 1 à partir d'une valeur X et d'une consigne X_ref. </p>
<p>La régulation est de type proportionnel, avec une boucle hysteresis:</p>
<ol>
<li>Si X-X_ref&LT; - Range, epsilon = epsmax</li>
<li>Si X-X_ref &GT; Range, epsilon = 0</li>
<li>Si X est dans l'intervalle [X_ref-Range;X_ref+Range], régulation proportionnelle ou epsilon = 0 selon le point d'entrée dans la zone proportionnelle.</li>
</ol>
<p><br><u><b>Mode d'emploi</b></u></p>
<p>Il faut renseigner la largeur de la bande proportionnelle (Range), ainsi que les valeurs minimale et maximale de epsilon, qui détermineront la pente de la loi proportionnelle.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Frédéric GASTIGER, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end PBandHysteresisSingleMode;
