within BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed;
model HPHeatingAir2Water
  "PAC air/eau en mode chauffage fonctionnant en tout-ou-rien"

  parameter Integer Choix=1
    annotation(Dialog(group="Choix de la méthode de paramétrisation"), choices(
                choice=1
        "Par défaut : un point de fonctionnement à 7°C/35°C",
                choice=2 "Expert : 3 points de fonctionnement"));

// Parametrisation d'après modèle PAC par défaut : Choix 1
  parameter Modelica.SIunits.Power Qnom=6490
    "Puissance calorifique nominale dans les conditions de températures de Enom"
    annotation (Dialog(enable=(Choix==1), group="Paramétrisation choix 1"));
  parameter Real COPnom=4.3
    "Coefficient de performance nominal dans les conditions de températures de Enom"
    annotation (Dialog(enable=(Choix==1), group="Paramétrisation choix 1"));

// Parametrisation experte : Choix 2
  parameter Real Enom[4] = {2,45,1800,4950}
    "Données nominales constructeur : {Text(°C), TdépartEau(°C), Puissance électrique appelée(W), Puissance fournie(W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));
  parameter Real E1[4] = {-15,55,1980,2480}
    "Données constructeur : {Text(°C), TdepartEau(°C), Puissance électrique appelée(W), Puissance fournie(W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));
  parameter Real E2[4] = {20,25,1690,7750}
    "Données constructeur : {Text(°C), TdepartEau(°C), Puissance électrique appelée(W), Puissance fournie(W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));

// Autres paramètres communs aux différents choix

  parameter Modelica.SIunits.MassFlowRate MegRat=0.1
    "Débit d'eau nominal côté intérieur"    annotation (Dialog(group="Autres paramètres"));
  parameter Modelica.SIunits.Power QfanextRat=0
    "Puissance du ventilateur extérieur, si QfanextRat  incluse dans Qa alors choisir 0"
    annotation (Dialog(group="Autres paramètres"));
  parameter Real Cdegi=0.9
    "Coefficient de dégradation du au givrage : 10% du temps de dégivrage en dessous de 2°C"
    annotation (Dialog(group="Autres paramètres"));
  parameter Modelica.SIunits.Time TauOn=120
    "Constante de temps de mise en marche [GAR 2002]"
    annotation (Dialog(group="Autres paramètres"));
  parameter Real alpha=0.01
    "Pourcentage de puissance de veille (EcoDesign Draft report of Task 4 : 1, 2 ou 3 % d'après travaux de Henderson2000)"
    annotation (Dialog(group="Autres paramètres"));
  parameter Modelica.SIunits.Time dtminOn=360
    "Durée minimum de fonctionnement"
    annotation (Dialog(group="Autres paramètres"));
  parameter Modelica.SIunits.Time dtminOff=360
    "Durée minimum d'arrêt avant redémarrage"
    annotation (Dialog(group="Autres paramètres"));

  Integer NbCyclePAC(start=0);
  Boolean v(start=false);

protected
  parameter Real Dtnom = (273.15+Enom[1])/(273.15+Enom[2]);
  parameter Real Dt1 = (273.15+E1[1])/(273.15+E1[2])-Dtnom;
  parameter Real Dt2 = (273.15+E2[1])/(273.15+E2[2])-Dtnom;
  Real D2;
  Real D1;
  Real C2;
  Real C1;
  Modelica.SIunits.Power QcRat "Puissance calorifique nominale fournie";
  Modelica.SIunits.Power QaRatC
    "Puissance appelée nominale au compresseur en mode chaud";
  Modelica.SIunits.Temperature TextRatC
    "Température nominale de l'air extérieur nominale en mode chaud";
  Modelica.SIunits.Temperature TintRatC
    "Température nominale de l'air à la sortie de l'unité intérieur en mode chaud";
  Modelica.SIunits.Power Qcflssdegi "sans dégivrage";
  Modelica.SIunits.Power Qcfl
    "chaleur fournie à pleine charge à température non nominale";
  Modelica.SIunits.Power Qafl
    "puissance appelée au compresseur à pleine charge à température non nominale";
  Real Dt;

  Boolean w;
  Modelica.SIunits.Time tOn;
  Modelica.SIunits.Time dtOn;
  Modelica.SIunits.Time tOff;
  Modelica.SIunits.Time dtOff;
  Modelica.SIunits.SpecificHeatCapacity CpLiq=4180;

public
  Modelica.Blocks.Interfaces.RealOutput Qfour "Heat supply (W)"
    annotation (Placement(transformation(extent={{60,-26},{94,8}}),
        iconTransformation(extent={{90,20},{110,40}})));

  Modelica.Blocks.Interfaces.RealInput Text "Température extérieure (K)"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Interfaces.RealOutput Qelec "Consumed electric power (W)"
    annotation (Placement(transformation(extent={{60,12},{94,46}}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,60})));

  Modelica.Blocks.Interfaces.BooleanInput u(start=false)
    "Valeur de la bande proportionnelle sur la température de consigne"
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100}),iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,90})));

  Modelica.Blocks.Interfaces.BooleanInput SaisonChauffe annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-22,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,90})));
  Modelica.Blocks.Interfaces.RealInput Entree[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}}),
        iconTransformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Sortie[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{80,-70},{120,-30}}),
        iconTransformation(extent={{92,-50},{112,-30}})));

equation
// Performances de la machine ssuivant la méthode de paramétrisation choisi par l'utilisateur
  if Choix==1 then
    TextRatC = 7+273.15;
    TintRatC = 35+273.15;
    QcRat=Qnom;
    QaRatC=Qnom/COPnom;
    C1 = -2.94982;
    C2 =  4.16648;
    D1 =  0.0154996;
    D2 = -0.0385624;
  else
    TextRatC = Enom[1]+273.15;
    TintRatC = Enom[2]+273.15;
    QcRat=Enom[4];
    QaRatC=Enom[3];
    D2=((E1[1]-Enom[1])*(E2[2]-Enom[2]))/(((E1[1]-Enom[1])*(E2[2]-Enom[2])-(E2[1]-Enom[1])*(E1[2]-Enom[2]))*(E2[2]-Enom[2]))*(E2[4]/Enom[4]-1-(E2[1]-Enom[1])/(E1[1]-Enom[1])*(E1[4]/Enom[4]-1));
    D1=(E1[4]/Enom[4]-1-D2*(E1[2]-Enom[2]))/(E1[1]-Enom[1]);
    C2=((E2[3]/E2[4])/(Enom[3]/Enom[4])-1-Dt2/Dt1*((E1[3]/E1[4])/(Enom[3]/Enom[4])-1))/(Dt2*Dt2-Dt1*Dt2);
    C1=((E1[3]/E1[4])/(Enom[3]/Enom[4])-1-C2*Dt1*Dt1)/Dt1;
  end if;

// Calculate required energy rates at full load for no-rating conditions
    Qcflssdegi = QcRat*(1 + D1*(Text - TextRatC) + D2*(Entree[1] - TintRatC));

// Defrost losses when Text < 2°C
    if (Text > 275.15) then
      Qcfl = Qcflssdegi;
    else
      Qcfl = Cdegi*Qcflssdegi;
    end if;

// calculate non-dimensionnal temperature difference
    Dt = Text/Entree[1] - TextRatC/TintRatC;
// Calculate consumed energy rates at full load for no-rating conditions
    Qafl = Qcflssdegi*(QaRatC/QcRat)*(1 + C1*Dt + C2*Dt*Dt);

// Two minimum time periods protect the machin
     when pre(v) then
       tOn=time;
     end when;
     dtOn=time-tOn;

     w = not v;
     when pre(w) then
       tOff=time;
     end when;
     dtOff=time-tOff;

    v = ((u or dtOn<=dtminOn) and dtOff>=dtminOff);

// Dynamic simulation
    //Concernant la puissance électrique absorbée, les auteurs s'accordent à dire qu'il n'y a pas
    //de constante de temps sur Pabs et que sa valeur en régime dynamique est égale à sa valeur en
    //régime permanent [Goldsmith 80], [Henderson 96], [O'Neal 91]. Cette hypothèse a été
    //confirmée par de nombreuses expérimentations [Rasmussen 87], [Miller 85] et [Garde 97a]. d'après [Garde2001]
if SaisonChauffe then
    Qelec=if v then Qafl+QfanextRat else alpha*QaRatC;
    //La puissance fournie est déterminée par une dynamique à une constante de temps.
    Qfour = if v then Qcfl*(1-exp(-dtOn/TauOn)) else 0;
    Sortie[2] = if v then MegRat else 1E-10;
    Sortie[1] = if v then Entree[1]+Qfour/(MegRat*CpLiq) else Entree[1];
else
    Qfour = 0;
    Qelec =0;
    Sortie[2] = 1E-10;
    Sortie[1] = Entree[1];
end if;

  when v then
    NbCyclePAC = pre(NbCyclePAC) + 1;
  end when;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}})),                 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                     graphics={
        Rectangle(
          extent={{-96,80},{96,-60}},
          lineColor={95,95,95},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{-80,-60},{80,-90}},
          lineColor={0,0,255},
          textString=" PAC Air/Eau
tout ou rien, variable"),
        Text(
          extent={{20,100},{76,84}},
          lineColor={0,0,0},
          textString="& Dtmin"),
        Line(
          points={{-126,42},{-120,44},{-116,40},{-110,44},{-104,40},{-100,42}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-126,38},{-120,40},{-116,36},{-110,40},{-104,36},{-100,38}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Polygon(
          points={{-52,60},{-52,22},{-32,36},{-32,46},{-52,60}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-38,50},{-28,60},{96,60}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0}),
        Line(
          points={{-18,4},{6,30},{90,30}},
          smooth=Smooth.None,
          color={0,0,0},
          pattern=LinePattern.Dash),
        Polygon(
          points={{16,-38},{-2,16},{6,16},{-8,22},{-10,10},{-6,14},{14,-40},{16,
              -38}},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-14,-10},
          rotation=180),
        Rectangle(
          extent={{-80,-30},{-38,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-38,-30},{42,-50}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{42,-30},{86,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Ellipse(
          extent={{80,-30},{92,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-84,-30},{-76,-50}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>PAC air/eau à vitesse de compresseur fixe - modèle polynomial adapté à un pas du temps variable</h4>
<h4>Information</h4>
<p><u><b>Description</b></u></p>
<p>Il s'agit d'une pompe à chaleur air/eau fonctionnement en tout ou rien (vitesse fixe) pour le mode chaud seul.</p>
<p><u><b>Modèle</b></u></p>
<p>Le modèle se veut minimaliste en terme de paramètres a renseigner et se base sur une approche empirique de la détermination de la puissance en régime permanent suivant les conditions de températures intérieure et extérieure. Le régime transitoire est modélisé à l'aide d'une constante de temps pour la puissance fournie. </p>
<p>La régulation du lancement est déterminée par l'input booléen &QUOT;u&QUOT; : VRAI la PAc doit fonctionner et FALSE doit être à l'arrêt.</p>
<p>La PAC fonctionne en tout ou rien. Le système de contr&ocirc;le associé lui indique quels sont les phases de marche et d'arrêt. Pour protéger la machine, il est commun que des temps de marche et d'arrêts minimimums soient définis (DtminOn et DtminOff), ils interviennent en régulation internes à la machine. </p>
<p><u><b>Choix de paramétrage</b></u></p>
<p>Deux choix de paramétrages sont possibles : </p>
<ol>
<li>Indication de la puissance nominale et du COP, il est possible de choisir la puissance nomianle et le COP de la PAC (attention un écart trop important de ces valeurs avec celles par défaut pourraient entraîner une modélisation peu fiable d'une machine réelle)</li>
<li>Indication de 3 points de fonctionnement, l'approche empirique du modèle nécessite 3 points de fonctionnement qui délimiteront la plage de températures du modèle</li>
</ol>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Pour toute approche empirique, il faut porter une attention particulière au choix de la plage des températures de fonctionnement.</p>
<p>Dégradation liées au givrage/dégivrage est donnée de façon assez grossière sans dynamique (dégradation de 10% de la puissance fournie pour des températures extérieures inférieures à 2&deg;C) </p>
<p>Pas adapté à la vitesse variable</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé d'après PAC air/air avec TIL - Hubert Blervaque- Sila Filfli 02/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T & m_flow.</p>
</html>"));
end HPHeatingAir2Water;
