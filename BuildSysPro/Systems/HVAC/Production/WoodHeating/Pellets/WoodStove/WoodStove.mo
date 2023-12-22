within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.WoodStove;
model WoodStove

  Modelica.Blocks.Interfaces.RealInput T_consigne
    "Temperature wanted in the room  [K]"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{28,32},{38,42}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{16,14},{26,24}})));
  Modelica.Blocks.Sources.Constant dT_T_off(k=5)
    "Value of temperature difference before stove stops"
    annotation (Placement(transformation(extent={{-4,28},{10,42}})));
  Modelica.Blocks.Sources.Constant dT_T_on(k=-5)
    "Value of temperature difference before stove starts"
    annotation (Placement(transformation(extent={{-12,8},{2,22}})));
  Modelica.Blocks.Interfaces.BooleanInput etatON
    "Indicates if the \"forced going\" mode is on"     annotation (Placement(
        transformation(
        extent={{-24,-24},{24,24}},
        rotation=270,
        origin={22,86}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,96})));
  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
                                                   annotation (Placement(
        transformation(
        extent={{-24,-24},{24,24}},
        rotation=270,
        origin={-38,88}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,96})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heat_Stove
    "Heat port that has to be connected to the room to heat"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{-10,-100},{10,-80}})));
  PGS.PGS_stove                                                        pGVH_poe
    annotation (Placement(transformation(extent={{26,-28},{46,-8}})));
  PGS.PGS_controller                                                         pGVH_reg(Pcombmin=
        Pcombmin, Pcombmax=Pcombmax)
    annotation (Placement(transformation(extent={{-32,-26},{-12,-6}})));
  parameter Modelica.Units.SI.Power Pcombmin=1700
    "Minimum thermal power";
  parameter Modelica.Units.SI.Power Pcombmax=6580
    "Maximum thermal power";
equation
  connect(T_consigne, add.u1) annotation (Line(
      points={{-100,40},{-16,40},{27,40}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(T_consigne, add1.u1) annotation (Line(
      points={{-100,40},{-30,40},{-30,22},{15,22}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(dT_T_on.y, add1.u2) annotation (Line(
      points={{2.7,15},{18,15},{18,16},{15,16}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(dT_T_off.y, add.u2) annotation (Line(
      points={{10.7,35},{22.25,35},{22.25,34},{27,34}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.Bezier));
  connect(pGVH_reg.fraction_of_max_power, pGVH_poe.g) annotation (Line(
      points={{-13,-15},{6.4,-15},{6.4,-15},{27,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(presence, pGVH_poe.presence) annotation (Line(
      points={{-38,88},{-38,-2},{4,-2},{4,-11},{27,-11}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pGVH_reg.presence, presence) annotation (Line(
      points={{-31,-9},{-38,-9},{-38,88}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(add1.y, pGVH_poe.Ton) annotation (Line(
      points={{26.5,19},{33,19},{33,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, pGVH_poe.Toff) annotation (Line(
      points={{38.5,37},{39,37},{39,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_consigne, pGVH_reg.Tconsigne) annotation (Line(
      points={{-100,40},{-70,40},{-70,-15},{-31,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pGVH_reg.Tsens, Heat_Stove) annotation (Line(
      points={{-31,-21},{-31,-57.95},{0,-57.95},{0,-90}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(pGVH_poe.Tsens, Heat_Stove) annotation (Line(
      points={{27,-23},{27,-57.35},{0,-57.35},{0,-90}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(pGVH_poe.PowerOut, Heat_Stove) annotation (Line(
      points={{45,-17},{45,-74},{0,-74},{0,-90}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(etatON, pGVH_reg.etatON) annotation (Line(
      points={{22,86},{22,58},{-26,58},{-26,-7},{-22,-7}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-52,96},{88,-70}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,78},{80,-30}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{0,0},{-28,46},{-2,36},{0,38},{10,74},{30,48},{50,62},{46,6},{
              0,0}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,0},{-8,30},{6,30},{14,60},{30,38},{44,50},{40,4},{8,0}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,179,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{16,0},{6,18},{20,16},{18,36},{26,14},{26,16},{36,30},{30,2},{
              16,0}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-40},{-30,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,90},{82,90}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,92},{82,92}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,88},{82,88}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,86},{82,86}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,84},{82,84}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,82},{82,82}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,-34},{84,-34}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,-32},{84,-32}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,-36},{84,-36}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-38,-40},{-36,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-26,-40},{-24,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-20,-40},{-18,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-14,-40},{-12,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-8,-40},{-6,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-2,-40},{0,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{4,-40},{6,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{10,-40},{12,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{16,-40},{18,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,-40},{24,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{28,-40},{30,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{34,-40},{36,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{40,-40},{42,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{46,-40},{48,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{52,-40},{54,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{58,-40},{60,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{64,-40},{66,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{70,-40},{72,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{76,-40},{78,-64}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{58,-4},{44,-12},{36,-10},{50,-4},{58,-4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{58,-4},{58,-6},{44,-14},{36,-12},{36,-10},{44,-12},{58,-4}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{68,6},{54,-2},{46,0},{60,6},{68,6}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{68,6},{68,4},{54,-4},{46,-2},{46,0},{54,-2},{68,6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{58,10},{44,2},{36,4},{50,10},{58,10}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{58,10},{58,8},{44,0},{36,2},{36,4},{44,2},{58,10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{46,0},{32,-8},{24,-6},{38,0},{46,0}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{46,0},{46,-2},{32,-10},{24,-8},{24,-6},{32,-8},{46,0}},
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
          origin={47,3},
          rotation=270),
        Polygon(
          points={{28,-6},{14,-14},{6,-12},{20,-6},{28,-6}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{28,-6},{28,-8},{14,-16},{6,-14},{6,-12},{14,-14},{28,-6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{30,2},{16,-6},{8,-4},{22,2},{30,2}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{30,2},{30,0},{16,-8},{8,-6},{8,-4},{16,-6},{30,2}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{6,4},{-8,-4},{-16,-2},{-2,4},{6,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{6,4},{6,2},{-8,-6},{-16,-4},{-16,-2},{-8,-4},{6,4}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{8,-6},{8,-8},{-6,-16},{-14,-14},{-14,-12},{-6,-14},{8,-6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{34,2},{20,-6},{12,-4},{26,2},{34,2}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{34,2},{34,0},{20,-8},{12,-6},{12,-4},{20,-6},{34,2}},
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
          origin={-5,-5},
          rotation=270),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={11,-1},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={11,0},
          rotation=90),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={35,-7},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={35,-6},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-5,-4},
          rotation=270),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={47,4},
          rotation=270),
        Polygon(
          points={{8,-6},{-6,-14},{-14,-12},{0,-6},{8,-6}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),                   Rectangle(
          extent={{-82,-24},{-24,-90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-76,-32},{-30,-52}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>PGS PELLET STOVE</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Complete model for PGS wood pellet stove. Maximum combustion power of PGS is 6,5 kW.</p>
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
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EIFER (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>H. Blervaque 09/2013 : Remplacement du contr&ocirc;le gradué par un contr&ocirc;leur PI car cela poser d'une part des problème de convergence et d'autre part ce type de régulation a été remplacé par un contr&ocirc;le plus souple (type PI) dans les équipements. Repositionnement des ic&ocirc;nes des variables d'entrées/sorties</p>
</html>"));
end WoodStove;
