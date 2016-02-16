within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model FLUXsurfLWRinc
  "Calcul de l'éclairement incident global incident au temps t sur une surface inclinée avec choix des flux donnés en entrée"

  FLUXsurf fLUXsurf(
    albedo=albedo,
    azimut=azimut,
    incl=incl,
    diffus_isotrope=diffus_isotrope)
    annotation (Placement(transformation(extent={{-62,-10},{-32,20}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{44,-2},{58,12}})));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°";
  parameter Real albedo=0.2 "Albedo de l'environnement";
  parameter Integer diffus_isotrope=1
    "1 - modèle de diffus isotrope ; 2 - modèle de diffus circumsolaire (Hay Davies Kluch Reindl)"
    annotation (dialog(
      compact=true), choices(
      choice=1 "Diffus isotrope",
      choice=0 "Diffus HDKR (prise en compte du circumsolaire)",
      radioButtons=true));

Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut,Hauteur"
    annotation (Placement(transformation(extent={{-120,-18},{-80,22}},
        rotation=0), iconTransformation(extent={{-120,-10},{-100,10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUX
    "Flux solaire surfacique incident global" annotation (Placement(
        transformation(extent={{65,-12},{99,22}}, rotation=0),
        iconTransformation(extent={{100,-11},{120,9}})));
equation
  connect(fLUXsurf.FLUX[1], add.u1) annotation (Line(
      points={{-30.5,3.85},{-12.25,3.85},{-12.25,9.2},{42.6,9.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf.FLUX[2], add.u2) annotation (Line(
      points={{-30.5,4.85},{-12.25,4.85},{-12.25,0.8},{42.6,0.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUX, add.y) annotation (Line(
      points={{82,5},{70,5},{70,5},{58.7,5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(G, fLUXsurf.G) annotation (Line(
      points={{-100,2},{-82,2},{-82,5},{-63.5,5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
        Polygon(
          points={{-100,-83},{100,-23},{100,-42},{-100,-100},{-100,-83}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-92,81},{41,-53}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,104},{98,51}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Az = %azimut °"),
        Text(
          extent={{-128,60},{88,19}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Incl = %incl °")}),
    Documentation(revisions="<html>
<p>Aurélie Kaemmerlen 05/2011 : Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</p>
<p>Hassan Bouia 03/2013 : simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Amy Lindsay 03/2013 : ajout du paramètre diffus_isotrope pour choisir entre un modèle de diffus isotrope ou le modèle de diffus HDKR</p>
</html>", info="<html>
<p>Modèle à intégré en option dans FLUXsurf - Aurélie</p>
<p><b>Nouveauté !</b> Il est possible de choisir quel modèle de diffus utiliser. Le modèle diffus isotrope est considéré plus conservateur (tendance à sous-estimer le rayonnement incident sur un plan incliné) mais est plus simple d'utilisation. Le modèle diffus Hay Davies Klucher Reindl (HDKR) est à privilégier dans les applications solaires (photovolta&iuml;que, solaire thermique...).</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>"));
end FLUXsurfLWRinc;
