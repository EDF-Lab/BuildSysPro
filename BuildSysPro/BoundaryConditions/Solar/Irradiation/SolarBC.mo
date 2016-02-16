within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model SolarBC "Calcul de conditions limites solaires"
// Paramètres

parameter Modelica.SIunits.Area[5] SurfacesVitrees
    "Surfaces vitrées (Plafond, Nord, Sud, Est, Ouest)"
                                 annotation(dialog(group="Vitrage"));
parameter Real TrDir=0.544
    "Coefficient de transmission direct de la fenêtre à incidence normale"
                                                                            annotation(dialog(group="Vitrage"));
parameter Integer Choix=2 "Formule utilisée" annotation(choices(
        choice=1 "Fauconnier",
        choice=2 "RT",
        choice=3 "Cardonnel",
        choice=4 "Linéaire avec cosi"),dialog(group="Vitrage"));
parameter Modelica.SIunits.Area[5] SurfacesExterieures
    "Surface des parois déperditives extérieures (Plafond,Nord, Sud, Est, Ouest)"
                                 annotation(dialog(group="Parois"));
  parameter Real beta=0
    "Correction de l'azimut des murs verticaux telle que azimut=beta+azimut, {beta=0 : N=180,S=0,E=-90,O=90})";
  parameter Real albedo=0.2 "Albedo de l'environnement";
// Composants publiques
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxAbsParois
    "Flux solaire surfacique sur les parois" annotation (Placement(
        transformation(extent={{60,50},{100,90}}), iconTransformation(extent={{
            80,-70},{100,-50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput
    FluxAbsVitrage "Flux solaire surfacique sur les vitrages" annotation (
      Placement(transformation(extent={{60,-20},{100,20}}), iconTransformation(
          extent={{80,10},{100,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxTrVitrage
    "Flux solaire transmis surfacique (doit tenir compte de l'influence de l'incidence)"
    annotation (Placement(transformation(extent={{60,-90},{100,-50}}),
        iconTransformation(extent={{80,70},{100,90}})));

// Composants internes
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(albedo=
        albedo, beta=beta)
    annotation (Placement(transformation(extent={{-90,-24},{-46,20}})));

  BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans transDirectNord(TrDir=
        TrDir, choix=Choix)
    annotation (Placement(transformation(extent={{0,-68},{20,-48}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans transDirectSud(TrDir=
        TrDir, choix=Choix)
    annotation (Placement(transformation(extent={{0,-92},{20,-72}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans transDirectEst(TrDir=
        TrDir, choix=Choix)
    annotation (Placement(transformation(extent={{0,-116},{20,-96}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans transDirectOuest(TrDir=
        TrDir, choix=Choix)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans transDirectPlafond(TrDir=
        TrDir, choix=Choix)
    annotation (Placement(transformation(extent={{0,-42},{20,-22}})));

  Modelica.Blocks.Math.Add addPlafond(k2=TrDir)
    annotation (Placement(transformation(extent={{30,-48},{50,-28}})));
  Modelica.Blocks.Math.Add addNord(k2=TrDir)
    annotation (Placement(transformation(extent={{30,-74},{50,-54}})));
  Modelica.Blocks.Math.Add addSud(k2=TrDir)
    annotation (Placement(transformation(extent={{30,-98},{50,-78}})));
  Modelica.Blocks.Math.Add addOuest(k2=TrDir)
    annotation (Placement(transformation(extent={{30,-146},{50,-126}})));
  Modelica.Blocks.Math.Add addEst(k2=TrDir)
    annotation (Placement(transformation(extent={{30,-122},{50,-102}})));
  Modelica.Blocks.Math.MultiSum multiSumTransVitrages(nu=5, k=SurfacesVitrees/sum(
         SurfacesVitrees)/TrDir)
    annotation (Placement(transformation(extent={{60,-76},{72,-64}})));
  Modelica.Blocks.Math.MultiSum multiSumAbsVitrages(nu=10, k={SurfacesVitrees[1]/
        sum(SurfacesVitrees),SurfacesVitrees[1]/sum(SurfacesVitrees),SurfacesVitrees[2]/
        sum(SurfacesVitrees),SurfacesVitrees[2]/sum(SurfacesVitrees),SurfacesVitrees[3]/
        sum(SurfacesVitrees),SurfacesVitrees[3]/sum(SurfacesVitrees),SurfacesVitrees[4]/
        sum(SurfacesVitrees),SurfacesVitrees[4]/sum(SurfacesVitrees),SurfacesVitrees[5]/
        sum(SurfacesVitrees),SurfacesVitrees[5]/sum(SurfacesVitrees)})
    annotation (Placement(transformation(extent={{60,-6},{72,6}})));
  Modelica.Blocks.Math.MultiSum multiSumAbsParois(
                             nu=10, k={SurfacesExterieures[1]/sum(SurfacesExterieures),
        SurfacesExterieures[1]/sum(SurfacesExterieures),SurfacesExterieures[2]/sum(SurfacesExterieures),
        SurfacesExterieures[2]/sum(SurfacesExterieures),SurfacesExterieures[3]/sum(SurfacesExterieures),
        SurfacesExterieures[3]/sum(SurfacesExterieures),SurfacesExterieures[4]/sum(SurfacesExterieures),
        SurfacesExterieures[4]/sum(SurfacesExterieures),SurfacesExterieures[5]/sum(SurfacesExterieures),
        SurfacesExterieures[5]/sum(SurfacesExterieures)})
    annotation (Placement(transformation(extent={{60,64},{72,76}})));
public
Modelica.Blocks.Interfaces.RealInput G[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut,Hauteur}"
    annotation (Placement(transformation(extent={{-119,69},{-79,109}},
        rotation=0), iconTransformation(extent={{-99,69},{-79,89}})));

equation
// Calcul des flux transmis par les vitrages
  connect(fLUXzone.FLUXNord, transDirectNord.FLUX) annotation (Line(
      points={{-43.8,7.24},{-24,7.24},{-24,-57.6},{-1,-57.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, transDirectSud.FLUX) annotation (Line(
      points={{-43.8,-1.12},{-24,-1.12},{-24,-81.6},{-1,-81.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, transDirectEst.FLUX) annotation (Line(
      points={{-43.8,-9.92},{-24,-9.92},{-24,-105.6},{-1,-105.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, transDirectOuest.FLUX) annotation (Line(
      points={{-43.8,-18.72},{-24,-18.72},{-24,-129.6},{-1,-129.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond, transDirectPlafond.FLUX) annotation (Line(
      points={{-43.8,16.48},{-24,16.48},{-24,-31.6},{-1,-31.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(transDirectPlafond.Direct, addPlafond.u1) annotation (Line(
      points={{21,-31.8},{23.5,-31.8},{23.5,-32},{28,-32}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond[1], addPlafond.u2) annotation (Line(
      points={{-43.8,15.0133},{-24,15.0133},{-24,-44},{28,-44}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(transDirectNord.Direct, addNord.u1) annotation (Line(
      points={{21,-57.8},{23.5,-57.8},{23.5,-58},{28,-58}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord[1], addNord.u2) annotation (Line(
      points={{-43.8,5.77333},{-24,5.77333},{-24,-70},{28,-70}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(transDirectSud.Direct, addSud.u1) annotation (Line(
      points={{21,-81.8},{23.5,-81.8},{23.5,-82},{28,-82}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud[1], addSud.u2) annotation (Line(
      points={{-43.8,-2.58667},{-24,-2.58667},{-24,-94},{28,-94}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(transDirectEst.Direct, addEst.u1) annotation (Line(
      points={{21,-105.8},{23.5,-105.8},{23.5,-106},{28,-106}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(transDirectOuest.Direct, addOuest.u1) annotation (Line(
      points={{21,-129.8},{24.5,-129.8},{24.5,-130},{28,-130}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst[1], addEst.u2) annotation (Line(
      points={{-43.8,-11.3867},{-24,-11.3867},{-24,-118},{28,-118}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest[1], addOuest.u2) annotation (Line(
      points={{-43.8,-20.1867},{-24,-20.1867},{-24,-142},{28,-142}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(multiSumTransVitrages.y, FluxTrVitrage)
                                     annotation (Line(
      points={{73.02,-70},{80,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addPlafond.y, multiSumTransVitrages.u[1])
                                       annotation (Line(
      points={{51,-38},{56,-38},{56,-66.64},{60,-66.64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addNord.y, multiSumTransVitrages.u[2])
                                    annotation (Line(
      points={{51,-64},{56,-64},{56,-68.32},{60,-68.32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addSud.y, multiSumTransVitrages.u[3])
                                   annotation (Line(
      points={{51,-88},{56,-88},{56,-70},{60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addEst.y, multiSumTransVitrages.u[4])
                                   annotation (Line(
      points={{51,-112},{56,-112},{56,-71.68},{60,-71.68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addOuest.y, multiSumTransVitrages.u[5])
                                     annotation (Line(
      points={{51,-136},{56,-136},{56,-73.36},{60,-73.36}},
      color={0,0,127},
      smooth=Smooth.None));
// Calcul des flux absorbés par le vitrages
  connect(multiSumAbsVitrages.y, FluxAbsVitrage)   annotation (Line(
      points={{73.02,0},{80,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond[1], multiSumAbsVitrages.u[1])   annotation (Line(
      points={{-43.8,15.0133},{40,15.0133},{40,3.78},{60,3.78}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond[2], multiSumAbsVitrages.u[2])   annotation (Line(
      points={{-43.8,16.48},{40,16.48},{40,2.94},{60,2.94}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord[1], multiSumAbsVitrages.u[3])   annotation (Line(
      points={{-43.8,5.77333},{40,5.77333},{40,2.1},{60,2.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord[2], multiSumAbsVitrages.u[4])   annotation (Line(
      points={{-43.8,7.24},{40,7.24},{40,1.26},{60,1.26}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud[1], multiSumAbsVitrages.u[5])   annotation (Line(
      points={{-43.8,-2.58667},{60,-2.58667},{60,0.42}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud[2], multiSumAbsVitrages.u[6])   annotation (Line(
      points={{-43.8,-1.12},{-24,-2},{60,-0.42}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst[1], multiSumAbsVitrages.u[7])   annotation (Line(
      points={{-43.8,-11.3867},{40,-11.3867},{40,-1.26},{60,-1.26}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst[2], multiSumAbsVitrages.u[8])   annotation (Line(
      points={{-43.8,-9.92},{40,-9.92},{40,-2.1},{60,-2.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest[1], multiSumAbsVitrages.u[9])   annotation (Line(
      points={{-43.8,-20.1867},{-24,-20.1867},{-24,-10},{40,-10},{40,-2.94},
          {60,-2.94}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest[2], multiSumAbsVitrages.u[10])   annotation (Line(
      points={{-43.8,-18.72},{-24,-18.72},{-24,-10},{40,-10},{40,-3.78},{60,
          -3.78}},
      color={255,192,1},
      smooth=Smooth.None));

// Calcul des flux absorbés par les parois
  connect(multiSumAbsParois.y, FluxAbsParois) annotation (Line(
      points={{73.02,70},{80,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond[1], multiSumAbsParois.u[1]) annotation (Line(
      points={{-43.8,15.0133},{-24,15.0133},{-24,96},{40,96},{40,73.78},
          {60,73.78}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXPlafond[2], multiSumAbsParois.u[2]) annotation (Line(
      points={{-43.8,16.48},{-24,16.48},{-24,94},{40,94},{40,72.94},{60,72.94}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord[1], multiSumAbsParois.u[3]) annotation (Line(
      points={{-43.8,5.77333},{-24,5.77333},{-24,92},{40,92},{40,72.1},{
          60,72.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord[2], multiSumAbsParois.u[4]) annotation (Line(
      points={{-43.8,7.24},{-24,7.24},{-24,90},{40,90},{40,71.26},{60,71.26}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud[1], multiSumAbsParois.u[5]) annotation (Line(
      points={{-43.8,-2.58667},{-24,-2.58667},{-24,86},{40,86},{40,70.42},
          {60,70.42}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud[2], multiSumAbsParois.u[6]) annotation (Line(
      points={{-43.8,-1.12},{-24,-1.12},{-24,82},{40,82},{40,69.58},{60,
          69.58}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst[1], multiSumAbsParois.u[7]) annotation (Line(
      points={{-43.8,-11.3867},{-24,-11.3867},{-24,78},{40,78},{40,68.74},
          {60,68.74}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst[2], multiSumAbsParois.u[8]) annotation (Line(
      points={{-43.8,-9.92},{-24,-9.92},{-24,74},{40,74},{40,67.9},{60,67.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest[1], multiSumAbsParois.u[9]) annotation (Line(
      points={{-43.8,-20.1867},{-24,-20.1867},{-24,70},{40,70},{40,67.06},
          {60,67.06}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest[2], multiSumAbsParois.u[10]) annotation (Line(
      points={{-43.8,-18.72},{-24,-18.72},{-24,70},{40,70},{40,66.22},{60,66.22}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(fLUXzone.G, G) annotation (Line(
      points={{-91.98,-2.22},{-98,-2.22},{-98,68},{-58,68},{-58,89},{-99,89}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}},      preserveAspectRatio=false),
                    graphics={       Ellipse(
          extent={{-95,94},{14,-16}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20.5,94},{20.5,6},{8.5,6},{8.5,94},{20.5,94}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={80.5,-6},
          rotation=180),
        Polygon(
          points={{-55,-17.5},{-43,2.5},{45,2.5},{33,-17.5},{-55,-17.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          origin={42.5,-45},
          rotation=90),
        Polygon(
          points={{33,-5.5},{45,14.5},{45,2.5},{33,-17.5},{33,-5.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={54.5,-45},
          rotation=90),
        Polygon(
          points={{33,-5.5},{45,14.5},{45,8.5},{33,-11.5},{33,-5.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={54.5,55},
          rotation=90),
        Polygon(
          points={{-55,-17.5},{-43,2.5},{45,2.5},{33,-17.5},{-55,-17.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          origin={42.5,55},
          rotation=90),
        Polygon(
          points={{20.5,94},{20.5,6},{14.5,6},{14.5,94},{20.5,94}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={80.5,94},
          rotation=180),
        Polygon(
          points={{20.5,94},{20.5,6},{12.5,6},{12.5,94},{20.5,94}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={84.5,-6},
          rotation=180),
        Polygon(
          points={{33,-5.5},{45,14.5},{45,6.5},{33,-13.5},{33,-5.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={58.5,-45},
          rotation=90)}),
    Documentation(info="<html>
<h4>Calcul des conditions limites solaires pour le modèle de bâtiment simplifié</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle permet le calcul des conditions limites solaires pour le modèle simplifié de bâtiment. Le modèle simplifié ne possède que 3 entrées courte longueur d'onde (CLO) : </p>
<ul>
<li>le flux CLO pour le calcul des flux transmis par les vitrages (prend en compte l'impact de l'angle d'incidence sur le flux direct mais pas le coefficient de transmission normal du vitrage)</li>
<li>le flux CLO absorbé par les vitrages</li>
<li>le flux CLO absorbé par les parois.</li>
</ul>
<p>L'impact de l'angle d'incidence sur le flux direct transmis est pris en compte grâce au paramètre <code><span style=\"font-family: Courier New,courier;\">Choix </span></code>et au modèle <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans\">DirectTrans</a>.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Néant.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Le port d'entrée <code><span style=\"font-family: Courier New,courier;\">Gh</span></code> doit être relié au bloc météo.</p>
<p>Les flux solaires<code><span style=\"font-family: Courier New,courier;\"> FluxAbsParois, FluxAbsVitrage et FluxTrVitrage</span></code> doivent être connectés à un modèle de bâtiment simplifié.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis 03/2013.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 12/2013 : Mise à jour des noms des paramètres SurfaceVitree-&GT;SurfacesVitrees et SurfaceExterieures-&GT;SurfacesExterieures</p>
</html>"));
end SolarBC;
