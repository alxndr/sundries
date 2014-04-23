function spy_on_object(namespace, constructor_name) {
  var spy;
  function stub(method_name, return_value) {
    spy[method_name] = jasmine.createSpy(method_name).andReturn(return_value);
  }

  spy = jasmine.createSpyObj('spy instance: ' + constructor_name, new Array(1));
  spyOn(namespace, constructor_name).andReturn(spy);

  return { stub: stub, instance: spy };
}

var jasmine_scope = jasmine.getGlobal();
if (jasmine_scope) {
  jasmine_scope.setupAndTeardown = setupAndTeardown;
}

describe('spy_on_object()', function() {
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

  describe('usage', function() {
    beforeEach(function() {
      expect(Namespace.Constructor.isSpy).toBeFalsy();
    });

    it('should spy on named constructor function in the namespace', function() {
      expect(Namespace.Constructor.isSpy).toBeFalsy();
      expect(Namespace.Constructor).toBeCallable();

      spy_on_object(Namespace, 'Constructor');

      new Namespace.Constructor();

      expect(Namespace.Constructor.isSpy).toBeTruthy();
      expect(Namespace.Constructor).toHaveBeenCalled();
    });

    it('should spy on stubs', function() {
      spy_on_object(Namespace, 'Constructor').stub('foo');

      var spy_instance = new Namespace.Constructor();
      spy_instance.foo();

      expect(spy_instance.foo).toHaveBeenCalled();
    });

    it('should return custom val from stubs', function() {
      spy_on_object(Namespace, 'Constructor').stub('foo', 'bar');

      var spy_instance = new Namespace.Constructor();

      expect(spy_instance.foo()).toEqual('bar');
    });

    it('should handle multiple stubs', function() {
      var spy_Constructor = spy_on_object(Namespace, 'Constructor');
      spy_Constructor.stub('foo', 'bar');
      spy_Constructor.stub('baz', {q: 'qux', t: 'tux'});

      var spy_instance = new Namespace.Constructor();

      expect(spy_instance.foo()).toEqual('bar');
      expect(spy_instance.baz()).toEqual({q: 'qux', t: 'tux'});
    });
  });

  describe('"API"', function() {
    it('should expose .stub()', function() {
      var spy_Constructor = spy_on_object(Namespace, 'Constructor');

      expect(spy_Constructor.stub).toBeCallable();
    });
    it('should expose .instance', function() {
      var spy_Constructor = spy_on_object(Namespace, 'Constructor');

      expect(spy_Constructor.instance).toBeTruthy();
    });
    describe('.instance', function() {
      it('should expose stubbed instance methods', function() {
        var spy_Constructor = spy_on_object(Namespace, 'Constructor');
        spy_Constructor.stub('foo');

        new Namespace.Constructor();

        expect(spy_Constructor.instance.foo).toBeCallable();
      });
      it('should spy on stubbed instance methods', function() {
        var spy_Constructor = spy_on_object(Namespace, 'Constructor');
        spy_Constructor.stub('foo', 'bar');

        expect(spy_Constructor.instance.foo).not.toHaveBeenCalled();

        new Namespace.Constructor().foo('baz');

        expect(spy_Constructor.instance.foo).toHaveBeenCalledWith('baz');
      });
    });
  });
});
