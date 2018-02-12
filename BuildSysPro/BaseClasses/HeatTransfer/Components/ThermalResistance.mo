within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ThermalResistance "Thermal resistance"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
  parameter Modelica.SIunits.ThermalResistance R
    "Constant thermal resistance of material";

equation
  Q_flow = dT/R;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag), Text(
          extent={{-105,-66},{123,-106}},
          lineColor={0,0,0},
          textString="R=%R K/W")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                             graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Simple model of a constant thermal resistance beetween two temperature points.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EAB 03/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : EDF<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">ThermalResistor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end ThermalResistance;
