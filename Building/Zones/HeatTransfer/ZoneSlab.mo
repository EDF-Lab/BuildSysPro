within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneSlab
  "Modèle de zone parallépipèdique sur terre plein sans vitrage modélisé en thermique pure."

parameter Boolean ChoixPint=false
    "Prise en compte d'apports radiatifs au prorata des surfaces" annotation (
      choices(choice=true "Oui",
      choice=false "Non",radioButtons=true));

 parameter Boolean ChoixGLOext=false
    "Prise en compte du rayonnement GLO (infrarouge) entre les parois verticales et le ciel"
    annotation(choices(choice=true "Oui : attention, hext purement convectifs", choice=false "Non", radioButtons=true));

 parameter Modelica.SIunits.Volume Vair "Volume d'air intérieur";
 parameter Real beta=0
    "correction de l'azimut des murs verticaux (azimut=azimut{0,90,180,-90}+beta)";

 parameter Modelica.SIunits.Temperature Tair=293.15
    "Température initiale de l'air intérieur" annotation(Dialog(enable = not  InitType== Utilitaires.Types.InitCond.SteadyState,group="Paramètres d'initialisation"));
 parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale des parois" annotation (dialog(group="Paramètres d'initialisation"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (dialog(group="Paramètres d'initialisation"));

//Parois verticales//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    CaracParoiVert "Caractéristiques des parois verticales" annotation (
      __Dymola_choicesAllMatching=true, Dialog(tab="Parois Verticales"));
parameter Modelica.SIunits.Area S1nv=1 "surface de la paroi Sud (non vitrée)"  annotation(Dialog(tab="Parois Verticales"));
parameter Modelica.SIunits.Area S2nv=1
    "surface de la paroi Ouest (non vitrée)"                                     annotation(Dialog(tab="Parois Verticales"));
parameter Modelica.SIunits.Area S3nv=1 "surface de la paroi Nord (non vitrée)"
                                                                                 annotation(Dialog(tab="Parois Verticales"));
parameter Modelica.SIunits.Area S4nv=1 "surface de la paroi Est (non vitrée)"  annotation(Dialog(tab="Parois Verticales"));

parameter Modelica.SIunits.CoefficientOfHeatTransfer hextv annotation(Dialog(tab="Parois Verticales"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintv annotation(Dialog(tab="Parois Verticales"));
 parameter Real albedo=0.2 "albedo de l'environnement" annotation(Dialog(tab="Parois Verticales"));
 parameter Real alpha= 0.6
    "coefficient d'absorption de la surface ext. dans le visible"                       annotation(Dialog(tab="Parois Verticales"));
parameter Real eps=0.6 "Emissivité en GLO"
    annotation(dialog(enable=ChoixGLOext, tab="Parois Verticales"));

//Parois Horizontales//
//Plafond//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlaf
    "Caractéristiques du plafond" annotation (__Dymola_choicesAllMatching=true,
      Dialog(tab="Parois Horizontales", group="Plafond"));
parameter Modelica.SIunits.Area Splaf=1 "surface du plafond" annotation(Dialog(tab="Parois Horizontales", group="Plafond"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hplaf annotation(Dialog(tab="Parois Horizontales", group="Plafond"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintplaf annotation(Dialog(tab="Parois Horizontales", group="Plafond"));
parameter Real b=0.5
    "Coefficient de pondération des températures du plancher et du plafond";

//Plancher//
 parameter Integer PlancherActif=1
      annotation(dialog(tab="Parois Horizontales", group="Plancher",compact=true),
      choices(choice=1 "Paroi classique",
      choice=2 "Circulation d'eau",
      choice=3 "Résistance électrique",radioButtons=true));
 parameter Boolean CLfixe=true "Condition en température de sol fixe"
                                            annotation(dialog(tab="Parois Horizontales", group="Plancher",compact=true),choices(radioButtons=true));

  parameter Boolean SurEquivalentTerre=true
    "Prise en compte d'une couche de terre entre la paroi et Tsol"
     annotation(dialog(tab="Parois Horizontales", group="Plancher",compact=true),choices(choice=true
        "Oui : Paroi en contact avec un matériau équivalent à de la terre",                                                                          choice=false
        "Non : Paroi classique",                                                                                                    radioButtons=true));

 parameter Modelica.SIunits.Temperature Ts=293.15 "Température du sol";
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlanch
    "Caractéristiques du plafond" annotation (__Dymola_choicesAllMatching=true,
      Dialog(tab="Parois Horizontales", group="Plancher"));
  parameter Modelica.SIunits.Area Splanch=1 "surface du plancher" annotation(Dialog(tab="Parois Horizontales", group="Plancher"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hplanch annotation(Dialog(tab="Parois Horizontales", group="Plancher"));

// Paramètre commun à la paroi active eau et au rayonnant électrique
 parameter Integer nP=1
    "Numéro de la couche dont la frontière supérieure est le lieu d'injection de la puissance - doit être strictement inférieur à n"
    annotation (Dialog(enable=not
                                 (PlancherActif==1), tab="Parois Horizontales", group="Plancher"));

// Paramètres propres à une paroi chauffante avec eau
  parameter Integer nD=8
    "Nombre de tranche de discrétisation du plancher à eau"
    annotation(dialog(enable=PlancherActif==2, tab="Parois Horizontales", group="Plancher"));
  parameter Modelica.SIunits.Distance Ltube=128
    "Longueur du serpentin de chauffe du plancher"
    annotation(dialog(enable=PlancherActif==2, tab="Parois Horizontales", group="Plancher"));
  parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Diamètre intérieure du tube"
    annotation(dialog(enable=PlancherActif==2, tab="Parois Horizontales", group="Plancher"));
  parameter Modelica.SIunits.Distance eT=0.0015 "Epaisseur du tube"
    annotation (Dialog(enable=PlancherActif==2, tab="Parois Horizontales", group="Plancher"));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Conductivité thermique du tube"
    annotation (Dialog(enable=PlancherActif==2, tab="Parois Horizontales", group="Plancher"));

// Composants
  Modelica.Blocks.Interfaces.RealInput Ensoleillement[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
    annotation (Placement(transformation(extent={{-192,-6},{-152,34}}),
        iconTransformation(extent={{-140,40},{-120,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-192,-22},{-172,-2}}),
        iconTransformation(extent={{-140,80},{-120,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairint
    annotation (Placement(transformation(extent={{20,-58},{40,-38}}),
        iconTransformation(extent={{20,-42},{40,-22}})));

protected
  AirFlow.HeatTransfer.AirNode                       noeudAir(V=Vair, Tair(
        displayUnit="K") = Tair)
    annotation (Placement(transformation(extent={{18,0},{38,20}})));
  BuildingEnvelope.HeatTransfer.Wall              Sud(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S1nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,10},{-40,28}})));

  BuildingEnvelope.HeatTransfer.Wall              Ouest(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S2nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps)
    annotation (Placement(transformation(extent={{-58,-44},{-40,-26}})));

  BuildingEnvelope.HeatTransfer.Wall              Nord(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S3nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,38},{-40,56}})));

  BuildingEnvelope.HeatTransfer.Wall              Est(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S4nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,-18},{-40,0}})));

  BuildingEnvelope.HeatTransfer.Wall              Plafond(
    InitType=InitType,
    caracParoi(
      n=CaracPlaf.n,
      m=CaracPlaf.m,
      e=CaracPlaf.e,
      mat=CaracPlaf.mat,
      positionIsolant=CaracPlaf.positionIsolant),
    S=Splaf,
    hs_ext=hplaf,
    hs_int=hintplaf,
    Tp=Tp,
    ParoiInterne=true,
    RadInterne=ChoixPint)
    annotation (Placement(transformation(extent={{-58,70},{-38,90}})));
  BuildingEnvelope.HeatTransfer.FloorOnSlab paroiTerrePleinRadAvecSol(
    InitType=InitType,
    caracParoi(
      n=CaracPlanch.n,
      m=CaracPlanch.m,
      e=CaracPlanch.e,
      mat=CaracPlanch.mat,
      positionIsolant=CaracPlanch.positionIsolant),
    S=Splanch,
    Ts=Ts,
    hs=hplanch,
    RadInterne=ChoixPint,
    ParoiActive=PlancherActif,
    SurEquivalentTerre=SurEquivalentTerre,
    CLfixe=CLfixe)
    annotation (Placement(transformation(extent={{-56,-76},{-36,-56}})));

  BuildingEnvelope.HeatTransfer.B_Coefficient                      coefficient_b(b=b)
    annotation (Placement(transformation(extent={{-144,50},{-124,70}})));

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta,
      albedo=albedo)
    annotation (Placement(transformation(extent={{-116,4},{-96,24}})));

public
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tsol if
                                         not
                                            (CLfixe) "Température du sol"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if PlancherActif==3
    "Puissance électrique injectée dans le plancher"
                                                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-64}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-76})));
public
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if PlancherActif==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-130,-94},{-110,-74}}),
        iconTransformation(extent={{-160,-86},{-140,-66}})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if PlancherActif==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}}),
        iconTransformation(extent={{60,-86},{80,-66}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if
                                         ChoixGLOext annotation (Placement(
        transformation(extent={{-160,-40},{-140,-20}}), iconTransformation(
          extent={{-178,60},{-158,80}})));
Modelica.Blocks.Interfaces.RealInput      Pint if ChoixPint
    "Apports internes radiatifs"
    annotation (Placement(
        transformation(extent={{120,62},{80,102}}),iconTransformation(extent={{60,-18},
            {40,2}})));
  BoundaryConditions.Radiation.PintRadDistrib pintDistribRad(
    np=6,
    nf=4,
    Sp={Splaf,Splanch,S1nv,S2nv,S3nv,S4nv},
    Sf={1,1,1,1}) if         ChoixPint
    "Distribution au prorata des surfaces d'un flux radiatif quelconque"
    annotation (Placement(transformation(
        extent={{-18,-15},{18,15}},
        rotation=180,
        origin={56,77})));
equation
  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
      points={{-39,77},{-2,77},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{28,6},{30,6},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, Text) annotation (Line(
      points={{-182,-12},{-180,-12},{-180,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(coefficient_b.Tponder, Plafond.T_ext) annotation (Line(
      points={{-129,59.8},{-87.5,59.8},{-87.5,77},{-57,77}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, coefficient_b.port_ext) annotation (Line(
      points={{-182,-12},{-182,64},{-143,64},{-143,63}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, Sud.FLUX) annotation (Line(
      points={{-95,14.4},{-88,14.4},{-88,27.1},{-51.7,27.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, Est.FLUX) annotation (Line(
      points={{-95,10.4},{-88,10.4},{-88,-0.9},{-51.7,-0.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, Ouest.FLUX) annotation (Line(
      points={{-95,6.4},{-88,6.4},{-88,-26.9},{-51.7,-26.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, Nord.FLUX) annotation (Line(
      points={{-95,18.2},{-90,18.2},{-90,55.1},{-51.7,55.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Nord.T_ext, Text) annotation (Line(
      points={{-57.1,44.3},{-80,44.3},{-80,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Sud.T_ext, Text) annotation (Line(
      points={{-57.1,16.3},{-80,16.3},{-80,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Est.T_ext, Text) annotation (Line(
      points={{-57.1,-11.7},{-121.55,-11.7},{-121.55,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_ext, Text) annotation (Line(
      points={{-57.1,-37.7},{-80,-37.7},{-80,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_b.port_int, Tairint) annotation (Line(
      points={{-143,57},{-150,57},{-150,-78},{30,-78},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Nord.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,44.3},{-2,44.3},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Sud.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,16.3},{-2,16.3},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Est.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,-11.7},{-2,-11.7},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,-37.7},{-2,-37.7},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.T_int, noeudAir.port_a) annotation (Line(
      points={{-37,-66},{-2,-66},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tsol, paroiTerrePleinRadAvecSol.Tsol) annotation (Line(
      points={{-70,-110},{-70,-66},{-57,-66}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.SortieEau, SortieEau) annotation (Line(
      points={{-37,-73},{-6.5,-73},{-6.5,-90},{30,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.EntreeEau, EntreeEau) annotation (Line(
      points={{-45.4,-75},{-45.4,-84},{-120,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.PelecPRE, PelecPRE) annotation (Line(
      points={{-46.8,-75},{-46.8,-82},{-104,-82},{-104,-64},{-120,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_ciel, Ouest.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,-43.1},{-57.1,-43.1}},
      color={191,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(T_ciel, Est.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,-17.1},{-57.1,-17.1}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Sud.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,10.9},{-57.1,10.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Nord.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,38.9},{-57.1,38.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Plafond.FluxAbsInt, pintDistribRad.FLUXParois[1]) annotation (Line(
      points={{-45,85},{11.5,85},{11.5,81.25},{36.2,81.25}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.FluxAbsInt, pintDistribRad.FLUXParois[2])
    annotation (Line(
      points={{-43,-61},{12,-61},{12,80.75},{36.2,80.75}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Nord.FluxAbsInt, pintDistribRad.FLUXParois[5]) annotation (Line(
      points={{-46.3,51.5},{12,51.5},{12,79.25},{36.2,79.25}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Sud.FluxAbsInt, pintDistribRad.FLUXParois[3]) annotation (Line(
      points={{-46.3,23.5},{12,23.5},{12,80.25},{36.2,80.25}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Est.FluxAbsInt, pintDistribRad.FLUXParois[6]) annotation (Line(
      points={{-46.3,-4.5},{12,-4.5},{12,78.75},{36.2,78.75}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Ouest.FluxAbsInt, pintDistribRad.FLUXParois[4]) annotation (Line(
      points={{-46.3,-30.5},{12,-30.5},{12,79.75},{36.2,79.75}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Ensoleillement, fLUXzone.G) annotation (Line(
      points={{-172,14},{-144.45,14},{-144.45,13.9},{-116.9,13.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pint, pintDistribRad.RayEntrant) annotation (Line(
      points={{100,82},{87,82},{87,77},{72.2,77}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<h4>Modèle de zone parallèpipèdique sur terre plein sans vitrage modélisé en thermique pure.</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de bâtiment parallélépipédique monozone sur terre plein sans vitrage, à connecter à un modèle de conditions limites(port thermique de gauche) et realOutput de gauche pour les flux solaires. Par défaut les murs sont orientés selon les quatres points cardinaux; la modification de l'orientation est représentée par le paramètre beta. Le port thermique de droite est connecté au volume intérieur (capacité thermique). Les températures extérieures auxquelles sont soumis le plancher et le plafond sont pondérées par un coefficient b. Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux</b>. </p>
<p><u><b>Bibliographie</b></u></p>
<p>Néant.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Ce modèle de bâtiment monozone est à connecter à un modèle de conditions limites météo sur la gauche (Température extérieure, données relatives à l'ensoleillement). Le port thermique de droite est connecté au volume intérieur (capacité thermique) et peut, si désiré, être relié à tout modèle utilisant un port thermique (apports internes...).</p>
<p>Le paramètrage des parois se fait par l'intermédiaire du paramètre caracParoi, cependant on peut toujours paramétrer les parois couche par couche sans créer de type de paroi. </p>
<ol>
<li><i><b>Cliquer sur la petite flèche de caracParoi+ Edit</b></i></li>
<li><i><b>Remplir les champs concernant le nombre de couches, leur épaisseur, le maillage. Le paramètre positionIsolant est optionnel</b></i></li>
<li><i><b>Pour le paramètre mat, cliquer sur la petite flèche + Edit array, faire correspondre le nombre de case sur une colonne au nombre de couche de matériaux dans la fenêtre s'affichant puis dans chaque case effectuer un clic droit + Insert function Call et parcourir la bibliothèque pour indiquer le chemin du matériaux souhaité (dans <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\">Utilities.Data.Solids</a>)</b></i></li>
</ol>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux</b>. </p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Ludovic Darnaud 07/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Ludovic DARNAUD, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen & Gilles Plessis 03/2011 </p>
<ul>
<li>Changement du modèle de coefficient B pour vérifier la conservation d'énergie + Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(__Dymola_choicesAllMatching=true)</li>
<li>Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</li>
<li>Ajout des surfaces des parois verticales !</li>
</ul>
<p><br>Gilles Plessis 02/2012 : Suppression du modifier <i>each </i>dans la définition des matériaux des parois. Le mot clé each n'a pas à être présent car les matériaux des parois sont définis en temps que vecteur.</p>
<p>Gilles Plessis 02/2012 : Modification du type de paroi pour le plafond de<i> paroiComplete</i> en <i>paroi</i></p>
<p>Gilles Plessis 06/2012 : </p>
<ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul>
<p><br>Aurélie Kaemmerlen 07/2012 : Ajout de booléens supplémentaires présents dans les parois</p>
<ul>
<li>Plancher chauffant électrique ou à eau,</li>
<li>Température de sol pouvant être non constante</li>
<li>Rayonnement avec le ciel pour les parois verticales, </li>
<li>Injection d'un flux radiatif (via des panneaux rayonnants par exemple, avec distribution au prorata des surfaces)</li>
</ul>
<p><br>Amy Lindsay 03/2014 : - changement des FluxSolInput en RealInput pour les apports internes Pint</p>
<p>- rajout du connect entre Pint et pintDistribRad</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-140,20},{60,-100}},
          lineColor={0,0,255},
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-140,20},{60,20},{-40,98},{-140,20}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={226,98,12},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-200,98},{-140,42}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-200,-76},{100,-100}},
          lineColor={0,255,0},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid)}),                                                          Dialog(tab="Parois Horizontales", group="Plafond"), Diagram(
        coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},{100,100}}),
        graphics),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,-100},
            {100,100}}),       graphics),
                               Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-200,-100},{100,100}}), graphics={
        Ellipse(
          extent={{12,98},{72,42}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160,20},{40,-100}},
          lineColor={0,0,255},
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-160,20},{40,20},{-60,98},{-160,20}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={226,98,12},
          fillPattern=FillPattern.Solid)}));
end ZoneSlab;
