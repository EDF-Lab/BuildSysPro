within BuildSysPro.Systems.Solar.Examples;
model PVCapacitivePhysicalModel_STP185AD
extends Modelica.Icons.Example;
  PV.BasicModels.PVPanelSimplified pVmodelePhysiqueCapacitif(
    surface=20.43,
    eta_STC=0.145,
    redeclare
      BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal.ThermalRecordsPV.TechnoCrystallineSilicon
      technoPV,
    mu_T=-0.48)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(meteofile.V, pVmodelePhysiqueCapacitif.Vit) annotation (Line(
      points={{-61,-5},{-16,-5},{-16,4},{-9.2,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.T_dry, pVmodelePhysiqueCapacitif.T_ext) annotation (Line(
      points={{-61,3},{-42,3},{-42,4},{-22,4},{-22,24},{-2.2,24},{-2.2,7}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(meteofile.T_sky, pVmodelePhysiqueCapacitif.T_ciel) annotation (
      Line(
      points={{-61,9},{-42,9},{-42,36},{2,36},{2,7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, pVmodelePhysiqueCapacitif.G) annotation (Line(
      points={{-61,-2},{-38,-2},{-38,0},{-8.4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics), Documentation(info="<html>
<p>Use example of the <code>PVPanelSimplified</code> model for a crystalline silicon technology.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Using supplier data for Suntech 185 AD panels.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end PVCapacitivePhysicalModel_STP185AD;
