within BuildSysPro.Systems.Distribution;
model StorageTankFloatingSection
  "Storage tank model with variable volumes"

parameter Modelica.SIunits.Volume Vtot=0.050 "Tank volume"  annotation(Dialog(group = "Geometrical parameters"));
parameter Real r=2 "Aspect ratio :  height/diameter"  annotation(Dialog(group = "Geometrical parameters"));
parameter Real xHaut(max=0.95)=0.9
    "Relative position of water input and output of the upper part (hot) of the tank" annotation(Dialog(group = "Geometrical parameters"));
parameter Real xBas(min=0.05)=0.1
    "Relative position of water input and output of the lower part (cold) of the tank" annotation(Dialog(group = "Geometrical parameters"));
    parameter Modelica.SIunits.Length eI=0.044 "Insulation thickness"
    annotation(Dialog(group = "Insulation"));
parameter Modelica.SIunits.ThermalConductivity lambdaI=0.035
    "Conductivité de l'isolant en W/(m.K)"  annotation(Dialog(group = "Insulation"));
parameter Modelica.SIunits.Density rho=1000 "Water density"
    annotation(Dialog(group = "Fluid characteristics"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp=4180
    "Water specific heat capacity" annotation(Dialog(group = "Fluid characteristics"));
parameter Modelica.SIunits.ThermalConductivity lambdaE=0.62
    "Water thermal conductivity (no convection, only conduction)"  annotation(Dialog(group = "Fluid characteristics"));

//Initialization
parameter Modelica.SIunits.Temperature TinitHaut=323.15
    "Initial temperature of hot water in the upper part"  annotation(Dialog(group = "Initialization"));
parameter Modelica.SIunits.Temperature TinitBas=288.15
    "Initial temperature of cold water in the lower part"  annotation(Dialog(group = "Initialization"));

protected
  parameter Modelica.SIunits.Mass mTot=rho*Vtot;
  constant Real pi=Modelica.Constants.pi;
  parameter Modelica.SIunits.Length D=(4*Vtot/(r*pi))^(1/3)
    "Diameter of the tank";
  parameter Modelica.SIunits.Length h=r*D "Height of the tank";
  parameter Modelica.SIunits.Area S=pi*D^2/4 "Horizontal section of the tank";
  parameter Modelica.SIunits.Area Alat=pi*D*h
    "External lateral surface of the tank";
  parameter Real U=lambdaI/eI "Transmission coefficient in W/(m2.K)";

//Variables
public
Modelica.SIunits.Mass mFroid(start=0.5*mTot);
Modelica.SIunits.MassFlowRate dm;
Real x "Relative position of hot/cold separation (between 0 and 1)";
Modelica.SIunits.Area Abas=S+x*Alat "Lower exchange surface";
Modelica.SIunits.Area Ahaut=S+(1-x)*Alat "Upper exchange surface";
Modelica.SIunits.Power PerteBas;
Modelica.SIunits.Power PerteHaut;
Modelica.SIunits.Power CondBasHaut;
Modelica.SIunits.Temperature Tbas(start=TinitBas);
Modelica.SIunits.Temperature Thaut(start=TinitHaut);

//Verification
Modelica.SIunits.Power He;
Modelica.SIunits.Power Hs;
Modelica.SIunits.Power deltaH;
Modelica.SIunits.Energy EcartEnergie;

  Modelica.Blocks.Interfaces.RealInput PrimaireChaud[2]
    "Starting point of primary hydraulic circuit / 1-fluid temperature (K), 2-flow rate (kg/s)" annotation (Placement(
        transformation(extent={{-120,20},{-80,60}}), iconTransformation(
          extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Interfaces.RealInput SecondaireFroid[2]
    "Ending point of secondary hydraulic circuit / 1-fluid temperature (K), 2-flow rate (kg/s)" annotation (Placement(transformation(
          extent={{120,-80},{80,-40}}), iconTransformation(extent={{100,-60},
            {80,-40}})));
  Modelica.Blocks.Interfaces.RealOutput SecondaireChaud[2]
    "Starting point of secondary hydraulic circuit / 1-fluid temperature (K), 2-flow rate (kg/s)" annotation (Placement(transformation(
          extent={{80,20},{120,60}}),  iconTransformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Interfaces.RealOutput PrimaireFroid[2]
    "Ending point of primary hydraulic circuit / 1-fluid temperature (K), 2-flow rate (kg/s)" annotation (Placement(
        transformation(extent={{-80,-80},{-120,-40}}), iconTransformation(
          extent={{-80,-60},{-100,-40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tamb
    "Ambient tamperature around the tank" annotation (
      Placement(transformation(extent={{80,0},{100,20}}), iconTransformation(
          extent={{80,0},{100,20}})));
equation
  // Equality of flow rates in primary and secondary hydraulic networks
  PrimaireChaud[2]=PrimaireFroid[2];
  SecondaireChaud[2]=SecondaireFroid[2];

// Mass and thermal balances of cold water in the tank
  dm = SecondaireFroid[2] - PrimaireChaud[2];
  x  = mFroid/mTot;
  if noEvent(dm>0 and x>xHaut) then    //the tank is full of cold water
    der(mFroid)=0;
     x*mTot*Cp*der(Tbas)+ SecondaireFroid[2]*Cp*(Tbas-SecondaireFroid[1]) + PerteBas + CondBasHaut =0;
     (1-x)*mTot*Cp*der(Thaut)+ PrimaireChaud[2]*Cp*(Thaut-PrimaireChaud[1]) - abs(dm)*Cp*(Tbas-Thaut) + PerteHaut - CondBasHaut =0;
  elseif noEvent(dm<0 and x<xBas) then //the tank is full of hot water
    der(mFroid)=0;
    x*mTot*Cp*der(Tbas)+ SecondaireFroid[2]*Cp*(Tbas-SecondaireFroid[1]) + abs(dm)*Cp*(Tbas-Thaut)+ PerteBas + CondBasHaut =0;
    (1-x)*mTot*Cp*der(Thaut)+ PrimaireChaud[2]*Cp*(Thaut-PrimaireChaud[1]) +PerteHaut - CondBasHaut =0;
  else
    der(mFroid)= dm;
    x*mTot*Cp*der(Tbas)+ SecondaireFroid[2]*Cp*(Tbas-SecondaireFroid[1]) + PerteBas + CondBasHaut =0;
    (1-x)*mTot*Cp*der(Thaut)+ PrimaireChaud[2]*Cp*(Thaut-PrimaireChaud[1]) + PerteHaut - CondBasHaut =0;
  end if;

// Thermal exchanges : thermal losses of the tank in the room and fluid conduction at hot/cold section
  PerteBas = Abas*U*(Tbas-Tamb.T);
  PerteHaut = Ahaut*U*(Thaut-Tamb.T);
  Tamb.Q_flow = - Abas*U*(Tbas-Tamb.T) - Ahaut*U*(Thaut-Tamb.T);
  CondBasHaut = S*lambdaE/(h/2)*(Tbas-Thaut);

//The mixture is considered as ideal in a zone and output temperatures are the ones of the zone
  PrimaireFroid[1]=Tbas;
  SecondaireChaud[1]=Thaut;

//VERIFICATION
  He=Cp*(PrimaireChaud[2]*PrimaireChaud[1]+SecondaireFroid[2]*SecondaireFroid[1]);
  Hs=Cp*(PrimaireFroid[2]*PrimaireFroid[1]+SecondaireChaud[2]*SecondaireChaud[1]);
  deltaH=Hs-He;
  der(EcartEnergie)=Hs-He-Tamb.Q_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Ellipse(
          extent={{-60,-60},{60,-100}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-60,100},{60,60}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,78},{60,-36}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-34},{60,-80}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                        graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic model of a bizonal tank with variable volumes.</p>
<p>In order to take into account the &QUOT;piston effect&QUOT; between the hot and cold water in a tank where the hot water is injected at the upper level and the cold water by the lower level, the volumes of water vary between these entries.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 01/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hubert BLERVAQUE, EDF (2012)<br>
--------------------------------------------------------------</b></p></html>",
      revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T & m_flow.</p>
</html>"));
end StorageTankFloatingSection;
