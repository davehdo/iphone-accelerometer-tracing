Trendline.Views.Patients ||= {}

class Trendline.Views.Patients.IndexView extends Backbone.View
  template: JST["backbone/templates/patients/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (patient) =>
    view = new Trendline.Views.Patients.PatientView({model : patient})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(patients: @collection.toJSON() ))
    @addAll()

    return this
