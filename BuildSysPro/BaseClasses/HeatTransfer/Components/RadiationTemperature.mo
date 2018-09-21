within BuildSysPro.BaseClasses.HeatTransfer.Components;
model RadiationTemperature "Radiative temperature of the room"

parameter Integer np=6 "Number of walles exposed to the radiative flux" annotation(Dialog(group="Opaque walls"));
parameter Modelica.SIunits.Area Sp[np]
    "Vector of wall surfaces, respecting the order of connexions"                                       annotation(Dialog(group="Opaque walls"));
parameter Modelica.SIunits.Emissivity Ep[np]
    "Vector of wall emissivities, respecting the order of connexions"                                   annotation(Dialog(group="Opaque walls"));
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
<p><u><b>Hypothesis and equations</b></u></p>
<p>Simplified model calculating the mean temperature of the walls, for the connexion to the heat port of the heating floor and the distribution of the radiative fluxes.</p>
<p><b>Radiative temperature from <code>RadiationTemperature</code> model (Buildings) :</b></p>
<p>This model computes the radiative temperature in the room. For a room with windows but no shade, the radiative temperature is computed as :</p>
<p><i>Trad = &sum;i   (Ai   &epsilon;i   Ti) &frasl; &sum;i   (Ai   &epsilon;i) </i></p>
<p>where <i>Trad</i> is the radiative temperature of the room, <i>Ai</i> are the surface areas of the room, <i>&epsilon;i</i> are the infrared emissivities of the surfaces, and <i>Ti</i> are the surface temperatures. </p>
<p><b>Radiative fluxes distribution from <code>InfraredRadiationGainDistribution</code> model (Buildings) :</b></p>
<p>This model computes the distribution of the infrared radiant heat gain to the room surfaces. The infrared radiant heat gain <i>Q</i> is an input to this model. It is distributed to the individual surfaces according to :</p>
<p><i>Qi = Q   Ai   &epsilon;i &frasl; &sum;k Ak   &epsilon;k. </i></p>
<p>For opaque surfaces, the heat flow rate <i>Qi</i> is set to be equal to the heat flow rate at the heat port. For the glass of the windows, the heat flow rate <i>Qi</i> is set to the radiosity </p>
<p><u><b>Bibliography</b></u></p>
<p><code>RadiationTemperature</code> and <code>InfraredRadiationGainDistribution</code> models (Buildings).</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Initial models : RadiationTemperature and InfraredRadiationGainDistribution, Michael Wetter, Buildings, Copyright © The Regents of the University of California, through Lawrence Berkeley National Laboratory.<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
</html>"));
end RadiationTemperature;
