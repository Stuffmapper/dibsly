(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Teaspoon.Reporters.Console = (function(superClass) {
    extend(Console, superClass);

    function Console(runner) {
      this.reportSpecResults = bind(this.reportSpecResults, this);
      Console.__super__.constructor.apply(this, arguments);
      this.reportRunnerStarting(runner);
      runner.on("fail", this.reportSpecResults);
      runner.on("test end", this.reportSpecResults);
      runner.on("end", this.reportRunnerResults);
    }

    Console.prototype.reportSpecResults = function(spec, err) {
      if (err) {
        spec.err = err;
        if (spec.type === "hook") {
          this.reportSpecResults(spec);
        }
        return;
      }
      return Console.__super__.reportSpecResults.apply(this, arguments);
    };

    return Console;

  })(Teaspoon.Reporters.Console);

}).call(this);
