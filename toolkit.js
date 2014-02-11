/*
 Array#unique
 */
Array.prototype.unique = function() {
  return this.reduce(function(uniques, current_val) {
    if (uniques.indexOf(current_val) < 0) {
      uniques.push(current_val);
    }
    return uniques;
  }, []);
};

/*
 Array#times_do
 returns an array of n results of calling a callback
 sorta like ruby's Array.new(n) { 'val' } but without the |index|

 ex:
 arr = [5].times_do(function(){ return 'default value';});
 */
Array.prototype.times_do = function(callback) {
  return Array.apply(null, Array(this[0])).map(callback); // todo - add i param to callback
};

/*
  Array#random
 */
Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ];
};

/*
  Object#tap
  like ruby's
*/
Object.prototype.tap = function(cb) {
  cb(this);
  return this;
}

/*
  i forget what this was for
*/
Object.prototype.try = function(code_str) {
  return eval(code_str);
};

/*
  String#repeat
  'foo'.repeat(2) == 'foofoo'

  from http://jsperf.com/faster-string-repeat/12
  */
String.prototype.repeat = function(count) {
  if (count < 1) {
    return '';
  }
  var result = '',
    pattern = this.valueOf();
  while (count > 0) {
    if (count & 1) {
      result += pattern;
    }
    count >>= 1;
    pattern += pattern;
  }
  return result;
};
