beforeEach(function() {
  this.addMatchers({
    toHaveOwnProperty: function(property_name) {
      return this.actual.hasOwnProperty(property_name);
    }
  });
});

describe('Jasmine matchers', function() {
  describe('toHaveOwnProperty', function() {
    it('should look at hasOwnProperty', function() {
      var obj = { foo: 'bar', baz: function (){} };

      expect(obj).toHaveOwnProperty('foo');
      expect(obj).toHaveOwnProperty('baz');
      expect(obj).not.toHaveOwnProperty('bar');
      expect(obj).not.toHaveOwnProperty('qux');
    });
  });
});

