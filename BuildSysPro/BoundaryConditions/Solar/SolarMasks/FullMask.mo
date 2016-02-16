within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
function FullMask "Calcul de l'aire ensoleillée pour le masque intégral"

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

output Modelica.SIunits.Area A0 "Surface ensoleillée de la fenêtre";

protected
Modelica.SIunits.Distance X0 "Variable intermédiaire pour le calcul de A0";
Modelica.SIunits.Distance Y0 "Variable intermédiaire pour le calcul de A0";
constant Real Convert=Modelica.Constants.pi/180
    "Facteur de conversion degrés->radians";

algorithm
  //Calcul de Y0
  Y0 := Av * tan(HauteurSoleil*Convert)/cos((azimut-AzimutSoleil)*Convert);
  if Y0 <= Ha then
    Y0 := Ha;
  end if;
  if Y0 >= Ha+Hf then
    Y0 := Ha+Hf;
  end if;

  //Calcul de X0
  if AzimutSoleil<=azimut then
    X0 :=Av * tan((azimut-AzimutSoleil)*Convert);
    if X0 <= Dg then
      X0 := Dg;
    end if;
    if X0 >= Dg + Lf then
      X0 := Dg + Lf;
    end if;
    A0 := (Lf+Dg-X0)*(Ha+Hf-Y0);
  else
    X0 :=Av * tan((AzimutSoleil-azimut)*Convert);
    if X0 <= Dd then
      X0 := Dd;
    end if;
    if X0 >= Dd + Lf then
      X0 := Dd + Lf;
    end if;
    A0 := (Lf+Dd-X0)*(Ha+Hf-Y0);
  end if;

  annotation (Documentation(info="<html>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/MasqueIntegral.bmp\"/> </p>
<p>Modèle validé (selon la norme ISO13791-2004) - Aurélie Kaemmerlen 05/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end FullMask;
