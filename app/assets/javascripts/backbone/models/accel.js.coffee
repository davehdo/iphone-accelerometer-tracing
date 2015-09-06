class Trendline.Models.Accel extends Backbone.Model
  paramRoot: 'accel'

  defaults:
    #accelx: null
    #accely: null
    #accelz: null
    #rota: null
    #rotb: null
    #rotg: null
    timestamp: null # takes the format of a string in iso
    user_identifier: null

class Trendline.Collections.AccelsCollection extends Backbone.Collection
  model: Trendline.Models.Accel
  url: '/accels'
  
  comparator: 'timestamp'
  
  saveMany: =>
    jsonToSave = []
    modelsToSave = []
    @map (i) -> 
      if i.isNew() 
        jsonToSave.push i.toJSON()
        modelsToSave.push i
        
    if jsonToSave.length > 0
      $.ajax(
        type: "POST"
        url: "/accels/save_many"
        data: {accel: jsonToSave}
        success: (models) => 
          $.map modelsToSave, (model) =>
            @remove model
          $.map models, (model) =>
            @add(model)
          
          console.log "Saved many"
        error: -> console.log "Error: Attempted to save many but failed"
        dataType: "json"
      )