Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.IndexView extends Backbone.View
  template: JST["backbone/templates/accels/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)
    @recording = false

  startRecording: (evt) =>
    #@nav = navigator.geolocation.watchPosition (location) =>
      #now = new Date()
      #new_model = new @collection.model(
        #lat: location.coords.latitude
        #lng: location.coords.longitude 
        #accuracy: location.coords.accuracy
        #heading: location.coords.heading
        #speed: location.coords.speed
        #timestamp: now.toISOString()
      #)
      #@collection.add new_model

    if (window.DeviceMotionEvent != undefined and @recording == false) 
      @$(".recording-status").html "Recording..."
      @recording = true
      
      window.ondevicemotion = (e) =>
        now = new Date()
        new_model = new @collection.model(
          accelx: e.accelerationIncludingGravity.x
          accely: e.accelerationIncludingGravity.y
          accelz: e.accelerationIncludingGravity.z
          timestamp: now.toISOString()
        )
        
        angle =  e.accelerationIncludingGravity.x ^ 2.0 + e.accelerationIncludingGravity.y ^ 2.0 + e.accelerationIncludingGravity.z ^ 2.0

        angle = 0 if angle < 10
        angle = 180 if angle > 180
        @$("#hammer").rotate( -40 - angle  )

        
        if ( e.rotationRate )
          new_model.set "rota", e.rotationRate.alpha
          new_model.set "rotb", e.rotationRate.beta
          new_model.set "rotg", e.rotationRate.gamma
          
        @collection.add new_model
    evt.stopPropagation() if evt
    false
    
  stopRecording: (evt) =>
    #navigator.geolocation.clearWatch @nav
    @recording = false
    @$(".recording-status").html "Stopped"
    if (window.DeviceMotionEvent != undefined) 
      window.ondevicemotion = undefined 
    evt.stopPropagation() if evt
    false
    
  parseDate: (date) -> d3.time.format.iso.parse(date)
    
  drawTrendlineScaffold: =>
    margin = {top: 20, right: 20, bottom: 30, left: 50}
    @width = 960 - margin.left - margin.right
    @height = 200 - margin.top - margin.bottom

    @x = d3.time.scale().range([0, @width])
    @y = d3.scale.linear().range([@height, 0]);
    @y = d3.scale.linear().range([@height, 0]);

    @line_accel = d3.svg.line()
    .x( (d) => @x(d.date) )
    .y( (d) => @y(d.close));

    @line_gps = d3.svg.line()
    .x( (d) => @x(d.date) )
    .y( (d) => @y(d.close));

    @svg_accel = d3.select( @$(".chart-container")[0]).append("svg")
    .attr("width", @width + margin.left + margin.right)
    .attr("height", @height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    @svg_gps = d3.select( @$(".chart-container")[0]).append("svg")
    .attr("width", @width + margin.left + margin.right)
    .attr("height", @height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  refreshTrendlines: =>
    # clean up the SVG
    @svg_accel.selectAll("path").remove()
    @svg_gps.selectAll("path").remove()

    # reset the x axis to show the last 30 seconds
    @x.domain([Date.now() - 20000, Date.now() ])

    plotOne = (svg, line_generator, data) =>
      #throw error if (error) 

      data.forEach (d) =>
        d.date = @parseDate(d.date)
        d.close = +d.close

      #@x.domain(d3.extent(data, (d) -> d.date ));
      @y.domain(d3.extent(data, (d) -> d.close ));
    
      svg.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line_generator);
    
    sum = 0
    velocityx = @collection.map (j,i) => 
      sum += j.get("accelx") / @collection.models.length if j.get("accelx")
      {date: j.get("timestamp"), close: sum}

    sum = 0
    velocityy = @collection.map (j,i) => 
      sum += j.get("accely") / @collection.models.length if j.get("accely")
      {date: j.get("timestamp"), close: sum}

    sum = 0
    velocityz = @collection.map (j,i) => 
      sum += j.get("accelz") / @collection.models.length if j.get("accelz")
      {date: j.get("timestamp"), close: sum}

    plotOne( @svg_accel, @line_accel, @collection.map (j,i) -> {date: j.get("timestamp"), close: j.get("accelx")})
    plotOne( @svg_accel, @line_accel, @collection.map (j,i) -> {date: j.get("timestamp"), close: j.get("accely")})
    plotOne( @svg_accel, @line_accel, @collection.map (j,i) -> {date: j.get("timestamp"), close: j.get("accelz")})

    plotOne( @svg_gps, @line_gps,  velocityx)
    plotOne( @svg_gps, @line_gps,  velocityy)
    plotOne( @svg_gps, @line_gps,  velocityz)

    
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
    #setInterval( =>
      #@refreshTrendlines() if @recording == true
    #, 500 ) 
    
    # saves all the unsaved measurements periodically
    #setInterval @collection.saveMany, 2000
    
    # grabs data periodically for display unless recording
    setInterval( =>
      if @recording == false
        @collection.fetch
          success: @refreshTrendlines
    , 1000 )

    return this
