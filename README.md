# BuildSysPro open source
*BuildSysPro open source* is [EDF](https://www.edf.fr/en/the-edf-group/who-we-are/activities/research-and-development)'s Modelica library for buildings, districts and energy systems modelling. This is BuildSysPro's official repository.

### Release updates
Current release is version 3.2.0.

This release provides :
- update of the IBPSA library to its 2.0.0 version
- adding a new RT2012 scenario file to account for the switch between winter and summer time.
**Warning:** in the RT2012 regulation, the environmental data are given in solar time whereas the data related to occupancy are in local time. To account for this time difference (switch between winter and summer time), the user should choose a specific scenario file (for example ScenarioRT2012_timechange.txt)
- correction of the flux connection between the zones in the Matisse multizone apartment model,  in order to be consistent with the distributed radiative heat fluxes on the walls by PintdistriRad.
**Warning:** this modification is likely to have impacts on some simulation results.
- other minor error corrections

EDF is part of [IBPSA Project 1](https://ibpsa.github.io/project1/), and the [IBPSA library](https://github.com/ibpsa/modelica-ibpsa) is now integrated to BuildSysPro open source 3.2.0.

BuildSysPro open source 3.2.0 is compatible with OpenModelica 1.9.3. When working with OpenModelica, specify your initial conditions carefully and use preferably Dassl, Euler or Runge-Kutta solvers.

### License
The BuildSysPro open source library is licensed by EDF under the [Modelica License Version 2](https://www.modelica.org/licenses/ModelicaLicense2).

### References
1. Plessis G., Kaemmerlen A., Lindsay A. (2014) [BuildSysPro: a Modelica library for modelling buildings and energy systems](https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961161_PlessisKaemmerlenLindsay.pdf). Modelica Conference 2014.
2. Schumann M. (2015) [Vers une plate-forme de modélisation du bâtiment au quartier multiphysique avec Modelica et BuildSysPro](http://ibpsa.fr/jdownloads/Simurex/2015/Presentations/29_01_mathieuschumann.pdf) (*Towards a multiphysics modelling platform for buildings and districts with Modelica and BuildSysPro*), IBPSA France SIMUREX 2015 Conference.
