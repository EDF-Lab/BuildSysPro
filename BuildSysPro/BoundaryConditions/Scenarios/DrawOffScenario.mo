within BuildSysPro.BoundaryConditions.Scenarios;
model DrawOffScenario
  "DHW draw-off scenario"

  parameter Real gain=1 "Mutliplying factor of energy consumption";
  parameter Real T_repeat=86400 "Repeat period";
  parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/Profil_S.csv") "Name of file to read" annotation (Dialog(
        loadSelector(filter="CSV files (*.csv)", caption=
            "Name of file to read")));
  final parameter Real[:,3] tbl=DataFiles.readCSVmatrix(fileName);

protected
  Boolean tapping(start=false,fixed=true);
  Integer i(start=1,fixed=true) "Table row index";
  Modelica.SIunits.Energy tapped_energy( start=0, fixed=true)
    "Amount of tapped energy from the tank";

public
  Modelica.Blocks.Interfaces.RealOutput drawoff_flow_rate(start=1e-10)
    "Draw-off flow rate (kg/s)"
    annotation (Placement(transformation(extent={{100,-12},{126,14}}),
        iconTransformation(extent={{100,-12},{126,14}})));

  Modelica.Blocks.Interfaces.RealInput T_hot
    "Temperature outflowing the tank"
    annotation (Placement(transformation(extent={{-138,-80},{-98,-40}}),
        iconTransformation(extent={{-138,-80},{-98,-40}})));
  Modelica.Blocks.Interfaces.RealInput T_cold
    "Cold inflow water temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  constant Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp=4185
    "Specific heat capacity of water at constant pressure in J/(kg.K)";
  Real timeBouclage(start=0);

algorithm
     if time-timeBouclage>=tbl[pre(i),1] and tapped_energy <= 3.6e6*gain*tbl[pre(i),2] then
       tapping:=true;
     else
       tapping:=false;
     end if;

     when not tapping then
       i:= pre(i) + 1;
     end when;

     when time-timeBouclage>=T_repeat then
       i:=1;
       timeBouclage:=time;

     end when;
equation

    when not tapping then
       reinit(tapped_energy,0);
     end when;

  drawoff_flow_rate = if tapping then gain*(1/60)*tbl[pre(i),3] else 0.0000000000001;
  der(tapped_energy) = drawoff_flow_rate*cp*(T_hot-T_cold);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,255}),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,78},{-50,-82}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,78},{10,76}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,78},{12,22}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,26},{44,20}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-10,10},{-18,-26}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{6,10},{6,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Line(
          points={{26,12},{34,-26}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{38,10},{54,-22}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash)}),  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>Simple draw-off scenario with a looping function</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Written with a repeat function in seconds to repeat normative scenarios over longer periods (less storage space taken) and a gain to vary the draw-off flow and energy.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>3 draw-off scenarios (S, M and L) from EN1647 standard are available in the resources.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Due to the way the model is written, unselecting \"store variables at events\" may hide the scenario output in the results.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Davy Merlet, Kévin Deutz 01/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Davy MERLET, Kévin DEUTZ, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Stéphanie Froidurot 05/2019 - Correction unité dans documentation</p>
</html>"));
end DrawOffScenario;
