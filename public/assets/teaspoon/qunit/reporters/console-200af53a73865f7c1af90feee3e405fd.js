(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Teaspoon.Reporters.Console = (function(superClass) {
    extend(Console, superClass);

    function Console(env) {
      this.reportSpecResults = bind(this.reportSpecResults, this);
      Console.__super__.constructor.apply(this, arguments);
      env.log(this.reportSpecResults);
      env.testDone(this.reportSpecResults);
      env.done(this.reportRunnerResults);
      this.reportRunnerStarting();
    }

    Console.prototype.reportRunnerStarting = function() {
      this.currentAssertions = [];
      return this.log({
        type: "runner",
        total: null,
        start: JSON.parse(JSON.stringify(this.start))
      });
    };

    Console.prototype.reportSpecResults = function(result) {
      if (typeof result.total !== "number") {
        this.currentAssertions.push(result);
        return;
      }
      result.assertions = this.currentAssertions;
      this.currentAssertions = [];
      return Console.__super__.reportSpecResults.call(this, result);
    };

    return Console;

  })(Teaspoon.Reporters.Console);

}).call(this);
