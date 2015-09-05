class Trendline.Routers.AccelsRouter extends Backbone.Router
  initialize: (options) ->
    @accels = new Trendline.Collections.AccelsCollection()
    @accels.reset options.accels

  routes:
    "new"      : "newAccel"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newAccel: ->
    @view = new Trendline.Views.Accels.NewView(collection: @accels)
    $("#accels").html(@view.render().el)

  index: ->
    @view = new Trendline.Views.Accels.IndexView(collection: @accels)
    $("#accels").html(@view.render().el)

  show: (id) ->
    accel = @accels.get(id)

    @view = new Trendline.Views.Accels.ShowView(model: accel)
    $("#accels").html(@view.render().el)

  edit: (id) ->
    accel = @accels.get(id)

    @view = new Trendline.Views.Accels.EditView(model: accel)
    $("#accels").html(@view.render().el)
