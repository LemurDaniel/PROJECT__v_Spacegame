module main

import math


struct Vector {
mut: 
	x	int
	y 	int
}

fn (mut vector Vector) round() {

}

fn (mut vector Vector) mag() f64 {
	return math.sqrt(vector.x * vector.x + vector.y * vector.y)
}

fn (mut vector Vector) dist(vector2 Vector) f64 {
	x := vector.x - vector2.x
	y := vector.y - vector2.y
	return math.sqrt(x * x + y * y)
}

fn (mut vector Vector) sub(vector2 Vector) Vector {
	vector.x -= vector2.x
	vector.y -= vector2.y
	return vector
}

fn (mut vector Vector) add(vector2 Vector) Vector {
	vector.x += vector2.x
	vector.y += vector2.y
	return vector
}

fn (mut vector Vector) mul(vector2 Vector) Vector {
	vector.x *= vector2.x
	vector.y *= vector2.y
	return vector
}

/*
    _round() {}

    copy() {}

    limit(limit) {}

    setMag(mag) {
        const angle = this.heading();
        this.x = Math.cos(angle) * mag;
        this.y = Math.sin(angle) * mag;
        this._round();
        return this;
    }

    heading() {
        const TAU = Math.PI * 2;

        if (this.x === 0)
            return this.y > 0 ? (Math.PI / 2) : (Math.PI * 3 / 2);

        if (this.x > 0)
            return (TAU + Math.atan(this.y / this.x)) % TAU;

        if (this.x < 0)
            return Math.PI + Math.atan(this.y / this.x);

    }

    add(vec) {}


    mul(vec, m) {}
*/