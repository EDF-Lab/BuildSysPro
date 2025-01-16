within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
model FixedSolarProtection
  //Data related to the glazed surface
  parameter Modelica.Units.SI.Distance Hauteur_mur=2.5
    "Total height of the wall surface";
  parameter Modelica.Units.NonSI.Angle_deg Angle_inclinaison=90
    "Angle of inclination of the wall surface relative to the floor";
  parameter Modelica.Units.NonSI.Angle_deg Azimut_surface=0
    "Azimuth of the wall surface";
  parameter Modelica.Units.SI.Distance Hauteur_basse_vitrage=0
    "Height at which the bottom of the glazing is located / currently unused in the model";
  parameter Modelica.Units.SI.Distance Hauteur_vitrage=2.15
    "Height of the glazing (glass + frame)";
  parameter Modelica.Units.SI.Distance largeur_vitrage=1.2
    "Width of the glazing (glass + frame)";
  final parameter Modelica.Units.SI.Area Surface_vitrage=Hauteur_vitrage*
      largeur_vitrage
    "Total surface area of the glazed area including the frame";
  parameter Real Proportion_cadre = 0.25 "Proportion of the frame surface relative to the total glazed surface";
  final parameter Modelica.Units.SI.Distance Epaisseur_cadre=(
      Hauteur_vitrage + largeur_vitrage)/4 - sqrt((Hauteur_vitrage +
      largeur_vitrage)*(Hauteur_vitrage + largeur_vitrage)/4 -
      Proportion_cadre*Surface_vitrage)/2
    "Thickness of the frame surrounding the glazing";
  final parameter Modelica.Units.SI.Area Surface_cadre=Proportion_cadre*
      Surface_vitrage "Surface du cadre";
  final parameter Modelica.Units.SI.Area Surface_vitre=(1 -
      Proportion_cadre)*Surface_vitrage "Glazed surface";
  //Data related to horizontal solar shading
  parameter Modelica.Units.SI.Distance Distance_VC_horizontale=0.35
    "Distance between the upper edge of the glazing and the horizontal solar shading";
  parameter Modelica.Units.SI.Distance l_protection_horizontale=0.5
    "Width of the horizontal shading";
  //CONSIDERATION OF THE FOLLOWING PARAMETER TO BE INTEGRATED INTO THE MODEL
  parameter Modelica.Units.SI.Distance L_protection_horizontale=1
    "Length of the horizontal shading";

  //Data related to horizontal solar protections
  parameter Modelica.Units.SI.Distance Distance_VC_verticale=0.3
    "Distance between the lateral edges of the glazing and the vertical solar protections";
  parameter Modelica.Units.SI.Distance l_protection_verticale=0.5
    "Width of the vertical solar protections";
  //CONSIDERATION OF THE FOLLOWING PARAMETER TO BE INTEGRATED INTO THE MODEL
  parameter Modelica.Units.SI.Distance L_protection_verticale=2
    "Length of the vertical solar protections";

  parameter Real DiffusSol= 0;

  Modelica.Units.SI.Distance Hauteur_ombre
    "Distance between the upper solar protection and the bottom of the shaded area";
  Modelica.Units.SI.Distance Largeur_ombre_droite
    "Distance between the right solar protection and the left side of the shaded area";
  Modelica.Units.SI.Distance Largeur_ombre_gauche
    "Distance between the left solar protection and the right side of the shaded area";
  Modelica.Units.SI.Area S_ombre
    "Surface of the glazing (glass + frame) in the shadow";
  Modelica.Units.SI.Area S_lumiere
    "Surface of the glazing (glass + frame) in the light";
  Modelica.Units.SI.Area S_ombre_vitre "Glazed surface in the shadow";
  Modelica.Units.SI.Area S_lumiere_vitre "Glazed surface in the light";
  Modelica.Units.SI.Area S_ombre_cadre "Frame surface in the shadow";
  Modelica.Units.SI.Area S_lumiere_cadre
    "Frame surface in the light";
  Modelica.Units.SI.Area Composante_H
    "Shaded surface created by the presence of the horizontal shading";
  Modelica.Units.SI.Area Composante_V_d
    "Shaded surface created by the presence of the right vertical shading";
  Modelica.Units.SI.Area Composante_V_g
    "Shaded surface created by the presence of the left vertical shading";
  Modelica.Units.SI.Area Composante_mixte_d
    "Shaded surface created by the presence of both the horizontal shading and the right vertical shading";
  Modelica.Units.SI.Area Composante_mixte_g
    "Shaded surface created by the presence of both the horizontal shading and the left vertical shading";
Real Repere "Permet le traçage du fonctionnement de l'algorithme";
Real Cos_Delta_Az=cos((Azimut_surface - Azimut)*Modelica.Constants.pi/180);

  Modelica.Blocks.Interfaces.RealInput G[10]
    "Output data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle , Solar elevation angle}"
    annotation (Placement(transformation(extent={{-142,80},{-102,120}}),
        iconTransformation(extent={{-142,80},{-102,120}})));
  Modelica.Units.NonSI.Angle_deg Azimut "Solar azimuth angle";
  Modelica.Units.NonSI.Angle_deg Elevation "Solar elevation angle";
  Modelica.Blocks.Interfaces.RealOutput Surfaces[4]
    "Frame surface in the shadow, Frame surface in the light, Glass surface in the shadow, Glass surface in the light"
                                        annotation (Placement(transformation(
          extent={{100,44},{132,76}}),  iconTransformation(extent={{46,10},{
            62,26}})));

Real FacMasqueDir;
Real FacMasqueDif;

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput Flux[3]
    "Solar irradiation for the surface considering the shading effects 1-Diffuse, 2- Direct and 3-Cosi"
    annotation (Placement(transformation(extent={{30,-20},{70,20}}, rotation=
            0), iconTransformation(extent={{90,-16},{114,8}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt[3]
    "Incident irradiance 1-Diffuse, 2- Direct and 3-Cosi" annotation (
      Placement(transformation(extent={{-77,-18},{-43,16}}, rotation=0),
        iconTransformation(extent={{-50,-14},{-30,6}})));
algorithm

Azimut:=G[9];
Elevation:=G[10];

  //Surface exposed to solar radiation
if abs(Azimut_surface-Azimut)<=89.9 then
    //Shadow induced by the horizontal shading
  if Angle_inclinaison == 90 then
    Hauteur_ombre :=l_protection_horizontale*tan(Elevation*Modelica.Constants.pi/180)/
        Cos_Delta_Az;
  else
    Hauteur_ombre :=l_protection_horizontale*tan((Angle_inclinaison - 90)*
        Modelica.Constants.pi/180 + atan(tan(Elevation*Modelica.Constants.pi/180)/
        Cos_Delta_Az));
  end if;
   if Hauteur_ombre > (Distance_VC_horizontale + Hauteur_vitrage) then
     Hauteur_ombre :=Distance_VC_horizontale + Hauteur_vitrage;
   elseif Hauteur_ombre < 0 then
     Hauteur_ombre :=0;
   end if;
  //Calculation of the shaded area induced by the horizontal shading (bounded)
  Composante_H:=(Hauteur_ombre - Distance_VC_horizontale)*largeur_vitrage;
   if Composante_H <0 then
     Composante_H :=0;
   elseif Composante_H > Hauteur_vitrage*largeur_vitrage then
     Composante_H :=Hauteur_vitrage*largeur_vitrage;
   end if;

    //Shadow induced by the vertical protections
  if Azimut_surface-Azimut >0 then
    Largeur_ombre_droite :=l_protection_verticale*tan(abs(Azimut_surface -Azimut)*Modelica.Constants.pi/180);
    Largeur_ombre_gauche :=0;
    if Largeur_ombre_droite > (Distance_VC_verticale + largeur_vitrage) then
      Largeur_ombre_droite :=Distance_VC_verticale + largeur_vitrage;
    elseif Largeur_ombre_droite < 0 then
      Largeur_ombre_droite :=0;
    end if;
  else
    Largeur_ombre_droite :=0;
    Largeur_ombre_gauche :=l_protection_verticale*tan(abs(Azimut_surface -Azimut)*Modelica.Constants.pi/180);
    if Largeur_ombre_gauche > (Distance_VC_verticale + largeur_vitrage) then
      Largeur_ombre_gauche :=Distance_VC_verticale + largeur_vitrage;
    elseif Largeur_ombre_gauche < 0 then
      Largeur_ombre_gauche :=0;
    end if;
  end if;
  //Calculation of the shaded area induced by the vertical protections (bounded)
  Composante_V_d:=(Largeur_ombre_droite -Distance_VC_verticale)*Hauteur_vitrage;
  Composante_V_g:=(Largeur_ombre_gauche -Distance_VC_verticale)*Hauteur_vitrage;
  if Composante_V_d <0 then
    Composante_V_d :=0;
  elseif Composante_V_d > Hauteur_vitrage*largeur_vitrage then
    Composante_V_d :=Hauteur_vitrage*largeur_vitrage;
  end if;
  if Composante_V_g <0 then
    Composante_V_g :=0;
  elseif Composante_V_g > Hauteur_vitrage*largeur_vitrage then
    Composante_V_g :=Hauteur_vitrage*largeur_vitrage;
  end if;
    //Surface related to the overlap of shaded areas
  Composante_mixte_d:=(Largeur_ombre_droite - Distance_VC_verticale)*(Hauteur_ombre - Distance_VC_horizontale);
  Composante_mixte_g:=(Largeur_ombre_gauche - Distance_VC_verticale)*(Hauteur_ombre - Distance_VC_horizontale);

    //Calculation of the shadow area related to the frame
  if Hauteur_ombre >= (Hauteur_vitrage+Distance_VC_horizontale) then
    Hauteur_ombre :=(Hauteur_vitrage+Distance_VC_horizontale);
    S_ombre :=Surface_vitrage;
    S_ombre_cadre:=Surface_cadre;
    Repere :=1;
  elseif Largeur_ombre_droite >= (Distance_VC_verticale+largeur_vitrage) then
    Largeur_ombre_droite :=(largeur_vitrage+Distance_VC_verticale);
    S_ombre :=Surface_vitrage;
    S_ombre_cadre:=Surface_cadre;
    Repere :=2;
  elseif Largeur_ombre_gauche >= (Distance_VC_verticale+largeur_vitrage) then
    Largeur_ombre_gauche :=(largeur_vitrage+Distance_VC_verticale);
    S_ombre :=Surface_vitrage;
    S_ombre_cadre:=Surface_cadre;
    Repere :=3;
    //Calculation of the accumulated shadow areas in the case of a partially illuminated glazing
  else
    //No active protection
    if Hauteur_ombre <= Distance_VC_horizontale and Largeur_ombre_gauche <= Distance_VC_verticale and Largeur_ombre_droite <= Distance_VC_verticale then
      S_ombre :=0;
      S_ombre_cadre:=0;
      Repere :=4;
        //One active protection
    elseif Hauteur_ombre > Distance_VC_horizontale and Largeur_ombre_droite <= Distance_VC_verticale and Largeur_ombre_gauche <= Distance_VC_verticale then
      S_ombre :=Composante_H;
      Repere :=11;
      if Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) then
        S_ombre_cadre :=S_ombre;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_ombre - (Distance_VC_horizontale + Epaisseur_cadre));
      else
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(
            Hauteur_vitrage - 2*Epaisseur_cadre);
      end if;

    elseif Hauteur_ombre <= Distance_VC_horizontale and Largeur_ombre_droite <= Distance_VC_verticale and Largeur_ombre_gauche > Distance_VC_verticale then
      S_ombre :=Composante_V_g;
      Repere :=12;
      if Largeur_ombre_gauche <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre :=S_ombre;
      elseif Largeur_ombre_gauche <= (Distance_VC_verticale + largeur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre := S_ombre - (Hauteur_vitrage - 2*Epaisseur_cadre)*(Largeur_ombre_gauche - (Distance_VC_verticale + Epaisseur_cadre));
      else
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(
            Hauteur_vitrage - 2*Epaisseur_cadre);
      end if;

    elseif Hauteur_ombre <= Distance_VC_horizontale and Largeur_ombre_droite > Distance_VC_verticale and Largeur_ombre_gauche <= Distance_VC_verticale then
      S_ombre :=Composante_V_d;
      Repere :=13;
      if Largeur_ombre_droite <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre :=S_ombre;
      elseif Largeur_ombre_droite <= (Distance_VC_verticale + largeur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre := S_ombre - (Hauteur_vitrage - 2*Epaisseur_cadre)*(Largeur_ombre_droite - (Distance_VC_verticale + Epaisseur_cadre));
      else
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(
            Hauteur_vitrage - 2*Epaisseur_cadre);
      end if;

       //Active horizontal and right vertical protections
    elseif Hauteur_ombre > Distance_VC_horizontale and Largeur_ombre_droite <= Distance_VC_verticale and Largeur_ombre_gauche > Distance_VC_verticale then
      S_ombre :=Composante_H + Composante_V_g - Composante_mixte_g;
      Repere :=100;
      if Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) and Largeur_ombre_gauche <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre:=S_ombre;
        Repere :=101;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) and Largeur_ombre_gauche <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre:=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_ombre - (Distance_VC_horizontale + Epaisseur_cadre));
        Repere :=102;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage) and Largeur_ombre_gauche <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre:= S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=103;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) and Largeur_ombre_gauche <= (Distance_VC_verticale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre := S_ombre - (Hauteur_vitrage - 2*Epaisseur_cadre)*(Largeur_ombre_gauche - (Distance_VC_verticale + Epaisseur_cadre));
        Repere :=104;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) and Largeur_ombre_gauche <= (Distance_VC_verticale + Hauteur_vitrage) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=105;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) and Largeur_ombre_gauche <= (Distance_VC_verticale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre := S_ombre - ((largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre)-(((Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre)-Hauteur_ombre)*((Distance_VC_verticale + largeur_vitrage - Epaisseur_cadre)-Largeur_ombre_gauche)));
        Repere :=106;
      // 107-109 à préciser si discontinuité mais restera très faible
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage) and Largeur_ombre_gauche <= (Distance_VC_verticale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=107;
      elseif  Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) and Largeur_ombre_gauche <= (Distance_VC_verticale + Hauteur_vitrage) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=108;
      else
        S_ombre_cadre := S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=109;
      end if;
//Active horizontal and left vertical protections
    elseif Hauteur_ombre > Distance_VC_horizontale and Largeur_ombre_droite > Distance_VC_verticale and Largeur_ombre_gauche <= Distance_VC_verticale then
      S_ombre :=Composante_H + Composante_V_d - Composante_mixte_d;
      Repere :=200;
      if Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) and Largeur_ombre_droite <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre:=S_ombre;
        Repere :=201;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) and Largeur_ombre_droite <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre:=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_ombre - (Distance_VC_horizontale + Epaisseur_cadre));
        Repere :=202;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage) and Largeur_ombre_droite <= (Distance_VC_verticale + Epaisseur_cadre) then
        S_ombre_cadre:= S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=203;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) and Largeur_ombre_droite <= (Distance_VC_verticale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre := S_ombre - (Hauteur_vitrage - 2*Epaisseur_cadre)*(Largeur_ombre_droite - (Distance_VC_verticale + Epaisseur_cadre));
        Repere :=204;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Epaisseur_cadre) and Largeur_ombre_droite <= (Distance_VC_verticale + Hauteur_vitrage) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=205;
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) and Largeur_ombre_droite <= (Distance_VC_verticale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre := S_ombre - ((largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre)-(((Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre)-Hauteur_ombre)*((Distance_VC_verticale + largeur_vitrage - Epaisseur_cadre)-Largeur_ombre_droite)));
        Repere :=206;
      // 207-209 à préciser si discontinuité mais restera très faible
      elseif Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage) and Largeur_ombre_droite <= (Distance_VC_verticale + Hauteur_vitrage - Epaisseur_cadre) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=207;
      elseif  Hauteur_ombre <= (Distance_VC_horizontale + Hauteur_vitrage - Epaisseur_cadre) and Largeur_ombre_droite <= (Distance_VC_verticale + Hauteur_vitrage) then
        S_ombre_cadre :=S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=208;
      else
        S_ombre_cadre := S_ombre - (largeur_vitrage - 2*Epaisseur_cadre)*(Hauteur_vitrage - 2*Epaisseur_cadre);
        Repere :=209;
      end if;

      //Cas impossible (les deux protections latérales actives en même temps)
    else
        S_ombre_cadre := S_ombre;
        Repere :=10000;
    end if;
  end if;

  //Surface not exposed to solar radiation
else
  Hauteur_ombre :=Hauteur_vitrage + Distance_VC_horizontale;
  Composante_H :=Hauteur_vitrage*largeur_vitrage;
  Largeur_ombre_droite :=largeur_vitrage + Distance_VC_verticale;
  Composante_V_d :=Hauteur_vitrage*largeur_vitrage;
  Largeur_ombre_gauche :=largeur_vitrage + Distance_VC_verticale;
  Composante_V_d :=Hauteur_vitrage*largeur_vitrage;
  S_ombre :=Surface_vitrage;
  S_ombre_cadre:=Surface_cadre;
  Repere :=0;
end if;

S_lumiere :=Surface_vitrage - S_ombre;
S_lumiere_cadre :=Surface_cadre - S_ombre_cadre;
S_ombre_vitre:=S_ombre - S_ombre_cadre;
S_lumiere_vitre :=Surface_vitre - S_ombre_vitre;

FacMasqueDir:= (S_lumiere_vitre)/(Surface_vitrage);
//FacMasqueDir:= min(max(0,1-(max(0,l_protection_horizontale*tan(Elevation*Modelica.Constants.pi/180)/cos((Azimut-Azimut_surface)*Modelica.Constants.pi/180))-Distance_VC_horizontale)/(Hauteur_vitrage-2*Epaisseur_vitrage)),1); //Formule RT2012

//cas protection horizontale
if l_protection_verticale > 0 then
  FacMasqueDif:=((largeur_vitrage+2*Distance_VC_verticale)*(Hauteur_vitrage+Distance_VC_horizontale))/((largeur_vitrage+2*Distance_VC_verticale)*(Hauteur_vitrage+Distance_VC_horizontale)+(largeur_vitrage+2*Distance_VC_verticale)*l_protection_horizontale+2*(Hauteur_vitrage+Distance_VC_horizontale)*l_protection_horizontale);
//cas protection horizontale + verticale
elseif l_protection_verticale == 0 then
  FacMasqueDif:=((largeur_vitrage+2*Distance_VC_verticale)*(Hauteur_vitrage+Distance_VC_horizontale)+2*l_protection_horizontale*(Hauteur_vitrage+Distance_VC_horizontale))/((largeur_vitrage+2*Distance_VC_verticale)*(Hauteur_vitrage+Distance_VC_horizontale)+(largeur_vitrage+2*Distance_VC_verticale)*l_protection_horizontale+2*(Hauteur_vitrage+Distance_VC_horizontale)*l_protection_horizontale);
//FacMasqueDif:=(2/Modelica.Constants.pi)*atan(((Hauteur_vitrage+Distance_VC_horizontale)/2)/l_protection_horizontale); //Formule RT2012
end if;

//Vector FLUX on a glazing with close mask / output: diffuse, direct, cosi
Flux[1] :=((FluxIncExt[1] - DiffusSol)*FacMasqueDif + DiffusSol);
Flux[2] :=FacMasqueDir*FluxIncExt[2];
Flux[3] :=FluxIncExt[3];

Surfaces :={S_ombre_cadre,S_lumiere_cadre,S_ombre_vitre,S_lumiere_vitre};
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -100},{120,140}}),                                  graphics={
        Ellipse(
          extent={{-140,144},{-58,54}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=90),
        Polygon(
          points={{46,30},{-54,30},{-54,-30},{46,-30},{46,30}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-54,-30},{-54,-30},{-64,-40},{-18,-30},{-54,-30}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-18,4},{46,-30}},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{46,30},{36,20},{36,-40},{46,-30},{46,30}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-54,30},{-64,20},{-64,-40},{-54,-30},{-54,30}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Polygon(
          points={{-54,30},{-64,20},{36,20},{46,30},{-54,30}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-54,-30},{36,20}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-32,10},{14,-18}},
          fillColor={139,175,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-18,4},{14,-18}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{120,
            140}})),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p> This model is detailed in the report of Rudy Vial (section 5.4) available in the documentation</p>
<p>The modeling is done in two stages. The first approach involves modeling the horizontal protections alone, and the second stage models the vertical protections independently of the horizontal ones. The impact of their combined use will be determined eventually.</p><p>Regarding the horizontal protections:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Configurationofhorizentalprotections.png\"/></p>
<p>Regarding the vertical protections:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Configurationofverticalprotections.png\"/> </p>
</ul>

<p><u><b>Bibliography</b></u></p>
<p>For more details, see the report of Rudy Vial (section 5.4) in the documentation.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None.</p>
<p><u><b>Validations</b></u></p>
<p>Non validated model - Rudy VIAL </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Kods GRISSA NACIB, EDF (2024)<br>
--------------------------------------------------------------</b></p>
</html>
"));
end FixedSolarProtection;
