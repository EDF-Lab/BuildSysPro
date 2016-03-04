within BuildSysPro.BaseClasses.HeatTransfer.Components;
model Wall
  "Paroi composée de un ou plusieurs matériaux décrits de l'extérieur vers l'intérieur"

  parameter Integer nc=2 "Nombre de matériaux";
  parameter BuildSysPro.Utilities.Records.GenericSolid matc[nc]
    "Matériaux constitutifs de la paroi de l'extérieur vers l'intérieur"
    annotation (choicesAllMatching=true);
  parameter Integer mc[nc]=3*fill(1, nc) "Nombre de couches par matériau";
  parameter Modelica.SIunits.Length[nc] ec=0.2*fill(1, nc)
    "Epaisseur des couches (ext vers int)";
  parameter Modelica.SIunits.Area Sc=1 "Surface de la paroi en m2";

  parameter Modelica.SIunits.Temperature Tinitc=293.15 "Température initiale";
  parameter BuildSysPro.Utilities.Types.InitCond InitTypec=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type d'initialisation";

  BuildSysPro.BaseClasses.HeatTransfer.Components.Material materiau[nc](
    e=ec,
    m=mc,
    each S=Sc,
    mat=matc,
    each InitType=InitTypec,
    each Tinit=Tinitc);

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (
     Placement(transformation(extent={{-100,-10},{-80,10}}), iconTransformation(
          extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b annotation (
     Placement(transformation(extent={{80,-10},{100,10}}), iconTransformation(
          extent={{80,-10},{100,10}})));
equation
  connect(port_a,materiau[1].port_a);
  for i in 2:nc loop
     connect(materiau[i-1].port_b,materiau[i].port_a);
  end for;
  connect(materiau[nc].port_b,port_b);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={       Line(
          points={{-80,0},{80,0}},
          color={0,0,255},
          smooth=Smooth.None),     Rectangle(
          extent={{-50,80},{6,-80}},
          lineColor={0,0,255},
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder),
                                   Rectangle(
          extent={{10,80},{50,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder)}),
              Documentation(info="<html>
<h4>Modèle de Conduction thermique 1D dans un matériau à n couches</h4>
<p>Modèle étendu du modèle désormais placé dans les modèles avancés - son code n'est plus acessible</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>La variable <b>T</b> donne la température au centre de chaque noeud (<b>m</b> mailles équidistantes sur l'épaisseur <b>ep</b> donnée).</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Hassan Bouia 06/2012 : correction du bug qui empêchait le fonctionnement du modèle lorsqu'on ne saisissait qu'un seul matériau avec une seule couche.</p>
</html>"));
end Wall;
