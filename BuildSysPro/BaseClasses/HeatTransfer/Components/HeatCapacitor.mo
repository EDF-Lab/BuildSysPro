within BuildSysPro.BaseClasses.HeatTransfer.Components;
model HeatCapacitor "Heat capacitor"
  parameter Modelica.SIunits.HeatCapacity C
    "Heat capacity of the element (= cp*m)";

 Modelica.SIunits.Temperature T( displayUnit="degC")
    "Temperature of the element";
  Modelica.SIunits.TemperatureSlope der_T(start=0)
    "Time derivative of the temperature (= der(T))";

  BaseClasses.HeatTransfer.Interfaces.HeatPort_a port annotation (Placement(
        transformation(extent={{-10,-90},{10,-70}},rotation=0),
        iconTransformation(extent={{-10,-90},{10,-70}})));

equation
  T = port.T;
  der_T = der(T);
  C*der(T) = port.Q_flow;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(extent={{-139,139},{140,80}}, textString="%name"),
        Polygon(
          points={{0,77},{-20,73},{-40,67},{-52,53},{-58,45},{-68,35},{-72,23},
              {-76,9},{-78,-5},{-76,-21},{-76,-33},{-76,-43},{-70,-55},{-64,-63},
              {-48,-67},{-30,-73},{-18,-73},{-2,-75},{8,-79},{22,-79},{32,-77},
              {42,-71},{54,-65},{56,-63},{66,-51},{68,-43},{70,-41},{72,-25},{
              76,-11},{78,-3},{78,13},{74,25},{66,35},{54,43},{44,51},{36,67},{
              26,75},{0,77}},
          lineColor={160,160,164},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,45},{-68,35},{-72,23},{-76,9},{-78,-5},{-76,-21},{-76,
              -33},{-76,-43},{-70,-55},{-64,-63},{-48,-67},{-30,-73},{-18,-73},
              {-2,-75},{8,-79},{22,-79},{32,-77},{42,-71},{54,-65},{42,-67},{40,
              -67},{30,-69},{20,-71},{18,-71},{10,-71},{2,-67},{-12,-63},{-22,
              -63},{-30,-61},{-40,-55},{-50,-45},{-56,-33},{-58,-25},{-58,-15},
              {-60,-3},{-60,5},{-60,17},{-58,27},{-56,29},{-52,37},{-48,45},{
              -44,55},{-40,67},{-58,45}},
          lineColor={0,0,0},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-69,17},{71,-14}},
          lineColor={0,0,0},
          textString="%C")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                    graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is a generic model for the heat capacity of a material. No specific geometry is assumed beyond a total volume with uniform temperature for the entire volume. Furthermore, it is assumed that the heat capacity is constant (indepedent of temperature). </p>
<p>The temperature T [Kelvin] of this component is a <b>state</b>. A default of T = 25 degree Celsius (= SIunits.Conversions.from_degC(25)) is used as start value for initialization. This usually means that at start of integration the temperature of this component is 25 degrees Celsius. You may, of course, define a different temperature as start value for initialization. Alternatively, it is possible to set parameter <b>steadyStateStart</b> to <b>true</b>. In this case the additional equation '<b>der</b>(T) = 0' is used during initialization, i.e., the temperature T is computed in such a way that the component starts in <b>steady state</b>. This is useful in cases, where one would like to start simulation in a suitable operating point without being forced to integrate for a long time to arrive at this point. </p>
<p>Note, that parameter <b>steadyStateStart</b> is not available in the parameter menue of the simulation window, because its value is utilized during translation to generate quite different equations depending on its setting. Therefore, the value of this parameter can only be changed before translating the model. </p>
<p>This component may be used for complicated geometries where the heat capacity C is determined my measurements. If the component consists mainly of one type of material, the <b>mass m</b> of the component may be measured or calculated and multiplied with the <b>specific heat capacity cp</b> of the component material to compute C: </p>
<pre>   C = cp*m.
   Typical values for cp at 20 degC in J/(kg.K):
      aluminium   896
      concrete    840
      copper      383
      iron        452
      silver      235
      steel       420 ... 500 (V2A)
      wood       2500</pre>
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
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">HeatCapacitor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end HeatCapacitor;
