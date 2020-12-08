within BuildSysPro.Building.Examples;
model OneZone "Pure thermal modelling for a one-zone model"
    extends Modelica.Icons.Example;

  BuildingEnvelope.HeatTransfer.Wall ParoiSud(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,8},{-2,30}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreSud(S=4)
    annotation (Placement(transformation(extent={{16,16},{38,38}})));
  BuildingEnvelope.HeatTransfer.Wall ParoiNord(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,38},{-2,60}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreNord(S=4)
    annotation (Placement(transformation(extent={{16,48},{38,70}})));
  BuildingEnvelope.HeatTransfer.Wall ParoiEst(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,-22},{-2,0}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreEst(S=4)
    annotation (Placement(transformation(extent={{16,-16},{38,6}})));
  BuildingEnvelope.HeatTransfer.Wall ParoiOuest(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,-52},{-2,-30}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreOuest(S=4)
    annotation (Placement(transformation(extent={{16,-46},{38,-24}})));
  BuildingEnvelope.HeatTransfer.Wall Plafond(S=14, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentCeiling
      caracParoi)
    annotation (Placement(transformation(extent={{-24,68},{-2,90}})));

  BuildingEnvelope.HeatTransfer.FloorOnSlab
                                     Plancher(                           redeclare
      BuildSysPro.Utilities.Data.WallData.RecentFloor
      caracParoi)
    annotation (Placement(transformation(extent={{-20,-92},{0,-72}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=52, Tair=293.15)
    annotation (Placement(transformation(extent={{78,-16},{98,4}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal RenouvellementAir
    annotation (Placement(transformation(extent={{38,80},{58,100}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone
    annotation (Placement(transformation(extent={{-80,66},{-52,94}})));

  BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=4) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={42,-72})));
equation
  connect(FenetreOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,-38.3},{46,-38.3},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenetreEst.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,-8.3},{46,-8.3},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenetreSud.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,23.7},{46,23.7},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenetreNord.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,55.7},{46,55.7},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(ParoiOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,-44.3},{6,-44.3},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,-14.3},{6,-14.3},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,15.7},{6,15.7},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,45.7},{6,45.7},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,75.7},{88,75.7},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, Plafond.FluxIncExt) annotation (Line(
      points={{-50.6,91.76},{-42,91.76},{-42,88.9},{-16.3,88.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, ParoiNord.FluxIncExt) annotation (Line(
      points={{-50.6,85.88},{-42,85.88},{-42,58.9},{-16.3,58.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, ParoiSud.FluxIncExt) annotation (Line(
      points={{-50.6,80.56},{-42,80.56},{-42,28.9},{-16.3,28.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, ParoiEst.FluxIncExt) annotation (Line(
      points={{-50.6,74.96},{-42,74.96},{-42,-1.1},{-16.3,-1.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, ParoiOuest.FluxIncExt) annotation (Line(
      points={{-50.6,69.36},{-42,69.36},{-42,-31.1},{-16.3,-31.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, FenetreNord.FluxIncExt) annotation (Line(
      points={{-50.6,85.88},{-42,85.88},{-42,64.5},{23.7,64.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, FenetreSud.FluxIncExt) annotation (Line(
      points={{-50.6,80.56},{-42,80.56},{-42,32.5},{23.7,32.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, FenetreEst.FluxIncExt) annotation (Line(
      points={{-50.6,74.96},{-42,74.96},{-42,0.5},{23.7,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, FenetreOuest.FluxIncExt) annotation (Line(
      points={{-50.6,69.36},{-42,69.36},{-42,-29.5},{23.7,-29.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(RenouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{57,90},{88,90},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, fLUXzone.G) annotation (Line(points={{-81,48},{-74,
          48},{-74,64},{-90,64},{-90,80.7},{-80.42,80.7}},
                                                    color={0,0,127}));
  connect(meteofile.T_dry, RenouvellementAir.port_a) annotation (Line(points={{
          -81,53},{-36,53},{-36,90},{39,90}}, color={191,0,0}));
  connect(meteofile.T_dry, Plafond.T_ext) annotation (Line(points={{-81,53},{-36,
          53},{-36,75.7},{-22.9,75.7}}, color={191,0,0}));
  connect(meteofile.T_dry, ParoiNord.T_ext) annotation (Line(points={{-81,53},{
          -36,53},{-36,45.7},{-22.9,45.7}}, color={191,0,0}));
  connect(meteofile.T_dry, ParoiSud.T_ext) annotation (Line(points={{-81,53},{-36,
          53},{-36,15.7},{-22.9,15.7}}, color={191,0,0}));
  connect(meteofile.T_dry, ParoiEst.T_ext) annotation (Line(points={{-81,53},{-36,
          53},{-36,-14.3},{-22.9,-14.3}}, color={191,0,0}));
  connect(meteofile.T_dry, ParoiOuest.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,-44.3},{-22.9,-44.3}}, color={191,0,0}));
  connect(Plancher.T_int, noeudAir.port_a) annotation (Line(points={{-1,-82},{6,
          -82},{6,76},{88,76},{88,-10}}, color={191,0,0}));
  connect(FenetreNord.CLOTr, multiSum.u[1]) annotation (Line(points={{36.9,64.5},
          {56,64.5},{56,-75.15},{48,-75.15}}, color={255,192,1}));
  connect(FenetreSud.CLOTr, multiSum.u[2]) annotation (Line(points={{36.9,32.5},
          {58,32.5},{56,32.5},{56,-73.05},{48,-73.05}}, color={255,192,1}));
  connect(FenetreEst.CLOTr, multiSum.u[3]) annotation (Line(points={{36.9,0.5},
          {56,0.5},{56,-74.1},{48,-74.1},{48,-70.95}}, color={255,192,1}));
  connect(FenetreOuest.CLOTr, multiSum.u[4]) annotation (Line(points={{36.9,
          -29.5},{56,-29.5},{56,-74.8},{48,-74.8},{48,-68.85}}, color={255,192,
          1}));
  connect(multiSum.y, Plancher.FluxAbsInt) annotation (Line(points={{34.98,-72},
          {14,-72},{14,-77},{-7,-77}}, color={0,0,127}));
  connect(meteofile.T_dry, FenetreNord.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,66},{12,66},{12,55.7},{17.1,55.7}}, color={191,0,0}));
  connect(meteofile.T_dry, FenetreSud.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,66},{12,66},{12,23.7},{17.1,23.7}}, color={191,0,0}));
  connect(meteofile.T_dry, FenetreEst.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,66},{12,66},{12,-8.3},{17.1,-8.3}}, color={191,0,0}));
  connect(meteofile.T_dry, FenetreOuest.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,66},{12,66},{12,-38.3},{17.1,-38.3}}, color={191,0,0}));
  annotation (
Documentation(info="<html>
<p><b>Simple example of a thermal zone model</b></p>
<p>This model is an example of a simple thermal zone assembly - it can not be used as such and must be set, including with the use of each sub-model parameters so that they are accessible to outside in an assembly using this model.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Parallelepiped single-zone glazed building model, connected to a boundary conditions model on the left hand side</p>
<ul>
<li><i>port_a</i> for the outdoor air temperature</li>
<li><i>port_a1</i> for the ground temperature</li>
<li>and <i>G</i>, a realOutput for solar fluxes.</li>
</ul>
<p>The ceiling is directly subjected to the outdoor temperature. The walls are oriented in the four cardinal points.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This single zone building model is to be connected to a weather boundary conditions model on the left (outside temperature, sunlight-related data).</p>
<p>The walls parameterization is done via the parameter caracParoi, however it still can be done layer by layer without creating any type of wall.</p>
<ol>
<li>Click on the small arrow of caracParoi + Edit</li>
<li>Fill in the fields on the number of layers, their thickness, the mesh. The parameter positionIsolant is optional</li>
<li>For the matte parameter, click on the small arrow + Edit array, match the number of boxes in a column to the number of materials layer in the window that is displayed, then, in each box, right-click + Insert function call and browse the library to specify the path of the desired material (in <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\"><code>Utilities.Data.Solids</code></a>)</li>
</ol>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>To consider longwave radiation, exchange coefficients <code>h</code> must be <b>global exchange coefficients</b>.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Cristian Muresan 04/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Cristian MURESAN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</p>
<p>Gilles Plessis 02/2012 : Remplacement du modèle de renouvellement d'air et suppression de la valeur du débit de ventilation (=0,2m3/h dans l'ancienne zone)</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})),         Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}},
        initialScale=0.1)),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput);
end OneZone;
