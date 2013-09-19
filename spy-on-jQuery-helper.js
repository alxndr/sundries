/*
  mock a jQuery object with Jasmine spies

  because it should be a little more straightforward

  designed to be loaded up by Jasmine
  stick me in your spec/javascript/helpers/
  comment out the test suite (the describe() chunk) if you want

  parameters:

    1) name of your spy (gets passed straight to jasmine.createSpyObj() )
    2) object describing the methods to spy on:
       * keys are names of methods
       * values are what should be returned by the spied upon message;
         * use null as value to get the mocked jQuery object back (i.e. chaining)
         * use a function as value to have it called via .andCallFake()
         * use another _$() as value to mimic traversing (e.g. .find('.children') when selector doesn't matter to the test)

  check out test suite for example usage
*/

function _$(name, methods_schema) {
  var $spy_obj = jasmine.createSpyObj(name, ['']);
  for (var key in methods_schema) {
    if (methods_schema.hasOwnProperty(key)) {
      var return_val = methods_schema[key];

      $spy_obj[key] = jasmine.createSpy(key);

      if (return_val === null) {
        $spy_obj[key].andReturn($spy_obj);
      } else if (typeof return_val === 'function') {
        $spy_obj[key].andCallFake(return_val);
      } else {
        $spy_obj[key].andReturn(return_val);
      }
    }
  }
  return $spy_obj;
}

describe('Jasmine helpers', function() {
  describe('_$()', function() {

    it('should return a spy object', function() {
      spyOn(jasmine, 'createSpyObj');

      _$('obj');

      expect(jasmine.createSpyObj).toHaveBeenCalled();
    });

    describe('method definitions', function() {

      it('should return a passed value', function() {
        var _$mock = _$('obj', {
          text: 'foo'
        });

        expect(_$mock.text()).toEqual('foo');
        expect(_$mock.text).toHaveBeenCalled();
      });

      it('should call a passed function', function() {
        var _$mock = _$('obj', {
          foo: function() { return 'bar'; }
        });

        expect(_$mock.foo()).toEqual('bar');
      });

      it('should return self when passed null', function() {
        var _$mock = _$('obj', {
          show: null,
          hide: null
        });

        expect(_$mock.show().hide()).toEqual(_$mock);
        expect(_$mock.show).toHaveBeenCalled();
        expect(_$mock.hide).toHaveBeenCalled();
      });

      it('should permit a mixture of method definitions', function() {
        var _$mock = _$('obj', {
          show: null,
          text: 'foo',
          each: function(){ return 'bar'; }
        });

        _$mock.show();

        expect(_$mock.show).toHaveBeenCalled();
        expect(_$mock.text()).toEqual('foo');
        expect(_$mock.each()).toEqual('bar');
      });

      it('should allow nesting', function() {
        var _$child = _$('span', {
          show: null
        });
        var _$parent = _$('div', {
          find: _$child
        });

        _$parent.find('foo').show();

        expect(_$child.show).toHaveBeenCalled();
      });

    });

  });
});
