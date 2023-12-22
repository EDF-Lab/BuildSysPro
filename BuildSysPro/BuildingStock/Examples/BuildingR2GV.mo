within BuildSysPro.BuildingStock.Examples;
model BuildingR2GV "GV calculation of BuildingR2"
  extends Modelica.Icons.Example;
Real GV;
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature
    CLtemperature(T=291.15)
    annotation (Placement(transformation(extent={{-94,38},{-74,58}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature Tconsigne(T=
       292.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,72})));

  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.BuildingR2
    mozartNonRehab(
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN.Gauguin1989to2000
      paraMaisonRT_Gauguin,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.Picasso1989to2000
      paraMaisonRT_Picasso,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.Matisse1989to2000
      paraMaisonRT_Matisse,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.UnheatedRoom1989to2000
      paraMaisonRT_LNC,
    ChoixModelePalier=1,
    T_palier=292.15)
    annotation (Placement(transformation(extent={{-50,-84},{46,70}})));
  Modelica.Blocks.Sources.Constant const[10](each k=0)
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature Tconsigne1(
      T=292.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,2})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature Tconsigne2(
      T=292.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-46})));
equation
 GV = -Tconsigne.port.Q_flow/(Tconsigne.port.T - CLtemperature.port.T);
  connect(const.y, mozartNonRehab.G) annotation (Line(
      points={{-77,88},{-40,88},{-40,64.8667},{-46.5091,64.8667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CLtemperature.port, mozartNonRehab.T_ext) annotation (Line(
      points={{-74,48},{-38,48},{-38,65.7222},{-10.7273,65.7222}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne.port, mozartNonRehab.T_int_Gauguin_R2) annotation (Line(
      points={{70,72},{58,72},{58,60.5889},{41.6364,60.5889}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne.port, mozartNonRehab.T_int_Matisse_R2) annotation (Line(
      points={{70,72},{58,72},{58,49.4667},{41.6364,49.4667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne.port, mozartNonRehab.T_int_Picasso_R2) annotation (Line(
      points={{70,72},{58,72},{58,38.3444},{41.6364,38.3444}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne1.port, mozartNonRehab.T_int_Gauguin_R1) annotation (Line(
      points={{72,2},{56,2},{56,9.25556},{41.6364,9.25556}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne1.port, mozartNonRehab.T_int_Matisse_R1) annotation (Line(
      points={{72,2},{58,2},{58,-1.86667},{41.6364,-1.86667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne1.port, mozartNonRehab.T_int_Picasso_R1) annotation (Line(
      points={{72,2},{60,2},{60,-12.9889},{41.6364,-12.9889}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne2.port, mozartNonRehab.T_int_Gauguin_R0) annotation (Line(
      points={{76,-46},{60,-46},{60,-41.2222},{41.6364,-41.2222}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne2.port, mozartNonRehab.T_int_Matisse_R0) annotation (Line(
      points={{76,-46},{60,-46},{60,-52.3444},{41.6364,-52.3444}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne2.port, mozartNonRehab.T_int_Picasso_R0) annotation (Line(
      points={{76,-46},{60,-46},{60,-63.4667},{41.6364,-63.4667}},
      color={191,0,0},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Example of GV calculation (heat losses of a building for a 1°C difference between inside and outside) for the <code>BuildingR2</code> model (constant interior temperature, no internal gains, no solar gains).</p>
<p>The result can be read when the balance is reached, calculating the ratio between the power injected to the building heatport by the <code>FixedTemperature</code> model and the temperature gap between inside and outside.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Gilles Plessis 06/2012 : Changement du modèle de paroi</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics));
end BuildingR2GV;
