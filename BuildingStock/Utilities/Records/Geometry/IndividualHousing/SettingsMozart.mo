within BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing;
record SettingsMozart

// Paramètres géométriques

constant Modelica.SIunits.Volume VolumeMozart=249.6;

constant Modelica.SIunits.Length HauteurMozart=2.50;

constant Modelica.SIunits.Area Surf_Refends=19.00;
constant Modelica.SIunits.Area Surf_Cloison=67.13;
constant Modelica.SIunits.Area Surf_PorteSeparation=13.50;
constant Modelica.SIunits.Area Surf_PorteEntree=2.04;
constant Modelica.SIunits.Area Surf_ParoiSousCombles=99.84;
constant Modelica.SIunits.Area Surf_PlancherBas=99.84;
constant Modelica.SIunits.Area Surf_MurEst=16.37;
constant Modelica.SIunits.Area Surf_MurSud=22.79;
constant Modelica.SIunits.Area Surf_MurOuest=3.45;
constant Modelica.SIunits.Area Surf_MurNord=28.33;
constant Modelica.SIunits.Area Surf_MurLNC3=14.25;
constant Modelica.SIunits.Area Surf_VitrageEst=3.88;
constant Modelica.SIunits.Area Surf_VitrageOuest=2.80;
constant Modelica.SIunits.Area Surf_VitrageNord=2.42;
constant Modelica.SIunits.Area Surf_VitrageSudSF=0.44;
constant Modelica.SIunits.Area Surf_VitrageSudAF=5.48;

constant Modelica.SIunits.Length H_VitrageNord=1.15;
constant Modelica.SIunits.Length H_VitrageEst=2.15;
constant Modelica.SIunits.Length H_VitrageSudSF=0.7;
constant Modelica.SIunits.Length H_VitrageSudAF=2.15;
constant Modelica.SIunits.Length H_VitrageOuest=2.15;

constant Real LongueursPonts[:] = {20.00,10.00,41.30,41.30,16.40,41.30,41.30,6.20,44.34};

//Données concernant le multizone

//Chambre1

constant Modelica.SIunits.Area Surf_VitrageNordC1=1.38;
constant Modelica.SIunits.Area Surf_MurNordC1=5.37;
constant Modelica.SIunits.Area Surf_PlancherPlafondC1=10.935;
constant Modelica.SIunits.Length H_VitrageNordC1=1.15;
constant Real LongueursPontsC1[:] = {0.00,0.00,2.7,2.7,0.00,2.7,2.7,0.00,4.7};

//Chambre2

constant Modelica.SIunits.Area Surf_MurNordC2=6.875;
constant Modelica.SIunits.Area Surf_MurEstC2=8.185;
constant Modelica.SIunits.Area Surf_VitrageEstC2=1.94;
constant Modelica.SIunits.Area Surf_PlancherPlafondC2=11.1375;
constant Modelica.SIunits.Length H_VitrageEstC2=2.15;
constant Real LongueursPontsC2[:] = {2*2.50,0.00,2.75+4.05,2.75+4.05,0.00,2.75+4.05,2.75+4.05,0.00,6.1};

//Chambre3

constant Modelica.SIunits.Area Surf_VitrageEstC3=1.94;
constant Modelica.SIunits.Area Surf_MurEstC3=4.81;
constant Modelica.SIunits.Area Surf_MurSudC3=6.795;
constant Modelica.SIunits.Area Surf_VitrageSudC3=2.58;
constant Modelica.SIunits.Area Surf_PlancherPlafondC3=10.125;
constant Modelica.SIunits.Length H_VitrageEstC3=2.15;
constant Modelica.SIunits.Length H_VitrageSudC3=2.15;
constant Real LongueursPontsC3[:] = {2*2.50,0.00,2.7+3.75,2.7+3.75,0.00,2.7+3.75,2.7+3.75,0.00,6.1+6.7};

//Entrée

constant Modelica.SIunits.Area Surf_MurSudEntree=1.46;
constant Modelica.SIunits.Area Surf_MurEstEntree=3.375;
constant Modelica.SIunits.Area Surf_PlancherPlafondEntree=14.31;
constant Real LongueursPontsEntree[:] = {0.00,2.50,1.4+1.35,1.4+1.35,4.05,1.4+1.35,1.4+1.35,6.20,0.00};

//Salle de bain

constant Modelica.SIunits.Area Surf_MurSudSDB=6.185;
constant Modelica.SIunits.Area Surf_VitrageSudSDB=0.44;
constant Modelica.SIunits.Area Surf_PlancherPlafondSDB=7.155;
constant Modelica.SIunits.Length H_VitrageSudSDB=0.7;
constant Real LongueursPontsSDB[:] = {0.00,0.00,2.65,2.65,0.00,2.65,2.65,0.00,2.66};

//Séjour

constant Modelica.SIunits.Area Surf_MurNordSejour=11.25;
constant Modelica.SIunits.Area Surf_MurLNCSejour=14.25;
constant Modelica.SIunits.Area Surf_MurOuestSejour=3.45;
constant Modelica.SIunits.Area Surf_MurSudSejour=8.35;
constant Modelica.SIunits.Area Surf_VitrageOuestSejour=2.8;
constant Modelica.SIunits.Area Surf_VitrageSudSejour=2.9;
constant Modelica.SIunits.Area Surf_PlancherPlafondSejour=36.5;
constant Modelica.SIunits.Length H_VitrageOuestSejour=2.15;
constant Modelica.SIunits.Length H_VitrageSudSejour=2.15;
constant Real LongueursPontsSejour[:] = {4*2.5,2*2.5,8.2+2*4.5,8.2+2*4.5,8.2,8.2+2*4.5,8.2+2*4.5,0.00,7.0+6.9};

//Cuisine

constant Modelica.SIunits.Area Surf_MurNordCuisine=4.835;
constant Modelica.SIunits.Area Surf_VitrageNordCuisine=1.04;
constant Modelica.SIunits.Area Surf_PlancherPlafondCuisine=9.5175;
constant Modelica.SIunits.Length H_VitrageNordCuisine=1.15;
constant Real LongueursPontsCuisine[:] = {0.00,2.50,2.35,2.35,4.05,2.35,2.35,0.00,4.1};

//Refends

constant Modelica.SIunits.Area  Surf_RefendSejourCuisine=10.125;
constant Modelica.SIunits.Area Surf_RefendEntreeSejour=8.625;

//Cloisons

constant Modelica.SIunits.Area Surf_CloisonLegEntreeCuisine=4.375;
constant Modelica.SIunits.Area Surf_CloisonLegC1C2=10.125;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeC2=5.375;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeC1=5.25;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeSDB=10.375;
constant Modelica.SIunits.Area Surf_CloisonLegC3SDB=6.75;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeC3=7.875;
constant Modelica.SIunits.Area Surf_CloisonLegC1Cuisine=10.125;

  annotation (Documentation(info="<html>
<p><i><b>Record pour renseigner les paramètres géométriques de la MI Mozart</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>Site de la bibliothèque des bâtiments types</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoît Charrier 11/2014 : Correction d'erreurs sur les surfaces de murs (<code>Surf_MurOuestSejour et Surf_MurNordCuisine).</code></p>
</html>"));
end SettingsMozart;
