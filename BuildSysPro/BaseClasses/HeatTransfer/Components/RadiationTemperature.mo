within BuildSysPro.BaseClasses.HeatTransfer.Components;
model RadiationTemperature "Radiative temperature of the room"

parameter Integer np=6 "Nombre de parois percevants le flux radiatifs" annotation(Dialog(group="Parois opaques"));
parameter Modelica.SIunits.Area Sp[np]
    "Vecteurs des surfaces des parois en respectant l'ordre de connections réalisé"
                                                                                                        annotation(Dialog(group="Parois opaques"));
parameter Modelica.SIunits.Emissivity Ep[np]
    "Vecteurs des emissivités des parois en respectant l'ordre de connections réalisé"
                                                                                                        annotation(Dialog(group="Parois opaques"));
Real SpEpTot=sum(Sp[i]*Ep[i] for i in 1:np);

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b ParoiEquivalente
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a AutresParois[np] annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-90,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=90,
        origin={-90,0})));

equation
 ParoiEquivalente.T=sum(Sp[i]*Ep[i]*AutresParois[i].T for i in 1:np)/SpEpTot;
 for i in 1:np loop
    AutresParois[i].Q_flow=-ParoiEquivalente.Q_flow*Sp[i]*Ep[i]/SpEpTot;
 end for;

annotation (
preferedView="info",
Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{74,8},{-70,30}},
          color={255,0,0},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{74,0},{-70,0}},
          color={255,0,0},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{74,-8},{-70,-30}},
          color={255,0,0},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open})}),
Documentation(
info="<html>
<p>Modèle simplifié du modèle Modelica Buildings pour la détermination de la température moyenne des parois pour la connection du port radtifs du planchers chauffants et la distribution des flux radiatifs. </p>
<ul>
<li>Température radiative d'après RadiationTemperature</li>
</ul>
<p>This model computes the radiative temperature in the room. For a room with windows but no shade, the radiative temperature is computed as </p>
<p align=\"center\"><i>Trad = &sum;i   (Ai   &epsilon;i   Ti) &frasl; &sum;i   (Ai   &epsilon;i) </i></p>
<p>where <i>Trad</i> is the radiative temperature of the room, <i>Ai</i> are the surface areas of the room, <i>&epsilon;i</i> are the infrared emissivities of the surfaces, and <i>Ti</i> are the surface temperatures. </p>
<ul>
<li>Distribution des flux radiatifs d'après InfraredRadiationGainDistribution</li>
</ul>
<p>This model computes the distribution of the infrared radiant heat gain to the room surfaces. The infrared radiant heat gain <i>Q</i> is an input to this model. It is distributed to the individual surfaces according to </p>
<p align=\"center\"><i>Qi = Q   Ai   &epsilon;i &frasl; &sum;k Ak   &epsilon;k. </i></p>
<p>For opaque surfaces, the heat flow rate <i>Qi</i> is set to be equal to the heat flow rate at the heat port. For the glass of the windows, the heat flow rate <i>Qi</i> is set to the radiosity </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
</html>"));
end RadiationTemperature;
