within BuildSysPro.Systems.DHW.HeatPump.Components;
model WaterHeaterHeatPumpPoly
  "Polynomial model of air-source heat pump for water heating"

  parameter Modelica.Units.SI.Power Pe_max=670
    "Maximum absorbed power by the heat pump unit at 7°C external air, 50Hz and a water temperature of 55°C";
  parameter Modelica.Units.SI.Time t_heating=25750
    "Heat-up time at 7°C external air for 10->55°C in tank";
  parameter Modelica.Units.SI.Volume V_tank=0.2
    "Heat-up time at 7°C external air for 10->55°C in tank";
   parameter Real n_inverter=0.95 "Inverter compressor efficiency";

   // Reference Model specifications
protected
  final constant Modelica.Units.SI.Power Pe_max_ref=670
    "Maximum absorbed power by the heat pump unit at 7°C external air, 50Hz and a water temperature of 55°C";
  final constant Modelica.Units.SI.Power Pe_fan_ref=67 "Fixed speed fan power";
  final constant Modelica.Units.SI.Time t_heating_ref=25750
    "Atlantic heat-up time at 7°C external air for 10->55°C in tank";
  final constant Modelica.Units.SI.Volume V_tank_ref=0.2
    "Heat-up time at 7°C external air for 10->55°C in tank";

parameter Real[10] Pe_poly_coefs={3.83165093e+04,  -4.34394686e+01,   3.26439628e-02,
        -8.95488047e+01,   4.10985298e-02,  -1.76706502e+02,
         1.84455287e-01,   2.36017967e-01,   8.12744660e-02,
         8.67503132e-02};

parameter Real[10] Pq_poly_coefs={ -1.93054762e+04,  -9.62000742e+01,  -9.94034808e-02,
         1.37286021e+02,  -9.70387915e-02,  -2.73772378e+01,
         2.44497450e-01,  -2.96119602e-01,   5.95326565e-01,
        -9.68183381e-02};

public
  Real Pe_fan(start=0);

  Modelica.Blocks.Interfaces.RealInput T_water
    annotation (Placement(transformation(extent={{-140,44},{-100,84}})));
  Modelica.Blocks.Interfaces.RealInput T_air
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput speed
    annotation (Placement(transformation(extent={{-140,-86},{-100,-46}})));
  Modelica.Blocks.Interfaces.BooleanInput OnOff annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,118})));

  Modelica.Blocks.Interfaces.RealOutput Pe_comp
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput Pe_tot
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput COP_comp
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput COP_tot
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput Pq_cond
    annotation (Placement(transformation(extent={{100,62},{120,82}})));
equation

  Pe_comp=if (OnOff) then (Pe_max/Pe_max_ref)*(Pe_poly_coefs[1]+Pe_poly_coefs[2]*speed+Pe_poly_coefs[3]*speed^2+Pe_poly_coefs[4]*T_water+Pe_poly_coefs[5]*T_water^2+Pe_poly_coefs[6]*T_air+Pe_poly_coefs[7]*T_air^2+Pe_poly_coefs[8]*T_air*T_water+Pe_poly_coefs[9]*T_air*speed+Pe_poly_coefs[10]*T_water*speed) else -1e-4;

  Pq_cond=if (OnOff) then -(t_heating_ref/t_heating)*(V_tank/V_tank_ref)*(Pq_poly_coefs[1]+Pq_poly_coefs[2]*speed+Pq_poly_coefs[3]*speed^2+Pq_poly_coefs[4]*T_water+Pq_poly_coefs[5]*T_water^2+Pq_poly_coefs[6]*T_air+Pq_poly_coefs[7]*T_air^2+Pq_poly_coefs[8]*T_air*T_water+Pq_poly_coefs[9]*T_air*speed+Pq_poly_coefs[10]*T_water*speed) else                                                                                                                                                                                                     -1e-4;

  Pe_fan=if (OnOff) then Pe_fan_ref*(Pe_max/Pe_max_ref) else 0;
  Pe_tot=Pe_comp/n_inverter+Pe_fan;
  COP_comp=sum(-Pq_cond)/noEvent(max(Pe_comp,1e-4));
  COP_tot=sum(-Pq_cond)/noEvent(max(Pe_tot,1e-4));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Text(
          extent={{-66,26},{64,-42}},
          lineColor={0,0,255},
          textString="PolyPAC HPWH
")}), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
           graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-66,64},{74,-70}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{6,-10},{74,10}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,-2},{14,64}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,-68},{12,-2}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-66,-12},{2,8}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>A quasi steady state polynomial air source heat pump for heat pump water heating application.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Air to water heat pump for an external air source heat pump water heater (ASHPWH) with mantle heat exchanger including both fixed and variable speed compressor.</p>
<p>Polynomial model extrapolatable to various ASHPWH sizes using linear extrapolation based on manufacturer data : heating time, maximum compressor power and tank volume.</p>
<p>Quasi-steady state model based on air temperature, tank water temperature and compressor speed.</p>
<p>Built upon a detailed model neglecting :
<ul><li>Oil circulation and accumulation</li>
<li>Frost growth (shown to be neglegible for ASHPWHs - K. R. Deutz 2018)</li>
<li>Compressor inertia (quasi-steady state heat pump)</li></ul></p>
<p>System reference configuration :
<ul><li>200L water tank</li>
<li>Maximum compressor reference power = 670W</li>
<li>Heating time = 25750s </li>
<li>13cm3 variable speed compressor</li>
<li>Mantle heat exchanger condenser</li></ul></p>
<p><u><b>Bibliography</b></u></p>
<p>See K. R. Deutz PhD Thesis 04/2018</p>
<p><a href=\"modelica://BuildSysPro/Resources/Documentation/Modeling%20and%20Experimental%20Study%20of%20a%20Heat%20Pump%20Water%20Heater%20Cycle.pdf\">Modeling and Experimental Study of a Heat Pump Water Heater Cycle</a> - Purdue Conference - K. R. Deutz 2016</p>
<p><a href=\"modelica://BuildSysPro/Resources/Documentation/Second%20Order%20Polynomial%20Regression%20for%20a%20standard%20Heat%20Pump%20Water%20Heater%20thermal%20Capacity%20Control%20Algorithm.pdf\">Second Order Polynomial Regression for a standard Heat Pump Water Heater thermal Capacity Control Algorithm</a> - K. R. Deutz 2017</p>
<p>Detailed and dynamic air source heat pump water heater model : combining a zonal tank model approach with a grey box heat pump model - Applied Energy - K. R. Deutz 2018</p>
<p><u><b>Instructions for use</b></u></p>
<p><ol><li>Take constructor catalogue and fill in the required parameters</li>
<li>Couple with a tank model for the water temperature</li>
<li>Couple with a weather file for the external air temperature</li>
<li>Couple with boolean on/off signal with a controller model</li>
<li>Couple speed with a controller model or a real constant 50Hz input if using fixed speed compressor and take inverter</li></ol></p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Guaranteed validity range :
<ul><li>Air temperatures : from -5&deg;C to 25&deg;C</li>
<li>Water temperatures : from 25&deg;C to 55&deg;C</li>
<li>Compressor speeds : from 30Hz to 120Hz</li></ul></p>
<p>Watch for simulation results outside the validity range and extrapolation</p>
<p><u><b>Validations</b></u></p>
<p>COP, electric power and thermal capacity validated model.</p>
<p>COP, electric power and thermal capacity validated experimentally on air temperatures ranging from -3&deg;C to 20&deg;C and compressor speeds ranging from 30Hz to 120Hz.</p>
<p>Validated model - Kévin Deutz 08/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Kévin DEUTZ, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WaterHeaterHeatPumpPoly;
