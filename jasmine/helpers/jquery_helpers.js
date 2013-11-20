/*
 designed to be loaded up by Jasmine
 stick me in your spec/javascript/helpers/
*/

var _$ = function _$(_name, methods_schema, properties_schema) {
  /*
    mock a jQuery object with Jasmine spies
    depends on jQuery as $()
    check out test suite for example usage

    parameters:
    1) name of your spy (currently unused)
    2) object describing the methods to spy on:
       * keys are names of methods
       * values are what should be returned by the spied upon message;
         * use null as value to get the mocked jQuery object back (i.e. chaining)
         * use a function as value to have it called via .andCallFake()
         * use another _$() as value to mimic traversing (e.g. .find('.children') when selector doesn't matter to the test)
    3) object describing properties the spy should have [optional]:
       * keys are names of properties
       * values are property values
       * default: { length: true }
  */
  var mock_obj = {
    length: true,
    __is_br_mock__: true // minor violation of our little api but that's what the underscores are for
  };
  for (var method_name in methods_schema) {
    if (!methods_schema.hasOwnProperty(method_name)) {
      continue;
    }
    var method_mapping = methods_schema[method_name];

    mock_obj[method_name] = jasmine.createSpy(method_name);

    if (method_mapping === null) {
      mock_obj[method_name].andReturn(mock_obj);
    } else if (typeof method_mapping === 'function') {
      mock_obj[method_name].andCallFake(method_mapping);
    } else {
      mock_obj[method_name].andReturn(method_mapping);
    }
  }
  for (var property_name in properties_schema) {
    if (!properties_schema.hasOwnProperty(property_name)) {
      continue;
    }
    mock_obj[property_name] = properties_schema[property_name];
  }
  return mock_obj;
};
jasmine.getGlobal()['_$'] = _$;

var stub_$init = function stub_$init(stub_schema) {
  /*
    convenience function for stubbing jQuery.fn.init by mapping selectors to return values
    depends on _$()

    parameters:
    1) object describing the selectors to respond to, and the properties of the _$() objects that should be returned
       * passed straight to _$(), so key/value definitions are same as second parameter there

    todo:
    * kinda ugly: need to handle $(window) by saving schema to variable and assigning index, e.g.:
      var schema = { 'selector':{data:1} };
      schema[window] = {scroll:null};
      stub_$init(schema);
    * idempotence (to allow calls in nested describe()s)
  */

  spyOn($.fn, 'init').andCallFake(function(selector_init) {
    if (stub_schema.hasOwnProperty(selector_init)) {
      if (stub_schema[selector_init].__is_br_mock__) {
        return stub_schema[selector_init];
      }
      return _$('mocked: ' + selector_init, stub_schema[selector_init]);
    } else if (selector_init == '#jasmine-fixtures') {
      return _$('mocked #jasmine-fixtures', {remove: undefined});
    }
    return _$('default mocked jQuery selector');
  });
};
jasmine.getGlobal()['stub_$init'] = stub_$init;

describe('Jasmine helpers', function() {
  describe('_$()', function() {

    describe('method definitions', function() {

      it('should return a passed value', function() {
        var _$mock = _$('obj', {
          text: 'foo'
        });
        var result = _$mock.text();

        expect(result).toEqual('foo');
        expect(_$mock.text).toHaveBeenCalled();
      });

      it('should call a passed function', function() {
        var return_bar = function() {
          return 'bar';
        };
        var _$mock = _$('obj', {
          foo: return_bar
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
        var return_bar = function() {
          return 'bar';
        };
        var _$mock = _$('obj', {
          show: null,
          text: 'foo',
          each: return_bar
        });

        _$mock.show();

        expect(_$mock.show).toHaveBeenCalled();
        expect(_$mock.text()).toEqual('foo');
        expect(_$mock.each()).toEqual('bar');
      });

      it('should allow nesting', function() {
        var _$child = _$('span', { show: null });
        var _$parent = _$('div', { find: _$child });

        _$parent.find('foo').show();

        expect(_$child.show).toHaveBeenCalled();
      });

      xit('respects own properties', function() {
        // todo - hasOwnProperty()
      })

    });

    describe('property definitions', function() {

      it('should default to .length == true (plus mock flag)', function() {
        var _$mock_obj = _$('foo');

        var keys = [], values = [];
        for (var key in _$mock_obj) {
          if (_$mock_obj.hasOwnProperty(key)) {
            keys.push(key);
            values.push(_$mock_obj[key]);
          }
        }

        expect(keys).toEqual(['length', '__is_br_mock__']);
        expect(values).toEqual([true, true]);
      });

      it('should return passed values', function() {
        var _$mock_obj = _$('foo', {}, {bar: 'baz'});

        expect(_$mock_obj).toHaveOwnProperty('bar');
        expect(_$mock_obj.bar).toEqual('baz');
      });

      it('should allow .length == false', function() {
        var _$mock_obj = _$('foo', {}, {length: 0});

        expect(_$mock_obj.length).toEqual(0);
      });

    });
  });

  describe('stub_$init()', function() {
    it('should spy on $.fn.init', function() {
      spyOn(window, 'spyOn').andCallThrough();

      stub_$init({foo: 'bar'});

      expect(window.spyOn).toHaveBeenCalledWith($.fn, 'init');
    });
    it('should accept schema mapping selectors to _$() method schemas', function() {
      stub_$init({ 'some selector': {baz: 'qux'} });

      expect($('some selector').baz()).toEqual('qux');
    });
    it('should automatically handle #jasmine-fixtures', function() {
      stub_$init({});

      expect($('#jasmine-fixtures')).toBeTruthy();
    });
    it('should have a default', function() {
      stub_$init({});

      expect($('foo')).toBeTruthy();
    });
  });
});
