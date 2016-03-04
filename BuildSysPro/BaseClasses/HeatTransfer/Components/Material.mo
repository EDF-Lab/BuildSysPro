within BuildSysPro.BaseClasses.HeatTransfer.Components;
model Material "Materiau discrétisé en couches d'égales épaisseurs"
  parameter BuildSysPro.Utilities.Records.GenericSolid mat "Matériau"
    annotation (choicesAllMatching=true);
  parameter Integer m=3 "Nombre de couches dans le matériau";
  parameter Modelica.SIunits.Length e=0.20 "Epasseur en m";
  parameter Modelica.SIunits.Area S=1 "Surface en m²";
  parameter Modelica.SIunits.Temperature Tinit=293.15 "Température initiale";
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type d'initialisation";

  BuildSysPro.BaseClasses.HeatTransfer.Components.MaterialLayer couche[m](
    each e=e/m,
    each S=S,
    each mat=mat,
    each InitType=InitType,
    each Tinit=Tinit);

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (
     Placement(transformation(extent={{-100,-10},{-80,10}}), iconTransformation(
          extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b annotation (
     Placement(transformation(extent={{80,-10},{100,10}}), iconTransformation(
          extent={{80,-10},{100,10}})));
equation
  connect(port_a,couche[1].port_a);
  for i in 2:m loop
     connect(couche[i-1].port_b,couche[i].port_a);
  end for;
  connect(couche[m].port_b,port_b);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={       Line(
          points={{-80,0},{80,0}},
          color={0,0,255},
          smooth=Smooth.None),     Rectangle(
          extent={{-40,80},{0,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder),
                                   Rectangle(
          extent={{0,80},{40,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder)}), Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end Material;
