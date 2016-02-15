within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model LightTransCoeff
  "Calcul des coefficients de transmission lumineuse direct et global avec et sans protection solaire"

  parameter Real H=1 "Hauteur de la fenêtre";
  parameter Real L=1 "Largeur de la fenêtre";
  parameter Real e=0.35 "Epaisseur de la paroi considérée";
  parameter Real azimut=0
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
  parameter Real TLw=0.5
    "Facteur de transmission lumineuse global de la baie sans protection";
  parameter Real TLw_dif=0
    "Facteur de transmission lumineuse diffus de la baie sans protection";
  parameter Real TLws=0
    "Facteur de transmission lumineuse global de la baie avec protection";
  parameter Real TLws_dif=0
    "Facteur de transmission lumineuse diffus de la baie avec protection";
  parameter Boolean MasqueProche=false
    annotation(choices(choice=true "Avec masque proche architectural",                                  choice=false
        "Sans masque proche architectural",                                                                                                  radioButtons=true));
  parameter Boolean Protection=false
    annotation(choices(choice=true
        "Avec protection mobile extérieure en place",                                                             choice=false
        "Sans protection mobile extérieure en place",                                                                                                  radioButtons=true));

protected
  Real K "Coefficient de forme";
  Real R_dir "Part du rayonnement total sur la baie en incidence directe";
  Real Fbati_dir;
  Real Fbati_dif;
  Real Friv_dir;
  Real Friv_dif;
  Real k;
  Real l;
  Real m;

public
  Modelica.Blocks.Interfaces.RealOutput CoeffTransLum[4]
    "Coefficients de transmission lumineuse: -global sans protection, -diffus sans, -global avec, -diffus avec"
    annotation (Placement(transformation(extent={{88,-18},{134,28}}),
        iconTransformation(extent={{60,26},{86,52}})));
equation

if (L>0 and H>0) then

  //Calcul du coefficient de forme caractérisant la baie (formule 7 des Règles Th-L)
  K=L*H/(e*(L+H));

  //Calcul des coefficients de correction
  //Part du rayonnement total sur la baie en incidence directe (tableau 9 des Règles Th-L)
  if azimut==0 then
    R_dir=0.5;
  else if azimut==90 then
    R_dir=0.4;
  else if azimut==-90 then
    R_dir=0.4;
  else R_dir=0.05;
  end if;
  end if;
  end if;

  //Coefficients de correction associés à l'intégration à l'ouvrage (tableaux 10 et 11 des Règles Th-L)
if MasqueProche==false then
    if K<=1 then
      Fbati_dif=0.5;
        if azimut==0 then
          Fbati_dir=0.45;
        else if azimut==90 then
          Fbati_dir=0.55;
        else if azimut==-90 then
          Fbati_dir=0.55;
        else Fbati_dir=0.15;
        end if;
        end if;
  end if;
else if K<5 then
  Fbati_dif=0.7;
  if azimut==0 then
          Fbati_dir=0.70;
        else if azimut==90 then
          Fbati_dir=0.75;
        else if azimut==-90 then
          Fbati_dir=0.75;
        else Fbati_dir=0.30;
        end if;
        end if;
        end if;
else Fbati_dif=0.85;
  if azimut==0 then
          Fbati_dir=0.85;
        else if azimut==90 then
          Fbati_dir=0.90;
        else if azimut==-90 then
          Fbati_dir=0.90;
        else Fbati_dir=0.60;
        end if;
        end if;
        end if;
    end if;
    end if;
else
Fbati_dir=1;
Fbati_dif=1;
end if;

  //Coefficients de correction lié à l'incidence variable (tableau 18 des Règles Th-L)
  if K<1.5 then
    k=1;
  else k=0;
  end if;
  if Protection==true then
    l=1;
  else l=0;
  end if;
  m=l+k;
  if m>0 then
    Friv_dir=1;
    Friv_dif=1;
  else Friv_dir=0.95;
    Friv_dif=0.95;
  end if;

  //Coefficients de transmission lumineuse avec et sans protection solaire (formule 1,2,3 et 4 des Règles Th-L)
  CoeffTransLum[1]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLw;
  CoeffTransLum[2]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLw_dif;
  CoeffTransLum[3]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLws;
  CoeffTransLum[4]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLws_dif;

else
  //La fenêtre possède des dimensions nulles
  K=0;
  Fbati_dir=0;
  Fbati_dif=0;
  Friv_dir=0;
  Friv_dif=0;
  R_dir=0;
  k=0;
  l=0;
  m=0;
  CoeffTransLum[1]=0;
  CoeffTransLum[2]=0;
  CoeffTransLum[3]=0;
  CoeffTransLum[4]=0;
end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            Documentation(info="<html>
<p><i><b>Modèle qui permet de calculer les coefficients de transmission lumineuse direct et diffus avec et sans protection solaire, nécessaires pour le calcul des flux lumineux transmis à travers une baie vitrée. </b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Les facteurs de transmission lumineuse global et diffus qui doivent être renseignés correspondent aux TLw, TLw_dif, TLsw et TLsw_dif qui sont calculés précisément dans la norme EN 410.</p>
<p>Cependant, il est possible de retrouver des valeurs tabulées dans le document <i>Valeurs tabulées des caractéristiques des parois vitrées et des correctifs associés aux baies</i> du CSTB.</p>
<p>Ainsi, par défaut:</p>
<p><i>-pour du double vitrage sans protection solaire: TLw=0.5, TLw_dif=0</i></p>
<p><i>-pour du double vitrage avec protection solaire opaque et sombre située à l'extérieur: TLsw=0, TLsw_dif=0</i></p>
<p><i>-pour du double vitrage avec protection solaire non opaque et claire située à l'extérieur: TLsw=0.09, TLsw_dif=0.03</i></p>
<p>Le vecteur output correspond aux 4 coefficients de transmission lumineuse nécessaire au minimum pour déterminer l'ensemble des coefficients de transmission lumineuse.</p>
<p>Il correspond à: Tli_sp, Tlid_sp, Tli_ap et Tlid_ap, utilisés dans les équations (408), (409) et (410) des flux transmis direct, diffus et réfléchi dans la méthode de calcul Th-BCE 2012. </p>
<p><u><b>Bibliographie</b></u></p>
<p>Règles Th-L - Caractérisation du facteur de transmission lumineuse des parois du bâtiment - CSTB Mars 2012</p>
<p>Valeurs tabulées des parois vitrées - CSTB Mars 2012</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Il faut penser à préciser s'il existe des masques proches en amont car alors la prise en compte des ombres dues à l'architecture se fait dans le modèle de Masque.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle non validé - Laura Sudries 05/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.05<br>
Author : Laura SUDRIES, Vincent MAGNAUDEIX, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{33,-5.5},{45,14.5},{45,8.5},{33,-11.5},{33,-5.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={2.5,15},
          rotation=90),
        Polygon(
          points={{-55,-17.5},{-43,2.5},{45,2.5},{33,-17.5},{-55,-17.5}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          origin={-9.5,15},
          rotation=90),
        Polygon(
          points={{20.5,94},{20.5,6},{14.5,6},{14.5,94},{20.5,94}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={28.5,54},
          rotation=180),
        Polygon(
          points={{-88,48},{-30,26},{-28,32},{-18,12},{-36,6},{-34,12},{-92,34},
              {-88,48}},
          lineColor={255,170,85},
          smooth=Smooth.None,
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{22,2},{76,-18},{78,-12},{86,-28},{72,-32},{74,-26},{20,-6},{22,
              2}},
          lineColor={255,170,85},
          smooth=Smooth.None,
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid)}));
end LightTransCoeff;
