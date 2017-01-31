within BuildSysPro.Utilities.Records;
record MeteoData "Record to facilitate weather data entry"

parameter Modelica.SIunits.Conversions.NonSIunits.Time_hour h0=-1
    "Universal time (in hours) at t=0 / h0=-1 for Meteonorm because data are in TU+1";
    parameter Real d0 = 1 "Number of the day in the year at t=0";
parameter Boolean Est = false
    "Est=true : longitude given in °East, otherwise in °West / Meteonorm is in °East";

// Configuration of the model : choice of input flux
parameter Integer CoupleFlux=2 "Solar flux 1 and 2 given in the G input vector"
                                                     annotation(choices(
choice=1 "GLOH DIFH", choice=2 "DIRN DIFH",choice=3 "DIFH DIRH", choice=4
        "GLOH DIRH", choice=5 "GLOH DIRN",radioButtons=true));

  annotation (Documentation(revisions="<html>
<p>11/2014 Amy Lindsay : suppression des paramètres MoyFlux et intervalle de temps qui deviennent obsolètes avec le nouveau Meteofile. Choix de toujours se ramener au milieu de l'intervalle des flux mesurés et moyennés</p>
</html>", info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end MeteoData;
