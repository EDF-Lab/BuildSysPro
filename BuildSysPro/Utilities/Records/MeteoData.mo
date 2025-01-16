within BuildSysPro.Utilities.Records;
record MeteoData "Record to facilitate weather data entry"

  parameter Real Fh=1 "Fuseau horaire >0 à l'est, <0 à l'ouest. Ex : Fh=+1 Paris, Fh=-8 Los Angeles" annotation(choices(
  choice=-11 "UTC-11 Midway",
  choice=-10 "UTC-10 Papeete - Hawaii - Iles Cook",
  choice=-9 "UTC-9 Alaska - Iles Gambier",
  choice=-8 "UTC-8 Los Angeles - Vancouver - Dawson - Pitcairn",
  choice=-7 "UTC-7 Phoenix - Calgary - Denver - Edmonton",
  choice=-6 "UTC-6 Mexico - Chicago - Dallas - Winnipeg",
  choice=-5 "UTC-5 New York - Toronto - Québec - Washinghton - Lima - Bogotta - Cuba",
  choice=-4 "UTC-4 Halifax - Guadeloupe - Martinique - Caracas - Manaus - La Paz - Asuncion - Santiago",
  choice=-3 "UTC-3 Brasilia - Buenos Aires - Sao Paulo - Groenland",
  choice=-2 "UTC-2 Trinidad",
  choice=-1 "UTC-1 Cap Vert - Açores ",
  choice=0 "UTC+0 Londres - Dublin - Lisbonne - Mali - Côte d'Ivoire - Sénégal",
  choice=1 "UTC+1 Paris - Berlin - Madrid - Rome - Alger - Casablanca",
  choice=2 "UTC+2 Bucarest - Helsinki - Kiev - Athènes",
  choice=3 "UTC+3 Moscou - Istanboul - Riyadh",
  choice=4 "UTC+4 Dubaï",
  choice=5 "UTC+5 Maldives - Pakistan",
  choice=6 "UTC+6 Omsk - Kazakhstan",
  choice=7 "UTC+7 Bangkok - Hanoï - Jakarta",
  choice=8 "UTC+8 Pekin - ShanghaI - Hong-Kong - Singapour - Taiwan - Perth",
  choice=9 "UTC+9 Séoul - Tokyo",
  choice=10 "UTC+10 Melbourne - Sydney - Nouvelle-Guinée",
  choice=11 "UTC+11 Vanuatu - Iles Salomon - Nvlle Calédonie",
  choice=12 "UTC+12 Fidji - Tuvalu - Auckland - Iles Marshall",
  choice=13 "UTC+13 Samoa - Tonga",
  choice=14 "UTC+14 Line Islands"));

  parameter Integer correctif=0 "Correctif hiver/été : 0 en hiver, 1 en été" annotation(choices(
  choice=0 "Heure d'hiver", choice=1 "Heure d'été"));

    parameter Real d0 = 1 "Number of the day in the year at t=0";
    //    parameter Boolean Est = false // correction DC du 29/10/2024
    parameter Boolean Est = true
    "Longitude >0 in °East (<0 in °West) : Est=true (like Meteonorm). Longitude >0 in °West (<0 in °East) : Est=false";

// Configuration of the model : choice of input flux
parameter Integer CoupleFlux=2 "Solar flux 1 and 2 given in the G input vector"
                                                     annotation(choices(
choice=1 "GLOH DIFH", choice=2 "DIRN DIFH",choice=3 "DIFH DIRH", choice=4
        "GLOH DIRH", choice=5 "GLOH DIRN",radioButtons=true));
Modelica.Units.NonSI.Time_hour h0=-(Fh+correctif)
    "Universal time (in hours) at t=0 / h0=-1 for Meteonorm because data are in TU+1";
  annotation (Documentation(revisions="<html>
<p>11/2014 Amy Lindsay : suppression des param&egrave;tres MoyFlux et intervalle de temps qui deviennent obsol&egrave;tes avec le nouveau Meteofile. Choix de toujours se ramener au milieu de l&apos;intervalle des flux mesur&eacute;s et moyenn&eacute;s</p>
<p>10/2024 Denis Covalet : pour les m&eacute;t&eacute;os <b>perso</b> :</p>
<ul>
<li> dans le param&eacute;trage du mod&egrave;le : remplacement de h0 (d&eacute;calage heure m&eacute;t&eacute;o pour les flux solaires, source de confusion) par le fuseau horaire (Fh) et le correctif hiver (0)/&eacute;t&eacute; (1), sachant que h0=-(Fh+correctif).</li>
<li> par d&eacute;faut la longitude est d&eacute;sormais compt&eacute;e positivement &agrave; l&apos;est et n&eacute;gativement &agrave; l&apos;ouest (Est=true). C&apos;&eacute;tait l&apos;inverse avant (Est = false par d&eacute;faut) </li>
</ul>
</html>", info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end MeteoData;
