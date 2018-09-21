within BuildSysPro.BaseClasses.HeatTransfer.Components;
model Material "Material discretized in different layers with the same length"
  parameter BuildSysPro.Utilities.Records.GenericSolid mat "Material"
    annotation (choicesAllMatching=true);
  parameter Integer m=3 "Number of layers in the material";
  parameter Modelica.SIunits.Length e=0.20 "Thickness";
  parameter Modelica.SIunits.Area S=1 "Surface";
  parameter Modelica.SIunits.Temperature Tinit=293.15 "Initial temperature";
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialization type";

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
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end Material;
