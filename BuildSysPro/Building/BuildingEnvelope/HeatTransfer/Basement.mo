within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model Basement "Buried basement"

  parameter Real Hauteur=2.2 "Height";
  parameter Real Longueur=10 "Length";
  parameter Real Largeur=5 "Width";
  parameter Real Sgarage=2*3 "Garage surface";
  parameter Real hc_lat=9 "Side wall convective coefficient";
  parameter Real hc_plancher=5 "Floor convective coefficient";
  parameter Real Ugarage=1/16+1/9 "Garage transmission coefficient";
  parameter Real TauRVT=0.2 "Air renewal rate";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat_Sol
    annotation (choicesAllMatching=true);
  parameter BuildSysPro.Utilities.Records.GenericSolid mat_Lat
    annotation (choicesAllMatching=true);
  parameter BuildSysPro.Utilities.Records.GenericSolid mat_Pla
    annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Temperature Tinit=281.15;
protected
  final parameter Real Perimetre=2*(Longueur*Largeur);
  final parameter Real Splancher=Longueur*Largeur;
  final parameter Real Slaterale=Perimetre*Hauteur-Sgarage;
  final parameter Real Volume=Hauteur*Splancher;

public
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor NoeudAir(
    C=1.2*720*Volume,
    der_T(fixed=true),
    T(fixed=false, start=281.15)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,6})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Gplancher(G=hc_plancher*Splancher)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-36})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Glateral(G=hc_lat*Slaterale)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={16,-10})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TsolLat
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,-10})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TsolPlancher
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-82})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Rvt(G=0.34*TauRVT*Volume)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-44,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor PorteGarage(G=Ugarage*Sgarage) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,10})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outdoor temperature" annotation (Placement(transformation(extent={{-110,0},
            {-90,20}}), iconTransformation(extent={{-110,0},{-90,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a T_int
    "Indoor temperature" annotation (Placement(transformation(extent={{-110,-24},
            {-90,-4}}), iconTransformation(extent={{-10,0},{10,20}})));
  BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall
    paroiNCouchesHomogenes3(
    n=1,
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()},
    m={180},
    e={9}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,44})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{60,44},{80,64}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        283.15) annotation (Placement(transformation(extent={{14,14},{34,34}})));
  BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall
    paroiNCouchesHomogenes4(
    n=1,
    m={20},
    e={1},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()}) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,68})));
  BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall
    paroiNCouchesHomogenes5(
    n=1,
    m={20},
    e={1},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()}) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-12,-68})));
  BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall
    paroiNCouchesHomogenes2(
    n=1,
    m={20},
    e={1},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()}) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,-8})));
equation

  connect(NoeudAir.port, Glateral.port_a) annotation (Line(
      points={{-10,-4},{-10,-10},{6,-10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Rvt.port_a, NoeudAir.port) annotation (Line(
      points={{-44,0},{-44,-4},{-10,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PorteGarage.port_a, NoeudAir.port) annotation (Line(
      points={{-70,0},{-70,-4},{-10,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, PorteGarage.port_b) annotation (Line(
      points={{-100,10},{-86,10},{-86,28},{-70,28},{-70,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, Rvt.port_b) annotation (Line(
      points={{-100,10},{-86,10},{-86,28},{-44,28},{-44,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Gplancher.port_a, NoeudAir.port) annotation (Line(
      points={{-10,-26},{-10,-15},{-10,-15},{-10,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(NoeudAir.port, T_int) annotation (Line(
      points={{-10,-4},{-10,-14},{-100,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, paroiNCouchesHomogenes3.port_b) annotation (
      Line(
      points={{34,24},{40,24},{40,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiNCouchesHomogenes4.port_a, T_ext) annotation (Line(
      points={{40,77},{42,77},{42,80},{-100,80},{-100,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiNCouchesHomogenes4.port_b, paroiNCouchesHomogenes3.port_a)
    annotation (Line(
      points={{40,59},{40,53}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiNCouchesHomogenes4.port_b, temperatureSensor.port) annotation (
      Line(
      points={{40,59},{52,59},{52,54},{60,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, TsolLat.T) annotation (Line(
      points={{80,54},{96,54},{96,-10},{86,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, TsolPlancher.T) annotation (Line(
      points={{80,54},{94,54},{94,-82},{82,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Glateral.port_b, paroiNCouchesHomogenes2.port_a) annotation (Line(
      points={{26,-10},{32,-10},{32,-8},{37,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiNCouchesHomogenes2.port_b, TsolLat.port) annotation (Line(
      points={{55,-8},{60,-8},{60,-10},{64,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiNCouchesHomogenes5.port_a, Gplancher.port_b) annotation (Line(
      points={{-12,-59},{-12,-46},{-10,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiNCouchesHomogenes5.port_b, TsolPlancher.port) annotation (Line(
      points={{-12,-77},{24,-77},{24,-82},{60,-82}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,255},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,56},{-56,-56}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,24},{12,16}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,16},{12,8}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,8},{12,0}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,0},{12,-8}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,-8},{12,-16}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,-16},{12,-24}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,-24},{12,-32}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,-32},{12,-40}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,-40},{12,-48}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-50,-48},{12,-56}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Text(
          extent={{-62,92},{66,66}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model of a buried basement.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 09/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Basement;
