within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ThermalResistance
  "Lumped thermal element transporting heat without storing it"
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
<p>Modèle simple de résistance thermique constante entre deux points de température, reprenant in extenso le modèle natif ThermalConductor EAB 26/03/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">ThermalResistor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end ThermalResistance;
