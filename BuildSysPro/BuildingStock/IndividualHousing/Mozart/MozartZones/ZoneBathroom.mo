within BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones;
model ZoneBathroom

  // Choix de la RT
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "Réglementation thermique utilisée" annotation (
      choicesAllMatching=true, Dialog(group="Choix de la RT"));

  // Flux thermiques
parameter Boolean GLOEXT=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel"                            annotation(Dialog(tab="Flux thermiques"));
parameter Boolean CLOintPlancher=true
    "True : tout le flux est absorbé par le plancher; False : le flux est absorbé par toutes les parois au prorata des surfaces"
                                                                                                        annotation(Dialog(tab="Flux thermiques"));
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

  // Fenêtres
parameter Boolean useVolet=false "true si présence d'un volet, false sinon" annotation(Dialog(tab="Fenêtres"));
parameter Boolean useReduction=false
    "Prise en compte ou non des facteurs de reduction"
    annotation (Dialog(tab="Fenêtres"));
parameter Integer TypeFenetrePF=1
    "Choix du type de fenetre ou porte-fenetre (PF)"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"),
    choices( choice= 1 "Je ne sais pas - pas de menuiserie",
             choice= 2 "Battant Fenêtre Bois",
             choice= 3 "Battant Fenêtre Métal",
             choice= 4 "Battant PF avec soubassement Bois",
             choice= 5 "Battant PF sans soubassement Bois",
             choice= 6 "Battant PF sans soubassement Métal",
             choice= 7 "Coulissant Fenêtre Bois",
             choice= 8 "Coulissant Fenêtre Métal",
             choice= 9 "Coulissant PF avec soubassement Bois",
             choice= 10 "Coulissant PF sans soubassement Bois",
             choice= 11 "Coulissant PF sans soubassement Métal"));
parameter Real voilage=0.95 "Voilage : = 0.95 si oui et = 1 sinon"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real position=0.90
    "Position du vitrage : = 0.9 si interieure et = 1 si exterieure"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real rideaux=0.85 "Presence de rideaux : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real ombrages=0.85
    "Ombrage d'obstacles (vegetation, voisinage) : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real r1=paraMaisonRT.transmissionMenuiserieFenetres
    "Coef. réducteur pour le direct si useReduction = false"
    annotation (Dialog(tab="Fenêtres",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));
parameter Real r2=paraMaisonRT.transmissionMenuiserieFenetres
    "Coef. réducteur pour le diffus si useReduction = false"
    annotation (Dialog(tab="Fenêtres",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));

  // Ponts thermiques
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsSDB,
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
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.ParoiSousCombles.n,
      m=paraMaisonRT.ParoiSousCombles.m,
      e=paraMaisonRT.ParoiSousCombles.e,
      mat=paraMaisonRT.ParoiSousCombles.mat,
      positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSDB)
    annotation (Placement(transformation(extent={{-7,82},{7,96}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherBas.n,
      m=paraMaisonRT.PlancherBas.m,
      e=paraMaisonRT.PlancherBas.e,
      mat=paraMaisonRT.PlancherBas.mat,
      positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSDB)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

//Parois verticales extérieures
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudSDB)
    annotation (Placement(transformation(extent={{-7,-18},{7,-4}})));

//Parois verticales internes

//Vitrages
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSudSF(
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    useVolet=useVolet,
    k=1/(1/paraMaisonRT.UvitrageSF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    DifDirOut=false,
    useReduction=useReduction,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudSDB,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageSudSDB)
    annotation (Placement(transformation(extent={{-36,-18},{-22,-4}})));

//Ponts thermiques
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

//Composants pour prise en compte du rayonnement GLO/CLO
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{60,-100},{80,-80}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=5,
    nf=1,
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSDB,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeSDB,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudSDB,BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC3SDB,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSDB},
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudSDB}) if
    not CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

//Composants de base
protected
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSDB
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart, Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{20,-100},{40,-80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TSDB annotation (
      Placement(transformation(extent={{80,-29},{100,-9}}), iconTransformation(
          extent={{-3,12},{17,32}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSDB
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart) annotation (
     Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={43,-45})));

  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVolet
    "fermeture des volets Sud"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={11,-45})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxSud[3]
    annotation (Placement(transformation(extent={{-108,76},{-84,100}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={-48,-88})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,80},{104,100}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonC3 if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,58},{104,78}}),
        iconTransformation(extent={{80,10},{100,30}})));
equation
  if CLOintPlancher==false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageSudSF.FluxAbsInt) annotation (
      Line(
      points={{19,-80},{24,-80},{24,-9.6},{-26.9,-9.6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[1], ParoiSousCombles.FluxAbsInt) annotation (
     Line(
      points={{19,-84.8},{24,-84.8},{24,92.5},{2.1,92.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[2], FLUXcloisonEntree) annotation (Line(
      points={{19,-84.4},{24,-84.4},{24,90},{94,90}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[3], MurSud.FluxAbsInt) annotation (Line(
      points={{19,-84},{24,-84},{24,-7.5},{2.1,-7.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[4], FLUXcloisonC3) annotation (Line(
      points={{19,-83.6},{24,-83.6},{24,68},{94,68}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[5], PlancherBas.FluxAbsInt) annotation (Line(
      points={{19,-83.2},{47.5,-83.2},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
else
    connect(multiSum.y, PlancherBas.FluxAbsInt) annotation (Line(
      points={{-14,-73.02},{48,-73.02},{48,-89.9},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if GLOEXT==true then
    connect(Tciel, VitrageSudSF.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-17.3},{-35.3,-17.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurSud.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-17.3},{-6.3,-17.3}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;

  if QVin==true then
    connect(RenouvAir, renouvellementAir.Qv_in) annotation (Line(
      points={{100,-78},{92,-78},{92,-49},{80.68,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVolet then
    connect(fermetureVolets[1], VitrageSudSF.fermeture_volet)
      annotation (
      Line(
      points={{-100,-80},{-76,-80},{-76,-6.1},{-35.3,-6.1}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

    connect(Text, MurSud.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-6.3,-13.1}},
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
    connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageSudSF.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-35.3,-13.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlafond.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,80},{-64,80},{-64,93},{-57,93}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageSudSF.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-22.7,-7.5},{-14,-7.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a,TSDB)  annotation (Line(
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
 connect(VitrageSudSF.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.7,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxSud, VitrageSudSF.FLUX) annotation (Line(
      points={{-96,88},{-84,88},{-84,90},{-72,90},{-72,-7.5},{-31.1,-7.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxSud, MurSud.FLUX) annotation (Line(
      points={{-96,88},{-84,88},{-84,90},{-72,90},{-72,-4.7},{-2.1,-4.7}},
      color={255,192,1},
      smooth=Smooth.None));

annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-72,80},{68,-40}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/SDB.png"),
        Ellipse(extent={{28,14},{56,-14}},  lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={42,30},
          rotation=360),
        Ellipse(
          extent={{40,2},{44,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={4,-56},
          rotation=180),
        Line(
          points={{26,10},{42,18},{56,10}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{56,12},{58,8},{54,10},{56,12}},
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
          origin={12,0},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={42,-30},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={72,0},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={27,-10},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Zone salle de bain Mozart</b></i></p>
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
end ZoneBathroom;
