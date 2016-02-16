within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
function HorizontalMask
  "Calcul de l'aire ensoleillée pour le masque horizontal"

input Modelica.SIunits.Distance Av "Avancée";
input Modelica.SIunits.Distance Ha
    "Distance de l'auvent au rebord haut de la fenêtre";
input Modelica.SIunits.Distance Lf "Largeur de la fenêtre";
input Modelica.SIunits.Distance Hf "Hauteur de la fenêtre";
input Modelica.SIunits.Distance Dd "Distance ou débord droit";
input Modelica.SIunits.Distance Dg "Distance ou débord gauche";
input Modelica.SIunits.Conversions.NonSIunits.Angle_deg AzimutSoleil
    "Azimut du soleil en degrés";
input Modelica.SIunits.Conversions.NonSIunits.Angle_deg HauteurSoleil
    "Hauteur du soleil";
input Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
output Modelica.SIunits.Area Asol "Surface ensoleillée de la fenêtre";

protected
Integer Cas
    "Numéro de la forme de l'ombrage - cf norme ISO13791 - Pour validations";
Modelica.SIunits.Area A0 "Surface de l'ombre sur la fenêtre";
constant Real Convert=Modelica.Constants.pi/180
    "Facteur de conversion degrés->radians";
Modelica.SIunits.Conversions.NonSIunits.Angle_deg Phi
    "Azimut du soleil - Azimut de la paroi vitrée";
Boolean DebordGauche
    "=true si le soleil arrive par le débord gauche, false sinon";
Modelica.SIunits.Distance T "Profondeur d'ombre";
Modelica.SIunits.Distance M "Décalage d'ombre";
Modelica.SIunits.Distance X0
    "Coordonnée selon x de la projection du coin du masque horizontal sur la paroi";
Modelica.SIunits.Distance Y0
    "Coordonnée selon y de la projection du coin du masque horizontal sur la paroi";
Boolean Inclus "=true si le point appartient à la surface";
Real Xdeb "Coordonnée selon X du débord";
Real Ydeb "Coordonnée selon Y du débord";
Boolean continue=true "True tant que le bon cas n'est pas trouvé";
Real b;

// Intersections avec les bords verticaux et horizontaux
Real Yi0;
Real YiL;
Real Xi0;
Real XiH;
Real X2iH
    "Grandeur intermédiaire - intersection de l'autre débord pour discrimination du cas 1";

algorithm
   Phi := AzimutSoleil-azimut; // Attention aux cas où Phi = 0 => M=0 => forme de l'ombre déterminée selon la valeur de T
   DebordGauche := if (Phi < 0) then true else false;
   T := Av * tan(HauteurSoleil*Convert)/cos(Phi*Convert);
   M := Av * tan(Phi*Convert);

// Premiers cas déterminés si Phi = 0
if (not (M<>0)) then
  continue := false;
  // Cas 1,2 ou 3 particuliers
  if (T >= Ha+Hf) then
    Cas := 2;
  elseif (T <= Ha) then
    Cas := 1;
  else
    Cas := 3;
  end if;
end if;

// Cas déterminés grâce à la connaissance des coordonnées du projeté du coin du masque selon la direction des rayons lumineux
if DebordGauche==true then
  b := Dg;
  Xdeb := Lf +Dg;
else
  b := Dd;
  Xdeb:= -Dd;
end if;
Ydeb := Ha + Hf;
X0 := Xdeb + M;
Y0 := Ydeb - T;

if (continue == true) then
// Calcul des coordonnées (X,Y) de l'intersection entre le rayon incident provenant de (Xdeb, Ydeb) et les bords de la fenêtre
  // Calcul des coordonnées Y de l'intersection avec le bord x=0 de la fenêtre
  Yi0 :=Ydeb+T*Xdeb/M;
  // Calcul des coordonnées Y de l'intersection avec le bord x=Lf de la fenêtre
  YiL :=Ydeb+(T/M)*(Xdeb-Lf);
  // Calcul des coordonnées X de l'intersection avec le bord y=0 de la fenêtre
  Xi0 :=Xdeb+M*Ydeb/T;
  // Calcul des coordonnées X de l'intersection avec le bord y=Hf de la fenêtre
  XiH :=Xdeb+(M/T)*Ha;

  // Cas 4 & 7 selon l'appartenance de 0 au vitrage
    Inclus :=BuildSysPro.BoundaryConditions.Solar.SolarMasks.PointOnSurface(
      Lf=Lf,
      Hf=Hf,
      X0=X0,
      Y0=Y0);

  if (Inclus == true) then
    continue := false;
    // Cas 4 ou 7
    if ((XiH>=0) and (XiH<=Lf)) then
      Cas := 4;
    else
      Cas := 7;
    end if;
  end if;
end if;

// Discrimination du cas 1
if (continue == true) then
   X2iH := if DebordGauche then (M/T)*Ha-Dd else (M/T)*Ha+Dg+Lf;
   if ((T<=Ha) or ((not DebordGauche) and X2iH >=Lf and XiH >=Lf) or (DebordGauche and X2iH <=0 and XiH <=0)) then
     continue := false;
     Cas := 1;
   end if;
end if;

// Cas 2,3,5,6,8,9
if (continue == true) then
  if (XiH >=0 and XiH <=Lf) then
    //Cas 5 ou 6
    if (Xi0 >=0 and Xi0 <=Lf) then
      Cas := 5;
    else
      Cas := 6;
    end if;
  else
    //Cas 2,3,8,9
    if (Yi0 >=0 and Yi0 <=Hf) and (YiL >=0 and YiL <=Hf) and ((DebordGauche and X0<=0) or ((not DebordGauche) and X0 >=Lf)) then
      Cas := 9;
    else
      //Cas 2,3,8
      if (Y0 >=0 and Y0 <=Hf) then
        Cas := 3;
      else
        if (Xi0 >=0 and Xi0 <=Lf) then
          Cas := 8;
        else
          Cas := 2;
        end if;
      end if;
    end if;
  end if;
end if;

////// Calcul des aires de l'ombre (A0) et ensoleillée (Asol)
M := abs(M); // Pour les formules d'aires suivantes on prend la valeur absolue de M
if Cas == 1 then
  A0 := 0;
elseif Cas == 2 then
  A0 := Hf*Lf;
elseif Cas == 3 then
  A0 := Lf*(T-Ha);
elseif Cas == 4 then
  A0 := (T-Ha)*(Lf+b-M*0.5*(1+Ha/T));
elseif Cas == 5 then
  A0 := Hf*(Lf+b-(Ha+0.5*Hf)*M/T);
elseif Cas == 6 then
 A0 := ((((Lf+b)*T/M)-Ha)^2)*0.5*M/T;
elseif Cas == 7 then
  A0 := (T-Ha)*Lf-((M-b)^2)*T*0.5/M;
elseif Cas == 8 then
  A0 := Hf*Lf-0.5*(T/M)*(M*(Ha+Hf)/T-b)^2;
else //Cas 9
  A0 := Lf*((b+0.5*Lf)*T/M-Ha);
end if;

Asol := Hf*Lf - A0;

  annotation (Documentation(info="<html>
<h4>Fonction inspirée du calcul des formes d'ombres de surplombs de la norme ISO 13791</h4>
<p><br><u><b>Hypothèses et équations</b></u></p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/MasqueHorizontal.bmp\"/> </p>
<p><u><b>Bibliographie</b></u></p>
<p>Norme ISO 13791</p>
<p><u><b>Mode d'emploi</b></u></p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Cette fonction ne doit être appelée que pour une valeur absolue de Phi strictement inférieure à 90&deg;, ce qui correspond au soleil qui arrive sur le plan de la fenêtre (<code><span style=\"font-family: Courier New,courier; color: #ff0000;\">abs</span>(azimut-AzimutSoleil)&LT;90).</code></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé (selon la norme ISO13791-2004) - Aurélie Kaemmerlen 05/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 10/2011 : correction du modèle - Nouveau chemin de calcul suite à la détection d'erreurs détectées </p>
</html>"));
end HorizontalMask;
