within BuildSysPro.Utilities.Records;
record GenericSolid "Generic structure for solid materials"

 Modelica.SIunits.ThermalConductivity lambda "Heat conductivity";
 Modelica.SIunits.Density rho "Density";
 Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-66,54},{-46,34}},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{38,0},{58,-20}},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-64,-44},{-44,-64}},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{50,-76},{70,-96}},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{40,94},{60,74}},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Description of thermophysical properties of a material considered to be homogeneous.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end GenericSolid;
