within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ConvectiveBoundaryLayer
  "Couche limite convective à exposant variable (TF75 C2K)"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;

parameter Modelica.SIunits.CoefficientOfHeatTransfer h=5
    "coefficient d'échange";
parameter Modelica.SIunits.Area S=1 "surface d'échange";
parameter Real alpha=0.5 "exposant de la loi d'échange";

equation
Q_flow = sign(dT)*h*S*abs(dT)^alpha;

  annotation (
Documentation(info="<html>
<p>Ce modèle reprend le TF 75 de CLIM2000. Il permet de définir un coefficient d'échange convectif entre un fluide et une paroi sous la forme : </p>
<p>Flux_convectif = hS (deltaT)^alpha </p>
<p>EAB avril 2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(extent={{-80,60},{80,-60}}, lineColor={0,0,255}),
        Polygon(
          points={{-80,-60},{-56,-42},{-6,-20},{58,4},{80,10},{80,-60},
              {-80,-60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,38},{93,16}},
          lineColor={0,0,0},
          textString="%h*%S*dT^ %alpha W")}),
                                           DymolaStoredErrors);
end ConvectiveBoundaryLayer;
