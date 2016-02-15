within BuildSysPro.Building.Examples;
model OneZone "Pure thermal modelling for a one-zone model"
    extends Modelica.Icons.Example;

  BuildingEnvelope.HeatTransfer.Wall ParoiSud(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,8},{-2,30}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreSud(S=4)
    annotation (Placement(transformation(extent={{16,16},{38,38}})));
  BuildingEnvelope.HeatTransfer.Wall ParoiNord(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,38},{-2,60}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreNord(S=4)
    annotation (Placement(transformation(extent={{16,48},{38,70}})));
  BuildingEnvelope.HeatTransfer.Wall ParoiEst(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,-22},{-2,0}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreEst(S=4)
    annotation (Placement(transformation(extent={{16,-16},{38,6}})));
  BuildingEnvelope.HeatTransfer.Wall ParoiOuest(S=10, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentExtWall
      caracParoi)
    annotation (Placement(transformation(extent={{-24,-52},{-2,-30}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenetreOuest(S=4)
    annotation (Placement(transformation(extent={{16,-46},{38,-24}})));
  BuildingEnvelope.HeatTransfer.Wall Plafond(S=14, redeclare
      BuildSysPro.Utilities.Data.WallData.RecentCeiling
      caracParoi)
    annotation (Placement(transformation(extent={{-24,68},{-2,90}})));

  BuildingEnvelope.HeatTransfer.FloorOnSlab
                                     Plancher(                           redeclare
      BuildSysPro.Utilities.Data.WallData.RecentFloor
      caracParoi)
    annotation (Placement(transformation(extent={{-20,-92},{0,-72}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=52, Tair=293.15)
    annotation (Placement(transformation(extent={{78,-16},{98,4}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal RenouvellementAir
    annotation (Placement(transformation(extent={{38,80},{58,100}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone
    annotation (Placement(transformation(extent={{-80,66},{-52,94}})));

  BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=4) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={42,-72})));
equation
  connect(FenetreOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,-38.3},{46,-38.3},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenetreEst.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,-8.3},{46,-8.3},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenetreSud.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,23.7},{46,23.7},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenetreNord.T_int, noeudAir.port_a) annotation (Line(
      points={{36.9,55.7},{46,55.7},{46,-10},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(ParoiOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,-44.3},{6,-44.3},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,-14.3},{6,-14.3},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,15.7},{6,15.7},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,45.7},{6,45.7},{6,76},{88,76},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
      points={{-3.1,75.7},{88,75.7},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond, Plafond.FLUX) annotation (Line(
      points={{-50.6,91.76},{-42,91.76},{-42,88.9},{-16.3,88.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, ParoiNord.FLUX) annotation (Line(
      points={{-50.6,85.88},{-42,85.88},{-42,58.9},{-16.3,58.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, ParoiSud.FLUX) annotation (Line(
      points={{-50.6,80.56},{-42,80.56},{-42,28.9},{-16.3,28.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, ParoiEst.FLUX) annotation (Line(
      points={{-50.6,74.96},{-42,74.96},{-42,-1.1},{-16.3,-1.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, ParoiOuest.FLUX) annotation (Line(
      points={{-50.6,69.36},{-42,69.36},{-42,-31.1},{-16.3,-31.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, FenetreNord.FLUX) annotation (Line(
      points={{-50.6,85.88},{-42,85.88},{-42,64.5},{23.7,64.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, FenetreSud.FLUX) annotation (Line(
      points={{-50.6,80.56},{-42,80.56},{-42,32.5},{23.7,32.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, FenetreEst.FLUX) annotation (Line(
      points={{-50.6,74.96},{-42,74.96},{-42,0.5},{23.7,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, FenetreOuest.FLUX) annotation (Line(
      points={{-50.6,69.36},{-42,69.36},{-42,-29.5},{23.7,-29.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(RenouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{57,90},{88,90},{88,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, fLUXzone.G) annotation (Line(points={{-81,48},{-74,48},{-74,
          64},{-90,64},{-90,79.86},{-81.26,79.86}}, color={0,0,127}));
  connect(meteofile.Tseche, RenouvellementAir.port_a) annotation (Line(points={
          {-81,53},{-36,53},{-36,90},{39,90}}, color={191,0,0}));
  connect(meteofile.Tseche, Plafond.T_ext) annotation (Line(points={{-81,53},{
          -36,53},{-36,75.7},{-22.9,75.7}}, color={191,0,0}));
  connect(meteofile.Tseche, ParoiNord.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,45.7},{-22.9,45.7}}, color={191,0,0}));
  connect(meteofile.Tseche, ParoiSud.T_ext) annotation (Line(points={{-81,53},{
          -36,53},{-36,15.7},{-22.9,15.7}}, color={191,0,0}));
  connect(meteofile.Tseche, ParoiEst.T_ext) annotation (Line(points={{-81,53},{
          -36,53},{-36,-14.3},{-22.9,-14.3}}, color={191,0,0}));
  connect(meteofile.Tseche, ParoiOuest.T_ext) annotation (Line(points={{-81,53},
          {-36,53},{-36,-44.3},{-22.9,-44.3}}, color={191,0,0}));
  connect(Plancher.T_int, noeudAir.port_a) annotation (Line(points={{-1,-82},{6,
          -82},{6,76},{88,76},{88,-10}}, color={191,0,0}));
  connect(FenetreNord.CLOTr, multiSum.u[1]) annotation (Line(points={{36.9,64.5},
          {56,64.5},{56,-75.15},{48,-75.15}}, color={255,192,1}));
  connect(FenetreSud.CLOTr, multiSum.u[2]) annotation (Line(points={{36.9,32.5},
          {58,32.5},{56,32.5},{56,-73.05},{48,-73.05}}, color={255,192,1}));
  connect(FenetreEst.CLOTr, multiSum.u[3]) annotation (Line(points={{36.9,0.5},
          {56,0.5},{56,-74.1},{48,-74.1},{48,-70.95}}, color={255,192,1}));
  connect(FenetreOuest.CLOTr, multiSum.u[4]) annotation (Line(points={{36.9,
          -29.5},{56,-29.5},{56,-74.8},{48,-74.8},{48,-68.85}}, color={255,192,
          1}));
  connect(multiSum.y, Plancher.FluxAbsInt) annotation (Line(points={{34.98,-72},
          {14,-72},{14,-77},{-7,-77}}, color={0,0,127}));
  annotation (
Documentation(info="<html>
<h4>Modèle d'exemple simple de zone thermique</h4>
<p><span style=\"color: #ff0000;\">Ce modèle sert d'exemple d'un assemblage simple d'une zone thermique - il ne peut pas être utilisé tel quel et doit être paramétré, y compris avec une remontée des paramètres de chaque sous-modèle afin que ceux-ci soient accessibles de l'extérieur dans un assemblage utilisant ce modèle.</span></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de bâtiment parallélépipédique monozone vitré, à connecter à des conditions limites sur la gauche:</p>
<ul>
<li>le <i>port_a</i> pour la température de d'air extérieur</li>
<li>le <i>port_a1 </i>pour la température du sol</li>
<li>et <i>G,</i> un realOutput pour les flux solaires. </li>
</ul>
<p>Le plafond est directement soumis à la température extérieure. Les murs sont orientés selon les quatres points cardinaux.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Néant.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Ce modèle de bâtiment monozone est à connecter à un modèle de conditions limites météo sur la gauche (Température extérieure, de sol et données relatives à l'ensoleillement).</p>
<p>Le paramètrage des parois se fait par l'intermédiaire du paramètre caracParoi, cependant on peut toujours paramétrer les parois couche par couche sans créer de type de paroi. </p>
<ol>
<li><i><b>Cliquer sur la petite flèche de caracParoi+ Edit</b></i></li>
<li><i><b>Remplir les champs concernant le nombre de couches, leur épaisseur, le maillage. Le paramètre positionIsolant est optionnel</b></i></li>
<li><i><b>Pour le paramètre mat, cliquer sur la petite flèche + Edit array, faire correspondre le nombre de case sur une colonne au nombre de couche de matériaux dans la fenêtre s'affichant puis dans chaque case effectuer un clic droit + Insert function Call et parcourir la bibliothèque pour indiquer le chemin du matériaux souhaité (dans <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\">Utilities.Data.Solids</a>)</b></i></li>
</ol>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux.</b></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Cristian Muresan 04/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Cristian MURESAN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</p>
<p>Gilles Plessis 02/2012 : Remplacement du modèle de renouvellement d'air et suppression de la valeur du débit de ventilation (=0,2m3/h dans l'ancienne zone)</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})),         Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}},
        initialScale=0.1)),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput);
end OneZone;
