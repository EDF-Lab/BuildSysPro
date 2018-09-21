within BuildSysPro.Systems.HVAC.Emission.Radiator;
model HotWaterRadiatorRegulDistrib
  "Hot water radiator with control and distribution"

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

  Modelica.Blocks.Interfaces.RealInput Regulation
    "Valve opening control (between 0 and 1)"           annotation (Placement(
        transformation(extent={{-120,20},{-80,60}}),   iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,50})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Rad
    "Radiative part of dissipated heat to the room" annotation (
      Placement(transformation(extent={{-40,60},{-20,80}}), iconTransformation(
          extent={{-26,60},{-6,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Conv
    "Convective part of dissipated heat to the room" annotation (Placement(
        transformation(extent={{20,60},{40,80}}), iconTransformation(extent={{
            34,60},{54,80}})));

  HotWaterRadiatorRegul radiateurNF(
    N=N,
    Pnom=Pnom,
    DeltaTnom=DeltaTnom,
    nNom=nNom,
    DebitNom=DebitNom,
    CoeffCorrectif=CoeffCorrectif,
    FracRad=FracRad,
    Type=Type)
    annotation (Placement(transformation(extent={{-60,-60},{60,40}})));

  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperature (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1- the output fluid temperature (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{92,-78},{112,-58}}),
        iconTransformation(extent={{92,-80},{112,-60}})));

equation
  // Water flow rate conservation
  WaterOut[2] = WaterIn[2];

// if the water flow is too low, heating needs are made null beacause
// - there is an error of dimensioning
// - distribution system is off and the radiator should not dissipate heat
  radiateurNF.Regulation=if DebitNom < WaterIn[2] then Regulation else 0;

// Output temperature is the weighted mean by water flows : on the output of the radiator and on the distribution system
  WaterOut[1] = (WaterIn[1]*(WaterIn[2] - radiateurNF.WaterOut[2]) +
    radiateurNF.WaterOut[1]*radiateurNF.WaterOut[2])/WaterOut[2];

  connect(radiateurNF.Conv, Conv) annotation (Line(
      points={{18,25},{30,25},{30,70}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiateurNF.Rad, Rad) annotation (Line(
      points={{-18,25},{-30,25},{-30,70}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(WaterIn, radiateurNF.WaterIn) annotation (Line(
      points={{-90,-70},{-68,-70},{-68,10},{-54,10}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-48,54},{74,-38}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{62,50},{60,46},{60,-30},{62,-34},{66,-30},{66,46},{62,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-54,52},{-48,46}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{74,-28},{80,-34}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-22,84},{-22,96},{-24,94}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-14,84},{-14,96},{-12,94}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-18,96},{-18,84},{-16,88}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-22,96},{-20,94}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-18,84},{-20,88}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-14,96},{-16,94}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,84},{42,86},{40,90},{40,92},{42,94},{42,96}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{48,84},{50,86},{48,90},{48,92},{50,94},{50,96}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{44,84},{46,86},{44,90},{44,92},{46,94},{46,96}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{40,94},{42,96},{44,94},{46,96},{48,94},{50,96},{52,94}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-10,96},{-10,84},{-8,88}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-10,84},{-12,88}},
          color={0,0,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{-82,-60},{82,-80}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Ellipse(
          extent={{76,-60},{88,-80}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-86,-60},{-78,-80}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{34,50},{32,46},{32,-30},{34,-34},{38,-30},{38,46},{34,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{48,50},{46,46},{46,-30},{48,-34},{52,-30},{52,46},{48,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-6,50},{-8,46},{-8,-30},{-6,-34},{-2,-30},{-2,46},{-6,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{8,50},{6,46},{6,-30},{8,-34},{12,-30},{12,46},{8,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{22,50},{20,46},{20,-30},{22,-34},{26,-30},{26,46},{22,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-34,50},{-36,46},{-36,-30},{-34,-34},{-30,-30},{-30,46},{-34,
              50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-20,50},{-22,46},{-22,-30},{-20,-34},{-16,-30},{-16,46},{-20,
              50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-56,52},{-54,-60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{80,-28},{82,-62}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                        graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Hot water radiator taking into account inertias of water filling and radiator body. Room heating needs have to be modelled apart from this model.</p>
<p>The radiator is controlled by an input of valve opening (between 0 and 1). The model manages the interface with a distribution system (pipe)</p>
<p>Control draws a part of distribution system water flow rate, according to the room heating needs.</p>
<p><u><b>Bibliography</b></u></p>
<p>Detailed modelling in note : H-E14-2011-01955-FR</p>
<p>[NF-047] NF / AERAULIQUE ET THERMIQUES - Radiateurs, convecteurs et panneaux rayonnants de plafonds - Annexe n°9</p>
<p>[EDF2000] Type 13, Radiateur, Document interne EDF sur la modélisation d'un radiateur à eau, corrigé par M. Raguin</p>
<p><u><b>Instructions for use</b></u></p>
<p>Setting of inertia is simplified thanks to a list of correlations by radiator type (cast iron, aluminium, steel) from manufactures data.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u> </p>
<p>Validated model - Hubert Blervaque, Sila Filfli 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Hubert Blervaque 06/2012 : MAJ de la documentation BuildSysPro.</p>
<p>Sila Filfli 04/2013 : Ajout d'une vanne thermostatique simple. Le débit varie en fonction du besoin et ne peut dépasser la valeur nominale. Le besoin est représenté par l'ouverture de la vanne avec une régulation entre 0 - fermée et 1 - ouverte (il s'agit du ratio de la puissance demandée par rapport à la puissance nominale).</p>
<p>Hubert Blervaque 09/2013 : Ajout d'une corrélation par type de radiateur (fonte, aluminium, acier) issue de données constructeur pour faciliter le paramétrage de l'inertie.</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>"));
end HotWaterRadiatorRegulDistrib;
