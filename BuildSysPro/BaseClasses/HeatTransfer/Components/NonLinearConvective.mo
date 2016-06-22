within BuildSysPro.BaseClasses.HeatTransfer.Components;
model NonLinearConvective
  "Generic non linear convective heat exchange coefficient"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
  parameter Real a "Multiplicative factor of the temperature difference";
  parameter Real n "Exponent of the exchange law";
  parameter Real b "Additional term of the exchange law";
  parameter Modelica.SIunits.Area S "Exchange surface";

equation
  Q_flow = if noEvent(abs(dT)>0) then S*(a*abs(dT)^n + b)*dT else 0;

  annotation ( Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic correlation of the convective heat exchange coefficient depending on the temperature gap : </p>
<p><code>hcv = a * dT<sup>n</sup> + b</code></p>
<p><u><b>Bibliography</b></u></p>
<p>See notice TF111 of CLIM2000 for examples from the bibliography.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EAB 04/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>",
   revisions="<html>
<p>Hassan Bouia 02/2013 : Modification de dt en abs(dT).</p>
<p>Amy Lindsay 11/2014 : mise en place d'un noEvent pour que le abs ne génère pas d'erreur lorsque dT est très petit (proche de 0)</p>
</html>"),
Icon(graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag), Text(
          extent={{-46,22},{46,-24}},
          lineColor={0,128,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,170,255},
          textString="h_cv = a dT^n + b")}));
end NonLinearConvective;
