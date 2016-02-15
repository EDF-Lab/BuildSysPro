within BuildSysPro.BaseClasses.HeatTransfer.Interfaces;
connector HeatPort_b "Port thermique pour transfert thermique 1-D"

  extends HeatPort;

  annotation(defaultComponentName = "port_b",
    Documentation(info="<html>
<p>This connector is used for 1-dimensional heat flow between components. The variables in the connector are:</p>
<pre><span style=\"font-family: Courier New,courier;\">   T       Temperature in [Kelvin].</span>
<span style=\"font-family: Courier New,courier;\">   Q_flow  Heat flow rate in [Watt].</span></pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This convention has to be used whenever this connector is used in a model class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and <b>HeatPort_b</b> are identical with the only exception of the different <b>icon layout</b>.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
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
