within BuildSysPro.Systems.DHW.HeatPump.Components;
model StratifiedWaterTank
  "Stratified water tank"

  // Initialization
  parameter Modelica.Units.SI.Temperature initialTemperature=10 + 273.15
    "Initial water temperature in the tank [K]";

  // Tank geometry
  parameter Modelica.Units.SI.Volume tankVolume=0.2 "Tank volume [m3]";
  parameter Modelica.Units.SI.Height tankHeight=1.7 "Tank height [m]";
  parameter Modelica.Units.SI.ThermalConductance UA=10
    "Insulating heat transfer coefficient [W/K]";
  parameter Integer nCells=10 "Number of cells";
  parameter Integer iHX_top=5 "Top condenser position";
  parameter Integer iHX_bottom=2 "Bottom condenser position";
  parameter Integer iAux_top=3 "Top auxiliary position";
  parameter Integer iAux_bottom=1 "Bottom auxiliary position";
  parameter Integer i_sensor=1 "Temperature sensor position";

  final parameter Modelica.Units.SI.Area tankSurface=tankVolume/tankHeight
    "Floor surface of the tank in m2";

  // Boundary conditions
  parameter Modelica.Units.SI.Temperature T_amb=20 + 273.15
    "Ambient temperature [K]";

  // Auxiliary element
  parameter Modelica.Units.SI.Power auxiliaryPower=1800
    "Fixed heating power of the auxiliary heater [W]";

  // Tank unknowns
  Modelica.Units.SI.Temperature T_tank[nCells](
    each start=initialTemperature,
    fixed=true)
    "Vector containing the water temperature of each layer [K]";
  Modelica.Units.SI.Energy E_stored(start=0)
    "Energy stored in the tank [J]";
  Modelica.Units.SI.Power P_loss(start=0)
    "Power losses [W]";

  Modelica.Blocks.Interfaces.RealInput m_flow
    "Inlet cold water mass flow rate [kg/s]"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-20,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-120})));

  Modelica.Blocks.Interfaces.RealInput T_in "Inlet cold water temperature [K]"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));

  Modelica.Blocks.Interfaces.BooleanInput onOffAuxiliary
    "Boolean for switching on/off the auxiliaries"
    annotation (Placement(transformation(extent={{-120,-60},{-80,-20}}),
        iconTransformation(extent={{-120,-60},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput T_sensor
    "Temperature of the sensor [K]"
    annotation (Placement(transformation(extent={{100,20},{120,40}}),
        iconTransformation(extent={{100,20},{120,40}})));

protected
  Modelica.Units.SI.Power electricPower[nCells];
  Modelica.Units.SI.Power thermalPower[nCells];
  Modelica.Units.SI.Power heatLoss[nCells];
  Modelica.Units.SI.Power conv[nCells];
  Modelica.Units.SI.ThermalConductance cond=lambda*tankSurface/(tankHeight/
      nCells);

  // Water thermo-hydraulic properties

  constant Modelica.Units.SI.Density rho_water=1000 "Water density";
  constant Modelica.Units.SI.SpecificHeatCapacityAtConstantPressure cp=4185
    "Water specific heat capacity";
  constant Modelica.Units.SI.ThermalConductivity lambda=0.62
    "Water thermal conductivity";
  constant Modelica.Units.SI.CoefficientOfHeatTransfer kup=1e6
    "Higher convection coefficient";
  constant Modelica.Units.SI.CoefficientOfHeatTransfer kdown=10
    "Higher convection coefficient";
  constant Modelica.Units.SI.Temperature T_en_base_tank=10 + 273.15
    "Base temperature for energy calculation";
public
  Modelica.Blocks.Interfaces.RealInput heatInput
    "Injected heat power [W]"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,40})));

  // Thermocline development model
  Integer i_thermocline(start=1);
  Boolean convection[iHX_top-iHX_bottom+1];

algorithm

   for  i in iHX_bottom:iHX_top loop
     if abs(heatInput)>100 and m_flow<1e-4 and not convection[i-iHX_bottom+1] then
       i_thermocline:=i-1;
       break;
     elseif abs(heatInput)>100 and m_flow<1e-4 then
       i_thermocline:=iHX_top;
     else
       i_thermocline:=iHX_bottom;
     end if;
   end for;

equation

  convection[1]=true;
  for i in iHX_bottom+1:iHX_top loop
     convection[i-iHX_bottom+1]=(pre(convection[i-iHX_bottom+1]) or (T_tank[i-iHX_bottom] >= T_tank[i-iHX_bottom+1]-1*(tankHeight/nCells)/0.043)) and (convection[i-iHX_bottom] and abs(heatInput)>100 and m_flow<1e-4);
  end for;

  T_sensor=T_tank[i_sensor];

  // Distribution of powers transferred to the water per layer

  for i in 1:nCells loop

    if i>=iAux_bottom and i<=iAux_top and onOffAuxiliary then
      electricPower[i]= -auxiliaryPower/(iAux_top-iAux_bottom+1);
    else
      electricPower[i]= 0;
    end if;

    if i>=iHX_bottom and i<=iHX_top then
      thermalPower[i]=if convection[i-iHX_bottom+1] then heatInput/(i_thermocline-iHX_bottom+1) else 0;
    else
       thermalPower[i]=0;
     end if;

  end for;

  // If there is just one layer there can be no conduction -> mixed tank
  if nCells>2 then
    conv[1]=(if T_tank[1] > T_tank[2] then kup else kdown)*tankSurface*(T_tank[2] - T_tank[1]);
  else
    conv[1]=0;
  end if;

  // Heat balance on the layer 1 after setting exchanges with the room (loss) and with upper and lower layers (conv)

  der(T_tank[1])=-(-(conv[1])+electricPower[1]+thermalPower[1]+m_flow*cp*(T_tank[1]-T_in)+ heatLoss[1]+ (if nCells==1 then 0 else -cond*(T_tank[2]-T_tank[1])))/(cp*rho_water*tankVolume/nCells);
  heatLoss[1]=(UA/nCells)*(T_tank[1]-T_amb);

  // Heat balance on intermediate layers

  for i in 2:nCells-1 loop

     conv[i]=(if T_tank[i] > T_tank[i + 1] then kup else kdown)*tankSurface*(T_tank[i + 1] - T_tank[i]);
     der(T_tank[i])=-(electricPower[i]+thermalPower[i]+m_flow*cp*(T_tank[i]-T_tank[i-1])+heatLoss[i]-(conv[i]-conv[i-1]) -cond*(T_tank[i-1]+T_tank[i+1]-2*T_tank[i]))/(cp*rho_water*tankVolume/nCells);
     heatLoss[i]=(UA/nCells)*(T_tank[i]-T_amb);

  end for;

  // Heat balance on the upper layer

  der(T_tank[nCells])=-(electricPower[nCells]+thermalPower[nCells]+m_flow*cp*(T_tank[nCells]-T_tank[nCells-1])+heatLoss[nCells] -(conv[nCells]-conv[nCells-1]) -cond*(T_tank[nCells-1]-T_tank[nCells]))/(cp*rho_water*tankVolume/nCells);
  conv[nCells]=0;
  heatLoss[nCells]=(UA/nCells)*(T_tank[nCells]-T_amb);

  // Analysis data
  P_loss=sum(heatLoss);
  E_stored=sum((tankVolume/nCells)*rho_water*cp*(T_tank[i]-T_en_base_tank) for i in 1:nCells);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-100},
            {100,140}})),                 Icon(coordinateSystem(extent={{-80,-100},
            {100,140}}, preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,54},{100,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-80,140},{100,-8}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-36,-8},{56,-8}},
          color={255,85,85},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model of a 1D stratified water tank using inversed gradient mixing coefficient and a power distribution model for MHW condenser tanks.</p>
<p>Used in <a href=\"BuildSysPro.Systems.DHW.HeatPump.HPWaterHeaterPoly_Stratified\"><code>HPWaterHeaterPoly_Stratified</code></a> model.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Kévin Deutz 08/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Kévin DEUTZ, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Deutz K&eacute;vin 07/2020 : correction of an error in the energy calculation (sum over the whole tank volume instead of sum over the cells volume) </p>
</html>"));
end StratifiedWaterTank;
