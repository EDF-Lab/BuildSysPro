within BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones;
model ZoneEntrance

  // Choix de la RT
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "Réglementation thermique utilisée" annotation (
      choicesAllMatching=true, Dialog(group="Choix de la RT"));

  // Flux thermiques
parameter Boolean GLOEXT=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel"                            annotation(Dialog(tab="Flux thermiques"));
parameter Boolean QVin=false
    "True : commande du débit de renouvellement d'air ; False : débit constant"
                                                                                                annotation(Dialog(tab="Flux thermiques"));

  // Parois
parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale des parois"
    annotation(Dialog(tab="Parois"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialisation en régime stationnaire dans les parois"
    annotation (Dialog(tab="Parois"));

  // Ponts thermiques
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsEntree,
      TauPonts=paraMaisonRT.TauPonts) "Ponts thermiques"
    annotation (Dialog(tab="Ponts thermiques"));

    //Coefficients de pondération
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(b=
        paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlafond(b=
        paraMaisonRT.bSousCombles)
    annotation (Placement(transformation(extent={{-58,80},{-38,100}})));

//Parois horizontales
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ParoiSousCombles(
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.ParoiSousCombles.n,
      m=paraMaisonRT.ParoiSousCombles.m,
      e=paraMaisonRT.ParoiSousCombles.e,
      mat=paraMaisonRT.ParoiSousCombles.mat,
      positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondEntree)
    annotation (Placement(transformation(extent={{-7,82},{7,96}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    ParoiInterne=true,
    Tp=Tp,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherBas.n,
      m=paraMaisonRT.PlancherBas.m,
      e=paraMaisonRT.PlancherBas.e,
      mat=paraMaisonRT.PlancherBas.mat,
      positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
    InitType=InitType,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondEntree)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

//Parois verticales extérieures
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Porte(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PorteEntree,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    hs_ext=paraMaisonRT.hsExtVert,
    caracParoi(
      n=paraMaisonRT.Porte.n,
      m=paraMaisonRT.Porte.m,
      e=paraMaisonRT.Porte.e,
      mat=paraMaisonRT.Porte.mat,
      positionIsolant=paraMaisonRT.Porte.positionIsolant))
    annotation (Placement(transformation(extent={{-7,61},{7,76}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    RadExterne=false,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEstEntree)
    annotation (Placement(transformation(extent={{-7,42},{7,56}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudEntree)
    annotation (Placement(transformation(extent={{-7,-18},{7,-4}})));

//Parois verticales internes

//Vitrages

//Ponts thermiques
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

//Composants pour prise en compte du rayonnement GLO/CLO
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{40,-100},{60,-80}})));

//Composants de base
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondEntree
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart, Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{0,-100},{20,-80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TEntree
    annotation (Placement(transformation(extent={{80,-29},{100,-9}}),
        iconTransformation(extent={{-75,6},{-55,26}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondEntree
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart) annotation (
     Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={0,-24})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxSud[3]
    annotation (Placement(transformation(extent={{-108,76},{-84,100}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={-62,-88})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxEst[3]
    annotation (Placement(transformation(extent={{-108,56},{-84,80}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={-40,-88})));
equation
  if GLOEXT==true then
    connect(Tciel, MurEst.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,42.7},{-6.3,42.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurSud.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-17.3},{-6.3,-17.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, Porte.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,61.75},{-6.3,61.75}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;

  if QVin==true then
    connect(RenouvAir, renouvellementAir.Qv_in) annotation (Line(
      points={{100,-78},{92,-78},{92,-49},{80.68,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

    connect(Text, MurEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-6.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurSud.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-6.3,-13.1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, Porte.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,66.25},{-6.3,66.25}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlafond.Tponder, ParoiSousCombles.T_ext) annotation (Line(
      points={{-43,89.8},{-6.3,89.8},{-6.3,86.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlancher.Tponder, PlancherBas.T_ext) annotation (Line(
      points={{-43,-90.2},{34,-90.2},{34,-98.3},{53.1,-98.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,86.9},{40,86.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(Porte.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,66.25},{40,66.25},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,46.9},{40,46.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlafond.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,80},{-64,80},{-64,93},{-57,93}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, TEntree) annotation (Line(
      points={{80,22},{80,2},{80,-19},{90,-19}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, PontsThermiques.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-72.5},{-57.25,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{71,-39.1},{71,-30},{40,-30},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TauPlancher.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-93},{-60,-93},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauPlafond.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,87},{-60,87},{-60,82},{40,82},{40,40},{80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxSud, Porte.FLUX) annotation (Line(
      points={{-96,88},{-70,88},{-70,75.25},{-2.1,75.25}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxSud, MurSud.FLUX) annotation (Line(
      points={{-96,88},{-70,88},{-70,-4.7},{-2.1,-4.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxEst, MurEst.FLUX) annotation (Line(
      points={{-96,68},{-70,68},{-70,55.3},{-2.1,55.3}},
      color={255,192,1},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-80,106},{94,-80}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/Entree.png"),
        Ellipse(extent={{-14,10},{14,-18}}, lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={0,26},
          rotation=360),
        Ellipse(
          extent={{-2,-2},{2,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-38,-60},
          rotation=180),
        Line(
          points={{-16,6},{0,14},{14,6}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{14,8},{16,4},{12,6},{14,8}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-30,-4},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={0,-34},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={30,-4},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-15,-14},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics),
    Documentation(info="<html>
<p><i><b>Zone entrée Mozart</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ZoneEntrance;
