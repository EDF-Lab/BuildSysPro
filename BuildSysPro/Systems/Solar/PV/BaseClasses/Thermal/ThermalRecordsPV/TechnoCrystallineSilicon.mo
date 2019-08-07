within BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal.ThermalRecordsPV;
record TechnoCrystallineSilicon =
    BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal.ThermalRecordsPV.RecordTechnoPV
    (
    n=7,
    ncell=3,
    mat={BuildSysPro.Utilities.Records.GenericSolid(
        lambda=1.8,
        rho=3000,
        c=500),BuildSysPro.Utilities.Records.GenericSolid(
        lambda=0.35,
        rho=960,
        c=2090),BuildSysPro.Utilities.Data.Solids.Silicon(),
        BuildSysPro.Utilities.Records.GenericSolid(
        lambda=0.35,
        rho=960,
        c=2090),BuildSysPro.Utilities.Records.GenericSolid(
        lambda=0.2,
        rho=1200,
        c=1250),BuildSysPro.Utilities.Data.Solids.Aluminium(),
        BuildSysPro.Utilities.Records.GenericSolid(
        lambda=0.2,
        rho=1200,
        c=1250)},
    epaisseur={0.003,0.0005,0.00025,0.0005,0.0001,0.00001,0.0001},
    m={1,2,1,2,1,1,1},
    cp_surf=5723,
    eps_fg=0.91,
    eps_bg=0.85,
    alpha_tau_n=0.9) annotation (Documentation(info="<html>
<p><i><b>Record for the crystalline silicon technology</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Data from the litterature:</p>
<p>A thermal model for photovoltaic systems, A.D. Jones and C.P. Underwood, Solar Energy Vol.70, pp.349-359, 2001</p>
<p>A thermal model for photovoltaic panels under varying atmospheric conditions, S. Armstrong and W.G. Hurley, Applied Thermal Engineering Vol.30, pp.1488-1495, 2010</p>
<p><u><b>Instructions for use</b></u></p>
<p>None</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p></html>"));
