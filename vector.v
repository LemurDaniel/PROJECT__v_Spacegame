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

fn (mut vector Vector) heading() f64 {
    tau := math.tau * 2

    if vector.x == 0 && vector.y > 0 {
        return math.pi / 2
    }
    if vector.x == 0 && vector.y <= 0 {
        return math.pi * 3 / 2
    }
    if vector.x > 0 {
        return math.fmod(tau + math.atan(vector.y / vector.x), tau)
    }
    if vector.x < 0 {
        return math.pi + math.atan(vector.y / vector.x)
    }

    return -1.0
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



    add(vec) {}


    mul(vec, m) {}
*/