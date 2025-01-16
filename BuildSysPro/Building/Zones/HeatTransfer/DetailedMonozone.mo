within BuildSysPro.Building.Zones.HeatTransfer;
model DetailedMonozone
  "Single zone detailed model with adjustable inertia and average thermal transmission coefficient (Ubat, W/K.m²)"

// General parameters
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Ubat
    "Ubat: surface thermal losses by transmission"
    annotation (Dialog(group="Global parameters"));
parameter Integer NbNiveau=1 "umber of levels, minimum = 1" annotation(Dialog(group="Global parameters"));
  parameter Modelica.Units.SI.Volume Vair=240 "Air volume"
    annotation (Dialog(group="Global parameters"));
  parameter Modelica.Units.SI.Area SH=100 "Living area"
    annotation (Dialog(group="Global parameters"));
parameter Real renouv(unit="1/h") "Ventilation and/or infiltration flow"    annotation(Dialog(group="Global parameters"));

// Glazing parameters
  parameter Modelica.Units.SI.Area[4] SurfaceVitree
    "Glazed surface (North, South, East, West)"
    annotation (Dialog(group="Glazing"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k
    "Glazing thermal conductivity" annotation (Dialog(group="Glazing"));
parameter Real Tr=0.544 "Glazing transmission coefficient" annotation(Dialog(group="Glazing"));
parameter Real AbsVitrage=0.1 "Glazing absorption coefficient" annotation(Dialog(group="Glazing"));
parameter Real epsWindows=0.9 "Emissivity" annotation(Dialog(group="Glazing"));
// Walls parameters
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraPlafond
    "Ceiling parameters"
    annotation (choicesAllMatching=true, Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext_Plafond=7
    "Coefficient of CONVECTIVE surface exchange on the ceiling outer face"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int_Plafond=10
    "Coefficient of GLOBAL surface exchange on the ceiling inner face"
    annotation (Dialog(group="Walls"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraParoiV
    "Vertical walls parameters"
    annotation (choicesAllMatching=true, Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext_paroiV=18
    "Coefficient of CONVECTIVE surface exchange on vertical walls outer face"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int_paroiV=7.7
    "Coefficient of GLOBAL surface exchange on vertical walls inner face"
    annotation (Dialog(group="Walls"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraPlancher
    "Floor parameters"
    annotation (choicesAllMatching=true, Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext_Plancher=5.88
    "Coefficient of GLOBAL surface exchange on floors lower face"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int_Plancher=5.88
    "Coefficient of GLOBAL surface exchange on floors upper face"
    annotation (Dialog(group="Walls"));

parameter Real b=0.1 "Weighting coefficient of regulatory boundary conditions"
                                                              annotation(Dialog(group="Walls"));
parameter Real alpha_ext=0.6
    "Absorption coefficient of outer walls in the visible" annotation(Dialog(group="Walls"));
parameter Real epsParois=0.7 "Outer walls emissivity in LWR" annotation(Dialog(group="Walls"));

// Initialisation
  parameter Modelica.Units.SI.Temperature Tinit=292.15
    "Initialisation temperature" annotation (Dialog(tab="Initialisation"));

// Internal parameters
protected
  parameter Modelica.Units.SI.Length hTotal=Vair*(NbNiveau/SH)
    "Total building height";
  parameter Modelica.Units.SI.Area Sdeper=4*hTotal*sqrt(SH/NbNiveau) + 2*
      Splancher "Total surface with losses";
  parameter Modelica.Units.SI.Area Swin=sum(SurfaceVitree)
    "Total glazed surface with losses";
  parameter Modelica.Units.SI.Area Sop=Sdeper - Swin
    "Total opaque walls surface with losses";
  parameter Modelica.Units.SI.Area Splancher=SH/NbNiveau
    "Total floor surface with losses";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Uplancher=1/(sum(
      paraPlancher.e ./ paraPlancher.mat.lambda) + 1/hs_ext_Plancher + 1/
      hs_int_Plancher) "Floor Uvalue";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Ug=1/(1/k + 1/
      hs_ext_paroiV + 1/hs_int_paroiV) "Glazings Uvalue";

  // Second order polynomial system resolution to find the value of alpha, multiplying factor of insulating layers in vertical walls and the ceiling
parameter Real Anew=Ubat*Sdeper-Swin*Ug-b*Uplancher*Splancher
    "Ubat decomposition";
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
    "Multiplying factor of insulating layers (vertical walls and ceiling)";

  // Computation of Ubat extreme values
parameter Real Umin=(Swin*Ug+Uplancher*b*Splancher)/Sdeper
    "Ubat minimum value for the considered type of floor and glazing";
parameter Real Umax=(Swin*Ug+Uplancher*b*Splancher+(Sop-2*Splancher)/(sum(paraParoiV.e./paraParoiV.mat.lambda.*(ones(paraParoiV.n)-paraParoiV.positionIsolant))+1/hs_ext_paroiV+1/hs_int_paroiV)+b*Splancher/(sum(paraPlafond.e./paraPlafond.mat.lambda.*(ones(paraPlafond.n)-paraPlafond.positionIsolant))+1/hs_ext_Plafond+1/hs_int_Plafond))/Sdeper
    "Ubat maximal value for the considered type of wall and glazing";

// Internal components
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
    alpha_ext=alpha_ext)
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
    alpha_ext=alpha_ext,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "North outer wall"
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
    alpha_ext=alpha_ext,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "South outer wall"
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
    alpha_ext=alpha_ext,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "East outer wall"
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
    alpha_ext=alpha_ext,
    eps=epsParois,
    S=(Sop - 2*Splancher)/4) "West outer wall"
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
    incl=0) annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));

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
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tinit)
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
// Public components
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-100,-20},{-80,0}}), iconTransformation(
          extent={{-130,70},{-110,90}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int annotation (
      Placement(transformation(extent={{80,0},{100,20}}), iconTransformation(
          extent={{70,-50},{90,-30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky
    "Sky temperature for LW radiation inclusion"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}}),
        iconTransformation(extent={{-50,110},{-30,130}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtSouth[3]
    "Information on south solar surface flux (diffuse, direct and cosi)"
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-100,10},{-80,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtNorth[3]
    "Information on north solar surface flux (diffuse, direct and cosi)"
    annotation (Placement(transformation(extent={{-120,90},{-80,130}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtWest[3]
    "Information on west solar surface flux (diffuse, direct and cosi)"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}}),
        iconTransformation(extent={{-100,-30},{-80,-10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtEast[3]
    "Information on east solar surface flux (diffuse, direct and cosi)"
    annotation (Placement(transformation(extent={{-120,10},{-80,50}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));

// For validation in stationary operation: set the parameters to have SWR, LWR (abs and eps), renew at zero and 1°C of difference between outdoor and indoor)
  Real UbatEffectif=T_int.Q_flow/Sdeper;

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtRoof[3]
    "Information on ceiling solar surface flux (diffuse, direct and cosi)"
    annotation (Placement(transformation(extent={{-120,130},{-80,170}}),
        iconTransformation(extent={{-100,50},{-80,70}})));
equation
  assert(max(paraParoiV.positionIsolant)==1, "No insulating layer specified for outer walls. Edit paraParoiExt.positionIsolant");
  assert(max(paraPlancher.positionIsolant)==1, "No insulating layer specified for floors. Edit paraPlancher.positionIsolant");
  assert(Ubat<Umax and Ubat>Umin,"The value of Ubat depends on selected types of glazing and walls. Given the current configuration, "+String(Umin)+"<Ubat<"+String(Umax));

  connect(noeudAir.port_a, T_int) annotation (Line(
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

  connect(T_ext, Text) annotation (Line(
      points={{-90,-10},{-56,-10},{-56,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(coefficientBsol.port_int, Tint) annotation (Line(
      points={{-49,-83},{-49,-91.5},{20,-91.5},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.port_ext, Text) annotation (Line(
      points={{-49,-77},{-49,-69.5},{-20,-69.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(plancher.T_int, Tint)
                           annotation (Line(
      points={{9,-83},{9,-82.5},{20,-82.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.Tponder, plancher.T_ext) annotation (Line(
      points={{-35,-80.2},{-33.5,-80.2},{-33.5,-83},{-9,-83}},
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
      points={{3,-75},{19.5,-75},{19.5,-79.02},{34,-79.02}},
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
  connect(T_sky, plafond.T_sky) annotation (Line(
      points={{-90,170},{-16,170},{-16,149},{-9,149}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtNord.T_sky, T_sky) annotation (Line(
      points={{-7,121},{-16,121},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageNord.T_sky, T_sky) annotation (Line(
      points={{-11,99},{-16,99},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtSud.T_sky, T_sky) annotation (Line(
      points={{-7,73},{-16,73},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageSud.T_sky, T_sky) annotation (Line(
      points={{-11,49},{-16,49},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtEst.T_sky, T_sky) annotation (Line(
      points={{-7,23},{-16,23},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageEst.T_sky, T_sky) annotation (Line(
      points={{-11,-1},{-16,-1},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExtOuest.T_sky, T_sky) annotation (Line(
      points={{-7,-29},{-16,-29},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrageOuest.T_sky, T_sky) annotation (Line(
      points={{-11,-57},{-16,-57},{-16,170},{-90,170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FluxIncExtNorth, paroiExtNord.FluxIncExt) annotation (Line(
      points={{-100,110},{-40,110},{-40,139},{-1,139}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtSouth, paroiExtSud.FluxIncExt) annotation (Line(
      points={{-100,70},{-40,70},{-40,91},{-1,91}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtEast, paroiExtEst.FluxIncExt) annotation (Line(
      points={{-100,30},{-40,30},{-40,41},{-1,41}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtEast, vitrageEst.FluxIncExt) annotation (Line(
      points={{-100,30},{-40,30},{-40,13},{-5,13}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtSouth, vitrageSud.FluxIncExt) annotation (Line(
      points={{-100,70},{-40,70},{-40,63},{-5,63}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtNorth, vitrageNord.FluxIncExt) annotation (Line(
      points={{-100,110},{-40,110},{-40,113},{-5,113}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtWest, paroiExtOuest.FluxIncExt) annotation (Line(
      points={{-100,-50},{-40,-50},{-40,-11},{-1,-11}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtWest, vitrageOuest.FluxIncExt) annotation (Line(
      points={{-100,-50},{-40,-50},{-40,-43},{-5,-43}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, plafond.T_ext) annotation (Line(
      points={{-20,10},{-20,155},{-9,155}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FluxIncExtRoof, plafond.FluxIncExt) annotation (Line(
      points={{-100,150},{-40,150},{-40,167},{-3,167}},
      color={255,192,1},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,
            -120},{120,120}})),  Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-120,-120},{120,120}}), graphics={
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
          points={{26,54},{26,34},{64,34},{64,54},{26,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,20},{26,0},{64,0},{64,20},{26,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-20},{26,-40},{64,-40},{64,-20},{26,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-54},{26,-74},{64,-74},{64,-54},{26,-54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b>Detailed model of a single-zone with Ubat and variable inertia</b></p>
<p>This model allows the representation of Individual House / Collective Housing / Tertiary Building in single zone. The modelling is detailed, walls and windows are distinguished according to their orientation.</p>
<p>The loss level represented by Ubat is adjustable.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p><b>Geometry</b></p>
<p>Model of a parallelepiped 0D-1D square section single-zone. The building height depends on the number of levels (NbNiveau), on total air volume (Vair) and on the living area (HS). The building is oriented in the four cardinal points. Glazing are defined on every façade.</p>
<p><b>Building typology</b></p>
<p>Building typologies (materials and layers thicknesses) are considered in detail.</p>
<p>Inertia is adjustable by choosing the constructive mode via the wall type. The inertia due to inner walls, outside floors, is neglected.</p>
<p>The choice of walls parameters (<code>paraParoiV</code>...) describing building typologies and of glazing parameters allows to compute a reference Ubat. The Ubat of the building is then adjusted to the parameter <i>Ubat</i> using insulations of external walls thicknesses. Floor insulation is not considered in this adjustment.</p>
<p><b>Physics</b></p>
<p>The coefficient B imposes boundary conditions on the low floor outer face. The entire solar flux transmitted through the glazing is absorbed on floor(s) surface. The ceiling / roof is subjected to SW/LW radiations as well as vertical outer walls.</p>
<p><u><b>Bibliography</b></u></p>
<p>Refer to BuildSysPro <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">walls</a> and <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">glazings</a> modelling assumptions.</p>
<p><u><b>Instructions for use</b></u></p>
<p>The solar fluxes different ports are connected with a <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone\">FLUXzone</a> model. The outdoor temperature port must be connected to a weather block.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Depending on the chosen building typology and the type of glazing, Ubat can be chosen anyhow. It must necessarily be framed. An error message occurs when the selected Ubat is out of this range.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis, Hassan Bouia 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2014 : Modification de l'absorptivité extérieur du plafond/toit de 0 à AbsParois.</p>
<p>Gilles Plessis 09/2015 : Ajout d'<code>assert</code> prévenant la non définition de couche isolante.</p>
</html>"));
end DetailedMonozone;
