
factories = angular.module('factories')


factories.factory('AlertService',[ '$timeout'
	($timeout)->

	    alerts = {}

	    clear:-> alerts={};

	    add:(type,text)->
	    	key = Math.floor(Math.random() * 1000)
	    	alert = {type:type,text:text}
	    	alerts[key] = alert
	    	$timeout( (-> delete alerts[key] ),4000)



	    remove:(idx)-> alerts.splice(idx,1)

	    get:-> alerts
])
