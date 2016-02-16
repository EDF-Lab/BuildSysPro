within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model NaturalIlluminance "Eclairement naturel transmis à une zone thermique"

parameter Real S_gr=100 "Surface totale du groupe (m²)";
parameter Real Aecl_nat=80
    "Surface du groupe ayant accès à la lumière naturelle (m²)";
protected
Real R_gr=4.5
    "Ratio de la surface totale des parois du groupe à la surface utile";
Real Flt1
    "Flux lumineux transmis au groupe par l'ensemble des baies vitrées du groupe sous forme directe (lumen)";
Real Flt2
    "Flux lumineux transmis au groupe par l'ensemble des baies vitrées du groupe sous forme hémisférique (lumen)";
Real Flt3
    "Flux lumineux transmis au groupe par l'ensemble des baies vitrées du groupe sous forme demi-hémisphérique (lumen)";
Real Flteq
    "Flux lumineux équivalent pénétrant dans les parties du groupe ayant accès à la lumière (lumen)";
Real C2;
public
parameter Real PinstEcl=1.4 "Puissance d'éclairage conventionnelle (W/m²)";
parameter Real C1=0.9
    "Taux d'utilisation de l'éclairage en absence d'éclairage naturel";
    parameter Real EclNatRef=200
    "Eclairement naturel de référence pour le local considéré";
parameter Real C2ref=0.05;

  Modelica.Blocks.Interfaces.RealInput FlumPlafond[3]
    "Flux lumineux incident venant du plafond -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-99,67}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,70})));
  Modelica.Blocks.Interfaces.RealInput FlumSud[3]
    "Flux lumineux incident de la fenêtre Sud -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-99,3}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-2})));
  Modelica.Blocks.Interfaces.RealInput FlumNord[3]
    "Flux lumineux incident de la fenêtre Nord -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-99,35}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,34})));
  Modelica.Blocks.Interfaces.RealInput FlumOuest[3]
    "Flux lumineux incident de la fenêtre Ouest -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-99,-63}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-72})));
  Modelica.Blocks.Interfaces.RealInput FlumEst[3]
    "Flux lumineux incident de la fenêtre Est -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-99,-29}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-38})));
  Modelica.Blocks.Interfaces.RealOutput EclNat
    "Eclairement naturel global transmis au groupe (lux)"
                                                    annotation (Placement(
        transformation(extent={{60,-39},{94,-5}}), iconTransformation(extent={{
            97,11},{123,37}})));
  Modelica.Blocks.Interfaces.RealOutput Pecl
    "Puissance d'éclairage à fournir (W)"
    annotation (Placement(transformation(extent={{60,7},{94,41}}),
        iconTransformation(extent={{97,-39},{123,-13}})));
  Modelica.Blocks.Interfaces.RealInput Occupation "Présence 1, absence 0"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=90,
        origin={-29,89}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-30,100})));
  Modelica.Blocks.Interfaces.RealInput ConsigneEclairage
    "Consigne d'éclairage (1=fonctionnement, 0=arrêt)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=90,
        origin={19,89}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={32,100})));

equation
  Flt1=FlumPlafond[1]+FlumSud[1]+FlumNord[1]+FlumOuest[1]+FlumEst[1];
  Flt2=FlumPlafond[2]+FlumSud[2]+FlumNord[2]+FlumOuest[2]+FlumEst[2];
  Flt3=FlumPlafond[3]+FlumSud[3]+FlumNord[3]+FlumOuest[3]+FlumEst[3];
  Flteq=0.2*Flt1+Flt2+0.6*Flt3;
  EclNat=(1.8*Flteq)/(R_gr*Aecl_nat*0.75);

  if EclNat < 100 then
    C2 = 1;
  elseif EclNat < EclNatRef then
    C2 = 1+(EclNat-100)*(C2ref-1)/(EclNatRef-100);
  elseif EclNat < 2800 then
    C2 = 0.05+(EclNat-EclNatRef)*(0-C2ref)/(2800-EclNatRef);
  else
    C2 = 0;
  end if;

  Pecl= PinstEcl*C1*C2*Occupation*S_gr*ConsigneEclairage;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={                   Ellipse(
          extent={{-83,84},{18,-18}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{16,-2},{38,-86},{62,-86},{84,-2},{16,-2}},
          smooth=Smooth.Bezier,
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid,
          lineColor={255,170,85}),
        Rectangle(
          extent={{45,-92},{55,-94}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{37,-76},{63,-92}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          radius=1),
        Line(
          points={{46,-76},{40,-48}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{54,-76},{60,-48}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-48,-72},{72,48}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{40,-48},{42,-42},{44,-54},{46,-42},{48,-54},{50,-42},{52,-54},
              {54,-42},{56,-54},{58,-42},{60,-48}},
          color={255,170,85},
          smooth=Smooth.None,
          thickness=0.5)}),
              Documentation(info="<html>
<p>Modèle de calcul de l'éclairement naturel transmis à une zone thermique</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>A partir des flux incidents sur chaque baie, on détermine les flux lumineux transmis sous forme directe, hémisphérique et demi-hémisphérique.</p>
<p>On en déduit ainsi le flux lumineux équivalent transmis à la zone et l'éclairement naturel global transmis à la zone.</p>
<p>Grâce à un seuil d'autonomie lumineuse, on arrive à déterminer la puissance en éclairage à fournir à chaque instant. </p>
<p><u><b>Bibliographie</b></u></p>
<p>Méthode Th-BCE RT 2012</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b> </u></p>
<p>Néant</p>
<p><br><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Laura Sudries 05/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Laura SUDRIES, Vincent MAGNAUDEIX, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Benoît Charrier 05/2015 : ajout du flux lumineux incident venant du plafond</p>
</html>"),                                                                    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1), graphics={Ellipse(
          extent={{-89,90},{20,-20}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,-54},{-20,-80}},
          lineColor={0,0,255},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,-54},{-54,-40},{21,-40},{-20,-54},{-96,-54}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{21,-40},{21,-66},{-20,-80},{-20,-54},{21,-40}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid)}),
              Icon(graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end NaturalIlluminance;
