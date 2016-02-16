within BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed;
model HPHeatingAir2Air
  "PAC air/air en mode chauffage fonctionnant en tout-ou-rien"

  parameter Integer Choix=1
    annotation(Dialog(group="Choix de la méthode de paramétrisation"), choices(
                choice=1
        "Par défaut : un point de fonctionnement à 7°C/20°C",
                choice=2 "Expert : 3 points de fonctionnement"));

// Parametrisation d'après modèle PAC par défaut : Choix 1
  parameter Modelica.SIunits.Power Qnom=1380.87
    "Puissance calorifique nominale dans les conditions de températures de Enom"
    annotation (Dialog(enable=(Choix==1), group="Paramétrisation choix 1"));
  parameter Real COPnom=4.18468
    "Coefficient de performance nominal dans les conditions de températures de Enom"
    annotation (Dialog(enable=(Choix==1), group="Paramétrisation choix 1"));

// Parametrisation experte : Choix 2
  parameter Real Enom[4] = {7,20,329.982,1380.87}
    "Données nominales constructeur : {Text(°C), Tint(°C), Puissance électrique appelée(W), Chaleur fournie(W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));
  parameter Real E1[4] = {-7,23,260.174,921.479}
    "Données nominales constructeur : {Text(°C), Tint(°C), Puissance électrique appelée(W), Chaleur fournie(W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));
  parameter Real E2[4] = {14,17,365.383,1690.44}
    "Données nominales constructeur : {Text(°C), Tint(°C), Puissance électrique appelée(W), Chaleur fournie(W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));

// Autres paramètres communs aux différents choix
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

  Real COPt "Coefficient de performance de la PAC à l'instant t";
  Boolean v;

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
  Modelica.SIunits.Temperature TextRatC = if Choix==1 then 280.15 else Enom[1]+273.15
    "Température nominale de l'air extérieur nominale en mode chaud";
  Modelica.SIunits.Temperature TintRatC = if Choix==1 then 293.15 else Enom[2]+273.15
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

public
  Modelica.Blocks.Interfaces.RealOutput Qfour "Heat supply (W)"
    annotation (Placement(transformation(extent={{60,-26},{94,8}}),
        iconTransformation(extent={{80,-20},{120,20}})));

  Modelica.Blocks.Interfaces.RealInput Text "Température extérieure (K)"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput Tint "inside air temperature (K)"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
        iconTransformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Qelec "Consumed electric power (W)"
    annotation (Placement(transformation(extent={{60,12},{94,46}}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-98})));

  Modelica.Blocks.Interfaces.BooleanInput u
    "Valeur de la bande proportionnelle sur la température de consigne"
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100}),iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,90})));

  Modelica.Blocks.Interfaces.BooleanInput SaisonChauffe annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-22,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-58,92})));
equation
// Performances de la machine ssuivant la méthode de paramétrisation choisi par l'utilisateur
  if Choix==1 then
    QcRat=Qnom;
    QaRatC=Qnom/COPnom;
    C1 = -2.94982;
    C2 =  4.16648;
    D1 =  0.0154996;
    D2 = -0.0385624;
  else
    QcRat=Enom[4];
    QaRatC=Enom[3];
    D2=((E1[1]-Enom[1])*(E2[2]-Enom[2]))/(((E1[1]-Enom[1])*(E2[2]-Enom[2])-(E2[1]-Enom[1])*(E1[2]-Enom[2]))*(E2[2]-Enom[2]))*(E2[4]/Enom[4]-1-(E2[1]-Enom[1])/(E1[1]-Enom[1])*(E1[4]/Enom[4]-1));
    D1=(E1[4]/Enom[4]-1-D2*(E1[2]-Enom[2]))/(E1[1]-Enom[1]);
    C2=((E2[3]/E2[4])/(Enom[3]/Enom[4])-1-Dt2/Dt1*((E1[3]/E1[4])/(Enom[3]/Enom[4])-1))/(Dt2*Dt2-Dt1*Dt2);
    C1=((E1[3]/E1[4])/(Enom[3]/Enom[4])-1-C2*Dt1*Dt1)/Dt1;
  end if;

// Calculate required energy rates at full load for no-rating conditions
    Qcflssdegi = QcRat*(1 + D1*(Text - TextRatC) + D2*(Tint - TintRatC));

// Defrost losses when Text < 2°C
    if (Text > 275.15) then
      Qcfl = Qcflssdegi;
    else
      Qcfl = Cdegi*Qcflssdegi;
    end if;

// calculate non-dimensionnal temperature difference
    Dt = Text/Tint - TextRatC/TintRatC;
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
    Qfour=if v then Qcfl*(1-exp(-dtOn/TauOn)) else 0;
    COPt=Qfour/Qelec;

else  Qfour = 0;
      Qelec =0;
      COPt = 0;
end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),                       Icon(coordinateSystem(
          preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                                                     graphics={Rectangle(
          extent={{-96,96},{96,-96}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          textString=" PAC Air/Air 
tout ou rien, variable"),
        Text(
          extent={{6,84},{62,68}},
          lineColor={0,0,0},
          textString="& Dtmin")}),
    Documentation(info="<html>
<p><u><b>Description</b></u></p>
<p>Il s'agit d'une pompe à chaleur air/air fonctionnement en tout ou rien (vitesse fixe) pour le mode chaud seul.</p>
<p><u><b>Modèle</b></u></p>
<p>Le modèle se veut minimaliste en terme de paramètres a renseigner et se base sur une approche empirique de la détermination de la puissance en régime permanent suivant les conditions de températures intérieure et extérieure. Le régime transitoire est modélisé à l'aide d'une constante de temps pour la puissance fournie. </p>
<p>La PAC fonctionne en tout ou rien. Le système de contr&ocirc;le associé lui indique quels sont les phases de marche et d'arrêt. Pour protéger la machine, il est commun que des temps de marche et d'arrêts minimimums soient définis (DtminOn et DtminOff), ils interviennent en régulation internes à la machine. </p>
<p><u><b>Choix de paramétrage</b></u></p>
<p>Quatres choix de paramétrages sont possibles : <b>ATTENTION ! </b>Veuillez à remettre les valeurs par défaut des options de paramétrage qui ne sont utilisés car ils sont susceptibles d'être utilisés pour simuler la configuration par défaut</p>
<ol>
<li>Indication de la puissance calorifique nominale (COP par défaut d'environ 4.2), les performances de la PAC sont adaptées à la puissance nominal définie par l'utilisateur</li>
<li>Indication de la puissance nominale et du COP, il est possible de choisir la puissance nomianle et le COP de la PAC (attention un écart trop important de ces valeurs avec celles par défaut pourraient entraîner une modélisation peu fiable d'une machine réelle)</li>
<li>Indication de 3 points de fonctionnement, l'approche empirique du modèle nécessite 3 points de fonctionnement qui délimiteront la plage de températures du modèle</li>
<li>Indication du point nominal et coeff de régression, cette paramétrisation experte permet de définir les coefficients C1, C2, D1 et D2 par une méthode extérieure au modèle (régression plus fine sur davantage de points de fonctionnements par exemple)</li>
</ol>
<p><br>Bien qu'il faut veiller à remettre les valeurs par défaut pour utiliser la configuratuion par défaut, il est possible pour les utilisateurs avertis de modifier la courbe de performances de la PAC à l'aide du mode 3 ou 4, puis passer en mode 1 ou 2 pour moduler la puissance de la PAC à partir des perfromances rentrées ci-avant. </p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Pour toute approche empirique, il faut porter une attention particulière au choix de la plage des températures de fonctionnement.</p>
<p>Dégradation liées au givrage/dégivrage est donnée de façon assez grossière sans dynamique (dégradation de 10% de la puissance fournie pour des températures extérieures inférieures à 2&deg;C) </p>
<p>Pas adapté à la vitesse variable</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé avec TIL - Hubert Blervaque- Sila Filfli 05/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Sila Filfli - novembre 2013 : MAJ de la description des paramètres</p>
</html>"));
end HPHeatingAir2Air;
