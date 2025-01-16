within BuildSysPro.BaseClasses.HeatTransfer.Components;
model BodyRadiation "Lumped thermal element for radiation heat transfer"
  extends BaseClasses.HeatTransfer.Interfaces.Element1D;
  parameter Boolean Gr_as_input=false  "Prescribed Net radiation conductance between two surface"   annotation(Evaluate=true, HideResult=true, choices(choice=false "Fixed",
        choice=true "Prescribed (needed for tracking)", radioButtons=true));
  parameter Real Gr(unit="m2")
    "Net radiation conductance between two surfaces (see docu)" annotation(Dialog(enable=not Gr_as_input));

public
  Modelica.Blocks.Interfaces.RealInput Gr_in(unit="m2") if Gr_as_input
    "Net radiation conductance between two surfaces (see docu)" annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=-90,
        origin={-20,96}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-20,84})));

// Internal connector
protected
  Modelica.Blocks.Interfaces.RealInput Gr_internal "internal connector for optional configuration";

equation
  connect(Gr_in, Gr_internal);
  if not Gr_as_input then Gr_internal=Gr;
  end if;


  Q_flow = Gr_internal*Modelica.Constants.sigma*(port_a.T^4 - port_b.T^4);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{50,80},{90,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-90,80},{-50,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{-36,10},{36,10}}, color={191,0,0}),
        Line(points={{-36,10},{-26,16}}, color={191,0,0}),
        Line(points={{-36,10},{-26,4}}, color={191,0,0}),
        Line(points={{-36,-10},{36,-10}}, color={191,0,0}),
        Line(points={{26,-16},{36,-10}}, color={191,0,0}),
        Line(points={{26,-4},{36,-10}}, color={191,0,0}),
        Line(points={{-36,-30},{36,-30}}, color={191,0,0}),
        Line(points={{-36,-30},{-26,-24}}, color={191,0,0}),
        Line(points={{-36,-30},{-26,-36}}, color={191,0,0}),
        Line(points={{-36,30},{36,30}}, color={191,0,0}),
        Line(points={{26,24},{36,30}}, color={191,0,0}),
        Line(points={{26,36},{36,30}}, color={191,0,0}),
        Text(
          extent={{-132,144},{108,84}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-119,-86},{117,-125}},
          lineColor={0,0,0},
          textString="Gr=%Gr"),
        Rectangle(
          extent={{-50,80},{-44,-80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{45,80},{50,-80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is a model describing the thermal radiation, i.e., electromagnetic radiation emitted between two bodies as a result of their temperatures. The following constitutive equation is used: </p>
<pre>    Q_flow = Gr*sigma*(port_a.T^4 - port_b.T^4);</pre>
<p>where Gr is the radiation conductance and sigma is the Stefan-Boltzmann constant (= Modelica.Constants.sigma). Gr may be determined by measurements and is assumed to be constant over the range of operations. </p>
<p>For simple cases, Gr may be analytically computed. The analytical equations use epsilon, the emission value of a body which is in the range 0..1. Epsilon=1, if the body absorbs all radiation (= black body). Epsilon=0, if the body reflects all radiation and does not absorb any. </p>
<pre>   Typical values for epsilon:
   aluminium, polished    0.04
   copper, polished       0.04
   gold, polished         0.02
   paper                  0.09
   rubber                 0.95
   silver, polished       0.02
   wood                   0.85..0.9</pre>
<p><b>Analytical Equations for Gr</b></p>
<p><b>Small convex object in large enclosure</b> (e.g., a hot machine in a room): </p>
<pre>    Gr = e*A
    where
       e: Emission value of object (0..1)
       A: Surface area of object where radiation
          heat transfer takes place</pre>
<p><b>Two parallel plates</b>:</p>
<pre>    Gr = A/(1/e1 + 1/e2 - 1)
    where
       e1: Emission value of plate1 (0..1)
       e2: Emission value of plate2 (0..1)
       A : Area of plate1 (= area of plate2)</pre>
<p><b>Two long cylinders in each other</b>, where radiation takes place from the inner to the outer cylinder): </p>
<pre>    Gr = 2*pi*r1*L/(1/e1 + (1/e2 - 1)*(r1/r2))
    where
       pi: = Modelica.Constants.pi
       r1: Radius of inner cylinder
       r2: Radius of outer cylinder
       L : Length of the two cylinders
       e1: Emission value of inner cylinder (0..1)
       e2: Emission value of outer cylinder (0..1)</pre>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Stéphanie Froidurot 07/2019 : Ajout de la possibilité de choisir entre Gr paramètre ou input.</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-90,80},{-56,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-56,80},{-56,-80}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{50,80},{50,-80}},
          color={0,0,0},
          thickness=1),
        Rectangle(
          extent={{50,80},{90,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{-40,10},{40,10}}, color={191,0,0}),
        Line(points={{-40,10},{-30,16}}, color={191,0,0}),
        Line(points={{-40,10},{-30,4}}, color={191,0,0}),
        Line(points={{-40,-10},{40,-10}}, color={191,0,0}),
        Line(points={{30,-16},{40,-10}}, color={191,0,0}),
        Line(points={{30,-4},{40,-10}}, color={191,0,0}),
        Line(points={{-40,-30},{40,-30}}, color={191,0,0}),
        Line(points={{-40,-30},{-30,-24}}, color={191,0,0}),
        Line(points={{-40,-30},{-30,-36}}, color={191,0,0}),
        Line(points={{-40,30},{40,30}}, color={191,0,0}),
        Line(points={{30,24},{40,30}}, color={191,0,0}),
        Line(points={{30,36},{40,30}}, color={191,0,0})}));
end BodyRadiation;
