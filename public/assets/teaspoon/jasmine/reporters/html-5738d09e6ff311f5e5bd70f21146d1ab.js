(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Teaspoon.Reporters.HTML = (function(superClass) {
    extend(HTML, superClass);

    function HTML() {
      return HTML.__super__.constructor.apply(this, arguments);
    }

    HTML.prototype.readConfig = function() {
      HTML.__super__.readConfig.apply(this, arguments);
      return jasmine.CATCH_EXCEPTIONS = this.config["use-catch"];
    };

    HTML.prototype.envInfo = function() {
      var ver, verString;
      ver = jasmine.getEnv().version();
      verString = [ver.major, ver.minor, ver.build].join(".");
      return "jasmine " + verString + " revision " + ver.revision;
    };

    return HTML;

  })(Teaspoon.Reporters.HTML);

}).call(this);
