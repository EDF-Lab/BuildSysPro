within BuildSysPro.BaseClasses.HeatTransfer.Components;
model LinearExtLWR
  "Echanges thermique par rayonnement en grande longueur d'onde"

// Paramètres publics
parameter Modelica.SIunits.Area S=1 "Surface";
parameter Real eps=0.5 "Emissivité";
parameter Real skyViewFactor
    "Facteur de forme moyen entre les parois et le ciel (exemple: skyViewFactor(toiture terrase)=1, skyViewfactor(paroi verticale en environnement dégagé)=0.5)";

// Composants publics
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel
    "Température du ciel" annotation (Placement(transformation(extent={{-100,-60},
            {-80,-40}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure (de l'environnement)" annotation (Placement(
        transformation(extent={{-100,40},{-80,60}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_p
    "Température de surface de la paroi" annotation (Placement(transformation(
          extent={{80,-10},{100,10}}, rotation=0), iconTransformation(extent={{
            80,-10},{100,10}})));

// Paramètres protégés
protected
  parameter Modelica.SIunits.Temperature TcielConst=263.15
    "Estimation de la température de Ciel";
  parameter Modelica.SIunits.Temperature TenvConst=283.15
    "Estimation de la température d'environnement";
  parameter Modelica.SIunits.Temperature TsurfConst=288.15
    "Estimation de la température de surface des parois";

// Composants internes
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor GLOenv(G=(1 -
        skyViewFactor)*S*Modelica.Constants.sigma*eps*(TenvConst^2 + TsurfConst
        ^2)*(TenvConst + TsurfConst)) "Echange GLO avec l'environnement"
    annotation (Placement(transformation(extent={{-16,34},{16,66}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor GLOciel(G=
        skyViewFactor*S*Modelica.Constants.sigma*eps*(TcielConst^2 + TsurfConst
        ^2)*(TcielConst + TsurfConst)) "Echange GLO avec le ciel"
    annotation (Placement(transformation(extent={{-18,-66},{16,-32}})));
equation
  connect(GLOciel.port_b, Ts_p) annotation (Line(
      points={{14.3,-49},{50.5,-49},{50.5,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(GLOenv.port_b, Ts_p) annotation (Line(
      points={{14.4,50},{50,50},{50,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(GLOenv.port_a, T_ext) annotation (Line(
      points={{-14.4,50},{-90,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ciel, GLOciel.port_a) annotation (Line(
      points={{-90,-50},{-53.15,-50},{-53.15,-49},{-16.3,-49}},
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
<h4>Modèle d'échanges en grande longueur d'onde linéarisé avec le ciel et l'environnement.</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le rayonnement GLO a deux origines : l'environnement et le ciel. On fait plusieurs hypothèses :</p>
<ul>
<li>Le flux dû au ciel est supposé isotrope </li>
<li>La paroi échange avec le ciel et l'environnement uniquement en fonction du <code>skyViewFacto</code>r et de son émissivité GLO.</li>
<li>Le ciel et l'environnement sont des corps noirs isothermes.</li>
</ul>
<p>Le flux radiatif net échangé entre une paroi et l'extérieur (environnement et ciel) est linéarisé avec la fonction ci-après : </p>
<ul>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation1.png\" alt=\"Flux_gloEnvironnement =sigma*epsilon*(T_envConst^2+T_surfConst^2)*(T_envConst+T_surfConst)*S*(1-skyViewfactor)*(T_env-T_surf)\"/></li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation2.png\" alt=\"Flux_gloCiel=sigma*epsilon*(T_cielConst^2+T_surfConst^2)*(T_cielConst+T_surfConst)*S*skyViewfactor*(T_ciel-T_surf)\"/></li>
</ul>
<p>Où :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation3.png\" alt=\"sigma
\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation4.png\" alt=\"epsilon\"/> sont repsectivement la constante de Stefan-Boltzmann et l'émissivité de la paroi. Par ailleurs <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation5.png\" alt=\"T_cielConst
\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation6.png\" alt=\"T_envConst\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation7.png\" alt=\"T_surfConst\"/> sont des constantes représentatives de la température de ciel, de l'environnement et de la surface extérieure. En prenant comme valeurs :</p>
<ul>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation8.png\" alt=\"T_envConst=283.15
\"/> K,</li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation9.png\" alt=\"T_cielConst=T_extConst-20
\"/> =263.15 K , d'après la corrélation de BRUNT,</li>
<li>et <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation10.png\" alt=\"T_surfConst=288.15

\"/> K,</li>
</ul>
<p>on obtient :</p>
<ul>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation11.png\" alt=\"Flux_GLOEnvironnement =5.29*S*epsilon*(1-skyViewfactor)*(T_ext-T_surf)\"/></li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation12.png\" alt=\"Flux_GLOCiel=4.76*S*epsilon*skyViewfactor*(T_ciel-T_surf)\"/></li>
</ul>
<p>Pour finir on a :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation13.png\" alt=\"Flux_GLO=Flux_GLOEnvironnement + Flux_GLOCiel\"/></p>
<p><u><b>Bibliographie</b></u></p>
<p>TF1 CLIM2000</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Valeurs typiques pour epsilon tirées de la documentation du modèle <a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation de Modelica</a>.</p>
<pre>   aluminium, polished    0.04
   copper, polished       0.04
   gold, polished         0.02
   paper                  0.09
   rubber                 0.95
   silver, polished       0.02
   wood                   0.85..0.9</pre>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Vérifier que les conditions d'utilisation sont suffisanmment proches de <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation14.png\" alt=\"T_envConst=283.15
\"/> K et <img src=\"modelica://BuildSysPro/Resources/Images/equations/LinearGLO/equation15.png\" alt=\"T_cielConst=T_extConst-20
\"/>=263.15 K.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles PLESSIS 12/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics));
end LinearExtLWR;
