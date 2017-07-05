within BuildSysPro.BoundaryConditions.Scenarios;
model ScenarioRT
  "Residential scenarios for the french building regulation 2012"

parameter Modelica.SIunits.Temp_C TconsChaud=19
    "Setpoint temperature in heating mode" annotation(Dialog( group="Heating and cooling setpoints"));
parameter Modelica.SIunits.Temp_C TconsChaudInf48Red=16
    "Setpoint temperature in heating mode for setback period shorter than 48h"
                                                                            annotation(Dialog( group="Heating and cooling setpoints"));
parameter Modelica.SIunits.Temp_C TconsChaudSup48Red=7
    "Setpoint temperature in heating mode for setback period longer than 48h"
                                                                            annotation(Dialog( group="Heating and cooling setpoints"));

parameter Modelica.SIunits.Temp_C TconsRef=28
    "Setpoint temperature in cooling mode" annotation(Dialog( group="Heating and cooling setpoints"));
parameter Modelica.SIunits.Temp_C TconsRefInf48Red=30
    "Setpoint temperature in cooling mode for setback period shorter than 48h"    annotation(Dialog( group="Heating and cooling setpoints"));
parameter Modelica.SIunits.Temp_C TconsRefSup48Red=30
    "Setpoint temperature in cooling mode for setback period longer than 48h"    annotation(Dialog( group="Heating and cooling setpoints"));
parameter Boolean UtilApportThOcc=false
    "Internal heat gains due to human occupancy"                                   annotation(Dialog( group="Optional internal heat loads"),choices(choice=true "YES", choice=false "NO", radioButtons=true));
parameter Boolean UtilApportThUsageSpe=false
    "Internal heat gains for specific uses"                             annotation(Dialog( group="Optional internal heat loads"),choices(choice=true "YES", choice=false "NO", radioButtons=true));
parameter Boolean UtilApportThEclairage=false
    "Internal heat gains due to lighting"                                           annotation(Dialog( group="Optional internal heat loads"),choices(choice=true "YES", choice=false "NO", radioButtons=true));

parameter Real Nadeq=1 "[NADEQ] Number of \"equivalent\" adult" annotation(Dialog(tab="Occupants"));
parameter Real caloOccupant=90
    "[W/NADEQ] Average heat load for an \"equivalent\" adult"
                                                        annotation(Dialog(tab="Occupancy",enable=UtilApportThOcc));
parameter Real humiOccupant=0.055
    "[kg/h/NADEQ] Humidity released by an \"equivalent\" adult"                               annotation(Dialog(tab="Occupancy"));

parameter Real consoECShebdo=0
    "[L/week/NADEQ] Number of liters of water at 40°C consumed per week and per Nadeq. 0 in the RT, for a realistic value use 455 L/week/Nadeq"
                                                                                             annotation(Dialog(tab="Others",group="DHW"));
                                                                                             parameter Real unite1=0
    "ex: Room surface area"                                                                                                     annotation(Dialog(tab="Others",group="Lighting",enable=UtilApportThEclairage or UtilApportThUsageSpe));
parameter Real caloEclairage=2
    "[W/unite1] Heat gains by the lighting per unit (ex. living space)"                                 annotation(Dialog(tab="Others",group="Lighting",enable=UtilApportThEclairage));

parameter Real caloUsageSpe=5.7
    "[W/unite1] Heat gains out of occupancy and lighting, per unit (ex. living space)" annotation(Dialog(tab="Others",group="Specific uses",enable=UtilApportThUsageSpe));

parameter Real unite2=0
    "ex: Considered room surface area or number of showers or beds..."                   annotation(Dialog(tab="Others",group="Specific uses"));
parameter Real HumiUsageSpe=0
    "[kg/h/unite2] Moisture production out of occupancy and lighting, per unit" annotation(Dialog(tab="Others",group="Specific uses"));

parameter BuildSysPro.Utilities.Types.FileNameIn pth=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ScenarioRT2012.txt")
    "Chemin d'acces au fichier des scénarios (contient les 2 tables voir Scenarios.StepFunctionMat)";

//Output connectors related to control
Modelica.Blocks.Interfaces.RealOutput Presence "Presence 1 / Absence 0"
  annotation (Placement(transformation(extent={{82,82},{118,118}},
        rotation=0), iconTransformation(extent={{80,-130},{100,-110}})));
Modelica.Blocks.Interfaces.RealOutput ComRefChauffage
    "Control for heating and cooling (1 = active, 0 setback period shorter than 48h, and -1 setback period longer than 48h)"
  annotation (Placement(transformation(extent={{82,42},{118,78}},
        rotation=0), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,80})));

Modelica.Blocks.Interfaces.RealOutput TconsigneChaud
    "Heating setpoint temperature [K]"
  annotation (Placement(transformation(extent={{82,12},{118,48}},
        rotation=0), iconTransformation(extent={{80,30},{100,50}})));
Modelica.Blocks.Interfaces.RealOutput TconsigneRef
    "Cooling setpoint temperature [K]"
  annotation (Placement(transformation(extent={{82,-18},{118,18}},
        rotation=0), iconTransformation(extent={{80,-10},{100,10}})));
Modelica.Blocks.Interfaces.RealOutput ComVenti
    "Ventilation setpoint (1=operation, 0=stop or minimum value)"
  annotation (Placement(transformation(extent={{82,-48},{118,-12}},
        rotation=0), iconTransformation(extent={{80,-50},{100,-30}})));
Modelica.Blocks.Interfaces.RealOutput ComEclairage
    "Lighting setpoint (1=operation, 0= stop or minimum value)"
  annotation (Placement(transformation(extent={{82,-78},{118,-42}},
        rotation=0), iconTransformation(extent={{80,-90},{100,-70}})));

Modelica.Blocks.Interfaces.RealOutput DebitECS
    "Hot water volume flow rate at 40°C [L/h]"
  annotation (Placement(transformation(extent={{82,-108},{118,-72}},
        rotation=0), iconTransformation(extent={{80,150},{100,170}})));
Modelica.Blocks.Interfaces.RealOutput ConsoECS
    "Hot water consumption at 40°C [L]"
  annotation (Placement(transformation(extent={{82,-138},{118,-102}},
        rotation=0), iconTransformation(extent={{80,110},{100,130}})));

// Output connectors associated to various loads
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a ApportsThOccupants if
    UtilApportThOcc "Heat gains from occupancy [W]"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a ApportsThUsageSpe if
    UtilApportThUsageSpe
    "Heat gains from specific uses [W] (out of occupancy and lihghting)"
    annotation (Placement(transformation(extent={{-10,180},{10,200}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a ApportsThEclairage if
    UtilApportThEclairage "Heat gains from lighting [W]"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));

Modelica.Blocks.Interfaces.RealOutput ApportsHuOccupants
    "Moisture gains from occupancy [kg steam/s]"
  annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=90,
        origin={-40,200}),
                     iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,190})));
Modelica.Blocks.Interfaces.RealOutput ApportHuUsageSpe
    "Moisture gains from specific uses [kg steam/s] (out of occupancy and lighting)"
  annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=90,
        origin={40,200}),
                     iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,190})));

//Data table
// Inner components
protected
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if
    UtilApportThOcc annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,160})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 if
    UtilApportThUsageSpe annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,166})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 if
    UtilApportThEclairage annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,156})));
  Modelica.Blocks.Sources.Constant Tchaud1(k=
        Modelica.SIunits.Conversions.from_degC(TconsChaud))
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,104})));
  Modelica.Blocks.Sources.Constant Tchaud3(k=
        Modelica.SIunits.Conversions.from_degC(TconsChaudSup48Red))
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,44})));
  Modelica.Blocks.Sources.Constant Tchaud2(k=
        Modelica.SIunits.Conversions.from_degC(TconsChaudInf48Red))
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,74})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-144,46},{-124,66}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Blocks.Sources.Constant TRef1(k=
        Modelica.SIunits.Conversions.from_degC(TconsRef))
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-174,10})));
  Modelica.Blocks.Sources.Constant TRef2(k=
        Modelica.SIunits.Conversions.from_degC(TconsRefInf48Red))
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,-20})));
  Modelica.Blocks.Sources.Constant TRef3(k=
        Modelica.SIunits.Conversions.from_degC(TconsRefSup48Red))
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,-50})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{-84,-4},{-64,16}})));
  Modelica.Blocks.Logical.Switch switch4
    annotation (Placement(transformation(extent={{-138,-48},{-118,-28}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=1e-6)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,102})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=-1 +
        1e-6)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,62})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold=1e-6)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-74,34})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold3(threshold=-1 +
        1e-6)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-74,-22})));
  Modelica.Blocks.Math.Gain gain(k=Nadeq*consoECShebdo)
    annotation (Placement(transformation(extent={{38,-100},{60,-78}})));
  Modelica.Blocks.Math.Gain gain1(k=Nadeq*caloOccupant) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-69,133})));

  Modelica.Blocks.Math.Gain gain2(k=Nadeq*humiOccupant/3600)
                                                        annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-39,149})));
  Modelica.Blocks.Math.Gain gain3(k=caloUsageSpe*unite1) annotation (Placement(
        transformation(
        extent={{-13,-13},{13,13}},
        rotation=90,
        origin={1,133})));
  Modelica.Blocks.Math.Gain gain4(k=unite2*HumiUsageSpe/3600)
                                                         annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={39,151})));

  Modelica.Blocks.Math.Gain gain5(k=caloEclairage*unite1)
                                                         annotation (Placement(
        transformation(
        extent={{-13,-13},{13,13}},
        rotation=90,
        origin={69,125})));

  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold4(threshold=1e-6)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-60})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-58,-64},{-38,-44}})));

  StepFunctionMat fctEscalierMat(
    tableOnFile1=true,
    tableOnFile2=true,
    tableName1="data1",
    tableName2="data2",
    columns2={2,3,4,5,6,7,8},
    fileName1=pth,
    fileName2=pth)
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=mod(time, 31536000))
    annotation (Placement(transformation(extent={{-196,-98},{-176,-78}})));

public
Modelica.Blocks.Interfaces.RealOutput Usages
  annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=90,
        origin={-134,198}),
                     iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,190})));
Modelica.Blocks.Interfaces.RealOutput Eclairage
  annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=90,
        origin={-158,198}),
                     iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-126,190})));
equation
  connect(Tchaud2.y, switch1.u1) annotation (Line(
      points={{-161,74},{-156,74},{-156,64},{-146,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tchaud3.y, switch1.u3) annotation (Line(
      points={{-161,44},{-154,44},{-154,48},{-146,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, switch2.u3) annotation (Line(
      points={{-123,56},{-118,56},{-118,72},{-112,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tchaud1.y, switch2.u1) annotation (Line(
      points={{-161,104},{-136,104},{-136,88},{-112,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch4.y, switch3.u3) annotation (Line(
      points={{-117,-38},{-104,-38},{-104,-2},{-86,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRef3.y, switch4.u3) annotation (Line(
      points={{-161,-50},{-150,-50},{-150,-46},{-140,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRef2.y, switch4.u1) annotation (Line(
      points={{-161,-20},{-150,-20},{-150,-30},{-140,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRef1.y, switch3.u1) annotation (Line(
      points={{-163,10},{-126,10},{-126,14},{-86,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold.y, switch2.u2) annotation (Line(
      points={{-81,102},{-132,102},{-132,80},{-112,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greaterThreshold1.y, switch1.u2) annotation (Line(
      points={{-81,62},{-150,62},{-150,56},{-146,56}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greaterThreshold3.y, switch4.u2) annotation (Line(
      points={{-85,-22},{-148,-22},{-148,-38},{-140,-38}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greaterThreshold2.y, switch3.u2) annotation (Line(
      points={{-85,34},{-86,34},{-86,6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch2.y, TconsigneChaud) annotation (Line(
      points={{-89,80},{-2,80},{-2,30},{100,30}},
      color={170,255,85},
      smooth=Smooth.None,
      thickness=0.5));
  connect(switch3.y, TconsigneRef) annotation (Line(
      points={{-63,6},{14,6},{14,0},{100,0}},
      color={0,128,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(gain.y, DebitECS)   annotation (Line(
      points={{61.1,-89},{59.55,-89},{59.55,-90},{100,-90}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(gain1.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-69,140.7},{-69,145.35},{-68.6,145.35},{-68.6,151}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, ApportsThOccupants)
                                                      annotation (Line(
      points={{-68.6,171},{-68.6,178.5},{-70,178.5},{-70,190}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  connect(gain2.y,ApportsHuOccupants)  annotation (Line(
      points={{-39,156.7},{-39,173.35},{-40,173.35},{-40,200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain2.u, gain1.u) annotation (Line(
      points={{-39,140.6},{-38.5,140.6},{-38.5,124.6},{-69,124.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold3.u, greaterThreshold2.u) annotation (Line(
      points={{-62,-22},{-62,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold2.u, greaterThreshold1.u) annotation (Line(
      points={{-62,34},{-60,34},{-60,62},{-58,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold1.u, greaterThreshold.u) annotation (Line(
      points={{-58,62},{-58,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port,ApportsThUsageSpe)  annotation (Line(
      points={{1.4,177},{1.4,176.5},{0,176.5},{0,190}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gain4.y,ApportHuUsageSpe)  annotation (Line(
      points={{39,158.7},{39,171.35},{40,171.35},{40,200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain5.y, prescribedHeatFlow2.Q_flow) annotation (Line(
      points={{69,139.3},{69,142.65},{69.4,142.65},{69.4,147}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(prescribedHeatFlow2.port, ApportsThEclairage) annotation (Line(
      points={{69.4,167},{69.4,176.5},{70,176.5},{70,190}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(booleanToReal.u, greaterThreshold4.y) annotation (Line(
      points={{-60,-54},{-60,-60},{-63,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanToReal.y, Presence)   annotation (Line(
      points={{-37,-54},{-12,-54},{-12,100},{100,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, fctEscalierMat.u) annotation (Line(
      points={{-175,-88},{-158,-88},{-158,-90},{-142,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold4.u, fctEscalierMat.y[5]) annotation (Line(
      points={{-86,-60},{-86,-89.7143},{-119,-89.7143}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[5], gain1.u) annotation (Line(
      points={{-119,-89.7143},{-69,-89.7143},{-69,124.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[7], gain4.u) annotation (Line(
      points={{-119,-89.1429},{-24,-89.1429},{-24,110},{39,110},{39,142.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[3], ComEclairage) annotation (Line(
      points={{-119,-90.2857},{-24,-90.2857},{-24,-60},{100,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[1], ComRefChauffage) annotation (Line(
      points={{-119,-90.8571},{-24,-90.8571},{-24,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[6], gain3.u) annotation (Line(
      points={{-119,-89.4286},{-24,-89.4286},{-24,110},{1,110},{1,117.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[2], ComVenti) annotation (Line(
      points={{-119,-90.5714},{-24,-90.5714},{-24,-30},{100,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[1], greaterThreshold3.u) annotation (Line(
      points={{-119,-90.8571},{-24,-90.8571},{-24,-22},{-62,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fctEscalierMat.y[4], gain.u) annotation (Line(
      points={{-119,-90},{-23.6,-90},{-23.6,-89},{35.8,-89}},
      color={0,0,127},
      smooth=Smooth.None));
der(ConsoECS)=DebitECS/3600;
  connect(gain5.u, fctEscalierMat.y[3]) annotation (Line(
      points={{69,109.4},{-24,109.4},{-24,-90.2857},{-119,-90.2857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain3.y, prescribedHeatFlow1.Q_flow) annotation (Line(
      points={{1,147.3},{1,151.65},{1.4,151.65},{1.4,157}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Eclairage, gain5.y) annotation (Line(
      points={{-158,198},{-158,139.3},{69,139.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Usages, gain3.y) annotation (Line(
      points={{-134,198},{-132,198},{-132,152},{1,152},{1,147.3}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,
            -120},{100,200}})),     Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-120},{100,200}}), graphics={
        Text(
          extent={{-184,-30},{76,-84}},
          lineColor={0,0,0},
          textString="French Building 
Regulation 2012"),
        Rectangle(
          extent={{-160,132},{-74,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,182}),
        Rectangle(
          extent={{-74,132},{-68,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,211,206},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,132},{18,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,182}),
        Text(
          extent={{-66,64},{16,62}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,211,206},
          fillPattern=FillPattern.Solid,
          textString="..........."),
        Text(
          extent={{-160,52},{-78,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,211,206},
          fillPattern=FillPattern.Solid,
          textString="..........."),
        Polygon(
          points={{18,12},{12,-2},{16,-6},{18,-6},{18,12}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-200,200},{100,-120}},
          lineColor={0,0,0},
          radius=5)}),
    Documentation(info="<html>
<p><i><b>Provisional french building regulation scenarios (RT 2012) 9th version [CSTB]</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Hourly scenarios on a full year of the RT2012. The following scenarios are included in this model:</p>
<ul>
<li>occupant (heat inputs, vapors and presence 0/1)</li>
<li>specific uses of electricity (thermal and vapor inputs)</li>
<li>domestic hot water needs (debit and consumption)</li>
<li>lighting</li>
<li>ventilation</li>
<li>heating and cooling</li>
</ul>
<p>The data being discrete and with an hourly time step, the interpolation is performed by a step function (see the block <a href=\"BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat\"><code>BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat</code></a>).</p>
<p>The model uses simulation time <i>modulo</i> 1 year (31536000s = 3600 * 8760). Therefore if the simulation is run several years, the scenario is repeated.</p>
<p><u><b>Bibliography</b></u></p>
<p>Version 9 of the 2012 French Building Regulation scenarios.</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model reads a data file, containing the two tables below.</p>
<p>Table 1 :</p>
<p><table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Time [s]</p></td>
<td><p>Hours</p></td>
</tr>
</table></p>
<p>Table 2 :</p>
<p><table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Hours</p></td>
<td><p>Control for heating and cooling</p><p>1 = active</p><p>0 = setback period shorter than 48h</p><p>-1 = setback period longer than 48</p></td>
<td><p>Ventilation setpoint</p><p>1 = operation</p><p>0 = stop or minimum value</p></td>
<td><p>Lighting setpoint</p><p>1 = operation</p><p>0 = stop or minimum value</p></td>
<td><p>Hot water consumption [&#37;]</p><p>Part of hot water consumed each hour</p><p>Reference period (100&#37;) is a week</p><p>Reference volume set by <code>consoECShebdo</code></p></td>
<td><p>Occupancy rate</p><p>1 = presence</p><p>0 = absence</p><p>Possible modulation between 0 and 1 (ex : sleeping period)</p></td>
<td><p>Internal gains by specific uses</p><p>1 = presence</p><p>0 = absence</p><p>Possible modulation between 0 and 1</p></td>
<td><p>Water vapour generation out of occupancy and lighting</p><p>1 = presence</p><p>0 = absence</p><p>Possible modulation between 0 and 1</p></td>
</tr>
</table></p>
<p>Scenarios describing the occupancy and specific uses provide &quot;physical&quot; information (superior ports of the model). The heat loads can be directly connected to an air node, and vapors inputs are in [kg steam/sec]. These are expressed through a RealOutput connector (causal modelling) and will then be adapted to the connectors selected for the multi-physics modelling.</p>
<p>The use of thermal ports is conditioned by the Booleans (<code>UtilApportThOcc, UtilApportThUsageSpe, UtilApportThEclairage</code>). In situations where these ports are not used but the Booleans are set to TRUE, the following error occurs:</p>
<p><i><span style=\"color: #ff0000;\">Error: Singular inconsistent scalar system for scenarioRT.ApportsThOccupants.T = (scenarioRT.prescribedHeatFlow.Q_flow*(1-scenarioRT.prescribedHeatFlow.alpha*scenarioRT.prescribedHeatFlow.T_ref))/( -scenarioRT.prescribedHeatFlow.Q_flow*scenarioRT.prescribedHeatFlow.alpha) = .../-0</span></i></p>
<p>To fix the problem change the value of concerned booleans.</p>
<p>Right ports of the model correspond to &quot;controls&quot;. They can be connected to models such as ventilation, hot water, lighting, heating and cooling or comfort analysis.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model but based on RT 2012 provisional scenarios - Gilles Plessis 02/2011 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2010 - 2015<br>
BuildSysPro version 3.0.0<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Gilles Plessis Février 2011: Le modèle devra être mis à jour notamment au niveau des valeurs de:</p>
<ul>
<li><i>consoECS </i>(valeur estimée et non règlementaire),</li>
<li><i>unite1</i>,</li>
<li><i>unite2,</i></li>
<li><i>HumiUsageSpe</i>.</li>
</ul>
<p>Une mise à jour des ports pour apports humides (vapeur d'eau) devra aussi être envisagée.</p>
<p>Gilles Plessis Février2012: </p>
<ul>
<li>Correction d'un bug dû à la non utilisation des ports thermiques. Ils sont désormais optionels.</li>
<li><font style=\"color: #ff0000; \">Les températures sont désormais exprimées enn Kelvin au lieu de degré Celsius, comme pour les blocs météo.</font></li>
<li>Modification du type du paramètre pth de <i>String</i> à <i>Filename</i> permettant l'utilisation d'une fenêtre pour atteindre le fichier de données.</li>
</ul>
<p>Gilles Plessis Juin2012</p>
<ul>
<li>Ajout du connecteur <i>Presence</i> en sortie. C'est un réel (<i>RealOutput</i>) égal à 1 lorsque le bâtiment est occupé et 0 lorsque le bâtiment est vide.</li>
<li>Une partie des composants jugés non utiles aux simulations ont été migrés en internes (protected)</li>
</ul>
<p><br>Gilles Plessis 10/2012 : gain4 divisé par 3600 </p>
<p>Gilles Plessis 11/2012 :</p>
<ul>
<li>l'interpolation est maintenant réalisée par des fonctions en escalier,</li>
<li>le nombre d'adultes équivalents est modifiable y compris lorsque l'on n'utilise pas de les apports thermiques humains,</li>
<li>le scénario peut être utilisé pour une simulation de plusieurs année. Il y a dans ce cas une répétition du scénario,</li>
<li>ajout de sorties pour le débit et la consommation d'ECS. Suppression de l'ancienne sortie BesoinsECS,</li>
<li>le paramètre <i>pth, </i>chemin d'accès au fichier de scénario, est conservé. Cependant le fichier de scénario doit contenir les 2 tables <i>data1 </i>et <i>data2.</i><b> Dans le cas de scénarios personnels mettre à jour les scénarios pour le respect de ces consignes</b>. Voir aussi l'utilisation du bloc Utilitaires.Scenario.FctEscalierMat,</li>
<li>modification du nom du paramètre consoECS en consoECShebdo.</li>
</ul>
<p><br>Sila Filfli 04/2013 :</p>
<ul>
<li>Ajout des ports pour les apports (usages spécifiques, éclairage, ...)</li>
</ul>
<p>Gilles Plessis 05/2013 : Modification de la valeur par défaut de la consommation hebdomadaire d'ECS de 50 L à 0L correspondant à la valeur RT. Pour information, la valeur de 455L/semaine/personne est recommandée.</p>
<p>Gilles Plessis 09/2015 : Utilisation de la fonction <code>Modelica.Utilities.Files.loadResource</code> pour le chargement de fichiers, pour une meilleure compatibilité avec le standard Modelica.</p>
<p>Benoît Charrier 01/2016 : Passage des valeurs de seuil des blocs <code>GreaterThreshold</code> à <code>x+1e-6</code> pour contourner le mauvais comportement sous OpenModelica de ce type de bloc.</p>
</html>"));
end ScenarioRT;
