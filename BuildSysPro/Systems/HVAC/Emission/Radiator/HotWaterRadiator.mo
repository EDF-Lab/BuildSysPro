within BuildSysPro.Systems.HVAC.Emission.Radiator;
model HotWaterRadiator "Hot water radiator"

  import SI = Modelica.SIunits;

  parameter Integer Type=2
    "Radiator type for determination of inertia (water filling and radiator body) by a correlation based on rated power"
    annotation(Dialog(group="Radiator technology"), choices(
                choice=1 "Cast iron radiator (high inertia)",
                choice=2 "Aluminium radiator (intermediate inertia)",
                choice=3
        "Steel panels radiator (slightly lower inertia than aluminium)"));
  parameter SI.EnergyFlowRate Pnom=1000
    "Radiator rated power. Certita database gives manufacturers data certified standard NF (French standard) for a 50°C temperature gap"
    annotation(Dialog(group = "CERTITA given parameters for a DeltaTnom = 50°C"));
  parameter SI.TemperatureDifference DeltaTnom=50
    "According to water temperature of distribution system, temperature gap between air and radiator (by default, in Certita conditions : 50°C)"
    annotation(Dialog(group = "CERTITA given parameters for a DeltaTnom = 50°C"));
  parameter Real nNom=1.29 "Slope of emission line"
    annotation(Dialog(group = "CERTITA given parameters for a DeltaTnom = 50°C"));
  parameter Integer N=10 "Number of discretized elements"
    annotation(Dialog(group = "Other parameters"));
  parameter Real CoeffCorrectif=1.1
    "For a low number of elements (<20), radiator rated power can be corrected with this parameter"
    annotation(Dialog(group = "Other parameters"));
  parameter Real FracRad(min=0, max=1) = 0.35
    "Part of radiative emission in comparison with the convective part (between 0 and 1)"
    annotation(Dialog(group = "Other parameters"));

  SI.Temperature Ta "Temperature of the room";
  SI.Temperature Te_m "mean temperature of water";
  SI.TemperatureDifference DeltaT_m
    "Mean temperature difference between an element of the radiator and the room";
  SI.EnergyFlowRate Ptot "Puissance dissipée par le radiateur à la pièce";

protected
  parameter Real Crecord[3,2]=[39.8,35.6;  13.8,11.1;  14.0,7.9];
  parameter SI.HeatCapacity Ceau=Crecord[Type,1]*Pnom
    "Volume of water in the radiator"
    annotation(Dialog(group = "Other parameters"));
  parameter SI.HeatCapacity Cmetal=Crecord[Type,2]*Pnom
    "Mass of radiator body without water (linear function applied to a cast iron radiator of Cp = 500)"
    annotation(Dialog(group = "Other parameters"));
  parameter SI.SpecificHeatCapacity CpEau=4180
    "Specific heat capacity of water"
    annotation(Dialog(group = "Other parameters"));
  SI.HeatCapacity Ci "Heat capacity of an element [J/K]";
  SI.Temperature Te[N+1] "Temperature of input water in element i";
  SI.Temperature TRad[N] "Temperature of element i";
  SI.TemperatureDifference DeltaT[N]
    "Temperature difference between an element and the room";
  SI.EnergyFlowRate P[N] "Power dissipated by an element to the room";

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Rad
    "Radiative part of dissipated heat to the room" annotation (
      Placement(transformation(extent={{-40,60},{-20,80}}),
        iconTransformation(extent={{-40,60},{-20,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Conv
    "Convective part of dissipated heat to the room" annotation (Placement(
        transformation(extent={{20,60},{40,80}}), iconTransformation(
          extent={{20,60},{40,80}})));

  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperature (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-100,32},{-80,52}}),
        iconTransformation(extent={{-100,32},{-80,52}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1- the output fluid temperature (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
equation
  // Heat capacity of an element
  Ci = (Cmetal + Ceau)/N;

  WaterOut[2] = WaterIn[2];

// Temperatures are fixed
  Ta           = Conv.T;
  Te[1]        =WaterIn[1];
  WaterOut[1] = TRad[N];

// Thermal balance of an element i
for i in 1:N loop
  Te[i+1]  = TRad[i];
  DeltaT[i]= abs(TRad[i]-Ta);
  if TRad[i]>Ta then
      P[i] = CoeffCorrectif*Pnom*(DeltaT[i]/DeltaTnom)^nNom/N;
  else // Particular case of air heating the radiator
      P[i] = -Pnom*(DeltaT[i]/DeltaTnom)/N;
  end if;
    WaterIn[2]*CpEau*(Te[i] - TRad[i]) = P[i] + Ci*der(TRad[i]);
end for;

// Means
 Te_m= sum(TRad)/N;
 DeltaT_m= sum(DeltaT)/N;

// Repartition of heating between radiative and convective
  Ptot        = sum(P);
  Rad.Q_flow  = -FracRad*Ptot;
  Conv.Q_flow = -(1-FracRad)*Ptot;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
         graphics={
        Rectangle(
          extent={{-74,52},{74,-60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-20,44},{-24,38},{-24,-50},{-20,-56},{-16,-50},{-16,38},
              {-20,44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,46},{-4,40},{-4,-48},{0,-54},{4,-48},{4,40},{0,46}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{20,44},{16,38},{16,-50},{20,-56},{24,-50},{24,38},{20,
              44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{40,44},{36,38},{36,-50},{40,-56},{44,-50},{44,38},{40,
              44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{60,44},{56,38},{56,-50},{60,-56},{64,-50},{64,38},{60,
              44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-60,44},{-64,38},{-64,-50},{-60,-56},{-56,-50},{-56,38},
              {-60,44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,44},{-44,38},{-44,-50},{-40,-56},{-36,-50},{-36,38},
              {-40,44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-80,46},{-74,40}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{74,-46},{80,-52}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-36,82},{-36,94},{-38,92}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,82},{-28,94},{-26,92}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-32,94},{-32,82},{-30,86}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-36,94},{-34,92}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-32,82},{-34,86}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,94},{-30,92}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,82},{28,84},{26,88},{26,90},{28,92},{28,94}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{34,82},{36,84},{34,88},{34,90},{36,92},{36,94}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{30,82},{32,84},{30,88},{30,90},{32,92},{32,94}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{26,92},{28,94},{30,92},{32,94},{34,92},{36,94},{38,92}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-24,94},{-24,82},{-22,86}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-24,82},{-26,86}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-74,16},{74,-10}},
          lineColor={0,0,255},
          textString="Norme NF")}),
    DymolaStoredErrors,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Diagram(graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Hot water radiator taking into account inertias of water filling and radiator body. Room heating needs and radiator control have to be modelled apart from this model as it does not include any control.</p>
<p>The radiator is discretized in horizontal slices with uniform temperature (water + metal). This discretization is detailed in document \"Type 13 Radiateur\" [EDF2000].</p>
<p>The model is based on dissipated power calculation from French standard with a power law [NF-047]. According to this standard, radiator parameters are standardized to a rated power for which the gap between mean radiator temperature and mean air temperature is 50°K.</p>
<p><u><b>Bibliography</b></u></p>
<p>Detailed modelling in note : H-E14-2011-01955-FR</p>
<p>[NF-047] NF / AERAULIQUE ET THERMIQUES - Radiateurs, convecteurs et panneaux rayonnants de plafonds - Annexe n°9</p>
<p>[EDF2000] Type 13, Radiateur, Document interne EDF sur la modélisation d'un radiateur à eau, corrigé par M. Raguin</p>
<p><u><b>Instructions for use</b></u></p>
<p>Setting of inertia is simplified thanks to a list of correlations by radiator type (cast iron, aluminium, steel) from manufactures data.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>For specific studies needing accuracy, it is possible to develop a pre-processor in order to determine the best value for the corrective coefficient <code>CoeffCorrectif</code>.</p>
<p>In further modelling, if the radiative dissipation become sensitive in comparison with conductive dissipation, it would be good to refine <code>FracRad</code> parameter in order to make it dependent on radiator temperature.</p>
<p><u><b>Validations</b></u> </p>
<p>Validated model - Hubert Blervaque, Sila Filfli 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
revisions=""));
end HotWaterRadiator;
