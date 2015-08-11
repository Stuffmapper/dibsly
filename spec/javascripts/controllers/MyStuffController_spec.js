
describe('MyStuffCtrl', function() {
  beforeEach(module('stfmpr'));

  var controller,
  httpBackend,
  mockUserService,
  mockMarkerService,
  routeParams,
  $rootScope,
  $scope;



  var setupController = function(){
    mockUserService = {
      currentUser:'Jack', check: function(){ this.currentUser = 'Jack'}};
    mockMarkerService = {};
     module(function($provide){
       $provide.value('MarkerService', mockMarkerService);
       $provide.value('UserService', mockUserService);
     });

    inject(function(_$controller_, _$rootScope_, _$httpBackend_, _$routeParams_){
      // The injector unwraps the underscores (_) from around the parameter names when matching
      $controller = _$controller_;
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $routeParams = _$routeParams_;
      httpBackend = _$httpBackend_;
      controller = $controller('MyStuffCtrl', { $scope: $scope });
    });

    $scope.markers = {
     1:{dibber:'Jack', updated_at: new Date('2012-11-25')},
     2:{dibber:'Jack', updated_at: new Date('2014-11-22')},
     3:{dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24') },
     4:{dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25')},
     5:{dibber:'Jack', updated_at: new Date('2014-11-23')},
     6:{dibber: "john" }
    };
  };

  describe('showtab', function() {
    it('changes the tabs correctly ', function() {
      setupController();
      $scope.tabs = {posts: true, messages: false, profile: false};
      $scope.showtab('messages');
      expect($scope.tabs.messages).toEqual(true);
      expect($scope.tabs.posts).toEqual(false);
    });
  });

  describe('show dibs', function() {
    it('returns the markers that have been dibbed', function() {
      setupController();
      $scope.currentUser = 'Jack'
      var dibs = $scope.show('dibber');
      expect(dibs[0]).toBe(  $scope.markers[5]);
      expect(dibs[1]).toBe(  $scope.markers[2]);
      expect(dibs.length).toEqual(3);
    });
  });

  describe('show posts', function() {
    it('returns the markers that have been dibbed', function() {
      setupController();
      $scope.currentUser = 'Jack'
      var posts = $scope.show('creator');
      expect(posts[0]).toBe(  $scope.markers[4]);
      expect(posts[1]).toBe(  $scope.markers[3]);
      expect(posts.length).toEqual(2);
    });
  });

});
