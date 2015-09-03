class Trendline.Models.Patient extends Backbone.Model
  paramRoot: 'patient'

  defaults:
    name: null

class Trendline.Collections.PatientsCollection extends Backbone.Collection
  model: Trendline.Models.Patient
  url: '/patients'
