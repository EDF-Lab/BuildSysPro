within BuildSysPro.BaseClasses.HeatTransfer.Components;
model NonLinearConvective
  "Coefficient d'échange convectif non linéaire générique"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
parameter Real a "facteur multiplicatif de la différence de température";
parameter Real n "exposant de la loi d'échange";
parameter Real b "terme supplémentaire de la loi d'échange";
parameter Modelica.SIunits.Area S "surface d'échange";

equation
  Q_flow = if noEvent(abs(dT)>0) then S*(a*abs(dT)^n + b)*dT else 0;

  annotation ( Documentation(info="<html>
<p>Corrélation générique du coefficient d'échange convectif en fonction de l'écart de température : </p>
<p>hcv = a * dT^n + b </p>
<p>voir par exemple notice TF111 de CLIM2000 pour des exemples biblio. </p>
<p>EAB avril 2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
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
