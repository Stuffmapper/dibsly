
factories = angular.module('factories')


factories.factory('AlertService',[ ->

    alerts = []

    clear:-> alerts=[];

    add:(type,text)-> alerts.push({type:type,text:text})
    
    remove:(idx)-> alerts.splice(idx,1)

    get:-> alerts
])