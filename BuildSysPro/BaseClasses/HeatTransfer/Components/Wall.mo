within BuildSysPro.BaseClasses.HeatTransfer.Components;
model Wall
  "Model of wall composed of one or more materials described from outside to inside"

  parameter Integer nc=2 "Number of materials";
  parameter BuildSysPro.Utilities.Records.GenericSolid matc[nc]
    "Constituting materials of the wall (from outside to inside)"
    annotation (choicesAllMatching=true);
  parameter Integer mc[nc]=3*fill(1, nc) "Number of layers by material";
  parameter Modelica.SIunits.Length[nc] ec=0.2*fill(1, nc)
    "Thickness of the layers (from outside to inside)";
  parameter Modelica.SIunits.Area Sc=1 "Surface of the wall";

  parameter Modelica.SIunits.Temperature Tinitc=293.15 "Initial temperature";
  parameter BuildSysPro.Utilities.Types.InitCond InitTypec=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialization type";

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
<h4>Model of 1-D thermal conduction in a N layers wall</h4>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The <code>T</code> variable gives the temperature in the middle of each node (<code>m</code> equidistants meshes on the given <code>ep</code> thickness).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Hassan Bouia 06/2012 : correction du bug qui empêchait le fonctionnement du modèle lorsqu'on ne saisissait qu'un seul matériau avec une seule couche.</p>
</html>"));
end Wall;
