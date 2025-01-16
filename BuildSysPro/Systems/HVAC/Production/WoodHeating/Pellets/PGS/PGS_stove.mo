within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.PGS;
model PGS_stove

  import      Modelica.Units.SI;

// TIMES
parameter SI.Time dt_sta1=360 " Duration of first part of start sequence ";   //0.1 hr in trnsys
parameter SI.Time dt_sta2=216 " Duration of second part of start sequence ";  // 0.06 hr in trnsys
parameter SI.Time dt_fanstp=241.2 " Time of fan operation during stop phase "; // 0.067 hr in trnsys
parameter SI.Time tcglow=298.8 " Time constant for after glow phase ";   // 0.083 hr in trnsys
SI.Time t_sta(start=0) " Simulation time when the stove turns on ";
SI.Time t_sta1(start=0)
    " Simulation time at the end of the first part of the start phase ";
SI.Time t_sta2(start=0)
    " Simulation time at the end of the second part of the start phase ";
SI.Time t_stp(start=0) " Simulation time when the stove turns off ";
SI.Time t_fanstp(start=0) " Duration of fan operation after stop ";

// TEMPERATURES (as reals to avoid conversion issues)
SI.Temperature Tg2(start=273.15+40) " Flue gas temperature ";
SI.Temperature Toutd " Outdoor temperature ";
SI.Temperature Tg0(start=273.15+40)
    " Temperature of combustion gas before meeting m1 ";
SI.Temperature Tg1(start=273.15+40)
    " Temperature of combustion gas before meeting m2 ";
SI.Temperature Tm1(start=273.15+40)
    " Temperature of mass1 (connected to ambiant air) ";
SI.Temperature Tm2(start=273.15+40)
    " Temperature of mass2 (connected to heat exchanger) ";
SI.Temperature Tlqi " Temperature of liquid entering heat exchanger ";
SI.Temperature Tlqo(start=273.15+40)
    " Temperature of liquid out of heat exchanger ";

// MASSES
parameter SI.MassFlowRate mfg50=5
    " Flue gas leak flow at (Texh-Toutdoor)=50 C ";
parameter SI.MassFlowRate mfgfanstp=65
    " Mass flow of flue gas during fan op after stp ";
parameter SI.MassFlowRate mflq=96
    " Mass flow of liquid entering heat exchanger ";
SI.MassFlowRate mfa " Combustion air mass flow ";
SI.MassFlowRate mff " Fuel mass flow ";
SI.MassFlowRate mfg " Flue gas leak flow ";

// HEAT CAPACITIES
parameter SI.HeatCapacity mcpm1=65 " Thermal mass of mass 1 ";
parameter SI.HeatCapacity mcpm2=35 " Thermal mass of mass 2 ";
parameter SI.SpecificHeatCapacity Cpliq=1.02 " Liquid specific heat ";
SI.SpecificHeatCapacity Cpg " Average flue gas specific heat ";

// MISCELANEOUS
parameter Real Hf=18000 " Lower heating value of fuel ";
parameter Real Af=5.57
    " Theoretical air to fuel mass flow ratio at stoechiometric combustion ";
parameter Real lbd0=3.59 " Air factor, constant ";
parameter Real lbd1=0.036 " Air factor, slope ";
Integer Opph(start=0) " Operation phase during timestep ";  // helpful to debug
Real O2dry " Dry quantity of O2 ";
Boolean Bsta " Boolean indicator for temperature below minimum wanted ";
Boolean Bstp " Boolean indicator for temperature ahead maximum wanted ";
Boolean GO " Boolean control for start phase";
Boolean STOP " Boolean control for stop phase";

// THERMAL CONDUCTANCES
SI.ThermalConductance UAgm1 " Actual UA value between gas and m1 ";
parameter SI.ThermalConductance UAgm10=9.19
    " UA value between gas and m1 at ?=0 ";
parameter SI.ThermalConductance UAgm11=18.4
    " UA value between gas and m1, slope ";
SI.ThermalConductance UAgm2 " Actual UA value between gas and m2 ";
parameter SI.ThermalConductance UAgm20=28.1
    " UA value between gas and m2 at ?=0 ";
parameter SI.ThermalConductance UAgm21=56.2
    " UA value between gas and m2, slope ";
SI.ThermalConductance UAma " Actual UA value between m1 and ambient air ";
parameter SI.ThermalConductance UAma0=3.68
    " UA value between m1 and ambient air at ?=0 ";
parameter SI.ThermalConductance UAma1=0.96
    " UA value between m1 and ambient air, slope ";
SI.ThermalConductance UAmm " Actual UA value between m1 and m2 ";
parameter SI.ThermalConductance UAmm0=1.1 " UA value between m1 and m2 at ?=0 ";
parameter SI.ThermalConductance UAmm1=0.1 " UA value between m1 and m2, slope ";
SI.ThermalConductance UAmliq " Actual UA value between m2 and liquid ";
parameter SI.ThermalConductance UAmlq0=200
    " UA value between m2 and liquid at ?=0 ";
parameter SI.ThermalConductance UAmlq1=180
    " UA value between m2 and liquid, slope ";

// POWERS
parameter SI.Power Pcmb_sta=3333
    " Combustion power during 2nd part of start phase ";
parameter SI.Power Pmax=6578 " Maximum power of the PGS stove ";
parameter SI.Power Pe0=33 " Electrical power consumption at gamma=0 ";
parameter SI.Power Pel_1=8.88 " Electrical power consumption, slope ";
parameter SI.Power Pel_sta=330 " Electric power at start phase part 1 ";
SI.Power Pcmb(start=0) " puissance de combustion ";
SI.Power Pel(start=0) " puissance électrique consommée ";
SI.Power Pgm1(start=0) " Power from combustion gas to m1 ";
SI.Power Pgm2(start=0) " Power from combustion gas to m2 ";
SI.Power Pliq(start=0) " Power to liquid through heat exchanger ";
SI.Power Pamb(start=0) " Power to ambient air in room ";
SI.Power Pm1m2(start=0) " Power from m1 to m2 ";
SI.Power Pg(start=0) " Power to exhaust gas ";
SI.Power Pcmbstp " Mean of Pcmb over the last minutes (as defined below) ";

// Pcmbstp CALCULATION
parameter SI.Frequency f=1/120
    " frequency for mean calculation: here it is 50 seconds ";
protected
  discrete SI.Time t0 "Start time of simulation";
  Real x(start=0) "Integrator state";

//------------------------------------------------------------------------------------
public
  Modelica.Blocks.Interfaces.RealInput g "fraction of max power"
    annotation (Placement(transformation(extent={{-120,10},{-80,50}}),
        iconTransformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput Ton
    "Min temperature before stove starts [K]"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,100})));
  Modelica.Blocks.Interfaces.RealInput Toff
    "Max temperature before stove stops [K]"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={30,100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,100})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tsens
    "Heat port connected to the room"
    annotation (Placement(transformation(extent={{-104,-64},{-76,-36}}),
        iconTransformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Ton_conv
    annotation (Placement(transformation(extent={{-28,66},{-20,74}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Toff_conv
    annotation (Placement(transformation(extent={{40,64},{50,74}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b PowerOut
    "Power transmitted to the room"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}}),
        iconTransformation(extent={{-100,60},{-80,80}})));

equation
  Toutd=Tsens.T+5;
  Tlqi=Tsens.T;
  Tsens.Q_flow=0;

//---------------------------------------------
// Boolean definition for stove control

  if Tsens.T<=Ton_conv.port.T then
    Bsta=true;
  else
    Bsta=false;
  end if;

  if Tsens.T>=Toff_conv.port.T then
    Bstp=true;
  else
    Bstp=false;
  end if;

  if Bsta==true and pre(Bsta)==false and presence==true then
    GO=true;
  elseif Bsta==true and pre(presence)==false and presence==true then
    GO=true;
  else
    GO=false;
  end if;

  if Bstp==true and pre(Bstp)==false and presence==true then
    STOP=true;
  elseif pre(presence)==true and presence==false then
    STOP=true;
  else
    STOP=false;
  end if;

//---------------------------------------------
// Time constants

if GO==true then
    t_sta=time;
    t_sta1=time+dt_sta1;
    t_sta2=time+dt_sta1+dt_sta2;
    t_stp=time+999999;
    t_fanstp=time+999999;
elseif STOP==true then
    t_sta=0;
    t_sta1=0;
    t_sta2=0;
    t_stp=time;
    t_fanstp=time+dt_fanstp;
else
    t_sta=t_sta;
    t_sta1=t_sta1;
    t_sta2=t_sta2;
    t_stp=t_stp;
    t_fanstp=t_fanstp;
end if;

//---------------------------------------------
// Definition of Pcmb, m_f, dm_a, and Pel according to the actual combustion's step

if time<t_sta then
  Opph=0;
  Pcmb=0;
  mff=0;
  if Tg2>Toutd then
    mfa=mfg50*sqrt(abs(Tg2-Toutd)/50);
  else
    mfa=0;
  end if;
  Pel=0;
elseif t_sta<=time and time<t_sta1 then
  Opph=1;
  Pcmb=0;
  mff=0;
  mfa=mfgfanstp;
  Pel=Pel_sta;
elseif t_sta1<=time and time<t_sta2 then
  Opph=2;
  Pcmb=Pcmb_sta;
  mff=Pcmb/Hf;
  mfa=mff*Af*(lbd0+lbd1*Pcmb/Pmax);
  Pel=Pe0+g*Pel_1;
elseif t_sta2<=time and time<t_stp then
  Opph=3;
  Pcmb=g*Pmax;
  mff=Pcmb/Hf;
  mfa=mff*Af*(lbd0+lbd1*Pcmb/Pmax);
  Pel=Pe0+g*Pel_1;
elseif t_stp<=time and time<t_fanstp then
  Opph=4;
  Pcmb=Pcmbstp*exp(-(time-t_stp)/tcglow);
  mff=Pcmb/Hf;
  mfa=mfgfanstp;
  Pel=Pe0+Pel_1*mfgfanstp/((Pmax/Hf)*Af*(lbd0+lbd1));
else
  Opph=5;
  Pcmb=Pcmbstp*exp(-(time-t_stp)/tcglow);
  mff=Pcmb/Hf;
  if Tg2>Toutd then
    mfa=mfg50*sqrt(abs(Tg2-Toutd)/50);
  else
    mfa=0;
  end if;
  Pel=Pe0;
end if;

//---------------------------------------------
// Definition of O2dry

if abs(mff)<=0 or abs(mfa)<=0 then
  O2dry=0.21;
else
  O2dry=0.21*(mfa-mff*Af)/(mfa+0.02);
end if;

//---------------------------------------------
// Definition of parameters and UA values

mfg=mff+mfa;
UAgm1 = UAgm10+g*UAgm11;
UAgm2 = UAgm20+g*UAgm21;
UAma  = UAma0 +g*UAma1;
UAmliq= UAmlq0+g*UAmlq1;
UAmm  = UAmm0 +g*UAmm1;

Cpg=1.046661+0.00016844*Tg2-0.168154*O2dry-0.00054628*Tg2*O2dry;

Pgm1=Cpg*mfg*(Tg0-Tg1);
Pgm2=Cpg*mfg*(Tg1-Tg2);
Pliq=Cpliq*mflq*(Tlqo-Tlqi);
Pamb=UAma*(Tm1-Tsens.T);
Pm1m2=UAmm*(Tm1-Tm2);
Pg=Pcmb+Pel-Pgm1-Pgm2;

if mfg<=0 then
  Tg0=Tsens.T;
else
  Tg0=Tsens.T+(Pcmb+Pel)/((mfg+0.02)*Cpg);
end if;

Tg1=Tg0+(Tm1-Tg0)*exp(-mfg*Cpg/UAgm1);
Tg2=Tg1+(Tm2-Tg1)*exp(-mfg*Cpg/UAgm2);
Tlqo=Tlqi+(Tm2-Tlqi)*exp(-mflq*Cpliq/UAmliq);
der(Tm1)=(Pgm1-Pamb-Pm1m2)/mcpm1;
der(Tm2)=(Pgm2-Pliq+Pm1m2)/mcpm2;

//---------------------------------------------
// Output parameters definition
PowerOut.Q_flow=-(Pamb+Pliq);

//---------------------------------------------
// Calculation of Pcmb mean value over the last 50 seconds to know Pcmbstp
when initial() then
  t0=time;
end when;
der(x)=Pcmb;
when sample(t0+1/f,1/f) then
  Pcmbstp=f*x;
  reinit(x,0);
end when;

  connect(Ton, Ton_conv.T) annotation (Line(
      points={{-40,100},{-40,70},{-28.8,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Toff, Toff_conv.T) annotation (Line(
      points={{30,100},{30,69},{39,69}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-68,80},{72,-86}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,62},{64,-46}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-16,-16},{-44,30},{-18,20},{-16,22},{-6,58},{14,32},{34,46},{
              30,-10},{-16,-16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-8,-16},{-24,14},{-10,14},{-2,44},{14,22},{28,34},{24,-12},{-8,
              -16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,179,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-16},{-10,2},{4,0},{2,20},{10,-2},{10,0},{20,14},{14,-14},{
              0,-16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-56},{-46,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-62,74},{66,74}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-62,76},{66,76}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-62,72},{66,72}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-62,70},{66,70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-62,68},{66,68}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-62,66},{66,66}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,-50},{68,-50}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,-48},{68,-48}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,-52},{68,-52}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,-56},{-52,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,-56},{-40,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-36,-56},{-34,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-30,-56},{-28,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,-56},{-22,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-18,-56},{-16,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,-56},{-10,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,-56},{-4,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,-56},{2,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{6,-56},{8,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{12,-56},{14,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{18,-56},{20,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,-56},{26,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{30,-56},{32,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{36,-56},{38,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{42,-56},{44,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{48,-56},{50,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{54,-56},{56,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{60,-56},{62,-80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{42,-20},{28,-28},{20,-26},{34,-20},{42,-20}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{42,-20},{42,-22},{28,-30},{20,-28},{20,-26},{28,-28},{42,-20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{52,-10},{38,-18},{30,-16},{44,-10},{52,-10}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{52,-10},{52,-12},{38,-20},{30,-18},{30,-16},{38,-18},{52,-10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{42,-6},{28,-14},{20,-12},{34,-6},{42,-6}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{42,-6},{42,-8},{28,-16},{20,-14},{20,-12},{28,-14},{42,-6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{30,-16},{16,-24},{8,-22},{22,-16},{30,-16}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{30,-16},{30,-18},{16,-26},{8,-24},{8,-22},{16,-24},{30,-16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={31,-13},
          rotation=270),
        Polygon(
          points={{12,-22},{-2,-30},{-10,-28},{4,-22},{12,-22}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{12,-22},{12,-24},{-2,-32},{-10,-30},{-10,-28},{-2,-30},{12,-22}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{14,-14},{0,-22},{-8,-20},{6,-14},{14,-14}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{14,-14},{14,-16},{0,-24},{-8,-22},{-8,-20},{0,-22},{14,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{-10,-12},{-24,-20},{-32,-18},{-18,-12},{-10,-12}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-10,-12},{-10,-14},{-24,-22},{-32,-20},{-32,-18},{-24,-20},{-10,
              -12}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{-8,-22},{-8,-24},{-22,-32},{-30,-30},{-30,-28},{-22,-30},{-8,
              -22}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{18,-14},{4,-22},{-4,-20},{10,-14},{18,-14}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{18,-14},{18,-16},{4,-24},{-4,-22},{-4,-20},{4,-22},{18,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={-21,-21},
          rotation=270),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={-5,-17},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-5,-16},
          rotation=90),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={19,-23},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={19,-22},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-21,-20},
          rotation=270),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={31,-12},
          rotation=270),
        Polygon(
          points={{-8,-22},{-22,-30},{-30,-28},{-16,-22},{-8,-22}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>PGS PELLET STOVE</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The purpose of this model is to be part of the PGS model</p>
<p>The pellet stove described below works according to the model developped by the &quot;Solar Energy Research Center&quot; work the &quot;TRNSys model for Type 210 - Pellet stove with heat liquid exchanger&quot;</p>
<p>The only output used on this very model is the power delivered to the room (PowerOut.Q_flow)</p>
<p>Here the combustion's steps are delimited by time parameters, and within each step experimental values are used.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EIFER 08/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EIFER  (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>H. Blervaque 09/2013 :Repositionnement des ic&ocirc;nes des variables d'entrées/sorties</p>
</html>"));
end PGS_stove;
