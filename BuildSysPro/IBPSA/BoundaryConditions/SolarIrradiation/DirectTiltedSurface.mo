within BuildSysPro.IBPSA.BoundaryConditions.SolarIrradiation;
block DirectTiltedSurface "Direct solar irradiation on a tilted surface"
  extends
    IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;

  parameter Modelica.Units.SI.Angle azi "Surface azimuth";

  Modelica.Blocks.Interfaces.RealOutput inc(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angle"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

protected
  SolarGeometry.IncidenceAngle incAng(
    final azi=azi,
    final til=til) "Incidence angle"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.DirectTiltedSurface HDirTil
    "Direct irradition on tilted surface"
    annotation (Placement(transformation(extent={{0,-20},{40,20}})));

equation
  connect(incAng.y, HDirTil.incAng) annotation (Line(
      points={{-29,-20},{-12,-20},{-12,-12},{-4,-12}},
      color={0,0,127}));

  connect(weaBus.HDirNor, HDirTil.HDirNor) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,12},{-4,12}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(incAng.y, inc) annotation (Line(
      points={{-29,-20},{-20,-20},{-20,-40},{110,-40}},
      color={0,0,127}));
  connect(HDirTil.HDirTil, H) annotation (Line(
      points={{42,1.22125e-15},{72,1.22125e-15},{72,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127}));

  connect(weaBus, incAng.weaBus) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-20},{-50,-20}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    defaultComponentName="HDirTil",
    Documentation(info="<html>
<p>
This component computes the direct solar irradiation on a tilted surface.
For a definition of the parameters, see the
<a href=\"modelica://BuildSysPro.IBPSA.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Removed parameter <code>lat</code> as it is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Removed duplicate instance <code>weaBus</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/461\">
https://github.com/ibpsa/modelica-ibpsa/issues/461</a>.
</li>
<li>
December 12, 2010, by Michael Wetter:<br/>
Added incidence angle as output as this is needed for the room model.
</li>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end DirectTiltedSurface;
