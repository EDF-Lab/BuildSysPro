within BuildSysPro.BaseClasses.HeatTransfer.Components;
model HeatCapacitor "Heat capacitor"
  parameter Modelica.SIunits.HeatCapacity C
    "Heat capacity of the element (= cp*m)";

 Modelica.SIunits.Temperature T( displayUnit="degC")
    "Temperature of the element";
  Modelica.SIunits.TemperatureSlope der_T(start=0)
    "Time derivative of the temperature (= der(T))";

  BaseClasses.HeatTransfer.Interfaces.HeatPort_a port annotation (Placement(
        transformation(extent={{0,-100},{20,-80}}, rotation=0)));

equation
  T = port.T;
  der_T = der(T);
  C*der(T) = port.Q_flow;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(extent={{-119,131},{141,80}}, textString="%name"),
        Polygon(
          points={{10,77},{-10,73},{-30,67},{-42,53},{-48,45},{-58,35},
              {-62,23},{-66,9},{-68,-5},{-66,-21},{-66,-33},{-66,-43},
              {-60,-55},{-54,-63},{-38,-67},{-20,-73},{-8,-73},{8,-75},
              {18,-79},{32,-79},{42,-77},{52,-71},{64,-65},{66,-63},{
              76,-51},{78,-43},{80,-41},{82,-25},{86,-11},{88,-3},{88,
              13},{84,25},{76,35},{64,43},{54,51},{46,67},{36,75},{10,
              77}},
          lineColor={160,160,164},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,45},{-58,35},{-62,23},{-66,9},{-68,-5},{-66,-21},
              {-66,-33},{-66,-43},{-60,-55},{-54,-63},{-38,-67},{-20,
              -73},{-8,-73},{8,-75},{18,-79},{32,-79},{42,-77},{52,-71},
              {64,-65},{52,-67},{50,-67},{40,-69},{30,-71},{28,-71},{
              20,-71},{12,-67},{-2,-63},{-12,-63},{-20,-61},{-30,-55},
              {-40,-45},{-46,-33},{-48,-25},{-48,-15},{-50,-3},{-50,5},
              {-50,17},{-48,27},{-46,29},{-42,37},{-38,45},{-34,55},{
              -30,67},{-48,45}},
          lineColor={0,0,0},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-59,17},{81,-14}},
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
BuildSysPro version 2.1.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">HeatCapacitor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end HeatCapacitor;
