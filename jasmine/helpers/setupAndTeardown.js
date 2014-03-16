function setupAndTeardown(obj, name, value) {
  /*
    convenience function for creating a namespaced object before an example or suite, and removing it afterwards

    parameters:
    1) (object) namespace object, e.g. namespace.console
    2) (string) name of object to attach to namespace object, e.g. 'log'
    3) (any) rvalue of new namespaced object, e.g. function(){}
  */
  beforeEach(function() {
    obj[name] = value;
  });
  afterEach(function() {
    delete(obj[name]);
  });
}

var jasmine_scope = jasmine.getGlobal();
if (jasmine_scope) {
  jasmine_scope.setupAndTeardown = setupAndTeardown;
}

var namespace = {};
describe('setupAndTeardown()', function() {

  setupAndTeardown(namespace, 'top_level', 'working');

  it('in the top level describe should work', function() {
    expect(namespace.hasOwnProperty('top_level')).toBeTruthy();
    expect(namespace.top_level).toEqual('working');
  });

  it('should not assign before the block', function() {
    expect(namespace.hasOwnProperty('foo')).toBeFalsy();
  });

  describe('within a block', function() {

    it('should exist', function() {
      expect(setupAndTeardown).toBeDefined();
    });

    setupAndTeardown(namespace, 'foo', 'bar');

    it('should assign 3rd param to value of property named 2nd param of object passed as 1st param', function() {
      expect(namespace.foo).toEqual('bar');
    });

  });

  it('should not assign after the block', function() {
    expect(namespace.hasOwnProperty('foo')).toBeFalsy();
  });

});

