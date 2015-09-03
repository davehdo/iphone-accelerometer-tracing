Trendline.Views.Patients ||= {}

class Trendline.Views.Patients.ShowView extends Backbone.View
  template: JST["backbone/templates/patients/show"]


  addOne: =>
    $parameter = $("""
	<div class="row">
		<div class="col-xs-1"><div class="y-axis-container"></div></div>
		<div class="col-xs-7"><div class="chart-container" style="overflow:scroll"></div></div>
		<div class="col-xs-4">
			<h4>Blood pressure</h4>
			<h1>96<h1>
		</div>
	</div>

""")
    @$el.find(".parameters-container").html $parameter

    margin = {top: 20, right: 20, bottom: 30, left: 50}
    width = 960 - margin.left - margin.right
    height = 160 - margin.top - margin.bottom

    parseDate = d3.time.format("%Y-%m-%dT%H:%M:%S").parse

    x = d3.time.scale().range([0, width])

    y = d3.scale.linear().range([height, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")

    yAxis = d3.svg.axis().scale(y).orient("left")

    line = d3.svg.line().x((d) ->  x(d.date)).y((d) -> y(d.close))

    svg = d3.select($parameter.find(".chart-container")[0]).append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    svg_y_axis = d3.select($parameter.find(".y-axis-container")[0]).append("svg")
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
	
    d3.json "/patients/#{ @model.get("id") }.json", (error, data) =>
      if (error)
        throw error

      data.forEach (d) ->
        d.date = parseDate(d.date);
        d.close = +d.close;

      x.domain(d3.extent(data, (d) -> d.date ))
      y.domain(d3.extent(data, (d) -> d.close ))
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis)
      svg_y_axis.append("g").attr("class", "y axis").call(yAxis)
      svg.append("path").datum(data).attr("class", "line").attr("d", line)

  render: ->
    @$el.html(@template(@model.toJSON() ))
    @addOne()

    return this
