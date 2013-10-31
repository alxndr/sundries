jasmine.getGlobal()['setupAndTeardown'] = function setupAndTeardown(obj, name, value) {
  beforeEach(function() {
    obj[name] = value;
  });
  afterEach(function() {
    delete(obj[name]);
  });
};

describe('setupAndTeardown()', function() {
  it('should not assign before the block', function() {
    expect(window.testObject.hasOwnProperty('foo')).toBeFalsy();
  });
  describe('within a block', function() {

    it('should exist', function() {
      expect(setupAndTeardown).toBeDefined();
    });

    window.testObject = {};
    setupAndTeardown(window.testObject, 'foo', 'bar');

    beforeEach(function() {
      expect(window.testObject.foo).toEqual('bar');
    });
    it('should assign 3rd param to value of property named 2nd param of object passed as 1st param', function() {
      expect(window.testObject.foo).toEqual('bar');
    });
    afterEach(function() {
      expect(window.testObject.foo).toEqual('bar');
    });
  });
  it('should not assign after the block', function() {
    expect(window.testObject.hasOwnProperty('foo')).toBeFalsy();
  });
});

