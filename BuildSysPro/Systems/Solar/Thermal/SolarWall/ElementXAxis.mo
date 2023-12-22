within BuildSysPro.Systems.Solar.Thermal.SolarWall;
model ElementXAxis "\"static solar active wall slice\""

  parameter Modelica.Units.NonSI.Temperature_degC Tstart=25;
  parameter Modelica.Units.SI.Area S=1 "active wall area";
  parameter Integer n_isol_f=5 "number of front face meshes";
parameter Integer n_stock=5 "number of stock meshes";
parameter Integer n_isol_b=3 "number of back side meshes";
  parameter Modelica.Units.SI.Length e_isol_f=0.16
    "front face insulation thickness";
  parameter Modelica.Units.SI.Length e_isol_b=0.03
    "back face insulation thickness";
  parameter Modelica.Units.SI.Length e_stock=0.2 "stock thickness";

  parameter BuildSysPro.Utilities.Records.GenericSolid mat_isol_f=
      BuildSysPro.Utilities.Data.Solids.MineralWool40()
    "transparent insulation";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat_stock=
      BuildSysPro.Utilities.Data.Solids.Concrete() "stock";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat_isol_b=
      BuildSysPro.Utilities.Data.Solids.MineralWool40() "stock insulation";

  parameter Modelica.Units.SI.ThermalConductance hsol=100
    "exchange coefficient pipe/wall";

  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tf "front panel temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Interfaces.RealInput G
    " solar flux absorbed on the element" annotation (Placement(
        transformation(extent={{-120,52},{-80,92}})));
  BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow SolaireTransmis
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tfluide
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  BaseClasses.HeatTransfer.Components.ThermalConductor EchangeTubeParoi(G=hsol)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,40})));
  BaseClasses.HeatTransfer.Components.HomogeneousConduction Stock(
    S=S,
    e=e_stock,
    n=n_stock,
    mat=BuildSysPro.Utilities.Data.Solids.Concrete())
    annotation (Placement(transformation(extent={{-18,-56},{2,-36}})));

  BaseClasses.HeatTransfer.Components.HomogeneousConduction IsolationStock(
    S=S,
    e=e_isol_b,
    n=n_isol_b,
    mat=BuildSysPro.Utilities.Data.Solids.MineralWool40())
    annotation (Placement(transformation(extent={{6,-56},{26,-36}})));

  BaseClasses.HeatTransfer.Components.HomogeneousConduction IsolantTransparent(
    S=S,
    e=e_isol_f,
    n=n_isol_f,
    mat(
      rho=32,
      lambda=0.06,
      c=1000)) annotation (Placement(transformation(extent={{-72,0},{-52,20}})));

  BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tb
    "back panel temperature"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  BaseClasses.HeatTransfer.Components.ThermalConductor EchangeGlobal_b(G=7.7*S)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-12})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Temetteur annotation (
      Placement(transformation(extent={{52,-22},{72,-2}}), iconTransformation(
          extent={{50,0},{70,20}})));

  BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow ApportEnthalpiqueNet
    annotation (Placement(transformation(extent={{-84,-56},{-64,-36}})));
  Modelica.Blocks.Interfaces.RealInput debit_s "enthalpy supply"
                                          annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-30,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-30,-120})));
  BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow ApportEnthalpiqueNet1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={76,54})));
  Modelica.Blocks.Interfaces.RealInput debit_e "enthalpy supply"
                                          annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={72,96}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
equation
  connect(G, SolaireTransmis.Q_flow)    annotation (Line(
      points={{-100,72},{-82.5,72},{-82.5,84},{-80,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tf, IsolantTransparent.port_a) annotation (Line(
      points={{-90,10},{-80.5,10},{-80.5,10.2},{-71,10.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Stock.port_b, IsolationStock.port_a) annotation (Line(
      points={{1,-46},{4,-46},{4,-45.8},{7,-45.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SolaireTransmis.port, IsolantTransparent.port_b)
    annotation (Line(
      points={{-60,84},{-53,84},{-53,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(IsolantTransparent.port_b, EchangeTubeParoi.port_b)
    annotation (Line(
      points={{-53,10},{-48,10},{-48,40},{-39,40}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(EchangeTubeParoi.port_a, Tfluide) annotation (Line(
      points={{-21,40},{-10,40},{-10,10},{-30,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(IsolantTransparent.port_b, Stock.port_a) annotation (Line(
      points={{-53,10},{-48,10},{-48,-50},{-17,-50},{-17,-45.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ApportEnthalpiqueNet.port, Tfluide)
                                             annotation (Line(
      points={{-64,-46},{-56,-46},{-56,-28},{-30,-28},{-30,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(debit_e, ApportEnthalpiqueNet1.Q_flow)
                                               annotation (Line(
      points={{72,96},{74,96},{74,64},{76,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ApportEnthalpiqueNet1.port, Temetteur)
                                               annotation (Line(
      points={{76,44},{76,18.5},{62,18.5},{62,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Temetteur, EchangeGlobal_b.port_b) annotation (Line(
      points={{62,-12},{69.5,-12},{69.5,-12},{77,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangeGlobal_b.port_a, Tb) annotation (Line(
      points={{95,-12},{98,-12},{98,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(IsolationStock.port_b, Temetteur) annotation (Line(
      points={{25,-46},{32,-46},{32,-12},{62,-12}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(debit_s, ApportEnthalpiqueNet.Q_flow) annotation (Line(
      points={{-30,-100},{-30,-70},{-90,-70},{-90,-46},{-84,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics), Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-20,100},{30,-100}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-80,100},{-40,-100}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-40,100},{-20,20}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,0},{-20,-100}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,100},{50,-100}},
          lineColor={215,215,215},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Emmanuel AMY DE LA BRETEQUE, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ElementXAxis;
