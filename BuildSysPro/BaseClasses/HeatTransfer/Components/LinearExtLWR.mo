within BuildSysPro.BaseClasses.HeatTransfer.Components;
model LinearExtLWR
  "Echanges thermique par rayonnement en grande longueur d'onde"

// Paramètres publics
  parameter Modelica.Units.SI.Area S=1 "Surface";
parameter Real eps=0.5 "Emissivité";
parameter Real skyViewFactor
    "Facteur de forme moyen entre les parois et le ciel (exemple: skyViewFactor(toiture terrase)=1, skyViewfactor(paroi verticale en environnement dégagé)=0.5)";

// Composants publics
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky
    "Température du ciel" annotation (Placement(transformation(extent={{-100,-50},
            {-80,-30}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure (de l'environnement)" annotation (Placement(
        transformation(extent={{-100,30},{-80,50}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_ext
    "Température de surface de la paroi" annotation (Placement(transformation(
          extent={{80,-10},{100,10}}, rotation=0), iconTransformation(extent={{
            80,-10},{100,10}})));

// Paramètres protégés
protected
  parameter Modelica.Units.SI.Temperature TcielConst=263.15
    "Estimation de la température de Ciel";
  parameter Modelica.Units.SI.Temperature TenvConst=283.15
    "Estimation de la température d'environnement";
  parameter Modelica.Units.SI.Temperature TsurfConst=288.15
    "Estimation de la température de surface des parois";

// Composants internes
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor GLOenv(G=(1 -
        skyViewFactor)*S*Modelica.Constants.sigma*eps*(TenvConst^2 + TsurfConst
        ^2)*(TenvConst + TsurfConst)) "Echange GLO avec l'environnement"
    annotation (Placement(transformation(extent={{-16,24},{16,56}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor GLOciel(G=
        skyViewFactor*S*Modelica.Constants.sigma*eps*(TcielConst^2 + TsurfConst
        ^2)*(TcielConst + TsurfConst)) "Echange GLO avec le ciel"
    annotation (Placement(transformation(extent={{-18,-57},{16,-23}})));
equation
  connect(GLOciel.port_b, Ts_ext) annotation (Line(
      points={{14.3,-40},{50.5,-40},{50.5,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(GLOenv.port_b, Ts_ext) annotation (Line(
      points={{14.4,40},{50,40},{50,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(GLOenv.port_a, T_ext) annotation (Line(
      points={{-14.4,40},{-90,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, GLOciel.port_a) annotation (Line(
      points={{-90,-40},{-16.3,-40}},
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
<i>Calculation of linearized long wavelength radiation exchanges with the sky and the environment.</i>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The solar flux with long wavelength radiation has two sources : the environment and the sky. Different hypothesis have been made :</p>
<ul>
<li>The flux from the sky is supposed isotropic.</li>
<li>The exchanges between the wall, the sky and the environment are supposed to depend only on the <code>skyViewFactor</code> and the long wavelength emissivity.</li>
<li>The sky and the environment are supposed to be isothermal black bodies.</li>
</ul>
<p>The radiative net fux exchanged between a wall and the outside is linearized with the function below :</p>
<ul>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation1.png\" alt=\"Flux_gloEnvironnement =sigma*epsilon*(T_envConst^2+T_surfConst^2)*(T_envConst+T_surfConst)*S*(1-skyViewfactor)*(T_env-T_surf)\"/></li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation2.png\" alt=\"Flux_gloCiel=sigma*epsilon*(T_cielConst^2+T_surfConst^2)*(T_cielConst+T_surfConst)*S*skyViewfactor*(T_ciel-T_surf)\"/></li>
</ul>
<p>Where :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation3.png\" alt=\"sigma\"/> and <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation4.png\" alt=\"epsilon\"/> are respectively the Stefan-Boltzmann constant and the emissivity of the wall. Furthermore <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation5.png\" alt=\"T_cielConst\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation6.png\" alt=\"T_envConst\"/> and <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation7.png\" alt=\"T_surfConst\"/> are representatives constants of the sky, environment and outside surface temperatures. Using the values :</p>
<ul>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation8.png\" alt=\"T_envConst=283.15\"/> K,</li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation9.png\" alt=\"T_cielConst=T_extConst-20\"/> = 263.15 K , from the BRUNT correlation,</li>
<li>and <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation10.png\" alt=\"T_surfConst=288.15\"/> K,</li>
</ul>
<p>it gives :</p>
<ul>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation11.png\" alt=\"Flux_GLOEnvironnement =5.29*S*epsilon*(1-skyViewfactor)*(T_ext-T_surf)\"/></li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation12.png\" alt=\"Flux_GLOCiel=4.76*S*epsilon*skyViewfactor*(T_ciel-T_surf)\"/></li>
</ul>
<p>Finally, we get :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation13.png\" alt=\"Flux_GLO=Flux_GLOEnvironnement + Flux_GLOCiel\"/></p>
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
<p>Verify that the conditions of use are close enough to <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation14.png\" alt=\"T_envConst=283.15\"/> K and <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation15.png\" alt=\"T_cielConst=T_extConst-20\"/> = 263.15 K.</p>
<p><u><b>Validations</b></u></p>
<p>Modèle validé - Gilles PLESSIS 12/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end LinearExtLWR;
