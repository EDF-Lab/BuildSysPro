within BuildSysPro.Building.Zones.HeatTransfer;
model DetailedMonozone "Modèle monozone à Ubat et inertie réglable."

// Paramètres généraux
parameter Modelica.SIunits.CoefficientOfHeatTransfer Ubat
    "Ubat : Déperditions  surfacique par transmission" annotation(dialog(group="Paramètres globaux"));
parameter Integer NbNiveau=1 "Nombre de niveaux, minimum = 1" annotation(dialog(group="Paramètres globaux"));
parameter Modelica.SIunits.Volume Vair=240 "Volume d'air" annotation(dialog(group="Paramètres globaux"));
parameter Modelica.SIunits.Area SH=100 "Surface habitable" annotation(dialog(group="Paramètres globaux"));
parameter Real renouv(unit="1/h") "Débit de ventilation et/ou d'infiltrations"
                                                                            annotation(dialog(group="Paramètres globaux"));

// Paramètres vitrages
parameter Modelica.SIunits.Area[4] SurfaceVitree
    "Surface vitrée (Nord, Sud, Est, Ouest)"
                                 annotation(dialog(group="Vitrage"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer k
    "Conductivité thermique du vitrage" annotation(dialog(group="Vitrage"));
parameter Real Tr=0.544 "Coefficient de transmission fenêtre" annotation(dialog(group="Vitrage"));
parameter Real AbsVitrage=0.1 "Coefficient d'absorption de la fenêtre" annotation(dialog(group="Vitrage"));
parameter Real epsWindows=0.9 "Emissivité" annotation(dialog(group="Vitrage"));
// Paramètres des parois
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraPlafond
    "Paramètres du plafond"
    annotation (__Dymola_choicesAllMatching=true, dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_Plafond=7
    "Coefficient d'échange CONVECTIF surfacique sur la face extérieure du plafond"
                                                                                     annotation(dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_Plafond=10
    "Coefficient d'échange surfacique global sur la face intérieure du plafond"
                                                                                   annotation(dialog(group="Parois"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraParoiV
    "Paramètres des parois verticales"
    annotation (__Dymola_choicesAllMatching=true, dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_paroiV=18
    "Coefficient d'échange CONVECTIF surfacique sur la face extérieure des parois verticales"
                                                                                    annotation(dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_paroiV=7.7
    "Coefficient d'échange surfacique global sur la face intérieure des parois verticales"
                                                                                   annotation(dialog(group="Parois"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraPlancher
    "Paramètres du plancher"
    annotation (__Dymola_choicesAllMatching=true, dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_Plancher=5.88
    "Coefficient d'échange surfacique global sur la face inférieure des planchers"
                                                                                     annotation(dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_Plancher=5.88
    "Coefficient d'échange surfacique global sur la face supérieure des planchers"
                                                                                   annotation(dialog(group="Parois"));

parameter Real b=0.1
    "Coefficient de pondération des conditions limites règlementaires" annotation(dialog(group="Parois"));
parameter Real AbsParois=0.6
    "Coefficient d'absorption de la parois ext. dans le visible" annotation(dialog(group="Parois"));
parameter Real epsParois=0.7 "Emissivité des parois extérieures en GLO" annotation(dialog(group="Parois"));

// Initialisation
parameter Modelica.SIunits.Temperature Tinit=292.15
    "Température d'initialisation"
                                  annotation(dialog(tab="Initialisation"));

// Paramètres internes
protected
parameter Modelica.SIunits.Length hTotal=Vair*(NbNiveau/SH)
    "Hauteur totale du bâtiment";
parameter Modelica.SIunits.Area Sdeper=4*hTotal*sqrt(SH/NbNiveau)+2*Splancher
    "Surface déperditive totale";
parameter Modelica.SIunits.Area Swin=sum(SurfaceVitree)
    "Surface déperditive des parois vitrées";
parameter Modelica.SIunits.Area Sop=Sdeper-Swin
    "Surface déperditive des parois opaques";
parameter Modelica.SIunits.Area Splancher=SH/NbNiveau
    "Surface déperditive du plancher";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Uplancher=1/(sum(paraPlancher.e./paraPlancher.mat.lambda)+1/hs_ext_Plancher+1/hs_int_Plancher)
    "Uvalue du plancher";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Ug= 1/(1/k+1/hs_ext_paroiV+1/hs_int_paroiV)
    "Uvalue des vitrages";

  // Résolution du système polynomiale d'ordre 2 pour trouver la valeur de alpha, coefficient multiplicateur des couches isolantes dans les parois verticales et le plafond.
parameter Real Anew=Ubat*Sdeper-Swin*Ug-b*Uplancher*Splancher
    "Décomposition du Ubat";
parameter Real coefN1=(Sop-2*Splancher);
parameter Real coefN2=Splancher;
parameter Real coefD1=sum(paraParoiV.e./paraParoiV.mat.lambda.*paraParoiV.positionIsolant);
parameter Real coefD2=sum(paraParoiV.e./paraParoiV.mat.lambda.*(ones(paraParoiV.n)-paraParoiV.positionIsolant))+1/hs_ext_paroiV+1/hs_int_paroiV;
parameter Real coefD3=sum(paraPlafond.e./paraPlafond.mat.lambda.*paraPlafond.positionIsolant);
parameter Real coefD4=sum(paraPlafond.e./paraPlafond.mat.lambda.*(ones(paraPlafond.n)-paraPlafond.positionIsolant))+1/hs_ext_Plafond+1/hs_int_Plafond;

parameter Real COEF1=Anew*coefD1*coefD3;
parameter Real COEF2=(coefD1*coefD4+coefD2*coefD3)*Anew-(coefD3*coefN1+coefD1*coefN2);
parameter Real COEF3=(coefD2*coefD4)*Anew-(coefN1*coefD4+coefN2*coefD2);

parameter Real alpha=abs((-COEF2+sqrt(COEF2^2-4*COEF1*COEF3))/(2*COEF1))
    "Coefficient multiplicateur des couches isolantes(parois verticales et plafond)";

  // Calcul des valeurs extremes du Ubat
parameter Real Umin=(Swin*Ug+Uplancher*b*Splancher)/Sdeper
    "Valeur minimale de Ubat pour le type de plancher et de vitrage considéré";
parameter Real Umax=(Swin*Ug+Uplancher*b*Splancher+(Sop-2*Splancher)/(sum(paraParoiV.e./paraParoiV.mat.lambda.*(ones(paraParoiV.n)-paraParoiV.positionIsolant))+1/hs_ext_paroiV+1/hs_int_paroiV)+b*Splancher/(sum(paraPlafond.e./paraPlafond.mat.lambda.*(ones(paraPlafond.n)-paraPlafond.positionIsolant))+1/hs_ext_Plafond+1/hs_int_Plafond))/Sdeper
    "Valeur maximale de Ubat pour le type de paroi et vitrage considéré";

// Composants internes
BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall plafond(
    caracParoi(
      n=paraPlafond.n,
      mat=paraPlafond.mat,
      m=paraPlafond.m,
      e=paraPlafond.e .* (ones(paraPlafond.n) - paraPlafond.positionIsolant) +
          alpha*paraPlafond.e .* paraPlafond.positionIsolant),
    Tp=Tinit,
    S=Splancher,
    hs_ext=hs_ext_Plafond,
    hs_int=hs_int_Plafond,
    incl=0,
    RadInterne=false,
    GLOext=true,
    eps=epsParois,
    ParoiInterne=false,
    alpha_ext=AbsParois)
    annotation (Placement(transformation(extent={{-10,148},{10,168}})));

BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall paroiExtNord(
    caracParoi(
      n=paraParoiV.n,
      mat=paraParoiV.mat,
      m=paraParoiV.m,
      e=paraParoiV.e .* (ones(paraParoiV.n) - paraParoiV.positionIsolant) +
          alpha*paraParoiV.e .* paraParoiV.positionIsolant),
    Tp=Tinit,
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    GLOext=true,
    ParoiInterne=false,
    RadExterne=false,
    alpha_ext=AbsParois,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "Paroi extérieure nord"
    annotation (Placement(transformation(extent={{-8,120},{12,140}})));
BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall paroiExtSud(
    caracParoi(
      n=paraParoiV.n,
      mat=paraParoiV.mat,
      m=paraParoiV.m,
      e=paraParoiV.e .* (ones(paraParoiV.n) - paraParoiV.positionIsolant) +
          alpha*paraParoiV.e .* paraParoiV.positionIsolant),
    Tp=Tinit,
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    GLOext=true,
    ParoiInterne=false,
    RadExterne=false,
    alpha_ext=AbsParois,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "Paroi extérieure sud"
    annotation (Placement(transformation(extent={{-8,72},{12,92}})));
BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall paroiExtEst(
    caracParoi(
      n=paraParoiV.n,
      mat=paraParoiV.mat,
      m=paraParoiV.m,
      e=paraParoiV.e .* (ones(paraParoiV.n) - paraParoiV.positionIsolant) +
          alpha*paraParoiV.e .* paraParoiV.positionIsolant),
    Tp=Tinit,
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    GLOext=true,
    ParoiInterne=false,
    RadExterne=false,
    alpha_ext=AbsParois,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "Paroi extérieure est"
    annotation (Placement(transformation(extent={{-8,22},{12,42}})));
BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall paroiExtOuest(
    caracParoi(
      n=paraParoiV.n,
      mat=paraParoiV.mat,
      m=paraParoiV.m,
      e=paraParoiV.e .* (ones(paraParoiV.n) - paraParoiV.positionIsolant) +
          alpha*paraParoiV.e .* paraParoiV.positionIsolant),
    Tp=Tinit,
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    GLOext=true,
    ParoiInterne=false,
    RadExterne=false,
    alpha_ext=AbsParois,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "Paroi extérieure ouest"
    annotation (Placement(transformation(extent={{-8,-30},{12,-10}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window vitrageNord(
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    S=SurfaceVitree[1],
    GLOext=true,
    k=k,
    TrDir=Tr,
    TrDif=Tr,
    eps=epsWindows,
    AbsDir=AbsVitrage,
    AbsDif=AbsVitrage)
    annotation (Placement(transformation(extent={{-12,98},{8,118}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window vitrageSud(
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    S=SurfaceVitree[2],
    GLOext=true,
    k=k,
    TrDir=Tr,
    TrDif=Tr,
    eps=epsWindows,
    AbsDir=AbsVitrage,
    AbsDif=AbsVitrage)
    annotation (Placement(transformation(extent={{-12,48},{8,68}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window vitrageEst(
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    S=SurfaceVitree[3],
    GLOext=true,
    k=k,
    TrDir=Tr,
    TrDif=Tr,
    eps=epsWindows,
    AbsDir=AbsVitrage,
    AbsDif=AbsVitrage)
    annotation (Placement(transformation(extent={{-12,-2},{8,18}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window vitrageOuest(
    hs_ext=hs_ext_paroiV,
    hs_int=hs_int_paroiV,
    RadInterne=false,
    S=SurfaceVitree[4],
    GLOext=true,
    k=k,
    TrDir=Tr,
    TrDif=Tr,
    eps=epsWindows,
    AbsDir=AbsVitrage,
    AbsDif=AbsVitrage)
    annotation (Placement(transformation(extent={{-12,-58},{8,-38}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall plancher(
    RadInterne=true,
    ParoiInterne=true,
    caracParoi(
      n=paraPlancher.n,
      m=paraPlancher.m,
      e=paraPlancher.e,
      mat=paraPlancher.mat,
      positionIsolant=paraPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher,
    hs_ext=hs_ext_Plancher,
    hs_int=hs_int_Plancher,
    incl=0) annotation (Placement(transformation(extent={{-8,-92},{12,-72}})));

   BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall plancherInt[NbNiveau
     - 1](
    each RadInterne=true,
    each ParoiInterne=true,
    each caracParoi(
      n=paraPlancher.n,
      m=paraPlancher.m,
      e=paraPlancher.e,
      mat=paraPlancher.mat,
      positionIsolant=paraPlancher.positionIsolant),
    each Tp=Tinit,
    each S=Splancher,
    each hs_ext=hs_ext_Plancher,
    each hs_int=hs_int_Plancher,
    each incl=0) if NbNiveau > 1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-76})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal ventilationSimple(Qv=renouv
        *Vair)
    annotation (Placement(transformation(extent={{-12,-116},{8,-96}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-22,8},{-18,12}}), iconTransformation(
          extent={{-192,4},{-172,24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tint annotation (
      Placement(transformation(extent={{18,8},{22,12}}), iconTransformation(
          extent={{60,-76},{80,-56}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=4, k=fill(1/NbNiveau, 4))
                                               annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={34,-72})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficientBsol(b=b)
    annotation (Placement(transformation(extent={{-46,-94},{-26,-74}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tinit)
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
// Composants publics
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairext
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}}),
        iconTransformation(extent={{-100,-120},{-80,-100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairint
    annotation (Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,-60},{100,-40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel
    "Température de ciel pour la prise en compte du rayonnement GLO"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}}),
        iconTransformation(extent={{-100,100},{-80,120}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUXS[3]
    "Informations de flux solaire surfacique (diffus, direct et cos i)"
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-100,10},{-80,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUXN[3]
    "Informations de flux solaire surfacique (diffus, direct et cos i)"
    annotation (Placement(transformation(extent={{-120,90},{-80,130}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUXO[3]
    "Informations de flux solaire surfacique (diffus, direct et cos i)"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}}),
        iconTransformation(extent={{-100,-30},{-80,-10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUXE[3]
    "Informations de flux solaire surfacique (diffus, direct et cos i)"
    annotation (Placement(transformation(extent={{-120,10},{-80,50}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));

// Pour validation en régime stationnaire : fixer les paramètres pour avoir CLO, GLO (abs et eps) et renouv à zéro et 1°C de différence entre extérieur et intérieur)
Real UbatEffectif=Tairint.Q_flow/Sdeper;

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUXP[3]
    "Informations de flux solaire surfacique (diffus, direct et cos i)"
    annotation (Placement(transformation(extent={{-120,130},{-80,170}}),
        iconTransformation(extent={{-100,50},{-80,70}})));
equation
  assert(max(paraParoiV.positionIsolant)==1, "Pas de couche isolante spécifiée pour les parois extérieures. Modifier paraParoiV.positionIsolant");
  assert(max(paraPlancher.positionIsolant)==1, "Pas de couche isolante spécifiée pour les planchers. Modifier paraPlancher.positionIsolant");
assert(Ubat<Umax and Ubat>Umin,"La valeur du Ubat est dépendante des types de vitrages et parois choisis. Etant donné la configuration actuelle,"+String(Umin)+"<Ubat<"+String(Umax));

  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{60,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tint) annotation (Line(
      points={{60,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(vitrageEst.T_int, Tint) annotation (Line(
      points={{7,5},{7,5.5},{20,5.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrageOuest.T_int, Tint) annotation (Line(
      points={{7,-51},{7,-51.5},{20,-51.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrageNord.T_ext, Text) annotation (Line(
      points={{-11,105},{-11,105.5},{-20,105.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageEst.T_ext, Text) annotation (Line(
      points={{-11,5},{-11,5.5},{-20,5.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageOuest.T_ext, Text) annotation (Line(
      points={{-11,-51},{-11,-50.5},{-20,-50.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Tairext, Text) annotation (Line(
      points={{-90,-10},{-56,-10},{-56,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(coefficientBsol.port_int, Tint) annotation (Line(
      points={{-45,-87},{-45,-91.5},{20,-91.5},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.port_ext, Text) annotation (Line(
      points={{-45,-81},{-45,-77.5},{-20,-77.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(plancher.T_int, Tint)
                           annotation (Line(
      points={{11,-85},{11,-82.5},{20,-82.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.Tponder, plancher.T_ext) annotation (Line(
      points={{-31,-84.2},{-29.5,-84.2},{-29.5,-85},{-7,-85}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(ventilationSimple.port_b, Tint) annotation (Line(
      points={{7,-106},{20,-106},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ventilationSimple.port_a, Text) annotation (Line(
      points={{-11,-106},{-20,-106},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
if NbNiveau>1 then
  for i in 1:NbNiveau-1 loop
  connect(plancherInt[i].T_ext, noeudAir.port_a) annotation (Line(
      points={{69,-73},{69,-8},{60,-8},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancherInt[i].T_int, noeudAir.port_a) annotation (Line(
      points={{51,-73},{51,-8},{60,-8},{60,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(plancherInt[i].FluxAbsInt, multiSum.y) annotation (Line(
      points={{57,-81},{45.5,-81},{45.5,-79.02},{34,-79.02}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;
end if;
  connect(vitrageEst.CLOTr, multiSum.u[1]) annotation (Line(
      points={{7,13},{37.15,13},{37.15,-66}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(vitrageOuest.CLOTr, multiSum.u[2]) annotation (Line(
      points={{7,-43},{36.5,-43},{36.5,-66},{35.05,-66}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(vitrageSud.CLOTr, multiSum.u[3]) annotation (Line(
      points={{7,63},{36,63},{36,-66},{32.95,-66}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(vitrageNord.CLOTr, multiSum.u[4]) annotation (Line(
      points={{7,113},{30.85,113},{30.85,-66}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(plancher.FluxAbsInt, multiSum.y) annotation (Line(
      points={{5,-77},{19.5,-77},{19.5,-79.02},{34,-79.02}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(plafond.T_int, Tint) annotation (Line(
      points={{9,155},{20,155},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrageNord.T_int, Tint) annotation (Line(
      points={{7,105},{20,105},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExtNord.T_int, Tint) annotation (Line(
      points={{11,127},{20,127},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExtNord.T_ext, Text) annotation (Line(
      points={{-7,127},{-20,127},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtSud.T_int, Tint) annotation (Line(
      points={{11,79},{20,79},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExtSud.T_ext, Text) annotation (Line(
      points={{-7,79},{-20,79},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtEst.T_ext, Text) annotation (Line(
      points={{-7,29},{-20,29},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtEst.T_int, Tint) annotation (Line(
      points={{11,29},{20,29},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExtOuest.T_ext, Text) annotation (Line(
      points={{-7,-23},{-20,-23},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtOuest.T_int, Tint) annotation (Line(
      points={{11,-23},{20,-23},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrageSud.T_int, Tint) annotation (Line(
      points={{7,55},{20,55},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrageSud.T_ext, Text) annotation (Line(
      points={{-11,55},{-20,55},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tciel, plafond.T_ciel) annotation (Line(
      points={{-90,170},{-16,170},{-16,149},{-9,149}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtNord.T_ciel, Tciel) annotation (Line(
      points={{-7,121},{-16,121},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageNord.T_ciel, Tciel) annotation (Line(
      points={{-11,99},{-16,99},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtSud.T_ciel, Tciel) annotation (Line(
      points={{-7,73},{-16,73},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageSud.T_ciel, Tciel) annotation (Line(
      points={{-11,49},{-16,49},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtEst.T_ciel, Tciel) annotation (Line(
      points={{-7,23},{-16,23},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageEst.T_ciel, Tciel) annotation (Line(
      points={{-11,-1},{-16,-1},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtOuest.T_ciel, Tciel) annotation (Line(
      points={{-7,-29},{-16,-29},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageOuest.T_ciel, Tciel) annotation (Line(
      points={{-11,-57},{-16,-57},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FLUXN, paroiExtNord.FLUX) annotation (Line(
      points={{-100,110},{-40,110},{-40,139},{-1,139}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXS, paroiExtSud.FLUX) annotation (Line(
      points={{-100,70},{-40,70},{-40,91},{-1,91}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXE, paroiExtEst.FLUX) annotation (Line(
      points={{-100,30},{-40,30},{-40,41},{-1,41}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXE, vitrageEst.FLUX) annotation (Line(
      points={{-100,30},{-40,30},{-40,13},{-5,13}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXS, vitrageSud.FLUX) annotation (Line(
      points={{-100,70},{-40,70},{-40,63},{-5,63}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXN, vitrageNord.FLUX) annotation (Line(
      points={{-100,110},{-40,110},{-40,113},{-5,113}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXO, paroiExtOuest.FLUX) annotation (Line(
      points={{-100,-50},{-40,-50},{-40,-11},{-1,-11}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUXO, vitrageOuest.FLUX) annotation (Line(
      points={{-100,-50},{-40,-50},{-40,-43},{-5,-43}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, plafond.T_ext) annotation (Line(
      points={{-20,10},{-20,155},{-9,155}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FLUXP, plafond.FLUX) annotation (Line(
      points={{-100,150},{-40,150},{-40,167},{-3,167}},
      color={255,192,1},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -120},{100,180}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-120},{100,180}}), graphics={
        Polygon(
          points={{-100,100},{-60,60},{-60,-100},{-100,-58},{-100,100}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-60,60},{100,60},{100,-100},{-60,-100},{-60,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Polygon(
          points={{-100,100},{38,100},{100,60},{-60,60},{-100,100}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,80},{-90,60},{-70,40},{-70,60},{-90,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,40},{-90,20},{-70,0},{-70,20},{-90,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,0},{-90,-20},{-70,-40},{-70,-20},{-90,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,-40},{-90,-60},{-70,-80},{-70,-60},{-90,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-54},{-48,-74},{-10,-74},{-10,-54},{-48,-54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-20},{-48,-40},{-10,-40},{-10,-20},{-48,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,20},{-46,0},{-8,0},{-8,20},{-46,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,54},{-46,34},{-8,34},{-8,54},{-46,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,54},{36,34},{74,34},{74,54},{36,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,20},{36,0},{74,0},{74,20},{36,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-20},{36,-40},{74,-40},{74,-20},{36,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-54},{36,-74},{74,-74},{74,-54},{36,-54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i><b>Modèle de monozone détaillé à Ubat et inertie variable</b></i></p>
<p>Ce modèle permet la représentation de Maison Individuelle/Logement Collectif/ Bâtiment Tertiaire en monozone. La modélisation est détaillée, les parois et vitrages sont distingués suivant leur orientation.</p>
<p>Le niveau de déperdition représenté par le Ubat est réglable.</p>
<p><u><b>Hypothèses et équations</b></u></p>
<h4>Géométrie</h4>
<p>Modèle monozone 0D-1D parallépipédique à section carrré. La hauteur du bâtiment est dépendante du nombre de niveaux (<code><span style=\"font-family: Courier New,courier;\">NbNiveau),</span></code> du volume d'air total (<code><span style=\"font-family: Courier New,courier;\">Vair</span></code>) et de la surface habitable (<code><span style=\"font-family: Courier New,courier;\">SH</span></code>). Le bâtiment est orienté suivant les 4 points cardinaux. Les vitrages sont définis sur chaque facade.</p>
<h4>Typologie constructive</h4>
<p>Les typologies constructives (matériaux et épaisseurs des couches) sont prises en compte de façon détaillée.</p>
<p>L'inertie est ajustable en choisissant le mode constructif via le type de paroi. L'inertie due aux parois internes, hors planchers, est négligée.</p>
<p>Le choix des paramètres des parois (<code><span style=\"font-family: Courier New,courier;\">paraParoiV</span></code>...) décrivant les typologies constructives ainsi que des paramètres des vitrages permet le calcul d'un Ubat référence. Le Ubat du bâtiment est ensuite ajusté au paramètre <code><span style=\"font-family: Courier New,courier;\">Ubat</span></code> grâce aux épaisseurs des isolants des parois exterieures. L'isolant de plancher ne participe pas à cette ajustement.</p>
<h4>Physique</h4>
<p>Le coefficient B impose les conditions limites sur la face extérieure du plancher bas. La totalité du flux solaire transmis par les vitrages est absorbé en surface du/des planchers. Le plafond/toit est soumis au rayonnement CLO et GLO au même titre que les parois extérieures verticales.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Voir les hypothèses de modélisation des <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">parois</a> et des <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">vitrages </a>de BuildSysPro.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Connexion des différents ports de flux solaires grâce à un modèle <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone\">FLUXzone</a>. Le port de température extérieure doit être connecté à un bloc météo.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Suivant la typologie constructive choisie et le type de vitrage, le Ubat ne peut être choisi n'importe comment. Il doit nécessairement être encadré. Un message d'erreur survient lorsque le Ubat choisi est hors de cet interval.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis, Hassan Bouia 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2014 : Modification de l'absorptivité extérieur du plafond/toit de 0 à AbsParois.</p>
<p>Gilles Plessis 09/2015 : Ajout d'<code>assert</code> prévenant la non définition de couche isolante.</p>
</html>"));
end DetailedMonozone;
