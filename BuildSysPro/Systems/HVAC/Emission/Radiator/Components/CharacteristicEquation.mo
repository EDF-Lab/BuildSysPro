within BuildSysPro.Systems.HVAC.Emission.Radiator.Components;
partial model CharacteristicEquation
  "Model for characteristic equation of a radiator (EN442)"
 import      Modelica.Units.SI;

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

  final parameter Real Km=Pnom/DTnom^nNom
    "Km coefficient (sometimes refers as KS or UA coefficient) used in the Characteristic equation";

  BaseClasses.HeatTransfer.Interfaces.HeatPort_b   Rad
    "HeatPort for long wave radiation exchanges" annotation (
      Placement(transformation(extent={{-30,70},{-10,90}}),
        iconTransformation(extent={{-40,60},{-20,80}})));

  BaseClasses.HeatTransfer.Interfaces.HeatPort_b             Conv
    "HeatPort for convective heat transfers" annotation (Placement(
        transformation(extent={{30,70},{50,90}}), iconTransformation(
          extent={{20,60},{40,80}})));

  replaceable BuildSysPro.Systems.HVAC.Emission.Radiator.Components.BasedCharacteristicEquation1
    radEqua(
    Pnom=Pnom,
    DTnom=DTnom,
    nNom=nNom,
    FracRad=FracRad,
    Km=Km) constrainedby
    BuildSysPro.Systems.HVAC.Emission.Radiator.Components.BasedCharacteristicEquation
                                                     annotation (
    choices(choice(redeclare
          BuildSysPro.Systems.HVAC.Emission.ElectricHeater.Components.BasedCharacteristicEquation1
          radEqua
          "Simplified : Room temperature based on average between radiative and convective temperatures"),
        choice(redeclare
          BuildSysPro.Systems.HVAC.Emission.ElectricHeater.Components.BasedCharacteristicEquation2
          radEqua
          "Detailed   : Distinction between radiative and convective temperatures for heat transfers")),
    Placement(transformation(extent={{-10,-10},{10,10}})),
    Dialog(group="Options"));

equation
  connect(radEqua.Rad, Rad) annotation (Line(points={{-3,7},{-3,40},{-20,40},{-20,
          80}}, color={191,0,0}));
  connect(radEqua.Conv, Conv)
    annotation (Line(points={{3,7},{3,20},{40,20},{40,80}}, color={191,0,0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Authors : Gilles PLESSIS, Hassan BOUIA EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end CharacteristicEquation;
