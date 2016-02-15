within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneNWalls "Modèle de zone à N parois et NF fenêtres"

// Paramètres globaux du modèles//
parameter Integer N=4 "Nombre de parois verticales";
parameter Integer NF=1 "Nombre de fenêtres";
parameter Real albedo=0.2 "Albedo de l'environnement";
parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale des parois et du noeud d'air";

// Entrées et sorties du modèle//
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_sol "Tsol"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}}),
        iconTransformation(extent={{-100,-80},{-80,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_Tint "Tint"
    annotation (Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,0},{100,20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_Text "Text"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Interfaces.RealInput G[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
                                            annotation (Placement(
        transformation(extent={{-120,40},{-80,80}}), iconTransformation(extent={
            {-100,50},{-80,70}})));
//Parois horizontales//
//Plafond//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracPlaf
    "Caractéristiques du plafond" annotation (__Dymola_choicesAllMatching=true,
      Dialog(tab="Parois horizontales", group="Plafond"));
    parameter Modelica.SIunits.Area SPlaf=1 "surface du plafond" annotation(Dialog(tab="Parois horizontales",group="Plafond"));
    parameter Real azimutPlaf=0
    "Azimut du plafond par rapport au Sud : S=0°, E=-90°, O=90°, N=180°"
                        annotation(Dialog(tab="Parois horizontales",group="Plafond"));
    parameter Real inclPlaf=0 "Inclinaison du plafond"
                             annotation(Dialog(tab="Parois horizontales",group="Plafond"));
    parameter Real alphaPlaf=0.5 "Coefficient d'absorption solaire du plafond"
                                                  annotation(Dialog(tab="Parois horizontales",group="Plafond"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hPlaf=1
    "coefficient d'échange surfacique global sur la face a" annotation(Dialog(tab="Parois horizontales",group="Plafond"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintPlaf=1
    "coefficient d'échange surfacique global sur la face b" annotation(Dialog(tab="Parois horizontales",group="Plafond"));
protected
  Building.BuildingEnvelope.HeatTransfer.Wall Plafond(
    caracParoi(
      n=caracPlaf.n,
      m=caracPlaf.m,
      e=caracPlaf.e,
      mat=caracPlaf.mat,
      positionIsolant=caracPlaf.positionIsolant),
    S=SPlaf,
    alpha_ext=alphaPlaf,
    hs_ext=hPlaf,
    hs_int=hintPlaf,
    Tp=Tp,
    RadInterne=true,
    ParoiInterne=false,
    RadExterne=false);

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf ProjectionSolairePlafond(
    albedo=albedo,
    azimut=azimutPlaf,
    incl=inclPlaf);

//Plancher//
public
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracPlanch
    "Caractéristiques du plafond" annotation (__Dymola_choicesAllMatching=true,
      Dialog(tab="Parois horizontales", group="Plancher"));
    parameter Modelica.SIunits.Area SPlan=1 "surface du plancher" annotation(Dialog(tab="Parois horizontales",group="Plancher"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintPlan=1
    "coefficient d'échange surfacique global sur la face intérieur" annotation(Dialog(tab="Parois horizontales",group="Plancher"));
protected
  Building.BuildingEnvelope.HeatTransfer.Wall Plancher(
    caracParoi(
      n=caracPlanch.n,
      m=caracPlanch.m,
      e=caracPlanch.e,
      mat=caracPlanch.mat,
      positionIsolant=caracPlanch.positionIsolant),
    S=SPlan,
    hs_int=hintPlan,
    Tp=Tp,
    RadInterne=true,
    ParoiInterne=true,
    RadExterne=false);

//Parois verticales//
public
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracParoiVert[N] "Caractéristiques du plafond" annotation (
      __Dymola_choicesAllMatching=true, Dialog(tab="Parois verticales"));
    parameter Modelica.SIunits.Area[N] SVert=ones(N)
    "surface des parois verticales" annotation(Dialog(tab="Parois verticales"));
    parameter Real[N] alphaVert=fill(0.5,N)
    "Coefficient d'absorption solaire des parois verticales (départ paroi Sud puis sens horaire)"
     annotation(Dialog(tab="Parois verticales"));
    parameter Real[N] azimutVert={0,90,180,-90}
    "Azimut des parois verticales par rapport au Sud : S=0°, E=-90°, O=90°, N=180°"
                                                                                    annotation(Dialog(tab="Parois verticales"));
    parameter Real[N] inclVert=fill(90,N) "Inclinaison des parois verticales"
                                        annotation(Dialog(tab="Parois verticales"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hVert=25
    "coefficient d'échange surfacique global sur la face extérieur" annotation(Dialog(tab="Parois verticales"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintVert=8.29
    "coefficient d'échange surfacique global sur la face intérieur" annotation(Dialog(tab="Parois verticales"));
protected
  Building.BuildingEnvelope.HeatTransfer.Wall[N] paroisVerticales(
    caracParoi(
      n=caracParoiVert.n,
      m=caracParoiVert.m,
      e=caracParoiVert.e,
      mat=caracParoiVert.mat,
      positionIsolant=caracParoiVert.positionIsolant),
    S=SVert,
    alpha_ext=alphaVert,
    each hs_int=hintVert,
    each hs_ext=hVert,
    Tp=fill(Tp, N),
    each RadInterne=true,
    each ParoiInterne=false,
    each RadExterne=false);

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf[N] ProjectionSolaireVert(
    each albedo=albedo,
    azimut=azimutVert,
    incl=inclVert);
//Fenêtres//
public
    parameter Modelica.SIunits.CoefficientOfHeatTransfer[NF] Ufen=fill(3,NF)
    "Conductivité thermique du vitrage (départ fenêtre Sud puis sens horaire)"
                                                                               annotation(Dialog(tab="Fenêtres"));
    parameter Real[NF] tauFen= fill(0.5,NF)
    "Coefficient de transmission énergétique (départ fenêtre Sud puis sens horaire)"
                                                                                       annotation(Dialog(tab="Fenêtres"));
    parameter Real[NF] gFen= fill(0.6,NF)
    "facteurs solaires (départ fenêtre Sud puis sens horaire)"                         annotation(Dialog(tab="Fenêtres"));
    parameter Modelica.SIunits.Area[NF] SFen=ones(NF)
    "Surface de chacune des fenêtres (départ fenêtre Sud puis sens horaire)"
                                                                             annotation(Dialog(tab="Fenêtres"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hFen=25
    "Coefficient d'échange surfacique global sur la face ext (25 W/m²/K pour norme EN 410 et 673)("
                                                                                                        annotation(Dialog(tab="Fenêtres"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintFen=8.29
    "Coefficient d'échange surfacique global sur la face int (8.29 W/m²/K pour norme EN 410 et 673)"
                                                                                                        annotation(Dialog(tab="Fenêtres"));
    parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg[NF]
    azimutFen =                                                               zeros(NF)
    "Azimut de chacune des fenêtres par rapport au Sud : S=0°, E=-90°, O=90°, N=180°"
                                                                                      annotation(Dialog(tab="Fenêtres"));
    parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg[NF] inclFen=fill(90,NF)
    "Inclinaison des fenêtres (départ fenêtre Sud puis sens horaire)" annotation(Dialog(tab="Fenêtres"));
protected
    BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow[NF] DVitrages(
    U=Ufen,
    tau=tauFen,
    g=gFen,
    S=SFen,
    each hs_ext=hFen,
    each hs_int=hintFen,
    each RadInterne=true,
    each DifDirOut=false);

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf[NF] ProjectionSolaireFen(
    each albedo=albedo,
    azimut=azimutFen,
    incl=inclFen);

//Zone interne//
public
    parameter Modelica.SIunits.Volume Vzone=10 "Volume [mCube] de la zone"
                                annotation(Dialog(tab="Zone interne"));
protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(Tair=Tp, V=Vzone);

//Renouvellement d'air//
    final constant Modelica.SIunits.Volume changUnit=1;
public
    parameter Real DebitRenouv=Vzone/changUnit
    "Debit de renouvellement d'air horaire [m3/h]" annotation(Dialog(tab="Renouvellement d'air"));
protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        DebitRenouv);

// Répartition des flux solaires au prorata des surfaces

  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib RepartitionSolaireInterne(
    np=N + 2,
    Sp=cat(
        1,
        SVert,
        {SPlaf},
        {SPlan}),
    nf=NF,
    Sf=SFen);

     Modelica.Blocks.Math.MultiSum SommeFluxSolaireInterne(nu=NF);

equation
  // Connection sur les parois verticales
  for i in 1:N loop
  connect(G,ProjectionSolaireVert[i].G);
  connect(ProjectionSolaireVert[i].FLUX,paroisVerticales[i].FLUX);
  connect(port_Text,paroisVerticales[i].T_ext);
  connect(paroisVerticales[i].T_int,noeudAir.port_a);
  connect(RepartitionSolaireInterne.FLUXParois[i],paroisVerticales[i].FluxAbsInt);
  end for;

  // Connections sur les fenêtres
  for i in 1:NF loop
  connect(G,ProjectionSolaireFen[i].G);
  connect(ProjectionSolaireFen[i].FLUX,DVitrages[i].FLUX);
  connect(port_Text,DVitrages[i].T_ext);
  connect(DVitrages[i].T_int,noeudAir.port_a);
  connect(DVitrages[i].CLOTr,SommeFluxSolaireInterne.u[i]);
  connect(RepartitionSolaireInterne.FLUXFenetres[i],DVitrages[i].FluxAbsInt);
  end for;

// Connection sur le plafond
  connect(G,ProjectionSolairePlafond.G);
  connect(ProjectionSolairePlafond.FLUX,Plafond.FLUX);
  connect(port_Text,Plafond.T_ext);
  connect(Plafond.T_int,noeudAir.port_a);
  connect(RepartitionSolaireInterne.FLUXParois[N+1],Plafond.FluxAbsInt);

// Connection sur le plancher
  connect(port_sol,Plancher.Ts_ext);
  connect(Plancher.T_int,noeudAir.port_a);
  connect(RepartitionSolaireInterne.FLUXParois[N+2],Plancher.FluxAbsInt);

// connection du renouvellement d'air
  connect(noeudAir.port_a, renouvellementAir.port_b);
  connect(renouvellementAir.port_a, port_Text);

// Connection du port port_Tint
  connect(noeudAir.port_a, port_Tint);

// Connection du flux solaire total transmis pour répartition
connect(SommeFluxSolaireInterne.y,RepartitionSolaireInterne.RayEntrant);

 annotation (Documentation(info="<html>
<h4>Modèle de zone à N parois et NF fenêtres en thermique pure.</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de zone therrmique à N parois verticales, NF fenêtres, 1 plancher et un plafond . Les parois sont de type Paroi et les fenêtres de type DVitrage. Ce modèle comporte aussi un renouvellement d'air.</p>
<p>Les parois verticales et le plafond sont connectés sur leur face extérieure au port thermique <i>port_Text</i> et sur leur face intérieure au port thermique <i>port_Tint</i>. Les fenêtres sont connectées de la même facon aux conditions limites extérieures et intérieures. Le plancher est connecté au port <i>port_sol</i> sur sa face extérieure et au port <i>port_Tint</i> sur sa face intérieure. Le renouvellement d'air est connecté au noeud d'air interne et au port thermique extérieur. Toutes ces conditions limites sont de types convectives et donc connectées sur la température de convection et non la température de surface à l'exception de du port <i>port_sol</i> .</p>
<p>La répartition des flux CLO transmis par les fenêtres à l'intérieur du bâti se fait au prorata des surfaces. L'ensolleillement est toujours pris en compte contrairement au modèle Paroi.</p>
<p>L'initialisation se fait en condition stationnaire à la température Tp.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Néant.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Ce modèle de bâtiment monozone est à connecter à un modèle de conditions limites météo sur la gauche (Température extérieure, données relatives à l'ensoleillement et température du sol). Le port thermique de droite est connecté au volume intérieur (capacité thermique) et peut, si désiré, être relié à tout modèle utilisant un port thermique. </p>
<p>Le paramètrage du plafond et du plancher se fait par l'intermédiaire du paramètre caracParoi (caracPlaf, caracPlanch), cependant on peut toujours paramétrer les parois couche par couche sans créer de type de paroi. </p>
<ol>
<li><i><b>Cliquer sur la petite flèche de caracParoi+ Edit</b></i></li>
<li><i><b>Remplir les champs concernant le nombre de couches, leur épaisseur, le maillage. Le paramètre positionIsolant est optionnel</b></i></li>
<li><i><b>Pour le paramètre mat, cliquer sur la petite flèche + Edit array, faire correspondre le nombre de case sur une colonne au nombre de couche de matériaux dans la fenêtre s'affichant puis dans chaque case effectuer un clic droit + Insert function Call et parcourir la bibliothèque pour indiquer le chemin du matériaux souhaité (dans <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\">Utilities.Data.Solids</a>)</b></i></li>
</ol>
<p>Le paramètrage des parois verticales se fait par l'intermédiaire du paramètre caracParoiVert (dimension N) de l'onglet <i>Parois verticales</i></p>
<ol>
<li><i><b>Cliquer sur la petite flèche de caracParoiVert+ Edit Array</b></i></li>
<li><i><b>Ajuster le nombre de cases (lignes) au nombre de parois verticales N,</b></i></li>
<li><i><b>dans chaque case effectuer un clic droit + Insert function Call puis parcourir la bibliothèque pour indiquer le chemin du type de paroi souhaité (dans <a href=\"modelica://BuildSysPro.Utilities.Data.WallData\">Utilities.Data.WallData</a>)</b></i></li>
</ol>
<p>Il est à noter que l'on peut toujours paramétrer les parois couche par couche sans créer de type de paroi. Pour ce faire:</p>
<ol>
<li><i><b>Cliquer sur la petite flèche de caracParoiVert+ Edit Combined</b></i></li>
<li><i><b>Ajuster le nombre de lignes au nombre de parois verticales N,</b></i></li>
<li><i><b>Renseigner les épaisseurs, les mailles et le nombre de couches dans chaque paroi puis pour le matériau effectuer un clic droit + Insert function Call puis parcourir la bibliothèque pour indiquer le chemin du matériau souhaité (dans <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\">Utilities.Data.Solids</a>)</b></i></li>
</ol>
<p><br><b>Attention </b>il est impératif que l'ordre des parois soit le même dans la définition des différents champs, orientation, matériaux, surface, épaisseurs...</p>
<p>Par défaut la zone comporte une fenêtre au Sud et 4 parois verticales orientées selon les quatres points cardinaux. </p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>La répartition des flux solaires à l'intérieur du bâti est réalisée au prorata des surfaces. Elle est donc relativement simpliste. Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux.</b></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Validation en évolution libre par comparaison avec modèle assemblé - Gilles Plessis 10/2011</p>
<p>Validation dans <i>Assemblages.ThermiquePure.ValidationsUnitaires</i> : modèle ZoneNparoisTEST</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Gilles Plessis 03/2011 : Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(__Dymola_choicesAllMatching=true).</p>
<p>Gilles Plessis 02/2012 : Modification du modèle de renouvellement d'air.</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                         graphics),
    DymolaStoredErrors,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-38,10},{34,-42}},
          lineColor={0,0,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-84,26},{66,-92}}, lineColor={0,0,255}),
        Line(
          points={{90,60},{-60,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-84,26},{-60,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{66,26},{90,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{90,60},{90,-58}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{66,-92},{90,-58}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{74,28},{-54,50}},
          lineColor={0,0,255},
          textString="ZoneNparois"),
        Ellipse(
          extent={{-80,80},{-40,40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),      graphics),
    DymolaStoredErrors);
end ZoneNWalls;
