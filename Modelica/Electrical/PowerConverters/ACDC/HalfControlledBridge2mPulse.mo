within Modelica.Electrical.PowerConverters.ACDC;
model HalfControlledBridge2mPulse
  "2*m pulse half controlled rectifier bridge"
  extends Icons.Converter;
  import Modelica.Constants.pi;
  // parameter Integer m(final min=3) = 3 "Number of phases";
  parameter Modelica.SIunits.Resistance RonDiode(final min=0) = 1e-05
    "Closed diode resistance";
  parameter Modelica.SIunits.Conductance GoffDiode(final min=0) = 1e-05
    "Opened diode conductance";
  parameter Modelica.SIunits.Voltage VkneeDiode(final min=0) = 0
    "Diode forward threshold voltage";
  parameter Modelica.SIunits.Resistance RonThyristor(final min=0) = 1e-05
    "Closed thyristor resistance";
  parameter Modelica.SIunits.Conductance GoffThyristor(final min=0) = 1e-05
    "Opened thyristor conductance";
  parameter Modelica.SIunits.Voltage VkneeThyristor(final min=0) = 0
    "Thyristor forward threshold voltage";
  parameter Boolean offStart_p[m]=fill(true, m)
    "Boolean start value of variable thyristor_p[:].off"
    annotation (choices(checkBox=true));
  extends PowerConverters.Interfaces.ACDC.ACplug;
  extends PowerConverters.Interfaces.ACDC.DCtwoPin;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(final T=
       293.15);
  extends Interfaces.Enable.Enable1m;
  Modelica.Electrical.Polyphase.Basic.Star star_p(final m=m)
    annotation (Placement(transformation(extent={{70,70},{90,50}})));
  Modelica.Electrical.Polyphase.Basic.Star star_n(final m=m)
    annotation (Placement(transformation(extent={{70,-50},{90,-70}})));
  Modelica.Electrical.Polyphase.Ideal.IdealThyristor thyristor_p(
    final m=m,
    final Ron=fill(RonThyristor, m),
    final Goff=fill(GoffThyristor, m),
    final Vknee=fill(VkneeThyristor, m),
    final useHeatPort=useHeatPort,
    final idealThyristor(off(start=offStart_p, fixed=fill(true, m))))
    "Thyristors connected to positive DC potential" annotation (Placement(
        transformation(
        origin={0,40},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Electrical.Polyphase.Ideal.IdealDiode diode_n(
    final m=m,
    final Ron=fill(RonDiode, m),
    final Goff=fill(GoffDiode, m),
    final Vknee=fill(VkneeDiode, m),
    final useHeatPort=useHeatPort)
    "Diodes connected to negative DC potential" annotation (Placement(
        transformation(
        origin={0,-40},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector
    thermalCollector(final m=m) if useHeatPort
    annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
  Modelica.Blocks.Logical.Pre pre[m] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-46})));
equation
  if not useHeatPort then
    LossPower = sum(thyristor_p.idealThyristor.LossPower) + sum(diode_n.idealDiode.LossPower);
  end if;
  connect(ac, thyristor_p.plug_p) annotation (Line(
      points={{-100,0},{0,0},{0,30}}, color={0,0,255}));
  connect(thyristor_p.plug_p, diode_n.plug_n) annotation (Line(
      points={{0,30},{0,-30}}, color={0,0,255}));
  connect(thyristor_p.plug_n, star_p.plug_p) annotation (Line(
      points={{0,50},{0,60},{70,60}}, color={0,0,255}));
  connect(star_p.pin_n, dc_p) annotation (Line(
      points={{90,60},{100,60}}, color={0,0,255}));
  connect(diode_n.plug_p, star_n.plug_p) annotation (Line(
      points={{0,-50},{0,-50},{0,-50},{0,-60},{70,-60}}, color={0,0,255}));
  connect(star_n.pin_n, dc_n) annotation (Line(
      points={{90,-60},{100,-60}}, color={0,0,255}));
  connect(heatPort, thermalCollector.port_b) annotation (Line(
      points={{0,-100},{20,-100}}, color={191,0,0}));
  connect(thermalCollector.port_a, diode_n.heatPort) annotation (Line(
      points={{20,-80},{20,-40},{10,-40}}, color={191,0,0}));
  connect(thyristor_p.heatPort, thermalCollector.port_a) annotation (Line(
      points={{10,40},{20,40},{20,-80}}, color={191,0,0}));
  connect(andCondition_p.y, pre.u)
    annotation (Line(points={{-60,-69},{-60,-58}}, color={255,0,255}));
  connect(pre.y, thyristor_p.fire) annotation (Line(points={{-60,-35},{-60,-35},{-60,48},{-60,50},{-11.8,50}},
                                            color={255,0,255}));
  annotation (defaultComponentName="rectifier",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={
        Text(
          extent={{-100,70},{0,50}},
          textColor={0,0,127},
          textString="AC"),
        Text(
          extent={{0,-50},{100,-70}},
          textColor={0,0,127},
          textString="DC"),
        Rectangle(
          extent={{-46,52},{34,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,28},{34,28}},
          color={0,0,255}),
        Line(
          points={{14,52},{14,4}},
          color={0,0,255}),
        Line(
          points={{14,28},{-26,52},{-26,4},{14,28}},
          color={0,0,255}),
        Rectangle(
          extent={{-46,4},{34,-52}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,-28},{34,-28}},
          color={0,0,255}),
        Line(
          points={{14,-4},{14,-52}},
          color={0,0,255}),
        Line(
          points={{14,-28},{-26,-4},{-26,-52},{14,-28}},
          color={0,0,255}),
        Line(
          points={{-6,-16},{-6,0}},
          color={0,0,255})}),
    Documentation(info="<html>
<p>
General information about AC/DC converters can be found at the
<a href=\"modelica://Modelica.Electrical.PowerConverters.UsersGuide.ACDCConcept\">AC/DC converter concept</a>
</p>

<p>
This is a 2*m pulse half controlled rectifier bridge. In order to operate this rectifier a voltage source with center tap is required. The circuit topology is the same as in
<a href=\"modelica://Modelica.Electrical.PowerConverters.Examples.ACDC.RectifierBridge2mPulse\">Examples.ACDC.RectifierBridge2mPulse</a>. It is important to note that for polyphase circuits with even phase numbers greater than three the
<a href=\"modelica://Modelica.Electrical.Polyphase.Basic.MultiStarResistance\">MultiStarResistance</a> shall be used for grounding the voltage sources.
</p>
</html>"));
end HalfControlledBridge2mPulse;
