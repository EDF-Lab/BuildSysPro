﻿within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneSlabGlazed
  "Model of glazed zone on slab-on-grade floor, in pure thermal modelling"

extends ZoneSlab;

//Windows//
  parameter Modelica.Units.SI.Area S1v=1 "South wall glass surface"
    annotation (Dialog(tab="Windows"));
  parameter Modelica.Units.SI.Area S2v=1 "West wall glass surface"
    annotation (Dialog(tab="Windows"));
  parameter Modelica.Units.SI.Area S3v=1 "North wall glass surface"
    annotation (Dialog(tab="Windows"));
  parameter Modelica.Units.SI.Area S4v=1 "East wall glass surface"
    annotation (Dialog(tab="Windows"));

parameter Real U "Glazings thermal conductivity" annotation(Dialog(tab="Windows"));
parameter Real tau "Glazings transmission coefficient" annotation(Dialog(tab="Windows"));
parameter Real AbsFen=0.1
    "Direct and diffuse absorption coefficient of the window" annotation(Dialog(tab="Windows"));

// For this model no diffuse / direct distinction
protected
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hefen=21
    "Outdoor exchange coefficient of windows";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hifen=8.29
    "Indoor exchange coefficient of windows";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k=1/(1/U - 1/hefen - 1/
      hifen)
    "Surface transmission coefficient of windows - without int / ext convection";

  BuildingEnvelope.HeatTransfer.Window                       FenSud(
    S=S1v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext)
    annotation (Placement(transformation(extent={{-24,18},{-8,34}})));

 BuildingEnvelope.HeatTransfer.Window                       FenOuest(
    S=S2v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext)
    annotation (Placement(transformation(extent={{-24,-36},{-8,-20}})));

 BuildingEnvelope.HeatTransfer.Window                       FenNord(
    S=S3v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext)
    annotation (Placement(transformation(extent={{-24,48},{-8,64}})));

  BuildingEnvelope.HeatTransfer.Window                       FenEst(
    S=S4v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext)
    annotation (Placement(transformation(extent={{-24,-10},{-8,6}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxS
    annotation (Placement(transformation(extent={{70,-60},{60,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxN
    annotation (Placement(transformation(extent={{70,-70},{60,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxE
    annotation (Placement(transformation(extent={{70,-80},{60,-70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxO
    annotation (Placement(transformation(extent={{70,-90},{60,-80}})));
equation
  connect(FenNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,53.6},{-2,53.6},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,23.6},{-2,23.6},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,-4.4},{-2,-4.4},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,-30.4},{-2,-30.4},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenNord.T_ext, T_ext) annotation (Line(
      points={{-23.2,53.6},{-30,53.6},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(FenOuest.T_ext, T_ext) annotation (Line(
      points={{-23.2,-30.4},{-30,-30.4},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(FenEst.T_ext, T_ext) annotation (Line(
      points={{-23.2,-4.4},{-30,-4.4},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(FenSud.T_ext, T_ext) annotation (Line(
      points={{-23.2,23.6},{-30,23.6},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(FenSud.CLOTr, FluxS.Q_flow) annotation (Line(
      points={{-8.8,30},{86,30},{86,-55},{70,-55}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenNord.CLOTr, FluxN.Q_flow) annotation (Line(
      points={{-8.8,60},{86,60},{86,-65},{70,-65}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenEst.CLOTr, FluxE.Q_flow) annotation (Line(
      points={{-8.8,2},{86,2},{86,-75},{70,-75}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenOuest.CLOTr, FluxO.Q_flow) annotation (Line(
      points={{-8.8,-24},{86,-24},{86,-85},{70,-85}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, FenNord.FluxIncExt) annotation (Line(
      points={{-95,18.2},{-90,18.2},{-90,60},{-18.4,60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, FenSud.FluxIncExt) annotation (Line(
      points={{-95,14.4},{-88,14.4},{-88,30},{-18.4,30}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, FenEst.FluxIncExt) annotation (Line(
      points={{-95,10.4},{-88,10.4},{-88,2},{-18.4,2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, FenOuest.FluxIncExt) annotation (Line(
      points={{-95,6.4},{-88,6.4},{-88,-24},{-18.4,-24}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(paroiTerrePleinRadAvecSol.Ts_int, FluxS.port) annotation (Line(
      points={{-43,-66},{-42,-66},{-42,-92},{50,-92},{50,-55},{60,-55}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.Ts_int, FluxN.port) annotation (Line(
      points={{-43,-66},{-42,-66},{-42,-92},{50,-92},{50,-65},{60,-65}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.Ts_int, FluxE.port) annotation (Line(
      points={{-43,-66},{-42,-66},{-42,-92},{50,-92},{50,-75},{60,-75}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.Ts_int, FluxO.port) annotation (Line(
      points={{-43,-66},{-42,-66},{-42,-92},{50,-92},{50,-85},{60,-85}},
      color={255,0,0},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p><b>Model of parallelepiped glazed zone on slab-on-grade floor, in pure thermal modelling</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Parallelepiped single-zone glazed building on slab-on-grade floor model, to be connected to a boundary conditions model (left thermal port) and a left realOutput for solar fluxes. By default walls are oriented in the four cardinal points; the orientation modification is represented by the parameter beta. The right thermal port is connected to the inner volume (heat capacity). Floor and ceiling are subject to outside temperatures which are weighted by a coefficient b.</p>
<p>This model inherits from <a href=\"modelica://BuildSysPro.Building.Zones.HeatTransfer.ZoneSlab\"><code>ZoneCrawlSpaceGlazedInternalPartitions</code></a> and superimposes on it the glazings.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This single zone building model is to be connected to a weather boundary conditions model on the left (outside temperature, sunlight-related data). The right thermal port is connected to the inner volume (heat capacity) and can, if desired, be connected to any model using a thermal port (internal heat gains...).</p>
<p>The walls parameterization is done via the parameter caracParoi, however it still can be done layer by layer without creating any type of wall.</p>
<ol>
<li>Click on the small arrow of caracParoi + Edit</li>
<li>Fill in the fields on the number of layers, their thickness, the mesh. The parameter positionIsolant is optional</li>
<li>For the mat parameter, click on the small arrow + Edit array, match the number of boxes in a column to the number of materials layer in the window that is displayed, then, in each box, right-click + Insert function call and browse the library to specify the path of the desired material (in <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\"><code>Utilities.Data.Solids</code></a>)</li>
</ol>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>To consider walls radiation in long wavelength (LWR), exchange coefficients h must be <b>global exchange coefficients</b>.</p>
<p>Glazings transmit solar fluxes to the floor.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Ludovic Darnaud 07/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Ludovic DARNAUD, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Gilles Plessis 02/2011: Changement du modèle de coefficient B pour vérifier la conservation d'énergie + Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(choicesAllMatching=true)</p>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {100,100}}), graphics),
     Icon(graphics={
        Rectangle(extent={{-116,-2},{-54,-38}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}));
end ZoneSlabGlazed;
