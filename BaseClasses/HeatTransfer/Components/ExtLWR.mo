within BuildSysPro.BaseClasses.HeatTransfer.Components;
model ExtLWR "Echanges GLO avec l'environnement et le ciel"

parameter Modelica.SIunits.Area S=1 "Surface";
  parameter Real eps=0.5 "Emissivité";
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°";
parameter Boolean GLO_env=true
    "Prise en compte de rayonnement GLO vers l'environnement";
parameter Boolean GLO_ciel=true
    "Prise en compte de rayonnement GLO vers le ciel";

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel
    "Température du ciel" annotation (Placement(transformation(extent={{-100,-60},
            {-80,-40}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation GLOenv(Gr=GrEnv)
    "Echange GLO avec l'environnement"
    annotation (Placement(transformation(extent={{-28,28},{4,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.BodyRadiation GLOciel(Gr=GrCiel)
    "Echange GLO avec le ciel"
    annotation (Placement(transformation(extent={{-32,-66},{2,-32}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure (de l'environnement)" annotation (Placement(
        transformation(extent={{-100,20},{-80,40}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_p
    "Température de surface de la paroi" annotation (Placement(transformation(
          extent={{80,-10},{100,10}}, rotation=0), iconTransformation(extent={{
            80,-10},{100,10}})));

protected
  parameter Real GrEnv= if GLO_env then eps*S*(0.5*(1-cos(incl*Modelica.Constants.pi/180))) else 0
    "Net radiation conductance between two surfaces (Env-paroi)";
  parameter Real GrCiel= if GLO_ciel then eps*S*(0.5*(1+cos(incl*Modelica.Constants.pi/180))) else 0
    "Net radiation conductance between two surfaces (Ciel-paroi)";

equation
  connect(T_ext, GLOenv.port_a) annotation (Line(
      points={{-90,30},{-58,30},{-58,44},{-26.4,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GLOenv.port_b, Ts_p) annotation (Line(
      points={{2.4,44},{52,44},{52,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_ciel, GLOciel.port_a) annotation (Line(
      points={{-90,-50},{-58,-50},{-58,-49},{-30.3,-49}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GLOciel.port_b, Ts_p) annotation (Line(
      points={{0.3,-49},{50.5,-49},{50.5,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_ciel, T_ciel) annotation (Line(
      points={{-90,-50},{-94,-50},{-96,-48},{-90,-50}},
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
<h4>Modèle permettant de calculer les échanges par rayonnement GLO avec le ciel et l'environnement</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le flux de rayonnement GLO a deux origines : l'environnement et le ciel. On fait plusieurs hypothèses :</p>
<ul>
<li>Le flux dû au ciel est supposé isotrope </li>
<li>La paroi échange avec le ciel et l'environnement uniquement en fonction de son inclinaison et de son émissivité GLO.</li>
<li>Le ciel et l'environnement sont des corps noirs isothermes.</li>
</ul>
<p>Le flux radiatif net échangé entre une paroi et l'extérieur est calculé avec la fonction ci-après : </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Equations/FluxGLOEnv.png\"/></p>
<p>Où <img src=\"modelica://BuildSysPro/Resources/Images/Equations/equation-DUkSL5mr.png\" alt=\"sigma\"/> est la constante de Stefan-Boltzmann.</p>
<p><u><b>Bibliographie</b></u></p>
<p>TF1 CLIM2000</p>
<p><u><b>Mode d'emploi</b></u></p>
<p><b>Typical values for epsilon</b><i> (d'après le modèle Modelica.Thermal.HeatTransfer.Components.BodyRadiation)</i></p>
<pre>   aluminium, polished    0.04
   copper, polished       0.04
   gold, polished         0.02
   paper                  0.09
   rubber                 0.95
   silver, polished       0.02
   wood                   0.85..0.9</pre>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<ul>
<li>Ce modèle étant utilisé dans un modèle de paroi avec échanges convectifs et radiatifs à sa surface, il faut prendre garde à ce que le coefficient d'échange superficiel extérieur soit un vrai coefficient d'échange convectif au lieu d'intégrer le rayonnement GLO.</li>
</ul>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé (Vérification analytique + vérification de la cohérence de l'allure des flux échangés) - Aurélie Kaemmerlen 09/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Components.BodyRadiation\">BodyRadiation</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics));
end ExtLWR;
