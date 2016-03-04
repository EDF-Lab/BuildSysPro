within BuildSysPro.BaseClasses.HeatTransfer.Components;
model WindConvection
  "Coefficient d'échange convectif d'une paroi en fonction de la vitesse et direction du vent"
  extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

parameter Boolean VitesseVent=false
    "Prise en compte du vent dans le calcul du coefficient d'échange convectif extérieur"
  annotation(Dialog(compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));

parameter Boolean GLOext=false
    "Prise en compte du rayonnement infrarouge entre la paroi et le ciel"
    annotation(Dialog(compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));

parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=25
    "Coefficient d'échange surfacique sur la face extérieure - selon choix GLOext et VitesseVent il peut être purement convectif ou purement radiatif";

parameter Modelica.SIunits.Area S "Surface d'échange";
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
 parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°";

Modelica.Blocks.Interfaces.RealInput V[2] if VitesseVent
    "Vitesse [m/s] et direction du vent (provenance 0° - Nord, 90° - Est, 180° - Sud, 270° - Ouest)"
                                                                                                        annotation (Placement(transformation(
          extent={{-120,50},{-80,90}}), iconTransformation(extent={{-14,-14},{14,
            14}},
        rotation=-90,
        origin={0,74})));

protected
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hrad_cst = if GLOext then 0 else hs_ext;
protected
  Modelica.Blocks.Interfaces.RealInput V_in[2]
    "Connecteur interne requis dans le cas de connection conditionnelle";
public
 Modelica.SIunits.CoefficientOfHeatTransfer h_vent
    "Coefficient convectif extérieur";

public
function correlation
  input Real V[2] "Vitesse et direction du vent";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
      "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
      "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°";
  output Modelica.SIunits.CoefficientOfHeatTransfer h_vent
      "h convectif seul dû au vent";

//Coefficient a de l'équation hcv = a*v^n+b
  //Façade au vent
  protected
  parameter Real a1=3.06;
  parameter Real n1=1;
  parameter Real b1=5.44;
  //Façade sous le vent
  parameter Real a2=0.34;
  parameter Real n2=1;
  parameter Real b2=7.99;

  Boolean AuVent "Façade au vent si =true";

algorithm
  if incl<180 and incl >0 then
    AuVent := if cos((azimut+180-V[2])*Modelica.Constants.pi/180)>0 then true else false;
  else
    AuVent := false;
  end if;

  if AuVent then
    h_vent :=a1*max(0, V[1])^n1 + b1;
  else
    h_vent :=a2*max(0, V[1])^n2 + b2;
  end if;

  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end correlation;

equation
connect(V_in, V);
  if not VitesseVent then
    V_in= {0,0};
  end if;

if VitesseVent then
  h_vent = correlation(V=V_in, azimut=azimut, incl=incl);
  Q_flow =(h_vent+hrad_cst)*dT*S;
else
  h_vent = 0;
  Q_flow = hs_ext*dT*S;
end if;

annotation(Dialog(enable=VitesseVent),
           Dialog(enable=VitesseVent),
           Dialog(enable=VitesseVent),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                               graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),            graphics),
    Documentation(info="<html>
<p>Modèle permettant de calculer le coefficient de convection extérieur en fonction de la vitesse et direction du vent, pour une paroi verticale ou horizontale</p>
<p><br>La corrélation utilisée est celle issue de la fiche TF112 de CLIM2000 pour les deux cas de figure suivant : façade &QUOT;au vent&QUOT; et &QUOT;sous le vent&QUOT; (soit respectivement lorsque le vent est dirigé vers la paroi et lorsque le vent est dirigé dans une autre direction). Une façade horizontale sera automatiquement &QUOT;sous le vent&QUOT;.</p>
<p>Remarque : Il faudrait améliorer ce modèle pour disposer de corrélations différentes selon les cas (rugosité des surfaces, inclinaison, plages de direction du vent, ...)</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WindConvection;
