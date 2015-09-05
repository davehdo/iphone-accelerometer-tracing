Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.NewView extends Backbone.View
  template: JST["backbone/templates/accels/new"]

  events:
    "submit #new-accel": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (accel) =>
        @model = accel
        window.location.hash = "/#{@model.id}"

      error: (accel, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
