beforeEach(function() {
  this.addMatchers({
    toHaveBeenConfiguredWith: function(config_key, config_value) {
      // todo - refactor this into being a helper property on the spy itself, so all matchers can be used on values directly
      if (!(this.actual.mostRecentCall && this.actual.mostRecentCall.args && this.actual.mostRecentCall.args[0])) {
        this.message = function() {
          return [
            'The .toHaveBeenConfiguredWith() matcher should be invoked on a spy, but ' + jasmine.pp(this.actual.identity) + ' does not appear to be a spy.',
            'The .toHaveBeenConfiguredWith() matcher should be invoked on a spy, but ' + jasmine.pp(this.actual.identity) + ' does not appear to be a spy.'
          ];
        };
        return false;
      }

      var config_object = this.actual.mostRecentCall.args[0];
      this.message = function(expected_key, expected_value) {
        var normal_message = 'Expected spy '
          + jasmine.pp(this.actual.identity)
          + ' to have been configured with '
          + jasmine.pp(expected_key)
          + ' = '
          + jasmine.pp(expected_value)
          + ' but was configured with specified key '
          + jasmine.pp(expected_key)
          + ' = '
          + jasmine.pp(config_object[expected_key]);
        var not_message = normal_message.replace(' to have been configured with ', ' not to have been configured with ');

        return [normal_message, not_message];
      };
      return config_object.hasOwnProperty(config_key) && ( (typeof config_value.jasmineMatches == 'function' && config_value.jasmineMatches(config_object[config_key])) || config_object[config_key] == config_value);
    }
  });
});

describe('matchers', function() {
  describe('toHaveBeenConfiguredWith', function() {
    describe('when called on a spy', function() {
      beforeEach(function() {
        spy = jasmine.createSpy('spy', ['a_method']);
      });
      it('should match keys on object passed to spy', function() {
        spy({ foo: 'bar' });
        expect(spy).toHaveBeenConfiguredWith('foo', 'bar');
        expect(spy).not.toHaveBeenConfiguredWith('foo', 'qux');
        expect(spy).not.toHaveBeenConfiguredWith('baz', 'bar');
      });
      it('should work with jasmine.any', function() {
        spy({ amount: 13, callback: function(){} });
        expect(spy).toHaveBeenConfiguredWith('amount', jasmine.any(Number));
        expect(spy).toHaveBeenConfiguredWith('callback', jasmine.any(Function));
      });
    });
    describe('when not called on a spy', function() {
      it('should be false', function() {
        expect(13).not.toHaveBeenConfiguredWith(13);
      });
    });
  });
});
