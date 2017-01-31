within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model FloorOnSlab
  "Slab-on-grade floor model - generic floor model - conventional, resistive or water-based heating floor"

// Choice of model parameters
 parameter Integer ParoiActive=1 "Type of floor"
      annotation(Dialog(group="Type of floor",compact=true),
      choices(choice=1 "Conventional floor",
      choice=2 "Water-based heating floor",
      choice=3 "Electric radiant floor",radioButtons=true));
  parameter Boolean SurEquivalentTerre=true
    "Consideration of an earth layer between the floor and Tsol"
     annotation(Dialog(group="Type of model",compact=true),choices(choice=true
        "Yes: floor in contact with a material equivalent to earth",                                                                          choice=false
        "No : conventional floor",                                                                                                    radioButtons=true));

  parameter Boolean RadInterne=true "Consideration of radiative fluxes inside"
                                               annotation(Dialog(group="Type of model",compact=true),choices(radioButtons=true));

 parameter Boolean CLfixe=true "Time-invariant temperature of the ground"
                                            annotation(Dialog(group="Type of model",compact=true),choices(radioButtons=true));

// Thermophysical parameters
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoi
    "Floor characteristics (including those of the ground under the floor if SurEquiValentTerre = False)"
    annotation (choicesAllMatching=true, Dialog(group=
          "Floor parameters"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericSolid caracTerre=BuildSysPro.Utilities.Data.Solids.SoilClaySilt()
    "Physical characteristics of the ground"
    annotation (choices(
                choice=BuildSysPro.Utilities.Data.Solids.SoilClaySilt()
        "Clay/silt ground lambda=1.5",
                choice=BuildSysPro.Utilities.Data.Solids.SoilSandGravel()
        "Sand/gravel ground lambda=2.0"),                                                                     Dialog(group=
          "Ground parameters"));

  parameter Modelica.SIunits.Area S=1 "Floor surface" annotation (Dialog(group="Floor parameters"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs=5.88
    "Coefficient of global surface exchange on the inner face" annotation (Dialog(group="Floor parameters"));
  parameter Modelica.SIunits.Temperature Ts=293.15 "Ground temperature" annotation (Dialog(enable=CLfixe,group="Ground parameters"));

// Parameter common to the water-based heating floor and the electric radiant floor
 parameter Integer nP=1
    "Number of the layer whose upper boundary is the site of power injection - must be strictly lower than n"
    annotation (Dialog(enable=not
                                 (ParoiActive==1), group="Type of floor"));

// Parameters specific to the water-based heating floor
  parameter Integer nD=8 "Number of water floor discretization slices"
    annotation(Dialog(enable=ParoiActive==2, tab="Water-based heating floor parameters"));
  parameter Modelica.SIunits.Distance Ltube=128 "Floor heating coil length"
    annotation(Dialog(enable=ParoiActive==2, tab="Water-based heating floor parameters"));
  parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Inside diameter of the tube"
    annotation(Dialog(enable=ParoiActive==2, tab="Water-based heating floor parameters"));
  parameter Modelica.SIunits.Distance eT=0.0015 "Tube thickness"
    annotation (Dialog(enable=ParoiActive==2, tab="Water-based heating floor parameters"));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Thermal conductivity of the tube"
    annotation (Dialog(enable=ParoiActive==2, tab="Water-based heating floor parameters"));

// Initialisation parameters
  parameter Modelica.SIunits.Temperature Tp=293.15
    "Initial temperature of the floor" annotation (Dialog(group="Initialisation parameters"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (Dialog(group="Initialisation parameters"));

// Ground parameters
  parameter Modelica.SIunits.Length eSol=0.2 "Ground thickness"
                       annotation (Dialog(enable=SurEquivalentTerre,group="Ground parameters"));
  parameter Integer mSol=5 "Number of meshes to model the ground"
                                            annotation (Dialog(group="Ground parameters",enable=SurEquivalentTerre));

// Components
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int annotation (
     Placement(transformation(extent={{20,-10},{40,10}}), iconTransformation(
          extent={{20,-10},{40,10}})));
  Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne "LWR/SWR flows absorbed by this floor on its inner face"
    annotation (Placement(transformation(extent={{118,70},{80,108}}),
        iconTransformation(extent={{40,40},{20,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature TemperatureSol(T=Ts) if
    CLfixe annotation (Placement(transformation(extent={{-99,-9},{-81,9}})));

protected
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor thermalConductor(G=hs*S)
    annotation (Placement(transformation(extent={{51,22},{72,42}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 if
    RadInterne annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={59,89})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall Sol(
    InitType=InitType,
    n=1,
    S=S,
    m={mSol},
    Tinit=Tp,
    e={eSol},
    mat={caracTerre}) if SurEquivalentTerre
    annotation (Placement(transformation(extent={{-56,6},{-36,26}})));

public
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tsol if not (CLfixe)
    "Ground temperature" annotation (Placement(transformation(extent={{-100,-40},
            {-80,-20}}), iconTransformation(extent={{-120,-10},{-100,10}})));

protected
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a NoeudTsol "Ground temperature"
    annotation (Placement(transformation(extent={{-65,-7},{-68,-10}})));

public
  BuildSysPro.Systems.HVAC.Emission.RadiantFloor.RadiantHeatingFloor
    PlancherActifEau[nD](
    Ltube=Ltube/nD*(0.1:1.8/(nD - 1):1.9),
    each Tp=Tp,
    each DiametreInt=DiametreInt,
    S=S/nD*(0.1:1.8/(nD - 1):1.9),
    each eT=eT,
    each lambdaT=lambdaT,
    each caracParoi(
      n=caracParoi.n,
      m=caracParoi.m,
      e=caracParoi.e,
      mat=caracParoi.mat,
      positionIsolant=caracParoi.positionIsolant),
    each nP=nP,
    each InitType=InitType) if ParoiActive == 2
    "Floor surface divided into nD active floors with water circulation inside"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall plancherClassique(
    S=S,
    Tinit=Tp,
    InitType=InitType,
    n=caracParoi.n,
    m=caracParoi.m,
    e=caracParoi.e,
    mat=caracParoi.mat) if ParoiActive == 1
    annotation (Placement(transformation(extent={{-14,32},{12,54}})));
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if ParoiActive==2
    "Vector containing 1-the fluid temperature (K), 2-the flow (kg/s)"
    annotation (Placement(transformation(extent={{-120,12},{-80,52}}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={6,-90})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if ParoiActive==2
    "Vector containing 1-the fluid temperature (K), 2-the flow (kg/s)"
    annotation (Placement(transformation(extent={{84,-66},{116,-34}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-70})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if ParoiActive==3
    "Electric power injected into the floor"    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,-90})));
protected
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a NoeudTsolPlanch
    "Temperature between ground and floor"
    annotation (Placement(transformation(extent={{-25,-7},{-28,-10}})));
public
  BuildSysPro.Systems.HVAC.Emission.RadiantFloor.RadiantHeatingFloor
    PlancherChauffanteElec(
    S=S,
    caracParoi(
      n=caracParoi.n,
      m=caracParoi.m,
      e=caracParoi.e,
      mat=caracParoi.mat,
      positionIsolant=caracParoi.positionIsolant),
    nP=nP,
    TypeChauffage=2,
    Tp=Tp,
    InitType=InitType) if ParoiActive == 3 annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={2,-40})));
equation

if ParoiActive==1 then
  //connection of slices in the case of a conventional floor
  connect(plancherClassique.port_a, NoeudTsolPlanch);
  connect(plancherClassique.port_b, Ts_int);
elseif ParoiActive==2 then
  //connection of the nD slices in the case of a water heating floor
  for i in 1:nD loop
    connect(PlancherActifEau[i].Ts_b, Ts_int);
    connect(PlancherActifEau[i].Ts_a, NoeudTsolPlanch);
  end for;
  connect(PlancherActifEau[1].Entree,EntreeEau);
  for i in  2:nD loop
    connect(PlancherActifEau[i-1].Sortie,PlancherActifEau[i].Entree);
  end for;
  connect(PlancherActifEau[nD].Sortie,SortieEau);

else // ParoiActive==3
  //connection of slices in the case of an electric heating floor
end if;

  if not SurEquivalentTerre then
    connect(NoeudTsolPlanch, NoeudTsol)
                                      annotation (Line(
      points={{-26.5,-8.5},{-66.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;

  connect(thermalConductor.port_b, T_int)  annotation (Line(
      points={{70.95,32},{74,32},{74,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ts_int, thermalConductor.port_a)
                                         annotation (Line(
      points={{30,0},{46,0},{46,32},{52.05,32}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(prescribedHeatFlow2.port, Ts_int) annotation (Line(
      points={{51.3,88.02},{51.3,87.01},{30,87.01},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FluxAbsInt, prescribedHeatFlow2.Q_flow) annotation (Line(
      points={{99,89},{81.5,89},{81.5,88.02},{65.3,88.02}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(TemperatureSol.port, NoeudTsol) annotation (Line(
      points={{-81,0},{-72,0},{-72,-8.5},{-66.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tsol, NoeudTsol) annotation (Line(
      points={{-90,-30},{-72,-30},{-72,-8.5},{-66.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));
 connect(NoeudTsol, Sol.port_a)                 annotation (Line(
      points={{-66.5,-8.5},{-60,-8.5},{-60,16},{-55,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Sol.port_b, NoeudTsolPlanch)
    annotation (Line(
      points={{-37,16},{-32,16},{-32,-8.5},{-26.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (
Documentation(info="<html>
<p><b>Model of a slab-on-grade floor, the ground is modelled as purely conductive and considers solar fluxes transmitted through windows</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Inner floor on a slab-on-grade floor model with a boundary condition on underside temperature (ground temperature). Modelling considers only the 1D conduction within the floor and the ground. On the upper side, convection and long wavelengths exchanges are modelled by a global surface exchange coefficient <code>hs</code>. The optional parameter <code>RadInterne</code> allows to take into account short wavelengths flows.</p>
<p>The parameter <code>SurEquiValentTerre</code> allows to take into account a ground layer whose thickness, mesh and type (clay/silt or sand/gravel) are defined in the <i>Ground parameters</i> section. In case this parameter is False the ground constituent material must be considered in the <code>CaracParoi</code> parameter.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Complete the parameters regarding the type of models, inclusion of short wavelengths solar flux as well as a layer of a ground equivalent under the floor.</p>
<p>Complete the parameters of the slab / floor especially on the surface, the surface exchange coefficient and the characteristics of materials used. If <code>SurEquivalentTerre</code> = True is selected, fill in the <i>Groud Parameters</i> section information on the thickness of this layer and its discretization.</p>
<p>Complete the parameters for initialisation.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 : </p>
<ul>
<li>Ajout du choix de considérer ou non les flux CLO sur la face interne via le booléen RadInterne </li>
<li>Ajout d'une liste déroulante pour le choix des matériaux via l'annotation(choicesAllMatching=true)</li>
</ul>
<p>Vincent Magnaudeix 03/2012 : Ajout d'un noeud de température pour une connection à une température de sol variable</p>
<p>Aurélie Kaemmerlen 05/2011 : Modification du nom du connecteur CLOabs changé en FluxAbsInt</p>
<p>Gilles Plessis 06/2012 :</p>
<ul>
<li>Fusion des anciens modèles pour considérer le sol ou non</li>
<li>Insertion du record ParoiGenerique pour le paramètrage des caractéristiques de la paroi sous une forme &quot;replaceable&quot;</li>
</ul>
<p>Aurélie Kaemmerlen 07/2012 : Modification similaires à celles effectuées sur la paroi classique</p>
<ul>
<li>Intégration de l'option permettant d'en faire un plancher chauffant à eau, Modification du paramètre par défaut pour hint (5.88 au lieu de 1)</li>
<li>Intégration du modèle partiel de plancher chauffant électrique.</li>
</ul>
<p><br>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les flux absorbés intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiatives)</p>
<p>Benoît Charrier 12/2015 : ajout du paramètre caracTerre permettant de changer les caractéristiques physiques du sol</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={       Text(
          extent={{-10,22},{6,12}},
          lineColor={0,128,0},
          textString="OU
"),                                      Text(
          extent={{-10,-18},{6,-28}},
          lineColor={0,128,0},
          textString="OU
")}),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),graphics={
        Line(
          points={{20,0},{94,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,100},{20,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,132},{112,98}},
          lineColor={0,0,0},
          textString="%name"),
        Rectangle(
          extent={{-100,100},{-20,-100}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}),
    DymolaStoredErrors);
end FloorOnSlab;
