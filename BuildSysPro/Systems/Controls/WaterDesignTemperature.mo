within BuildSysPro.Systems.Controls;
model WaterDesignTemperature

  parameter Boolean RegTOR = true "On/Off control ?";
  parameter Real table[:,2]=[-20, 60; -7, 52; 0, 43; 7, 37; 20, 20]
    "Table of water design curve : exterior temperature (°C) in 1st row and system output temperature (°C) in 2nd row";

  parameter Modelica.Units.SI.TemperatureDifference THyst=1
    "Upper and lower tolerance compared with the setpoint"
    annotation (Dialog(enable=RegTOR));

  Modelica.Blocks.Interfaces.RealInput T_ext "Exterior temperature (°K)"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput u if RegTOR "Heatpump On/Off"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,-100}),iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-62})));
  Modelica.Blocks.Interfaces.RealInput RetourDEau[2] if RegTOR
    "Point of the hydraulic network which should respect the water design curve" annotation (
      Placement(transformation(extent={{-120,-60},{-80,-20}}),
        iconTransformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput T_sp "Setpoint temperature (°K)"
    annotation (Placement(transformation(extent={{96,-10},{116,10}}),
        iconTransformation(extent={{96,-10},{116,10}})));
protected
  Modelica.Blocks.Tables.CombiTable1Dv LoiDEau(table=table)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.UnitConversions.To_degC to_degC
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.UnitConversions.From_degC
                                         Tcons "Converting temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  if RetourDEau[1] > (T_sp + THyst) then
    u = false;
  elseif RetourDEau[1] < (T_sp - THyst) then
    u = true;
  else
    u = pre(u);
  end if;

  connect(T_ext, to_degC.u) annotation (Line(
      points={{-100,0},{-62,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC.y, LoiDEau.u[1]) annotation (Line(
      points={{-39,0},{-22,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(LoiDEau.y[1], Tcons.u) annotation (Line(
      points={{1,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tcons.y, T_sp) annotation (Line(
      points={{41,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={Rectangle(
          extent={{-92,60},{94,-60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,10},{94,-10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Water design")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>On/Off control model for a heat generator, according to the hydraulic circuit temperature.</p>
<p>The number of points of the water design curve has to be chosen based on the need (system output water temperature depending on exterior temperature, 3 temperature points minimum).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Sila Filfli 02/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",
    revisions="<html>
<p>Hubert Blervaque 09/2013 : Ajout d'une option permetttant d'utilier la régulation tout-ou-rien, sinon les connecteurs associés sont occultés.</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>"));
end WaterDesignTemperature;
