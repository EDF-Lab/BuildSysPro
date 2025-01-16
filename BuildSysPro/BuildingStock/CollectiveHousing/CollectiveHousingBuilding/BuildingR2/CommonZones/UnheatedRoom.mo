within BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.CommonZones;
model UnheatedRoom
  "Unheated room to be used as landing for complete collective housing assembly"

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent=
           {{50,80},{70,100}}), iconTransformation(extent={{50,80},{70,
            100}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_landing
    "Stairwell temperature" annotation (Placement(transformation(extent={{-10,
            22},{10,42}}), iconTransformation(extent={{-10,22},{10,42}})));

// Public parameters
public
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group=
          "Overall parameters"));
parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"
    annotation(Dialog(tab="Advanced parameters"), choices(radioButtons=true));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Advanced parameters"));
parameter Integer PositionEtage=2 "Floor position"
   annotation(Dialog(group="Overall parameters"),choices(
                choice=1 "Ground floor",
                choice=2 "Intermediate floor",
                choice=3 "Last floor",radioButtons=true));
 parameter Real beta=0
    "Correction of azimuth for vertical walls such as azimuth=beta+azimuth, {beta=0 : N=180,S=0,E=-90,O=90}"
 annotation(Dialog(group="Overall parameters"));
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls"
    annotation (Dialog(group="Advanced parameters"));
protected
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer HE=if GLOEXT == false
       then paraMaisonRT.Hsext else paraMaisonRT.Hsext - 5.15;
  parameter Modelica.Units.SI.ThermalConductance Gpontsthermiques=if
      PositionEtage == 1 then paraMaisonRT.PontsTh_Generique + paraMaisonRT.PontsTh_Bas
       elseif PositionEtage == 2 then paraMaisonRT.PontsTh_Generique else
      paraMaisonRT.PontsTh_Generique + paraMaisonRT.PontsTh_Haut;
parameter Real ValeurQVconstant=paraMaisonRT.TauxRenouvAir*
      BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsUnheatedRoom.VolumeLNC
    "Default value if the air change rate is constant (m^3/h)"                         annotation (Dialog(group="Overall parameters"), enable=not QVin);

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    caracParoi=paraMaisonRT.PlancherBas,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.HsPlancherBas,
    Tp=Tp,
    InitType=paraMaisonRT.InitType,
    S=paraMaisonRT.S_LNC,
    hs_int=paraMaisonRT.Hsint,
    RadInterne=false) if PositionEtage == 1        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,-64})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherInterm(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.HsPlancherBas,
    Tp=Tp,
    InitType=paraMaisonRT.InitType,
    hs_int=paraMaisonRT.Hsint,
    S=paraMaisonRT.S_LNC,
    caracParoi=paraMaisonRT.PlancherInterm,
    RadInterne=false) if PositionEtage >= 2        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-64})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_inf
    "Lower unheated room temperature" annotation (Placement(transformation(
          extent={{80,-100},{100,-80}}), iconTransformation(extent={{80,-100},{
            100,-80}})));

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsUnheatedRoom.Surf_MurSud)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,4})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky   if GLOEXT
     == true annotation (Placement(transformation(extent={{80,50},{100,70}}),
        iconTransformation(extent={{80,50},{100,70}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=
       beta)
    annotation (Placement(transformation(extent={{-88,58},{-68,78}})));
public
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
      annotation (Placement(transformation(extent={{-120,56},{-80,96}}),
        iconTransformation(extent={{-100,62},{-76,86}})));
protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(Tair=Tp, V=
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsUnheatedRoom.VolumeLNC)
    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsUnheatedRoom.Surf_MurEst)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-26})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        ValeurQVconstant, use_Qv_in=false) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={32,-24})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=Gpontsthermiques) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={72,-28})));
equation
  connect(PlancherInterm.T_ext, T_int_inf) annotation (Line(
      points={{53,-73},{53,-90},{90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_ext, T_int_inf) annotation (Line(
      points={{15,-73},{15,-90},{90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.G,G)  annotation (Line(
      points={{-88.3,68.5},{-88.3,76},{-100,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, MurSud.FluxIncExt) annotation (Line(
      points={{-67,68.4},{-67,13},{-33,13}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_sky, MurSud.T_sky) annotation (Line(
      points={{90,60},{-39,60},{-39,-5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, MurSud.T_ext) annotation (Line(
      points={{60,90},{60,1},{-39,1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-21,1},{-14,1},{-14,0},{0,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{15,-55},{15,0},{0,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherInterm.T_int, noeudAir.port_a) annotation (Line(
      points={{53,-55},{53,0},{0,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, T_int_landing) annotation (Line(
      points={{0,0},{0,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-21,-29},{0,-29},{0,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_sky, MurSud.T_sky) annotation (Line(
      points={{-39,-35},{-39,-5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, MurEst.FluxIncExt) annotation (Line(
      points={{-67,64.4},{-62,64.4},{-62,-17},{-33,-17}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{32,-15},{32,0},{0,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_a, T_ext) annotation (Line(
      points={{32,-33},{32,-48},{60,-48},{60,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{72,-19},{72,0},{0,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_a, T_ext) annotation (Line(
      points={{72,-37},{72,-48},{60,-48},{60,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_ext, T_sky) annotation (Line(
      points={{-39,-29},{-39,60},{90,60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i>Unheated room</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled unheated room.</p>
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
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
end UnheatedRoom;
