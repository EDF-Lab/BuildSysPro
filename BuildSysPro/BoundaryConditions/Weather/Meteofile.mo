within BuildSysPro.BoundaryConditions.Weather;
model Meteofile
  "Lecteur de fichiers météo (avec Azimut et Hauteur du Soleil)"

parameter Integer TypeMeteo=2 annotation(choices(
choice=1 "Meteofrance",
choice=2 "Météonorm France",
choice=3 "Météos RT",
choice=4 "Météo perso", radioButtons=true));

parameter Boolean Tempciel=true
    "true si la température de ciel est renseignée dans le fichier météo, false s'il faut la calculer"
                                                                                                        annotation(choices(
choice=true "Tciel renseignée dans le fichier texte", choice=false
        "Tciel à calculer"));
parameter Boolean HR=true
    "true si l'humidité relative est connue, false sinon"                        annotation(choices(
choice=true "Humidité relative (HR) renseignée dans le fichier texte", choice=false
        "HR non connue"),Dialog(enable=Tempciel==false));

  parameter String pth=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/RT2012/H1a.txt")
    "Chemin d'accès au fichier meteo"
  annotation(Dialog(__Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",
                           caption="Ouverture du fichier météo")));

  parameter BuildSysPro.Utilities.Records.MeteoData DonneesPerso
    "Données à saisir lors du choix d'un fichier météo perso"
    annotation (Dialog(enable=TypeMeteo == 4));

parameter Modelica.Blocks.Types.Smoothness Interpolation=Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    "Choix du type d'interpolation des données météo" annotation(Dialog(tab="Paramètres avancés"));

parameter Modelica.SIunits.Time Tbouclage=31536000
    "Fichier météo bouclé au-delà de Tbouclage si le stop time de la simulation y est supérieur"
    annotation(Dialog(tab="Paramètres avancés"));
parameter Real delta_t=3600
    "Période en secondes si choix de fonction en escalier."
    annotation (Dialog(tab="Paramètres avancés"));
parameter Integer table_column_number=11
    "Nombre de colonnes du fichier de données (hors première colonne du temps)"
                                                                                                        annotation (Dialog(tab="Paramètres avancés"));
parameter Integer option[:]=fill(1, table_column_number)
    "Nombre entier =0 pour une colonne s'il faut lui appliquer une fonction en escalier et >0 sinon."
    annotation (Dialog(tab="Paramètres avancés"));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tseche annotation (
     Placement(transformation(extent={{80,48},{100,68}}, rotation=0),
        iconTransformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Interfaces.RealOutput G[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
    annotation (Placement(transformation(extent={{82,-52},{118,-16}},
          rotation=0), iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,-20})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTseche
    annotation (Placement(transformation(extent={{26,48},{46,68}}, rotation=0)));
  BuildSysPro.BoundaryConditions.Weather.CombiTable1Ds_ForStepMeteo
    combiTimeTable(
    tableOnFile=true,
    tableName="data",
    columns={2,3,4,5,6,7,8,9,10,11,12},
    smoothness=Interpolation,
    delta_t=delta_t,
    option=option,
    fileName=pth)  annotation (Placement(transformation(extent={{-58,20},{-38,
            40}}, rotation=0)));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTrosee
    annotation (Placement(transformation(extent={{26,18},{46,38}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Trosee
    "Température de rosée" annotation (Placement(transformation(extent={{80,
            18},{100,38}}, rotation=0), iconTransformation(extent={{80,50},{100,
            70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tciel
    "Température du ciel" annotation (Placement(transformation(extent={{80,-14},
            {100,6}}, rotation=0), iconTransformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Interfaces.RealOutput V[2]
    "Vitesse (m/s) et direction du vent (provenance 0° - Nord, 90° - Est, 180° - Sud, 270° - Ouest)"
    annotation (Placement(transformation(extent={{82,-82},{118,-46}},
          rotation=0), iconTransformation(extent={{80,-60},{100,-40}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTseche
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTrosee
    annotation (Placement(transformation(extent={{-8,18},{12,38}})));
  Modelica.Blocks.Interfaces.RealOutput Hygro[3]
    "T (en K), Pt (en Pa), Pv (en Pa)"
    annotation (Placement(transformation(extent={{82,-110},{118,-74}},
          rotation=0), iconTransformation(extent={{80,-90},{100,-70}})));
protected
parameter Boolean ChoixEst=if TypeMeteo==4 then DonneesPerso.Est else true;
  Real ps;
  Real DIFH;
  Real DIRN;
  Real DIRH;
  Real GLOH;
  Real T_ciel;
  Real t0;
  Real CosDir[3];
  Real h0;
  Real d0;
  Real CoupleFlux;
  Real FluxMeteo[2];
  Real latitude;
  Real longitude;
  Real AzHaut[2];

public
  Modelica.Blocks.Sources.RealExpression Temps(y=mod(time, Tbouclage))
    annotation (Placement(transformation(extent={{-100,20},{-68,40}})));
  Modelica.Blocks.Tables.CombiTable1Ds   combiTimeTable1(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    columns={10},
    fileName=pth)    annotation (Placement(transformation(extent={{-58,-10},{
            -38,10}},      rotation=0)));
equation
  // Lecture des flux solaires, latitude et longitude
  // La longitude doit être donnée telle que Est>0 et Ouest<0 avec des valeurs absolues <180°

  when initial() then
    latitude=combiTimeTable.y[10];
    longitude =
      BuildSysPro.BoundaryConditions.Weather.Functions.ConvertLongitude(Est=
      ChoixEst, LongIn=combiTimeTable.y[11]);
    h0 = if (TypeMeteo==4) then DonneesPerso.h0 else (if (TypeMeteo==1 or TypeMeteo==3) then 0 else -1);
    d0 = if TypeMeteo==4 then DonneesPerso.d0 else 1;
    CoupleFlux= if TypeMeteo==4 then DonneesPerso.CoupleFlux else 2;
    t0=86400*(d0-1)+3600*h0;
  end when;

  //combiTimeTable.u=mod(time,31536000);

  FluxMeteo[1]=combiTimeTable.y[1];
  FluxMeteo[2]=combiTimeTable.y[2];

// Connecteur de Vent
 connect(combiTimeTable.y[8], V[1]) annotation (Line(
      points={{-37,30.3636},{-30,30.3636},{-30,-73},{100,-73}},
      color={0,0,127},
      smooth=Smooth.None));

// Connecteurs de Température
  connect(prescribedTseche.port, Tseche)      annotation (Line(
      points={{46,58},{90,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTrosee.port, Trosee)       annotation (Line(
      points={{46,28},{90,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(combiTimeTable.y[3], toKelvinTseche.Celsius)
                                                 annotation (Line(
      points={{-37,29.4545},{-26,29.4545},{-26,58},{-12,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTimeTable.y[4], toKelvinTrosee.Celsius)
                                                  annotation (Line(
      points={{-37,29.6364},{-34,29.6364},{-34,28},{-10,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvinTseche.Kelvin, prescribedTseche.T)
                                                    annotation (Line(
      points={{11,58},{24,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvinTrosee.Kelvin, prescribedTrosee.T)  annotation (Line(
      points={{13,28},{24,28}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connecteur Hygrothermique

  ps = BuildSysPro.BoundaryConditions.Weather.Functions.CalculPs(Hygro[1]);

  Hygro[1]=combiTimeTable.y[3]+273.15;
  Hygro[2]=combiTimeTable.y[6];
  Hygro[3]=combiTimeTable.y[7]*ps;

  // Calcul Tciel

  if Tempciel==false then
    if HR==true then
      T_ciel=Functions.CalculTsky_withRH(
        t=time,
        G=G,
        T_seche=Tseche.T,
        Pvap=Hygro[3]);
    else
      T_ciel=Functions.CalculTsky_withoutRH(
        t=time,
        G=G,
        T_seche=Tseche.T);
    end if;
  else
    T_ciel=combiTimeTable.y[5]+273.15;
  end if;

  Tciel.T=T_ciel;

  // Calcul des Cosinus Directeurs du vecteur Solaire

  (CosDir,AzHaut[1],AzHaut[2]) =
    BuildSysPro.BoundaryConditions.Solar.Utilities.CosDirSunVectorHeightAz(
    t0=t0,
    t=time,
    latitude=latitude,
    longitude=longitude);

  // Calcul des flux DIFH, DIRN, DIRH, GLOH

  if CoupleFlux<1.5 then
    GLOH = FluxMeteo[1];
    DIFH = FluxMeteo[2];
    DIRH=GLOH-DIFH;
    DIRN=if CosDir[1]>0 then DIRH/CosDir[1] else 0;
  elseif CoupleFlux<2.5 then
    DIRN = FluxMeteo[1];
    DIFH = FluxMeteo[2];
    DIRH=if CosDir[1]>0 then DIRN*CosDir[1] else 0;
    GLOH=DIRH+DIFH;
  elseif CoupleFlux<3.5 then
    DIFH = FluxMeteo[1];
    DIRH = FluxMeteo[2];
    GLOH=DIRH+DIFH;
    DIRN=if CosDir[1]>0 then DIRH/CosDir[1] else 0;
  elseif CoupleFlux<4.5 then
    GLOH = FluxMeteo[1];
    DIRH = FluxMeteo[2];
    DIRN=if CosDir[1]>0 then DIRH/CosDir[1] else 0;
    DIFH=GLOH-DIRH;
  else // CoupleFlux==5
    GLOH = FluxMeteo[1];
    DIRN = FluxMeteo[2];
    DIRH=if CosDir[1]>0 then DIRN*CosDir[1] else 0;
    DIFH=GLOH-DIRH;
  end if;

  //G[1:10]={DIFH,DIRN,DIRH,GLOH, t0, CosDir[1],CosDir[2],CosDir[3], latitude,longitude};
  G[1:10]={DIFH,DIRN,DIRH,GLOH, t0, CosDir[1],CosDir[2],CosDir[3], AzHaut[1],AzHaut[2]};

  if option[9]==0 then
    connect(combiTimeTable.y[9],V[2]);
  else
    connect(combiTimeTable1.y[1],V[2]);
  end if;
  connect(Temps.y, combiTimeTable.u) annotation (Line(
      points={{-66.4,30},{-60,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temps.y, combiTimeTable1.u) annotation (Line(
      points={{-66.4,30},{-64,30},{-64,0},{-60,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Ellipse(
          extent={{-48,50},{2,16}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-50,62},{-36,46}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-30,66},{-24,46}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-62,46},{-46,38}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-60,24},{-44,30}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Polygon(
          points={{-52,0},{-30,38},{14,36},{48,28},{60,0},{-52,0}},
          lineColor={85,170,255},
          lineThickness=1,
          smooth=Smooth.Bezier,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,64},{-16,44}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{8,52},{-10,42}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Text(
          extent={{-56,-16},{50,-44}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle permet de venir lire des fichiers météo mis sous un format bien précis (cf tableau ci-dessous)</p>
<p><u><b>Bibliographie</b></u></p>
<p>Néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<h4>Contenu des colonnes du fichier météo</h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Temps (s) </p></td>
<td><p>Flux solaire 1 (W/m&sup2;)</p><p>Direct normal par défaut</p></td>
<td><p>Flux solaire 2 (W/m&sup2;)</p><p>Diffus horizontal par défaut</p></td>
<td><p>Tsèche (&deg;C)</p><p>Température extérieure</p></td>
<td><p>Trosée (&deg;C)</p><p>Température de rosée</p></td>
<td><p>Tciel (&deg;C)</p><p>Température du ciel</p></td>
<td><p>Patm (Pa)</p><p>Pression atmosphérique</p></td>
<td><p>HR (entre 0 et 1)</p><p>Humidité relative</p></td>
<td><p>VitVent (m/s)</p><p>Vitesse du vent</p></td>
<td><p>DirVent (&deg;)</p><p>Direction du vent</p></td>
<td><p>Latitude (&deg;)</p></td>
<td><p>Longitude (&deg;)</p></td>
</tr>
</table>
<p><br><h4>Contenu du vecteur G en sortie</h4></p>
<p>(1) Flux diffus horizontal</p>
<p>(2) Flux direct normal</p>
<p>(3) Flux direct horizontal</p>
<p>(4) Flux global horizontal</p>
<p>(5) Heure en TU au temps t = 0 (début de simulation)</p>
<p>(6-7-8) Cosinus directeurs du soleil (6-sinh, 7-cosW, 8-cosS)</p>
<p>(9) Azimut du soleil</p>
<p>(10) Hauteur du soleil</p>
<h4>Contenu des autres connecteurs en sortie</h4>
<p>Les valeurs de la vitesse et de la direction du vent sont accessibles via la sortie <b>V</b> (respectivement V[1] et V[2]).</p>
<p>La sortie <b>Hygro</b> permet le raccordement direct aux connecteurs thermo-hygro-aérauliques et fournit les variables suivantes :</p>
<ul>
<li>Hygro[1] donne la température sèche de l'air en <b>degrés K</b> ( = Tsèche + 273.15)</li>
<li>Hygro[2] donne la pression <b>totale</b> <b>Pt </b>de l'air, supposé <b>humide</b> (=Patm)</li>
<li>Hygro[3] donne la pression <b>partielle de vapeur</b> <b>Pv</b> (=HR*Psat(T))</li>
</ul>
<h4>Remarques :</h4>
<ul>
<li>Le couple de flux lu par le lecteur meteo est paramétré via le choix de <i>CoupleFlux</i>. Par défaut, le modèle lit le couple FDIRN/FDIFH</li>
<li>Le temps dans le fichier météo peut être donné soit en temps universel (TU - h0=0) soit en temps local (TL - h0=Fuseau horaire). Les scénarios devront être cohérents avec le temps donné du fichier météo - il n'y a pas de passage à l'heure d'été.</li>
<li>Le même fichier annuel météo est automatiquement reconduit à l'identique à chaque fin d'année de sorte qu'on puisse lancer des simulations sur des saisons de chauffe : exemple 1er octobre (start time 23587200s) au 1er mai(stop time 41904000s) - Le paramètre avancé Tbouclage permet de boucler à partir d'une durée plus longue de sorte qu'un fichier de donnée supérieur à une année puisse être utilisé.</li>
</ul>
<p><u><b>Paramètres par défaut - lien avec le contenu du dossier Resources/Donnees/Meteo</b></u></p>
<p>Par défaut :</p>
<ul>
<li>Les flux donnés sont DIRN et DIFH </li>
<li>Le début des fichiers est à 0h00 le 1er janvier</li>
<li>La longitude est donnée en &deg;Est</li>
<li>La pression (en Pa) est une pression absolue, et est <b>supposée</b> être une pression totale d'air <b>humide</b> (exploitée comme telle dans les fonctions de calcul d'humidité)</li>
<li>L'humidité relative est comprise entre 0 et 1</li>
<li>Pour la direction du vent, l'Organisation Mondiale de la Météo suppose qu'un vent <b>venant</b> du nord soit codé 360, la rose des vents étant graduée dans le sens horaire (un vent d'est sera codé 90) <i>- à vérifier sur tous les fichiers météo -</i></li>
</ul>
<h4>Les fichiers disponibles, et leurs différences par rapport aux valeurs par défaut, sont :</h4>
<p>1/ <b>Meteofrance </b>: Flux moyens [t-dt/2;t+dt/2]. h0=0</p>
<p>2/ <b>Meteonorm</b> : Flux déterminés sur l'heure écoulée, ramenés au milieu de l'heure pour mieux correspondre au parcours du soleil. Temps local (h0=-1 en France)</p>
<p>3/ <b>Meteo réglementaire RT2012 </b>: Flux déterminés sur l'heure écoulée, ramenés au milieu de l'heure pour mieux correspondre au parcours du soleil. h0=0 (Temps Universel).</p>
<p>Pour des météos personnelles, attention à bien renseigner les paramètres conditionnant les calculs de flux incidents par la suite. Par exemple, pour des données commençant le 11 mai, à 15h30 (temps universel) - il faudra renseigner h0=15.5 et d0=135.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Attention au format du fichier météo : un fichier csv devra être exporté en .txt (texte séparateur tabulation), et devra avoir la même allure que les exemples donnés dans la documentation :</p>
<ul>
<li>pas de ligne vide avant la fin du fichier / Ligne vide obligatoire en fin de fichier</li>
<li>2 premières lignes copiées-collées des exemples (type de données (double), nom des données (data), commentaires, ...)</li>
</ul>
<p>Attention, la direction du vent est la <u>provenance</u> de celui-ci. De plus,<b> la convention des angles pour la direction du vent</b> (0&deg; - Nord, 90&deg; - Est, 180&deg; - Sud, 270&deg; - Ouest) <b>diffère bien de la convention des azimuts</b> pour le solaire et <b>pour les parois </b>(0&deg; - Sud, -90&deg; - Est, 90&deg; - Ouest, 180&deg; - Nord). A priori, cette convention de direction des vents est bien respectée dans le fichiers Meteonorm.</p>
<p>Dans les fichiers météo réglementaires (RT2012) a priori la direction de vent n'est pas connue. Elle a été renseignée en prenant le fichier Meteonorm pour chaque ville correspondant à une zone thermique (Trappes pour H1a etc.).</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Aurélie Kaemmerlen 2010</p>
<p><i><b>ATTENTION : validation du modèle uniquement et pas du contenu des fichiers météos notamment les conventions de temps / vérifier la cohérence des flux solaires incidents avec la hauteur du soleil calculé dans les modèles de rayonnement / vérifier que la direction du vent est bien donnée en cohérence avec la convention de l'OMM (0&deg; - Nord, 90&deg; - Est, 180&deg; - Sud, 270&deg; - Ouest)</b></i></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
<b>Copyright &copy; EDF 2009 - 2016</b><br/>
<b>BuildSysPro version 2015.12</b><br/>
<b>Author : Aurélie KAEMMERLEN, EDF (2010)</b><br/>
-------------------------------------------------------------- </p></html>",
    revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 : Inversion des composants 1 et 2 du vecteur <b>G</b> pour garder le même ordre des flux solaires entre le fichier météo d'entrée et ce vecteur <b>G</b> en sortie du lecteur Météo - Pas d'impact sur le format des fichiers mais les modèles utilisant le vecteur <b>G</b> modifiés en conséquent </p>
<p>Aurélie Kaemmerlen 05/2011 : Le vecteur<b> G</b> a été allongé avec 3 paramètres de plus : MoyFlux, dt et CoupleFlux permettant une plus grande réutilisabilité de ce lecteur Météo</p>
<p>Gilles Plessis 02/2012: Modification du type du paramètre pth (<i>String</i> changé en <i>Filename</i>) permettant l'utilisation d'une fenêtre pour atteindre le fichier de données.</p>
<p>Aurélie Kaemmerlen 03/2012 : Modification de la valeur par défaut de Est (=false pour Meteonorm qui est le fichier par défaut)</p>
<p>Aurélie Kaemmerlen 06/2012 :</p>
<ul>
<li>Désactivation de la saisie du paramètre dt lorsque la moyenne est une moyenne classique,</li>
<li>Ajout de documentation pour préciser le mode d'emploi du modèle</li>
<li>Automatisation du choix des fichiers météo selon les données disponibles par défaut dans la documentation (par défaut, météo perso)</li>
<li>Ajout du port Hygro permettant la connexion avec les modèles aérauliques</li>
<li>Modification du type d'interpolation de la table : au lieu d'une interpolation linéaire, les données sont interpolées de sorte que leur dérivée reste continue</li>
</ul>
<p>Hassan Bouia 03/2013 : Simplification des calculs solaires et modification du vecteur G</p>
<p>Denis Covalet 04/2013 : Précisions sur le vecteur Hygro, variable pression et correction infos sur HR (entre 0 et 1 et non pas en %)</p>
<p>Aurélie Kaemmerlen 09/2013 : Ajout d'un choix du type d'interpolation des données météo, du choix du temps de bouclage du fichier météo et modulo sur la direction du vent qui sortait des bornes [0-360] avec une interpolation continue</p>
<p>Amy Lindsay 01/2014 : Suppression du modulo sur la direction du vent qui posait des problèmes de résolution dans certains cas (non continuité des données), et interpolation linéaire obligatoire sur la direction du vent pour répondre à ce problème</p>
<p>Amy Lindsay 03/2014 : Ajout de deux booléens permettant de 1- préciser si la température de ciel est déjà renseignée dans le fichier texte météo ou si'il faut la calculer 2- le cas échéant, préciser si l'humidité relative est connue ou non (la corrélation estimant la température de ciel dépend des données d'entrée disponibles)</p>
<p>Amy Lindsay 04/2014 : Ajout de documentation pour rappeler l'importance des conventions d'angles qui sont différentes pour la direction du vent et pour l'orientation des parois !</p>
<p>Amy Lindsay 11/2014 : <b>Changement important pour les fichiers météo Meteonorm et réglementaires</b> : pour mieux correspondre à la position du soleil à chaque instant, les flux moyennés sur l'heure écoulée sont affectés au milieu du pas de temps (demie-heure). </p>
<p>Hassan Bouia, Amy Lindsay 12/2014 : Ajout de la possibilité d'utiliser des fonctions en escalier.</p>
<p>Gilles Plessis 09/2015 : Utilisation de la fonction <code>Modelica.Utilities.Files.loadResource</code> pour le chargement de fichiers, pour une meilleure compatibilité avec le standard Modelica.</p>
<p>Benoît Charrier 01/2016 : Ajout du paramètre avancé <code>table_column_number</code> pour éviter une déclaration croisée de variables et permettre la compatibilité avec OpenModelica.</p>
</html>"),      Placement(transformation(extent={{80,-44},{100,-24}}),
        iconTransformation(extent={{80,-72},{100,-52}})),
                Placement(transformation(extent={{80,-72},{100,-52}}),
        iconTransformation(extent={{80,-100},{100,-80}})),
                                        Line(
      points={{90,28},{90,28}},
      color={255,0,0},
      smooth=Smooth.None));
end Meteofile;
