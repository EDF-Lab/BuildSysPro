within BuildSysPro.Systems.DHW;
model ResistiveWaterHeater "Ballon ECS électrique homogène en température"
  parameter Modelica.SIunits.Volume V=0.200 "Volume"
    annotation(Dialog(group = "Ballon"));
  parameter Modelica.SIunits.Length d=0.50 "Diamètre "
    annotation(Dialog(group = "Ballon"));
  parameter Modelica.SIunits.Power P=2500 "Puissance électrique maxi en W"
    annotation(Dialog(group = "Régulation"));
  parameter Modelica.SIunits.Temperature Tcons=273.15+60
    "Température de consigne"
    annotation(Dialog(group = "Régulation"));
  parameter Modelica.SIunits.TemperatureDifference dT=3 "Bande d'hystérésis"
    annotation(Dialog(group = "Régulation"));
  parameter Modelica.SIunits.Length e=0.04 "Epaisseur"
    annotation(Dialog(group = "Isolant",tab="Autres paramètres"));
  parameter Modelica.SIunits.ThermalConductivity lambda=0.04
    "Conductivité thermique"
    annotation(Dialog(group = "Isolant",tab="Autres paramètres"));
  parameter Modelica.SIunits.Density rho=1000 "Masse volumique"
    annotation(Dialog(group = "Fluide",tab="Autres paramètres"));
  parameter Modelica.SIunits.SpecificHeatCapacity Cp=4185 "Chaleur massique"
    annotation(Dialog(group = "Fluide",tab="Autres paramètres"));
  //Modelica.SIunits.Temperature T "Température de l'eau dans le ballon";
  Integer Hyst(start=0) "Hystérésis";

  Real PertekWh "Perte Ã©nergÃ©tique par l'enveloppe du ballon en kWh";
  Real EnergieCHkWh "Energie de chauffage de l'eau du ballon en kWh";

protected
  constant Real pi=Modelica.Constants.pi;
  constant Real coef36=1.0/3.6e6;
  constant Modelica.SIunits.CoefficientOfHeatTransfer he=10
    "Coefficien d'échange extérieur";

  parameter Modelica.SIunits.Area Sb=pi*d*d/4 "surface de la base du ballon";
  parameter Modelica.SIunits.Length H=V/Sb "Hauteur du ballon";
  parameter Modelica.SIunits.Area St=pi*d*H+2*Sb "surface totale d'échange";

  parameter Modelica.SIunits.CoefficientOfHeatTransfer h=1.0/(1/he+e/lambda)
    "Coefficien d'échange extérieur";
  parameter Modelica.SIunits.ThermalConductance KS=(1.1+0.05/V)*h*St;
  parameter Modelica.SIunits.HeatCapacity C=rho*Cp*V;

public
  Modelica.Blocks.Interfaces.RealInput Tef
    "Température d'eau froide en degré C" annotation (Placement(transformation(
          extent={{-120,-10},{-80,30}}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-100})));
  Modelica.Blocks.Interfaces.RealInput debit "débit de puisage en kg/s"
    annotation (Placement(transformation(extent={{-120,-84},{-80,-44}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-100})));
  Modelica.Blocks.Interfaces.RealInput OnOff
    "Signal Marche(1)/Arrêt(0) de la résistance électrique" annotation (
      Placement(transformation(extent={{-100,40},{-60,80}}), iconTransformation(
          extent={{-100,40},{-60,80}})));
  Modelica.Blocks.Interfaces.RealOutput Pelec
    "Puissance électrique injectée en W" annotation (Placement(transformation(
          extent={{60,60},{80,80}}), iconTransformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Interfaces.RealOutput ConsokWh
    "Consommation électrique en kWh" annotation (Placement(transformation(
          extent={{60,40},{80,60}}), iconTransformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b portAMB "Air ambiant"
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
        iconTransformation(extent={{60,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor deperdition(G=KS)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-14})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,-32})));
  Modelica.Thermal.HeatTransfer.Components.Convection ChauffageEau
                                                                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-14,-32})));
  Modelica.Blocks.Math.Gain gain(k=Cp)
    annotation (Placement(transformation(extent={{-60,-74},{-40,-54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,46})));
  Modelica.Blocks.Sources.RealExpression Puissance(y=Pelec)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Eau(C=C)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={14,10})));
  Modelica.Blocks.Interfaces.RealOutput T
    "Température de l'eau dans le ballon [K]"
                                           annotation (Placement(transformation(
          extent={{60,82},{80,102}}),iconTransformation(extent={{-10,-10},{10,
            10}},
        rotation=90,
        origin={0,90})));
equation
  Hyst=if T<Tcons-dT then 1 elseif T>Tcons+dT then 0 else pre(Hyst);
  Pelec=OnOff*P*Hyst;
  T=Eau.T;
  der(ConsokWh)=Pelec*coef36;
  der(EnergieCHkWh)=ChauffageEau.solid.Q_flow*coef36;
  der(PertekWh)=deperdition.port_a.Q_flow*coef36;
initial equation
//  der(T)=0.0;
  T=Tcons;
  EnergieCHkWh=0.0;
  PertekWh=0.0;

equation
  connect(deperdition.port_b, portAMB)
                                     annotation (Line(
      points={{52,0},{70,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(toKelvin.Celsius, Tef) annotation (Line(
      points={{-70,-2},{-70,10},{-100,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvin.Kelvin, prescribedTemperature.T) annotation (Line(
      points={{-70,-25},{-70,-32},{-56,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, ChauffageEau.fluid)
                                                        annotation (Line(
      points={{-34,-32},{-24,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(debit, gain.u) annotation (Line(
      points={{-100,-64},{-62,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, ChauffageEau.Gc)
                                 annotation (Line(
      points={{-39,-64},{-14,-64},{-14,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Puissance.y, prescribedHeatFlow.Q_flow)      annotation (Line(
      points={{-27,60},{1.83697e-015,60},{1.83697e-015,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, Eau.port) annotation (Line(
      points={{-1.83697e-015,36},{0,36},{0,0},{14,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(deperdition.port_a, Eau.port) annotation (Line(
      points={{32,0},{14,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ChauffageEau.solid, Eau.port) annotation (Line(
      points={{-4,-32},{14,-32},{14,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (                               Diagram(graphics),
    Icon(graphics={Rectangle(
          extent={{-60,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,0,255},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="ECS
homogène"),
        Text(
          extent={{-30,74},{30,54}},
          lineColor={0,0,255},
          textString="Teau")}),
    Documentation(info="<html>
<h4>Ballon d'eau chaude électrique à un seul noeud de température : la température est supposée homogène (pas de stratification).</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le ballon est supposé cylindrique : diamètre d et hauteur H.</p>
<p>L'isolant (conductivité lambda et épaisseur e) est réparti uniformément sur la surface extérieure du ballon.</p>
<p>La masse d'eau est supposée à température homogène T.</p>
<p>Le stockage de chaleur dans le ballon résulte de la superposition de 3 flux de chaleur :</p>
<ul>
<li>la puissance électrique injectée dans l'eau moyennant une résistantce de puissance P pour maintenir la consigne Tcons suivant un signal Marche/Arrêt (OnOff),</li>
<p>- La régulation est à hystérésis avec une demie-bande dT de part et d'autre de la consigne : Hyst = if TTcons+dT then 0 else pre(Hyst)</p>
<p>- La puissance électrique injectée dans l'eau est égale à : Pelec = OnOff.P.Hyst </p>
<li>la puissance participant au chauffage du débit de puisage qui arrive dans le ballon avec une température Tef (eau froide) et en sort à la température T,</li>
<p>- La puissance de chauffage de l'eau est égale à : debit.Cp.(T - Tef) </p>
<li>les déperditions du ballon à travers son enveloppe calculées selon la référence [1] :</li>
</ul>
<p>- On admet une coefficient d'échane extérieur moyen he = 10 W/(m&sup2;.K)</p>
<p>- Le coefficient de déperdition vaut en première approximation : KS = (1,1 +0,05/V).h.S avec 1/h = 1/he + e/lambda, S = pi.d.(H + d/2) et V = pi.d&sup2;.H/4 </p>
<p><u><b>Bibliographie</b></u></p>
<p>[1] : E.C.S. : l'eau chaude sanitaire dans les bâtiments résidentiels et tertiaires</p>
<p>Conception et calcul des installations</p>
<p>Collection des guides de l'AICVF, pyc édition, première édition 1991</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Voir exemple <a href=\"BuildSysPro.Systems.DHW.Examples.DHWResistiveWaterHeater\">DHWResistiveWaterHeater</a>.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Ce modèle est très simple à implémenter dans une étude et favorise un faible temps de calcul.</p>
<p>Il est très suffisant et précis pour traiter des problèmes de consommation sur une longue durée (1 an par exemple).</p>
<p>Cependant pour des études sur les appels de puissance, il est conseillé d'utiliser des modèles de ballon prenant en compte la stratification thermique.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Hassan Bouia 10/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ResistiveWaterHeater;
