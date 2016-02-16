within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
model FLUXsurfMask
  "Flux solaire incident sur une surface possédant un masque solaire proche (vitrage notamment)"
parameter Boolean useEclairement=false
annotation(dialog(group="Paramètres généraux",compact=true),choices(choice=true
        "Avec calcul de l'éclairement naturel",                                                             choice=false
        "Sans calcul de l'éclairement naturel",                                                                                                  radioButtons=true));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°"
                                                                                              annotation(Dialog(group="Orientation de la surface"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°"
                                                                                                        annotation(Dialog(group="Orientation de la surface"));

parameter Real albedo=0.2 "Albedo de l'environnement" annotation(Dialog(group="Paramètre de l'environnement"));
parameter Integer diffus_isotrope=1
    "1 - modèle de diffus isotrope ; 2 - modèle de diffus circumsolaire (Hay Davies Kluch Reindl)"
    annotation (Dialog(group="Paramètre de l'environnement", compact=true), choices(
      choice=1 "Diffus isotrope",
      choice=0 "Diffus HDKR (prise en compte du circumsolaire)",
      radioButtons=true));

parameter Integer TypeMasque annotation(Dialog(group="Masques proches"),choices(choice=0
        "Masque intégral",                                                                                choice=1
        "Masque horizontal",choice=2 "Pas de masque proche", radioButtons=true));
        parameter Modelica.SIunits.Distance Av=0.5 "Avancée" annotation(Dialog(enable=TypeMasque<>2,group="Masques proches"));
parameter Modelica.SIunits.Distance Ha=0.3
    "Distance de l'auvent au rebord haut de la fenêtre"
                                                        annotation(Dialog(enable=TypeMasque<>2,group="Masques proches"));
parameter Modelica.SIunits.Distance Lf=1 "Largeur de la fenêtre"
                                                                 annotation(Dialog(enable=TypeMasque<>2,group="Masques proches"));
parameter Modelica.SIunits.Distance Hf=1 "Hauteur de la fenêtre"
                                                                 annotation(Dialog(enable=TypeMasque<>2,group="Masques proches"));
parameter Modelica.SIunits.Distance Dd=0.5 "Distance ou débord droit"
                                                                      annotation(Dialog(enable=TypeMasque<>2,group="Masques proches"));
parameter Modelica.SIunits.Distance Dg=0.5 "Distance ou débord gauche"
                                                                       annotation(Dialog(enable=TypeMasque<>2,group="Masques proches"));
parameter Boolean MasqueLointain=false
annotation(dialog(group="Masques lointains",compact=true),choices(choice=true
        "Avec masque lointain vertical",                                                             choice=false
        "Sans masque lointain vertical",                                                                                                  radioButtons=true));
parameter Modelica.SIunits.Distance dE=5
    "Distance de la paroi au masque lointain" annotation(Dialog(enable=MasqueLointain,group="Masques lointains"));
parameter Modelica.SIunits.Distance hpE=2 "Hauteur du masque lointain" annotation(Dialog(enable=MasqueLointain,group="Masques lointains"));
  Irradiation.FLUXsurf fLUXsurf(
    azimut=azimut,
    incl=incl,
    albedo=albedo,
    diffus_isotrope=diffus_isotrope)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Masks masques(
    azimut=azimut,
    Av=Av,
    Ha=Ha,
    Lf=Lf,
    Hf=Hf,
    Dd=Dd,
    Dg=Dg,
    TypeMasque=TypeMasque,
    MasqueLointain=MasqueLointain,
    useEclairement=useEclairement,
    dE=dE,
    hpE=hpE) annotation (Placement(transformation(extent={{-6,-10},{28,10}})));
  Interfaces.SolarFluxOutput FluxMasques[3]
    "Flux solaires surfaciques incidents après prise en compte de masques solaires au vitrage 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{60,-20},{100,20}}, rotation=0),
        iconTransformation(extent={{100,-12},{124,12}})));
Modelica.Blocks.Interfaces.RealInput G[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut,Hauteur}"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}},
        rotation=0), iconTransformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Eclairement naturel incident: direct, diffus et réfléchi " annotation (
      Placement(transformation(extent={{-120,-56},{-80,-16}}),
        iconTransformation(extent={{-100,-36},{-80,-16}})));
  Modelica.Blocks.Interfaces.RealOutput EclMasques[3] if useEclairement
    "Eclairement naturel incident après la prise en compte des masques -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{20,-56},{60,-16}}),
        iconTransformation(extent={{40,-36},{60,-16}})));
equation
  connect(fLUXsurf.FLUX, masques.FLUX) annotation (Line(
      points={{-39,-0.1},{-29.5,-0.1},{-29.5,0},{5.9,0}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf.AzHSol, masques.AzHSol) annotation (Line(
      points={{-39,8},{-30,8},{-30,5},{-4.81,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G, fLUXsurf.G) annotation (Line(
      points={{-100,10},{-80,10},{-80,0},{-61,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masques.FluxMasques, FluxMasques) annotation (Line(
      points={{30.04,0},{80,0}},
      color={255,192,1},
      smooth=Smooth.None));
  if useEclairement then
    connect(Ecl, masques.Ecl) annotation (Line(
        points={{-100,-36},{-20,-36},{-20,-5},{-4.81,-5}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(masques.EclMasques, EclMasques) annotation (Line(
        points={{24.09,-5},{30,-5},{30,-14},{12,-14},{12,-36},{40,-36}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;
  annotation (
    Documentation(info="<html>
<h4>Calcul des conditions limites solaires pour la surface de dimension (Lf x Hf) représentée dans les illustrations ci-dessous</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Les masques considérés sont :</p>
<ol>
<li>Les masques proches</li>
<li><ol>
<li>Les auvents (arête horizontale)</li>
<li>Les masques complets (arête + joue gauche et droite)</li>
</ol></li>
</ol>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/MasqueHorizontal.bmp\"/> <img src=\"modelica://BuildSysPro/Resources/Images/MasqueIntegral.bmp\"/> </p>
<ol>
<li>Les masques lointains verticaux </li>
</ol>
<p><u><b>Bibliographie</b></u></p>
<p>Norme ISO 13791</p>
<p><i>Intégration de la protection solaire dans le logiciel PAPTER</i>, M. ABDESSELAM, AIRab Consultant, Fevrier 2000 - Corrections effectuées car modèle incorrect</p>
<p>Norme RT2012 pour la prise en compte des masques lointains verticaux</p>
<p><u><b>Mode d'emploi</b></u></p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b> </u></p>
<ul>
<li>Ces modèles ne sont valables que pour des parois verticales</li>
<li>Le cumul de plusieurs types de masques proches pour une même paroi est interdit</li>
</ul>
<p><br><u><b>Validations effectuées</b></u></p>
<p>Modèle non validé (issu de la fusion des modèles FLUXsurf et MasquesProches pour en simplifier la saisie mais non testé) - Aurélie Kaemmerlen 11/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Benoît Charrier 05/2015 : adaptation du modèle pour l'intégration des masques lointains</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{30,34},{-70,34},{-70,-26},{30,-26},{30,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-70,-26},{-70,-26},{-80,-36},{-34,-26},{-70,-26}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,8},{30,-26}},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{30,34},{20,24},{20,-36},{30,-26},{30,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,34},{-80,24},{-80,-36},{-70,-26},{-70,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Polygon(
          points={{-70,34},{-80,24},{20,24},{30,34},{-70,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-70,-26},{20,24}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-48,14},{-2,-14}},
          fillColor={139,175,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,8},{-2,-14}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end FLUXsurfMask;
