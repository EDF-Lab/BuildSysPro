within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ExtConvection
  "Coefficient d'échange convectif tenant compte de la vitesse du vent"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
parameter Real a;
parameter Real n;
parameter Real b;
parameter Modelica.SIunits.Area S;

  Modelica.Blocks.Interfaces.RealInput v "vitesse du vent [m/s]"
                                         annotation (Placement(transformation(
          extent={{-110,26},{-70,66}}), iconTransformation(extent={{-120,20},{
            -80,60}})));
equation
  Q_flow = (a*v^n+b)*dT*S;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p>Corrélation générique du coefficient d'échange convectif en fonction de la vitesse du vent sous la forme : </p>
<p>hcv = a * v^n + b </p>
<p>voir par exemple notice TF112 de CLIM2000 pour des exemples biblio. </p>
<p>EAB avril 2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end ExtConvection;
