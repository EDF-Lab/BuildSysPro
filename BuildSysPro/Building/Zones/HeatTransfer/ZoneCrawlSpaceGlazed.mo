within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpaceGlazed
  "Modèle de zone sur vide sanitaire en thermique pure."

extends ZoneCrawlSpace(   pintDistribRad(nf=4, Sf={S1v,S2v,S3v,S4v}));

parameter Boolean ensoleillement=true "Prise en compte des flux solaires";

//Fenêtres//
parameter Modelica.SIunits.Area S1v=1 "Surface vitrée de la paroi Sud"  annotation(Dialog(tab="Fenêtres"));
parameter Modelica.SIunits.Area S2v=1 "Surface vitrée de la paroi Ouest"  annotation(Dialog(tab="Fenêtres"));
parameter Modelica.SIunits.Area S3v=1 "Surface vitrée de la paroi Nord" annotation(Dialog(tab="Fenêtres"));
parameter Modelica.SIunits.Area S4v=1 "Surface vitrée de la paroi Est" annotation(Dialog(tab="Fenêtres"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U
    "Conductivité thermique des vitrages"                                                    annotation(Dialog(tab="Fenêtres"));
parameter Real tau "Coefficient de transmission des vitrages" annotation(Dialog(tab="Fenêtres"));
parameter Real AbsFen=0.1
    "Coefficient d'absorption en direct et diffus de la fenêtre" annotation(Dialog(tab="Fenêtres"));

// Pour ce modèle pas de distinction diffus/direct
protected
parameter Modelica.SIunits.CoefficientOfHeatTransfer hefen=21
    "Coefficient d'échange extérieur des fenêtres";
parameter Modelica.SIunits.CoefficientOfHeatTransfer hifen=8.29
    "Coefficient d'échange intérieur des fenêtres";
parameter Modelica.SIunits.CoefficientOfHeatTransfer k=1/(1/U-1/hefen-1/hifen)
    "Coefficient de transmission surfacique des vitrages - sans convection int/ext";

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenSud(
    S=S1v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-24,18},{-8,34}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenOuest(
    S=S2v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-24,-36},{-8,-20}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenNord(
    S=S3v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-24,48},{-8,64}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window FenEst(
    S=S4v,
    TrDir=tau,
    TrDif=tau,
    AbsDir=AbsFen,
    AbsDif=AbsFen,
    k=k,
    hs_ext=hefen,
    hs_int=hifen,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-24,-10},{-8,6}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxS
    annotation (Placement(transformation(extent={{70,-60},{60,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxN
    annotation (Placement(transformation(extent={{70,-70},{60,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxE
    annotation (Placement(transformation(extent={{70,-80},{60,-70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow FluxO
    annotation (Placement(transformation(extent={{70,-90},{60,-80}})));

equation
  connect(FenNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,53.6},{-2,53.6},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,23.6},{-2,23.6},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,-4.4},{-2,-4.4},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-8.8,-30.4},{-2,-30.4},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenNord.T_ext, Text) annotation (Line(
      points={{-23.2,53.6},{-30,53.6},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenOuest.T_ext, Text) annotation (Line(
      points={{-23.2,-30.4},{-30,-30.4},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenEst.T_ext, Text) annotation (Line(
      points={{-23.2,-4.4},{-30,-4.4},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenSud.T_ext, Text) annotation (Line(
      points={{-23.2,23.6},{-30,23.6},{-30,-48},{-98,-48},{-98,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Plancher.Ts_int, FluxO.port) annotation (Line(
      points={{-45,-67},{-45,-86},{52,-86},{52,-85.7},{59.5,-85.7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plancher.Ts_int, FluxE.port) annotation (Line(
      points={{-45,-67},{-45,-86},{52,-86},{52,-75.7},{59.5,-75.7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plancher.Ts_int, FluxN.port) annotation (Line(
      points={{-45,-67},{-45,-86},{52,-86},{52,-65.7},{59.5,-65.7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plancher.Ts_int, FluxS.port) annotation (Line(
      points={{-45,-67},{-45,-86},{52,-86},{52,-55.7},{59.5,-55.7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenSud.CLOTr, FluxS.Q_flow) annotation (Line(
      points={{-8.8,30},{86,30},{86,-55.7},{69.5,-55.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenNord.CLOTr, FluxN.Q_flow) annotation (Line(
      points={{-8.8,60},{86,60},{86,-65.7},{69.5,-65.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenEst.CLOTr, FluxE.Q_flow) annotation (Line(
      points={{-8.8,2},{86,2},{86,-75.7},{69.5,-75.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenOuest.CLOTr, FluxO.Q_flow) annotation (Line(
      points={{-8.8,-24},{86,-24},{86,-85.7},{69.5,-85.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, FenNord.FLUX) annotation (Line(
      points={{-95,18.2},{-90,18.2},{-90,60},{-18.4,60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, FenSud.FLUX) annotation (Line(
      points={{-95,14.4},{-88,14.4},{-88,30},{-18.4,30}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, FenEst.FLUX) annotation (Line(
      points={{-95,10.4},{-88,10.4},{-88,2},{-18.4,2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, FenOuest.FLUX) annotation (Line(
      points={{-95,6.4},{-88,6.4},{-88,-24},{-18.4,-24}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ciel, FenNord.T_ciel) annotation (Line(
      points={{-150,-30},{-92,-30},{-92,-46},{-28,-46},{-28,48.8},{
          -23.2,48.8}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, FenSud.T_ciel) annotation (Line(
      points={{-150,-30},{-92,-30},{-92,-46},{-28,-46},{-28,18.8},{
          -23.2,18.8}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, FenEst.T_ciel) annotation (Line(
      points={{-150,-30},{-92,-30},{-92,-46},{-28,-46},{-28,-9.2},{
          -23.2,-9.2}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, FenOuest.T_ciel) annotation (Line(
      points={{-150,-30},{-92,-30},{-92,-46},{-28,-46},{-28,-35.2},{
          -23.2,-35.2}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[3], FenNord.FluxAbsInt)
    annotation (Line(
      points={{36.2,73.625},{12,73.625},{12,57.6},{-13.6,57.6}},
      color={255,192,1},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[1], FenSud.FluxAbsInt)
    annotation (Line(
      points={{36.2,75.125},{12,75.125},{12,27.6},{-13.6,27.6}},
      color={255,192,1},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[4], FenEst.FluxAbsInt)
    annotation (Line(
      points={{36.2,72.875},{12,72.875},{12,-0.4},{-13.6,-0.4}},
      color={255,192,1},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[2], FenOuest.FluxAbsInt)
    annotation (Line(
      points={{36.2,74.375},{12,74.375},{12,-26.4},{-13.6,-26.4}},
      color={255,192,1},
      thickness=0.5,
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<h4>Modèle de zone parallèpipèdique sur vide sanitaire avec vitrages modélisé en thermique pure.</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de bâtiment parallélépipédique monozone sur vide sanitaire vitré, à connecter à un modèle de conditions limites(port thermique de gauche) et realOutput de gauche pour les flux solaires. Par défaut les murs sont orientés selon les quatres points cardinaux; la modification de l'orientation est représentée par le paramètre beta. Le port thermique de droite est connecté au volume intérieur (capacité thermique). Les températures extérieures auxquelles sont soumis le plancher et le plafond sont pondérées par un coefficient b. Pour considérer le rayonnement des parois en grande longueur d'onde, les coefficients d'échange h doivent être des <b>coefficients d'échange globaux</b>. </p>
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
<p>Modèle validé - Ludovic Darnaud 07/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Ludovic DARNAUD, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Gilles Plessis 02/2011: Changement du modèle de coefficient B pour vérifier la conservation d'énergie + Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(__Dymola_choicesAllMatching=true)</p>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents + Modèle mis en extends du cas sans vitres (ZoneVideSanitaire)</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{100,100}}),
                         graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {100,100}}),
         graphics={
        Rectangle(
          extent={{-116,-2},{-54,-38}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}));
end ZoneCrawlSpaceGlazed;
