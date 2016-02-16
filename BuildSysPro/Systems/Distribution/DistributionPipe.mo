within BuildSysPro.Systems.Distribution;
model DistributionPipe "Modélisation d'un réseau d'eau chaude ou eau froide"

  import SI = Modelica.SIunits;

  parameter Integer Choix=1  annotation(Dialog(group="Choix de la méthode de calcul"), choices(choice=1
        "Charactéristiques tuyauterie connues",    choice=2
        "Estimation par puissance chaudière"));

  parameter SI.Length L=20
    "Longueur d'échange du réseau _ si Ler = 0 alors calcul simplifié et forfaitaire des pertes selon QfouNom"
                                                                                                        annotation(Dialog(enable=(Choix==1), group="Choix 1 : Caractéristiques tuyauterie connues"));
  parameter SI.ThermalConductivity U=0.04
    "Coefficient d'échange linéique, caractéristique du réseau d'eau"                               annotation(Dialog(enable=(Choix==1), group="Choix 1 : Caractéristiques tuyauterie connues"));
  parameter SI.SpecificHeatCapacity CpLiq=4190
    "Capacité thermique du fluide caloporteur" annotation(Dialog(enable=(Choix==1), group="Choix 1 : Caractéristiques tuyauterie connues"));
  parameter Real Rpnre= 0.8 "Ratio des pertes thermiques non récupérables"
                                                     annotation(Dialog(enable=(Choix==2), group="Choix 2 : Estimation par puissance chaudière"));
  parameter Modelica.SIunits.Power QfouNom=8000
    "puissance nominale fournie par la production centrale" annotation(Dialog(enable=(Choix==2), group="Choix 2 : Estimation par puissance chaudière"));
  parameter Real Cperte=0.025
    "pertes par défaut évaluées à 2.5% de QfouNom" annotation(Dialog(enable=(Choix==2), group="Choix 2 : Estimation par puissance chaudière"));

protected
SI.MassFlowRate Debit; //Débit massique circulant daans la conduite
SI.Power Qper; //Chaleur perdue

public
  Modelica.Blocks.Interfaces.RealOutput Sortie[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{80,-10},{120,30}}),
        iconTransformation(extent={{80,-20},{100,0}})));
  Modelica.Blocks.Interfaces.RealInput Entree[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-100,-20},{-80,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Zone
    "Zone dans laquelle se trouve les conduites d'eau" annotation (Placement(
        transformation(extent={{-10,60},{10,80}}), iconTransformation(extent={{
            -10,60},{10,80}})));
// -----------------------------------------------------------------------------------
equation

// Il y a conservation du débit : Entrée[2]=Sortie[2]
  Debit=Entree[2];

// Calcul des pertes sur le réseau
  if (L>0) then// CAS: RESEAU CONNU

  // Calcul de la température de sortie
    if Entree[1]>Zone.T then
      Sortie[1]= max(Zone.T,Entree[1] - (Entree[1]-Zone.T)*(1-exp(-U*L/(Debit*CpLiq))));
    else
      Sortie[1]= min(Zone.T,Entree[1] - (Entree[1]-Zone.T)*(1-exp(-U*L/(Debit*CpLiq))));
    end if;
  // Calcul des pertes
    Qper = Debit*CpLiq*(Entree[1] - Sortie[1]);

  else // CAS : VALEURS PAR DEFAUT
  // Calcul des pertes
    Qper = Cperte*QfouNom;

  // Calcul de la température
    if (Debit>1e-4) then
        Sortie[1] = Entree[1] - Qper/(Debit*CpLiq);
    else
        Sortie[1] = Zone.T;
    end if;

end if;

// Calcul de la part récupérable dans les locaux
Zone.Q_flow = -Qper*(1 - Rpnre);

  connect(Entree[2], Sortie[2]) annotation (Line(
      points={{-100,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>Modèle validé - Hubert Blervaque, Sila Filfli 06/2011</p>
<p><u><b>Description</b></u></p>
<p>Prise en compte des déperditions du réseau de distribution, deux méthodes sont proposées :</p>
<p>- si les caractéristiques de la tuyauterie sont connues, le calcul permet de construire le réseau de distrubtion en joignant émetteurs (radiateurs par exemple) et éléments de tuyauterie</p>
<p>- si tel n'est pas le cas, on peut estimer les déperditions globales en fonction de la puissance de la chaudière</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>",
    revisions="<html>
<p>Hubert Blervaque - Juin 2012 : MAJ de la documentation BuildSysPro</p>
</html>"), Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-70,0},{72,-20}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          lineThickness=1),
        Ellipse(
          extent={{62,0},{78,-20}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Ellipse(
          extent={{-78,0},{-62,-20}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}));
end DistributionPipe;
