within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpace "Modèle de zone sur vide sanitaire en thermique pure."

 parameter Modelica.SIunits.Volume Vair "Volume d'air intérieur";
 parameter Real beta=0
    "correction de l'azimut des murs verticaux (azimut=azimut{0,90,180,-90}+beta)";

 parameter Boolean ChoixPint=false
    "Prise en compte d'apports radiatifs au prorata des surfaces" annotation (
      choices(choice=true "Oui",
      choice=false "Non",radioButtons=true));
 parameter Boolean ChoixGLOext=false
    "Prise en compte du rayonnement GLO (infrarouge) entre les parois verticales et le ciel"
    annotation(choices(choice=true "Oui : attention, hext purement convectifs", choice=false "Non", radioButtons=true));

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

parameter Real bCombles=0.5
    "Coefficient de pondération des températures du plafond sur combles perdus";
parameter Real bVS=0.5
    "Coefficient de pondération des températures du plancher sur vide sanitaire";

//Plancher//
 parameter Integer PlancherActif=1
      annotation(dialog(tab="Parois Horizontales", group="Plancher",compact=true),
      choices(choice=1 "Plancher classique",
      choice=2 "Plancher chauffant avec circulation d'eau",
      choice=3 "Plancher rayonnant électrique",radioButtons=true));

  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlanch
    "Caractéristiques du plancher" annotation (__Dymola_choicesAllMatching=
        true, Dialog(tab="Parois Horizontales", group="Plancher"));
parameter Modelica.SIunits.Area Splanch=1 "surface du plancher" annotation(Dialog(tab="Parois Horizontales", group="Plancher"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hplanch annotation(Dialog(tab="Parois Horizontales", group="Plancher"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintplanch annotation(Dialog(tab="Parois Horizontales", group="Plancher"));

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
        iconTransformation(extent={{20,-62},{40,-42}})));

protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tair)
    annotation (Placement(transformation(extent={{18,0},{38,20}})));

  BuildingEnvelope.HeatTransfer.Wall Sud(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S1nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,10},{-40,28}})));

  BuildingEnvelope.HeatTransfer.Wall Ouest(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S2nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps)
    annotation (Placement(transformation(extent={{-58,-44},{-40,-26}})));

  BuildingEnvelope.HeatTransfer.Wall Nord(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S3nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,38},{-40,56}})));

  BuildingEnvelope.HeatTransfer.Wall Est(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S4nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,-18},{-40,0}})));

  BuildingEnvelope.HeatTransfer.Wall Plafond(
    caracParoi(
      n=CaracPlaf.n,
      m=CaracPlaf.m,
      e=CaracPlaf.e,
      mat=CaracPlaf.mat,
      positionIsolant=CaracPlaf.positionIsolant),
    InitType=InitType,
    S=Splaf,
    hs_ext=hplaf,
    hs_int=hintplaf,
    Tp=Tp,
    ParoiInterne=true,
    RadInterne=ChoixPint)
    annotation (Placement(transformation(extent={{-58,70},{-38,90}})));

  BuildingEnvelope.HeatTransfer.Wall Plancher(
    caracParoi(
      n=CaracPlanch.n,
      m=CaracPlanch.m,
      e=CaracPlanch.e,
      mat=CaracPlanch.mat,
      positionIsolant=CaracPlanch.positionIsolant),
    InitType=InitType,
    S=Splanch,
    hs_ext=hplanch,
    hs_int=hintplanch,
    Tp=Tp,
    ParoiInterne=true,
    ParoiActive=PlancherActif,
    nP=nP,
    nD=nD,
    Ltube=Ltube,
    DiametreInt=DiametreInt,
    eT=eT,
    lambdaT=lambdaT,
    RadInterne=ChoixPint)
    annotation (Placement(transformation(extent={{-58,-74},{-38,-54}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficient_bCombles(b=
        bCombles)
    annotation (Placement(transformation(extent={{-144,70},{-124,50}})));

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta,
      albedo=albedo)
    annotation (Placement(transformation(extent={{-116,4},{-96,24}})));
public
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if PlancherActif==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-110,-104},{-90,-84}}),
        iconTransformation(extent={{-160,-110},{-140,-90}})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if PlancherActif==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}}),
        iconTransformation(extent={{60,-110},{80,-90}})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if PlancherActif==3
    "Puissance électrique injectée dans le plancher"
                                                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-74}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-100})));
  BuildingEnvelope.HeatTransfer.B_Coefficient coefficient_bVS(b=bVS)
    annotation (Placement(transformation(extent={{-146,-68},{-126,-48}})));
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
Modelica.Blocks.Interfaces.RealInput      Pint if ChoixPint
    "Apports internes radiatifs"
    annotation (Placement(
        transformation(extent={{120,60},{80,100}}),iconTransformation(extent={{60,-18},
            {40,2}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if
                                         ChoixGLOext annotation (Placement(
        transformation(extent={{-160,-40},{-140,-20}}), iconTransformation(
          extent={{-180,60},{-160,80}})));
equation

  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
      points={{-39,77},{4,77},{4,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plancher.T_int, noeudAir.port_a) annotation (Line(
      points={{-39,-67},{4,-67},{4,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{28,6},{30,6},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bCombles.Tponder, Plafond.T_ext)
                                                annotation (Line(
      points={{-129,60.2},{-89.5,60.2},{-89.5,77},{-57,77}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, coefficient_bCombles.port_ext)
                                        annotation (Line(
      points={{-182,-12},{-182,56},{-143,56},{-143,57}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ensoleillement, fLUXzone.G) annotation (Line(
      points={{-172,14},{-144.45,14},{-144.45,13.9},{-116.9,13.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, Sud.FLUX) annotation (Line(
      points={{-95,14.4},{-88,14.4},{-88,27.1},{-51.7,27.1}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fLUXzone.FLUXEst, Est.FLUX) annotation (Line(
      points={{-95,10.4},{-88,10.4},{-88,-0.9},{-51.7,-0.9}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fLUXzone.FLUXouest, Ouest.FLUX) annotation (Line(
      points={{-95,6.4},{-88,6.4},{-88,-26.9},{-51.7,-26.9}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fLUXzone.FLUXNord, Nord.FLUX) annotation (Line(
      points={{-95,18.2},{-90,18.2},{-90,55.1},{-51.7,55.1}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
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
  connect(coefficient_bCombles.port_int, Tairint)
                                           annotation (Line(
      points={{-143,63},{-150,63},{-150,96},{30,96},{30,-48}},
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
  connect(EntreeEau, Plancher.EntreeEau) annotation (Line(
      points={{-100,-94},{-86,-94},{-86,-61.4},{-57,-61.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Plancher.SortieEau, SortieEau) annotation (Line(
      points={{-39,-71},{-20,-71},{-20,-100},{50,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Plancher.PelecPRE, PelecPRE) annotation (Line(
      points={{-57,-63},{-86,-63},{-86,-74},{-100,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Text, coefficient_bVS.port_ext) annotation (Line(
      points={{-182,-12},{-182,-55},{-145,-55}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bVS.port_int, Tairint) annotation (Line(
      points={{-145,-61},{-180,-61},{-180,-106},{30,-106},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bVS.Tponder, Plancher.T_ext) annotation (Line(
      points={{-131,-58.2},{-93.5,-58.2},{-93.5,-67},{-57,-67}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Pint, pintDistribRad.RayEntrant) annotation (Line(
      points={{100,80},{90,80},{90,77},{72.2,77}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pintDistribRad.FLUXParois[1], Plafond.FluxAbsInt) annotation (Line(
      points={{36.2,81.25},{10,81.25},{10,85},{-45,85}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pintDistribRad.FLUXParois[2], Plancher.FluxAbsInt) annotation (Line(
      points={{36.2,80.75},{38,80.75},{38,80},{10,80},{10,-59},{-45,-59}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(T_ciel, Nord.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,38.9},{-57.1,38.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Sud.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,10.9},{-57.1,10.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Est.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,-17.1},{-57.1,-17.1}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Ouest.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,-43.1},{-57.1,-43.1}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[5], Nord.FluxAbsInt) annotation (Line(
      points={{36.2,79.25},{10,79.25},{10,51.5},{-46.3,51.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[3], Sud.FluxAbsInt) annotation (Line(
      points={{36.2,80.25},{10,80.25},{10,23.5},{-46.3,23.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[6], Est.FluxAbsInt) annotation (Line(
      points={{36.2,78.75},{22,78.75},{22,80},{10,80},{10,-4.5},{-46.3,-4.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[4], Ouest.FluxAbsInt) annotation (Line(
      points={{36.2,79.75},{10,79.75},{10,-30.5},{-46.3,-30.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<h4>Modèle de zone parallèpipèdique sur vide sanitaire sans vitrage modélisé en thermique pure.</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de bâtiment parallélépipédique monozone sur vide sanitaire sans vitrage, à connecter à un modèle de conditions limites(port thermique de gauche) et realOutput de gauche pour les flux solaires. Par défaut les murs sont orientés selon les quatres points cardinaux; la modification de l'orientation est représentée par le paramètre beta. Le port thermique de droite est connecté au volume intérieur (capacité thermique). Les températures extérieures auxquelles sont soumis le plancher et le plafond sont pondérées par un coefficient b. Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux</b>. </p>
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
<p>Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux.</b></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Ludovic Darnaud 07/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Ludovic DARNAUD, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2011: Changement du modèle de coefficient B pour vérifier la conservation d'énergie + Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(__Dymola_choicesAllMatching=true)</p>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</p>
<p>Gilles Plessis 02/2012 : Suppression du modifier <i>each </i>dans la définition des matériaux des parois. Le mot clé each n'a pas à être présent car les matériaux des parois sont définis en temps que vecteur.</p>
<p>Gilles Plessis 02/2012 : Modification du type de paroi pour le plancher et le plafond de<i> paroiComplete</i> en <i>paroi</i></p>
<p>Gilles Plessis 06/2012 : </p>
<ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul>
<p>Vincent Magnaudeix 06/2012 : Coefficient b de réduction de température distinct pour le plafond et le plancher</p>
<p>Aurélie Kaemmerlen 07/2012 : Ajout de booléens supplémentaires présents dans les parois</p>
<ul>
<li>Plancher chauffant électrique ou à eau,</li>
<li>Rayonnement avec le ciel pour les parois verticales, </li>
<li>Injection d'un flux radiatif (via des panneaux rayonnants par exemple, avec distribution au prorata des surfaces)</li>
</ul>
<p><br>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les apports internes Pint</p>
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
end ZoneCrawlSpace;
