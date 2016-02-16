within BuildSysPro.Systems.HVAC.Emission.ElectricHeater;
model JouleHeatingPIControlled "Convecteur électrique avec régulation PI"

parameter Modelica.SIunits.Power Pnom=1500 "Puissance nominale du convecteur" annotation(choices(
choice=250 "250W",
choice=500 "500W",
choice=750 "750W",
choice=1000 "1000W",
choice=1500 "1500W",
choice=2000 "2000W",
choice=2500 "2500W",
choice=3000 "3000W"));

protected
  Modelica.Blocks.Continuous.LimPID PI1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=0.,
    limitsAtInit=true,
    yMin=0.,
    yMax=1,
    k=1,
    Ti=900,
    Ni=1,
    initType=Modelica.Blocks.Types.InitPID.NoInit)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}}, rotation=180,
        origin={-60,0})));

  Modelica.Blocks.Continuous.FirstOrder         firstOrder(T=60) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={60,0})));

public
 Modelica.Blocks.Interfaces.RealInput Tcons "Température de consigne"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput Tint "Mesure température intérieure"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealOutput Pelec
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Gain gain(k=Pnom)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(PI1.u_s, Tcons)
                      annotation (Line(
      points={{-72,1.46958e-015},{-90,1.46958e-015},{-90,20},{-110,
          20}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(PI1.u_m, Tint) annotation (Line(
      points={{-60,-12},{-60,-12},{-60,-20},{-70,-20},{-70,-20},{-110,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, Pelec) annotation (Line(
      points={{71,-1.34711e-015},{91.5,-1.34711e-015},{91.5,0},{110,
          0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, PI1.y) annotation (Line(
      points={{-10,0},{-29.5,0},{-29.5,-1.34711e-015},{-49,
          -1.34711e-015}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, firstOrder.u) annotation (Line(
      points={{13,0},{30.5,0},{30.5,1.46958e-015},{48,1.46958e-015}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=0.1, NumberOfIntervals=450),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><i><b>Convecteur électrique avec régulation PI</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<ul>
<li>Régulation PI avec Gain = 1 et Temps Intégration = 900 s.</li>
<li>Mise en chauffe de l'appareil prise en compte via un filtre 1er ordre de 60s.</li>
</ul>
<p><u><b>Bibliographie</b></u></p>
<p>Néant.</p>
<p><u><b>Mode d'emploi</b></u></p>
<ul>
<li>La température de consigne et la température mesurée doivent avoir la même unité : &deg;C ou K.</li>
<li>La puissance à injecter dans le bâtiment est Pelec.</li>
</ul>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Néant.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé dans ses conditions de fonctionnement par défaut - Bernard Clémençon 06/2012.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Bernard CLEMENCON, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 03/2014 : Modification des filtres du premier ordre issus initialement de LinearSystems2 vers Modelica.Block.Continuous. Evite l'appel à des bibliothèques externes lorsque ca n'est pas nécessaire.</p>
</html>"),
    Icon(graphics={Bitmap(extent={{-98,98},{98,-98}}, fileName=
              "modelica://BuildSysPro/Resources/Images/convecteur.gif")}));
end JouleHeatingPIControlled;
