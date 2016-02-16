within BuildSysPro.Systems.HVAC.Emission.Examples;
model RadiatorEN442_Test "Example to test the HotWaterRadiator model"
  import BuildSysPro;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.EnergyFlowRate Pnom=411;
  parameter Real nNom=1.225 "Slope at nominal point";

    // Variables
     Modelica.SIunits.Temperature Tinlet;
     Modelica.SIunits.Temperature Toutlet;
    // Components
  BuildSysPro.Systems.HVAC.Emission.Radiator.Radiator_EN442 Radiator(
    Pnom=Pnom,
    nNom=nNom,
    redeclare BuildSysPro.Systems.HVAC.Components.BasedCharacteristicEquation1
      radEqua
      "Simplified : Room temperature based on average between radiative and convective temperatures",
    MediumMass=0.1,
    BodyMass=0.1,
    FracRad=0.35,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    useInertia=false)
    annotation (Placement(transformation(extent={{-12,-4},{8,16}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tconv(T=293.15)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Trad(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,70})));
  Modelica.Blocks.Sources.RealExpression m_flow_inlet(y=m_flow)
    annotation (Placement(transformation(extent={{-74,-6},{-54,14}})));
    Real DTAM;
Real m_flow;
  Modelica.Blocks.Sources.RealExpression Qradiator(y=m_flow*Radiator.Medium.cp_const*(Tinlet-Toutlet))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Step InletT(
    offset=273.15 + 75,
    height=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-78,24},{-58,44}})));
equation
  DTAM=(Tinlet+Toutlet)/2-Tconv.T;
  m_flow=Pnom/(Radiator.Medium.cp_const*(Tinlet
         - Toutlet));
  Tinlet=Radiator.EntreeEau[1];
  Toutlet=Radiator.SortieEau[1];
  connect(Tconv.port, Radiator.Rad)
    annotation (Line(points={{-20,70},{-5,70},{-5,13}},color={191,0,0}));
  connect(Trad.port, Radiator.Conv)
    annotation (Line(points={{20,70},{1,70},{1,13}},color={191,0,0}));
  connect(m_flow_inlet.y, Radiator.EntreeEau[2]) annotation (Line(points={{-53,4},
          {-32,4},{-32,11.5},{-11,11.5}},
                                        color={0,0,127}));
  connect(InletT.y, Radiator.EntreeEau[1]) annotation (Line(points={{-57,34},{
          -34,34},{-34,10.5},{-11,10.5}},
                                    color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-12,4},{102,-90}},
          lineColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="Nominal operating point :
Tinlet =75°C and Toutlet = 65°C
Troom= 20°C

Nnom=1.225
Pnom=411 W
Weight = 9 kg",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=20000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end RadiatorEN442_Test;
