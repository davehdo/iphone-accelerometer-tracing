Trendline.Views.Patients ||= {}

class Trendline.Views.Patients.ShowView extends Backbone.View
  template: JST["backbone/templates/patients/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))

    @$el.find(".parameters-container").html """
	<div class="row">
		<div class="col-xs-1"><div class="y-axis-container"></div></div>
		<div class="col-xs-7"><div class="chart-container" style="overflow:scroll"></div></div>
		<div class="col-xs-4">
			<h4>Blood pressure</h4>
			<h1>96<h1>
		</div>
	</div>

"""
    return this
