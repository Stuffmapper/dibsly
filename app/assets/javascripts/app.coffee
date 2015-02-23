stfmpr = angular.module('stfmpr',[
        'controllers',
        'uiGmapgoogle-maps'
		
])


 
controllers = angular.module('controllers',[])

stfmpr.config( (uiGmapGoogleMapApiProvider)-> 
    uiGmapGoogleMapApiProvider.configure({
      
        v: '3.17',
        libraries: 'weather,geometry,visualization'
 	})
)	




