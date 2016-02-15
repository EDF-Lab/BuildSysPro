within BuildSysPro.Systems.HVAC.HeatExchangers;
model Air2AirSimplifiedHeatEx

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Paramètres de commande
parameter Boolean use_Qv_in=false "Débit volumique commandé"
annotation(Evaluate=true,HideResult=true,Dialog(group="Commande"),
choices(choice=true "oui", choice=false "non (constant)", radioButtons=true));
parameter Boolean use_Efficacite_in=false "Efficacité commandée"
annotation(Evaluate=true,HideResult=true,Dialog(group="Commande"),
choices(choice=true "oui", choice=false "non (constant)", radioButtons=true));
parameter Real Qv=0 "Débit de ventilation constant [m3/h]"
    annotation(Dialog(group="Commande",enable=not use_Qv_in));
parameter Real Efficacite=0.5 "Efficacité de l'échangeur constante [0-1]"
    annotation(Dialog(group="Commande",enable=not use_Efficacite_in));

// Propriétés de l'air
parameter Modelica.SIunits.Density rho=1.24 "densité de l'air"
                                                               annotation(Dialog(group="Propriétés de l'air"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp=1005 "Cp de l'air"
                                                                     annotation(Dialog(group="Propriétés de l'air"));

// Connecteurs publics
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Scénario du débit de ventilation commandé [m3/h]"
                                     annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={52,80}),                          iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={48,28})));
Modelica.Blocks.Interfaces.RealInput Efficacite_in if use_Efficacite_in
    "Scénario de l'efficacité du double flux [0-1]"
                                     annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-30,80}),                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-54,28})));

Modelica.SIunits.Temperature Tentree "Température d'entrée de l'échangeur";

// Connecteurs internes
protected
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";
Modelica.Blocks.Interfaces.RealInput Efficacite_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";

equation
  connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;
  end if;

  connect(Efficacite_in, Efficacite_in_internal);
  if not use_Efficacite_in then
    Efficacite_in_internal= Efficacite;
  end if;

 Tentree = Efficacite_in_internal* port_b.T  + (1-Efficacite_in_internal)* port_a.T;
 Q_flow = rho * Cp * (Qv_in_internal/3600) *(Tentree-port_b.T);

  annotation (
Documentation(info="<html>
<h4>Modèle d'échangeur simplifié en thermique pure considérant une efficacité d'échangeur et un débit de ventilation</h4>
<p>La valeur du débit volumique peut être commandée ou fixe durant toute la simulation de même que l'efficacité de l'échangeur.</p>
<p><i>Remarque : modification d'un ancien modèle d'échangeur dont le débit était donné en vol/h au lieu des m3/h de ce modèle.</i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p><u><b>Bibliographie</b></u></p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Le port_a est à connecter à la température extérieure et le port_b à l'intérieur</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Lou Chesne 10/2011 - Aurélie Kaemmerlen 10/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Lou CHESNE, Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),      graphics={
        Line(
          points={{-78,8},{74,8},{64,14}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,8},{74,8},{64,2}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-6},{74,-6},{64,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-6},{74,-6},{64,-12}},
          color={0,128,255},
          smooth=Smooth.None)}),
    DymolaStoredErrors,
    Diagram(graphics));
end Air2AirSimplifiedHeatEx;
