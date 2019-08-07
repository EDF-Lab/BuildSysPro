within BuildSysPro.Building.BuildingEnvelope.Functions;
function CalculAlphaTauDoubleGlazing
  "Calculation of absorption and transmission coefficients of a double glazing window"

  input Modelica.SIunits.CoefficientOfHeatTransfer Uw
    "Heat transfert coefficient of the window";
  input Real g "Solar factor of the window [between 0 and 1]";
  input Real tau0 "Coefficient of energy transmission [between 0 and 1]";
  input Modelica.SIunits.CoefficientOfHeatTransfer Hext=21
    "Global surface exchange coefficient on the outer face of the window";
  input Modelica.SIunits.CoefficientOfHeatTransfer Hint=8.29
    "Global surface exchange coefficient on the inner face of the window";
  output Real alpha_dir "Direct absorption coefficient of the window";
  output Real alpha_dif "Diffuse absorption coefficient of the window";
  output Real tau_dir "Direct transmission coefficient of the window";
  output Real tau_dif "Diffuse transmission coefficient of the window";

protected
  Real rho_dir;
  Real rho_dif;
  Real alpha_30;
  Real alpha_60;
  Real tau_30;
  Real tau_60;
  Real a1;
  Real a2;
  Real a3;
  Real b1;
  Real b2;
  Real b3;

algorithm
  //Direct coefficients (standard EN 410)
  //First glazing
  alpha_dir := (g-tau0)/(1+Uw*((1/Hext)-(1/Hint)));
  tau_dir := ((2*tau0*(1-alpha_dir))+sqrt((2*tau0*(1-alpha_dir))^2+4*(1+tau0)*tau0*alpha_dir*(2-alpha_dir)))/(2*(1+tau0));
  rho_dir := 1-alpha_dir-tau_dir;
  //Global glazing
  tau_dir := (tau_dir)^2/(1-(rho_dir)^2);
  rho_dir := rho_dir*(1+tau_dir);
  alpha_dir := 1-tau_dir-rho_dir;

  //Diffuse coefficients (method Th-S from RT)
  alpha_30 := -8.5884e-4+1.0869*alpha_dir-6.1151e-2*(alpha_dir^2);
  alpha_60 := -1.7566e-3+1.2352*alpha_dir-2.7231e-1*(alpha_dir^2);
  tau_30 := -7.068e-4+9.3967e-1*tau_dir+7.0476e-2*(tau_dir^2);
  tau_60 := -1.6265e-2+6.9767e-1*tau_dir+2.4509e-1*(tau_dir^2);
  a1 := 6.4646*alpha_dir-11.7745*alpha_30+9.4645*alpha_60;
  a2 := -20.394*alpha_dir+35.3234*alpha_30-20.394*alpha_60;
  a3 := 14.9294*alpha_dir-23.5489*alpha_30+10.9295*alpha_60;
  b1 := 6.4646*tau_dir-11.7745*tau_30+9.4645*tau_60;
  b2 := -20.394*tau_dir+35.3234*tau_30-20.394*tau_60;
  b3 := 14.9294*tau_dir-23.5489*tau_30+10.9295*tau_60;
  alpha_dif := (a1/3+a2/4+a3/5)*2;
  tau_dif := (b1/3+b2/4+b3/5)*2;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function calculates the absorption and transmission coefficients of a double glazing window, for direct and diffuse solar fluxes, from manufacturer data :
<ul><li>Uw : Heat transfert coefficient of the window [W/m².K]</li>
<li>g : Solar factor of the glazing [between 0 and 1]</li>
<li>tau0 : Coefficient of energy transmission of the glazing [between 0 and 1]</li></ul></p>
<p><u><b>Bibliography</b></u></p>
<p>Standard EN 410 for calculation of equivalent coefficients for direct solar flux on normal incidence.</p>
<p>Method Th-S from RT for calculation of equivalent coefficients for diffuse solar flux.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 02/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Benoît CHARRIER, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 08/2017 : correction of errors in documentation and parameter naming, manufacturer data needed are the coefficient of energy transmission of the glazing (tau0) and the solar factor of the glazing (g).</p>
</html>"));
end CalculAlphaTauDoubleGlazing;
