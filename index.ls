<- $(document).ready
points = [{idx: i, x: Math.random!*600 + 100, y: Math.random!*400 + 100, r: Math.random!*8 + 2} for i from 0 til 100]
lines = [{idx: i} for i from 0 til 99]
color = d3.scale.linear!domain [2 6 10] .range <[#090 #ff0 #f00]>
init = ->
  d3.select \svg .selectAll \path .data lines .enter!append \path .each -> it.node = @
  d3.select \svg .selectAll \circle .data points .enter!append \circle

update = ->
  spline.update points, lines
  alpha = force.alpha!

  for i from 0 til lines.length
    x = points[i].x - points[i + 1].x
    y = points[i].y - points[i + 1].y
    w = (points[i].r + points[i + 1].r) / 2
    len = lines[i].node.getTotalLength!
    min = 20
    if len > 30 => len = 30
    if len < 10 => len = 10
    if Math.abs(len - min) > 5 =>
      len = w * alpha * ( len - min ) / len * 0.5
      [x,y] = [x * len, y * len]
      points[i].x -= x
      points[i].y -= y
      points[i + 1].x += x
      points[i + 1].y += y

  d3.select \svg .selectAll \circle .attr do
    cx: -> it.x
    cy: -> it.y
    r: -> it.r
    fill:  -> color it.r
    stroke: \#444
  d3.select \svg .selectAll \path .attr do
    d: -> it.d
    fill: \none
    stroke: \#444

init!
force = d3.layout.force!size [800,600] .charge -> it.r * it.r * -2
force.nodes(points).on(\tick, update).start!

