# ![BuildSysPro](https://raw.githubusercontent.com/EDF-TREE/BuildSysPro/master/BuildSysPro/Resources/Images/Logo-BuildSysPro.png)
*BuildSysPro open source* is [EDF](https://www.edf.fr/en/the-edf-group/who-we-are/activities/research-and-development)'s Modelica library for buildings, districts and energy systems modelling. This is BuildSysPro's official repository.

### Release updates
Current release is version 3.5.0.

This release provides :

- Migration from Modelica version 3.2.3 to 4.0.0.
- Correction of models following the BuildSysPro and OpenModelica compatibility study.
- Adding new  building models: 
     -  Simple air renewal model for a single zone with variable air properties, 
     -  Enthalpy transfer through a door, Ventilation model with default values from 3CL DPE v1.3 method, 
     -  Records allows to save the parameters needed to calculate the ventilation flow using 3CL-DPE method.
- Adding new  system models: 
     -   On/Off control model for a heat generator, 
     -  according to the hydraulic circuit temperature, 
     -  Generic model of air temperature control based on a PID model,
     -  Wood Stove (BuildSysPro.Systems.HVAC.Production.WoodHeating)
     -  models of heatpumps with its components,
     -  A solar warter heater model,
     -  Solar wall models
     -  Storage : Lithium-Ion Battery;
     -  Distribution systems : HydraulicPipe, ThreeWayValveFlow, fan.
- Adding new boundary conditions:
     -    Weather : Cold water temperature reader,
     -    Scenarios: occupancy schedule.
- Adding new building stock models:
    - GV calculation of BuildingR2,
    - GenericFloor model,
    - BuildingR2 model,
    - Building date, assembly and settings of collective housing: Gaugun, Picasso and unheated room,
    - Collective housing building  R+2 of 9 apartements and R+5 of 34 apartements.
- Adding new utilities models:
    - Description of the battery characteristics with different configurations,
    - Cases of DHW analysis (Detect change in a signal value, Domestic hot water drawing queue, Measure of cold discomfort of DHW temperature relative to the setpoint).
- other minor error corrections

EDF is part of [IBPSA Project 1](https://ibpsa.github.io/project1/), and the [IBPSA library](https://github.com/ibpsa/modelica-ibpsa) is now integrated to BuildSysPro open source 3.5.0.

BuildSysPro open source 3.5.0 is compatible with OpenModelica 1.17.0. When working with OpenModelica, specify your initial conditions carefully and use preferably Dassl, Euler or Runge-Kutta solvers.

### License
The BuildSysPro open source library is licensed by EDF under the [3-Clause BSD-License](https://opensource.org/licenses/BSD-3-Clause).

### Documentation
A set of [self-training documents](https://github.com/edf-enerbat/buildsyspro-doc) for the BuildSysPro open source library is available.

### References
1. Plessis G., Kaemmerlen A., Lindsay A. (2014) [BuildSysPro: a Modelica library for modelling buildings and energy systems](https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961161_PlessisKaemmerlenLindsay.pdf). Modelica Conference 2014.
2. Schumann M. (2015) [Vers une plate-forme de modélisation du bâtiment au quartier multiphysique avec Modelica et BuildSysPro](http://ibpsa.fr/jdownloads/Simurex/2015/Presentations/29_01_mathieuschumann.pdf) (*Towards a multiphysics modelling platform for buildings and districts with Modelica and BuildSysPro*), IBPSA France SIMUREX 2015 Conference.


