within BuildSysPro.BaseClasses.HeatTransfer.Components;
model MaterialLayer "Material layer"
  parameter BuildSysPro.Utilities.Records.GenericSolid mat "Material"
    annotation(choicesAllMatching=true,Dialog(enable=(not VariableMatProp)));
  parameter Modelica.SIunits.Length e=0.05 "Thickness";
  parameter Modelica.SIunits.Area S=1 "Surface";
  parameter Modelica.SIunits.Temperature Tinit=293.15 "Initial temperature";
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialization type";
  Modelica.SIunits.Temperature T(start=Tinit,displayUnit="degC");
protected
  parameter Real G=(2*mat.lambda*S)/e;
  parameter Real C=mat.rho*mat.c*e*S;

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (
     Placement(transformation(extent={{-100,-10},{-80,10}}), iconTransformation(
          extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b annotation (
     Placement(transformation(extent={{80,-10},{100,10}}), iconTransformation(
          extent={{80,-10},{100,10}})));

initial equation
  if InitType == BuildSysPro.Utilities.Types.InitCond.SteadyState then
    der(T)=0;
//   elseif InitType ==BuildSysPro.Utilitaires.Types.InitCond.Value then
//     T=Tinit;
  end if;

equation
  port_a.Q_flow=G*(port_a.T-T);
  port_b.Q_flow=G*(port_b.T-T);
  C*der(T)=port_a.Q_flow+port_b.Q_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={       Line(
          points={{-80,0},{80,0}},
          color={0,0,255},
          smooth=Smooth.None),     Rectangle(
          extent={{-20,80},{20,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder),
        Text(
          extent={{-50,136},{70,96}},
          lineColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end MaterialLayer;
