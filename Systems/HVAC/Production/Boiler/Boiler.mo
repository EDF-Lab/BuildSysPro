within BuildSysPro.Systems.HVAC.Production.Boiler;
model Boiler

  import SI = Modelica.SIunits;
  import BuildSysPro.BaseClasses.Media.OLD_THERMHYGAERO.AirFunctions.Psat;

  parameter Real PCSI=1.11 "Ratio PCS/PCI défini suivant le combustible";
  parameter SI.Temperature Tnom=273.15+70 "Temperature nominale"
                           annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter Real PLRnom=100 "Taux de charge nominale (%)"         annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Power Pnom=17300 "Puissance nominale" annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter Real etaNom=97.4 "Efficacité PCI nominale (%)"        annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Temperature TInt=273.15+33 "Temperature intermédiaire"
                                 annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter Real PLRInt=30 "Taux de charge intermédiaire (%)"     annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Power PInt=5190 "Puissance intermédiaire"           annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter Real etaInt=107.2 "Efficacité PCI intermédiaire (%)"  annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Power PertesT30K = 60 "Pertes à l'arrêt" annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.VolumeFlowRate V_flow= 1.02/3600
    "Débit volumique nominal d'eau"                               annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter Modelica.SIunits.Volume Veau(displayUnit="l") = 2.8E-3
    "Volume d'eau contenue dans la chaudière"                     annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Mass mSec = 35 "Masse à sec"                       annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Power Paux = 24
    "Puissance électrique des auxiliaires à puissance nominale (hors ciculateur)"
     annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Power Pveille = 5.2 "Puissance de veille (hors ciculateur)"
     annotation(Dialog(group = "Paramètres fournis sur ATITA"));
  parameter SI.Power Pcirculateur = 37 "Puissance électrique du ciculateur"
     annotation(Dialog(group = "Paramètres fournis sur ATITA"));

  parameter Real DetaPLR = 1
    "Ecart d'efficacité à TInt entre un PLRnom et PLRInt (entre 0 et 2 pt% suivant les machines)"
     annotation(Dialog(tab = "Autres paramètres",group="Performance"));
  parameter Real PLRmin = PLRInt "Taux de charge minimal"
     annotation(Dialog(tab = "Autres paramètres",group="Performance"));
  parameter SI.Time TimePrePurge=30 "Durée de la pre-purge"
     annotation(Dialog(tab = "Autres paramètres",group="Performance"));
  parameter SI.Time TimeCycle(displayUnit="min")=300
    "Durée minimale d'un cycle (anti-court cyle)"
     annotation(Dialog(tab = "Autres paramètres",group="Performance"));
  parameter SI.Time TimeCirculateur(displayUnit="min")=600
    "Durée de fonctionnemnt du circulateur après un cycle de combustion"
     annotation(Dialog(tab = "Autres paramètres",group="Performance"));
  parameter SI.SpecificHeatCapacity CpE = 4180 "Capacité thermique de l'eau"
     annotation(Dialog(tab = "Autres paramètres",group="Propriétés des fluides"));
  parameter SI.Density rhoE = 1000 "Masse volumique de l'eau"
     annotation(Dialog(tab = "Autres paramètres",group="Propriétés des fluides"));
  parameter SI.VolumeFlowRate V_flowAir = 6.7E-3 * (Pnom/20000)
    "Pré-purge : Débit volumique nominal d'air (valeur nominale d'après [Kemna2007])"
     annotation(Dialog(tab = "Autres paramètres",group="Propriétés des fluides"));
  parameter SI.SpecificHeatCapacity CpA = 1000 "Capacité thermique de l'air"
     annotation(Dialog(tab = "Autres paramètres",group="Propriétés des fluides"));
  parameter SI.Density rhoA = 1.2 "Masse volumique de l'air"
     annotation(Dialog(tab = "Autres paramètres",group="Propriétés des fluides"));

protected
  parameter SI.ThermalConductance UA=PertesT30K/30
    "Conductante à travers l'enveloppe";
  parameter SI.Pressure Pref = 101300 "Pression de référence";
  parameter SI.Temperature Tref = 15 + 273.15 "Temperature de référence";
  parameter Real lambda = 0.01
    "Variable de décalage des coefficients de pondération sigmas";
  discrete SI.Time Time0(start=0) "Début du cycle de la chaudière";
  discrete SI.Time TimeF(start=0) "Fin du cycle de la chaudière";

public
  Real etaRP "Efficacité en régime permanent à T et PLR de fonctionnement";
  SI.Power QaFournir "Puissance thermique à fournir";
  Integer NbCycle(start=0);

protected
  SI.Temperature Tc
    "Température d'intersection de la charactéristique Sensible et Latente";
  SI.Temperature Te=Entree[1]
    "Température de retour d'eau (i.e. température d'entrée d'eau)";
  //EGAL AU PORT D'ENTREE
  Real a1=(etaNom-100)/(Tnom-Tref)
    "Pente de la droite charactérisant la partie sensible";
  Real etaSens;
  Real etaCond30;
  Real etaCond;
  Real sigmaSens;
  Real sigmaCond;
  Real a;
  SI.MassFlowRate Debit
    "Débit massique d'eau au ciculateur donc dans la chaudière";

public
  Modelica.Blocks.Interfaces.RealInput PLR(min=0, max=100)
    "Part load ratio (0-100%)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor ConductanceEnv(G=UA)
    "Resistance thermique de l'enveloppe de la chaudière"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,32})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tamb
    "Temperature ambiante du lieu où se situe la chaudière"
    annotation (Placement(transformation(extent={{40,50},
            {60,70}},            rotation=0), iconTransformation(extent={{50,70},
            {70,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CpChau(
      C=500*mSec) "Capacité thermique de la chaudière (masse à sec)"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(
        extent={{-5.75,-5.75},{5.75,5.75}},
        rotation=0,
        origin={-14.25,-80.25})));
  Modelica.Blocks.Sources.RealExpression QaFournirExp(y=QaFournir)
    annotation (Placement(transformation(extent={{-62,-90},{-42,-70}})));
  Modelica.Blocks.Interfaces.RealOutput Pgaz
    "Puissance thermique fournie par combustion de gaz"
    annotation (Placement(transformation(extent={{92,16},{112,36}}),
        iconTransformation(extent={{92,16},{112,36}})));
  Modelica.Blocks.Interfaces.RealOutput Pelec
    "Puissance électrique consommée (auxiliaires...)"
    annotation (Placement(transformation(extent={{92,40},{112,60}}),
        iconTransformation(extent={{92,-16},{112,4}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CpEau(C=CpE*rhoE*Veau)
    "Capacité thermique du volume d'eau"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    annotation (Placement(transformation(
        extent={{-5.75,-5.75},{5.75,5.75}},
        rotation=0,
        origin={-34.25,-40.25})));
  Modelica.Blocks.Sources.RealExpression BilanEau(y=Debit*CpE*(Entree[1] -
        Sortie[1]))
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression DebitExp(y=Debit)
    annotation (Placement(transformation(extent={{40,-40},{60,-24}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{46,-54},{60,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput SaisonChauffe annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-30,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,90})));

protected
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1
    annotation (Placement(transformation(extent={{2,2},{-2,-2}})));
public
  Modelica.Blocks.Interfaces.RealInput Entree[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-128,-60},{-88,-20}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Sortie[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{92,-50},{112,-30}}),
        iconTransformation(extent={{92,-50},{112,-30}})));
initial equation

algorithm
if SaisonChauffe then  //La chaudière est lancée pour PLR > PLRmin
  //Détermination de l'efficacité pour la loi sans condensation
  etaSens   :=etaNom + a1*(Te - Tnom);
  //Détermination de l'efficacité pour la loi caractérisant la condensation
  etaCond30 :=etaInt + (100*PCSI - etaInt)*(1 - Psat(Te)/Psat(TInt)*TInt/Te);
  etaCond   :=etaCond30 - DetaPLR*(Tc - Te)/(Tc - TInt)*(PLR - PLRInt)/(PLRnom -
      PLRInt);
  //Détermination de l'efficacité en régime permanent
  sigmaSens :=1/(1 + exp(Tc - Te - lambda));
  sigmaCond :=1 - 1/(1 + exp(Tc - Te + lambda));
  etaRP     :=sigmaSens*etaSens + sigmaCond*etaCond;
  if PLR>PLRmin then
    if noEvent(time <= Time0+TimePrePurge) then
      a:=1;//Pré-purge
      Pelec:=Paux + Pcirculateur;
      QaFournir :=V_flowAir*rhoA*CpA*(15+273.15 - CpEau.port.T);//semble négligeable, à supprimer ??? OUI d'après étude paramétrique, suppression de l'entrée T qui est fixée à 15°C
      Pgaz:=0;

    else
      a:=2;//Combustion
      //on considère que la moité de la puissance électrique nominale dépend du ventilateur qui dépend du taux de charge (PLR)
      Pelec:=Paux*(0.5 + 0.5*PLR/100) + Pcirculateur;
      //Les données constructeurs intégrent déjà les déperditions à travers l'enveloppe donc en cas de marche, on ajoute le terme de déperditions par l'enveloppe
      QaFournir :=PInt + (PLR - PLRInt)/(PLRnom - PLRInt)*(Pnom - PInt) + abs(ConductanceEnv.Q_flow);
      Pgaz:=QaFournir*100/etaRP;//efficacité en pourcentage
    end if;
  else
    if noEvent(time <= Time0+TimePrePurge+TimeCycle) then
      a:=3; //Anticourtcycle à puissance minimale
      Pelec:=Paux*(0.5 + PLRmin/100) + Pcirculateur;
      QaFournir :=PInt + abs(ConductanceEnv.Q_flow);
      Pgaz:=QaFournir*100/etaRP;//efficacité en pourcentage
    elseif noEvent(time < max(TimeF,Time0+TimePrePurge+TimeCycle)+TimeCirculateur) then
        a:=4;//Bruleur éteint mais circulateur en fonctionnement
        Pelec:=Pveille + Pcirculateur;
        QaFournir:=0;
        Pgaz:=0;
    else
        a:=5;//Bruleur éteint et circulateur coupé
        Pelec:=Pveille;
        QaFournir:=0;
        Pgaz:=0;
    end if;
  end if;
else
  a:=0;//Arrêt saisonnier
  Pelec:=0;
  QaFournir:=0;
  Pgaz:=0;
end if;

equation
  Debit = if a < 1 or a > 4 then 0 else V_flow * rhoE;
  //Détermination du point d'intersection Tc
  etaNom+a1*(Tc-Tnom) = etaInt+(100*PCSI-etaInt)*(1-Psat(Tc)/Psat(TInt)*TInt/Tc);

  when PLR >= PLRmin then
    Time0 = time;
  end when;
  when PLR <= PLRmin then
    TimeF = time;
  end when;

  when Pgaz<0.1*PInt then
    NbCycle = pre(NbCycle) + 1;
  end when;

  connect(ConductanceEnv.port_a, Tamb)           annotation (Line(
      points={{1.83697e-015,42},{0,60},{50,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QaFournirExp.y, preHeaFlo.Q_flow)      annotation (Line(
      points={{-41,-80},{-20,-80},{-20,-81.055},{-19.425,-81.055}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(BilanEau.y, preHeaFlo1.Q_flow)         annotation (Line(
      points={{-59,-40},{-38,-40},{-38,-41.055},{-39.425,-41.055}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo1.port, CpEau.port)   annotation (Line(
      points={{-27.925,-41.055},{30,-41.055},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(CpEau.port, temperatureSensor.port)   annotation (Line(
      points={{30,0},{30,-47},{46,-47}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(ConductanceEnv.port_b, port_b1) annotation (Line(
      points={{-1.77636e-015,22},{0,22},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, CpEau.port) annotation (Line(
      points={{0,0},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, CpChau.port) annotation (Line(
      points={{0,0},{-30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHeaFlo.port, port_b1) annotation (Line(
      points={{-7.925,-81.055},{0,-81.055},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, Sortie[1]) annotation (Line(
      points={{60,-47},{80,-47},{80,-45},{102,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DebitExp.y, Sortie[2]) annotation (Line(
      points={{61,-32},{80,-32},{80,-35},{102,-35}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-32,96},{-8,86}},
          lineColor={0,0,127},
          textString="PLR"),
        Rectangle(
          extent={{-100,60},{100,-80}},
          lineColor={245,0,0},
          lineThickness=1,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{44,28},{90,18}},
          lineColor={0,0,255},
          textString="Conso GAZ"),
        Text(
          extent={{40,-2},{90,-12}},
          lineColor={0,0,255},
          textString="Conso ELEC"),
        Polygon(
          points={{-58,-86},{-58,-86},{-50,-76},{-42,-86},{-44,-94},{-48,-96},{-56,
              -94},{-58,-86},{-58,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-54,-90},{-54,-90},{-50,-82},{-44,-90},{-46,-94},{-48,-96},{-52,
              -94},{-54,-90},{-54,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{-38,-86},{-38,-86},{-30,-76},{-22,-86},{-24,-94},{-28,-96},{-36,
              -94},{-38,-86},{-38,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-34,-90},{-34,-90},{-30,-82},{-24,-90},{-26,-94},{-28,-96},{-32,
              -94},{-34,-90},{-34,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{-18,-86},{-18,-86},{-10,-76},{-2,-86},{-4,-94},{-8,-96},{-16,
              -94},{-18,-86},{-18,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-14,-90},{-14,-90},{-10,-82},{-4,-90},{-6,-94},{-8,-96},{-12,
              -94},{-14,-90},{-14,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{2,-86},{2,-86},{10,-76},{18,-86},{16,-94},{12,-96},{4,-94},{2,
              -86},{2,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{6,-90},{6,-90},{10,-82},{16,-90},{14,-94},{12,-96},{8,-94},{6,
              -90},{6,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{22,-86},{22,-86},{30,-76},{38,-86},{36,-94},{32,-96},{24,-94},
              {22,-86},{22,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{26,-90},{26,-90},{30,-82},{36,-90},{34,-94},{32,-96},{28,-94},
              {26,-90},{26,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{42,-86},{42,-86},{50,-76},{58,-86},{56,-94},{52,-96},{44,-94},
              {42,-86},{42,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{46,-90},{46,-90},{50,-82},{56,-90},{54,-94},{52,-96},{48,-94},
              {46,-90},{46,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{64,-86},{64,-86},{72,-76},{80,-86},{78,-94},{74,-96},{66,-94},
              {64,-86},{64,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{68,-90},{68,-90},{72,-82},{78,-90},{76,-94},{74,-96},{70,-94},
              {68,-90},{68,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{-78,-86},{-78,-86},{-70,-76},{-62,-86},{-64,-94},{-68,-96},{-76,
              -94},{-78,-86},{-78,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-74,-90},{-74,-90},{-70,-82},{-64,-90},{-66,-94},{-68,-96},{-72,
              -94},{-74,-90},{-74,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Rectangle(
          extent={{-82,-30},{-40,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Ellipse(
          extent={{78,-30},{90,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-86,-30},{-78,-50}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-30},{84,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-40,-30},{40,-50}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash),
        Polygon(
          points={{10,-20},{-2,16},{6,16},{-8,22},{-10,10},{-6,14},{6,
              -22},{10,-20}},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={12,-62},
          rotation=360),
        Text(
          extent={{-98,54},{-74,44}},
          lineColor={0,0,127},
          textString="Text")}),
defaultComponentName="boi",
Documentation(info="<html>
<p><u><b>Description</b></u></p>
<p>Il s'agit d'un modèle dynamique de chaudière modulante à condensation.</p>
<p><br><u><b>Modèle</b></u></p>
<p>Le modèle de prévision de la consommation de gaz est estimé par un modèle de boîte grise. La consommation électrique est déterminée suivant les consommations des différentes phases de fonctionnement de la chaudière (purge, circulateur, marche veille, etc). Le modèle est paramétrable à partir de données certifiées accessibles sur la base ATITA (www.rt2005-chauffage)</p>
<p><br><u><b>Paramétrage et étude de sensibilité</b></u></p>
<p>Ce modèle nécessite peu de données d'entrées accessibles d'après les essais normatifs.</p>
<p>Suite à une étude de sensibilité,</p>
<ul>
<li>Les durées de de l'anticourt-cyle et surtout de celle du fonctionnement du circulateur après la combustion ont un impact très marqué sur la consommation et le nombre de cycle de la machine ;</li>
<li>Le paramètre &Delta;&eta; (représentant la baisse de performances en fonction de la charge à une température de retour d'eau de 30) a un effet quasiment nulle sur les résultats pour les niveaux de température la loi d'eau considérée (entre 35 et 45 &deg;C). Dans le cas de la modélisationn d'un système nécessitant des températures d'eau supérieure à 35, l'utilisateur peut laisser la valeur proposée par défaut, d'autant plus que ce paramètre n'est pas fourni dans la base ATITA ;</li>
<li>La considération de la purge pré-combustion durant laquelle l'air de la chambre de combustion doit être renouvelé a également un impact réduit : la sur-consommation ne dépasse pas les 0,5% et est due principalement au retard de 30 secondes avant le lancement de la chaudière qu'à la puissance thermique perdue dans les fumées.</li>
</ul>
<p><br><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Il s'agit d'un modèle dynamique détaillé. Certaines phénomènes sont représentés d'une manière simple :</p>
<ul>
<li>Les déperditions à travers la paroi sont intégralement transmis au milieu ambiant (la RT2012 donne des coefficients de la part qui est perdue -par exemple à travers le mur pour une chaudière murale),</li>
<li>La consommations des auxiliaires est partiellement dégradée sous forme thermique (par exemple via la transformation de l'énergie cinétique de l'eau dans les conduites en chaleur par frottement pour la puissance fournie au circulateur), cette conservation de l'énergie n'est pas prise en compte actuellement,</li>
</ul>
<p><br><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Hubert Blervaque- Sila Filfli 07/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T & m_flow.</p>
<p>Benoît Charrier 01/2016 : Passage du calcul du débit en equation pour compatibilité OpenModelica.</p>
</html>"),
    experiment(StopTime=5000, Interval=600),
    __Dymola_experimentSetupOutput);
end Boiler;
