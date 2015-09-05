Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.IndexView extends Backbone.View
  template: JST["backbone/templates/accels/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)
    @recording = false

  startRecording: (evt) =>
    
    if (window.DeviceMotionEvent != undefined and @recording == false) 
      @$(".recording-status").html "Recording..."
      @recording = true
      
      window.ondevicemotion = (e) =>
        #@$("#accelerationX").html e.accelerationIncludingGravity.x
        #@$("#accelerationY").html e.accelerationIncludingGravity.y
        #@$("#accelerationZ").html e.accelerationIncludingGravity.z

        now = new Date()
        new_model = new @collection.model(
          accelx: e.accelerationIncludingGravity.x
          accely: e.accelerationIncludingGravity.y
          accelz: e.accelerationIncludingGravity.z
          timestamp: now.toISOString()
        )
        
        if ( e.rotationRate )
          #@$("#rotationAlpha").html e.rotationRate.alpha
          #@$("#rotationBeta").html e.rotationRate.beta
          #@$("#rotationGamma").html e.rotationRate.gamma
          new_model.set "rota", e.rotationRate.alpha
          new_model.set "rotb", e.rotationRate.beta
          new_model.set "rotg", e.rotationRate.gamma
          
        @collection.add new_model
    evt.stopPropagation() if evt
    false
    
  stopRecording: (evt) =>
    @recording = false
    @$(".recording-status").html "Stopped"
    if (window.DeviceMotionEvent != undefined) 
      window.ondevicemotion = undefined 
    evt.stopPropagation() if evt
    false
      
  #addAll: () =>
    #@collection.each(@addOne)
#
  #addOne: (accel) =>
    #view = new Trendline.Views.Accels.AccelView({model : accel})
    #@$("tbody").append(view.render().el)

  #drawChart: =>
    #m = 400 # number of samples per layer
    #stack = d3.layout.stack().offset("wiggle")
     #an array of arrays of {x: y:}
    #layers0 = stack(d3.range(n).map -> bumpLayer(m) )
    #layers0 = [ 
      #@collection.slice(-400,-1).map (j,i) -> {x: i, y: j.get("accelx"), y0: j.get("accely")},
      #@collection.slice(-400,-1).map (j,i) -> {x: i, y: j.get("accely"), y0: 0},
      #@collection.slice(-400,-1).map (j,i) -> {x: i, y: j.get("accelz"), y0: 0}
    #]
#
    #width = 760
    #height = 400
#
    #x = d3.scale.linear()
    #.domain([0, m - 1])
    #.range([0, width]);
#
    #y = d3.scale.linear()
    #.domain([0, d3.max(layers0, (layer) -> d3.max(layer, (d) -> d.y0 + d.y ))])
    #.range([height, 0]);
#
    #color = d3.scale.linear()
    #.range(["#aad", "#556"])
#
    #area = d3.svg.area()
    #.x((d) -> x(d.x))
    #.y0((d) -> y(d.y0))
    #.y1((d) -> y(d.y0 + d.y))
#
    #@$(".chart-container").children().remove()
    #
    #svg = d3.select( @$(".chart-container")[0] ).append("svg")
    #.attr("width", width)
    #.attr("height", height)
#
    #svg.selectAll("path")
    #.data(layers0)
    #.enter().append("path")
    #.attr("d", area)
    #.style("fill", -> color(Math.random()))
    
  parseDate: (date) -> d3.time.format.iso.parse(date)
    
  drawTrendlineScaffold: =>
    margin = {top: 20, right: 20, bottom: 30, left: 50}
    @width = 960 - margin.left - margin.right
    @height = 200 - margin.top - margin.bottom

    @x = d3.time.scale().range([0, @width])

    @y = d3.scale.linear()
    .range([@height, 0]);

    #@xAxis = d3.svg.axis()
    #.scale(@x)
    #.orient("bottom");
#
    #@yAxis = d3.svg.axis()
    #.scale(@y)
    #.orient("left");

    @line = d3.svg.line()
    .x( (d) => @x(d.date) )
    .y( (d) => @y(d.close));

    @svg = d3.select( @$(".chart-container")[0]).append("svg")
    .attr("width", @width + margin.left + margin.right)
    .attr("height", @height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  refreshTrendlines: =>
    # clean up the SVG
    @svg.selectAll("path").remove()

    plotOne = (error, data) =>
      throw error if (error) 

      data.forEach (d) =>
        d.date = @parseDate(d.date)
        d.close = +d.close

      #@x.domain(d3.extent(data, (d) -> d.date ));
      # reset the x axis to show the last 30 seconds
      @x.domain([Date.now() - 20000, Date.now() ])
      @y.domain([-10, 10]);
    
      @svg.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", @line);
    
    nShown = 400
    plotOne( false, @collection.slice(-nShown,-1).map (j,i) -> {date: j.get("timestamp"), close: j.get("accelx")})
    plotOne( false, @collection.slice(-nShown,-1).map (j,i) -> {date: j.get("timestamp"), close: j.get("accely")})
    plotOne( false, @collection.slice(-nShown,-1).map (j,i) -> {date: j.get("timestamp"), close: j.get("accelz")})
    plotOne( false, @collection.slice(-nShown,-1).map (j,i) -> {date: j.get("timestamp"), close: j.get("rota")})
    plotOne( false, @collection.slice(-nShown,-1).map (j,i) -> {date: j.get("timestamp"), close: j.get("rotb")})
    plotOne( false, @collection.slice(-nShown,-1).map (j,i) -> {date: j.get("timestamp"), close: j.get("rotg")})
    
    #@svg.append("g")
      #.attr("class", "x axis")
      #.attr("transform", "translate(0," + @height + ")")
      #.call(@xAxis);
  
    #@svg.append("g")
      #.attr("class", "y axis")
      #.call(@yAxis)
      #.append("text")
      #.attr("transform", "rotate(-90)")
      #.attr("y", 6)
      #.attr("dy", ".71em")
      #.style("text-anchor", "end")
      #.text("Price ($)");
    
  render: =>
    @$el.html(@template(accels: @collection.toJSON() ))
    
    @$(".toggle-recording").click =>
      if @recording 
        @stopRecording()
      else
        @startRecording()
        
    #@addAll()
    #setInterval @drawChart, 100
    @drawTrendlineScaffold()
    
    # do a rapid refresh of the trendlines while recording to show ones own data
    setInterval( =>
      @refreshTrendlines() if @recording == true
    , 500 ) 
    
    # saves all the unsaved measurements periodically
    setInterval @collection.saveMany, 2000
    
    # grabs data periodically for display unless recording
    setInterval( =>
      if @recording == false
        @collection.fetch
          success: @refreshTrendlines
    , 1000 )

    return this
