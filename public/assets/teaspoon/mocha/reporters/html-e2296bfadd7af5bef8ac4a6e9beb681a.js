(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Teaspoon.Reporters.HTML = (function(superClass) {
    extend(HTML, superClass);

    function HTML(runner) {
      this.reportSpecResults = bind(this.reportSpecResults, this);
      HTML.__super__.constructor.apply(this, arguments);
      this.reportRunnerStarting(runner);
      runner.on("fail", this.reportSpecResults);
      runner.on("test end", this.reportSpecResults);
      runner.on("end", this.reportRunnerResults);
    }

    HTML.prototype.reportSpecResults = function(spec, err) {
      if (err) {
        spec.err = err;
        if (spec.type === "hook") {
          this.reportSpecResults(spec);
        }
        return;
      }
      this.reportSpecStarting(spec);
      return HTML.__super__.reportSpecResults.apply(this, arguments);
    };

    HTML.prototype.envInfo = function() {
      return "mocha " + (_mocha_version || "[unknown version]");
    };

    return HTML;

  })(Teaspoon.Reporters.HTML);

  Teaspoon.Reporters.HTML.SpecView = (function(superClass) {
    extend(SpecView, superClass);

    function SpecView() {
      return SpecView.__super__.constructor.apply(this, arguments);
    }

    SpecView.prototype.updateState = function(state) {
      return SpecView.__super__.updateState.call(this, state, this.spec.spec.duration);
    };

    return SpecView;

  })(Teaspoon.Reporters.HTML.SpecView);

}).call(this);
