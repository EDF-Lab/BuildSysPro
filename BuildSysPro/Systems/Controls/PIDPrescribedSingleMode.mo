within BuildSysPro.Systems.Controls;
model PIDPrescribedSingleMode
  "Calcul des besoins de chauffage ou de clim (PID avec scénario de température)"

parameter Boolean saisieTableau=false
    "= false si on connecte la température de consigne à un RealInput , = true si on saisit la température de consigne dans un tableau"
    annotation(Dialog(group="Mode de saisie de la consigne"));
parameter Boolean tableauSurFichier=false
    "= true, si les consignes de température sont indiquées dans un fichier texte"
    annotation(Dialog(group="Scénario de consigne de température",enable=saisieTableau));
parameter Real tableau[:, :] = [0, 292.15]
    "Tableau à définir ici si pas dans un fichier texte (première colonne=temps en secondes, deuxième colonne=consigne de température en Kelvin); par défaut consigne à 19°C"
       annotation(Dialog(group="Scénario de consigne de température", enable = not tableauSurFichier and saisieTableau));
parameter String nomTableau="data"
    "Nom du tableau indiqué dans le fichier texte"
       annotation(Dialog(group="Scénario de consigne de température", enable = tableauSurFichier and saisieTableau));
parameter String nomFichier=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ConsigneChauffageRT2012_Kelvin.txt")
    "Emplacement du fichier texte contenant le tableau des températures de consigne"
       annotation(Dialog(group="Scénario de consigne de température", enable = tableauSurFichier and saisieTableau,
                         __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Ouvrir le fichier renseignant le scénario des températures de consigne")));
parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Type d'interpolation des données dans le tableau"
  annotation(Dialog(group="Scénario de consigne de température",enable=saisieTableau));
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation de la température de consigne en dehors du domaine de définition du tableau"
  annotation(Dialog(group="Scénario de consigne de température",enable=saisieTableau));

parameter Real PuissanceNom=1000
    "puissance du convecteur ou de la clim (toujours positif !)";
parameter Integer chaud_froid=0 "0 - chauffage, 1 - refroidissement"
    annotation (dialog(
      compact=true), choices(
      choice=0 "Chauffage",
      choice=1 "Refroidissement",
      radioButtons=true));
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10000,
    Ni=0.1,
    initType=Modelica.Blocks.Types.InitPID.SteadyState,
    Td=0.,
    yMin= if chaud_froid==0 then 0. else -PuissanceNom,
    limitsAtInit=true,
    yMax= if chaud_froid==0 then PuissanceNom else 0,
    Ti=1)
    annotation (Placement(transformation(extent={{44,-10},{24,-30}})));
  BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{0,-38},{-20,-18}})));
  BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(
        transformation(extent={{-100,-100},{-80,-80}}),
                                                 iconTransformation(extent={{-100,
            -100},{-80,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable1(
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableOnFile=tableauSurFichier,
    table=tableau,
    tableName=nomTableau,
    fileName=nomFichier,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) if
                            saisieTableau
                      annotation (Placement(transformation(extent={{36.8,-92.5},
            {56.8,-72.5}})));
  Modelica.Blocks.Continuous.Integrator integrator annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={11,-65})));
  Modelica.Blocks.Math.Gain gain(k=1/(1000*3600))
                                           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={12,-46})));
  Modelica.Blocks.Interfaces.RealOutput Pth "puissance thermique appelée"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-6,-58}),  iconTransformation(extent={{80,10},{100,30}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput kWh_th "kWh thermiques cumulés"
                                           annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=-90,
        origin={12,-93}), iconTransformation(extent={{80,-31},{100,-9}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput Tcons if not saisieTableau
    "température de consigne [K]"
    annotation (Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=-90,
        origin={84,-94}), iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-80,0})));
equation
  connect(PID.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{23,-20},{10,-20},{10,-29.4},{-1,-29.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T,PID. u_m) annotation (Line(
      points={{60,0},{60,4},{34,4},{34,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.port, port_a) annotation (Line(
      points={{80,0},{98,0},{98,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gain.y,integrator. u) annotation (Line(
      points={{12,-52.6},{11,-52.6},{11,-59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y,kWh_th)  annotation (Line(
      points={{11,-70.5},{11,-93},{12,-93}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, port_a) annotation (Line(
      points={{-21,-29.4},{-68,-29.4},{-68,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID.y, gain.u) annotation (Line(
      points={{23,-20},{12,-20},{12,-38.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, Pth) annotation (Line(
      points={{23,-20},{10,-20},{10,-36},{-6,-36},{-6,-58}},
      color={0,0,127},
      smooth=Smooth.None));
 if saisieTableau then
   connect(combiTimeTable1.y[1],PID.u_s);
 else
   connect(Tcons,PID.u_s);
 end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                         graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-18,-98},{22,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,40},{14,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{14,0},{60,0}},  color={0,0,255}),
        Line(points={{-88,0},{-10,0}}, color={0,0,255}),
        Polygon(
          points={{-10,40},{-10,80},{-8,86},{-4,88},{2,90},{8,88},{12,86},{14,
              80},{14,40},{-10,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-10,40},{-10,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{14,40},{14,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-38,-20},{-10,-20}}, color={0,0,0}),
        Line(points={{-38,20},{-10,20}}, color={0,0,0}),
        Line(points={{-38,60},{-10,60}}, color={0,0,0}),
        Text(
          extent={{128,-20},{28,-120}},
          lineColor={0,0,0},
          textString="°K"),
        Text(
          extent={{-52,184},{70,62}},
          lineColor={0,0,255},
          textString="Chauffage ou
refroidissement"),
        Line(points={{60,20},{80,20}},color={0,0,255}),
        Line(points={{60,-20},{80,-20}},
                                      color={0,0,255}),
        Line(points={{60,-20},{60,20}},
                                      color={0,0,255})}),
    Documentation(info="<html>
<p><i><b>Convecteur ou climatiseur à un noeud d'air en fonction d'un scénario de température </b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle suppose une régulation PID pour un apport de calories (chauffage) ou de frigories (refroidissement). Les consignes de température sont stockées dans un fichier texte de scénario.</p>
<p><br><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Le fichier texte ou le tableau de températures de consigne doit contenir dans la première colonne, le temps en secondes, et dans la deuxième colonne, la température de consigne en <u>Kelvin</u></p>
<p>Un exemple de scénario de température de consigne se trouve dans BuildSysPro/Resources/Donnees/Scenarios/ConsigneChauffageRT2012_Kelvin.txt</p>
<p>Deux cas d'utilisation :</p>
<p>- fonctionnement idéal : la puissance nominale doit être largement sur-dimensionnée pour pouvoir calculer les <u>besoins</u> en refroidissement ou en chauffage, sinon rien ne garantit que la puissance installée suffise à atteindre les consignes de température.</p>
<p>- fonctionnement réel : la puissance nominale est la puissance de dimensionnement, ce qui permet de voir si le dimensionnement permet de satisfaire les températures de consigne.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p><b>Attention ! </b>Les températures de consigne dans le fichier texte, dans le tableau renseigné ou connectées au port Tcons suivant les cas, doivent être en degrés Kelvin</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 10/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Modification en 10/2013 par A.Lindsay : les consignes de température ne doivent plus être renseignées en degrés Celsius mais en degrés Kelvin !!! Ajout de la possibilité de calculer les besoins de froid et non pas que les besoins de chaud</p>
<p>04/2014 A.  Lindsay : modification du gain avant intégration pour bien obtenir des kWh !</p>
</html>"));
end PIDPrescribedSingleMode;
