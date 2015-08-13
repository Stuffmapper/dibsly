
describe('MyStuffController', function() {


  var MarkerService, gmarker, markers;
  //Mocking google
  //TODO replace with a better Mocking strategy
  window.google = { maps: {
      LatLng: function(){ return {} },
      event: { addListener: function(){} },
      Marker: function(){ return {thing: 'marker'} }
    }
  };


  beforeEach(module('stfmpr'));

  var setupController = function(){

    inject(function(_MarkerService_){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      MarkerService = _MarkerService_;
    });
    gmarker = jasmine.createSpyObj('gmarker',['setIcon', ])
    markers = {
     1:{id:1, dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
     2:{id: 2, dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker},
     3:{id:3, dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
     4:{id:4, dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
     5:{id:5, dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker },
     6:{id:6, marker:gmarker}
    };
  };



  describe('Marker Service', function() {
    it('is defined', function() {
      setupController();
      expect(MarkerService).toBeDefined();
    });
  });

  describe('setMarker ', function() {
    it('sets a Marker', function() {
      setupController();
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(markers[1])
      expect(MarkerService.markers[1].updated_at ).toEqual(markers[1].updated_at );
    });
    it('extends a Marker', function() {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.markers[1].id).toEqual(info.id);
      MarkerService.setMarker(newinfo);
      expect(MarkerService.markers[1].url).toEqual(info.url);
      expect(MarkerService.markers[1].url_image).toEqual(newinfo.url_image);
    });

    it('creates a marker ', function() {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.markers[1].id).toEqual(info.id);
      MarkerService.setMarker(newinfo);
      expect(MarkerService.markers[1].marker).not.toBeUndefined();
    });

    it('creates a marker with show dib and show edit functions', function() {
      setupController();
      var info = {
        id:1,
        url: 'this is a url',
        creator: 'someGuy',
        currentUser: 'someGuy'
      };

      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.markers[1].id).toEqual(info.id);
      expect(MarkerService.markers[1].showEdit()).toEqual(true);
      expect(MarkerService.markers[1].showDib()).toEqual(false);
      expect(MarkerService.markers[1].showUnDib()).toEqual(false)


    });


    it('creates a marker that does not show editing info for non creators', function() {
      setupController();

      var info2 = {
         id:2,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: true };

      expect(MarkerService.markers[2]).toBeUndefined();
      MarkerService.setMarker(info2);
      expect(MarkerService.markers[2].id).toEqual(info2.id);
      expect(MarkerService.markers[2].showEdit()).toEqual(false);
      expect(MarkerService.markers[2].showDib()).toEqual(true);
      expect(MarkerService.markers[2].showUnDib()).toEqual(false);


    });

    it('creates a marker with that shows undib for current dibbers', function() {

     var info3 = {
        id:3,
        url: 'this is a url',
        creator: 'someOtherGuy',
        currentUser: 'someGuy',
        dibber: 'someGuy',
        isCurrentDibber: true };

      expect(MarkerService.markers[3]).toBeUndefined();
      MarkerService.setMarker(info3);
      expect(MarkerService.markers[3].id).toEqual(info3.id);
      expect(MarkerService.markers[3].showEdit()).toEqual(false);
      expect(MarkerService.markers[3].showUnDib()).toEqual(true);

    });

    it('creates a marker that shows does not show dibs for the undibbable', function() {
      setupController();

      var info4 = {
         id:4,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false };

      expect(MarkerService.markers[4]).toBeUndefined();
      MarkerService.setMarker(info4);
      expect(MarkerService.markers[4].id).toEqual(info4.id);
      expect(MarkerService.markers[4].showEdit()).toEqual(false);
      expect(MarkerService.markers[4].showUnDib()).toEqual(false);
      expect(MarkerService.markers[4].showDib()).toEqual(false);

    });
  });
});
