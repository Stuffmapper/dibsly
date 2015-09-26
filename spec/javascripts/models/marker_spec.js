
describe('MarkerService', function() {


  var mockMapsService,MarkerService, gmarker,gmap, markers, mockLocalService, $q, $rootScope;
  //Mocking google
  //TODO replace with a better Mocking strategy
  window.google = { 
   load: function(){ }// todo ..beter mocking
  };


  beforeEach(module('stfmpr'));
  var Marker, mockLocalService, mockMapsService, $q, $httpBackend;

  var setupController = function(){

    inject(function(_MapsService_, _Marker_, _LocalService_, _$q_, _$rootScope_,_$httpBackend_){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      Marker = _Marker_;
      $httpBackend =_$httpBackend_;
      mockLocalService = _LocalService_;
      mockMapsService = _MapsService_;
      $rootScope = _$rootScope_;
      $q = _$q_;
    });


  };

 
  describe('Marker ', function() {
 

    it('has accurate show functions', function() {
      setupController();
      var info = {
        id:1,
        url: 'this is a url',
        creator: 'someGuy',
        currentUser: 'someGuy'
      };
      var testMarker = new Marker(info);
    
      expect(testMarker.id).toEqual(info.id);
      expect(testMarker.showEdit()).toEqual(true);
      expect(testMarker.showDib()).toEqual(false);
      expect(testMarker.showUnDib()).toEqual(false)

    });


    it('creates a marker that does not show editing info for non creators', function() {
      setupController();

      var info2 = {
         id:2,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: true };
       var testMarker = new Marker(info2);

      expect(testMarker.id).toEqual(info2.id);
      expect(testMarker.showEdit()).toEqual(false);
      expect(testMarker.showDib()).toEqual(true);
      expect(testMarker.showUnDib()).toEqual(false);


    });

    it('creates a marker with that shows undib for current dibbers', function() {

     var info3 = {
        id:3,
        url: 'this is a url',
        creator: 'someOtherGuy',
        currentUser: 'someGuy',
        dibber: 'someGuy',
        isCurrentDibber: true };
      var testMarker = new Marker(info3);

      expect(testMarker.id).toEqual(info3.id);
      expect(testMarker.showEdit()).toEqual(false);
      expect(testMarker.showUnDib()).toEqual(true);

    });

    it('creates a marker that shows does not show dibs for the undibbable', function() {
      setupController();

      var info4 = {
         id:4,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false };
      var testMarker = new Marker(info4);

      expect(testMarker.id).toEqual(info4.id);
      expect(testMarker.showEdit()).toEqual(false);
      expect(testMarker.showUnDib()).toEqual(false);
      expect(testMarker.showDib()).toEqual(false);

    });
  });

  it('has a show wanted function', function() {

     var info3 = {
        id:3,
        url: 'this is a url',
        creator: 'someOtherGuy',
        currentUser: 'someOtherGuy',
        dibber: 'someGuy',
        status: 'dibbed',
        isCurrentDibber: false };
      var testMarker = new Marker(info3);
       expect(testMarker.showWanted).toBeDefined();

      expect(testMarker.showWanted()).toEqual(true);
      testMarker['status'] = 'new';
      expect(testMarker.showWanted()).toEqual(false);

    });


  describe('saveLocal function', function() {

    it('is defined', function() {
      setupController();
      var info4 = {
         id:4,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false };
      var testMarker = new Marker(info4);

      expect(testMarker.saveLocal ).toBeDefined
    });
    it('calls LocalService when a marker isn\'t temporary', function() {
      setupController();
      var info4 = {
         id:4,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false };
      var testMarker = new Marker(info4);

      spyOn(mockLocalService, 'set' ).and.returnValue(true);
      testMarker.saveLocal();
      expect(mockLocalService.set ).toHaveBeenCalled();
    });
    it(' does\t call a LocalService when a marker is temporary', function() {
      setupController();
      var info4 = {
         id:4,
         temporary: true,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false };
      var testMarker = new Marker(info4);

      spyOn(mockLocalService, 'set' ).and.returnValue(true);
      testMarker.saveLocal();
      expect(mockLocalService.set ).not.toHaveBeenCalled();
    });
  });
  describe('restful calls', function() {
    var testMarker;
    beforeEach(function(){
      setupController();
      var info4 = {
         id:'temporary',
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false,
         status: 'only local' };
      testMarker = new Marker(info4);
     var getHandler = $httpBackend.whenGET( /\/api\/posts\/\d.*/ )
     getHandler.respond({ post: {
      id:4,
      dibber:'Jack',
      updated_at:'2222',
      status:'reached the server' }});
    })

    it('is defines crud routes', function() {
  
      expect(testMarker.create ).toBeDefined
      expect(testMarker.get ).toBeDefined
      expect(testMarker.update ).toBeDefined
      expect(testMarker.remove ).toBeDefined
    });

    it('creates', function() {
      var createHandler = $httpBackend.whenPOST( /\/api\/posts.*/  )
      createHandler.respond({ post: {
      id:4,
      dibber:'Jack',
      updated_at:'2222',
      status:'reached the server' }});
      expect(testMarker.id ).toEqual('temporary')
      testMarker.create()
      $httpBackend.flush()
      expect(testMarker.id ).toEqual(4)
    });

    it('gets', function() {
      testMarker.id = 4;
      expect(testMarker.status ).toEqual('only local')
      testMarker.get()
      $httpBackend.flush()
      expect(testMarker.status ).toEqual('reached the server')
    });

    it('updates', function() {
      var updateHandler = $httpBackend.whenPOST( /\/api\/posts\/\d.*/  )
      updateHandler.respond({ post: {
      id:4,
      dibber:'Jack',
      updated_at:'2222',
      status:'reached the server' }});
      testMarker.id = 4;
      testMarker.status = "need to update"
      testMarker.updated_at = '1111'
      testMarker.update();
      $httpBackend.flush();
      expect(testMarker.updated_at ).toEqual('2222');
    });

    it('removes', function() {
      var deleteHandler = $httpBackend.whenDELETE( /\/api\/posts\/\d.*/  )
      deleteHandler.respond({ post: {
      id:4,
      dibber:'Jack',
      updated_at:'2222',
      status:'deleted' }});
      testMarker.id = 4
      spyOn(mockLocalService, 'unset' ).and.returnValue(true);
      testMarker.remove()
      $httpBackend.flush()
      expect(testMarker.status ).toEqual('deleted');
    });
   
  });
  describe('additional restful calls', function() {
    var testMarker;
    beforeEach(function(){
      setupController();
      var info3 = {
        id:3,
        url: 'this is a url',
        creator: 'someOtherGuy',
        currentUser: 'someOtherGuy',
        dibber: 'someGuy',
        status: 'dibbed',
        isCurrentDibber: false };
     testMarker = new Marker(info3);
     var getHandler = $httpBackend.whenGET( /\/api\/posts\/\d.*/ )
     getHandler.respond({ post: {
      id:4,
      dibber:'Jack',
      updated_at:'2222',
      status:'reached the server' }});
    })

    it(' exist', function() {
  
      expect(testMarker.rejectDibber ).toBeDefined

    });

    it('reject dibber', function() {
      var deleteHandler = $httpBackend.whenPOST( /\/api\/posts\/\d\/removecurrentdib.*/  )
      deleteHandler.respond({ post: {
      id:4,
      dibber:'Jack',
      updated_at:'2222',
      status:'new' }});
      testMarker.id = 4
      spyOn(mockLocalService, 'unset' ).and.returnValue(true);
      expect(testMarker.showWanted() ).toEqual(true);
      testMarker.rejectDibber()
      $httpBackend.flush()
      expect(testMarker.showWanted() ).toEqual(false);
    });
   
  });
});
