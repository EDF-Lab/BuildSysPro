within BuildSysPro.Systems.Controls;
model PBand

  Modelica.Blocks.Interfaces.RealInput X
    annotation (Placement(transformation(extent={{-108,40},{-92,56}})));
  Modelica.Blocks.Interfaces.RealInput X_ref
    annotation (Placement(transformation(extent={{-108,-54},{-92,-38}})));
  Modelica.Blocks.Interfaces.RealOutput Y
    annotation (Placement(transformation(extent={{96,-8},{112,8}})));

  parameter Real Ymin=0.3 "valeur minimale du paramètre de sortie";
  parameter Real Ymax=1 "valeur maximale du paramètre de sortie";
  parameter Real Range=0.5
    "Ecart (X-X_ref) maximal avant saturation de la sortie";

algorithm
    Y := max(Ymin,min(Ymax,Ymax - (X-(X_ref-Range))*(Ymax-Ymin)/(2*Range)));

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
          points={{-88,64},{-38,64},{38,-16},{86,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-4,64},{4,64}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{6,58},{22,70}},
          lineColor={0,0,0},
          textString="Ymax"),
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
          textString="Y"),
        Text(
          extent={{84,-38},{102,-24}},
          lineColor={0,0,0},
          textString="X-X_ref"),
        Text(
          extent={{-16,-20},{0,-8}},
          lineColor={0,0,0},
          textString="Ymin")}),
    Documentation(info="<html>
<p><u><b>Description</b></u></p>
<p>Gestion en bande proportionnelle autour d'une valeur de consigne</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le modèle renvoie une valeur qui varie proportionnellement avec l'écart X-X-ref (valeur de consigne). Le signal est saturé à Ymin et Ymax dans les conditions extrêmes.</p>
<p><br><u><b>Mode d'emploi</b></u></p>
<p>Le réglage du modèle est le suivant:</p>
<ol>
<li>Ymin et Ymax, valeurs de saturation (par exemple 0 et 1 pour obtenir un gain).</li>
<li>Valeur du Range, soit la demi-largeur de la bande proportionnelle.</li>
</ol>
<p><br><b>Note</b>: Pour Range&GT;0, la bande proportionnelle sera décroissante. Pour obtenir une fonction croissante, il suffit d'avoir Range&LT;0, en laissant les autres valeurs <u>inchangées</u>.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end PBand;
