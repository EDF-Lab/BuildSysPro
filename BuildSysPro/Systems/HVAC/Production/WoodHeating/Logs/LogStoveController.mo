within BuildSysPro.Systems.HVAC.Production.WoodHeating.Logs;
block LogStoveController

  Modelica.Blocks.Interfaces.RealInput m_b "Actual mass of wood in the stove"
    annotation (Placement(transformation(extent={{-110,-50},{-70,-10}}),
        iconTransformation(extent={{-96,-42},{-70,-16}})));
  Modelica.Blocks.Interfaces.RealInput Tconsigne "Temperature wanted"
    annotation (Placement(transformation(extent={{-110,6},{-70,46}}),
        iconTransformation(extent={{-96,8},{-70,34}})));
  Modelica.Blocks.Interfaces.RealOutput tim_start "Starting combustion time"
    annotation (Placement(transformation(extent={{72,-50},{92,-30}}),
        iconTransformation(extent={{72,-50},{92,-30}})));

parameter Real dT_seuil_N=1 "temperature gap to use the stove at a normal rate";
parameter Real dT_seuil_R=0.7 "temperature gap to use the stove at lower rate";
                                                       // this is only used when the user leaves the house
parameter Real dt_charg=0
    "in forced going mode: set the time gap between the end of combustion and the start of a new one";

//-------------------------------------------------------------------------------
  Modelica.Blocks.Interfaces.RealOutput allure "Combustion rate"
    annotation (Placement(transformation(extent={{72,16},{92,36}}),
        iconTransformation(extent={{72,16},{92,36}})));

  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
    annotation (Placement(transformation(extent={{-110,56},{-70,96}}),
        iconTransformation(extent={{-96,56},{-70,82}})));
  Modelica.Blocks.Interfaces.BooleanInput marche_forcee
    "Indicates if \"forced going\" mode is activated"   annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-4,80}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={-9,83})));
  Modelica.Blocks.Interfaces.RealInput Tsens "Temperature of the room"
    annotation (Placement(transformation(extent={{-108,-88},{-68,-48}}),
        iconTransformation(extent={{-96,-80},{-70,-54}})));
equation

if presence then
  allure = 0.3;
  if marche_forcee then
    if m_b<0.1 then
      tim_start = time + dt_charg;
    else
      tim_start = tim_start;
    end if;
  else
    if m_b<0.1 and Tsens<=Tconsigne-dT_seuil_N then
      tim_start = time;
    else
      tim_start = tim_start;
    end if;
  end if;
else
  allure = 0.1;
  if pre(presence)==true and Tsens<=Tconsigne-dT_seuil_R and m_b<0.1 then
    tim_start=time;
  else
    tim_start=tim_start;
  end if;
end if;

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-66,76},{58,-78}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-52,58},{44,8}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-2,8},{-36,38}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{-6,48},{-6,40}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{6,48},{6,40}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{18,48},{18,40}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{28,44},{28,36}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{-16,46},{-16,38}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{-30,44},{-30,36}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{-38,40},{-38,32}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Text(
          extent={{-56,-12},{38,-58}},
          lineColor={0,0,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="Reg.")}),
    DymolaStoredErrors,
    Documentation(info="<html>
<p>PB50 LOG STOVE's REGULATOR</p>
<p>Regulation system(representative for exemple of successive manual loads of logs) of a stove</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The model connects to the stove without regulatuion </p>
<p>This model's purpose is to be part of the PB50 model</p>
<p>Tthe control is done according to the informations given by the user</p>
<p>The user can decide to use a &quot;forced going&quot; mode when he's in the house</p>
<p>The two outputs are the time of the start phase and the combustion rate</p>
<p><u><b>Bibliography</b></u></p>
<p>detailled model is the note :H-E14-2011-01955-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EIFER 09/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end LogStoveController;
