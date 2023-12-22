within BuildSysPro.Systems.HVAC.Production.WoodHeating.Logs;
model LogStove

  import      Modelica.Units.SI;

// WOOD RELATED PARAMETERS
parameter SI.Mass mL0=3.6 "Initial mass of wet wood log";
parameter SI.Mass mB0=(1-H/100)*mL0 "Initial mass of dry wood log";
SI.Mass mL "Mass of wood (wet)"; // mL=mB+mE
SI.Mass mE(start=H*mL0/100) "Mass of water in the wood";
SI.Mass mB(start=mB0) "Mass of dry wood";
SI.Mass mF(start=5) "Mass of smoke";
SI.SpecificHeatCapacity CpL "Specific Heat Capacity of wet wood";
SI.SpecificHeatCapacity CpG "Specific Heat Capacity of gas";
SI.SpecificHeatCapacity CpP "Specific Heat Capacity of the stove";
parameter Real H=15.0 "Wood humidity in %";
parameter Real x=1 "Stoichiometric value of carbone";
parameter Real y=1.44 "Stoichiometric value of hydrogen";
parameter Real z=0.66 "Stoichiometric value of oxygen";
Real M_O2=16 "Molar mass of 02";
Real M_N2=14 "Molar mass of N2";
Real M_O=8 "Molar mass of 0";
Real M_C=6 "Molar mass of C";
Real M_H=1 "Molar mass of H";

// TEMPERATURES
SI.Temperature T_L(start=293.15) "Wood temperature";
SI.Temperature T_G(start=293.15) "Gas temperature";
SI.Temperature T_P(start=293.15) "Stove's side temperature";
  Modelica.Units.NonSI.Temperature_degC T_FenC
    "Window temperature in Celsius degrees";

// ENERGIES
parameter SI.SpecificEnergy Hpy=125900 "Specific Energy of pyrolysis";
parameter SI.SpecificEnergy Hevap=2260000 "Latent Heat of Vaporization";
parameter SI.SpecificEnergy PCS=20000000 "Higher Heating Value - HHV";   // PCS stands for "Pouvoir Calorifique Supérieur"
parameter SI.SpecificEnergy PCI = PCS*(1-H/100)-2512*(9*0.05*(1-H/100)+H/100)
    "Lower Heating Value - LHV";    // PCI stands for "Pouvoir Calorifique Inférieur"
SI.EnergyFlowRate Qpy "pyrolysis energy flow rate";
SI.EnergyFlowRate Qevap "vaporization energy flow rate";
SI.EnergyFlowRate Qcomb "combustion Energy flow rate";
SI.EnergyFlowRate QccLG "convective heat transfer between the wood and the gas";
SI.EnergyFlowRate QccPExt
    "convective heat transfer between the stove and the room";
SI.EnergyFlowRate QccGP
    "convective heat transfer between the gas and the stove";
SI.EnergyFlowRate QrLG "radiative heat transfer between the wood and the gas";
SI.EnergyFlowRate QrLP "radiative heat transfer between the wood and the stove";
SI.EnergyFlowRate QrGP "radiative heat transfer between the gas and the stove";
SI.EnergyFlowRate QrGL "radiative heat transfer between the gas and the wood";
SI.EnergyFlowRate QrPL "radiative heat transfer between the stove and the wood";
SI.EnergyFlowRate QrPG "radiative heat transfer between the stove and the gas";
SI.EnergyFlowRate QrVitre "radiative heat transfer through the stove's window";
SI.EnergyFlowRate QrPExt
    "radiative heat transfer between the wood and the room";

// STOVE
parameter SI.Mass mP=113 "Stove's mass";
parameter SI.Mass mG=V_P*1.4 "Gas mass in combustion chamber";
parameter SI.Area S_L=0.03 "Wood surface";
parameter SI.Area S_P=1.07 "Inside stove surface";
parameter SI.Area S_PExt=3.5 "External stove surface";
parameter SI.Area S_Vitre=0.1421 "Window surface";
parameter SI.Area S_G=0.12219 "Gas surface";
parameter SI.Volume V_P=0.08 "Volume of combustion chamber";

// SMOKE
parameter Real contactratio=20
    "ratio of the stove's surface used in radiative heat transfer with smokes";  // divided by 100 within the code
SI.SpecificHeatCapacity CpF "Specific Heat Capacity of the smoke";
SI.EnergyFlowRate Q_F "Heat lost within the smoke";

// EVAPORATION
parameter Real A=51300000000;
parameter SI.Energy Ea=88000 "Activation energy for vaporization";

// CONDUCTION, CONVECTION, AND RADIATION
parameter SI.Emissivity eL=0.9 "Emissivity of the wood";
parameter SI.Emissivity eG=1 "Emissivity of the gas";
parameter SI.Emissivity eP=0.3 "Emissivity of the stove (intern)";
parameter SI.CoefficientOfHeatTransfer hccL=15.432
    "Heat transfer coefficient of the wood";
parameter SI.CoefficientOfHeatTransfer hccP=30.864
    "Heat transfer coefficient of the combustion chamber";
parameter SI.CoefficientOfHeatTransfer hccPExt=6.173
    "Heat transfer coefficient of the stove";
SI.CoefficientOfHeatTransfer hr "radiative heat transfer coefficient";
Real X "combustion coefficient X";
Real A1 "View factor";
Real A2 "View factor";
Real B1 "View factor";
Real B2 "View factor";
Real C1 "View factor";
Real C2 "View factor";

// PHASES MANAGEMENT
parameter Real dmi=2.77/3600 "Initial mass loss";
parameter SI.Time Taux=0.4*3600 "Response time";
parameter Real TauxEtoileCR=1.6 "Mass loss characteristic time";
parameter Real a=0.79573283 "Coefficient a";   // used in wood consumption equation
parameter Real b=0.18557385 "Coefficient b";   // used in wood consumption equation
parameter SI.Time t_sech=688 "Drying time";
parameter SI.Mass mPhase3=0.001
    "When this mass is reached, the fire is over: it's the 3rd phase";
Real tEtoile;
Real tCharge "Moment when wood is inserted into the stove";
Real tCharge2
    "Used to make a difference between the start of mE and mB loss if a start phase is required";

// START PHASE
SI.EnergyFlowRate Q_demarrage = eP*Modelica.Constants.sigma*S_P*(T_P^4 - C1*
      Tpiece^4) + eG*Modelica.Constants.sigma*S_G*(T_G^4 - B2*Tpiece^4) + hccL*
      S_L*((T_G) - Tpiece) "actual power in the chamber of combustion";   // if Q_demarrage>Q_fournie, then the start phase is not required
SI.EnergyFlowRate Q_fournie=300
    "estimated power required to start the combustion without warming phase";
SI.EnergyFlowRate Q_starting=1000;
Integer demarrage "true only during the start phase";

//---------------------------------------------------------------------------------------------------------------------
  Modelica.Blocks.Interfaces.RealInput Allure
    "Air rate (0,1 = reduced rate ; 0,3 = normal rate)"
                                              annotation (Placement(
        transformation(extent={{-112,26},{-82,56}}), iconTransformation(extent={{-98,40},
            {-82,56}})));
  Modelica.Blocks.Interfaces.RealOutput T_FenK "Window temperature"
    annotation (Placement(transformation(extent={{-6,82},{14,102}}),
        iconTransformation(extent={{-16,84},{-2,98}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Convection
    "Heat transmitted by convection to the room" annotation (Placement(
        transformation(extent={{68,40},{88,60}}), iconTransformation(extent={{
            68,40},{88,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Radiation
    "Heat transmitted by radiation to the room" annotation (Placement(
        transformation(extent={{68,-20},{88,0}}), iconTransformation(extent={{
            68,-20},{88,0}})));
  Modelica.Blocks.Interfaces.RealInput t_start
    "Time when the stove starts a new phase"  annotation (Placement(
        transformation(extent={{-112,-22},{-82,8}}), iconTransformation(extent={{-98,-14},
            {-82,2}})));
  Modelica.Blocks.Interfaces.RealOutput m_b "Mass of wood"
    annotation (Placement(transformation(extent={{76,-64},{112,-28}}),
        iconTransformation(extent={{72,-72},{86,-58}})));
  Modelica.Blocks.Interfaces.RealInput Tpiece "Room temperature in K"
                                              annotation (Placement(
        transformation(extent={{-76,-76},{-46,-46}}),iconTransformation(extent={{-74,-76},
            {-58,-60}})));
equation

// Initialization
when t_start>=time then             // if a forthcoming start is due
  reinit(mE,H*mL0/100);
  reinit(mB,mB0);
  tCharge=t_start;
end when;

if Q_demarrage>Q_fournie then
    demarrage=0;
elseif mE<0.01 then
    demarrage=0;
  else
    demarrage=1;
end if;

if pre(demarrage)==1 and demarrage==0 then
  tCharge2=time-t_sech;
elseif demarrage==0 and mB<=0.1 then
  tCharge2=tCharge;
else
  tCharge2=tCharge2;
end if;

// Masses statement
  m_b = mB;     // different name between the output and the local variable so that there's no confusion
  mL = mB+mE;
  tEtoile=(time-tCharge2-t_sech)/Taux;

// Mass of water
  if T_L<373 then
    der(mE)=0;
  else
    if mE>0.01 then
    der(mE)=-dmi;
    else
    der(mE)=-dmi*mE;
    end if;
  end if;

// Mass of dry wood
if demarrage==1 then
  der(mB)=0;
else
  if time <= tCharge+t_sech then
    der(mB)= 0;
  else
     if tEtoile<=TauxEtoileCR then
        der(mB)=(mB0)*(-a/Taux+2*b*tEtoile/Taux);
     elseif mB<0.005 then
        der(mB)=0;
     else
        der(mB)=-mB/Taux;
     end if;
  end if;
end if;

// Temperature calculation
if demarrage==1 then
   mG*CpG*der(T_G)=-QccLG+QccGP+QrGL+QrGP+QrVitre;
   mP*CpP*der(T_P)=QrPL-QccGP+QrPG+QccPExt+QrPExt;
  if T_L<373 then
   mL*CpL*der(T_L)=QccLG+QrLP+QrLG+Q_starting;
  else
   der(T_L)=0;
  end if;
else
  if mB>(0.20*mB0) then
    mL*CpL*der(T_L)=QccLG+QrLP+QrLG+Qpy+Qevap;
    mG*CpG*der(T_G)=-QccLG+QccGP+QrGL+QrGP+Qcomb+Q_F+QrVitre;
    mP*CpP*der(T_P)=QrPL-QccGP+QrPG+QccPExt+QrPExt;
  elseif mB>mPhase3 and mB<=(0.20*mB0) then
      mL*CpL*der(T_L)=QccLG+QrLP+(1-X)*Qcomb;
      mG*CpG*der(T_G)=-QccLG+QccGP+X*Qcomb+Q_F+QrVitre;
      mP*CpP*der(T_P)=QrPL-QccGP+QccPExt+QrPExt;
  else
     mL*CpL*der(T_L)=QccLG;
     mG*CpG*der(T_G)=-QccLG+QccGP+Q_F+QrVitre;
     mP*CpP*der(T_P)=-QccGP+QccPExt+QrPExt;
  end if;
end if;

// Calculation of smokes' data
  der(mF)=(1+(Allure+1)^2*((x+y/4-z/2)*(x*M_C+y*M_H+z*M_O))/(M_O2+0.79/0.21*M_N2))*(-der(mL));
  if demarrage==1 then
    CpF=524+1.84*(T_G)-3.76E-4*(T_G)^2;
  else
    CpF=3000+1.84*(T_G)-3.76E-4*(T_G)^2;
  end if;
  hr=4*eP*Modelica.Constants.sigma*T_P^3;
  if abs(der(mF))<=0 then
    T_FenK=T_P;
  else
    T_FenK=T_P+(T_G-T_P)*exp(-contactratio/100*S_P*(hccP+hr)/(der(mF)*CpF));
  end if;
  T_FenC=T_FenK-273.15;

// Calculation of view factor
  A1=(1+(1-eP)*(eL*S_L*T_L^4)/(eP*S_P*T_P^4))/(1 + (1 - eP)*(eL*S_L)/(eP*S_P));
  A2=(1+(1-eG)*(eL*S_L*T_L^4)/(eG*S_G*T_G^4))/(1 + (1 - eG)*(eL*S_L)/(eG*S_G));
  B1=(1+(1-eP)*(eG*S_G*T_G^4)/(eP*S_P*T_P^4))/(1 + (1 - eP)*(eG*S_G)/(eP*S_P));
  B2=(1+(1-eL)*(eG*S_G*T_G^4)/(eL*S_L*T_L^4))/(1 + (1 - eL)*(eG*S_G)/(eL*S_L));
  C1=(S_L/S_P)*(1-(1-eL)*eP*T_P^4/(eL*T_L^4))/(1 + eP*S_L*(1 - eL)/(S_P*eL));
  C2=(S_G/S_P)*(1-(1-eG)*eP*T_P^4/(eG*T_L^4))/(1 + eP*S_G*(1 - eG)/(S_P*eG));

// Calculation of Specific Heat Capacities
  CpL=100+3.7*T_L;
  CpG=524+1.84*T_G-3.76E-4*T_G^2;
  if demarrage==1 then
    CpP=313.5+0.52*T_P;
  else
    CpP=1000+0.52*T_P;
  end if;

// Heat
  Qpy=der(mB)*Hpy;
  Qevap=der(mE)*Hevap;
  Qcomb=-der(mB)*PCI;
  X=(mB/(0.20*mB0))^2;
  Q_F=-der(mF)*CpF*(T_FenK-Tpiece);
  QccLG=-hccL*S_L*(T_L-T_G);
  QrLP=-eL*Modelica.Constants.sigma*S_L*(T_L^4-A1*T_P^4);
  QrLG=-eL*Modelica.Constants.sigma*S_L*(T_L^4-A2*T_G^4);
  QrGP=-eG*Modelica.Constants.sigma*S_G*(T_G^4-B1*T_P^4);
  QrGL=-eG*Modelica.Constants.sigma*S_G*(T_G^4-B2*T_L^4);
  QrPL=-eP*Modelica.Constants.sigma*S_P*(T_P^4-C1*T_L^4);
  QrPG=-eP*Modelica.Constants.sigma*S_P*(T_P^4-C2*T_G^4);
  QccGP=-hccP*S_P*(T_G-T_P);
  QccPExt=-hccPExt*S_PExt*(T_P-Tpiece);
  QrPExt=-eP*Modelica.Constants.sigma*S_PExt*(T_P^4-Tpiece^4);
  QrVitre=-eG*Modelica.Constants.sigma*S_Vitre*(T_G^4-Tpiece^4);

//Répartition des flux de chaleurs
  Convection.Q_flow=QccPExt;
  Radiation.Q_flow=QrVitre+QrPExt;

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-82,82},{58,-84}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-72,64},{52,-44}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{34,-84},{46,-100}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{12,-2},{40,-28}},
          fillColor={108,80,80},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-40,-16},{24,-2},{30,-28},{-36,-42},{-34,-42},{-36,-42},{-40,
              -16}},
          smooth=Smooth.None,
          fillColor={104,77,77},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-52,-16},{-24,-42}},
          fillColor={207,138,69},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-28,-14},{-56,32},{-30,22},{-28,24},{-18,60},{2,34},{22,48},{
              18,-8},{-28,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-14},{-36,16},{-22,16},{-14,46},{2,24},{16,36},{12,-10},{
              -20,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,179,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,-14},{-22,4},{-8,2},{-10,22},{-2,0},{-2,2},{8,16},{2,-12},
              {-12,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-54},{-58,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,76},{54,76}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,78},{54,78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,74},{54,74}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,72},{54,72}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,70},{54,70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,68},{54,68}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-72,-48},{56,-48}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-72,-46},{56,-46}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-72,-50},{56,-50}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-20,100},{0,82}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-66,-54},{-64,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,-54},{-52,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,-54},{-46,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,-54},{-40,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-36,-54},{-34,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-30,-54},{-28,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,-54},{-22,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-18,-54},{-16,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,-54},{-10,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,-54},{-4,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,-54},{2,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{6,-54},{8,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{12,-54},{14,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{18,-54},{20,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,-54},{26,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{30,-54},{32,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{36,-54},{38,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{42,-54},{44,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{48,-54},{50,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-64,-84},{-52,-100}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-100,-66},{-94,-64},{-90,-68},{-84,-64},{-78,-68},{-74,-66}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-100,-70},{-94,-68},{-90,-72},{-84,-68},{-78,-72},{-74,-70}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{72,2},{72,14},{70,12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{80,2},{80,14},{82,12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{76,14},{76,2},{78,6}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{72,14},{74,12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{76,2},{74,6}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{80,14},{78,12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{74,62},{76,64},{74,68},{74,70},{76,72},{76,74}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{82,62},{84,64},{82,68},{82,70},{84,72},{84,74}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{78,62},{80,64},{78,68},{78,70},{80,72},{80,74}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{74,72},{76,74},{78,72},{80,74},{82,72},{84,74},{86,72}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{84,14},{84,2},{86,6}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{84,2},{82,6}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>Log stove (by default 3,6 kg)</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The model connects directly to the air node of the heated room. </p>
<p><u><b>Bibliography</b></u></p>
<p>detailled model is the note :H-E14-2011-01955-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EIFER 07/2011</p>

<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Hubert Blervaque - Juin 2012</p>
<p>Prise en compte du message suivant : <font style=\"color: #ff0000; \">/// Rque Aurélie Kaemmerlen, 10/2011 : ATTENTION, les initialisations sur <code>T_L, T_G et T_P(start=Tpiece)</code> sont invalides car Tpiece n'est pas un paramètre mais une variable. Cette initialisation n'est donc pas utilisée par Dymola</font></p>
</html>"));
end LogStove;
