within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpaceGlazedInternalPartitions
  "Modèle de zone parallépipèdique sur vide sanitaire avec vitrage modélisé en thermique pure et prenant en compte l'inertie due aux parois internes"
  extends ZoneCrawlSpaceGlazed;

// Cloisons interzones et intrazones//
//Refends
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracRef
    "Caractéristiques des réfends" annotation (__Dymola_choicesAllMatching=
        true, Dialog(tab="Parois internes", group="Refends (murs porteurs)"));

parameter Modelica.SIunits.Area SRef=1 "surface des refends" annotation(Dialog(tab="Parois internes", group="Refends (murs porteurs)"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hRef
    "coefficient d'échange convectif des refends"                                                              annotation(Dialog(tab="Parois internes", group="Refends (murs porteurs)"));

//Cloisons légères
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracCleg
    "Caractéristiques des cloisons légères" annotation (
      __Dymola_choicesAllMatching=true, Dialog(tab="Parois internes", group=
          "Cloisons légères"));
parameter Modelica.SIunits.Area SCleg=1 "surface des cloisons légères" annotation(Dialog(tab="Parois internes", group="Cloisons légères"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hCleg
    "coefficient d'échange global des cloisons légères"                                                               annotation(Dialog(tab="Parois internes", group="Cloisons légères"));

//Composants
protected
  BuildingEnvelope.HeatTransfer.Wall Refends(
    InitType=InitType,
    Tp=Tp,
    caracParoi(
      n=caracRef.n,
      m=caracRef.m,
      e=caracRef.e,
      mat=caracRef.mat,
      positionIsolant=caracRef.positionIsolant),
    S=SRef,
    hs_ext=hRef,
    hs_int=hRef,
    ParoiInterne=true) "Cloissons interzone de type refends "
    annotation (Placement(transformation(extent={{18,40},{38,60}})));
  BuildingEnvelope.HeatTransfer.Wall CloisonsLegeres(
    InitType=InitType,
    Tp=Tp,
    caracParoi(
      n=caracCleg.n,
      m=caracCleg.m,
      e=caracCleg.e,
      mat=caracCleg.mat,
      positionIsolant=caracCleg.positionIsolant),
    S=SCleg,
    hs_ext=hCleg,
    hs_int=hCleg,
    ParoiInterne=true) "Cloisons interzone légères" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={58,50})));

equation
  connect(CloisonsLegeres.T_ext, noeudAir.port_a) annotation (Line(
      points={{67,47},{67,26.5},{28,26.5},{28,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(CloisonsLegeres.T_int, noeudAir.port_a) annotation (Line(
      points={{49,47},{49,26.5},{28,26.5},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Refends.T_int, noeudAir.port_a) annotation (Line(
      points={{37,47},{37,26.5},{28,26.5},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Refends.T_ext, noeudAir.port_a) annotation (Line(
      points={{19,47},{19,27.5},{28,27.5},{28,6}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<h4>Modèle de zone parallèpipèdique sur vide sanitaire avec vitrages modélisé en thermique pure et prenant en compte l'inertie interne due aux parois internes.</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de bâtiment parallélépipédique monozone sur vide sanitaire vitré, à connecter à un modèle de conditions limites(port thermique de gauche) et realOutput de gauche pour les flux solaires. Par défaut les murs sont orientés selon les quatres points cardinaux; la modification de l'orientation est représentée par le paramètre beta. Le port thermique de droite est connecté au volume intérieur (capacité thermique). Les températures extérieures auxquelles sont soumis le plancher et le plafond sont pondérées par un coefficient b. Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux</b>. L'inertie des parois internes est prise en compte. Ce modèle hérite de <i>ZoneVideSanitaireVitre</i> et y superpose des cloisons internes de types refends (murs porteurs) et cloisons légères.</p>
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
<p>Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux. </b>Les vitrages transmettent les flux solaires au plancher. </p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2012 : Suppression du modifier <i>each </i>dans la définition des matériaux des parois. Le mot clé each n'a pas à être présent car les matériaux des parois sont définis en temps que vecteur.</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
<p>Gilles Plessis 03/2013 : Modification mineure sur la documentation.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {100,100}}), graphics));
end ZoneCrawlSpaceGlazedInternalPartitions;
