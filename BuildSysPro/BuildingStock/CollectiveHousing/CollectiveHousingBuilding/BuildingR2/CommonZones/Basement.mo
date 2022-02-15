within BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.CommonZones;
model Basement "Basement for complete collective housing assembly"

// Temperatures of interest
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température exterieure" annotation (Placement(transformation(extent=
           {{-100,40},{-80,60}}), iconTransformation(extent={{-10,-100},{
            10,-80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin
    "Upper Gauguin apartment temperature" annotation (Placement(transformation(
          extent={{-100,-10},{-80,10}}), iconTransformation(extent={{-100,-10},
            {-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso
    "Upper Picasso apartment temperature" annotation (Placement(transformation(
          extent={{-100,-60},{-80,-40}}), iconTransformation(extent={{80,-40},{
            100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse
    "Upper Matisse apartment temperature" annotation (Placement(transformation(
          extent={{-10,60},{10,80}}), iconTransformation(extent={{40,80},{60,
            100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing
    "Upper unheated room temperature" annotation (Placement(transformation(
          extent={{-20,-82},{0,-62}}), iconTransformation(extent={{-60,80},{-40,
            100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_basement
    "Basement temperature" annotation (Placement(transformation(extent={{80,-10},
            {100,10}}), iconTransformation(extent={{-10,-10},{10,10}})));

// Calculation of weighted temperature
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedTemperature
    TintMoy
    annotation (Placement(transformation(extent={{-24,-32},{-4,-12}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient
    Ponderation(b=b_LNC)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

// Temperature sensors
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor TMat
    annotation (Placement(transformation(extent={{28,60},{48,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor TGau
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor TPic
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor TLNC
    annotation (Placement(transformation(extent={{18,-82},{38,-62}})));

protected
  parameter Real S_Gauguin=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_PlancherBas
    "Surface of upper Gauguin apartment";
  parameter Real S_Picasso=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_PlancherBas
    "Surface of upper Picasso apartment";
  parameter Real S_Matisse=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherBas
    "Surface of upper Matisse apartment";
  parameter Real S_LNC=paraMaisonRT.S_LNC "Surface of upper unheated room";
  parameter Real b_LNC= paraMaisonRT.b_SousSol
    "Weighted coefficient of basement temperature";
public
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group=
          "Overall parameters"));
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls"
    annotation (Dialog(group="Advanced parameters"));

equation
  TintMoy.T=(TGau.T*S_Gauguin+TMat.T*S_Matisse+TPic.T*S_Picasso+TLNC.T*S_LNC)/(S_LNC+S_Gauguin+S_Matisse+S_Picasso);

  connect(Ponderation.Tponder, T_int_basement) annotation (Line(
      points={{24,0},{52.5,0},{52.5,0},{90,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, Ponderation.port_ext) annotation (Line(
      points={{-90,50},{-40,50},{-40,4},{12,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TintMoy.port, Ponderation.port_int) annotation (Line(
      points={{-4,-22},{4,-22},{4,-4},{12,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_int_Matisse, TMat.port) annotation (Line(
      points={{0,70},{28,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Gauguin, TGau.port) annotation (Line(
      points={{-90,0},{-74,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Picasso, TPic.port) annotation (Line(
      points={{-90,-50},{-70,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_landing, TLNC.port) annotation (Line(
      points={{-10,-72},{18,-72}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i>Basement</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled basement.</p>
<p>To be complete, the model should be connected to the different apartment models, which contain common wall models.</p>
<p>Height under ceiling : 2.5m.</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of building stock library</p>
<p>Notes H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>Wall and glazing surfaces come from <a href=\"BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsUnheatedRoom\"><code>SettingsUnheatedRoom</code></a> record.</p>
<p>To change a surface value, prefer to modify it in the record rather than in the assembly.</p>
<p>Parameters depending on RT (French building regulation) are stored in <a href=\"BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM\"><code>BuildingDataUNHEATEDROOM</code></a> records.</p>
<p>When one of these records is selectied thanks to <code>paraMaisonRT</code>, building envelope parameters (walls, windows, ventilation...) will take the values stored in the selected record.</p>
<p>Available parameters are listed below :</p>
<ul><li><code>paraMaisonRT</code> : choice of the RT (French building regulation))</li>
<li><code>PositionEtage</code> : 1 if ground floor, 2 if intermediat floore, 3 if last floor. it is possible to assembly a n floor building with a numbering such as : 1 - 2 - .... - 2 - 3</li></ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p>See note H-E13-2014-00591-FR for validation</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
end Basement;
