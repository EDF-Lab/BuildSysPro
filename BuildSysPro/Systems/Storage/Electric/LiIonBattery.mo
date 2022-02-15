within BuildSysPro.Systems.Storage.Electric;
model LiIonBattery "Lithium-Ion Battery"

public
  parameter Real R_c=0.97 "Coulomb efficiency" annotation (choicesAllMatching=
        true, Dialog(
      compact=true,
      group="Pertes du système"));
      parameter Real R_charge=0.9 "Charge efficiency"
                                                     annotation (choicesAllMatching=
        true, Dialog(
      compact=true,
      group="Pertes du système"));
parameter Real R_decharge=0.9 "Discharge efficiency"
                                                    annotation (choicesAllMatching=
        true, Dialog(
      compact=true,
      group="Pertes du système"));
parameter Real C0=30 "No-load consumption of BMS and converters (W)"
                                                                    annotation (choicesAllMatching=
        true, Dialog(
      compact=true,
      group="Pertes du système"));
parameter Real Pdecharge=0.9 "Allowable discharge depth"
                                                        annotation (choicesAllMatching=
        true, Dialog(
      compact=true,
      group="Caractéristiques de la batterie"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericBattery
    technoBattOnd "Chice of battery inverter couple" annotation (
      choicesAllMatching=true, Dialog(compact=true, group=
          "Caractéristiques de la batterie"));
//auxiliary variables
  Real R_charge_variable(start=1) " Charge efficiency with a power adjustment ";
  Real R_decharge_variable(start=1) " Discharge efficiency with a power adjustment ";
public
  Modelica.Blocks.Interfaces.RealOutput Pcmax
    "Maximum power available for storage (W)"
    annotation (Placement(transformation(extent={{84,-26},{108,-2}}),
        iconTransformation(extent={{100,-12},{120,8}})));

  Modelica.Blocks.Interfaces.RealOutput P
    "Power given by the battery (W)"
    annotation (Placement(transformation(extent={{84,-6},{108,18}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealInput P_consigne "Setpoint power (W)"
    annotation (Placement(transformation(extent={{-112,-14},{-84,14}}),
        iconTransformation(extent={{-108,-14},{-86,8}})));
  Modelica.Blocks.Interfaces.RealOutput Pdmax
    "Maximum power available for destocking (W)"
    annotation (Placement(transformation(extent={{84,-48},{108,-24}}),
        iconTransformation(extent={{100,-36},{120,-16}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "SOC of battery"
    annotation (Placement(transformation(extent={{86,22},{110,46}}),
        iconTransformation(extent={{100,34},{120,54}})));

Real P_vide(start=0) "Power consumed by the converters and the BSM";
equation

Pcmax=min(technoBattOnd.Pmaxc,technoBattOnd.P_onduleur);
Pdmax=min(technoBattOnd.Pmaxd,technoBattOnd.P_onduleur);
 R_charge_variable = if P_consigne < 0
                      then max(0.1, 0.98*0.95*(1 - exp(P_consigne/59)))
                      else 1;
  R_decharge_variable = if P_consigne < 0
                      then 1
                      else max(0.1, 0.98*0.95*(1 - exp(-P_consigne/61)));
if P_consigne < 0 then
  if (SOC/3600)<(Pdecharge*technoBattOnd.Cmax) then
    P = min(-R_charge*P_consigne,Pcmax);
    P_vide = C0;
  else
      P=0;
      P_vide = 0;
  end if;
else
  if (SOC/3600)>((1-Pdecharge)*technoBattOnd.Cmax) then
      P = -min(R_decharge*R_c*P_consigne,Pdmax);
      P_vide = C0;
  else
      P = 0;
      P_vide =0;
  end if;
end if;
  der(SOC)= (R_charge_variable/R_decharge_variable)*P - P_vide;

   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-98,46},{90,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Polygon(
          points={{-98,46},{90,46},{110,66},{-78,66},{-98,46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Polygon(
          points={{90,46},{110,66},{110,-42},{90,-56},{90,46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Backward),
        Ellipse(
          extent={{-60,60},{-44,52}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,60},{-4,52}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,60},{32,52}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,60},{74,52}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-38,-12},{80,-62}},
          lineColor={255,255,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Backward,
          textString="Batterie Li-ion"),
        Text(
          extent={{-150,38},{-102,-8}},
          lineColor={0,0,0},
          textString="Pconsigne"),
        Text(
          extent={{120,66},{148,38}},
          lineColor={0,0,0},
          textString="SOC"),
        Text(
          extent={{116,38},{132,20}},
          lineColor={0,0,0},
          textString="P"),
        Text(
          extent={{120,24},{154,-12}},
          lineColor={0,0,0},
          textString="Pcmax"),
        Text(
          extent={{120,0},{154,-36}},
          lineColor={0,0,0},
          textString="Pdmax")}),
          Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The model is composed of a Li-ion battery + converters + inverter system.</p>
<p>It takes into account the static losses, the charging and discharging efficiencies and the ,no-load consumption of the converters and the BSM.</p>
<p>The currents are limited by the charge and discharge currents admitted by the battery and by the power of the inverter.</p>
<p>By default, the maximum charge and discharge currents are taken equal to Cmax and 2Cmax respectively (Saft type battery).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The input setpoint power must be negative if you want to store it, positive if we want to destock. </p>
<p>The output power of the battery correponds to the stored power if it is positive, destocked otherwise.</p>
<p><u><b>Validations</b></u></p>
<p>Not validated model - Laura Sudries 02/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Laura SUDRIES, Julien LHERMENAULT, Vincent MAGNAUDEIX, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end LiIonBattery;
