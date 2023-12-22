within BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2;
model BuildingR2

  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.GenericFloor Etage2(
    PositionEtage=3,
    paraMaisonRT_Gauguin=paraMaisonRT_Gauguin,
    paraMaisonRT_Picasso=paraMaisonRT_Picasso,
    paraMaisonRT_Matisse=paraMaisonRT_Matisse,
    paraMaisonRT_LNC=paraMaisonRT_LNC,
    beta=beta,
    GLOEXT=GLOEXT,
    USEreduction=USEreduction,
    Tp=Tp,
    InitType=InitType,
    T_palier=T_palier,
    ChoixModelePalier=ChoixModelePalier)
    annotation (Placement(transformation(extent={{-86,-40},{60,40}})));
  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.GenericFloor Etage1(
    paraMaisonRT_Gauguin=paraMaisonRT_Gauguin,
    paraMaisonRT_Picasso=paraMaisonRT_Picasso,
    paraMaisonRT_Matisse=paraMaisonRT_Matisse,
    paraMaisonRT_LNC=paraMaisonRT_LNC,
    beta=beta,
    GLOEXT=GLOEXT,
    USEreduction=USEreduction,
    Tp=Tp,
    InitType=InitType,
    PositionEtage=2,
    T_palier=T_palier,
    ChoixModelePalier=ChoixModelePalier)
    annotation (Placement(transformation(extent={{-88,-134},{58,-52}})));
  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.GenericFloor RdC(
    paraMaisonRT_Gauguin=paraMaisonRT_Gauguin,
    paraMaisonRT_Picasso=paraMaisonRT_Picasso,
    paraMaisonRT_Matisse=paraMaisonRT_Matisse,
    paraMaisonRT_LNC=paraMaisonRT_LNC,
    beta=beta,
    GLOEXT=GLOEXT,
    USEreduction=USEreduction,
    Tp=Tp,
    InitType=InitType,
    PositionEtage=1,
    T_palier=T_palier,
    ChoixModelePalier=ChoixModelePalier)
    annotation (Placement(transformation(extent={{-84,-240},{62,-154}})));

 Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
     annotation (Placement(transformation(extent={{-120,60},{-80,100}}),
       iconTransformation(extent={{-104,76},{-80,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent={{20,80},
            {40,100}}), iconTransformation(extent={{-20,80},{0,100}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky   if GLOEXT
    annotation (Placement(transformation(extent={{48,80},{68,100}}),
        iconTransformation(extent={{40,80},{60,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin_R2
    "R+2 Gauguin temperature" annotation (Placement(transformation(extent={{100,
            68},{120,88}}), iconTransformation(extent={{100,68},{120,88}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin_R1
    "R+1 Gauguin temperature" annotation (Placement(transformation(extent={{100,
            -54},{120,-34}}), iconTransformation(extent={{100,-52},{120,-32}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin_R0
    "Ground floor Gauguin temperature" annotation (Placement(transformation(
          extent={{100,-172},{120,-152}}), iconTransformation(extent={{100,-170},
            {120,-150}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse_R0
    "Ground floor Matisse temperature" annotation (Placement(transformation(
          extent={{100,-198},{120,-178}}), iconTransformation(extent={{100,-196},
            {120,-176}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse_R1
    "R+1 Matisse temperature" annotation (Placement(transformation(extent={{100,
            -80},{120,-60}}), iconTransformation(extent={{100,-78},{120,-58}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse_R2
    "R+2 Matisse temperature" annotation (Placement(transformation(extent={{100,
            42},{120,62}}), iconTransformation(extent={{100,42},{120,62}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso_R0
    "Ground floor Picasso temperature" annotation (Placement(transformation(
          extent={{100,-250},{120,-230}}), iconTransformation(extent={{100,-222},
            {120,-202}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso_R1
    "R+1 Picasso temperature" annotation (Placement(transformation(extent={{100,
            -132},{120,-112}}), iconTransformation(extent={{100,-104},{120,-84}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso_R2
    "R+1 Picasso temperature" annotation (Placement(transformation(extent={{100,
            -18},{120,2}}), iconTransformation(extent={{100,16},{120,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing_R0
    "Ground floor landing temperature" annotation (Placement(transformation(
          extent={{100,-224},{120,-204}}), iconTransformation(extent={{100,-250},
            {120,-228}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing_R1
    "R+1 landing temperature" annotation (Placement(transformation(extent={{100,
            -106},{120,-86}}), iconTransformation(extent={{100,-130},{120,-110}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing_R2
    "R+2 landing temperature" annotation (Placement(transformation(extent={{100,
            8},{120,28}}), iconTransformation(extent={{100,-10},{120,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_basement
    "Basement temperature" annotation (Placement(transformation(extent={{-30,-260},
            {-10,-240}}), iconTransformation(extent={{-30,-260},{-10,-240}})));

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
  parameter Real beta=0
    "Correction of azimuth for vertical walls such as azimuth=beta+azimuth, {beta=0 : N=180,S=0,E=-90,O=90}"
    annotation (Dialog(tab="Advanced parameters"));
  parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"
    annotation (Dialog(tab="Advanced parameters"));
  parameter Boolean USEreduction=false
    "Integration of solar reduction factors (masking, frame) for glazings"
    annotation (Dialog(tab="Advanced parameters"));
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls"
    annotation (Dialog(tab="Advanced parameters"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Advanced parameters"));

  parameter Integer ChoixModelePalier=1 "Type of landing modelling"
    annotation(Dialog(group="Landing modelling"),choices(
               choice=1 "Heated room at constant temperature",
               choice=2 "Detailled modelling (unheated room)",radioButtons=true));
  parameter Modelica.Units.SI.Temperature T_palier=273.15 + 16
    "Landing temperature if heated" annotation (Dialog(group=
          "Landing modelling", enable=(ChoixModelePalier == 1)));

equation
  connect(G, Etage2.G)          annotation (Line(
      points={{-100,80},{-83,80},{-83,34.6667},{-82.8714,34.6667}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(T_ext, Etage2.T_ext) annotation (Line(
      points={{30,90},{32,90},{32,37.3333},{46.9643,37.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, Etage1.T_ext) annotation (Line(
      points={{30,90},{32,90},{32,-54.7333},{44.9643,-54.7333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, RdC.T_ext) annotation (Line(
      points={{30,90},{32,90},{32,-156.867},{48.9643,-156.867}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, Etage2.T_sky) annotation (Line(
      points={{58,90},{72,90},{72,26.6667},{57.3929,26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, Etage1.T_sky) annotation (Line(
      points={{58,90},{72,90},{72,-65.6667},{55.3929,-65.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, RdC.T_sky) annotation (Line(
      points={{58,90},{72,90},{72,-168.333},{59.3929,-168.333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage2.T_int_Gauguin, T_int_Gauguin_R2) annotation (Line(
      points={{-40.1143,8.53333},{-40.1143,78},{110,78}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage2.T_int_Matisse, T_int_Matisse_R2) annotation (Line(
      points={{15.1571,21.8667},{15.1571,52},{110,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage2.T_int_landing, T_int_landing_R2) annotation (Line(
      points={{-6.74286,0.533333},{84,0.533333},{84,18},{110,18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage2.T_int_Picasso, T_int_Picasso_R2) annotation (Line(
      points={{22.4571,-4.8},{70.2285,-4.8},{70.2285,-8},{110,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage2.T_int_Gauguin_inf, Etage1.T_int_Gauguin) annotation (Line(
      points={{-67.75,-32},{-42.1143,-32},{-42.1143,-84.2533}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Gauguin, T_int_Gauguin_R1) annotation (Line(
      points={{-42.1143,-84.2533},{-42.1143,-44},{110,-44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_landing, T_int_landing_R1) annotation (Line(
      points={{-8.74286,-92.4533},{47.1071,-92.4533},{47.1071,-96},{110,-96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Picasso, T_int_Picasso_R1) annotation (Line(
      points={{20.4571,-97.92},{20.4571,-122},{110,-122}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Picasso, Etage2.T_int_Picasso_inf) annotation (Line(
      points={{20.4571,-97.92},{20.4571,-32},{41.75,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Matisse, Etage2.T_int_Matisse_inf) annotation (Line(
      points={{13.1571,-70.5867},{5.25,-70.5867},{5.25,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Matisse, T_int_Matisse_R1) annotation (Line(
      points={{13.1571,-70.5867},{60.5786,-70.5867},{60.5786,-70},{110,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Gauguin_inf, RdC.T_int_Gauguin) annotation (Line(
      points={{-69.75,-125.8},{-38.1143,-125.8},{-38.1143,-187.827}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RdC.T_int_Gauguin, T_int_Gauguin_R0) annotation (Line(
      points={{-38.1143,-187.827},{-38.1143,-162},{110,-162}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RdC.T_int_basement, T_int_basement) annotation (Line(
      points={{-11,-225.667},{-11,-250},{-20,-250}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RdC.T_int_landing, T_int_landing_R0) annotation (Line(
      points={{-4.74286,-196.427},{70,-196.427},{70,-214},{110,-214}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RdC.T_int_Picasso, T_int_Picasso_R0) annotation (Line(
      points={{24.4571,-202.16},{54,-202.16},{54,-240},{110,-240}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RdC.T_int_Matisse, T_int_Matisse_R0) annotation (Line(
      points={{17.1571,-173.493},{17.1571,-188},{110,-188}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(G, Etage1.G) annotation (Line(
      points={{-100,80},{-84.8714,80},{-84.8714,-57.4667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G, RdC.G) annotation (Line(
      points={{-100,80},{-84,80},{-84,-160},{-80.8714,-160},{-80.8714,-159.733}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(T_sky, T_sky) annotation (Line(
      points={{58,90},{58,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Matisse_inf, RdC.T_int_Matisse) annotation (Line(
      points={{3.25,-125.8},{3.25,-173.493},{17.1571,-173.493}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Etage1.T_int_Picasso_inf, RdC.T_int_Picasso) annotation (Line(
      points={{39.75,-125.8},{39.75,-202.16},{24.4571,-202.16}},
      color={191,0,0},
      smooth=Smooth.None));
if ChoixModelePalier==2 then
    connect(Etage2.T_int_landing_inf, Etage1.T_int_landing) annotation (Line(
        points={{-31.25,-32},{-31.25,-92.4533},{-8.74286,-92.4533}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(Etage1.T_int_landing_inf, RdC.T_int_landing) annotation (Line(
        points={{-33.25,-125.8},{-33.25,-196.427},{-4.74286,-196.427}},
        color={191,0,0},
        smooth=Smooth.None));
end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -260},{120,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-260},{120,100}}), graphics={
       Ellipse(
         extent={{-100,94},{-60,54}},
         lineColor={255,255,0},
         fillColor={255,255,0},
         fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,40},{-40,100},{80,100},{42,40},{-80,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-260},{40,40},{80,100},{80,-200},{40,-260}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,42},{40,-260}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-60},{40,-60},{80,0},{80,-100},{40,-160},{-80,-160}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-80,-60},{-40,0},{80,0},{80,-100},{-40,-100},{-80,-160},{-80,
              -260},{-38,-200},{80,-200}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-40,100},{-38,-200}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
       Rectangle(
         extent={{-62,10},{-30,-30}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-10,10},{22,-30}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-62,-92},{-30,-132}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-10,-92},{22,-132}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-60,-190},{-28,-230}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-10,-190},{22,-230}},
         lineColor={0,0,0},
         fillColor={170,213,255},
         fillPattern=FillPattern.Solid),
        Text(
          extent={{50,40},{72,6}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="R2"),
        Text(
          extent={{50,-60},{72,-94}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="R1"),
        Text(
          extent={{50,-160},{72,-194}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="R0")}),
    Documentation(info="<html>
<p><i>Complete R+2 collective housing building model (9 apartments, 13 thermal zones)</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled collective housing building.</p>
<p>Height under ceiling : 2.5m.</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of building stock library</p>
<p>Notes H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model is a 3 floor collective housing building.</p>
<p>Parameters <code>paraMaisonRT</code> allow the user to chose a specific French building regulation for each type of apartment, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from choosen records.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p>See note H-E13-2014-00591-FR for validation</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
end BuildingR2;
