within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ExtLWR
  "Long wavelength radiation exchanges with the sky and the environment"

parameter Modelica.SIunits.Area S=1 "Surface";
  parameter Real eps=0.5 "Emissivity";
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°";
parameter Boolean GLO_env=true
    "Integration of long wavelength radiation (infrared) toward the environment";
parameter Boolean GLO_ciel=true
    "Integration of long wavelength radiation (infrared) toward the sky";

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky
    "Sky temperature" annotation (Placement(transformation(extent={{-100,-50},{
            -80,-30}}, rotation=0), iconTransformation(extent={{-100,-50},{-80,
            -30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation GLOenv(Gr=GrEnv)
    "Long wavelength exchanges with the environment"
    annotation (Placement(transformation(extent={{-28,24},{4,56}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation GLOciel(Gr=GrCiel)
    "Long wavelength exchanges with the sky"
    annotation (Placement(transformation(extent={{-32,-57},{2,-23}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outside temperature (of the environment)" annotation (Placement(
        transformation(extent={{-100,30},{-80,50}}, rotation=0),
        iconTransformation(extent={{-100,30},{-80,50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_ext
    "Outside temperature at the wall surface" annotation (Placement(
        transformation(extent={{80,-10},{100,10}}, rotation=0),
        iconTransformation(extent={{80,-10},{100,10}})));

protected
  parameter Real GrEnv= if GLO_env then eps*S*(0.5*(1-cos(incl*Modelica.Constants.pi/180))) else 0
    "Net radiation conductance between two surfaces (Env-Wall)";
  parameter Real GrCiel= if GLO_ciel then eps*S*(0.5*(1+cos(incl*Modelica.Constants.pi/180))) else 0
    "Net radiation conductance between two surfaces (Sky-Wall)";

equation
  connect(T_ext, GLOenv.port_a) annotation (Line(
      points={{-90,40},{-26.4,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GLOenv.port_b, Ts_ext) annotation (Line(
      points={{2.4,40},{52,40},{52,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_sky, GLOciel.port_a) annotation (Line(
      points={{-90,-40},{-30.3,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GLOciel.port_b, Ts_ext) annotation (Line(
      points={{0.3,-40},{50.5,-40},{50.5,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_sky, T_sky) annotation (Line(
      points={{-90,-40},{-90,-40}},
      color={191,0,0},
      smooth=Smooth.None));
annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),graphics={
        Rectangle(
          extent={{40,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-80,80},{-40,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{-30,10},{32,10}}, color={191,0,0}),
        Line(points={{-36,10},{-26,16}}, color={191,0,0}),
        Line(points={{-36,10},{-26,4}}, color={191,0,0}),
        Line(points={{-30,-10},{34,-10}}, color={191,0,0}),
        Line(points={{26,-16},{36,-10}}, color={191,0,0}),
        Line(points={{26,-4},{36,-10}}, color={191,0,0}),
        Line(points={{-30,-30},{36,-30}}, color={191,0,0}),
        Line(points={{-36,-30},{-26,-24}}, color={191,0,0}),
        Line(points={{-36,-30},{-26,-36}}, color={191,0,0}),
        Line(points={{-30,30},{34,30}}, color={191,0,0}),
        Line(points={{26,24},{36,30}}, color={191,0,0}),
        Line(points={{26,36},{36,30}}, color={191,0,0}),
        Text(
          extent={{-150,125},{150,85}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-150,-90},{150,-120}},
          lineColor={0,0,0},
          textString="Gr=%Gr"),
        Rectangle(
          extent={{-40,80},{-34,-80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{35,80},{40,-80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Calculation of long wavelength radiation exchanges with the sky and the environment</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The solar flux with long wavelength radiation has two sources : the environment and the sky. Different hypothesis have been made :</p>
<ul>
<li>The flux from the sky is supposed isotropic.</li>
<li>The exchanges between the wall, the sky and the environment are supposed to depend only on the tilt and the long wavelength emissivity.</li>
<li>The sky and the environment are supposed to be isothermal black bodies.</li>
</ul>
<p>The radiative net fux exchanged between a wall and the outside is calculated with the function below :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Equations/FluxGLOEnv.png\"/></p>
<p>Where <img src=\"modelica://BuildSysPro/Resources/Images/Equations/equation-DUkSL5mr.png\" alt=\"sigma\"/> is the Stefan-Boltzmann constant.</p>
<p><u><b>Bibliography</b></u></p>
<p>TF1 CLIM2000</p>
<p><u><b>Instructions for use</b></u></p>
<p>Typical values for epsilon <i>(from <a href=\"BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a> model)</i> :</p>
<pre>   aluminium, polished    0.04
   copper, polished       0.04
   gold, polished         0.02
   paper                  0.09
   rubber                 0.95
   silver, polished       0.02
   wood                   0.85..0.9</pre>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>As this model is used in a wall model with convective and radiatives exchanges on its surface, care must be taken to ensure that the outside superficial heat exchange coefficient is a real convective heat exchange coefficient instead of integrating the long wavelength radiation.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (analytical verification + verification of the coherence of the exchanged fluxes profile) - Aurélie Kaemmerlen 09/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end ExtLWR;
