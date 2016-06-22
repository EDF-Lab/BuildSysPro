within BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed;
model HPHeatingAir2Air
  "Intermittently controlled air to air HP - heating mode only"

  parameter Integer Choix=1
    annotation(Dialog(group="Choice of parameterization method"), choices(
                choice=1 "Default: an operating point of 7°C/20°C",
                choice=2 "Expert: 3 operating points"));

// Parameterization based on the HP default template : Choice 1
  parameter Modelica.SIunits.Power Qnom=1380.87
    "Nominal heating power in Enom temperature conditions"
    annotation (Dialog(enable=(Choix==1), group="Parameterization choice 1"));
  parameter Real COPnom=4.18468
    "Nominal coefficient of performance in Enom temperature conditions"
    annotation (Dialog(enable=(Choix==1), group="Parameterization choice 1"));

// Expert parameterization : Choice 2
  parameter Real Enom[4] = {7,20,329.982,1380.87}
    "Nominal manufacturer data: {Text(°C), ToutputHP(°C), Electric power consumed (W), Supplied heat (W)}"
    annotation (Dialog(enable=(Choix==2), group="Parameterization choice 2"));
  parameter Real E1[4] = {-7,23,260.174,921.479}
    "Manufacturer data: {Text(°C), ToutputHP(°C), Electric power consumed (W), Supplied heat (W)}"
    annotation (Dialog(enable=(Choix==2), group="Parameterization choice 2"));
  parameter Real E2[4] = {14,17,365.383,1690.44}
    "Manufacturer data: {Text(°C), ToutputHP(°C), Electric power consumed (W), Supplied heat (W)}"
    annotation (Dialog(enable=(Choix==2), group="Parameterization choice 2"));

// Other parameters common to the different choices
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

  Real COPt "HP coefficient of performance at time t";
  Boolean v;

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
  Modelica.SIunits.Temperature TextRatC = if Choix==1 then 280.15 else Enom[1]+273.15
    "Nominal temperature of outside air in heating mode";
  Modelica.SIunits.Temperature TintRatC = if Choix==1 then 293.15 else Enom[2]+273.15
    "ominal temperature of air at the indoor unit output in heating mode";
  Modelica.SIunits.Power Qcflssdegi "Without defrosting";
  Modelica.SIunits.Power Qcfl
    "Heating power supplied at full load at no nominal temperature";
  Modelica.SIunits.Power Qafl
    "Nominal compressor power demand at full load at no-nominal temperature";
  Real Dt;
  Boolean w;
  Modelica.SIunits.Time tOn;
  Modelica.SIunits.Time dtOn;
  Modelica.SIunits.Time tOff;
  Modelica.SIunits.Time dtOff;

public
  Modelica.Blocks.Interfaces.RealOutput Qfour "Supplied heating power (W)"
    annotation (Placement(transformation(extent={{60,-26},{94,8}}),
        iconTransformation(extent={{84,-20},{124,20}})));

  Modelica.Blocks.Interfaces.RealInput Text "Outdoor air temperature (K)"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput Tint "Indoor air temperature (K)"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
        iconTransformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Qelec "Consumed electric power (W)"
    annotation (Placement(transformation(extent={{60,12},{94,46}}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-98})));

  Modelica.Blocks.Interfaces.BooleanInput u
    "Value of proportional band on setpoint temperature"
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100}),iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,90})));

  Modelica.Blocks.Interfaces.BooleanInput SaisonChauffe annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-22,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-58,92})));
equation
// Machine performance according to the parameterization method selected by the user
  if Choix==1 then
    QcRat=Qnom;
    QaRatC=Qnom/COPnom;
    C1 = -2.94982;
    C2 =  4.16648;
    D1 =  0.0154996;
    D2 = -0.0385624;
  else
    QcRat=Enom[4];
    QaRatC=Enom[3];
    D2=((E1[1]-Enom[1])*(E2[2]-Enom[2]))/(((E1[1]-Enom[1])*(E2[2]-Enom[2])-(E2[1]-Enom[1])*(E1[2]-Enom[2]))*(E2[2]-Enom[2]))*(E2[4]/Enom[4]-1-(E2[1]-Enom[1])/(E1[1]-Enom[1])*(E1[4]/Enom[4]-1));
    D1=(E1[4]/Enom[4]-1-D2*(E1[2]-Enom[2]))/(E1[1]-Enom[1]);
    C2=((E2[3]/E2[4])/(Enom[3]/Enom[4])-1-Dt2/Dt1*((E1[3]/E1[4])/(Enom[3]/Enom[4])-1))/(Dt2*Dt2-Dt1*Dt2);
    C1=((E1[3]/E1[4])/(Enom[3]/Enom[4])-1-C2*Dt1*Dt1)/Dt1;
  end if;

// Calculate required energy rates at full load for no-rating conditions
    Qcflssdegi = QcRat*(1 + D1*(Text - TextRatC) + D2*(Tint - TintRatC));

// Defrost losses when Text < 2°C
    if (Text > 275.15) then
      Qcfl = Qcflssdegi;
    else
      Qcfl = Cdegi*Qcflssdegi;
    end if;

// Calculate non-dimensionnal temperature difference
    Dt = Text/Tint - TextRatC/TintRatC;
// Calculate consumed energy rates at full load for no-rating conditions
    Qafl = Qcflssdegi*(QaRatC/QcRat)*(1 + C1*Dt + C2*Dt*Dt);

// Two minimum time periods protect the machin
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
    //The power delivered is determined by a dynamic with one time constant
    Qfour=if v then Qcfl*(1-exp(-dtOn/TauOn)) else 0;
    COPt=Qfour/Qelec;

else  Qfour = 0;
      Qelec =0;
      COPt = 0;
end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),                       Icon(coordinateSystem(
          preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                                                     graphics={Rectangle(
          extent={{-96,96},{96,-96}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          textString="air to air HP
all-or-none, variable"),
        Text(
          extent={{6,84},{62,68}},
          lineColor={0,0,0},
          textString="& Dtmin")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is an air/air heat pump with on/off (intermittently controlled) operation (fixed speed) for the heating mode only.</p>
<p>The model is minimalist in terms of parameters to inform and is based on an empirical approach to determining the power in steady state according to indoor and outdoor temperatures conditions. The transitional regime is modelled using a time constant for the power supplied.</p>
<p>The HP operates in all or nothing. Start and stop phases are given by the associated control system. To protect the machine, it is common that minimum on and off times are defined (DtminOn and DtminOff), they intervene in internal control of the machine.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Four parameter choices are possible: <b>WARNING!</b> Be sure to replace the default setting options that are not used because they may be used to simulate the default configuration</p>
<ol>
<li>Indication of nominal heating capacity (COP default of about 4.2), HP performances are adapted to the nominal power defined by the user</li>
<li>Indication of nominal power and COP (warning, a too large a gap of these values with those by default could result in unreliable modelling of a real machine)</li>
<li>Indication of 3 operating points, the empirical model approach requires three operating points which delimit the model temperature range</li>
<li>Indication of the nominal point and the regression coeff, this expert parameterization allows to define the C1, C2, D1 and D2 coefficients by a method external to the model (finer regression on more operating points for example)</li>
</ol>
<p>Although the need to ensure the replacement of default values to use the default configuration, it is possible for advanced users to modify the HP performance curve using the mode 3 or 4, then go in mode 1 or 2 to modulate the HP power from performances defined above.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>For empirical approach, pay special attention to the choice of operating temperatures range.</p>
<p>Degradation related to icing/de-icing is rather grossly given without dynamic (10&percnt; degradation of the power supplied for outside temperatures below 2&deg;C).</p>
<p>Not suitable for variable speed.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model with TIL - Hubert Blervaque, Sila Filfli 05/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Hubert Blervaque - novembre 2013 : MAJ de la description des paramètres</p>
</html>"));
end HPHeatingAir2Air;
