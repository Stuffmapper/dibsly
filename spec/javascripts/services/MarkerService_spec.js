
describe('MarkerService', function() {


  var mockMapsService,MarkerService, gmarker,gmap, markers, mockLocalService, $q, $rootScope;
  //Mocking google
  //TODO replace with a better Mocking strategy
  window.google = { 
   load: function(){ }// todo ..beter mocking
  };


  beforeEach(module('stfmpr'));
  var markers;

  var setupController = function(){

    inject(function(_MapsService_, _MarkerService_, _LocalService_, _$q_, _$rootScope_ ){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      MarkerService = _MarkerService_;
      mockLocalService = _LocalService_;
      mockMapsService = _MapsService_;
      $rootScope = _$rootScope_;
      $q = _$q_;
    });
    gmarker = jasmine.createSpyObj('gmarker',['setIcon', 'setMap' ]);
    gmap = jasmine.createSpyObj('gmap',['panTo' ]);
    markers = {
     1:{id:1, dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
     2:{id: 2, dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker, category: 'books'},
     3:{id:3, dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
     4:{id:4, dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
     5:{id:5, dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker, },
     6:{id:6, marker:gmarker}
    };
    spyOn(mockMapsService,'loadMap').and.returnValue( $q( function(resolve, reject){ resolve(gmap); }) ) 
    spyOn(mockMapsService,'newMapMarker').and.returnValue( $q( function(resolve, reject){ resolve(gmarker); }) ) 
    spyOn(mockMapsService,'addMarkerListener').and.returnValue( true );
    spyOn(mockMapsService,'updateMarker').and.returnValue( true ) 

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
      MarkerService.setMarker(markers[1]);
      $rootScope.$digest();
      expect(MarkerService.delete).toBeDefined();
      expect(MarkerService.getMarker(1)).toBeDefined();
      MarkerService.delete(1);
      expect(MarkerService.getMarker(1)).toEqual(undefined);

    });
  });


  describe('MarkerService.contains', function() {
    it('is defined', function() {
      setupController();
      expect(MarkerService.contains).toBeDefined();
    });
    it('returns a boolean if an item is in an object', function() {
      setupController();
      expect(MarkerService.contains({category: 'books'},
      [{category: 'books'}] )).toEqual(true)
      expect(MarkerService.contains({category: 'books'}, [{category: 'bookers'}] )).toEqual(false)
    });
  });

  describe('setMarker ', function() {
    it('sets a Marker', function() {
      setupController();
      expect(MarkerService.getMarker(1)).toBeUndefined();
      MarkerService.setMarker(markers[1])
      expect(MarkerService.getMarker(1).updated_at ).toEqual(markers[1].updated_at );
    });
    it('extends a Marker', function() {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.getMarker(1)).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.getMarker(1).id).toEqual(info.id);
      MarkerService.setMarker(newinfo);
      expect(MarkerService.getMarker(1).url).toEqual(info.url);
      expect(MarkerService.getMarker(1).url_image).toEqual(newinfo.url_image);
    });

    it('creates a marker ', function(done) {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.getMarker(1)).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.getMarker(1).id).toEqual(info.id);
      MarkerService.setMarker(newinfo)
      .then(
        function(){
          expect(MarkerService.getMarker(1).marker).not.toBeUndefined();
          done();
        }
      )
      $rootScope.$digest();
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

    it('returns markers with matching attributes', function() {
      setupController();
      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where([{ dibber:'john' }]);
      expect(results.length ).toEqual(1)
      expect(results[0].id ).toEqual(3)


    });

    it('returns markers with matching attributes in order', function() {
      setupController();


      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where([{ fake:true }]);
      expect(results.length ).toEqual(5)
      expect(results[0].id ).toEqual(5)
      expect(results[1].id ).toEqual(2)
      expect(results[3].id ).toEqual(1)

    });
    it('takes a single object or an array', function() {
      setupController();


      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where([{ fake:true }]);
      expect(results.length ).toEqual(5)
      expect(results[0].id ).toEqual(5)
      expect(results[1].id ).toEqual(2)
      expect(results[3].id ).toEqual(1)
      results = MarkerService.where({ fake:true });
      expect(results.length ).toEqual(5)
      expect(results[0].id ).toEqual(5)
      expect(results[1].id ).toEqual(2)
      expect(results[3].id ).toEqual(1)


    });


    it('returns items with multiple values for the same attributes', function() {
      setupController();


      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where([{ id:5 }, {id:2 }]);
      expect(results.length ).toEqual(2)
      expect(results[0].id ).toEqual(5)
      expect(results[1].id ).toEqual(2)


    });

    it('returns markers if they haven\'t been mapped', function() {
      setupController();
      angular.forEach(testMarkers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where();
      expect(results.length ).toEqual(6)

    });

    it('is doesn\'t return results in the negative', function() {
      setupController();
      angular.forEach(markers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where([{ dibber: 'Jack' }], [{ category: 'books'}]);
      expect(results.length ).toEqual(2)
      expect(results[1].id ).toEqual(1)
    });
    it('is returns everything with an empty object' , function() {
      setupController();
      angular.forEach(markers, function(value){
        MarkerService.setMarker(value)
      })
      var results = MarkerService.where([]);
      expect(results.length ).toEqual(6)
      results = MarkerService.where();
      expect(results.length ).toEqual(6)
      results = MarkerService.where([{}]);
      expect(results.length ).toEqual(6)
    });

  });

});
