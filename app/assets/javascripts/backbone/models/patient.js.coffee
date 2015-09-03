class Trendline.Models.Patient extends Backbone.Model
  paramRoot: 'patient'

  defaults:
    name: null
 
  initialize: (options) ->
    @annotations = new Trendline.Collections.AnnotationsCollection()

    @annotations.url = "/patients/#{ @get("id") }/annotations"
    @annotations.reset options.annotations

class Trendline.Collections.PatientsCollection extends Backbone.Collection
  model: Trendline.Models.Patient
  url: '/patients'
