stfmpr = angular.module('stfmpr',[
        'templates',
        'controllers',
        'uiGmapgoogle-maps',
        'ui.bootstrap',
        
		
])


 
controllers = angular.module('controllers',[])

stfmpr.config( (uiGmapGoogleMapApiProvider)-> 
    uiGmapGoogleMapApiProvider.configure({
      
        v: '3.17',
        libraries: 'weather,geometry,visualization'
 	})
)	




