
factories = angular.module('factories')


factories.factory('AlertService',[ '$timeout'
	($timeout)->

	    alerts = []

	    clear:-> alerts=[];

	    add:(type,text)->
	    	alerts=[]
	    	$timeout( (-> alerts=[]),2300)
	    	alerts.push({type:type,text:text})
	    	
	    
	    remove:(idx)-> alerts.splice(idx,1)

	    get:-> alerts
])