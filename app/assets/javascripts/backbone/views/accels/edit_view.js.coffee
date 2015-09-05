Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.EditView extends Backbone.View
  template: JST["backbone/templates/accels/edit"]

  events:
    "submit #edit-accel": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (accel) =>
        @model = accel
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
