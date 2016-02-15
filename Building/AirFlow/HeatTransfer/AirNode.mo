within BuildSysPro.Building.AirFlow.HeatTransfer;
model AirNode "Noeud d'air à volume constant (thermique pure)"

  parameter Modelica.SIunits.Volume V "volume du noeud d'air";
  parameter Modelica.SIunits.Temperature Tair "température initiale de l'air";
  constant Modelica.SIunits.SpecificHeatCapacityAtConstantVolume Cv=713
    "capacité calorifique isochore de l'air [J/kg.K]";
  constant Modelica.SIunits.Density rho=1.24 "masse volumique de l'air [kg/m3]";

  BaseClasses.HeatTransfer.Components.HeatCapacitor VolAir(C=Cv*rho*V, T(start=
          Tair, displayUnit="degC")) annotation (Placement(transformation(
          extent={{-20,24},{0,44}}, rotation=0)));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(
        transformation(extent={{-8,-54},{6,-40}}, rotation=0),
        iconTransformation(extent={{-20,-60},{20,-20}})));

equation
  connect(VolAir.port, port_a) annotation (Line(
      points={{-9,25},{-9,11.5},{-1,11.5},{-1,-47}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(extent={{-148.5,-105},{148.5,105}},
          preserveAspectRatio=true), graphics),                             Icon(coordinateSystem(extent={{-100,
            -100},{100,100}}, preserveAspectRatio=true), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,128,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None), Text(
          extent={{-117,18},{111,-22}},
          lineColor={0,0,0},
          textString="V=%V m3")}),
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end AirNode;
