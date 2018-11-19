function calculateParentPointer(index) {
  return Math.floor(index + 1 / 2);
}

function Heap() {
  // NB: root is smaller than leaves
  this.array = [];
}

Heap.prototype.add = function(val) {
  if (val.length > 1) {
    return val.forEach
      ? val.forEach(this.add.bind(this))
      : val.split("").forEach(this.add.bind(this));
  }
  const newIndex = this.array.push(val) - 1;
  if (newIndex !== 0) {
    // weird math cause pointers !== indices
    const parentIndex = calculateParentPointer(newIndex) - 1;
    const comparison = this.compare(newIndex, parentIndex);
    this.recursivelyCompareAndSwap(newIndex, parentIndex);
  }
  this.log();
}

Heap.prototype.balance = function(index) {
  const rootPointer = index + 1;
  const leftPointer = rootPointer * 2,
    leftIndex = leftPointer - 1,
    rightPointer = leftPointer + 1,
    rightIndex = rightPointer - 1;
  const values = {
    root: this.array[index],
    left: this.array[leftIndex],
    right: this.array[rightIndex]
  };
  if (typeof values.left === "undefined") {
    this.log();
    return;
  }
  console.log(`Balancing at index:${index}`, values);
  const leftComparison = this.compare(index, leftIndex),
    rightComparison = this.compare(index, rightIndex);
  if (leftComparison < 0 && rightComparison < 0) { // happy path
    console.log("root is the smallest! done here...");
    return;
  }
  if (leftComparison > 0 && rightComparison > 0) { // pathological case
    const leavesComparison = this.compare(leftPointer - 1, rightPointer - 1);
    if (leavesComparison < 0) {
      console.log("left!");
      // left should be root; swap
      this.array[index] = values.left;
      this.array[leftIndex] = values.root;
      // recur with the new left leaf
      return this.balance(leftIndex)
    }
    console.log("right");
    // right should be root (TODO or they're equal?!?); swap...
    this.array[index] = values.right;
    this.array[rightIndex] = values.root;
    // recur with new right leaf
    return this.balance(rightIndex);
  }
  if (leftComparison > 0) {
    console.log("left!");
    // left should be root; swap
    this.array[index] = values.left;
    this.array[leftIndex] = values.root;
    // recur with the new left leaf
    return this.balance(leftIndex)
  }
  if (rightComparison > 0) {
    console.log("right now.......");
    // right should be root; swap...
    this.array[index] = values.right;
    this.array[rightIndex] = values.root;
    // recur with new right leaf
    return this.balance(rightIndex);
  }
  console.log("ruh roh!!!!!!!!!!!!!! something equal?", leftComparison, rightComparison);
}

Heap.prototype.compare = function(aIndex, bIndex) {
  const a = this.array[aIndex],
    b = this.array[bIndex];
  return a === b
    ? 0
    : a < b
    ? -1
    : 1;
}

Heap.prototype.log = function() { console.log(` ➔ ${this.toString()}`); }

Heap.prototype.logTree = function() {
  console.log(this.array.reduce(function(string, element, index) {
    const row = Math.log2(index + 1);
    if (row === Math.floor(row)) {
      return `${string}\n${element}`;
    }
    return `${string}  ${element}`;
  }, ""));
}

Heap.prototype.popMinimum = function() {
  const root = this.array[0];
  this.array[0] = this.array.pop();
  this.balance(0);
  return root;
}

Heap.prototype.recursivelyCompareAndSwap = function(index, parentIndex) { // returns the number of comparisons made
  if (this.compare(index, parentIndex) < 0) {
    // swap values...
    const val = this.array[index];
    this.array[index] = this.array[parentIndex];
    this.array[parentIndex] = val;
    //  then identify the grandparent & recur
    return 1 + this.recursivelyCompareAndSwap(parentIndex, calculateParentPointer(parentIndex) - 1);
  }
  return 1; // base case does one comparison
}

Heap.prototype.toString = function() {
  return this.array.toString();
}

global.Heap = Heap;
