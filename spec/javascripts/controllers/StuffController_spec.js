
describe('StuffCtrl', function() {


  var controller,
  httpBackend,
  $location,
  gmarker,
  google,
  mockUserService,
  mockMarkerService,
  routeParams,
  $q,
  $rootScope,
  $scope,
  UserService;

  var setupController = function(){
    module('stfmpr');

    inject(function(_$controller_,_$q_, _$rootScope_, _$httpBackend_, _$location_, _$routeParams_, UserService, MarkerService){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      $controller = _$controller_;
      $location = _$location_;
      $q = _$q_;
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $routeParams = _$routeParams_;
      httpBackend = _$httpBackend_;
      spyOn(UserService,"check").andReturn( UserService.currentUser = 'Jack');
      $scope.currentUser = 'Jack';
      $scope.map = jasmine.createSpyObj('map',['new']);
      gmarker = jasmine.createSpyObj('gmarker',['setIcon', 'setMap']);
      $scope.markers = {
       1:{dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
       2:{dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker},
       3:{dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
       4:{dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
       5:{dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker },
       6:{ marker:gmarker}
      };
      MarkerService.markers = $scope.markers;
      controller = $controller('StuffCtrl', { $scope: $scope });
    });


  };

  describe('center map', function() {
    it('calls map service', function() {
      setupController()

      throw new Error('not implemented!!')

    });

    it('sets map to the User Location', function() {
      setupController();

      throw new Error('not implemented!!')

    });

    it('Sets an alert if the Location service is unavailable', function() {
      setupController();
      throw new Error('not implemented!!')
    });

  });

  describe('Get Details', function() {
    it('only make the call once if you click on details or the icon', function() {
      setupController()
      throw new Error('not implemented!!')

    });
  });
  describe('Give Stuff', function() {
    it('opens up Give Stuff when in the routeParams ', function() {
      setupController();
      controller = $controller('StuffCtrl', {
        $scope: $scope,
        $routeParams: { menuState: 'giveStuff'}
      });

      expect($scope.tabs.giveStuff ).toEqual(true)

    });
    it('sets the routeParams', function() {
      setupController();
      expect( $location.url() ).toEqual('/')
      $scope.giveStuff();
      expect($location.url() ).toEqual('/menu/giveStuff')
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
      expect($scope.mapHeight).toEqual('map-1');
      expect($scope.menuHeight).toEqual('menu-1');
    });
  });


});
