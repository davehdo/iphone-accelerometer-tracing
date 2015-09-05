Trendline.Views.Accels ||= {}

class Trendline.Views.Accels.ShowView extends Backbone.View
  template: JST["backbone/templates/accels/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
