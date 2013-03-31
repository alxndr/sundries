var Promise = {

  /* 

    Usage:

      promise = Object.create(Promise).new() \
        .fill( 'anything', {goes:'here'} ) \
        .bind( function(a){ console.log(a) } ) \
        .fill( 'then fulfill with new data' );
    
    Can also add data and/or callback during initialization:
    
      promise = Object.create(Promise).new({
        data: ['anything else'], // an array of the arguments you'd pass to promise.fill()
        callback: function(a){ console.log(a) }
      })
  */

  new: function(opts) {
    this._initial_this = window.top;
    if (opts && (opts.data || opts.callback)) {
      opts.data     && this._add_data(opts.data);
      opts.callback && this._bind_valid(opts.callback) && this._add_callback(opts.callback);
      this._tick();
    }
    return this;
  },

  bind: function(callback) {
    if (this._bind_valid(callback)) {
      this._add_callback(callback);
      this._tick();
    }
    return this;
  },
  unbind: function() {
    this._callback = null;
    return this; // don't need to tick
  },

  fill: function() {
    this._data = arguments
    this._tick();
    return this;
  },
  empty: function() {
    this._data = null;
    return this; // don't need to tick
  },

  // "private"

  _tick: function() {
    if (this._data && this._callback) {
      this._retval = this._callback(this._data);
    }
    return this;
  },

  // storage

  // _data: null,             // added with .fill()
  // _callback: null,         // added with .bind()
  // _retval: null,           // return value of callback when ran in _tick()
  // _invalid_callback: null, // most recent non-function passed to .bind()

  // setters
  
  _add_callback: function(callback) {
    this._callback = callback;
    return this;
  },
  _add_data: function(data) {
    this._data = data;
    return this;
  },

  // validation

  _bind_valid: function(callback) {
    var valid = typeof callback === 'function';
    if (!valid) {
      this._invalid_callback = callback;
      console.error('invalid callback',callback);
    }
    return valid;
  }

}
