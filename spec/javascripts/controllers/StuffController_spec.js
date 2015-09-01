
describe('StuffCtrl', function() {


  var controller,
  httpBackend,
  $location,
  gmarker,
  LocationService,
  mockMapsService,
  MarkerService,
  mockMarkerService,
  routeParams,
  $q,
  $rootScope,
  $scope,
  UserService;

  var setupController = function(){
    module('stfmpr');

    inject(function(_$controller_,_$q_, _$rootScope_, _$httpBackend_,
       _$location_, _$routeParams_, LocationService, UserService, MarkerService, MapsService){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      $controller = _$controller_;
      $location = _$location_;
      $q = _$q_;
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $routeParams = _$routeParams_;
      httpBackend = _$httpBackend_;
      LocationService = LocationService;
      spyOn(UserService,"check").and.returnValue( UserService.currentUser = 'Jack');
      $scope.currentUser = 'Jack';
      $scope.map = jasmine.createSpyObj('map',['new']);
      gmarker = jasmine.createSpyObj('gmarker',['setIcon', 'setMap']);
      var markers = {
       1:{dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
       2:{dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker},
       3:{dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
       4:{dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
       5:{dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker },
       6:{ marker:gmarker}
      };
      MarkerService.markers = markers;
      mockMarkerService = MarkerService;
      mockMapsService = MapsService;
      spyOn(mockMapsService, 'panTo').and.returnValue('non')
      spyOn(mockMapsService, 'getCenter').and.returnValue({lat:1, lat:2})
      spyOn(mockMapsService, 'addMapListener').and.returnValue('');

      controller = $controller('StuffCtrl', { $scope: $scope });
    });


  };

  describe('center map', function() {
    beforeEach(function(done) {
      done();
    }, 4000);


    it('calls map service center function without navigator', function(done) {
      setupController();
      //MapsService =
      $scope.centerMap()
      .then( function(data){
        expect(mockMapsService.getCenter ).toHaveBeenCalled();
        done();

      })
      $rootScope.$digest();
      //needed for promises to resolve

    });

    it('sets map to the User Location when there is a navigator', function(done) {
      setupController();
      spyOn(mockMapsService, 'newLatLng').and.returnValue('none')
       window.navigator = { geolocation: {
          getCurrentPosition: function(success, error, geoOptions){
             success({
               coords: { latitude:1, longitude: 3 }
             })
          }
        }
      };
      $scope.centerMap()
      .then( function(data){
        expect( mockMapsService.newLatLng ).toHaveBeenCalled();
        done();
      })
      $rootScope.$digest();
      //needed for promises to resolve
    });


  });

  describe('Give Stuff', function() {
    it('opens up Give Stuff when in the routeParams ', function() {
      setupController();
      controller = $controller('StuffCtrl', {
        $scope: $scope,
        $routeParams: { menuState: 'giveStuff'}
      });
      $scope.$emit('mapInitialized', {}) //to fake the map loading
      expect($scope.tabs.giveStuff[0] ).toEqual(true)

    });
    it('sets the routeParams', function() {
      setupController();
      expect( $location.url() ).toEqual('/')
      $scope.giveStuff();
      expect($location.url() ).toEqual('/menu/giveStuff/1')
    });

  });

  describe('change to give stuff tabmap', function() {
    it('sets the classes for the map and menu', function() {
      setupController()
      expect($scope.mapHeight).toBeDefined();
      expect($scope.menuHeight).toBeDefined();
    });
    it('sets the classes for the map and menu', function() {
      setupController();
      $scope.giveStuff();
      expect($scope.mapHeight).toEqual('map-1-1');
      expect($scope.menuHeight).toEqual('menu-1-1');
    });
  });

  describe('get markers', function() {
    it('is defined', function() {
      setupController()
      expect($scope.markers).toBeDefined();
    });
    it('sets the classes for the map and menu', function() {
      setupController();
      spyOn(mockMarkerService, 'where');
      $scope.markers({visable:true})

      expect(mockMarkerService.where).toHaveBeenCalled();

    });
  });
  describe('mapChanged', function() {
    it('activates the updateMarkers', function() {
      setupController();
      spyOn($scope, 'updateMarkers');
      $scope.$emit('mapChanged', {nw:{lat:1, lon:2},se:{lat:1, lon:2}})

      expect($scope.updateMarkers).toHaveBeenCalled();

    });
  });
  describe('mapInitialized', function() {
    it('sets event listeners', function() {
      setupController();
      $scope.$emit('mapInitialized')
      expect(mockMapsService.addMapListener).toHaveBeenCalled();
    });
  });




});
