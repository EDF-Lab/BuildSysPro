within BuildSysPro.Systems.DHW.HeatPump.Components;
model WaterHeaterHeatPumpController
  "Simple Hysteresis control with Time of Use switch and Auto mode"

  parameter Modelica.Units.SI.Temperature T_set=55 + 273.15
    "HPWH setpoint temperature";
  parameter Boolean activateTOU=false
    "Activate time of use prioritization" annotation(choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Boolean HP_only=false
    "HP only mode (no auxiliary back up)" annotation(choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Boolean manualOnOff=false "Activate external manual on/off signal" annotation(choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Modelica.Units.SI.Temperature T_set_low=45 + 273.15
    "HPWH setpoint temperature outside TOU period"
    annotation (Dialog(enable=(activateTOU)));
  parameter Modelica.Units.SI.TemperatureDifference delta_T=10
    "Temperature hysteresis";

  parameter Modelica.Units.SI.Temperature T_min_HP=273.15 - 5
    "Minimal HPWH operating condition";

  parameter Real compSpeed=50 "Compressor operating speed";
  final parameter Real compIddleSpeed=20.0;

  Modelica.Units.SI.Temperature T_set_cold(start=55 + 273.15)
    "HP setpoint temperature at low external air temperatures";

  Boolean minHP(start=false)
    "HP operating region for the heat pump";

  Modelica.Blocks.Interfaces.RealOutput freq(start=50,fixed=true)
    "Freqeuncy output"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}}),
        iconTransformation(extent={{150,-130},{170,-110}})));

  Modelica.Blocks.Interfaces.BooleanOutput OnOff "System on off signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-42,-200}),
                        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-190})));

  Modelica.Blocks.Interfaces.RealInput T_water "Water temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-168,52}),iconTransformation(extent={{-164,94},{-144,114}})));

// protected
  Boolean Hyst(start=true,fixed=true) "Hysteresis signal";
  Boolean HystAux(start=true,fixed=true) "Hysteresis signal";
  // Time of use variables
  Boolean TOU( start=true,fixed=true) "Time of use tarif signal";
  Real initTime(start=0,fixed=true);
  Integer day(start=1,fixed=true);

public
  Modelica.Blocks.Interfaces.RealInput T_air "External air temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-166,-108}),iconTransformation(extent={{-166,-108},{-146,-88}})));

  Modelica.Blocks.Interfaces.BooleanOutput OnOffAuxiliary
    "Auxiliary on off control"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={36,-200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={48,-188})));
  Modelica.Blocks.Interfaces.BooleanInput onOffSwitch if manualOnOff
    "External on off switch"                                                   annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-46,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={2,152})));

protected
  Modelica.Blocks.Interfaces.BooleanInput onOffSwitch_internal;

initial equation

  pre(OnOff)=true;

equation
  connect(onOffSwitch, onOffSwitch_internal);
  if not manualOnOff then
    onOffSwitch_internal=false;
  end if;
  day= (integer(floor(mod(time, 3.1536e7)/86400 + 1)));

//   Mode AUTO
  if T_air<-2+273.15  and not HP_only then
    T_set_cold=45+273.15;
  elseif T_air>=-2+273.15 and T_air<2+273.15  and not HP_only then
    T_set_cold=50+273.15;
  else
    T_set_cold=T_set;
  end if;

  freq= if OnOff then compSpeed else compIddleSpeed;

  TOU=if (time-initTime)<=21600 or (time-initTime)>=79200 then true else false;

  if activateTOU and not TOU then
    Hyst=if T_water<T_set_low-delta_T then true else (if T_water>=T_set_low then false else pre(Hyst));
    HystAux=if T_water<T_set_low-delta_T then true else (if T_water>=T_set_low then false else pre(HystAux));
  else
    Hyst=if T_water<T_set_cold-delta_T then true else (if T_water>=T_set_cold then false else pre(Hyst));
    HystAux=if T_water<T_set-delta_T then true else (if T_water>=T_set then false else pre(HystAux));
  end if;

  OnOffAuxiliary=(not Hyst and HystAux) or (not minHP and Hyst);

  minHP=T_air>=T_min_HP and (T_water<=T_set_cold);
  OnOff=if not manualOnOff then (Hyst and minHP) else (onOffSwitch_internal and Hyst);

  when day<>pre(day) then
    initTime= time;
  end when;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -180},{150,150}}), graphics={
        Rectangle(
          extent={{-150,150},{150,-180}},
          lineColor={0,0,255},
          lineThickness=0.5)}),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-150,-180},{150,150}}), graphics={
        Rectangle(
          extent={{-150,150},{150,-180}},
          lineColor={0,0,255},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,140},{138,-168}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,74},{108,-82}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Control")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>For detailed documentation, see <a href=\"BuildSysPro.Systems.DHW.HeatPump.Components.WaterHeaterHeatPumpPoly\"><code>WaterHeaterHeatPumpPoly</code></a> model.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Kévin Deutz 08/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Kévin DEUTZ, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WaterHeaterHeatPumpController;
