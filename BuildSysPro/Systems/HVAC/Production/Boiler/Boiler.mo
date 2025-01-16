within BuildSysPro.Systems.HVAC.Production.Boiler;
model Boiler

  import      Modelica.Units.SI;
  import BuildSysPro.BaseClasses.Media.OLD_THERMHYGAERO.AirFunctions.Psat;

  parameter Real PCSI=1.11
    "Ratio gross (high) heating value / net (low) heating value defined according to the fuel";
  parameter SI.Temperature Tnom=273.15+70 "Nominal temperature"
                           annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter Real PLRnom=100 "Nominal loading rate (%)"         annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Power Pnom=17300 "Nominal power" annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter Real etaNom=97.4 "Nominal net heating value efficiency (%)"        annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Temperature TInt=273.15+33 "Intermediate temperature"
                                 annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter Real PLRInt=30 "Intermediate loading rate (%)"     annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Power PInt=5190 "Intermediate power"           annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter Real etaInt=107.2 "Intermediate net heating value efficiency (%)"  annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Power PertesT30K = 60 "Stop losses" annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.VolumeFlowRate V_flow= 1.02/3600 "Volume of water in the boiler"
                                                                  annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter Modelica.Units.SI.Volume Veau(displayUnit="l") = 2.8E-3
    "Volume d'eau contenue dans la chaudière"
    annotation (Dialog(group="Parameters provided on ATITA basis"));
  parameter SI.Mass mSec = 35 "Dry weight"                       annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Power Paux = 24
    "Electrical power of auxiliary on nominal power (out circulation pump)"
     annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Power Pveille = 5.2 "Standby power (out circulation pump)"
     annotation(Dialog(group = "Parameters provided on ATITA basis"));
  parameter SI.Power Pcirculateur = 37
    "Water circulation pump electrical power"
     annotation(Dialog(group = "Parameters provided on ATITA basis"));

  parameter Real DetaPLR = 1
    "Efficiency gap at Tint between PLRnom (Part Load Ratio) and PLRInt (between 0 and 2% depending on the machine)"
     annotation(Dialog(tab = "Other parameters",group="Performance"));
  parameter Real PLRmin = PLRInt "Minimum loading rate"
     annotation(Dialog(tab = "Other parameters",group="Performance"));
  parameter SI.Time TimePrePurge=30 "Pre-purge duration"
     annotation(Dialog(tab = "Other parameters",group="Performance"));
  parameter SI.Time TimeCycle(displayUnit="min")=300
    "Minimum duration of a cycle (anti-short cycle)"
     annotation(Dialog(tab = "Other parameters",group="Performance"));
  parameter SI.Time TimeCirculateur(displayUnit="min")=600
    "Operating time of the circulation pump after a combustion cycle"
     annotation(Dialog(tab = "Other parameters",group="Performance"));
  parameter SI.SpecificHeatCapacity CpE = 4180
    "Specific heat capacity of water"
     annotation(Dialog(tab = "Other parameters",group="Fluids properties"));
  parameter SI.Density rhoE = 1000 "Density of water"
     annotation(Dialog(tab = "Other parameters",group="Fluids properties"));
  parameter SI.VolumeFlowRate V_flowAir = 6.7E-3 * (Pnom/20000)
    "Pre-purge: nominal flow rate of air (nominal value from [Kemna 2007])"
     annotation(Dialog(tab = "Other parameters",group="Fluids properties"));
  parameter SI.SpecificHeatCapacity CpA = 1000 "Capacité thermique de l'air"
     annotation(Dialog(tab = "Other parameters",group="Fluids properties"));
  parameter SI.Density rhoA = 1.2 "Specific heat capacity of air"
     annotation(Dialog(tab = "Other parameters",group="Fluids properties"));

protected
  parameter SI.ThermalConductance UA=PertesT30K/30
    "Conduction through the envelope";
  parameter SI.Pressure Pref = 101300 "Reference pressure";
  parameter SI.Temperature Tref = 15 + 273.15 "Reference temperature";
  parameter Real lambda = 0.01
    "Offset variable of weighting coefficients sigmas";
  discrete SI.Time Time0(start=0) "Beginning of the boiler cycle";
  discrete SI.Time TimeF(start=0) "End of the boiler cycle";

public
  Real etaRP "Efficiency in steady state at T and operational PLR";
  SI.Power QaFournir "Thermal power to provide";
  Integer NbCycle(start=0);

protected
  SI.Temperature Tc
    "Temperature of Sensitive and Latent characteristic intersection";
  SI.Temperature Te=WaterIn[1]
    "Water-return temperature (i.e. water inlet temperature)";
  //EQUAL TO THE ENTRY PORT
  Real a1=(etaNom-100)/(Tnom-Tref)
    "Slope of the line characterizing the sensitive part";
  Real etaSens;
  Real etaCond30;
  Real etaCond;
  Real sigmaSens;
  Real sigmaCond;
  Real a;
  SI.MassFlowRate Debit
    "Water mass flow to the circulation pump, therefore in the boiler";

public
  Modelica.Blocks.Interfaces.RealInput PLR(min=0, max=100)
    "Part load ratio (0-100%)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor ConductanceEnv(G=UA)
    "Thermal resistance of the boiler casing"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,32})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a T_int
    "Ambient temperature of the place where the boiler is located" annotation (
      Placement(transformation(extent={{40,50},{60,70}}, rotation=0),
        iconTransformation(extent={{50,70},{70,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CpChau(
      C=500*mSec) "Boiler thermal capacity (dry weight)"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(
        extent={{-5.75,-5.75},{5.75,5.75}},
        rotation=0,
        origin={-14.25,-80.25})));
  Modelica.Blocks.Sources.RealExpression QaFournirExp(y=QaFournir)
    annotation (Placement(transformation(extent={{-62,-90},{-42,-70}})));
  Modelica.Blocks.Interfaces.RealOutput Pgaz
    "Thermal power provided by gas combustion"
    annotation (Placement(transformation(extent={{92,16},{112,36}}),
        iconTransformation(extent={{92,16},{112,36}})));
  Modelica.Blocks.Interfaces.RealOutput Pelec
    "Electrical power consumed (auxiliary ...)"
    annotation (Placement(transformation(extent={{92,40},{112,60}}),
        iconTransformation(extent={{92,-16},{112,4}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CpEau(C=CpE*rhoE*Veau)
    "Heat capacity of the water volume"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    annotation (Placement(transformation(
        extent={{-5.75,-5.75},{5.75,5.75}},
        rotation=0,
        origin={-34.25,-40.25})));
  Modelica.Blocks.Sources.RealExpression BilanEau(y=Debit*CpE*(WaterIn[1] -
        WaterOut[1]))
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression DebitExp(y=Debit)
    annotation (Placement(transformation(extent={{40,-40},{60,-24}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{46,-54},{60,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput SaisonChauffe annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-30,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,90})));

protected
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1
    annotation (Placement(transformation(extent={{2,2},{-2,-2}})));
public
  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperature (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-128,-60},{-88,-20}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1- the output fluid temperature (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{92,-50},{112,-30}}),
        iconTransformation(extent={{92,-50},{112,-30}})));
initial equation

algorithm
if SaisonChauffe then  //The boiler is launched for PLR > PLRmin
  //Determination of the efficiency for the law without condensation
  etaSens   :=etaNom + a1*(Te - Tnom);
  //Determination of the efficiency for the law characterizing the condensation
  etaCond30 :=etaInt + (100*PCSI - etaInt)*(1 - Psat(Te)/Psat(TInt)*TInt/Te);
  etaCond   :=etaCond30 - DetaPLR*(Tc - Te)/(Tc - TInt)*(PLR - PLRInt)/(PLRnom -
      PLRInt);
  //Determination of the efficiency in steady state
  sigmaSens :=1/(1 + exp(Tc - Te - lambda));
  sigmaCond :=1 - 1/(1 + exp(Tc - Te + lambda));
  etaRP     :=sigmaSens*etaSens + sigmaCond*etaCond;
  if PLR>PLRmin then
    if noEvent(time <= Time0+TimePrePurge) then
      a:=1;//Pre-purge
      Pelec:=Paux + Pcirculateur;
      QaFournir :=V_flowAir*rhoA*CpA*(15+273.15 - CpEau.port.T);//seems negligible, delete ??? YES based on parametric study, delete the entry T which is set at 15°C
        Pgaz
          :=0;

    else
      a:=2;//Combustion
      //It is considered that half of the nominal electric power depends on the fan which depends on the load rate (PLR)
      Pelec:=Paux*(0.5 + 0.5*PLR/100) + Pcirculateur;
      //Manufacturers data already integrate losses through the envelope so when running, the term corresponding to losses through the envelope is added
      QaFournir :=PInt + (PLR - PLRInt)/(PLRnom - PLRInt)*(Pnom - PInt) + abs(ConductanceEnv.Q_flow);
        Pgaz
          :=QaFournir*100/etaRP;//Efficiency (%)
    end if;
  else
    if noEvent(time <= Time0+TimePrePurge+TimeCycle) then
      a:=3; //Anti-short cycles at minimal power
      Pelec:=Paux*(0.5 + PLRmin/100) + Pcirculateur;
      QaFournir :=PInt + abs(ConductanceEnv.Q_flow);
        Pgaz
          :=QaFournir*100/etaRP;//Efficiency (%)
    elseif noEvent(time < max(TimeF,Time0+TimePrePurge+TimeCycle)+TimeCirculateur) then
        a:=4;//Burner off but circulator in operation
        Pelec:=Pveille + Pcirculateur;
        QaFournir:=0;
        Pgaz:=0;
    else
        a:=5;//Burner off and circulator cut off
        Pelec:=Pveille;
        QaFournir:=0;
        Pgaz:=0;
    end if;
  end if;
else
  a:=0;//Seasonal shutdown
  Pelec:=0;
  QaFournir:=0;
    Pgaz
      :=0;
end if;

equation
  Debit = if a < 1 or a > 4 then 0 else V_flow * rhoE;
  //Intersection point Tc determination
  etaNom+a1*(Tc-Tnom) = etaInt+(100*PCSI-etaInt)*(1-Psat(Tc)/Psat(TInt)*TInt/Tc);

  when PLR >= PLRmin then
    Time0 = time;
  end when;
  when PLR <= PLRmin then
    TimeF = time;
  end when;

  when Pgaz<0.1*PInt then
    NbCycle = pre(NbCycle) + 1;
  end when;

  connect(ConductanceEnv.port_a, T_int) annotation (Line(
      points={{1.83697e-015,42},{0,60},{50,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QaFournirExp.y, preHeaFlo.Q_flow)      annotation (Line(
      points={{-41,-80},{-20,-80},{-20,-80.25},{-20,-80.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(BilanEau.y, preHeaFlo1.Q_flow)         annotation (Line(
      points={{-59,-40},{-38,-40},{-38,-40.25},{-40,-40.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo1.port, CpEau.port)   annotation (Line(
      points={{-28.5,-40.25},{30,-40.25},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(CpEau.port, temperatureSensor.port)   annotation (Line(
      points={{30,0},{30,-47},{46,-47}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(ConductanceEnv.port_b, port_b1) annotation (Line(
      points={{-1.77636e-015,22},{0,22},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, CpEau.port) annotation (Line(
      points={{0,0},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, CpChau.port) annotation (Line(
      points={{0,0},{-30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHeaFlo.port, port_b1) annotation (Line(
      points={{-8.5,-80.25},{0,-80.25},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, WaterOut[1]) annotation (Line(
      points={{60,-47},{80,-47},{80,-45},{102,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DebitExp.y, WaterOut[2]) annotation (Line(
      points={{61,-32},{80,-32},{80,-35},{102,-35}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-32,96},{-8,86}},
          lineColor={0,0,127},
          textString="PLR"),
        Rectangle(
          extent={{-100,60},{100,-80}},
          lineColor={245,0,0},
          lineThickness=1,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{44,28},{90,18}},
          lineColor={0,0,255},
          textString="Gas consumption"),
        Text(
          extent={{40,-2},{90,-12}},
          lineColor={0,0,255},
          textString="Elec consumption"),
        Polygon(
          points={{-58,-86},{-58,-86},{-50,-76},{-42,-86},{-44,-94},{-48,-96},{-56,
              -94},{-58,-86},{-58,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-54,-90},{-54,-90},{-50,-82},{-44,-90},{-46,-94},{-48,-96},{-52,
              -94},{-54,-90},{-54,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{-38,-86},{-38,-86},{-30,-76},{-22,-86},{-24,-94},{-28,-96},{-36,
              -94},{-38,-86},{-38,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-34,-90},{-34,-90},{-30,-82},{-24,-90},{-26,-94},{-28,-96},{-32,
              -94},{-34,-90},{-34,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{-18,-86},{-18,-86},{-10,-76},{-2,-86},{-4,-94},{-8,-96},{-16,
              -94},{-18,-86},{-18,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-14,-90},{-14,-90},{-10,-82},{-4,-90},{-6,-94},{-8,-96},{-12,
              -94},{-14,-90},{-14,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{2,-86},{2,-86},{10,-76},{18,-86},{16,-94},{12,-96},{4,-94},{2,
              -86},{2,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{6,-90},{6,-90},{10,-82},{16,-90},{14,-94},{12,-96},{8,-94},{6,
              -90},{6,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{22,-86},{22,-86},{30,-76},{38,-86},{36,-94},{32,-96},{24,-94},
              {22,-86},{22,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{26,-90},{26,-90},{30,-82},{36,-90},{34,-94},{32,-96},{28,-94},
              {26,-90},{26,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{42,-86},{42,-86},{50,-76},{58,-86},{56,-94},{52,-96},{44,-94},
              {42,-86},{42,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{46,-90},{46,-90},{50,-82},{56,-90},{54,-94},{52,-96},{48,-94},
              {46,-90},{46,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{64,-86},{64,-86},{72,-76},{80,-86},{78,-94},{74,-96},{66,-94},
              {64,-86},{64,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{68,-90},{68,-90},{72,-82},{78,-90},{76,-94},{74,-96},{70,-94},
              {68,-90},{68,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Polygon(
          points={{-78,-86},{-78,-86},{-70,-76},{-62,-86},{-64,-94},{-68,-96},{-76,
              -94},{-78,-86},{-78,-86}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-74,-90},{-74,-90},{-70,-82},{-64,-90},{-66,-94},{-68,-96},{-72,
              -94},{-74,-90},{-74,-90}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          lineThickness=1),
        Rectangle(
          extent={{-82,-30},{-40,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Ellipse(
          extent={{78,-30},{90,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-86,-30},{-78,-50}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-30},{84,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-40,-30},{40,-50}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash),
        Polygon(
          points={{10,-20},{-2,16},{6,16},{-8,22},{-10,10},{-6,14},{6,
              -22},{10,-20}},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={12,-62},
          rotation=360),
        Text(
          extent={{-98,54},{-74,44}},
          lineColor={0,0,127},
          textString="Text")}),
defaultComponentName="boi",
Documentation(info="<html>
<p>It is a dynamic model of modulating condensing boiler.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The gas consumption prediction model is estimated with a grey box model. Electric consumption is determined according to the consumption of the various operation phases of the boiler (purging, pump, power on/off, standby, etc).</p>
<p>This model requires a limited amount of input data accessible from the normative tests.</p>
<p>Following a sensitivity analysis,</p>
<ul>
<li>The durations of anti-short cycles (abnormally rapid start and stop cycles), and especially the duration of the pump operation after combustion have a very significant impact on consumption and the number of machine cycles;</li>
<li>The parameter &Delta;&eta; (representing the decrease in performance depending on the load at a return of water temperature equal to 30°C) has nearly no effects on the results for the temperature levels of the water law in question (between 35 and 45°C). In the case of modelling a system requiring water temperatures higher than 35°C, the user can leave the default value, especially since this parameter is not provided in the ATITA basis;</li>
<li>Consideration of pre-combustion purge, during which the air in combustion chamber must be renewed, has also a reduced impact: over-consumption does not exceed 0.5&#37; and is more due to a 30 second delay before launching the boiler than to the thermal power lost in the smoke.</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>The model is configurable from certified data accessible in the ATITA basis (rt2012-chauffage.com).</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This is a detailed dynamic model. Some phenomena are represented in a simple way:</p>
<ul>
<li>Heat losses through the wall are fully transmitted to the environment (RT2012 gives the lost part coefficients -for example through the wall for a wall boiler)</li>
<li>The consumption of auxiliary is partially degraded in thermal form (e.g. via the conversion of the water kinetic energy in pipes into heat by friction for the power supplied to the pump), this energy conservation is not considered now</li>
</ul>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Sila Filfli 07/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
<p>Benoît Charrier 01/2016 : Passage du calcul du débit en equation pour compatibilité OpenModelica.</p>
</html>"),
    experiment(StopTime=5000, Interval=600),
    __Dymola_experimentSetupOutput);
end Boiler;
