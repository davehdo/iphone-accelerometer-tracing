Trendline.Views.Patients ||= {}

class Trendline.Views.Patients.EditView extends Backbone.View
  template: JST["backbone/templates/patients/edit"]

  events:
    "submit #edit-patient": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (patient) =>
        @model = patient
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
