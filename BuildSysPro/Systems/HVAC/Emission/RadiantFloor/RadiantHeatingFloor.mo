within BuildSysPro.Systems.HVAC.Emission.RadiantFloor;
model RadiantHeatingFloor
  "Elementary building block of a heating floor - without convective elements"

// Choice of heating mode
parameter Integer TypeChauffage=1 "Heating floor type" annotation(choices(choice=1
        "Water circulation",
      choice=2 "Electrical resistance",radioButtons=true));

  parameter Modelica.SIunits.Area S=1 "Wall surface";
  parameter Modelica.SIunits.Temperature Tp=293.15 "Initial wall temoerature";
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState;

  replaceable parameter BuildSysPro.Utilities.Data.WallData.RecentFloor
    caracParoi "Wall characteristics" annotation (
      choicesAllMatching=true, Dialog(group="Wall type"));
   parameter Integer nP=1
    "Number of the layer whose upper boundary is the site of power injection - must be between 2 layers!!!";

// Parameters specific to a heating wall with water
  parameter Modelica.SIunits.Distance Ltube=100 "Floor heating coil length"      annotation(Dialog(enable=TypeChauffage==1));
   parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Inside diameter of the tube"                                                        annotation(Dialog(enable=TypeChauffage==1));
  parameter Modelica.SIunits.Distance eT=0.0015 "Tube thickness"   annotation (Dialog(enable=TypeChauffage==1));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Thermal conductivity of the tube"                                                            annotation (Dialog(enable=TypeChauffage==1));

protected
  parameter Integer nA=nP
    "Number of layers in the wall between A and the heating layer";
  parameter Integer[nA] mA=caracParoi.m[1:nA] "Number of meshes per layer";
  parameter Modelica.SIunits.Length[nA] eA=caracParoi.e[1:nA]
    "Thickness of the layers (from A to the heating layer)";
  parameter BuildSysPro.Utilities.Records.GenericSolid matA[nA]=caracParoi.mat[
      1:nA] "Constituent materials of the wall, from A to the heating layer"
    annotation (choicesAllMatching=true);

   parameter Integer nB=caracParoi.n-nP
    "Number of layers in the wall between the heating layer and B";
   parameter Integer[nB] mB=caracParoi.m[nA+1:end] "Number of meshes per layer";
   parameter Modelica.SIunits.Length[nB] eB=caracParoi.e[nA+1:end]
    "Thickness of the layers (from the heating layer to B)";
  parameter BuildSysPro.Utilities.Records.GenericSolid[nB] matB=caracParoi.mat[
      nA + 1:end]
    "Constituent materials of the wall, from the heating layer to B"
    annotation (choicesAllMatching=true);

protected
  parameter Modelica.SIunits.SpecificHeatCapacity CpEau=4180
    "Specific heat capacity of water";
  parameter Modelica.SIunits.Density rhoEau=1000 "Density of water";
  parameter Modelica.SIunits.Volume VEau=Ltube*Modelica.Constants.pi*(DiametreInt/2)^2
    "Volume of water contained in the radiator";
  parameter Modelica.SIunits.Area surfaceT=Ltube*Modelica.Constants.pi*(DiametreInt+2*eT)
    "Tube exchange surface";

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_a
    "Surface temperature" annotation (Placement(transformation(extent={{-40,
            -52},{-20,-32}}, rotation=0), iconTransformation(extent={{-40,-52},
            {-20,-32}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_b
    "Surface temperature" annotation (Placement(transformation(extent={{20,
            -52},{40,-32}}, rotation=0), iconTransformation(extent={{20,-52},{
            40,-32}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall ParoiNCouchesHomogenesA(
    Tinit=Tp,
    InitType=InitType,
    n=nA,
    m=mA,
    e=eA,
    mat=matA,
    S=S) annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall ParoiNCouchesHomogenesB(
    Tinit=Tp,
    InitType=InitType,
    n=nB,
    m=mB,
    e=eB,
    mat=matB,
    S=S) annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedPelec if
    TypeChauffage == 2
    annotation (Placement(transformation(extent={{-62,8},{-42,28}})));
  Modelica.Blocks.Interfaces.RealInput PelecIn if TypeChauffage==2
    "Electric power injected into the floor" annotation (
      Placement(transformation(extent={{-120,-4},{-80,36}}),
        iconTransformation(extent={{-40,74},{-20,94}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HeatCapacitor Eau(C=CpEau*
        VEau*rhoEau) if TypeChauffage == 1
    annotation (Placement(transformation(extent={{-16,62},{6,84}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor if
    TypeChauffage == 1 annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=270,
        origin={39,63})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Entree[2]*CpEau*(Entree[1]
         - Eau.port.T)) if TypeChauffage==1
    annotation (Placement(transformation(extent={{-84,58},{-64,78}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 if
    TypeChauffage == 1
    annotation (Placement(transformation(extent={{-42,48},{-22,68}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor thermalConductor(G=lambdaT
        *surfaceT/eT) if TypeChauffage == 1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-4,36})));
  Modelica.Blocks.Interfaces.RealInput Entree[2] if TypeChauffage==1
    "Vector containing 1- the inlet fluid temperature (K), 2- the inlet fluid flow rate (kg/s)"
                                              annotation (Placement(
        transformation(extent={{-104,78},{-84,98}}), iconTransformation(
          extent={{-100,74},{-80,94}})));
  Modelica.Blocks.Interfaces.RealOutput Sortie[2] if  TypeChauffage==1
    "Vector containing 1- the outlet fluid temperature (K), 2- the outlet fluid flow rate (kg/s)"
                                                annotation (Placement(
        transformation(extent={{78,60},{98,80}}),    iconTransformation(
          extent={{80,-96},{100,-76}})));
protected
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port1
    annotation (Placement(transformation(extent={{-5,-11},{-3,-9}})));
equation
  connect(Ts_a, ParoiNCouchesHomogenesA.port_a)
                                 annotation (Line(
      points={{-30,-42},{-46,-42},{-46,-10},{-39,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiNCouchesHomogenesB.port_b, Ts_b) annotation (Line(
      points={{39,-10},{46,-10},{46,-42},{30,-42}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(PelecIn, prescribedPelec.Q_flow)     annotation (Line(
      points={{-100,16},{-61,16},{-61,16.6}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(temperatureSensor.T, Sortie[1]) annotation (Line(
      points={{39,68},{39,65},{88,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Entree[2], Sortie[2]) annotation (Line(
      points={{-94,93},{-49,93},{-49,75},{88,75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y,prescribedHeatFlow1. Q_flow) annotation (
      Line(
      points={{-63,68},{-56,68},{-56,56.6},{-41,56.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port,Eau. port)        annotation (Line(
      points={{-21,56.6},{-21,57.3},{-3.9,57.3},{-3.9,63.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Eau.port,temperatureSensor. port) annotation (Line(
      points={{-3.9,63.1},{-3.9,58},{39,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedPelec.port, port1) annotation (Line(
      points={{-41,16.6},{-4,16.6},{-4,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiNCouchesHomogenesA.port_b, port1) annotation (Line(
      points={{-21,-10},{-4,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port1, ParoiNCouchesHomogenesB.port_a) annotation (Line(
      points={{-4,-10},{21,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Eau.port, thermalConductor.port_a) annotation (Line(
      points={{-3.9,63.1},{-3.9,51.5},{-4,51.5},{-4,45}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, port1) annotation (Line(
      points={{-4,27},{-4,8.5},{-4,8.5},{-4,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>From a wall model with n homogeneous layers in pure thermal (1D spatial discretization of the heat equation), this model integrates an intermediate node capable of providing a thermal heat flow depending on temperature and water flow in the case of a water floor, or depending on electric power in the case of an electric radiant floor.</p>
<p><b>This model was integrated into the wall model of the library that should be used for connexions with indoor and outdoor air nodes to a thermal area.</b></p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model is to be used as elementary building block for a discretization of an active wall surface, such as a heating floor (default setting).</p>
<p>Surface nodes allow to connect directly incident flows on the surface (eg. Solar fluxes).</p>
<p>External nodes allow to connect temperatures of the environment, however by adding convective exchanges.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 06/2012 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Hubert BLERVAQUE, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Gilles Plessis 06/2012 : Modification du paramétrage du modèle pour ne rentrer qu'une composition de paroi (au lieu de n, m, mat et e) et une position de la couche chauffante &amp; suppression de la convection : utiliser le modèle de Paroi intégrant ce choix de paroi active.</p>
<p>Aurélie Kaemmerlen 07/2012 : Fusion des modèles de paroi active à eau et de plancher électrique</p>
<p>Sila Filfli 07/2012 : Correction de la formule donnant la surface des tuyaux (surfaceT)</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-20,98},{20,-102}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,126},{98,100}},
          lineColor={0,0,0},
          textString="%name"),
        Line(
          points={{-80,84},{-20,84}},
          color={0,0,118},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{20,-86},{80,-86}},
          color={0,0,118},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-20,84},{20,84},{-20,64},{20,54},{-20,34},{20,14},
              {-20,-6},{20,-26},{-20,-46},{19.7266,-65.8633},{-20,-86},
              {20,-86}},
          color={0,0,118},
          thickness=0.5,
          smooth=Smooth.Bezier)}),
    DymolaStoredErrors);
end RadiantHeatingFloor;
