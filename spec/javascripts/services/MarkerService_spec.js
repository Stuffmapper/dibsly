
describe('MarkerService', function() {


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
  var markers;

  var setupController = function(){

    inject(function(_MarkerService_){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      MarkerService = _MarkerService_;
    });
    gmarker = jasmine.createSpyObj('gmarker',['setIcon', ])
    markers = {
     1:{id:1, dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
     2:{id: 2, dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker, category: 'books'},
     3:{id:3, dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
     4:{id:4, dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
     5:{id:5, dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker, },
     6:{id:6, marker:gmarker}
    };
  };




  describe('Marker Service', function() {
    it('is defined', function() {
      setupController();
      expect(MarkerService).toBeDefined();
    });
  });
  describe('delete', function() {
    it('is defined', function() {
      setupController();
      MarkerService.markers = markers;
      expect(MarkerService.delete).toBeDefined();
      expect(MarkerService.markers[1]).toBeDefined();
      MarkerService.delete( MarkerService.markers[1] );
      expect(MarkerService.markers[1]).toEqual(undefined);

    });
  });


  describe('MarkerService.contains', function() {
    it('is defined', function() {
      setupController();
      expect(MarkerService.contains).toBeDefined();
    });
    it('returns a boolean if an item is in an object', function() {
      setupController();
      expect(MarkerService.contains({category: 'books'}, {category: 'books'} )).toEqual(true)
      expect(MarkerService.contains({category: 'books'}, {category: 'bookers'} )).toEqual(false)
    });
  });

  describe('setMarker ', function() {
    it('sets a Marker', function() {
      setupController();
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(markers[1])
      expect(MarkerService.markers[1].mapped).toEqual(false) //because map not defined
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
  describe('Marker properties categories', function() {
    it('is defined', function() {
      setupController();
      expect(MarkerService.categories).toBeDefined
      var info = {
         id:1,
         url: 'this is a url',
         creator: 'someOtherGuy',
         currentUser: 'someGuy',
         dibbable: false };
      MarkerService.setMarker(info);
      expect(MarkerService.editProperties ).toBeDefined

      expect(MarkerService.categories ).toBeDefined();
    });
    it('attaches  a list editable properties to the marker', function() {
      setupController();

      expect(MarkerService.editProperties ).toEqual(
        [ 'id',
          'category',
          'description',
          'image_url',
          'latitude',
          'longitude',
          'on_the_curb',
          'published',
          'title'
        ]
      );
    });

    it('has a list of categories', function(){
      setupController();
      expect(MarkerService.categories ).toEqual(
      ['Arts & Crafts',
      'Books, Games, Media',
      'Building & Garden Materials',
      'Clothing & Accessories',
      'Electronics',
      'Furniture & Household',
      'General',
      'Kids & Babies',
      'Recreation'] );
    });
  });
  describe('Where function', function() {
    var testMarkers;
    beforeEach( function(){
      testMarkers = [
        {
          id:1,
          dibber:'Jack',
          updated_at: new Date('2012-11-25'),//4
          marker: gmarker,
          fake:true
        },
        {
          id: 2,
          dibber:'Jack',
          updated_at: new Date('2014-11-22'),//2
          marker: gmarker,
          category: 'books',
          fake:true
        },
        {
          id:3,
          dibber: 'john',
          creator:'Jack',
          updated_at: new Date('2012-11-24'),//5
          marker: gmarker,
          fake:true
        },
        {
          id:4,
          dibber:'Jackie',
          creator:'Jack',
          updated_at: new Date('2012-11-26'),//3
          marker: gmarker,
          fake:true

        },
        {
          id:5,
          dibber:'Jack',
          updated_at: new Date('2014-11-23'),//1
          marker: gmarker,
          fake:true
        },
        {id:6, marker:gmarker}
      ];

    })
    it('is defined', function() {
      setupController();
      expect(MarkerService.where ).toBeDefined
    });

    it('is returns markers with matching attributes', function() {
      setupController();
      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where({ dibber:'john' });
      expect(results.length ).toEqual(1)
      expect(results[0].id ).toEqual(3)


    });

    it('returns markers with matching attributes in order', function() {
      setupController();


      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where({ fake:true });
      expect(results.length ).toEqual(5)
      expect(results[0].id ).toEqual(5)
      expect(results[1].id ).toEqual(2)
      expect(results[3].id ).toEqual(1)

    });

    it('returns markers if they haven\'t been mapped', function() {
      setupController();


      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where({ mapped:false });
      expect(results.length ).toEqual(6)

    });

    it('is doesn\'t return results in the negative', function() {
      setupController();
      angular.forEach(markers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where({ dibber:'Jack' }, { category: 'books'});
      expect(results.length ).toEqual(2)
      expect(results[1].id ).toEqual(1)
    });
    it('is returns everything with an empty object' , function() {
      setupController();
      angular.forEach(markers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where({});
      expect(results.length ).toEqual(6)
    });

  });
});
