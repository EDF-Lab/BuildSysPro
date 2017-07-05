within BuildSysPro.Systems.HVAC.Emission.Radiator.Components;
partial model BasedCharacteristicEquation
  "Partial model for characteristic equation of a radiator (EN442)"
 import SI = Modelica.SIunits;
  parameter SI.EnergyFlowRate Pnom=411
    "Nominal power for a DT=50 K, based on inlet temperature 75/65"
    annotation(Dialog(group = "EN442 - Nominal point"));

  parameter SI.TemperatureDifference DTnom=50
    "Temperature difference (air to water) at nominal operating point"
    annotation(Dialog(group = "EN442 - Nominal point"));

  parameter Real nNom=1.225 "Slope at nominal point"
    annotation(Dialog(group = "EN442 - Nominal point"));
  // Other parameters
  parameter Real FracRad(min=0, max=1) = 0.35 "Radiative fraction of heat"
    annotation(Dialog(group = "EN442 - Nominal point"));

  parameter Real Km=Pnom/DTnom^nNom
    "Km coefficient (sometimes refers as KS or UA coefficient) used in the Characteristic equation";

    // Variables
  outer SI.Temperature   T_HWR(start=273.15+60)
    "Temperature of the hot water radiator";

SI.EnergyFlowRate  Qtot "Heating power output from the radiator";
  //Components
  BaseClasses.HeatTransfer.Interfaces.HeatPort_b   Rad
    "HeatPort for long wave radiation exchanges"     annotation (
      Placement(transformation(extent={{-30,70},{-10,90}}),
        iconTransformation(extent={{-40,60},{-20,80}})));

  BaseClasses.HeatTransfer.Interfaces.HeatPort_b             Conv
    "HeatPort for convective heat transfers"     annotation (Placement(
        transformation(extent={{30,70},{50,90}}), iconTransformation(
          extent={{20,60},{40,80}})));
equation
  Qtot=-(Conv.Q_flow+Rad.Q_flow);
  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Authors : Gilles PLESSIS, Hassan BOUIA EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end BasedCharacteristicEquation;
