within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record BuildingType "Liste de paramètres physiques d'un bâtiment"

// Parois
  // Types des parois
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall PlancherBas
    annotation (Dialog(tab="Parois", group="Parois extérieures"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    ParoiSousCombles annotation (Dialog(tab="Parois", group=
          "Parois extérieures"), choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Porte
    annotation (Dialog(tab="Parois", group="Parois intérieures"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Mur
    annotation (Dialog(tab="Parois", group="Parois extérieures"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Cloisons
    annotation (Dialog(tab="Parois", group="Parois intérieures"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Refends
    annotation (Dialog(tab="Parois", group="Parois intérieures"),
      choicesAllMatching=true);

  // Propriétés optiques
  parameter Real alphaExt=0.3
    "Coefficient d'absorption des parois extérieures dans le visible" annotation(Dialog(tab="Parois",group="Parois extérieures"));
  parameter Real eps=0
    "Emissivité des parois extérieures en grande longueur d'onde"                    annotation(Dialog(tab="Parois",group="Parois extérieures"));

  // Coefficients d'échange globaux (convection et rayonnement)
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsExtVert=25
    "Coefficient d'échange surfacique sur la face extérieure des parois verticales"
                                                                                      annotation(Dialog(tab="Flux thermiques",group="Coefficients d'échanges surfaciques (attention à prendre en compte ou non les échanges en GLO en fonction du paramètre GLOEXT)"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsIntVert = 7.69
    "Coefficient d'échange surfacique sur la face intérieure des parois verticales"
                                                                                      annotation(Dialog(tab="Flux thermiques",group="Coefficients d'échanges surfaciques (attention à prendre en compte ou non les échanges en GLO en fonction du paramètre GLOEXT)"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsIntHorHaut=10
    "Coefficient d'échange surfacique sur la face intérieure des parois horizontales lorsque l'échange thermique se fait vers le haut"
                                                                                                        annotation(Dialog(tab="Flux thermiques",group="Coefficients d'échanges surfaciques (attention à prendre en compte ou non les échanges en GLO en fonction du paramètre GLOEXT)"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsIntHorBas=5.88
    "Coefficient d'échange surfacique sur la face intérieure des parois horizontales lorsque l'échange thermique se fait vers le bas"
                                                                                                        annotation(Dialog(tab="Flux thermiques",group="Coefficients d'échanges surfaciques (attention à prendre en compte ou non les échanges en GLO en fonction du paramètre GLOEXT)"));

// Vitrages
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UvitrageAF
    "Coefficient de transfert thermique du vitrage avec fermeture (conduction+convection)"
                                                                                           annotation (Dialog(tab="Fenêtres"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UvitrageSF
    "Coefficient de transfert thermique du vitrage sans fermeture (conduction+convection)"
                                                                                           annotation (Dialog(tab="Fenêtres"));

  // Descriptions des fenêtres et portes fenêtre
  parameter Real transmissionMenuiserieFenetres=(1-0.3)*0.9
    "transmission de lumière due à la menuiserie des fenêtres" annotation (Dialog(tab="Fenêtres"));
  parameter Real transmissionMenuiseriePortesFenetres=(1-0.33)*0.9
    "transmission de lumière due à la menuiserie des portes fenêtres" annotation (Dialog(tab="Fenêtres"));
  parameter Real eps_vitrage=0 "Emissivité en grande longueur d'onde" annotation (Dialog(tab="Fenêtres"));

// Renouvellement d'air et infiltration
  parameter Real renouvAir "Taux de renouvellement d'air en vol/h" annotation(Dialog(tab="Flux thermiques", group="Renouvellement d'air"));

// Ponts thermiques
  parameter Real ValeursK[9]
    "Valeurs du coefficient k pour chaque déperdition linéique relative à un pont thermique en W/m²K"
                                                                                                       annotation(Dialog(tab="Ponts thermiques"));
  parameter Real TauPonts[9]
    "Coefficients tau de réduction de chaque pont thermique"                                           annotation(Dialog(tab="Ponts thermiques"));

// Conditions limites
  parameter Real     bLNC=0
    "Coefficient de pondération des conditions limites en température pour les locaux non chauffés"
                                                                                                       annotation(Dialog(tab="CL Température"));
  parameter Real     bPlancher
    "Coefficient de pondération des conditions limites en température pour le vide sanitaire"
                                                                                                annotation(Dialog(tab="CL Température"));
  parameter Real     bSousCombles
    "Coefficient de pondération des conditions limites en température pour les combles"
                                                                                          annotation(Dialog(tab="CL Température"));
  annotation (Documentation(info="<html>
<p><i><b>Record pour renseigner les paramètres de la MI Mozart en fonction de l'année de construction</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>Site de la bibliothèque des bâtiments types</p>
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
end BuildingType;
