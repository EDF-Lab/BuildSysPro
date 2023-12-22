within BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing;
record SettingsMozart

// Geometric parameters

  constant Modelica.Units.SI.Volume VolumeMozart=249.6;

  constant Modelica.Units.SI.Length HauteurMozart=2.50;

  constant Modelica.Units.SI.Area Surf_Refends=19.00;
  constant Modelica.Units.SI.Area Surf_Cloison=67.13;
  constant Modelica.Units.SI.Area Surf_PorteSeparation=13.50;
  constant Modelica.Units.SI.Area Surf_PorteEntree=2.04;
  constant Modelica.Units.SI.Area Surf_ParoiSousCombles=99.84;
  constant Modelica.Units.SI.Area Surf_PlancherBas=99.84;
  constant Modelica.Units.SI.Area Surf_MurEst=16.37;
  constant Modelica.Units.SI.Area Surf_MurSud=22.79;
  constant Modelica.Units.SI.Area Surf_MurOuest=3.45;
  constant Modelica.Units.SI.Area Surf_MurNord=28.33;
  constant Modelica.Units.SI.Area Surf_MurLNC3=14.25;
  constant Modelica.Units.SI.Area Surf_VitrageEst=3.88;
  constant Modelica.Units.SI.Area Surf_VitrageOuest=2.80;
  constant Modelica.Units.SI.Area Surf_VitrageNord=2.42;
  constant Modelica.Units.SI.Area Surf_VitrageSudSF=0.44;
  constant Modelica.Units.SI.Area Surf_VitrageSudAF=5.48;

  constant Modelica.Units.SI.Length H_VitrageNord=1.15;
  constant Modelica.Units.SI.Length H_VitrageEst=2.15;
  constant Modelica.Units.SI.Length H_VitrageSudSF=0.7;
  constant Modelica.Units.SI.Length H_VitrageSudAF=2.15;
  constant Modelica.Units.SI.Length H_VitrageOuest=2.15;

constant Real LongueursPonts[:] = {20.00,10.00,41.30,41.30,16.40,41.30,41.30,6.20,44.34};

// Multizone data

// Room 1

  constant Modelica.Units.SI.Area Surf_VitrageNordC1=1.38;
  constant Modelica.Units.SI.Area Surf_MurNordC1=5.37;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondC1=10.935;
  constant Modelica.Units.SI.Length H_VitrageNordC1=1.15;
constant Real LongueursPontsC1[:] = {0.00,0.00,2.7,2.7,0.00,2.7,2.7,0.00,4.7};

// Room 2

  constant Modelica.Units.SI.Area Surf_MurNordC2=6.875;
  constant Modelica.Units.SI.Area Surf_MurEstC2=8.185;
  constant Modelica.Units.SI.Area Surf_VitrageEstC2=1.94;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondC2=11.1375;
  constant Modelica.Units.SI.Length H_VitrageEstC2=2.15;
constant Real LongueursPontsC2[:] = {2*2.50,0.00,2.75+4.05,2.75+4.05,0.00,2.75+4.05,2.75+4.05,0.00,6.1};

// Room 3

  constant Modelica.Units.SI.Area Surf_VitrageEstC3=1.94;
  constant Modelica.Units.SI.Area Surf_MurEstC3=4.81;
  constant Modelica.Units.SI.Area Surf_MurSudC3=6.795;
  constant Modelica.Units.SI.Area Surf_VitrageSudC3=2.58;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondC3=10.125;
  constant Modelica.Units.SI.Length H_VitrageEstC3=2.15;
  constant Modelica.Units.SI.Length H_VitrageSudC3=2.15;
constant Real LongueursPontsC3[:] = {2*2.50,0.00,2.7+3.75,2.7+3.75,0.00,2.7+3.75,2.7+3.75,0.00,6.1+6.7};

// Entrance

  constant Modelica.Units.SI.Area Surf_MurSudEntree=1.46;
  constant Modelica.Units.SI.Area Surf_MurEstEntree=3.375;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondEntree=14.31;
constant Real LongueursPontsEntree[:] = {0.00,2.50,1.4+1.35,1.4+1.35,4.05,1.4+1.35,1.4+1.35,6.20,0.00};

// Bathroom

  constant Modelica.Units.SI.Area Surf_MurSudSDB=6.185;
  constant Modelica.Units.SI.Area Surf_VitrageSudSDB=0.44;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondSDB=7.155;
  constant Modelica.Units.SI.Length H_VitrageSudSDB=0.7;
constant Real LongueursPontsSDB[:] = {0.00,0.00,2.65,2.65,0.00,2.65,2.65,0.00,2.66};

// Living

  constant Modelica.Units.SI.Area Surf_MurNordSejour=11.25;
  constant Modelica.Units.SI.Area Surf_MurLNCSejour=14.25;
  constant Modelica.Units.SI.Area Surf_MurOuestSejour=3.45;
  constant Modelica.Units.SI.Area Surf_MurSudSejour=8.35;
  constant Modelica.Units.SI.Area Surf_VitrageOuestSejour=2.8;
  constant Modelica.Units.SI.Area Surf_VitrageSudSejour=2.9;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondSejour=36.5;
  constant Modelica.Units.SI.Length H_VitrageOuestSejour=2.15;
  constant Modelica.Units.SI.Length H_VitrageSudSejour=2.15;
constant Real LongueursPontsSejour[:] = {4*2.5,2*2.5,8.2+2*4.5,8.2+2*4.5,8.2,8.2+2*4.5,8.2+2*4.5,0.00,7.0+6.9};

// Kitchen

  constant Modelica.Units.SI.Area Surf_MurNordCuisine=4.835;
  constant Modelica.Units.SI.Area Surf_VitrageNordCuisine=1.04;
  constant Modelica.Units.SI.Area Surf_PlancherPlafondCuisine=9.5175;
  constant Modelica.Units.SI.Length H_VitrageNordCuisine=1.15;
constant Real LongueursPontsCuisine[:] = {0.00,2.50,2.35,2.35,4.05,2.35,2.35,0.00,4.1};

// Supporting walls

  constant Modelica.Units.SI.Area Surf_RefendSejourCuisine=10.125;
  constant Modelica.Units.SI.Area Surf_RefendEntreeSejour=8.625;

// Partition walls

  constant Modelica.Units.SI.Area Surf_CloisonLegEntreeCuisine=4.375;
  constant Modelica.Units.SI.Area Surf_CloisonLegC1C2=10.125;
  constant Modelica.Units.SI.Area Surf_CloisonLegEntreeC2=5.375;
  constant Modelica.Units.SI.Area Surf_CloisonLegEntreeC1=5.25;
  constant Modelica.Units.SI.Area Surf_CloisonLegEntreeSDB=10.375;
  constant Modelica.Units.SI.Area Surf_CloisonLegC3SDB=6.75;
  constant Modelica.Units.SI.Area Surf_CloisonLegEntreeC3=7.875;
  constant Modelica.Units.SI.Area Surf_CloisonLegC1Cuisine=10.125;


// Internal doors

  constant Modelica.Units.SI.Area Surf_PorteIntEntreeSejour=1.75;
  constant Modelica.Units.SI.Area Surf_PorteIntEntreeCuisine=1.5;
  constant Modelica.Units.SI.Area Surf_PorteIntEntreeC2=1.5;
  constant Modelica.Units.SI.Area Surf_PorteIntEntreeC1=1.5;
  constant Modelica.Units.SI.Area Surf_PorteIntEntreeSDB=3;
  constant Modelica.Units.SI.Area Surf_PorteIntEntreeC3=1.5;


  annotation (Documentation(info="<html>
<p><i><b>Record of geometric data for Mozart individual housing.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoît Charrier 11/2014 : Correction d'erreurs sur les surfaces de murs (<code>Surf_MurOuestSejour et Surf_MurNordCuisine).</code></p>
<p>Stéphanie Froidurot - 10/2020 : Add internal doors</p>
</html>"));
end SettingsMozart;
