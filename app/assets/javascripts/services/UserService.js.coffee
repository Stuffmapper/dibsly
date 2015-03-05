factories = angular.module('factories')

factories.factory('UserService',['$http',
    ($http) ->
        
        login: 
            (username,password,callback) -> 
                self = this
                loginData={ username:username, password:password};
                $http.post('/sessions/create', loginData)
                .success (data) ->
                    if(data && data.user)
                        self.currentUser=data.user
                    else
                        self.currentUser=false;
                
                    callback(null,data)

                .error (err)->
                    callback(err)           
        
        logout: 
            (callback) ->
                self = this
                $http.get('/log_out')
                    .success (data)->
                        self.currentUser=false;
                        callback(null,data)
                    .error (err)->
                        callback(err)
            
        check: 
            (callback) ->
                self=this;
                $http.get('/api/auth')
                
                .success (data)->
                    if (data && data.user)
                        self.currentUser=data.user
                    else
                        self.currentUser=false
                
                    callback(null,data)

                .error (err)->
                    callback(err)
])