within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record BuildingType "List of Mozart individual housing construction dates"

// Walls
  // Wall type
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall PlancherBas "Floor"
    annotation (Dialog(tab="Walls", group="Exterior walls"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    ParoiSousCombles "Attic wall" annotation (Dialog(tab="Walls", group=
          "Exterior walls"), choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Porte "Door"
    annotation (Dialog(tab="Walls", group="Exterior walls"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Mur
    "Exterior wall"
    annotation (Dialog(tab="Walls", group="Exterior walls"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Cloisons
    "Partition wall"
    annotation (Dialog(tab="Walls", group="Interior walls"),
      choicesAllMatching=true);
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall Refends
    "Supporting wall"
    annotation (Dialog(tab="Walls", group="Interior walls"),
      choicesAllMatching=true);

  // Optical properties
  parameter Real alphaExt=0.3
    "Absorption coefficient of exterior walls in the visible spectrum" annotation(Dialog(tab="Walls",group="Exterior walls"));
  parameter Real eps=0
    "Emissivity of exterior walls for long wavelength radiation"                    annotation(Dialog(tab="Walls",group="Exterior walls"));

  // Global exchange coefficients (convective and radiative)
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsExtVert=25
    "Surface exchange coefficient on the outer face of vertical walls"                annotation(Dialog(tab="Thermal flows",group="Surface exchange coefficients (Warning : take care to consider or not long wavelength radiation exchanges according to GLOEXT parameter)"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsIntVert = 7.69
    "Surface exchange coefficient on the inner face of vertical walls"                annotation(Dialog(tab="Thermal flows",group="Surface exchange coefficients (Warning : take care to consider or not long wavelength radiation exchanges according to GLOEXT parameter)"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsIntHorHaut=10
    "Surface exchange coefficient on the inner face of horizontal walls when the thermal flow is upwards"
                                                                                                        annotation(Dialog(tab="Thermal flows",group="Surface exchange coefficients (Warning : take care to consider or not long wavelength radiation exchanges according to GLOEXT parameter)"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hsIntHorBas=5.88
    "Surface exchange coefficient on the inner face of horizontal walls when the thermal flow is downwards"
                                                                                                        annotation(Dialog(tab="Thermal flows",group="Surface exchange coefficients (Warning : take care to consider or not long wavelength radiation exchanges according to GLOEXT parameter)"));

// Glazings
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UvitrageAF
    "Coefficient of heat transfert of the window with closing (conduction+convection)"     annotation (Dialog(tab="Windows"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UvitrageSF
    "Coefficient of heat transfert of the window without closing (conduction+convection)"  annotation (Dialog(tab="Windows"));

  // Description of windows or French windows
  parameter Real transmissionMenuiserieFenetres=(1-0.3)*0.9
    "Light transmission due to window frame" annotation (Dialog(tab="Windows"));
  parameter Real transmissionMenuiseriePortesFenetres=(1-0.33)*0.9
    "Light transmission due to French window frame" annotation (Dialog(tab="Windows"));
  parameter Real eps_vitrage=0 "Emissivity in long wavelength radiation" annotation (Dialog(tab="Windows"));

// Air renewal and infiltration
  parameter Real renouvAir "Air renewal rate in vol/h" annotation(Dialog(tab="Thermal flows", group="Air renewal"));

// Thermal bridges
  parameter Real ValeursK[9]
    "K coefficient for each linear heat loss relating to a thermal bridge in [W/(m.K)]"                   annotation(Dialog(tab="Thermal bridges"));
  parameter Real TauPonts[9] "Tau reduction coefficient of each thermal bridge"                  annotation(Dialog(tab="Thermal bridges"));

// Boundary conditions
  parameter Real     bLNC=0
    "Weighting coefficient of boundary conditions in temperature for unheated rooms"                   annotation(Dialog(tab="Boundary conditions in temperature"));
  parameter Real     bPlancher
    "Weighting coefficient of boundary conditions in temperature for crawl space"               annotation(Dialog(tab="Boundary conditions in temperature"));
  parameter Real     bSousCombles
    "Weighting coefficient of boundary conditions in temperature for attic"               annotation(Dialog(tab="Boundary conditions in temperature"));
  annotation (Documentation(info="<html>
<p><i><b>Record of Mozart monozone individual housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end BuildingType;
