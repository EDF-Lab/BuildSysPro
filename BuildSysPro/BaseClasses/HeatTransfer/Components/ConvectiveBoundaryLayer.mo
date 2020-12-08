within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ConvectiveBoundaryLayer
  "Convective boundary layer with variable exponent (TF75 C2K)"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;

parameter Modelica.SIunits.CoefficientOfHeatTransfer h=5
    "Heat exchange coefficient";
    parameter Modelica.SIunits.Area S=1 "Exchange surface";
    parameter Real alpha=0.5 "Exponent of the exchange law";

equation
Q_flow = sign(dT)*h*S*abs(dT)^alpha;

  annotation (
Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows to define a convective heat exchange coefficient between a fluid and a wall, in the form of :</p>
<p>Q_flow = h.S.(deltaT)<sup>alpha</sup></p>
<p><u><b>Bibliography</b></u></p>
<p>See notice TF75 of CLIM2000.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EAB 04/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
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
