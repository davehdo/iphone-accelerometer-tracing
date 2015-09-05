Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.AccelView extends Backbone.View
  template: JST["backbone/templates/accels/accel"]

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
