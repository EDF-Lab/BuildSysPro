within BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed;
model HPHeatingAir2Water
  "Intermittently controlled air to water HP - heating mode only"

  parameter Integer Choix=1
    annotation(Dialog(group="Choice of parameterization method"), choices(
                choice=1 "Default: an operating point of 7°C/35°C",
                choice=2 "Expert: 3 operating points"));

// Parameterization based on the HP default template : Choice 1
  parameter Modelica.SIunits.Power Qnom=6490
    "Nominal heating power in Enom temperature conditions"
    annotation (Dialog(enable=(Choix==1), group="Parameterization choice 1"));
  parameter Real COPnom=4.3
    "Nominal coefficient of performance in Enom temperature conditions"
    annotation (Dialog(enable=(Choix==1), group="Paramétrisation choix 1"));

// Expert parameterization : Choice 2
  parameter Real Enom[4] = {2,45,1800,4950}
    "Nominal manufacturer data: {Text(°C), ToutputHP(°C), Electric power consumed (W), Supplied heat (W)}"
    annotation (Dialog(enable=(Choix==2), group="Parameterization choice 2"));
  parameter Real E1[4] = {-15,55,1980,2480}
    "Manufacturer data: {Text(°C), ToutputHP(°C), Electric power consumed (W), Supplied heat (W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));
  parameter Real E2[4] = {20,25,1690,7750}
    "Manufacturer data: {Text(°C), ToutputHP(°C), Electric power consumed (W), Supplied heat (W)}"
    annotation (Dialog(enable=(Choix==2), group="Paramétrisation choix 2"));

// Other parameters common to the different choices
  parameter Modelica.SIunits.MassFlowRate MegRat=0.1
    "Nominal water flow inside"    annotation (Dialog(group="Other parameters"));
  parameter Modelica.SIunits.Power QfanextRat=0
    "Outdoor fan power, if QfanextRat included in Qa then choose 0"
    annotation (Dialog(group="Other parameters"));
  parameter Real Cdegi=0.9
    "Degradation coefficient due to icing: 10% of the defrosting time below 2°C"
    annotation (Dialog(group="Other parameters"));
  parameter Modelica.SIunits.Time TauOn=120
    "Switch-on time constant [GAR 2002]"
    annotation (Dialog(group="Other parameters"));
  parameter Real alpha=0.01
    "Percentage of standby power (Eco Design Draft report of Task 4: 1, 2 or 3% according to Henderson2000 work)"
    annotation (Dialog(group="Other parameters"));
  parameter Modelica.SIunits.Time dtminOn=360 "Minimum operating time"
    annotation (Dialog(group="Other parameters"));
  parameter Modelica.SIunits.Time dtminOff=360
    "Minimum stop time before restarting"
    annotation (Dialog(group="Other parameters"));

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
  Modelica.SIunits.Power QcRat "Nominal heating output power";
  Modelica.SIunits.Power QaRatC
    "Nominal compressor power demand in heating mode";
  Modelica.SIunits.Temperature TextRatC
    "Outdoor air nominal temperature in heating mode";
  Modelica.SIunits.Temperature TintRatC
    "Nominal temperature of air at the indoor unit output in heating mode";
  Modelica.SIunits.Power Qcflssdegi "Without defrosting";
  Modelica.SIunits.Power Qcfl
    "Heating power supplied at full load at no-nominal temperature";
  Modelica.SIunits.Power Qafl
    "Nominal compressor power demand at full load at no-nominal temperature";
  Real Dt;

  Boolean w;
  Modelica.SIunits.Time tOn;
  Modelica.SIunits.Time dtOn;
  Modelica.SIunits.Time tOff;
  Modelica.SIunits.Time dtOff;
  Modelica.SIunits.SpecificHeatCapacity CpLiq=4180;

public
  Modelica.Blocks.Interfaces.RealOutput Qfour "Supplied heating power (W)"
    annotation (Placement(transformation(extent={{60,-26},{94,8}}),
        iconTransformation(extent={{90,20},{110,40}})));

  Modelica.Blocks.Interfaces.RealInput T_ext "Outdoor temperature (K)"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Interfaces.RealOutput Qelec "Consumed electric power (W)"
    annotation (Placement(transformation(extent={{60,12},{94,46}}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,60})));

  Modelica.Blocks.Interfaces.BooleanInput u(start=false)
    "Value of proportional band on setpoint temperature"
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
  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperarture (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}}),
        iconTransformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1- the output fluid temperarture (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-70},{120,-30}}),
        iconTransformation(extent={{92,-50},{112,-30}})));

equation
// Machine performance according to the parameterization method selected by the user
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
    Qcflssdegi =QcRat*(1 + D1*(T_ext - TextRatC) + D2*(WaterIn[1] - TintRatC));

// Defrost losses when Text < 2°C
  if (T_ext > 275.15) then
      Qcfl = Qcflssdegi;
    else
      Qcfl = Cdegi*Qcflssdegi;
    end if;

// Calculate non-dimensionnal temperature difference
    Dt =T_ext/WaterIn[1] - TextRatC/TintRatC;
// Calculate consumed energy rates at full load for no-rating conditions
    Qafl = Qcflssdegi*(QaRatC/QcRat)*(1 + C1*Dt + C2*Dt*Dt);

// Two minimum time periods protect the machine
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
    //About consumed electric power, the athors agree that there is no time constant
    //on consumed power, and that its value is the same in dynamic and steady states [Goldsmith 80], [Henderson 96], [O'Neal 91].
    //This hypothesis was confirmed by different experimentations [Rasmussen 87], [Miller 85] and [Garde 97a]. from [Garde2001]
if SaisonChauffe then
    Qelec=if v then Qafl+QfanextRat else alpha*QaRatC;
    //The power supplied is determined by a dynamic with one time constant.
    Qfour = if v then Qcfl*(1-exp(-dtOn/TauOn)) else 0;
    WaterOut[2] = if v then MegRat else 1E-10;
    WaterOut[1] = if v then WaterIn[1] + Qfour/(MegRat*CpLiq) else WaterIn[1];
else
    Qfour = 0;
    Qelec =0;
    WaterOut[2] = 1E-10;
    WaterOut[1] = WaterIn[1];
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
          textString="air to water HP
all-or-none, variable"),
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
<p><b>Air/water heat pump with fixed speed compressor - polynomial model adapted to variable time step</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is an air/water heat pump with on/off (intermittently controlled) operation (fixed speed) for the heating mode only.</p>
<p>The model is minimalist in terms of parameters to inform and is based on an empirical approach to determining the power in steady state according to indoor and outdoor temperatures conditions. The transitional regime is modelled using a time constant for the power supplied.</p>
<p>The start regulation is determined by the input Boolean \"u\" : TRUE the HP must be in operation and FALSE the HP must be stopped.</p>
<p>The HP operates in all or nothing. Start and stop phases are given by the associated control system. To protect the machine, it is common that minimum on and off times are defined (DtminOn and DtminOff), they intervene in internal control of the machine.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Two parameter choices are possible:</p>
<ol>
<li>Indication of nominal power and COP (warning, a too large a gap of these values with those by default could result in unreliable modelling of a real machine)</li>
<li>Indication of 3 operating points, the empirical model approach requires three operating points which delimit the model temperature range</li>
</ol>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>For empirical approach, pay special attention to the choice of operating temperatures range.</p>
<p>Degradation related to icing/de-icing is rather grossly given without dynamic (10&percnt; degradation of the power supplied for outside temperatures below 2&deg;C).</p>
<p>Not suitable for variable speed.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model according to air/air HP with TIL - Hubert Blervaque, Sila Filfli 02/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>"));
end HPHeatingAir2Water;
