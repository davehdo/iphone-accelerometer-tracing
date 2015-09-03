Trendline.Views.Patients ||= {}

class Trendline.Views.Patients.PatientView extends Backbone.View
  template: JST["backbone/templates/patients/patient"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
