within BuildSysPro.BaseClasses.HeatTransfer.Interfaces;
connector HeatPort_b "Thermal port for 1-D heat transfer"

  extends HeatPort;

  annotation(defaultComponentName = "port_b",
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This connector is used for 1-dimensional heat flow between components. The variables in the connector are:</p>
<pre>   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This convention has to be used whenever this connector is used in a model class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and <b>HeatPort_b</b> are identical with the only exception of the different <b>icon layout</b>.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b\">HeatPort_b</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,120},{120,60}},
          lineColor={191,0,0},
          textString="%name")}));
end HeatPort_b;
