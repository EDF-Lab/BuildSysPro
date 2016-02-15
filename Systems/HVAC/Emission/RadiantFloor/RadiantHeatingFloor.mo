within BuildSysPro.Systems.HVAC.Emission.RadiantFloor;
model RadiantHeatingFloor
  "Brique élementaire d'un plancher chauffant - sans les éléments convectifs"

// Choix du mode de chauffage
parameter Integer TypeChauffage=1 annotation(dialog(compact=true),
      choices(choice=1 "Circulation d'eau",
      choice=2 "Résistance électrique",radioButtons=true));

  parameter Modelica.SIunits.Area S=1 "Surface de la paroi";
  parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale de la paroi";
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState;

  replaceable parameter BuildSysPro.Utilities.Data.WallData.RecentFloor
    caracParoi "Caractéristiques de paroi" annotation (
      __Dymola_choicesAllMatching=true, dialog(group="Type de paroi"));
   parameter Integer nP=1
    "Numéro de la couche dont la frontière supérieure est le lieu d'injection de la puissance - doit être comprise entre 2 couches!!!";

// Paramètres propres à une paroi chauffante avec eau
  parameter Modelica.SIunits.Distance Ltube=100
    "Longueur du serpentin de chauffe du plancher"                                                  annotation(dialog(enable=TypeChauffage==1));
   parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Diamètre intérieure du tube"                                                        annotation(dialog(enable=TypeChauffage==1));
  parameter Modelica.SIunits.Distance eT=0.0015 "Epaisseur du tube"   annotation (Dialog(enable=TypeChauffage==1));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Conductivité thermique du tube"                                                            annotation (Dialog(enable=TypeChauffage==1));

protected
  parameter Integer nA=nP
    "Nombre de couches dans la paroi entre a et la couche chauffante";
  parameter Integer[nA] mA=caracParoi.m[1:nA] "Nombre de mailles par couches";
  parameter Modelica.SIunits.Length[nA] eA=caracParoi.e[1:nA]
    "Epaisseur des couches (a vers la couche chauffante)";
  parameter BuildSysPro.Utilities.Records.GenericSolid matA[nA]=caracParoi.mat[
      1:nA]
    "Matériaux constitutifs de la paroi, de a vers la couche chauffante"
    annotation (__Dymola_choicesAllMatching=true);

   parameter Integer nB=caracParoi.n-nP
    "Nombre de couches dans la paroi entre la couche chauffante et b";
   parameter Integer[nB] mB=caracParoi.m[nA+1:end]
    "Nombre de mailles par couches";
   parameter Modelica.SIunits.Length[nB] eB=caracParoi.e[nA+1:end]
    "Epaisseur des couches (couche chauffante vers b)";
  parameter BuildSysPro.Utilities.Records.GenericSolid[nB] matB=caracParoi.mat[
      nA + 1:end]
    "Matériaux constitutifs de la paroi, de la couche chauffante vers b"
    annotation (__Dymola_choicesAllMatching=true);

protected
  parameter Modelica.SIunits.SpecificHeatCapacity CpEau=4180
    "Capacité thermique de l'eau";
  parameter Modelica.SIunits.Density rhoEau=1000 "Masse volumique de l'eau";
  parameter Modelica.SIunits.Volume VEau=Ltube*Modelica.Constants.pi*(DiametreInt/2)^2
    "Volume d'eau contenue dans le radiateur";
  parameter Modelica.SIunits.Area surfaceT=Ltube*Modelica.Constants.pi*(DiametreInt+2*eT)
    "Surface d'échange du tube";

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_a
    "température de surface" annotation (Placement(transformation(extent={{-40,
            -52},{-20,-32}}, rotation=0), iconTransformation(extent={{-40,-52},
            {-20,-32}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_b
    "température de surface" annotation (Placement(transformation(extent={{20,
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
    "Puissance électrique injectée dans le plancher" annotation (
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
    "Vecteur contenant 1-la température du fluide (K), 2-le débit (kg/s)"
                                              annotation (Placement(
        transformation(extent={{-104,78},{-84,98}}), iconTransformation(
          extent={{-100,74},{-80,94}})));
  Modelica.Blocks.Interfaces.RealOutput Sortie[2] if  TypeChauffage==1
    "Vecteur contenant 1-la température du fluide (K), 2-le débit (kg/s)"
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
<p>A partir d'un modèle de paroi à n couches homogènes en thermique pure (discrétisation spatiale 1D de l'équation de la chaleur), on intégre un noeud thermique intermédiaire pouvant procurer un flux thermique en fonction de la température et du débit d'eau dans le cas d'un plancher à eau, ou en fonction d'une puissance électrique dans le cas d'un plancher rayonnant électrique.</p>
<p>Ce modèle a pour fonction de servir de brique élementaire pour une discrétisation de la surface d'une paroi active, telle qu'un plancher chauffant (paramètre par défaut).</p>
<p>Les noeuds de surface permettent de connecter directement des flux incidents sur la surface (p. ex. des flux solaires). </p>
<p>Les noeuds externes permettent de connecter des températures de l'environnement en ajoutant par contre les échanges convectifs</p>
<h4>Ce modèle a été intégré au modèle de Paroi de la bibliothèque qui doit donc être utilisé lors de connexions avec les noeuds d'air intérieurs et extérieurs à une zone thermique.</h4>
<p>Modèle validé - Hubert Blervaque 06/2012 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hubert BLERVAQUE, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Gilles Plessis 06/2012 : Modification du paramétrage du modèle pour ne rentrer qu'une composition de paroi (au lieu de n, m, mat et e) et une position de la couche chauffante & suppression de la convection : utiliser le modèle de Paroi intégrant ce choix de paroi active.</p>
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
