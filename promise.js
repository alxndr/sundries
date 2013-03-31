var Promise = {

  // Usage:
  //
  // promise = Object.create(Promise).new() \
  //   .fill( 'anything', {goes:'here'} ) \
  //   .bind( function(a){ console.log(a) } ) \
  //   .fill( 'fulfill with new data' );
  //
  // Can also add data and/or callback during initialization:
  //
  // promise = Object.create(Promise).new({
  //   data: ['anything else'], // an array of the arguments you'd pass to promise.fill()
  //   callback: function(a){ console.log(a) }
  // })
  //

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
    this._data = Array.prototype.slice.call(arguments); // coerce arguments to a Real Array
    // this._data = arguments // would rather do this though, and this.callback.call(this,this.data) or something
    this._tick();
    return this;
  },
  empty: function() {
    this._data = null;
    return this; // don't need to tick
  },

  // "private"

  _tick: function() {
    // console.warn('tick');
    if (this._data && this._callback) {
      // would rather not map
      // we should only call callback once and pass in that arguments object
      var callback = this._callback;
      // console.warn('wanna call',callback,'with',this._data);
      this._data.map(function(data) {
        console.warn('actually calling',callback,'with',data);
        callback.call(this._initial_this,data);
      });
    }
    return this;
  },

  // storage

  _data: null,
  _callback: null,

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

  _bind_valid: function(cb) {
    return typeof cb === 'function';
  }

}
