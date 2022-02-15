within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.PGVH.Examples;
model MonozonePGVH

  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile(pth=
        Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/METEONORM/France/nancy_station.txt"),
      TypeMeteo=2)
    annotation (Placement(transformation(extent={{-90,-8},{-72,10}})));
  Modelica.Blocks.Sources.Constant const(k=293)
    annotation (Placement(transformation(extent={{-70,44},{-56,58}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=false)
                                                               annotation (
      Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=270,
        origin={45,64})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y=true)
                                                               annotation (
      Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=270,
        origin={27,64})));
  BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazed cas1aAvecFlux1(
    Vair=252.15,
    hextv=25,
    hintv=7.7,
    Splaf=100.86,
    hplaf=10,
    hintplaf=10,
    Splanch=100.86,
    hplanch=5.88,
    hintplanch=5.88,
    albedo=0.2,
    alpha=0.6,
    S2nv=18.5,
    S3nv=26.75,
    S4nv=16.5,
    S1v=5,
    S2v=2,
    S3v=4,
    S4v=4,
    U=1.43,
    tau=0.544,
    S1nv=25.75,
    bCombles=0.1,
    bVS=0.1,
    Tair=293.15,
    CaracParoiVert(
      n=3,
      m={4,3,1},
      e={0.2,0.15,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()}),
    CaracPlaf(
      n=2,
      m={5,1},
      e={0.25,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.InsulationMaterialAndJoists(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()}),
    CaracPlanch(
      n=3,
      m={4,4,1},
      e={0.16,0.2,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
          BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.FloorTile()}))
    annotation (Placement(transformation(extent={{-48,-58},{16,-16}})));

  PGVH pGVH annotation (Placement(transformation(extent={{8,-4},{56,40}})));
equation

  connect(const.y, pGVH.T_consigne) annotation (Line(
      points={{-55.3,51},{-33.65,51},{-33.65,23.5},{13.52,23.5}},
      color={0,0,127}));
  connect(cas1aAvecFlux1.T_int, pGVH.Heat_Stove) annotation (Line(points={{
          1.06667,-47.92},{1.06667,-23.28},{34.64,-23.28},{34.64,-1.14}}, color=
         {191,0,0}));

  connect(booleanExpression2.y, pGVH.presence) annotation (Line(
      points={{27,57.4},{27,46.7},{29.12,46.7},{29.12,35.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanExpression1.y, pGVH.fixed_power) annotation (Line(
      points={{45,57.4},{45,45.7},{44.72,45.7},{44.72,35.82}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(meteofile.T_dry, cas1aAvecFlux1.T_ext) annotation (Line(points={{-72.9,
          3.7},{-50,3.7},{-50,-18.1},{-33.0667,-18.1}}, color={191,0,0}));
  connect(meteofile.G, cas1aAvecFlux1.G) annotation (Line(points={{-72.9,-0.8},
          {-60,-0.8},{-60,-26.5},{-33.0667,-26.5}}, color={0,0,127}));
  annotation (                   Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Hubert BLERVAQUE, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MonozonePGVH;
