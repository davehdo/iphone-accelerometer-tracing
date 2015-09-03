class Trendline.Models.Annotation extends Backbone.Model
  paramRoot: 'annotation'

  defaults:
    category: null
    comment: null
    occurred_at: null

class Trendline.Collections.AnnotationsCollection extends Backbone.Collection
  model: Trendline.Models.Annotation
  # url: 'a' # this is set dynamically in patient.js.coffee because its a nested resource
