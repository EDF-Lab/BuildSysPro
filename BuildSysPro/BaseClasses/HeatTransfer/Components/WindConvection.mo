within BuildSysPro.BaseClasses.HeatTransfer.Components;
model WindConvection
  "Convective heat exchange coefficient of a wall taking into account wind speed and direction"
  extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

parameter Boolean VitesseVent=false
    "Taking into account wind speed in the calculation of the outside convective heat exchange coefficient"
  annotation(Dialog(compact=true),choices(choice=true "Yes", choice=false "No", radioButtons=true));

parameter Boolean GLOext=false
    "Taking into account infrared radiation between the wall and the sky"
    annotation(Dialog(compact=true),choices(choice=true "Yes", choice=false "No", radioButtons=true));

parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=25
    "Convective surface heat exchange coefficient on the outside - depending on the settings (GLOext and VitesseVent), hs_ext can be purely convective or purely radiative";

parameter Modelica.SIunits.Area S "Exchange surface";
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Azimut of the surface (relative to the south) - S=0°, E=-90°, W=90°, N=180°";
 parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°";

Modelica.Blocks.Interfaces.RealInput V[2] if VitesseVent
    "Wind speed [m/s] and direction (0° - North, 90° - East, 180° - South, 270° - West)"            annotation (Placement(transformation(
          extent={{-120,50},{-80,90}}), iconTransformation(extent={{-14,-14},{14,
            14}},
        rotation=-90,
        origin={0,74})));

protected
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hrad_cst = if GLOext then 0 else hs_ext;
protected
  Modelica.Blocks.Interfaces.RealInput V_in[2]
    "Internal connector, needed if conditional connexion";
public
 Modelica.SIunits.CoefficientOfHeatTransfer h_vent
    "Convective heat exchange coefficient on the outside";

public
function correlation
  input Real V[2] "Wind speed and direction";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
      "Azimut of the surface (relative to the south) - S=0°, E=-90°, W=90°, N=180°";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
      "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°";
  output Modelica.SIunits.CoefficientOfHeatTransfer h_vent
      "Convective surface heat exchange coefficient due to wind";

//Coefficient a of the equation hcv = a*v^n+b
  //Windward façade (exposed to wind)
  protected
  parameter Real a1=3.06;
  parameter Real n1=1;
  parameter Real b1=5.44;
  //Leeward façade
  parameter Real a2=0.34;
  parameter Real n2=1;
  parameter Real b2=7.99;

  Boolean AuVent "Windward façade (exposed to wind) if =true";

algorithm
  if incl<180 and incl >0 then
    AuVent := if cos((azimut+180-V[2])*Modelica.Constants.pi/180)>0 then true else false;
  else
    AuVent := false;
  end if;

  if AuVent then
    h_vent :=a1*max(0, V[1])^n1 + b1;
  else
    h_vent :=a2*max(0, V[1])^n2 + b2;
  end if;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end correlation;

equation
connect(V_in, V);
  if not VitesseVent then
    V_in= {0,0};
  end if;

if VitesseVent then
  h_vent = correlation(V=V_in, azimut=azimut, incl=incl);
  Q_flow =(h_vent+hrad_cst)*dT*S;
else
  h_vent = 0;
  Q_flow = hs_ext*dT*S;
end if;

annotation(Dialog(enable=VitesseVent),
           Dialog(enable=VitesseVent),
           Dialog(enable=VitesseVent),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                               graphics={Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),            graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model to calculate the convective heat exchange coefficient on the outside, depending on the wind speed and direction, for an horizontal or vertical wall.</p>
<p>Correlation comes from notice TF112 of CLIM2000, for these two specific cases :
<ul><li>Windward façade (when wind is directed to the façade)</li>
<li>Leeward façade (when wind is directed to another direction)</li></ul></p>
<p>An horizontal wall will be automatically considered as a leeward façade.</p>
<p><u><b>Bibliography</b></u></p>
<p>See notice TF112 from CLIM2000.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The model could be improved adding different correlations (roughness of the surface, tilt, wind direction...).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Aurélie KAEMMERLEN, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WindConvection;
