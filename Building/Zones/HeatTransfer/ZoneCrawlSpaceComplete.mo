within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpaceComplete
  "Modèle  monozone de maison vitrée sur vide sanitaire avec inertie des parois internes, renouvellement d'air et ponts thermiques"
  extends
    BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazedInternalPartitions;

// Renouvellement d'air//
parameter Real TauxRA=0.3 "Taux de renouvellement d'air en vol/h";
// Ponts thermiques
parameter Real Rpth=1/6.423 "Résistance équivalente due aux ponts thermiques";

  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance thermalResistance(R=Rpth)
    annotation (Placement(transformation(extent={{-126,-92},{-106,-72}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        TauxRA*Vair, use_Qv_in=true) annotation (Placement(transformation(
        extent={{-5,10},{5,-10}},
        rotation=270,
        origin={-172,-91})));
  Modelica.Blocks.Sources.Constant TauxRenouvellementAir(k=TauxRA)
    "Taux de renouvellement d'air vol/h" annotation (Placement(
        transformation(extent={{-196,-96},{-186,-86}})));

equation
  connect(Text, thermalResistance.port_a) annotation (Line(
      points={{-182,-12},{-160,-12},{-160,-82},{-125,-82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResistance.port_b, Tairint) annotation (Line(
      points={{-107,-82},{-6,-82},{-6,-96},{30,-96},{30,-48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, Tairint) annotation (Line(
      points={{-172,-95.5},{-42,-95.5},{-42,-96},{30,-96},{30,-48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_a, Text) annotation (Line(
      points={{-172,-86.5},{-174,-86.5},{-174,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauxRenouvellementAir.y, renouvellementAir.Qv_in) annotation (
     Line(
      points={{-185.5,-91},{-180.8,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>Modèle monozone de maison vitrée sur vide sanitaire avec prise en compte de l'inertie des parois internes, intégrant le renouvellement d'air et un pont thermique</p>
<p>Modèle validé - Vincent Magnaudeix 07/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Vincent MAGNAUDEIX, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"),                                                                    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,
            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {100,100}}), graphics));
end ZoneCrawlSpaceComplete;
