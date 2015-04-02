directives = angular.module('directives')

directives.directive('fileUpload', ->
    scope: true,        
    link: (scope, el, attrs) ->
        el.bind('change', (event) ->
            files = event.target.files;
            scope.$emit("fileSelected", { file: file }) for file in files
            )
)