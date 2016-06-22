within BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing;
record SettingsMatisse

// Geometric parameters

constant Modelica.SIunits.Volume VolumeMatisse=164.43;

constant Modelica.SIunits.Length HauteurMatisse=2.50;

constant Modelica.SIunits.Area Surf_Refends=0.00;
constant Modelica.SIunits.Area Surf_Cloison=65.13;
constant Modelica.SIunits.Area Surf_PorteEntree=1.60;
constant Modelica.SIunits.Area Surf_PorteSeparations=10.50;
constant Modelica.SIunits.Area Surf_PlafondHaut=65.77;
constant Modelica.SIunits.Area Surf_PlancherBas=65.77;
constant Modelica.SIunits.Area Surf_MurEst=14.95;
constant Modelica.SIunits.Area Surf_MurSud=25.67;
constant Modelica.SIunits.Area Surf_MurOuest=15.13;
constant Modelica.SIunits.Area Surf_MurNord=17.88;
constant Modelica.SIunits.Area Surf_VitrageNord=9.75;
constant Modelica.SIunits.Area SommeDesSurfacesExterieures=Surf_PorteEntree+Surf_PlafondHaut+Surf_PlancherBas+Surf_MurEst+Surf_MurSud+Surf_MurOuest+Surf_MurNord+Surf_VitrageNord;

constant Modelica.SIunits.Length H_VitrageNord=1.3;

constant Real LongueursPonts[:] = {5.00,5.00,11.27,11.27,11.27,11.27,5.60,28.00};
constant Real LongueursPontsPlancher[:]={11.27,11.27,12.10};
constant Real LongueursPontsPlafond[:]={11.27,11.27,12.10};

// Multizone data

// Room 1

constant Modelica.SIunits.Area Surf_VitrageNordC1=1.95;
constant Modelica.SIunits.Area Surf_MurNordC1=4.3;
constant Modelica.SIunits.Area Surf_PlancherPlafondC1=9.5;
constant Modelica.SIunits.Length H_VitrageNordC1=1.3;
constant Real LongueursPontsC1[:] = {0.00,0.00,2.5,2.5,0.00,0.00,0.00,5.6};
constant Real LongueursPontsC1PlancherPlafond[:]={2.5,0.00,0.00};

// Room 2

constant Modelica.SIunits.Area Surf_MurNordC2=5.675;
constant Modelica.SIunits.Area Surf_MurEstC2=9.5;
constant Modelica.SIunits.Area Surf_VitrageNordC2=1.95;
constant Modelica.SIunits.Area Surf_PlancherPlafondC2=11.59;
constant Modelica.SIunits.Length H_VitrageNordC2=1.3;
constant Real LongueursPontsC2[:] = {2.5,0.00,3.05,3.05,0.00,0.00,0.00,5.6};
constant Real LongueursPontsC2PlancherPlafond[:]={3.05,0.00,3.8};

// Entrance

constant Modelica.SIunits.Area Surf_MurSudEntree=7.4;
constant Modelica.SIunits.Area Surf_PlancherPlafondEntree=8.892;
constant Real LongueursPontsEntree[:] = {0.00,0.00,0.00,0.00,3.6,3.6,5.6,0.00};
constant Real LongueursPontsEntreePlancherPlafond[:]={0.00,3.6,0.00};

// Bathroom

constant Modelica.SIunits.Area Surf_MurSudSDB=9.675;
constant Modelica.SIunits.Area Surf_MurEstSDB=5.25;
constant Modelica.SIunits.Area Surf_PlancherPlafondSDB=6.867;
constant Real LongueursPontsSDB[:] = {0.00,2.5,0.00,0.00,1.4+2.47,1.4+2.47,0.00,0.00};
constant Real LongueursPontsSDBPlancherPlafond[:]={0.00,1.4+2.47,1.2+0.9};

// Kitchen

constant Modelica.SIunits.Area Surf_MurNordCuisine=3.05;
constant Modelica.SIunits.Area Surf_VitrageNordCuisine=1.95;
constant Modelica.SIunits.Area Surf_PlancherPlafondCuisine=7.6;
constant Modelica.SIunits.Length H_VitrageNordCuisine=1.3;
constant Real LongueursPontsCuisine[:] = {0.00,0.00,2.00,2.00,0.00,0.00,0.00,5.6};
constant Real LongueursPontsCuisinePlancherPlafond[:]={2.00,0.00,0.00};

// Living

constant Modelica.SIunits.Area Surf_MurNordSejour=4.85;
constant Modelica.SIunits.Area Surf_VitrageNordSejour=3.9;
constant Modelica.SIunits.Area Surf_MurOuestSejour=15.125;
constant Modelica.SIunits.Area Surf_MurSudSejour=8.75;
constant Modelica.SIunits.Area Surf_PlancherPlafondSejour=21.175;
constant Modelica.SIunits.Length H_VitrageNordSejour=1.3;
constant Real LongueursPontsSejour[:] = {2.5,2.5,3.5,3.5,3.5,3.5,0.00,5.6*2};
constant Real LongueursPontsSejourPlancherPlafond[:]={3.5,3.5,6.05};

// Partition walls

constant Modelica.SIunits.Area Surf_CloisonLegSejourCuisine=9.5;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeSejour=3.75;
constant Modelica.SIunits.Area Surf_CloisonLegC1Cuisine=9.5;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeCuisine=3.5;
constant Modelica.SIunits.Area Surf_CloisonLegC1C2=9.5;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeC1=4.75;
constant Modelica.SIunits.Area Surf_CloisonLegC2SDB=6.175;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeC2=2;
constant Modelica.SIunits.Area Surf_CloisonLegEntreeSDB=9.75;

  annotation (Documentation(info="<html>
<p><i><b>Record of geometric data for Matisse collective housing.</b></i></p>
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
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Benoît Charrier 05/2015 : ajouts de paramètres pour l'assemblage d'un logement collectif</p>
</html>"));
end SettingsMatisse;
