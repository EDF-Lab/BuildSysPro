within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model LightTransCoeff
  "Calculation of direct and global light transmittance throught a window"

  parameter Real H=1 "Window height";
  parameter Real L=1 "Window width";
  parameter Real e=0.35 "Wall thickness";
  parameter Real azimut=0
    "Surface azimuth (Orientation relative to the south) - S=0°, E=-90°, W=90°, N=180°";

  parameter Real TLw=0.5 "Global light transmittance without solar shading";
  parameter Real TLw_dif=0 "Diffuse light transmittance without solar shading";

  parameter Real TLws=0 "Global light transmittance with solar shading";
  parameter Real TLws_dif=0 "Diffuse light transmittance with solar shading";

  parameter Boolean MasqueProche=false
    annotation(choices(choice=true "With architectural close mask",                                  choice=false
        "Without architectural close mask",                                                                                              radioButtons=true));
  parameter Boolean Protection=false
    annotation(choices(choice=true "With external shading device in place",                                  choice=false
        "Without external shading device in place",                                                                                                  radioButtons=true));
protected
  Real K "Form coefficient";
  Real R_dir "Share of the total direct incident radiation on the bay window";
  Real Fbati_dir;
  Real Fbati_dif;
  Real Friv_dir;
  Real Friv_dif;
  Real k;
  Real l;
  Real m;

public
  Modelica.Blocks.Interfaces.RealOutput CoeffTransLum[4]
    "Light transmittance -global without protection,- diffuse without protection, - global with protection, -diffuse with protection"
    annotation (Placement(transformation(extent={{88,-18},{134,28}}),
        iconTransformation(extent={{60,26},{86,52}})));

equation
if (L>0 and H>0) then

  //Calculation of form coefficient characterizing the bay window (formula 7 of Th-L rules)
  K=L*H/(e*(L+H));

  //Computation of correction coefficients
  //Share of the total direct incident radiation on the bay window (table 9 of Th-L rules)
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

  //Correction coefficients associated with the integration to work (Tables 10 and 11 of Th-L Rules)
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

  //Correction coefficients related to the variable incidence (Table 18 of Th-L Rules)
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

  //Light transmission coefficients with and without sun protection (formula 1,2,3 and 4 of Th-L Rules)
  CoeffTransLum[1]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLw;
  CoeffTransLum[2]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLw_dif;
  CoeffTransLum[3]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLws;
  CoeffTransLum[4]=(R_dir*Fbati_dir*Friv_dir+(1-R_dir)*Fbati_dif*Friv_dif)*TLws_dif;

else
  //Window dimensions are null
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
<p><i><b>Computation of direct and global light transmittance trought a window with or without shading</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The global and diffuse light transmittance TLW, TLw_dif, TLsw and TLsw_dif should be specify according to EN 410 standard.</p>
<p>However, it is possible to find values in the document \"Valeurs tabulées des caractéristiques des parois vitrées et des correctifs associés aux baies\" from CSTB.</p>
<p>Thus, by default:</p>
<ul>
<li>for double glazing without sun protection: TLw=0.5, TLw_dif=0</li>
<li>for double glazing with opaque and dark sun protection on the outside: TLsw=0, TLsw_dif=0</li>
<li>for double glazing with non-opaque and clear sun protection on the outside: TLsw=0.09, TLsw_dif=0.03</li>
</ul>
<p>The output vector corresponds to the set of 4 minimum light transmittance values to compute transmitted illuminance.
It corresponds to: Tli_sp, Tlid_sp, Tli_ap and Tlid_ap, used in direct, diffuse and reflected transmitted illuminance equations in the computation method Th-BCE 2012.</p>

<p><u><b>Bibliography</b></u></p>
<p>Règles Th-L - Caractérisation du facteur de transmission lumineuse des parois du bâtiment - CSTB March 2012.</p>
<p>Valeurs tabulées des parois vitrées - CSTB March 2012.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>near shading must be specify ahead because then the consideration of architecture shading is done according to the type of mask.</p>
<p><u><b>Validations</b></u></p>
<p>Non validated model - Laura Sudries 05/2014</b></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Laura SUDRIES, Vincent MAGNAUDEIX, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>
"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
