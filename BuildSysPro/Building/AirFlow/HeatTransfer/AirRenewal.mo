within BuildSysPro.Building.AirFlow.HeatTransfer;
model AirRenewal "Modèle de renouvellement d'air"

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Paramètres de commande
parameter Boolean use_Qv_in=false "Débit volumique commandé"   annotation(Evaluate=true,HideResult=true,Dialog(group="Commande"),choices(choice=true "oui",
                                                                                            choice=false
        "non (constant)",                                                                                                    radioButtons=true));

// Puissance électrique
parameter Boolean use_Pelec=false
    "Calcul de la puissance électrique liée à la ventilation"                                 annotation(Evaluate=true,HideResult=true,Dialog(group="Puissance électrique"),choices(choice=true "oui",
                                                                                            choice=false "non",   radioButtons=true));
parameter Real Qv=0
    "Débit de ventilation et/ou d'infiltrations constant [m3/h]"                                                          annotation(Dialog(group="Commande",enable=not use_Qv_in));

parameter Real Pelec_spe=0.334 "Puissance électrique spécifique [W/m3.h]"
    annotation(Dialog(group="Puissance électrique",enable=use_Pelec));

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
  Modelica.Blocks.Interfaces.RealOutput PelecVentil if use_Pelec
    "Puissance électrique de ventilation (W)"
    annotation (Placement(transformation(extent={{86,26},{126,66}}),
        iconTransformation(extent={{88,40},{108,60}})));

// Connecteur interne
protected
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";

  Modelica.Blocks.Math.Gain CalcPelec(k=Pelec_spe) if use_Pelec
    "Conversion du debit (m3/h) en Pelec (W)"
    annotation (Placement(transformation(extent={{46,36},{66,56}})));

equation
connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;

  end if;

  Q_flow = rhoair*Cp*(Qv_in_internal/3600)*dT;

  if use_Pelec then
  connect(Qv_in_internal, CalcPelec.u);
  connect(CalcPelec.y, PelecVentil);
  end if;

   annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-110,-98},{112,-136}},
          lineColor={0,0,0},
          textString="%name"),
        Line(
          points={{-80,-10},{0,10},{80,-10}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={0,-70},
          rotation=180),
        Polygon(
          points={{-6,7},{10,-7},{-10,-7},{-6,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-70,-67},
          rotation=180),
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
    Documentation(info="<html>
<h4>Renouvellement d'air simple pour monozone tiré de CLIM 2000 (TF 5)</h4>
<p>Ce modèle calcule un flux enthalpique entre un monozone et l'extérieur. Il considère le bilan de masse comme respecté.</p>
<p>La valeur du débit volumique peut être commandé ou fixe durant toute la simulation.</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Le débit enthalpique entre la zone thermique et l'extérieur est définie comme suit :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-6ZmrjEsS.png\" alt=\"Q_flow = rho*(Q_v/3600)*c_p*Delta.T\"/></p>
<ul>
<li>la température de l'air est uniforme pour l'ensemble de la pièce : Tair uniforme</li>
<li>la chaleur massique de l'air est considérée constante : Cp = constante</li>
<li>la masse volumique d'une zone d'air est constante : rho = constante.</li>
</ul>
<p>Concernant le calcul de la puissance électrique liée à la ventilation, la valeur par défaut de la puissance électrique spécifique (0.334 W/m3.h) correspond à la puissance d'un ventilateur (extraction).</p>
<p><u><b>Bibliographie</b></u></p>
<p>Note du type formel TF5 de CLIM 2000.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Il n'y a pas de sens a priori pour la connection des ports thermiques. Le <i>port_a</i> peut être connecté au port thermique d'un bloc météo et le <i>port_b </i>au port thermique d'une zone ou inversement. Pour l'utilisation de la commande de scénario de ventilation (<code><span style=\"font-family: Courier New,courier;\">use_Qv_in=true</span></code>) connecté une source réelle au RealInput nommé <code><span style=\"font-family: Courier New,courier;\">Qv_in.</span></code></p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Ce modèle décrit le transfert thermique correspondant au renouvellement d'air (ponts thermiques, infiltrations, ...). Ce composant est particulièrement important en période de chauffage. Il peut représenter aussi bien un renouvellement d'air entre un local et l'extérieur, qu'un renouvellement d'air entre deux locaux. Pour des différences de température importantes, préférer un modèle en pression et température.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Validation unitaire entre un noeud d'air et une condition limite. Gilles Plessis 02/2012.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Ajout du calcul de la puissance électrique liée à la ventilation, activable depuis un booléen. La puissance calculée est accessible pour les deux modes : débit commandé ou non.</p>
</html>"));
end AirRenewal;
