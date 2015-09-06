Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.IndexView extends Backbone.View
  template: JST["backbone/templates/accels/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)
    @recording = false
    
    @zero = 
      accelx: 0
      accely: 0
      accelz: 0

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
        
        #angle =  e.accelerationIncludingGravity.x ^ 2.0 + e.accelerationIncludingGravity.y ^ 2.0 + e.accelerationIncludingGravity.z ^ 2.0
#
        #angle = 0 if angle < 10
        #angle = 180 if angle > 180
        #@$("#hammer").rotate( -40 - angle  )

        
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
    
    
  
        
        

    
  render: =>
    @$el.html(@template(accels: @collection.toJSON() ))
    
    @$(".toggle-recording").click =>
      if @recording 
        @stopRecording()
      else
        @startRecording()
        
    @$(".zero").click =>
      last_model = @collection.models.slice(-1)[0]
      if last_model
        @zero = 
          accelx: last_model.get "accelx"
          accely: last_model.get "accely"
          accelz: last_model.get "accelz"

    # the trendlines
    @accelCharts = new trendlineScaffold
    @accelCharts.initialize( @$(".chart-container")[0] )


    # the velocities
    @velocCharts = new trendlineScaffold
    @velocCharts.initialize( @$(".chart-container")[0] )
    @velocCharts.x.domain([-1000, 1000])
    # the direction vectors
    
    # do a rapid refresh of the trendlines while recording to show ones own data
    setInterval( =>
      if @recording == true
        @accelCharts.refreshTrendlines( [
            (@collection.map (j,i) => {date: j.get("timestamp"), close: j.get("accelx") - @zero.accelx}),
            (@collection.map (j,i) => {date: j.get("timestamp"), close: j.get("accely") - @zero.accely}),
            (@collection.map (j,i) => {date: j.get("timestamp"), close: j.get("accelz") - @zero.accelz})
          ]) 
      
        @velocCharts.refreshTrendlines( [
          @collection.velocityx( @zero.accelx )
        ]) 
    , 500 ) 
    
    # saves all the unsaved measurements periodically
    #setInterval @collection.saveMany, 2000
    
    # grabs data from server periodically for display unless recording
    setInterval( =>
      if @recording == false
        @collection.fetch
          success: => 
            @accelCharts.refreshTrendlines( [
              (@collection.map (j,i) => {date: j.get("timestamp"), close: j.get("accelx") - @zero.accelx}),
              (@collection.map (j,i) => {date: j.get("timestamp"), close: j.get("accely") - @zero.accely}),
              (@collection.map (j,i) => {date: j.get("timestamp"), close: j.get("accelz") - @zero.accelz})
            ])
            
            @velocCharts.refreshTrendlines( [
              @collection.velocityx( @zero.accelx )
              @collection.velocityy( @zero.accely )
              @collection.velocityz( @zero.accelz )
            ]) 

    , 1000 )

    return this


class trendlineScaffold
  initialize: (parentDiv) ->

    @margin = {top: 20, right: 20, bottom: 30, left: 50}

    @width = 960 - @margin.left - @margin.right
    @height = 200 - @margin.top - @margin.bottom

    @x = d3.time.scale().range([0, @width])
    @y = d3.scale.linear().range([@height, 0]).domain([-10, 10])

    @line = d3.svg.line()
        .x( (d) => @x(d.date) )
        .y( (d) => @y(d.close))

    @svg = d3.select( parentDiv ).append("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")


  parseDate: (date) -> d3.time.format.iso.parse(date)

  yAxis: => d3.svg.axis().scale(@y).orient("left")


  drawYAxis: =>
    @svg.append("g")
      .attr("class", "y axis")
      .call(@yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")

  refreshTrendlines: (data) =>
    # clean up the SVG
    @svg.selectAll("path").remove()
    # reset the x axis to show the last 30 seconds
    @x.domain([Date.now() - 20000, Date.now() ])
    $.map data, (a) =>
      a.forEach (d) =>
        d.date = @parseDate(d.date)
        #d.close = +d.close
      @svg.append("path").datum(a).attr("class", "line").attr("d", @line)