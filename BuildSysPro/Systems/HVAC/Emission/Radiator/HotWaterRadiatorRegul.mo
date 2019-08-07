within BuildSysPro.Systems.HVAC.Emission.Radiator;
model HotWaterRadiatorRegul "Hot water radiator with control"

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
  parameter SI.MassFlowRate DebitNom=0.01 "Nominal water flow rate"
    annotation(Dialog(group = "CERTITA given parameters for a DeltaTnom = 50°C"));
  parameter Integer N=10 "Number of discretized elements"
    annotation(Dialog(group = "Other parameters"));
  parameter Real CoeffCorrectif=1.1
    "For a low number of elements (<20), radiator rated power can be corrected with this parameter"
    annotation(Dialog(group = "Other parameters"));
  parameter Real FracRad(min=0, max=1) = 0.35
    "Part of radiative emission in comparison with the convective part (between 0 and 1)"
    annotation(Dialog(group = "Other parameters"));

  SI.MassFlowRate Debit "Water flow rate in radiator";
  SI.Temperature Ta "Temperature of the room";
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
      Placement(transformation(extent={{-40,60},{-20,80}}), iconTransformation(
          extent={{-40,60},{-20,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Conv
    "Convective part of dissipated heat to the room" annotation (Placement(
        transformation(extent={{20,60},{40,80}}), iconTransformation(extent={{
            20,60},{40,80}})));
  Modelica.Blocks.Interfaces.RealInput Regulation
    "Valve opening control (between 0 and 1)"
     annotation (Placement(
        transformation(extent={{-16,-16},{16,16}},
        rotation=270,
        origin={-80,76}),                              iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,70})));

  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperature (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1- the output fluid temperature (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
equation
// Heat capacity of an element
  Ci = (Cmetal + Ceau)/N;

// Water flow rate varies depending on room heating needs, and can not exceed nominal water flow rate
  Debit        = min(1,max(Regulation,0))*DebitNom;
  WaterOut[2] = Debit;

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
  Debit*CpEau*(Te[i]-TRad[i]) = P[i] + Ci*der(TRad[i]);
end for;

// Repartition of heating between radiative and convective
  Ptot        = sum(P);
  Rad.Q_flow  = -FracRad*Ptot;
  Conv.Q_flow = -(1-FracRad)*Ptot;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-74,50},{74,-62}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-20,42},{-24,36},{-24,-52},{-20,-58},{-16,-52},{-16,36},{-20,
              42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,42},{-4,36},{-4,-52},{0,-58},{4,-52},{4,36},{0,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{20,42},{16,36},{16,-52},{20,-58},{24,-52},{24,36},{20,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{40,42},{36,36},{36,-52},{40,-58},{44,-52},{44,36},{40,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{60,42},{56,36},{56,-52},{60,-58},{64,-52},{64,36},{60,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-60,42},{-64,36},{-64,-52},{-60,-58},{-56,-52},{-56,36},{-60,
              42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,42},{-44,36},{-44,-52},{-40,-58},{-36,-52},{-36,36},{-40,
              42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-80,44},{-74,38}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{74,-48},{80,-54}},
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
          extent={{-74,14},{74,-12}},
          lineColor={0,0,255},
          textString="Norme NF")}),
    DymolaStoredErrors,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Diagram(graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Hot water radiator taking into account inertias of water filling and radiator body. Room heating needs have to be modelled apart from this model.</p>
<p>The radiator is controlled by an input of valve opening (between 0 and 1).</p>
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
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>",
revisions="<html>
<p>Hubert Blervaque 06/2012 : MAJ de la documentation BuildSysPro.</p>
<p>Sila Filfli 04/2013 : Ajout d'une vanne thermostatique simple. Le débit varie en fonction du besoin et ne peut dépasser la valeur nominale. Le besoin est représenté par l'ouverture de la vanne avec une régulation entre 0 - fermée et 1 - ouverte (il s'agit du ratio de la puissance demandée par rapport à la puissance nominale).</p>
<p>Hubert Blervaque 09/2013 : Ajout d'une corrélation par type de radiateur (fonte, aluminium, acier) issue de données constructeur pour faciliter le paramétrage de l'inertie. </p>
<p>Frédéric Gastiger 03/2015 : Correction d'une erreur sur la valeur de la masse volumique de l'eau (1E-3 au lieu de 1E3).</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>"));
end HotWaterRadiatorRegul;
