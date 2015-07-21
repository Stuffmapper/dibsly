factories = angular.module('factories')

factories.factory('AuthInterceptor',['$q','$injector',
    ($q, $injector)->
      LocalService = $injector.get('LocalService')
      request: (config)->
        if (LocalService.get('sMToken'))
          token = JSON.parse((LocalService.get('sMToken'))).token
        if (token)
          config.headers.Authorization = 'Bearer ' + token
        return config
      responseError: (response)->
        if (response.status == 401 || response.status == 403)
          LocalService.unset('sMToken');
        return $q.reject(response)
])
