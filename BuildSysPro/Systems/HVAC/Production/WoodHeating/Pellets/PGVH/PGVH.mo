within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.PGVH;
model PGVH

  Modelica.Blocks.Interfaces.RealInput T_consigne
    "Temperature wanted in the room"
    annotation (Placement(transformation(extent={{-104,10},{-64,50}}),
        iconTransformation(extent={{-92,10},{-62,40}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{28,32},{38,42}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{18,10},{28,20}})));
  Modelica.Blocks.Sources.Constant dT_T_off(k=1.2)
    "Value of temperature difference before stove stops"
    annotation (Placement(transformation(extent={{8,32},{14,38}})));
  Modelica.Blocks.Sources.Constant dT_T_on(k=-0.5)
    "Value of temperature difference before stove starts"
    annotation (Placement(transformation(extent={{-2,8},{4,14}})));
  Modelica.Blocks.Interfaces.BooleanInput fixed_power
    "Indicates if the \"fixed power\" mode is on"      annotation (Placement(
        transformation(
        extent={{-24,-24},{24,24}},
        rotation=270,
        origin={20,80}), iconTransformation(
        extent={{-15,-15},{15,15}},
        rotation=270,
        origin={53,81})));
  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
                                                   annotation (Placement(
        transformation(
        extent={{-24,-24},{24,24}},
        rotation=270,
        origin={-38,84}), iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=270,
        origin={-12,80})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heat_Stove
    "Heat port that has to be connected to the room to heat"
    annotation (Placement(transformation(extent={{0,-98},{22,-76}}),
        iconTransformation(extent={{0,-98},{22,-76}})));
  PGVH_stove                   pGVH_poe
    annotation (Placement(transformation(extent={{22,-46},{66,0}})));
  PGVH_controller              pGVH_reg
    annotation (Placement(transformation(extent={{-38,-46},{-8,-10}})));
equation
  connect(T_consigne, add.u1) annotation (Line(
      points={{-84,30},{-16,30},{-16,40},{27,40}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(T_consigne, add1.u1) annotation (Line(
      points={{-84,30},{-30,30},{-30,18},{17,18}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(dT_T_on.y, add1.u2) annotation (Line(
      points={{4.3,11},{18,11},{18,12},{17,12}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(dT_T_off.y, add.u2) annotation (Line(
      points={{14.3,35},{22.25,35},{22.25,34},{27,34}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(pGVH_reg.fraction_of_max_power, pGVH_poe.g) annotation (Line(
      points={{-9.8,-27.28},{6.4,-27.28},{6.4,-17.02},{24.64,-17.02}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(presence, pGVH_poe.presence) annotation (Line(
      points={{-38,84},{-38,-2},{4,-2},{4,-4.83},{23.98,-4.83}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pGVH_reg.presence, presence) annotation (Line(
      points={{-36.65,-13.78},{-42,-13.78},{-42,84},{-38,84}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(add1.y, pGVH_poe.Ton) annotation (Line(
      points={{28.5,15},{35.64,15},{35.64,-1.38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, pGVH_poe.Toff) annotation (Line(
      points={{38.5,37},{49.94,37},{49.94,-1.15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_consigne, pGVH_reg.Tconsigne) annotation (Line(
      points={{-84,30},{-62,30},{-62,-14},{-36.5,-14},{-36.5,-25.48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pGVH_reg.Tsens, Heat_Stove) annotation (Line(
      points={{-36.05,-38.62},{-36.05,-57.95},{11,-57.95},{11,-87}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(pGVH_poe.Tsens, Heat_Stove) annotation (Line(
      points={{24.42,-33.81},{24.42,-57.35},{11,-57.35},{11,-87}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(pGVH_poe.PowerOut, Heat_Stove) annotation (Line(
      points={{61.16,-23.46},{61.16,-74},{11,-74},{11,-87}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(Heat_Stove, Heat_Stove) annotation (Line(
      points={{11,-87},{9.5,-87},{9.5,-87},{11,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixed_power, pGVH_reg.marche_forcee) annotation (Line(
      points={{20,80},{-12,80},{-12,-11.26},{-24.05,-11.26}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-46,88},{88,-74}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,70},{76,-28}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{2,-6},{-26,40},{0,30},{2,32},{12,68},{32,42},{52,56},
              {48,0},{2,-6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,-6},{-6,24},{8,24},{16,54},{32,32},{46,44},{42,-2},
              {10,-6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,179,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,-6},{8,12},{22,10},{20,30},{28,8},{28,10},{38,24},
              {32,-4},{18,-6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-46},{-28,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,82},{84,82}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,84},{84,84}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,82},{84,82}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,80},{84,80}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,78},{84,78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,76},{84,76}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,-40},{86,-40}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,-38},{86,-38}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,-42},{86,-42}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-36,-46},{-34,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,-46},{-22,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-18,-46},{-16,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,-46},{-10,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,-46},{-4,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,-46},{2,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{6,-46},{8,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{12,-46},{14,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{18,-46},{20,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,-46},{26,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{30,-46},{32,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{36,-46},{38,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{42,-46},{44,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{48,-46},{50,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{54,-46},{56,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{60,-46},{62,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{66,-46},{68,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{72,-46},{74,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{78,-46},{80,-70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{60,-10},{46,-18},{38,-16},{52,-10},{60,-10}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{60,-10},{60,-12},{46,-20},{38,-18},{38,-16},{46,-18},
              {60,-10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{70,0},{56,-8},{48,-6},{62,0},{70,0}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{70,0},{70,-2},{56,-10},{48,-8},{48,-6},{56,-8},{70,0}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{60,4},{46,-4},{38,-2},{52,4},{60,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{60,4},{60,2},{46,-6},{38,-4},{38,-2},{46,-4},{60,4}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{48,-6},{34,-14},{26,-12},{40,-6},{48,-6}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{48,-6},{48,-8},{34,-16},{26,-14},{26,-12},{34,-14},{
              48,-6}},
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
          origin={49,-3},
          rotation=270),
        Polygon(
          points={{30,-12},{16,-20},{8,-18},{22,-12},{30,-12}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{30,-12},{30,-14},{16,-22},{8,-20},{8,-18},{16,-20},{
              30,-12}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{32,-4},{18,-12},{10,-10},{24,-4},{32,-4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{32,-4},{32,-6},{18,-14},{10,-12},{10,-10},{18,-12},{
              32,-4}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{8,-2},{-6,-10},{-14,-8},{0,-2},{8,-2}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{8,-2},{8,-4},{-6,-12},{-14,-10},{-14,-8},{-6,-10},{8,
              -2}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{10,-12},{10,-14},{-4,-22},{-12,-20},{-12,-18},{-4,
              -20},{10,-12}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{36,-4},{22,-12},{14,-10},{28,-4},{36,-4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{36,-4},{36,-6},{22,-14},{14,-12},{14,-10},{22,-12},{
              36,-4}},
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
          origin={-3,-11},
          rotation=270),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={13,-7},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={13,-6},
          rotation=90),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={37,-13},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={37,-12},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-3,-10},
          rotation=270),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={49,-2},
          rotation=270),
        Polygon(
          points={{10,-12},{-4,-20},{-12,-18},{2,-12},{10,-12}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),                   Rectangle(
          extent={{-72,-18},{-14,-84}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-66,-28},{-20,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>PGVH PELLET STOVE</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Complete model for PGVH wood pellet stove. Maximum combustion power of PGVH is 7,5 kW.</p>
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
Author : EIFER, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end PGVH;
