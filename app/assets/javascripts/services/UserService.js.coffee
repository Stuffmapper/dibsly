factories = angular.module('factories')

factories.factory('UserService',['$http','LocalService',
    ($http, LocalService) ->

        login:
            (username,password,callback) ->
                self = this
                loginData={ username:username, password:password};
                $http.post('/api/sessions/create', loginData)
                .success (data) ->
                    if(data && data.user)
                        self.currentUser = data.user
                        self.token = data.token
                        LocalService.set('sMToken', JSON.stringify(data))
                    else
                        console.log(data)
                        LocalService.unset('sMToken')
                        self.currentUser=false;

                    callback(null,data)

                .error (err)->
                  console.log(err)
                  self.currentUser=false;
                  callback(err)


        logout:
            (callback) ->
                self = this
                localStorage.clear()
                $http.get('/api/log_out')
                    .success (data)->
                        self.currentUser=false;
                        callback(null,data)
                    .error (err)->
                        callback(err)

        check:
            (callback) ->
                self=this;
                user = JSON.parse(LocalService.get('sMToken'))
                if user
                  $http.get('/api/auth/check?token='+ user.token
                  )
                  .success (data)->
                      self.currentUser = user.user
                      console.log('49')
                      callback(null,'success')
                  .error (err)->
                      self.currentUser=false
                      console.log('5')
                      callback('err')
                else
                  console.log('56')
                  callback('error')
                  self.currentUser = false
])
