
describe('MyStuffCtrl', function() {
  beforeEach(module('stfmpr'));

  var $controller, mockUserService, mockMarkerService

  beforeEach(function(){
    mockUserService = {
      currentUser:'Jack', check: function(){ this.currentUser = 'Jack'}};
    mockMarkerService = {
      markers: {
        1:{dibber:'Jack', updated_at: new Date('2012-11-25')},
        2:{dibber:'Jack', updated_at: new Date('2014-11-22')},
        3:{dibber: "john" }
      }
    };
     module(function($provide){
       $provide.value('MarkerService', mockMarkerService);
       $provide.value('UserService', mockUserService);
     })

  });



  beforeEach(inject(function(_$controller_, _$rootScope_){
    // The injector unwraps the underscores (_) from around the parameter names when matching
    $controller = _$controller_;
    $rootScope = _$rootScope_;
  }));

  describe('showtab', function() {
    it('changes the tabs correctly ', function() {
      var $scope = $rootScope.$new();
      var controller = $controller('MyStuffCtrl', { $scope: $scope });
      $scope.tabs = {posts: true, messages: false, profile: false};
      // console.log(controller.$scope)
      $scope.showtab('messages');

      expect($scope.tabs.messages).toEqual(true);
      expect($scope.tabs.posts).toEqual(false);
    });
  });

  describe('showDibs', function() {
    it('returns the markers that have been dibbed', function() {
      //
      var $scope = $rootScope.$new();
      $scope.markers = mockMarkerService.markers;
      $scope.currentUser = 'Jack'
      var controller = $controller('MyStuffCtrl', { $scope: $scope });
      var dibs = $scope.show('dibber');
      console.log($scope.markers)
      expect(dibs[0]).toEqual($scope.markers[2]);
      expect(dibs[1]).toEqual($scope.markers[1]);
      expect(dibs.length).toEqual(2);
    });
  });
});
