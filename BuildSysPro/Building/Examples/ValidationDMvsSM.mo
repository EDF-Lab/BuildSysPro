within BuildSysPro.Building.Examples;
model ValidationDMvsSM
  "Comparison between DetailedMonozone and SimplifiedMonozone models"
extends Modelica.Icons.Example;
  BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone
    annotation (Placement(transformation(extent={{-58,42},{-38,62}})));
  BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Zones.HeatTransfer.DetailedMonozone mD(
    Ubat=0.2,
    NbNiveau=2,
    Vair=480,
    SH=200,
    renouv=0.35,
    k=1.5,
    SurfaceVitree={10,20,10,10},
    hs_ext_Plafond=18,
    hs_int_Plafond=7.7,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall paraParoiV,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentFloor paraPlancher,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall paraPlafond)
    annotation (Placement(transformation(extent={{8,42},{42,92}})));
  Modelica.Blocks.Sources.RealExpression Temps(y=time)
    annotation (Placement(transformation(extent={{-26,0},{-6,20}})));
  BoundaryConditions.Weather.Meteofile meteofile1
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Zones.HeatTransfer.SimplifiedZone1 mS(
    Ubat=0.2,
    NbNiveau=2,
    Vair=480,
    SH=200,
    renouv=0.35,
    SurfaceVitree=50,
    k=1.5,
    skyViewFactorWindows=0.5,
    skyViewFactorParois=0.706612,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall paraParoiExt,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentFloor paraPlancher)
    annotation (Placement(transformation(extent={{28,-62},{48,-38}})));

  BoundaryConditions.Solar.Irradiation.SolarBC cLSolaire(
    TrDir=mS.Tr,
    SurfacesVitrees={0,10,20,10,10},
    SurfacesExterieures={100,38,18,38,38})
    annotation (Placement(transformation(extent={{-52,-38},{-32,-18}})));
equation
  connect(mD.FLUXN,fLUXzone. FLUXNord) annotation (Line(
      points={{9.7,68.6667},{-13.15,68.6667},{-13.15,56.2},{-37,56.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(mD.FLUXS,fLUXzone. FLUXSud) annotation (Line(
      points={{9.7,65.3333},{-13.15,65.3333},{-13.15,52.4},{-37,52.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(mD.FLUXE,fLUXzone. FLUXEst) annotation (Line(
      points={{9.7,62},{-14,62},{-14,48.4},{-37,48.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(mD.FLUXO,fLUXzone. FLUXouest) annotation (Line(
      points={{9.7,58.6667},{-13.15,58.6667},{-13.15,44.4},{-37,44.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(mD.Tairext,meteofile. Tseche) annotation (Line(
      points={{9.7,43.6667},{9.7,26},{-66,26},{-66,73},{-81,73}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mD.Tciel,meteofile. Tciel) annotation (Line(
      points={{9.7,80.3333},{-31.15,80.3333},{-31.15,79},{-81,79}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond,mD. FLUXP) annotation (Line(
      points={{-37,60.4},{-18,60.4},{-18,72},{9.7,72}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(meteofile.G,fLUXzone. G) annotation (Line(
      points={{-81,68},{-62,68},{-62,52.5},{-58.3,52.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mS.Tairext, meteofile1.Tseche)
                                        annotation (Line(
      points={{29,-61},{-76,-61},{-76,-7},{-81,-7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile1.G, cLSolaire.G)
                                    annotation (Line(
      points={{-81,-12},{-62,-12},{-62,-20.1},{-50.9,-20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile1.Tciel, mS.Tciel) annotation (Line(
      points={{-81,-1},{29,-1},{29,-41}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mS.FluxTrVitrage, cLSolaire.FluxTrVitrage) annotation (Line(points={{
          29,-50},{-14,-50},{-14,-18},{-33,-18},{-33,-20}}, color={255,192,1}));
  connect(mS.FluxIncVitrage, cLSolaire.FluxIncVitrage) annotation (Line(points={{29,-44},
          {-12,-44},{-12,-26},{-33,-26}},           color={255,192,1}));
  connect(mS.FluxIncParoi, cLSolaire.FluxIncParois) annotation (Line(points={{
          29,-46},{14,-46},{14,-44},{-4,-44},{-4,-34},{-33,-34}}, color={255,
          192,1}));
  annotation (experiment(StopTime=3.1536e+007, Interval=600),
      __Dymola_experimentSetupOutput(events=false),
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
<p>Validated model - Gilles PLESSIS 12/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author: Gilles PLESSIS, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles PLESSIS 09/2014 : Correction d'un bug : le MS.Tciel était connecté à la Trosée de la météo.</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end ValidationDMvsSM;
