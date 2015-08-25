//
// describe('ImageService', function() {
//
//
//   var ImageService, gmarker, markers;
//   //Mocking google
//   //TODO replace with a better Mocking strategy
//
//
//   beforeEach(module('stfmpr'));
//
//   var setupController = function(){
//
//     inject(function(_ImageService_){
//       // The injector unwraps the underscores (_) from around the parameter names when matchin
//       ImageService = _ImageService_;
//
//     });
//   };
//
//   describe('ImageService', function() {
//     it('is defined', function() {
//       setupController();
//       expect(ImageService).toBeDefined();
//     });
//   });
//
//   describe('convert', function() {
//     it('converts a file', function() {
//       var file = {
//         lastModified: 1429400301000,
//         name: "IMG_0820.JPG",
//         size: 2778608
//       };
//       setupController();
//       return ImageService.convert(file)
//         .then(
//           function(data){console.log(typeof data)}
//         );
//
//
//     });
//   });
//
//   describe('upload', function() {
//     it('sets a Marker', function() {
//       setupController();
//       ImageService.upload();
//       throw new Error('not implemented')
//     });
//
//   });
//
//   describe('thumbnail', function() {
//     it('creates a thumbnail', function() {
//       setupController();
//       ImageService.set();
//       throw new Error('not implemented')
//     });
//
//   });
// });
