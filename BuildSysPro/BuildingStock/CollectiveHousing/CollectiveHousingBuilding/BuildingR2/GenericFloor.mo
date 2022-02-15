within BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2;
model GenericFloor

  // Housings
  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseAssemblyCH matisse(
    PositionEtage=PositionEtage,
    GLOEXT=GLOEXT,
    Tp=Tp,
    InitType=InitType,
    beta=beta,
    paraMaisonRT=paraMaisonRT_Matisse)
    annotation (Placement(transformation(extent={{-104,4},{86,116}})));
  BuildSysPro.BuildingStock.CollectiveHousing.Picasso.PicassoAssemblyCH picasso(
    PositionEtage=PositionEtage,
    GLOEXT=GLOEXT,
    Tp=Tp,
    InitType=InitType,
    beta=beta,
    paraMaisonRT=paraMaisonRT_Picasso)
    annotation (Placement(transformation(extent={{104,-104},{224,16}})));
  BuildSysPro.BuildingStock.CollectiveHousing.Gauguin.GauguinAssemblyCH gauguin(
    PositionEtage=PositionEtage,
    GLOEXT=GLOEXT,
    Tp=Tp,
    InitType=InitType,
    beta=beta,
    paraMaisonRT=paraMaisonRT_Gauguin)
    annotation (Placement(transformation(extent={{-296,-92},{-120,112}})));
  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.CommonZones.UnheatedRoom
    LNC(
    GLOEXT=GLOEXT,
    InitType=InitType,
    PositionEtage=PositionEtage,
    beta=beta,
    Tp=Tp,
    paraMaisonRT=paraMaisonRT_LNC) if ChoixModelePalier == 2
    annotation (Placement(transformation(extent={{-18,-70},{12,-34}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature LNC_Fixe(T=
        T_palier) if ChoixModelePalier == 1
    annotation (Placement(transformation(extent={{-98,-34},{-78,-14}})));

  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.CommonZones.Basement
    sousSol(Tp=Tp, paraMaisonRT=paraMaisonRT_LNC) if PositionEtage == 1
    annotation (Placement(transformation(extent={{-46,-152},{10,-94}})));

  // Input data from the environment
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent={{180,
            120},{200,140}}), iconTransformation(extent={{180,120},{200,140}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky if   GLOEXT
    annotation (Placement(transformation(extent={{220,80},{240,100}}),
        iconTransformation(extent={{220,80},{240,100}})));
 Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
     annotation (Placement(transformation(extent={{-336,104},{-296,144}}),
       iconTransformation(extent={{-320,108},{-296,132}})));

  // Housing temperatures
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin_inf if
                                                                             not (
    PositionEtage == 1) "Lower Gauguin apartment temperature" annotation (
      Placement(transformation(extent={{-140,-152},{-120,-132}}),
        iconTransformation(extent={{-260,-140},{-240,-120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse_inf if
                                                                             not (
    PositionEtage == 1) "Lower Matisse apartment temperature" annotation (
      Placement(transformation(extent={{40,-20},{60,0}}), iconTransformation(
          extent={{20,-140},{40,-120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso_inf if
                                                                             not (
    PositionEtage == 1) "Lower Picasso apartment temperature" annotation (
      Placement(transformation(extent={{160,-140},{180,-120}}),
        iconTransformation(extent={{160,-140},{180,-120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing_inf if
                                                                             (not (
    PositionEtage == 1) and ChoixModelePalier == 2)
    "Lower unheated room temperature" annotation (Placement(transformation(
          extent={{40,-176},{60,-156}}), iconTransformation(extent={{-120,-140},
            {-100,-120}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin
    "Gauguin apartment temperature" annotation (Placement(transformation(extent=
           {{-222,-66},{-202,-46}}), iconTransformation(extent={{-154,12},{-134,
            32}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse
    "Matisse apartment temperature" annotation (Placement(transformation(extent=
           {{20,52},{40,72}}), iconTransformation(extent={{58,62},{78,82}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso
    "Picasso apartment temperature" annotation (Placement(transformation(extent=
           {{130,-38},{150,-18}}), iconTransformation(extent={{86,-38},{106,-18}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing
    "Unheated room (landing) temperature" annotation (Placement(transformation(
          extent={{-100,-80},{-80,-60}}), iconTransformation(extent={{-26,-18},
            {-6,2}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_basement if
    PositionEtage == 1 "Basement temperature" annotation (Placement(
        transformation(extent={{-102,-154},{-82,-134}}), iconTransformation(
          extent={{-50,-120},{-30,-100}})));
  // Overall parameters
 parameter Integer PositionEtage=1 "Floor position"
   annotation(Dialog(group="Overall parameters"),choices(
               choice=1 "Ground floor",
               choice=2 "Intermediate floor",
               choice=3 "Last floor",radioButtons=true));
 parameter Integer ChoixModelePalier=1 "Type of landing modelling"
   annotation(Dialog(group="Landing modelling"),choices(
               choice=1 "Heated room at constant temperature",
               choice=2 "Detailled modelling (unheated room)",radioButtons=true));
  parameter Modelica.Units.SI.Temperature T_palier=273.15 + 16
    "Landing temperature if heated" annotation (Dialog(enable=(
          ChoixModelePalier == 1), group="Landing modelling"));
  // Homogeneization of housing construction date
 replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN.BuildingType
    paraMaisonRT_Gauguin "French building regulation used for Gauguin"
    annotation (choicesAllMatching=true, Dialog(group="Overall parameters"));
 replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.BuildingType
    paraMaisonRT_Picasso "French building regulation used for Picasso"
    annotation (choicesAllMatching=true, Dialog(group="Overall parameters"));
 replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    paraMaisonRT_Matisse "French building regulation used for Matisse"
    annotation (choicesAllMatching=true, Dialog(group="Overall parameters"));
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.BuildingType
    paraMaisonRT_LNC "French building regulation used for unheated room"
    annotation (choicesAllMatching=true, Dialog(group=
          "Overall parameters"));
  // Advanced parameters
 parameter Real beta=0
    "Correction of azimuth for vertical walls such as azimuth=beta+azimuth, {beta=0 : N=180,S=0,E=-90,O=90}"
   annotation (Dialog(tab="Advanced parameters"));
 parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky" annotation(Dialog(tab="Advanced parameters"));
 parameter Boolean USEreduction=false
    "Integration of solar reduction factors (masking, frame) for glazings" annotation(Dialog(tab="Advanced parameters"));
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls"
    annotation (Dialog(tab="Advanced parameters"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Advanced parameters"));

equation
 connect(G, matisse.G) annotation (Line(
     points={{-316,124},{-95.8571,124},{-95.8571,104.8}},
     color={0,0,127},
     smooth=Smooth.None));
 connect(G, picasso.G) annotation (Line(
     points={{-316,124},{104,124},{104,5.09091}},
     color={0,0,127},
     smooth=Smooth.None));
  connect(T_ext, gauguin.T_ext) annotation (Line(
      points={{190,130},{-269.6,130},{-269.6,101.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, matisse.T_ext) annotation (Line(
      points={{190,130},{52.0714,130},{52.0714,109}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, picasso.T_sky) annotation (Line(
      points={{230,90},{230,-11.2727},{219,-11.2727}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, matisse.T_sky) annotation (Line(
      points={{230,90},{156,90},{156,81},{79.2143,81}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, gauguin.T_sky) annotation (Line(
      points={{230,90},{156,90},{156,130},{-287.2,130},{-287.2,61}},
      color={191,0,0},
      smooth=Smooth.None));
 connect(G, gauguin.G) annotation (Line(
     points={{-316,124},{-318,124},{-318,-69.56},{-285.44,-69.56}},
     color={0,0,127},
     smooth=Smooth.None));
  connect(matisse.T_int_Gauguin, gauguin.T_int_Gauguin) annotation (Line(
      points={{-97.2143,60},{-205.36,60},{-205.36,-20.6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(picasso.T_ext, T_ext) annotation (Line(
      points={{199,10.5455},{199,60},{190,60},{190,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Picasso_inf, picasso.T_int_inf) annotation (Line(
      points={{170,-130},{219,-130},{219,-98.5455}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Matisse_inf, matisse.T_int_inf) annotation (Line(
      points={{50,-10},{78,-10},{78,14},{79.2143,14},{79.2143,11}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gauguin.T_int_Gauguin, T_int_Gauguin) annotation (Line(
      points={{-205.36,-20.6},{-205.36,-56},{-212,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(matisse.T_int_Matisse, T_int_Matisse) annotation (Line(
      points={{-0.178571,62.8},{14.9107,62.8},{14.9107,62},{30,62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Picasso, picasso.T_int_Picasso) annotation (Line(
      points={{140,-28},{162.5,-28},{162.5,-50.5455}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sousSol.T_int_Matisse, T_int_Matisse) annotation (Line(
      points={{-4,-96.9},{30,-96.9},{30,62}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(sousSol.T_int_Picasso, picasso.T_int_Picasso) annotation (Line(
      points={{7.2,-131.7},{162.5,-131.7},{162.5,-50.5455}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sousSol.T_ext, T_ext) annotation (Line(
      points={{-18,-149.1},{106,-149.1},{106,-86},{190,-86},{190,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sousSol.T_int_Gauguin, gauguin.T_int_Gauguin) annotation (Line(
      points={{-43.2,-123},{-205.36,-123},{-205.36,-20.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_basement, sousSol.T_int_basement) annotation (Line(
      points={{-92,-144},{-32,-144},{-32,-123},{-18,-123}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_basement, gauguin.T_int_inf) annotation (Line(
      points={{-92,-144},{-92,-81.8},{-128.8,-81.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_basement, picasso.T_int_inf) annotation (Line(
      points={{-92,-144},{62,-144},{62,-142},{219,-142},{219,-98.5455}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_basement, matisse.T_int_inf) annotation (Line(
      points={{-92,-144},{78,-144},{78,14},{79.2143,14},{79.2143,11}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gauguin.T_int_inf, T_int_Gauguin_inf) annotation (Line(
      points={{-128.8,-81.8},{-128.8,-105.9},{-130,-105.9},{-130,-142}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(LNC.T_sky, T_sky) annotation (Line(
      points={{10.5,-41.2},{230,-41.2},{230,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(LNC.T_ext, T_ext) annotation (Line(
      points={{6,-35.8},{8,-35.8},{8,130},{190,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(picasso.T_int_landing, LNC.T_int_unheated) annotation (Line(
      points={{109,-44},{52.5,-44},{52.5,-46.24},{-3,-46.24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(matisse.T_int_landing, LNC.T_int_unheated) annotation (Line(
      points={{-26.6429,11},{-26.6429,-17.5},{-3,-17.5},{-3,-46.24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(gauguin.T_int_landing, LNC.T_int_unheated) annotation (Line(
      points={{-128.8,-8.36},{-62,-8.36},{-62,-46.24},{-3,-46.24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sousSol.T_int_landing, LNC.T_int_unheated) annotation (Line(
      points={{-32,-96.9},{-32,-46.24},{-3,-46.24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_landing, LNC.T_int_unheated) annotation (Line(
      points={{-90,-70},{-3,-70},{-3,-46.24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(LNC.T_int_inf, T_int_landing_inf) annotation (Line(
      points={{10.5,-68.2},{50,-68.2},{50,-166}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(LNC.T_int_inf, T_int_basement) annotation (Line(
      points={{10.5,-68.2},{-36.75,-68.2},{-36.75,-144},{-92,-144}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(LNC.G, G) annotation (Line(
      points={{-16.2,-38.68},{-164.1,-38.68},{-164.1,124},{-316,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gauguin.T_int_landing, LNC_Fixe.port) annotation (Line(
      points={{-128.8,-8.36},{-70,-8.36},{-70,-24},{-78,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(matisse.T_int_landing, LNC_Fixe.port) annotation (Line(
      points={{-26.6429,11},{-26.6429,-24},{-78,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(picasso.T_int_landing, LNC_Fixe.port) annotation (Line(
      points={{109,-44},{74,-44},{74,-24},{-78,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(LNC_Fixe.port, T_int_landing) annotation (Line(
      points={{-78,-24},{-66,-24},{-66,-70},{-90,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sousSol.T_int_landing, LNC_Fixe.port) annotation (Line(
      points={{-32,-96.9},{-34,-96.9},{-34,-24},{-78,-24}},
      color={191,0,0},
      smooth=Smooth.None));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-160},
            {240,140}}),      graphics), Icon(coordinateSystem(extent={{-320,
            -160},{240,140}},     preserveAspectRatio=false), graphics={
       Rectangle(
         extent={{-300,-20},{-100,-80}},
         fillColor={213,170,255},
         fillPattern=FillPattern.Solid,
         lineColor={0,0,0}),
       Polygon(
         points={{-42,60},{0,120},{220,120},{178,60},{-42,60}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={255,170,85},
         fillPattern=FillPattern.Solid),
       Polygon(
         points={{178,60},{220,120},{220,60},{178,0},{178,60}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={255,170,85},
         fillPattern=FillPattern.Solid),
       Polygon(
         points={{164,40},{178,60},{178,0},{164,-20},{164,40}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={255,170,170},
         fillPattern=FillPattern.Solid),
       Polygon(
         points={{14,25},{-6,39},{-6,-181},{14,-195},{14,25}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={255,170,170},
         fillPattern=FillPattern.Solid,
         origin={139,54},
         rotation=-90),
       Polygon(
         points={{-100,-20},{-48,60},{66,40},{22,-20},{-100,-20}},
         smooth=Smooth.None,
         fillColor={255,170,170},
         fillPattern=FillPattern.Solid,
         pattern=LinePattern.None),
       Polygon(
         points={{-300,-20},{-200,120},{0,120},{-100,-20},{-300,-20}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={213,170,255},
         fillPattern=FillPattern.Solid),
       Polygon(
         points={{108,-40},{164,40},{164,-20},{108,-100},{108,-40}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={170,255,170},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{8,-40},{108,-100}},
         fillColor={170,255,170},
         fillPattern=FillPattern.Solid,
         lineColor={0,0,0}),
       Polygon(
         points={{8,-40},{64,40},{164,40},{108,-40},{8,-40}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={170,255,170},
         fillPattern=FillPattern.Solid),
       Polygon(
         points={{-100,-20},{22,-20},{8,-40},{8,-80},{-100,-80},{-100,-20}},
         lineColor={0,0,0},
         smooth=Smooth.None,
         fillColor={255,170,170},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-186,-34},{-132,-64}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Line(
         points={{0,120},{0,60}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{-200,120},{-200,60}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{66,40},{66,-20}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{22,-20},{22,-80}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{-42,60},{-42,0}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{-200,60},{220,60}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{-200,60},{-300,-80}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Rectangle(
         extent={{-276,-34},{-222,-64}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Line(
         points={{0,60},{-100,-80}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{66,-20},{8,-100}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{66,-20},{164,-20}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{-40,0},{164,0}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Line(
         points={{164,0},{178,0}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Rectangle(
         extent={{32,-54},{86,-84}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Line(
         points={{8,-80},{22,-80}},
         color={0,0,0},
         smooth=Smooth.None,
         pattern=LinePattern.Dash),
       Ellipse(
         extent={{-318,137},{-268,90}},
         lineColor={255,255,0},
         fillColor={255,255,0},
         fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i>Generic floor</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled generic floor.</p>
<p>Height under ceiling : 2.5m.</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of building stock library</p>
<p>Notes H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model is a generic floor for complete collective housing assembly (Gauguin, Matisse, Picasso apartments and unheated rooms).</p>
<p>Parameter <code>PositionEtage</code> allows the user to chose the floor position.</p>
<p>Parameters <code>paraMaisonRT</code> allow the user to chose a specific French building regulation for each type of apartment, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from choosen records.</p>
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
end GenericFloor;
