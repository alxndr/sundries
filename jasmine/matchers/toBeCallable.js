beforeEach(function() {
  this.addMatchers({
    toBeCallable: function() {
      return typeof this.actual === 'function';
    }
  });
});

describe('Jasmine matchers', function() {
  describe('toBeCallable', function() {
    describe('for a function', function() {
      it('should be true', function() {
        expect(function(){}).toBeCallable();
        expect(expect).toBeCallable();
      });
    });
    describe('for other things', function() {
      it('should be false', function() {
        expect().not.toBeCallable();
        expect(null).not.toBeCallable();
        expect(undefined).not.toBeCallable();
        expect(1).not.toBeCallable();
        expect(1/0).not.toBeCallable();
        expect('').not.toBeCallable();
        expect('foo').not.toBeCallable();
        expect(this).not.toBeCallable();
        expect(window).not.toBeCallable();
      });
    });
  });
});
