within BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal.ThermalRecordsPV;
record RecordTechnoPV
  "Record permettant d'enregistrer pour chaque technologie PV un ensemble de caractéristiques servant aux modèles thermiques"

  parameter Integer n=7 "nombre de couches du panneau PV";
  parameter Integer ncell=3
    "niveau auquel se situe la cellule PV (à partir de la face avant)";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat[n]
    "matériaux constitutifs du panneau PV (face avant vers face arrière)";
  parameter Modelica.SIunits.Length epaisseur[n]
    "Épaisseur des couches du panneau PV (face avant vers face arrière)";
  parameter Integer[n] m=fill(1, n)
    "nombre de mailles par couche (face avant vers face arrière)";
  parameter Real cp_surf "capacité thermique du panneau PV par m² (J/K.m²)";
  parameter Modelica.SIunits.Emissivity eps_fg
    "émissivité de la face avant en GLO";
  parameter Modelica.SIunits.Emissivity eps_bg
    "émissivité de la face arrière en GLO";
  parameter Real alpha_tau_n
    "transmission - absorption du panneau PV sous incidence normale";

  annotation (Documentation(info="<html>
<p><i><b>Record permettant d'enregistrer pour chaque technologie PV un ensemble de caractéristiques servant aux modèles thermiques</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p></html>"));
end RecordTechnoPV;
