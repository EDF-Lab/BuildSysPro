﻿within BuildSysPro.BoundaryConditions.Scenarios;
block OccupancySchedule "Occupancy Schedule"
  extends Modelica.Blocks.Icons.Block;

  parameter Real occupancy[:]=3600*{7, 19}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Boolean firstEntryOccupied = true
    "Set to true if first entry in occupancy denotes a changed from unoccupied to occupied";
  parameter Modelica.Units.SI.Time startTime=0 "Start time of periodicity";
  parameter Modelica.Units.SI.Time endTime=86400 "End time of periodicity";

  Modelica.Blocks.Interfaces.RealOutput tNexNonOcc
    "Time until next non-occupancy"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput tNexOcc "Time until next occupancy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput occupied
    "Outputs true if occupied at current time"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  final parameter Modelica.Units.SI.Time period=endTime - startTime;
  final parameter Integer nRow = size(occupancy,1);

  output Integer nexStaInd "Next index when occupancy starts";
  output Integer nexStoInd "Next index when occupancy stops";

  output Integer iPerSta
    "Counter for the period in which the next occupancy starts";
  output Integer iPerSto
    "Counter for the period in which the next occupancy stops";
  output Modelica.Units.SI.Time schTim
    "Time in schedule (not exceeding max. schedule time)";
  output Modelica.Units.SI.Time tMax "Maximum time in schedule";
  output Modelica.Units.SI.Time tOcc "Time when next occupancy starts";
  output Modelica.Units.SI.Time tNonOcc "Time when next non-occupancy starts";
initial algorithm
  // Check parameters for correctness
 assert(mod(nRow, 2) < 0.1,
   "The parameter \"occupancy\" must have an even number of elements.\n");
 assert(startTime < occupancy[1],
   "The parameter \"startTime\" must be smaller than the first element of \"occupancy\"."
   + "\n   Received startTime    = " + String(startTime)
   + "\n            occupancy[1] = " + String(occupancy[1]));
 assert(endTime > occupancy[nRow],
   "The parameter \"endTime\" must be greater than the last element of \"occupancy\"."
   + "\n   Received endTime      = " + String(endTime)
   + "\n            occupancy[" + integerString(nRow) +
     "] = " + String(occupancy[nRow]));
  for i in 1:nRow-1 loop
    assert(occupancy[i] < occupancy[i+1],
      "The elements of the parameter \"occupancy\" must be strictly increasing.");
  end for;
 // Initialize variables
 // if the firstEntryOccupied == false, then set the current time to the
 // the time when occupancy starts.
 tOcc    :=if firstEntryOccupied then occupancy[1] else time;
 tNonOcc :=if firstEntryOccupied then time else occupancy[1];

 iPerSta   := 0;
 iPerSto   := 0;
 nexStaInd := if firstEntryOccupied then 1 else 2;
 nexStoInd := if firstEntryOccupied then 2 else 1;
 occupied := not firstEntryOccupied;
 tOcc    := occupancy[nexStaInd];
 tNonOcc := occupancy[nexStoInd];
algorithm
  assert(startTime < endTime, "Wrong parameter values.");
  tMax :=endTime;
  schTim :=startTime + mod(time-startTime, period);

  // Changed the index that computes the time until the next occupancy
  when time >= pre(occupancy[nexStaInd])+ iPerSta*period then
    nexStaInd :=nexStaInd + 2;
    occupied := not occupied;
    // Wrap index around
    if nexStaInd > nRow then
       nexStaInd := if firstEntryOccupied then 1 else 2;
       iPerSta := iPerSta + 1;
    end if;
    tOcc := occupancy[nexStaInd] + iPerSta*(period);
  end when;

  // Changed the index that computes the time until the next non-occupancy
  when time >= pre(occupancy[nexStoInd])+ iPerSto*period then
    nexStoInd :=nexStoInd + 2;
    occupied := not occupied;
    // Wrap index around
    if nexStoInd > nRow then
       nexStoInd := if firstEntryOccupied then 2 else 1;
       iPerSto := iPerSto + 1;
    end if;
    tNonOcc := occupancy[nexStoInd] + iPerSto*(period);
  end when;

 tNexOcc    := tOcc-time;
 tNexNonOcc := tNonOcc-time;
  annotation (
    Icon(graphics={
        Line(
          points={{-62,-68},{-38,-20},{-14,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,-20},{-38,44}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-54,74},{-22,44}}, lineColor={0,0,255}),
        Line(
          points={{-66,22},{-38,36}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,36},{-6,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{34,74},{90,50}},
          lineColor={0,0,255},
          textString="occupancy"),
        Text(
          extent={{32,16},{92,-16}},
          lineColor={0,0,255},
          textString="non-occupancy"),
        Text(
          extent={{34,-44},{94,-76}},
          lineColor={0,0,255},
          textString="occupied")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                    graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model outputs whether the building is currently occupied, and how long it will take until the next time when the building will be occupied or non-occupied. The latter may be used, for example, to start a ventilation system half an hour before occupancy starts in order to ventilate the room. </p>
<p>The occupancy is defined by a time schedule of the form </p>
<pre>  occupancy = 3600*{7, 12, 14, 19}</pre>
<p>This indicates that the occupancy is from <code>7:00</code> until <code>12:00</code> and from <code>14:00</code> to <code>19:00</code>. This will be repeated periodically. The parameters <code>startTime and endTime define the periodicity. </code></p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<ul>
<li>
April 2, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end OccupancySchedule;
