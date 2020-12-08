within BuildSysPro.BoundaryConditions.Weather;
model Meteofile "Weather data reader"

parameter Integer TypeMeteo=3 annotation(choices(
choice=1 "Meteofrance",
choice=2 "Meteonorm",
choice=3 "Weather RT (french building regulation)",
choice=4 "User-defined weather file", radioButtons=true));

parameter Boolean Tempciel=true "Sky temperature in data file"                                          annotation(choices(
choice=true "Provided", choice=false "To be calculated"));

parameter Boolean HR=true "Relative humidity in data file" annotation(choices(
   choice=true "Provided in data file", choice=false "HR unknown"),
                      Dialog(enable=Tempciel==false));

  parameter String pth=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/RT2012/H1a.txt")
    "Path to the weather data file"
  annotation(Dialog(__Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",
                             caption="Selecting the weather file")));

  parameter BuildSysPro.Utilities.Records.MeteoData DonneesPerso
    "Variables provided for User-defined data"
    annotation (Dialog(enable=TypeMeteo == 4));

parameter Modelica.Blocks.Types.Smoothness Interpolation=Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    "Data interpolation method" annotation(Dialog(tab="Advanced parameters"));

parameter Modelica.SIunits.Time Tbouclage=31536000
    "Weather data looped beyond Tbouclage if the simulation stop time is superior"
    annotation(Dialog(tab="Advanced parameters"));

parameter Real delta_t=3600
    "Time interval for piecewise constant interpolation method"
    annotation (Dialog(tab="Advanced parameters"));

parameter Integer table_column_number=11
    "Number of column in data file (time not considered)"                                               annotation (Dialog(tab="Advanced parameters"));
parameter Integer option[:]=fill(1, table_column_number)
    "Integer = 0 for a column if it is necessary to apply a step function on it, >0 otherwise."
    annotation (Dialog(tab="Advanced parameters"));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_dry "Dry air temperature" annotation (
      Placement(transformation(extent={{80,48},{100,68}}, rotation=0),
        iconTransformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Interfaces.RealOutput G[10]
    "Output data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle , Solar elevation angle}"
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
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_dew
    "Dew point temperature" annotation (Placement(transformation(extent={{80,18},
            {100,38}}, rotation=0), iconTransformation(extent={{80,50},{100,70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_sky
    "Sky temperature" annotation (Placement(transformation(extent={{80,-14},
            {100,6}}, rotation=0), iconTransformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Interfaces.RealOutput V[2]
    "Wind speed (m/s) and  direction (from 0° - North, 90° - East, 180° - South, 270 ° - West)"
    annotation (Placement(transformation(extent={{82,-82},{118,-46}},
          rotation=0), iconTransformation(extent={{80,-60},{100,-40}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTseche
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTrosee
    annotation (Placement(transformation(extent={{-8,18},{12,38}})));
  Modelica.Blocks.Interfaces.RealOutput Hygro[3]
    "T [K], total pressure [Pa], relative humidity [0;1]"
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
  // Irradiance reading, latitude and longitude
  // The longitude must be given in such a way that East>0 and West<0 with absolute values <180 °

  when initial() then
    latitude=combiTimeTable.y[10];
    longitude =
      BuildSysPro.BoundaryConditions.Weather.Functions.ConvertLongitude(Est=
      ChoixEst, LongIn=combiTimeTable.y[11]);
    h0 = if (TypeMeteo==4) then DonneesPerso.h0 else (if (TypeMeteo==1) then 0 else -1);
    d0 = if TypeMeteo==4 then DonneesPerso.d0 else 1;
    CoupleFlux= if TypeMeteo==4 then DonneesPerso.CoupleFlux else 2;
    t0=86400*(d0-1)+3600*h0;
  end when;

  //combiTimeTable.u=mod(time,31536000);

  FluxMeteo[1]=combiTimeTable.y[1];
  FluxMeteo[2]=combiTimeTable.y[2];

// Wind connector
 connect(combiTimeTable.y[8], V[1]) annotation (Line(
      points={{-37,30},{-30,30},{-30,-73},{100,-73}},
      color={0,0,127},
      smooth=Smooth.None));

// Temperature Connectors
  connect(prescribedTseche.port, T_dry) annotation (Line(
      points={{46,58},{90,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTrosee.port, T_dew) annotation (Line(
      points={{46,28},{90,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(combiTimeTable.y[3], toKelvinTseche.Celsius)
                                                 annotation (Line(
      points={{-37,30},{-26,30},{-26,58},{-12,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTimeTable.y[4], toKelvinTrosee.Celsius)
                                                  annotation (Line(
      points={{-37,30},{-34,30},{-34,28},{-10,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvinTseche.Kelvin, prescribedTseche.T)
                                                    annotation (Line(
      points={{11,58},{26,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvinTrosee.Kelvin, prescribedTrosee.T)  annotation (Line(
      points={{13,28},{26,28}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connector for humid air

  ps = BuildSysPro.BoundaryConditions.Weather.Functions.CalculPs(Hygro[1]);

  Hygro[1]=combiTimeTable.y[3]+273.15;
  Hygro[2]=combiTimeTable.y[6];
  Hygro[3]=combiTimeTable.y[7];

  // Tciel computation

  if Tempciel==false then
    if HR==true then
      T_ciel=Functions.CalculTsky_withRH(
        t=time,
        G=G,
        T_seche=T_dry.T,
        Pvap=Hygro[3]*ps);
    else
      T_ciel=Functions.CalculTsky_withoutRH(
        t=time,
        G=G,
        T_seche=T_dry.T);
    end if;
  else
    T_ciel=combiTimeTable.y[5]+273.15;
  end if;

  T_sky.T=T_ciel;

  //Calculation of sun's direction cosines

  (CosDir,AzHaut[1],AzHaut[2]) =
    BuildSysPro.BoundaryConditions.Solar.Utilities.CosDirSunVectorHeightAz(
    t0=t0,
    t=time,
    latitude=latitude,
    longitude=longitude);

  // Calculation of flux DIFH, DIRN, DIRH, GLOH

  if CoupleFlux<1.5 then
    GLOH = FluxMeteo[1];
    DIFH = FluxMeteo[2];
    DIRH=GLOH-DIFH;
    DIRN=if noEvent(CosDir[1]>0) then DIRH/CosDir[1] else 0;
  elseif CoupleFlux<2.5 then
    DIRN = FluxMeteo[1];
    DIFH = FluxMeteo[2];
    DIRH=if CosDir[1]>0 then DIRN*CosDir[1] else 0;
    GLOH=DIRH+DIFH;
  elseif CoupleFlux<3.5 then
    DIFH = FluxMeteo[1];
    DIRH = FluxMeteo[2];
    GLOH=DIRH+DIFH;
    DIRN=if noEvent(CosDir[1]>0) then DIRH/CosDir[1] else 0;
  elseif CoupleFlux<4.5 then
    GLOH = FluxMeteo[1];
    DIRH = FluxMeteo[2];
    DIRN=if noEvent(CosDir[1]>0) then DIRH/CosDir[1] else 0;
    DIFH=GLOH-DIRH;
  else // CoupleFlux==5
    GLOH = FluxMeteo[1];
    DIRN = FluxMeteo[2];
    DIRH=if CosDir[1]>0 then DIRN*CosDir[1] else 0;
    DIFH=GLOH-DIRH;
  end if;

  //G[1:10]={DIFH,DIRN,DIRH,GLOH, t0, CosDir[1],CosDir[2],CosDir[3], latitude, longitude};
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
                  extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Weather data reader providing meteorological boundary conditions</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model reads weather data files. The files are contained in the directory <u>file://BuildSysPro\\Resources\\Donnees\\Meteos</u>.</p>
<p>The data format must be compliant with specifications described below (see table).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model reads a data file containing the following columns:</p>
<p><table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Time [s] </p></td>
<td><p>Solar irradiance 1 [W/m²]</p><p>Direct normal (defaut)</p></td>
<td><p>Solar irradiance 2 [W/m²]</p><p>Diffuse horizontal (defaut)</p></td>
<td><p>T_dry [°C]</p><p>Dry bulb temperature </p></td>
<td><p>T_dew [°C]</p><p>Dew point temperature</p></td>
<td><p>T_sky [°C]</p><p>Sky temperature</p></td>
<td><p>Patm [Pa]</p><p>Atmospheric pressure</p></td>
<td><p>HR (between 0 and 1)</p><p>Relative humidity</p></td>
<td><p>VitVent [m/s]</p><p>Wind speed</p></td>
<td><p>DirVent [°]</p><p>Wind direction</p></td>
<td><p>Latitude [°]</p></td>
<td><p>Longitude [°]</p></td>
</tr>
</table></p>
<p>By default weather file can be given either in universal time (UTC - h0 = 0) or in local time (TL - h0 = Time zone). The scenarios should be consistent with the time given in the weather file - there is no change to summer time.</p>
<p>The weather data are repeated periodically. By default, a one year period is used (see advanced parameter <b>Tbouclage</b>). So that one can start simulations on heating season: for example, from October 1 (start time 23587200s) to May 1 (stop time 41904000s). The advanced parameter <b>Tbouclage</b> allows to loop from a longer period so that a data file larger than a year can be used.</p>
<p><b>Default settings - link to the content of the folder  <u>file://BuildSysPro\\Resources\\Donnees\\Meteos</u></b>
<ol>
<li>Irradiation data are DIRN and DIFH</li>
<li>The beginning of the files is at 0:00 on January 1</li>
<li>The longitude is given in ° East</li>
<li>The pressure (in Pa) is an absolute pressure, and is assumed to be a wet air total pressure (used as such in humidity calculation functions)</li>
<li>The relative humidity is between 0 and 1</li>
<li>For the wind direction, the World Weather Organization assumes that a wind coming from the north is coded 360°, the wind rose is graduated clockwise (an east wind will be coded 90°) - check in all weather files -</li>
</ol></p>
<p><b>Available files and their differences from default values are:</p></b>
<ol>
<li>Meteofrance: Average irradiation [t-dt/2;t+dt/2]. h0 = 0</li>
<li>Meteonorm: Irradiation determined on the last hour and assigned in the middle of the hour to better match the sun's path. Local time (h0 = -1 in France).</li>
<li>Weather file from the French building regulation RT2012: irradiation determined on the last hour and assigned in the middle of the hour to better match the sun's path. Local time (h0 = -1 in France).</li>
<li>For user-defined weather data, fill in the parameters conditioning irradiation calculations thereafter. For example, for data starting May 11, at 15:30 (Universal Time) - indicate h0 = 15.5 and d0 = 135.</li>
</ol></p>
<p>This model returns as outputs:
<ul>
<li><b>G[10]</b> vector containing information for solar irradiance computation:</li>
<ul>
 <li>(1) Horizontal diffuse flux</li>
 <li>(2) Normal direct flux</li>
 <li>(3) Horizontal direct flux</li>
 <li>(4) Horizontal global flux</li>
 <li>(5) Time in UTC at time t = 0 (start of the simulation)</li>
 <li>(6-7-8) Sun's direction cosines (6-sinH, 7-cosW, 8-cosS)</li>
 <li>(9) Solar azimuth angle</li>
 <li>(10) Solar elevation angle</li>
</ul>
<li><b>V[2]</b> vector containing information about wind</li>
<ol>
<li>Wind speed</li>
<li>Wind direction (origin)</li>
</ol>
<li><b>Hygro[3]</b> for hygro-thermal modelling</li>
<ol>
<li>Dry air temperature [K]</li>
<li>Total pressure supposed to be wet (=Patm) [Pa]</li>
<li>Relative humidity [0;1]</li>
</ol>
</ul>
</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The irradiation couple read by the weather reader is set via the choice of CoupleFlux. By default, the model reads the couple FDIRN / FDIFH</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.4.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>
",  revisions="<html>
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
<p>Denis Covalet 04/2013 : Précisions sur le vecteur Hygro, variable pression et correction infos sur HR (entre 0 et 1 et non pas en &#37;)</p>
<p>Aurélie Kaemmerlen 09/2013 : Ajout d'un choix du type d'interpolation des données météo, du choix du temps de bouclage du fichier météo et modulo sur la direction du vent qui sortait des bornes [0-360] avec une interpolation continue</p>
<p>Amy Lindsay 01/2014 : Suppression du modulo sur la direction du vent qui posait des problèmes de résolution dans certains cas (non continuité des données), et interpolation linéaire obligatoire sur la direction du vent pour répondre à ce problème</p>
<p>Amy Lindsay 03/2014 : Ajout de deux booléens permettant de 1- préciser si la température de ciel est déjà renseignée dans le fichier texte météo ou si'il faut la calculer 2- le cas échéant, préciser si l'humidité relative est connue ou non (la corrélation estimant la température de ciel dépend des données d'entrée disponibles)</p>
<p>Amy Lindsay 04/2014 : Ajout de documentation pour rappeler l'importance des conventions d'angles qui sont différentes pour la direction du vent et pour l'orientation des parois !</p>
<p>Amy Lindsay 11/2014 : <b>Changement important pour les fichiers météo Meteonorm et réglementaires</b> : pour mieux correspondre à la position du soleil à chaque instant, les flux moyennés sur l'heure écoulée sont affectés au milieu du pas de temps (demie-heure). </p>
<p>Hassan Bouia, Amy Lindsay 12/2014 : Ajout de la possibilité d'utiliser des fonctions en escalier.</p>
<p>Gilles Plessis 09/2015 : Utilisation de la fonction <code>Modelica.Utilities.Files.loadResource</code> pour le chargement de fichiers, pour une meilleure compatibilité avec le standard Modelica.</p>
<p>Benoît Charrier 01/2016 : Ajout du paramètre avancé <code>table_column_number</code> pour éviter une déclaration croisée de variables et permettre la compatibilité avec OpenModelica.</p>
<p>Benoît Charrier 01/2017 : Remplacement de la pression de vapeur par l'humidité relative comme troisième composante du vecteur <code>Hygro</code> pour coller aux entrées des modèles de conditions limites <code>WithoutWindEffect</code> et <code>WithWindEffect</code>.</p>
<p>Benoît Charrier 01/2018 : Added <code>noEvent</code> on some <code>CosDir[1]>0</code> conditions to avoid division by zero errors. Changed <code>h0</code> value from <code>0</code> to <code>-1</code> in case of RT2012 meteo to fit with sun height.</p>
</html>"));
end Meteofile;
