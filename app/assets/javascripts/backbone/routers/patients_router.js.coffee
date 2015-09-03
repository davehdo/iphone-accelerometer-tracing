class Trendline.Routers.PatientsRouter extends Backbone.Router
  initialize: (options) ->
    @patients = new Trendline.Collections.PatientsCollection()
    @patients.reset options.patients

  routes:
    "new"      : "newPatient"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newPatient: ->
    @view = new Trendline.Views.Patients.NewView(collection: @patients)
    $("#patients").html(@view.render().el)

  index: ->
    @view = new Trendline.Views.Patients.IndexView(collection: @patients)
    $("#patients").html(@view.render().el)

  show: (id) ->
    patient = @patients.get(id)

    @view = new Trendline.Views.Patients.ShowView(model: patient)
    $("#patients").html(@view.render().el)

  edit: (id) ->
    patient = @patients.get(id)

    @view = new Trendline.Views.Patients.EditView(model: patient)
    $("#patients").html(@view.render().el)
