function spy_on_instance_method(constructor, method_name, retval) {
  constructor.prototype[method_name] = jasmine.createSpy();
  if (retval && typeof(retval) === 'function') {
    constructor.prototype[method_name].andCallFake(retval);
  } else {
    //constructor.prototype[method_name].andReturn(retval);
  }
}

var jasmine_scope = jasmine.getGlobal();
if (jasmine_scope) {
  jasmine_scope.spy_on_instance_method = spy_on_instance_method;
}

describe('spy_on_instance_method()', function() {
  var Namespace;

  beforeEach(function() {
    Namespace = {
      Constructor: function() {
        this.value = 'foo';
      }
    };
  });

  afterEach(function() {
    delete Namespace;
  });

  describe('when no return value is specified', function() {
    it('should spy on method name', function() {
      spyOn(jasmine, 'createSpy').andReturn('spy!');

      spy_on_instance_method(Namespace.Constructor, 'method');

      expect(jasmine.createSpy).toHaveBeenCalled();
      expect(new Namespace.Constructor().method).toEqual('spy!');
    });
  });
  describe('when callback', function() {
    it('should spy on method name and call callback', function() {
      spy_on_instance_method(Namespace.Constructor, 'method', function() { return 'foo'; });

      expect(new Namespace.Constructor().method()).toEqual('foo');
    });
  });
  describe('when value', function() {
    it('should spy on method name and return the value', function() {
      spy_on_instance_method(Namespace.Constructor, 'method', 'bar');

      //expect(new Namespace.Constructor().method()).toEqual('bar');
    });
  });
});
