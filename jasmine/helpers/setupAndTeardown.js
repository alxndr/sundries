jasmine.getGlobal()['setupAndTeardown'] = function setupAndTeardown(obj, name, value) {
  /*
    convenience function for creating a namespaced object before an example or suite, and removing it afterwards

    parameters:
    1) (object) namespace object, e.g. window.console
    2) (string) name of object to attach to namespace object, e.g. 'log'
    3) (any) rvalue of new namespaced object, e.g. function(){}

    todo:
    * make usable in top-level describe() block
  */

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

