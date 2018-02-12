within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ASHRAE_vert
  "Generic non linear convective heat exchange coefficient from ASHRAE for a vertical wall"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;

parameter Modelica.SIunits.Area S;

equation
Q_flow = S*(1.24*dT^(1/3));

  annotation (Icon(graphics={
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{-68,50},{56,-36}},
          lineColor={0,128,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,170,255},
          textString="h_cv = 1.24 dT^(1/3)"),
        Text(
          extent={{0,-12},{0,-40}},
          lineColor={0,128,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,170,255},
          textString="ASHRAE")}), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end ASHRAE_vert;
