directives = angular.module('directives')

directives.directive('fileUpload', ->
    scope: true,
    link: (scope, el, attrs) ->
        el.bind('change', (event) ->
            files = event.target.files;
            if event.target.files.length > 1
              files = event.target.files[0]
            scope.$emit("fileSelected", { file: file }) for file in files
            )
)
