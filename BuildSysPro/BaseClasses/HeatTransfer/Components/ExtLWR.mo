within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ExtLWR
  "Long wavelength radiation exchanges with the sky and the environment"

parameter Boolean backLWR=false "Model used to calculate exchanges with the soil and the environnement?" annotation(Evaluate=true,HideResult=true,
  choices(choice=true "Exchanges with the soil", choice=false "Echanges with the sky (default)", radioButtons=true));

parameter Boolean use_incl_in=false "Prescribed or fixed tilt of the surface relative to the horizontal" annotation(Evaluate=true,HideResult=true,
  choices(choice=true "Prescribed", choice=false "Fixed", radioButtons=true));

  parameter Modelica.Units.SI.Area S=1 "Surface";
parameter Real eps=0.5 "Emissivity";

parameter Real incl=30
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°"
    annotation(Dialog(enable=not use_incl_in));
parameter Boolean GLO_env=true
    "Integration of long wavelength radiation (infrared) toward the environment";
parameter Boolean GLO_ciel=true
    "Integration of long wavelength radiation (infrared) toward the sky";

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky
    "Sky temperature" annotation (Placement(transformation(extent={{-100,-50},{
            -80,-30}}, rotation=0), iconTransformation(extent={{-100,-50},{-80,
            -30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outside temperature (of the environment)" annotation (Placement(
        transformation(extent={{-100,30},{-80,50}}, rotation=0),
        iconTransformation(extent={{-100,30},{-80,50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_ext
    "Outside temperature at the wall surface" annotation (Placement(
        transformation(extent={{80,-10},{100,10}}, rotation=0),
        iconTransformation(extent={{80,-10},{100,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation GLOenv(Gr_as_input=use_incl_in, Gr=GrEnv)
    "Long wavelength exchanges with the environment"
    annotation (Placement(transformation(extent={{-28,24},{4,56}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation GLOciel(Gr_as_input=use_incl_in, Gr=GrCiel)
    "Long wavelength exchanges with the sky"
    annotation (Placement(transformation(extent={{-32,-57},{2,-23}})));
  Modelica.Blocks.Interfaces.RealInput incl_in if use_incl_in
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°"
           annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
           iconTransformation(extent={{-100,64},{-80,84}})));

protected
  parameter Real incl_gen = if backLWR and not use_incl_in then 180-incl else incl
  "Generic value of tilt for the calculations (either oriented toward the sky or the soil)";
  Modelica.Blocks.Sources.RealExpression incl_gen_in(y=if backLWR then 180-incl else incl) if use_incl_in;


  parameter Real GrEnv = if GLO_env and not use_incl_in then eps*S*(0.5*(1-cos(incl_gen*Modelica.Constants.pi/180))) else 0
    "Net radiation conductance between two surfaces (Env-Wall)";
  parameter Real GrCiel= if GLO_ciel and not use_incl_in then eps*S*(0.5*(1+cos(incl_gen*Modelica.Constants.pi/180))) else 0
    "Net radiation conductance between two surfaces (Sky-Wall)";

  Modelica.Blocks.Sources.RealExpression GrEnv_in(y=if GLO_env then
    eps*S*(0.5*(1 - cos(incl_gen_in.y*Modelica.Constants.pi/180))) else 0) if use_incl_in;
  Modelica.Blocks.Sources.RealExpression GrCiel_in(y=if GLO_ciel then
    eps*S*(0.5*(1+cos(incl_gen_in.y*Modelica.Constants.pi/180))) else 0) if use_incl_in;


  //Internal connector
protected
   Modelica.Blocks.Interfaces.RealInput incl_in_internal "Internal connector for optional configuration";



equation
  connect(incl_gen_in.y, incl_in_internal);
  if not use_incl_in then incl_in_internal=incl_gen;
  end if;

  if use_incl_in then
    connect(GLOenv.Gr_in, GrEnv_in.y);
    connect(GLOciel.Gr_in, GrCiel_in.y);
  end if;

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

<p>It is possible to calculate the long wavelength exchanges with the soil using the boolean <code>backLWR = true</code>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>As this model is used in a wall model with convective and radiatives exchanges on its surface, care must be taken to ensure that the outside superficial heat exchange coefficient is a real convective heat exchange coefficient instead of integrating the long wavelength radiation.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (analytical verification + verification of the coherence of the exchanged fluxes profile) - Aurélie Kaemmerlen 09/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Stéphanie Froidurot 07/2019 : Adding the possibility to use fixed (parameter) or prescribed (input) tilt, controlled by a boolean (use_incl_in).
Adding the possibility to calculate radiative exchanges with the soil (tilt = 180 - incl), controlled by a boolean (backLWR).
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end ExtLWR;
