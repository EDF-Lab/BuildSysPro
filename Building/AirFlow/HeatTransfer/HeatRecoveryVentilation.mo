within BuildSysPro.Building.AirFlow.HeatTransfer;
model HeatRecoveryVentilation "Modèles de double flux avec bypass"

// Paramètres de commande

parameter Boolean use_Qv_in=false "Débit volumique commandé"   annotation(Evaluate=true,HideResult=true,Dialog(group="Commande"),choices(choice=true "oui",
                                                                                            choice=false
        "non (constant)",                                                                                                    radioButtons=true));

parameter Boolean use_Efficacite_in=false "Efficacité commandée" annotation(Evaluate=true,HideResult=true,Dialog(group="Commande"),choices(choice=true "oui", choice=false
        "non (constant)",                                                                                                    radioButtons=true));
// Puissance électrique
parameter Boolean use_Pelec=false
    "Calcul de la puissance électrique liée à la ventilation"                                 annotation(Evaluate=true,HideResult=true,Dialog(group="Puissance électrique"),choices(choice=true "oui",
                                                                                            choice=false "non",   radioButtons=true));
// Paramètres
parameter Real Qv=0 "Débit de ventilation constant [m3/h]"
    annotation(Dialog(group="Commande",enable=not use_Qv_in));

parameter Real Efficacite=0.5 "Efficacité de l'échangeur constante [0-1]"
    annotation(Dialog(group="Commande",enable=not use_Efficacite_in));

parameter Real Pelec_spe=0.667 "Puissance électrique spécifique [W/m3.h]"
    annotation(Dialog(group="Puissance électrique",enable=use_Pelec));
// Propriétés de l'air
parameter Modelica.SIunits.Density rho=1.24 "densité de l'air"
                                                               annotation(Dialog(group="Propriétés de l'air"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp=1005 "Cp de l'air"
                                                                     annotation(Dialog(group="Propriétés de l'air"));

  // Composants

public
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Scénario du débit de ventilation commandé [m3/h]"
                                       annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={80,100}),                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,90})));
  Modelica.Blocks.Interfaces.RealInput Efficacite_in if use_Efficacite_in
    "Scénario de l'efficacité du double flux [0-1]"
                                     annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}),                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,90})));
  Modelica.Blocks.Interfaces.BooleanInput Bypass
    "True : Bypass /  False : pas de Bypass" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-80,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,90})));

protected
  BuildSysPro.Systems.HVAC.HeatExchangers.Air2AirSimplifiedHeatEx
    echangeurSimplifie(
    use_Qv_in=true,
    use_Efficacite_in=true,
    rho=rho,
    Cp=Cp) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,52})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-72,60},{-52,80}})));
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";
  Modelica.Blocks.Interfaces.RealInput Efficacite_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";
  Modelica.Blocks.Math.Gain CalcPelec(k=Pelec_spe) if use_Pelec
    "Conversion du debit (m3/h) en Pelec (W)"
    annotation (Placement(transformation(extent={{46,36},{66,56}})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Blocks.Interfaces.RealOutput PelecVentil if use_Pelec
    "Puissance électrique de ventilation (W)"
    annotation (Placement(transformation(extent={{86,26},{126,66}}),
        iconTransformation(extent={{88,40},{108,60}})));

equation
  connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;
  end if;
  connect(echangeurSimplifie.Qv_in, Qv_in_internal);

  connect(Efficacite_in, Efficacite_in_internal);
  if not use_Efficacite_in then
    Efficacite_in_internal= Efficacite;
  end if;
  connect(Efficacite_in_internal, switch1.u3);
  connect(switch1.y, echangeurSimplifie.Efficacite_in) annotation (Line(
      points={{-15,52},{-8,52},{-8,2.8},{-7.4,2.8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Bypass, switch1.u2) annotation (Line(
      points={{-80,100},{-80,52},{-38,52}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(const1.y, switch1.u1) annotation (Line(
      points={{-51,70},{-48,70},{-48,60},{-38,60}},
      color={0,0,127},
      smooth=Smooth.None));
  if use_Pelec then
  connect(Qv_in_internal, CalcPelec.u);
  connect(CalcPelec.y, PelecVentil);
  end if;

  connect(echangeurSimplifie.port_b, port_b) annotation (Line(
      points={{7,0},{48,0},{48,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(echangeurSimplifie.port_a, port_a) annotation (Line(
      points={{-11,0},{-90,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
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
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4>Modèle de double flux simplifié en thermique pure avec bypass</h4>
<p>Ce modèle est une surcouche du modèle d'échangeur simplifié avec l'intégration d'une commande de bypass.</p>
<p>La valeur du débit volumique peut être commandée ou fixe durant toute la simulation de même que l'efficacité de l'échangeur.</p>
<p><br><u><b>Hypothèses et équations</b></u></p>
<p>Voir modèle d'échangeur simplifié..</p>
<p>Concernant le calcul de la puissance électrique liée à la ventilation, la valeur par défaut de la puissance électrique spécifique (0.667 W/m3.h) correspond à la puissance de deux ventilateurs (insuflation + extraction).</p>
<p><u><b>Bibliographie</b></u></p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Le port_a est à connecter à la température extérieure et le port_b à l'intérieur</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis 02/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Ajout du calcul de la puissance électrique liée à la ventilation, activable depuis un booléen. La puissance calculée est accessible pour les deux modes : débit commandé ou non.</p>
</html>"));
end HeatRecoveryVentilation;
