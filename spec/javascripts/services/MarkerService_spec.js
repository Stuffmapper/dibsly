
describe('MyStuffCtrl', function() {


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
      expect(MarkerService.markers[1]).toEqual(markers[1]);
    });
    it('extends extends a Marker', function() {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.markers[1]).toEqual(info);
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
      expect(MarkerService.markers[1]).toEqual(info);
      MarkerService.setMarker(newinfo);
      expect(MarkerService.markers[1].marker).not.toBeUndefined();
    });
  });


});
