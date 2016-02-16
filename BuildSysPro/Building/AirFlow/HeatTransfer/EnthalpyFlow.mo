within BuildSysPro.Building.AirFlow.HeatTransfer;
model EnthalpyFlow "Flux enthalpique à masse constante"

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Paramètres de commande
parameter Boolean use_Qv_in=false "Débit volumique commandé"   annotation(Evaluate=true,HideResult=true,Dialog(group="Commande"),choices(choice=true "oui",
                                                                                            choice=false
        "non (constant)",                                                                                                    radioButtons=true));
parameter Real Qv=0
    "Débit de ventilation et/ou d'infiltrations constant [m3/h]"                                                          annotation(Dialog(group="Commande",enable=not use_Qv_in));

// Propriétés de l'air
parameter Modelica.SIunits.Density rhoair = 1.24 "Densité de l'air" annotation(Dialog(group="Propriétés de l'air"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp=1005 "Cp de l'air" annotation(Dialog(group="Propriétés de l'air"));

// Connecteur public
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Scénario du débit de ventilation commandé [m3/h]"
                                       annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,44}),                           iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,88})));

// Connecteur interne
protected
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";

equation
connect(Qv_in, Qv_in_internal);

  if not use_Qv_in then
    Qv_in_internal= Qv;
  end if;

Q_flow = Qv_in_internal/3600*rhoair*Cp*port_a.T;

  annotation (
Documentation(info="<html>
<h4>Modèle de flux enthalpique à masse constante tiré de CLIM 2000 (TF 101)</h4>
<p>Ce modèle calcule un flux enthalpique entre 2 pièces à des températures différentes, en supposant un bilan de masse respecté. Un seul échange enthalpique, <u>orienté de l'amont vers l'ava</u>l, est modélisé.</p>
<p>La valeur du débit volumique peut être commandé ou fixe durant toute la simulation.</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le débit enthalpique entre la zone thermique et l'extérieur est définie comme suit :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-PDJSex77.png\" alt=\"Q_flow=rho*(Q_v/3600)*c_p*T_amont\"/></p>
<ul>
<li>les variations d'énergies potentielle et cinétique de l'air sont négligées : <img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-Gefs5rIZ.png\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-SBxQyO58.png\"/></li>
<li>le travail mécanique échangé avec les parois solides est nul : <img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-KzWFZkpI.png\"/></li>
<li>la température de l'air est uniforme pour l'ensemble de la pièce : Tair uniforme</li>
<li>la chaleur massique de l'air est considérée constante et uniforme : Cp = constante</li>
<li>la masse volumique d'une zone d'air est constante et uniforme : rho = constante.</li>
</ul>
<p>Le système considéré est le suivant : on fait transvaser une quantité d'air de la zone A (amont) à température port_a.T et à masse volumique rho vers la zone B (aval). La variation d'enthalpie est due uniquement à la différence de température entre ces zones.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Note du type formel CLIM 2000. Février 2002.</p>
<p>CLIM2000 : étude du renouvellement d'air, C. Rogari , Rapport de stage 3ème année ESIP-EDF. Juin1990.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>La conservation de la masse dans une zone est impérative et est laissée au soin de l'utilisateur, sinon le travail de transvasement (PdV) ne peux être considéré comme nul. Par construction, ce modèle ne peut l'assurer. A titre d'exemple, pour une zone échangant de l'air avec l'extérieur il faudrait employer 2 modèles tête-bêche. De même, ce modèle ne peut pas être utilisé seul en monozone.</p>
<p>Pour plus d'informations voir le mode d'emploi de TF101 de CLIM2000.</p>
<p><br><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Employer ce type de modélisation que pour des différences de température inférieure à 5&deg;C. Au delà, préférer les modèles en pression et température, qui offrent une modélisation plus juste.</p>
<p>Précaution liée à la conservation de la masse.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Validation unitaire entre un noeud d'air et une condition limite. Gilles Plessis 02/2012.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 10/2011 : Suppresion du paramètre V volume de la zone d'air amont par rapport au modèle CLIM2000.</p>
<p>Gilles Plessis 02/2012 : Modification du modèle pour permettre un scénario de ventilation fixe ou commandé.</p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),      graphics={
        Polygon(
          points={{64,74},{80,60},{60,60},{64,74}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,60},{0,80},{80,60}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-30,0},
          rotation=90),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={0,-30},
          rotation=180),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={30,0},
          rotation=270),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={0,30},
          rotation=360),
        Ellipse(extent={{-60,60},{60,-60}}, lineColor={0,0,0}),
        Ellipse(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(graphics));
end EnthalpyFlow;
